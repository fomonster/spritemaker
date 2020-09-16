{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2003 by the Free Pascal development team

    XPM writer class.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$mode objfpc}{$h+}
unit ssFPWritePNG;

interface

uses sysutils, classes, FPImage, FPImgCmn, PNGComn, ZStream;

type

  TGetPixelFunc = function (x,y : LongWord) : TColorData of object;

  TColorFormatFunction = function (color:TFPColor) : TColorData of object;

  TSSFPWriterPNG = class (TFPCustomImageWriter)
    private
      FUsetRNS, FCompressedText, FWordSized, FIndexed,
      FUseAlpha, FGrayScale : boolean;
      FByteWidth : byte;
      FChunk : TChunk;
      CFmt : TColorFormat; // format of the colors to convert from
      FFmtColor : TColorFormatFunction;
      FTransparentColor : TFPColor;
      FSwitchLine, FCurrentLine, FPreviousLine : pByteArray;
      FPalette : TFPPalette;
      FHeader : THeaderChunk;
      FGetPixel : TGetPixelFunc;
      FDatalineLength : longword;
      ZData : TMemoryStream;  // holds uncompressed data until all blocks are written
      Compressor : TCompressionStream; // compresses the data
      procedure WriteChunk;
      function GetColorPixel (x,y:longword) : TColorData;
      function GetPalettePixel (x,y:longword) : TColorData;
      function GetColPalPixel (x,y:longword) : TColorData;
      procedure InitWriteIDAT;
      procedure Gatherdata;
      procedure WriteCompressedData;
      procedure FinalWriteIDAT;
    protected
      property Header : THeaderChunk read FHeader;
      procedure InternalWrite (Str:TStream; Img:TFPCustomImage); override;
      procedure WriteIHDR; virtual;
      procedure WritePLTE; virtual;
      procedure WritetRNS; virtual;
      procedure WriteIDAT; virtual;
      procedure WriteTexts; virtual;
      procedure WriteIEND; virtual;
      function CurrentLine (x:longword) : byte;
      function PrevSample (x:longword): byte;
      function PreviousLine (x:longword) : byte;
      function PrevLinePrevSample (x:longword): byte;
      function  DoFilter (LineFilter:byte;index:longword; b:byte) : byte; virtual;
      procedure SetChunkLength (aValue : longword);
      procedure SetChunkType (ct : TChunkTypes);
      procedure SetChunkType (ct : TChunkCode);
      function DecideGetPixel : TGetPixelFunc; virtual;
      procedure DetermineHeader (var AHeader : THeaderChunk); virtual;
      function DetermineFilter (Current, Previous:PByteArray; linelength:longword):byte; virtual;
      procedure FillScanLine (y : integer; ScanLine : pByteArray); virtual;
      function ColorDataGrayB(color:TFPColor) : TColorData;
      function ColorDataColorB(color:TFPColor) : TColorData;
      function ColorDataGrayW(color:TFPColor) : TColorData;
      function ColorDataColorW(color:TFPColor) : TColorData;
      function ColorDataGrayAB(color:TFPColor) : TColorData;
      function ColorDataColorAB(color:TFPColor) : TColorData;
      function ColorDataGrayAW(color:TFPColor) : TColorData;
      function ColorDataColorAW(color:TFPColor) : TColorData;
      property ChunkDataBuffer : pByteArray read FChunk.data;
      property UsetRNS : boolean read FUsetRNS;
      property SingleTransparentColor : TFPColor read FTransparentColor;
      property ThePalette : TFPPalette read FPalette;
      property ColorFormat : TColorformat read CFmt;
      property ColorFormatFunc : TColorFormatFunction read FFmtColor;
      property byteWidth : byte read FByteWidth;
      property DatalineLength : longword read FDatalineLength;
    public
      constructor create; override;
      destructor destroy; override;
      property GrayScale : boolean read FGrayscale write FGrayScale;
      property Indexed : boolean read FIndexed write FIndexed;
      property CompressedText : boolean read FCompressedText write FCompressedText;
      property WordSized : boolean read FWordSized write FWordSized;
      property UseAlpha : boolean read FUseAlpha write FUseAlpha;
  end;

implementation

constructor TSSFPWriterPNG.create;
begin
  inherited;
  Fchunk.acapacity := 0;
  Fchunk.data := nil;
  FGrayScale := False;
  FIndexed := false;
  FCompressedText := True;
  FWordSized := True;
  FUseAlpha := true;
end;

destructor TSSFPWriterPNG.destroy;
begin
  with Fchunk do
    if acapacity > 0 then
      freemem (data);
  inherited;
end;

procedure TSSFPWriterPNG.WriteChunk;
var chead : TChunkHeader;
    c : longword;
begin
  with FChunk do
    begin
    {$IFDEF ENDIAN_LITTLE}
    chead.CLength := swap (alength);
    {$ELSE}
    chead.CLength := alength;
    {$ENDIF}
	if (ReadType = '') then
      if atype <> ctUnknown then
        chead.CType := ChunkTypes[aType]
      else
        raise PNGImageException.create ('Doesn''t have a chunktype to write')
    else
      chead.CType := ReadType;
    c := CalculateCRC (All1Bits, ReadType, sizeOf(ReadType));
    c := CalculateCRC (c, data^, alength);
    {$IFDEF ENDIAN_LITTLE}
    crc := swap(c xor All1Bits);
    {$ELSE}
    crc := c xor All1Bits;
    {$ENDIF}
    with TheStream do
      begin
      Write (chead, sizeof(chead));
      Write (data^[0], alength);
      Write (crc, sizeof(crc));
      end;
    end;
end;

procedure TSSFPWriterPNG.SetChunkLength(aValue : longword);
begin
  with Fchunk do
    begin
    alength := aValue;
    if aValue > acapacity then
      begin
      if acapacity > 0 then
        freemem (data);
      GetMem (data, alength);
      acapacity := alength;
      end;
    end;
end;

procedure TSSFPWriterPNG.SetChunkType (ct : TChunkTypes);
begin
  with Fchunk do
    begin
    aType := ct;
    ReadType := ChunkTypes[ct];
    end;
end;

procedure TSSFPWriterPNG.SetChunkType (ct : TChunkCode);
begin
  with FChunk do
    begin
    ReadType := ct;
    aType := low(TChunkTypes);
    while (aType < high(TChunkTypes)) and (ChunkTypes[aType] <> ct) do
      inc (aType);
    end;
end;

function TSSFPWriterPNG.CurrentLine(x:longword):byte;
begin
  result := FCurrentLine^[x];
end;

function TSSFPWriterPNG.PrevSample (x:longword): byte;
begin
  if x < byteWidth then
    result := 0
  else
    result := FCurrentLine^[x - bytewidth];
end;

function TSSFPWriterPNG.PreviousLine (x:longword) : byte;
begin
  result := FPreviousline^[x];
end;

function TSSFPWriterPNG.PrevLinePrevSample (x:longword): byte;
begin
  if x < byteWidth then
    result := 0
  else
    result := FPreviousLine^[x - bytewidth];
end;

function TSSFPWriterPNG.DoFilter(LineFilter:byte;index:longword; b:byte) : byte;
var diff : byte;
  procedure FilterSub;
  begin
    diff := PrevSample(index);
  end;
  procedure FilterUp;
  begin
    diff := PreviousLine(index);
  end;
  procedure FilterAverage;
  var l, p : word;
  begin
    l := PrevSample(index);
    p := PreviousLine(index);
    Diff := (l + p) div 2;
  end;
  procedure FilterPaeth;
  var dl, dp, dlp : word; // index for previous and distances for:
      l, p, lp : byte;  // r:predictor, Left, Previous, LeftPrevious
      r : integer;
  begin
    l := PrevSample(index);
    lp := PrevLinePrevSample(index);
    p := PreviousLine(index);
    r := l + p - lp;
    dl := abs (r - l);
    dlp := abs (r - lp);
    dp := abs (r - p);
    if (dl <= dp) and (dl <= dlp) then
      diff := l
    else if dp <= dlp then
      diff := p
    else
      diff := lp;
  end;
begin
  case LineFilter of
    0 : diff := 0;
    1 : FilterSub;
    2 : FilterUp;
    3 : FilterAverage;
    4 : FilterPaeth;
  end;
  if diff > b then
    result := (b + $100 - diff)
  else
    result := b - diff;
end;

procedure TSSFPWriterPNG.DetermineHeader (var AHeader : THeaderChunk);
var c : integer;

  function CountAlphas : integer;
  var none, half : boolean;
      x,y : longint;  // warning, checks on <0 !
      p : integer;
      c : TFPColor;
      a : word;
  begin
    half := false;
    none := false;
    with TheImage do
      if UsePalette then
        with Palette do
          begin
          p := count-1;
          FTransparentColor.alpha := alphaOpaque;
          while (p >= 0) do
            begin
            c := color[p];
            a := c.Alpha;
            if a = alphaTransparent then
              begin
              none := true;
              FTransparentColor := c;
              end
            else if a <> alphaOpaque then
              begin
              half := true;
              if FtransparentColor.alpha < a then
                FtransparentColor := c;
              end;
            dec (p);
            end;
          end
      else
        begin
        x := width-1;
        y := height-1;
        FTransparentColor.alpha := alphaOpaque;
        while (y >= 0) and not (half and none) do
          begin
          c := colors[x,y];
          a := c.Alpha;
          if a = alphaTransparent then
            begin
            none := true;
            FTransparentColor := c;
            end
          else if a <> alphaOpaque then
            begin
            half := true;
            if FtransparentColor.alpha < a then
              FtransparentColor := c;
            end;
          dec (x);
          if (x < 0) then
            begin
            dec (y);
            x := width-1;
            end;
          end;
        end;
      result := 1;
      if none then
        inc (result);
      if half then
        inc (result);
  end;
  procedure DetermineColorFormat;
  begin
    with AHeader do
      case colortype of
        0 : if FWordSized then
              begin
              FFmtColor := @ColorDataGrayW;
              FByteWidth := 2;
              //CFmt := cfGray16
              end
            else
              begin
              FFmtColor := @ColorDataGrayB;
              FByteWidth := 1;
              //CFmt := cfGray8;
              end;
        2 : if FWordSized then
              begin
              FFmtColor := @ColorDataColorW;
              FByteWidth := 6;
              //CFmt := cfBGR48
              end
            else
              begin
              FFmtColor := @ColorDataColorB;
              FByteWidth := 3;
              //CFmt := cfBGR24;
              end;
        4 : if FWordSized then
              begin
              FFmtColor := @ColorDataGrayAW;
              FByteWidth := 4;
              //CFmt := cfGrayA32
              end
            else
              begin
              FFmtColor := @ColorDataGrayAB;
              FByteWidth := 2;
              //CFmt := cfGrayA16;
              end;
        6 : if FWordSized then
              begin
              FFmtColor := @ColorDataColorAW;
              FByteWidth := 8;
              //CFmt := cfABGR64
              end
            else
              begin
              FFmtColor := @ColorDataColorAB;
              FByteWidth := 4;
              //CFmt := cfABGR32;
              end;
      end;
  end;
begin
  with AHeader do
    begin
    {$IFDEF ENDIAN_LITTLE}
    // problem: TheImage has integer width, PNG header longword width.
    //          Integer Swap can give negative value
    Width := swap (longword(TheImage.Width));
    height := swap (longword(TheImage.Height));
    {$ELSE}
    Width := TheImage.Width;
    height := TheImage.Height;
    {$ENDIF}
    if FUseAlpha then
      c := CountAlphas
    else
      c := 0;

    c := 3;

    if FIndexed then
      begin
      if TheImage.UsePalette then
        FPalette := TheImage.Palette
      else
        begin
        FPalette := TFPPalette.Create (16);
        FPalette.Build (TheImage);
        end;
      if ThePalette.count > 256 then
        raise PNGImageException.Create ('Too many colors to use indexed PNG color type');
      ColorType := 3;
      FUsetRNS := C > 1;
      BitDepth := 8;
      FByteWidth := 1;
      end
    else
      begin
      if c = 3 then
        ColorType := 4;
      FUsetRNS := (c = 2);
      if not FGrayScale then
        ColorType := ColorType + 2;
      if FWordSized then
        BitDepth := 16
      else
        BitDepth := 8;
      DetermineColorFormat;
      end;
    Compression := 0;
    Filter := 0;
    Interlace := 0;
    end;
end;

procedure TSSFPWriterPNG.WriteIHDR;
begin
  // signature for PNG
  TheStream.writeBuffer(Signature,sizeof(Signature));
  // Determine all settings for filling the header
  DetermineHeader (FHeader);
  // write the header chunk
  SetChunkLength (13);   // (sizeof(FHeader)); gives 14 and is wrong !!
  move (FHeader, ChunkDataBuffer^, 13);  // sizeof(FHeader));
  SetChunkType (ctIHDR);
  WriteChunk;
end;

{ Color convertions }

function TSSFPWriterPNG.ColorDataGrayB(color:TFPColor) : TColorData;
var t : word;
begin
  t := CalculateGray (color);
  result := hi(t);
end;

function TSSFPWriterPNG.ColorDataGrayW(color:TFPColor) : TColorData;
begin
  result := CalculateGray (color);
end;

function TSSFPWriterPNG.ColorDataGrayAB(color:TFPColor) : TColorData;
begin
  result := ColorDataGrayB (color);
  result := (result shl 8) and hi(color.Alpha);
end;

function TSSFPWriterPNG.ColorDataGrayAW(color:TFPColor) : TColorData;
begin
  result := ColorDataGrayW (color);
  result := (result shl 16) and color.Alpha;
end;

function TSSFPWriterPNG.ColorDataColorB(color:TFPColor) : TColorData;
begin
  with color do
    result := hi(red) + (green and $FF00) + (hi(blue) shl 16);
end;

function TSSFPWriterPNG.ColorDataColorW(color:TFPColor) : TColorData;
begin
  with color do
    result := red + (green shl 16) + (qword(blue) shl 32);
end;

function TSSFPWriterPNG.ColorDataColorAB(color:TFPColor) : TColorData;
begin
  with color do
    result := hi(red) + (green and $FF00) + (hi(blue) shl 16) + (hi(alpha) shl 24);
end;

function TSSFPWriterPNG.ColorDataColorAW(color:TFPColor) : TColorData;
begin
  with color do
    result := red + (green shl 16) + (qword(blue) shl 32) + (qword(alpha) shl 48);
end;

{ Data making routines }

function TSSFPWriterPNG.GetColorPixel (x,y:longword) : TColorData;
begin
  result := FFmtColor (TheImage[x,y]);
  //result := ConvertColorToData(TheImage.Colors[x,y],CFmt);
end;

function TSSFPWriterPNG.GetPalettePixel (x,y:longword) : TColorData;
begin
  result := TheImage.Pixels[x,y];
end;

function TSSFPWriterPNG.GetColPalPixel (x,y:longword) : TColorData;
begin
  result := ThePalette.IndexOf (TheImage.Colors[x,y]);
end;

function TSSFPWriterPNG.DecideGetPixel : TGetPixelFunc;
begin
  case Fheader.colortype of
    3 : if TheImage.UsePalette then
          begin
          result := @GetPalettePixel;
          end
        else
          begin
          result := @GetColPalPixel;
          end;
    else  begin
          result := @GetColorPixel;
          end
  end;
end;

procedure TSSFPWriterPNG.WritePLTE;
var r,t : integer;
    c : TFPColor;
begin
  with ThePalette do
    begin
    SetChunkLength (count*3);
    SetChunkType (ctPLTE);
    t := 0;
    For r := 0 to count-1 do
      begin
      c := Color[r];
      ChunkdataBuffer^[t] := c.red div 256;
      inc (t);
      ChunkdataBuffer^[t] := c.green div 256;
      inc (t);
      ChunkdataBuffer^[t] := c.blue div 256;
      inc (t);
      end;
    end;
  WriteChunk;
end;

procedure TSSFPWriterPNG.InitWriteIDAT;
begin
  FDatalineLength := TheImage.Width*ByteWidth;
  GetMem (FPreviousLine, FDatalineLength);
  GetMem (FCurrentLine, FDatalineLength);
  fillchar (FCurrentLine^,FDatalineLength,0);
  ZData := TMemoryStream.Create;
  Compressor := TCompressionStream.Create (clMax,ZData);
  FGetPixel := DecideGetPixel;
end;

procedure TSSFPWriterPNG.FinalWriteIDAT;
begin
  ZData.Free;
  FreeMem (FPreviousLine);
  FreeMem (FCurrentLine);
end;

function TSSFPWriterPNG.DetermineFilter (Current, Previous:PByteArray; linelength:longword) : byte;
begin
  result := 0;
end;

procedure TSSFPWriterPNG.FillScanLine (y : integer; ScanLine : pByteArray);
var r, x : integer;
    cd : TColorData;
    index : longword;
    b : byte;
begin
  index := 0;
  for x := 0 to pred(TheImage.Width) do
    begin
    cd := FGetPixel (x,y);
    {$IFDEF ENDIAN_BIG}
    cd:=swap(cd);
    {$ENDIF}
    move (cd, ScanLine^[index], FBytewidth);
    if WordSized then
      begin
      r := 1;
      while (r < FByteWidth) do
        begin
        b := Scanline^[index+r];
        Scanline^[index+r] := Scanline^[index+r-1];
        Scanline^[index+r-1] := b;
        inc (r,2);
        end;
      end;
    inc (index, FByteWidth);
    end;
end;

procedure TSSFPWriterPNG.GatherData;
var x,y : integer;
    lf : byte;
begin
  for y := 0 to pred(TheImage.height) do
    begin
    FSwitchLine := FCurrentLine;
    FCurrentLine := FPreviousLine;
    FPreviousLine := FSwitchLine;
    FillScanLine (y, FCurrentLine);
    lf := DetermineFilter (FCurrentLine, FpreviousLine, FDataLineLength);
    for x := 0 to FDatalineLength-1 do
      FCurrentLine^[x] := DoFilter (lf, x, FCurrentLine^[x]);
    Compressor.Write (lf, sizeof(lf));
    Compressor.Write (FCurrentLine^, FDataLineLength);
    end;
end;

procedure TSSFPWriterPNG.WriteCompressedData;
var l : longword;
begin
  Compressor.Free;  // Close compression and finish the writing in ZData
  l := ZData.position;
  ZData.position := 0;
  SetChunkLength(l);
  SetChunkType (ctIDAT);
  ZData.Read (ChunkdataBuffer^, l);
  WriteChunk;
end;

procedure TSSFPWriterPNG.WriteIDAT;
begin
  InitWriteIDAT;
  GatherData;
  WriteCompressedData;
  FinalWriteIDAT;
end;

procedure TSSFPWriterPNG.WritetRNS;
  procedure PaletteAlpha;
  var r : integer;
  begin
    with TheImage.palette do
      begin
      // search last palette entry with transparency
      r := count;
      repeat
        dec (r);
      until (r < 0) or (color[r].alpha <> alphaOpaque);
      if r >= 0 then // there is at least 1 transparent color
        begin
        // from this color we go to the first palette entry
        SetChunkLength (r+1);
        repeat
          chunkdatabuffer^[r] := (color[r].alpha shr 8);
          dec (r);
        until (r < 0);
        end;
      writechunk;
      end;
  end;
  procedure GrayAlpha;
  var g : word;
  begin
    SetChunkLength(2);
    if WordSized then
      g := CalculateGray (SingleTransparentColor)
    else
      g := hi (CalculateGray(SingleTransparentColor));
    {$IFDEF ENDIAN_LITTLE}
    g := swap (g);
    {$ENDIF}
    move (g,ChunkDataBuffer^[0],2);
    WriteChunk;
  end;
  procedure ColorAlpha;
  var g : TFPColor;
  begin
    SetChunkLength(6);
    g := SingleTransparentColor;
    with g do
      if WordSized then
        begin
        {$IFDEF ENDIAN_LITTLE}
        red := swap (red);
        green := swap (green);
        blue := swap (blue);
        {$ENDIF}
        move (g, ChunkDatabuffer^[0], 6);
        end
      else
        begin
        ChunkDataBuffer^[0] := 0;
        ChunkDataBuffer^[1] := red shr 8;
        ChunkDataBuffer^[2] := 0;
        ChunkDataBuffer^[3] := green shr 8;
        ChunkDataBuffer^[4] := 0;
        ChunkDataBuffer^[5] := blue shr 8;
        end;
    WriteChunk;
  end;
begin
  SetChunkType (cttRNS);
  case fheader.colortype of
    6,4 : raise PNGImageException.create ('tRNS chunk forbidden for full alpha channels');
    3 : PaletteAlpha;
    2 : ColorAlpha;
    0 : GrayAlpha;
  end;
end;

procedure TSSFPWriterPNG.WriteTexts;
begin
end;

procedure TSSFPWriterPNG.WriteIEND;
begin
  SetChunkLength(0);
  SetChunkType (ctIEND);
  WriteChunk;
end;

procedure TSSFPWriterPNG.InternalWrite (Str:TStream; Img:TFPCustomImage);
begin
  WriteIHDR;
  if Fheader.colorType = 3 then
    WritePLTE;
  if FUsetRNS then
    WritetRNS;
  WriteIDAT;
  WriteTexts;
  WriteIEND;
end;

initialization
 // ImageHandlers.RegisterImageWriter ('Portable Network Graphics', 'png', TSSFPWriterPNG);
end.
