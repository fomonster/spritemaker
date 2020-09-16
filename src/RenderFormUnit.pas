unit RenderFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, GraphType, Dialogs,
  ExtCtrls, Buttons, StdCtrls, ComCtrls, Gradient, RichView, RVStyle, SSFPWritePNG,
  RenderOptionsFormUnit, Windows, DXTC, RGBGraphics, RGBTypes, Clipbrd,IntfGraphics, FPImage,
  FPImgCanv, SSPictureView, SSPictureUnit, libwebp_static;


const
  it_bmp=1;
  it_dds=2;

   RegisterName = 'G32 Bitmap32 Alpha Channel';
   GlobalUnlockBugErrorCode = ERROR_INVALID_PARAMETER;


   DDSD_CAPS        = $00000001;
   DDSD_HEIGHT      = $00000002;
   DDSD_WIDTH       = $00000004;
   DDSD_PITCH       = $00000008;
   DDSD_PIXELFORMAT = $00001000;
   DDSD_MIPMAPCOUNT = $00020000;
   DDSD_LINEARSIZE  = $00080000;
   DDSD_DEPTH       = $00800000;

   DDPF_ALPHAPIXELS = $00000001;
   DDPF_FOURCC      = $00000004;
   DDPF_RGB         = $00000040;

   DDSCAPS_COMPLEX  = $00000008;
   DDSCAPS_TEXTURE  = $00001000;
   DDSCAPS_MIPMAP   = $00400000;

   DDSCAPS2_CUBEMAP           = $00000200;
   DDSCAPS2_CUBEMAP_POSITIVEX = $00000400;
   DDSCAPS2_CUBEMAP_NEGATIVEX = $00000800;
   DDSCAPS2_CUBEMAP_POSITIVEY = $00001000;
   DDSCAPS2_CUBEMAP_NEGATIVEY = $00002000;
   DDSCAPS2_CUBEMAP_POSITIVEZ = $00004000;
   DDSCAPS2_CUBEMAP_NEGATIVEZ = $00008000;
   DDSCAPS2_VOLUME            = $00200000;

   FOURCC_DXT1 = $31545844; // 'DXT1'
   FOURCC_DXT3 = $33545844; // 'DXT3'
   FOURCC_DXT5 = $35545844; // 'DXT5'

{******************************************************************************}
type

TDDPIXELFORMAT = record
      dwSize,
      dwFlags,
      dwFourCC,
      dwRGBBitCount,
      dwRBitMask,
      dwGBitMask,
      dwBBitMask,
      dwRGBAlphaBitMask : Cardinal;
   end;

   TDDCAPS2 = record
      dwCaps1,
      dwCaps2 : Cardinal;
      Reserved : array[0..1] of Cardinal;
   end;

   TDDSURFACEDESC2 = record
      dwSize,
      dwFlags,
      dwHeight,
      dwWidth,
      dwPitchOrLinearSize,
      dwDepth,
      dwMipMapCount : Cardinal;
      dwReserved1 : array[0..10] of Cardinal;
      ddpfPixelFormat : TDDPIXELFORMAT;
      ddsCaps : TDDCAPS2;
      dwReserved2 : Cardinal;
   end;

   TDDSHeader = record
      Magic : Cardinal;
      SurfaceFormat : TDDSURFACEDESC2;
   end;

   TFOURCC = array[0..3] of char;

type

  { TRenderForm }

  TRenderForm = class(TForm)
    Label2: TLabel;
    Label4: TLabel;
    LazGradient1: TLazGradient;
    LazGradient6: TLazGradient;
    LazGradient7: TLazGradient;
    Panel1: TPanel;
    Panel3: TPanel;
    PanelLeft4: TPanel;
    PanelLeftHeader1: TPanel;
    PanelLeftHeader3: TPanel;
    PanelRight: TPanel;
    PanelRight2: TPanel;
    PanelScreen: TPanel;
    PanelScreen2: TPanel;
    PanelTop: TPanel;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PanelScreenClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    picture:TSSPicture;
    PictureView:TPictureView;
    procedure DoRenderTexture;
  end; 

var
  RenderForm: TRenderForm;
  FAlphaFormatHandle: Word = 0;

implementation

  Uses MainFormUnit, GeneratorTreeUnit, ConstantsUnit, SSConstantsUnit, GeneratorNodeUnit;

{ TRenderForm }

procedure SaveToWEBP(bmp:TRGB32BitMap;filename:String);
  var
    webpOut:PByte;
    webpSize:integer;
    stream:TFileStream;
begin
  try
    stream:=TFileStream.Create(filename,fmOpenWrite or fmCreate);
    stream.Seek(0, soFromBeginning);
    webpSize := WebPEncodeBGRA(PByte(bmp.GetPixelPtr(0,0)), bmp.Width, bmp.Height, bmp.Width * 4, 80, webpOut);
    stream.Write(webpOut^,webpSize);
  finally
    //WebPFree(webpOut);
    stream.Free;
  end;

end;

procedure SaveToDDS(bmp:TRGB32BitMap;filename:String;PixelFormat:Integer;Transparent:boolean);
  const
    DDSD_CAPS        = $00000001;
   DDSD_HEIGHT      = $00000002;
   DDSD_WIDTH       = $00000004;
   DDSD_PITCH       = $00000008;
   DDSD_PIXELFORMAT = $00001000;
   DDSD_MIPMAPCOUNT = $00020000;
   DDSD_LINEARSIZE  = $00080000;
   DDSD_DEPTH       = $00800000;

   DDPF_ALPHAPIXELS = $00000001;
   DDPF_FOURCC      = $00000004;
   DDPF_RGB         = $00000040;

   DDSCAPS_COMPLEX  = $00000008;
   DDSCAPS_TEXTURE  = $00001000;
   DDSCAPS_MIPMAP   = $00400000;

   DDSCAPS2_CUBEMAP           = $00000200;
   DDSCAPS2_CUBEMAP_POSITIVEX = $00000400;
   DDSCAPS2_CUBEMAP_NEGATIVEX = $00000800;
   DDSCAPS2_CUBEMAP_POSITIVEY = $00001000;
   DDSCAPS2_CUBEMAP_NEGATIVEY = $00002000;
   DDSCAPS2_CUBEMAP_POSITIVEZ = $00004000;
   DDSCAPS2_CUBEMAP_NEGATIVEZ = $00008000;
   DDSCAPS2_VOLUME            = $00200000;

   FOURCC_DXT1 = $31545844; // 'DXT1'
   FOURCC_DXT3 = $33545844; // 'DXT3'
   FOURCC_DXT5 = $35545844; // 'DXT5'
  type
    TDDPIXELFORMAT = record
          dwSize,
          dwFlags,
          dwFourCC,
          dwRGBBitCount,
          dwRBitMask,
          dwGBitMask,
          dwBBitMask,
          dwRGBAlphaBitMask : Cardinal;
       end;

       TDDCAPS2 = record
          dwCaps1,
          dwCaps2 : Cardinal;
          Reserved : array[0..1] of Cardinal;
       end;

       TDDSURFACEDESC2 = record
          dwSize,
          dwFlags,
          dwHeight,
          dwWidth,
          dwPitchOrLinearSize,
          dwDepth,
          dwMipMapCount : Cardinal;
          dwReserved1 : array[0..10] of Cardinal;
          ddpfPixelFormat : TDDPIXELFORMAT;
          ddsCaps : TDDCAPS2;
          dwReserved2 : Cardinal;
       end;

       TDDSHeader = record
          Magic : Cardinal;
          SurfaceFormat : TDDSURFACEDESC2;
       end;

       TFOURCC = array[0..3] of char;
  var
    stream:TFileStream;
    magic : TFOURCC;
    header : TDDSHeader;
    i,j, rowSize : Integer;
begin
  stream:=TFileStream.Create(filename,fmOpenWrite or fmCreate);

  stream.Seek(0, soFromBeginning);

  FillChar(header, SizeOf(TDDSHeader), 0);
  magic:='DDS ';
  header.magic:=Cardinal(magic);
  with header.SurfaceFormat do begin

    dwSize:=124;
    dwFlags:=DDSD_CAPS +
             DDSD_PIXELFORMAT +
             DDSD_WIDTH +
             DDSD_HEIGHT +
             DDSD_PITCH;
    dwWidth:=bmp.Width;
    dwHeight:=bmp.Height;

    case PixelFormat of
      {$IFDEF MSWINDOWS}
      0:
        begin
          ddpfPixelFormat.dwFlags:=DDPF_RGB;
          ddpfPixelFormat.dwRGBBitCount:=24;
          ddpfPixelFormat.dwRBitMask:=$00FF0000;
          ddpfPixelFormat.dwGBitMask:=$0000FF00;
          ddpfPixelFormat.dwBBitMask:=$000000FF;
        end;
         {$ENDIF}
      1:
        begin
          ddpfPixelFormat.dwFlags:=DDPF_RGB;
          ddpfPixelFormat.dwRGBBitCount:=32;
          ddpfPixelFormat.dwRBitMask:=$00FF0000;
          ddpfPixelFormat.dwGBitMask:=$0000FF00;
          ddpfPixelFormat.dwBBitMask:=$000000FF;
          if Transparent then begin
            ddpfPixelFormat.dwFlags:=ddpfPixelFormat.dwFlags + DDPF_ALPHAPIXELS;
            ddpfPixelFormat.dwRGBAlphaBitMask:=$FF000000;
          end;
        end;
      else
         //error
      end;

      rowSize:=(ddpfPixelFormat.dwRGBBitCount div 8)*dwWidth;

      dwPitchOrLinearSize:=dwHeight*Cardinal(rowSize);

      ddsCaps.dwCaps1:=DDSCAPS_TEXTURE;
      stream.Write(header, SizeOf(TDDSHeader));

      for i:=0 to bmp.Height-1 do
        for j:=0 to bmp.Width-1 do
          stream.Write(bmp.Get32PixelPtr(j, i)^, 4);

  end;
  stream.Free;
end;

procedure TRenderForm.PanelScreenClick(Sender: TObject);
begin

end;

// DO RENDER
procedure TRenderForm.SpeedButton1Click(Sender: TObject);
  type

   { TFPColor = record
      red,green,blue,alpha : word;
    end;}

    TRGBARec = packed record
      r,b,g,a:Byte;
    end;
    PRGBARec = ^TRGBARec;

  var
    i, x,y:Integer;
    GeneratorTree:TGeneratorNodeList;
    Node,RootNode:TGeneratorNode;
    ex,filename:String;

    cc:TGraphicsColor;
 //   raw:TRawImage;
    pa:TRGB32PixelArray;

    RawImage: TRawImage;

    ny:Integer;

    IntfImg:TLazIntfImage;
    dt:TRawImageDescription;

    //c:TFPColor;
    hdcTemp:HBITMAP;

    b:Byte;

    Size:Integer;

    pngWriter : TLazWriterPNG;
    bmpWriter : TLazWriterBMP;
    pic:TPicture;
    img : TLazIntfImage;
    jpgImg : TJPEGImage;


    //Img: TFPMemoryImage;
    Writer: TSSFPWriterPNG;
    ImgCanvas: TFPImageCanvas;
    fs:TFileStream;
    c:TFPColor;
    cs:TRGB32Pixel;
    //Img:TFPCustomImage;
begin
  RootNode:=nil;
  GeneratorTree:=MainForm.GeneratorTree;
  for i:=0 to GeneratorTree.count-1 do begin
    if GeneratorTree[i].OwnerId=-1 then RootNode:=GeneratorTree[i];
  end;
  if (RootNode<>nil)and(RootNode.TextureRenderer<>nil)and(RootNode.TextureRenderer.rbm<>nil) then begin

    SaveDialog1.FileName:=SavePicturePath+'\';
    SaveDialog1.InitialDir:=SavePicturePath+'\';
    if SaveDialog1.Execute then begin
      SavePicturePath:=ExtractFilePath(SaveDialog1.FileName);
      filename:=SaveDialog1.FileName;

      case SaveDialog1.FilterIndex of
        1:filename:=ExtractFileNameWithoutExt(filename)+'.png';
        2:filename:=ExtractFileNameWithoutExt(filename)+'.jpg';
        3:filename:=ExtractFileNameWithoutExt(filename)+'.webp';
        4:filename:=ExtractFileNameWithoutExt(filename)+'.bmp';
        5:filename:=ExtractFileNameWithoutExt(filename)+'.dds';
      end;

      if not FileExists(filename) or (MessageDlg('Overwrite?', 'File exists! Are you sure overwrite it?',mtConfirmation, mbYesNo, 0) = mrYes) then
      begin
        if FileExists(filename) then DeleteFile(PChar(filename));
        RootNode.TextureRenderer.UnCache;
        RootNode.TextureRenderer.Cache(true);
        if SaveDialog1.FilterIndex=4 then begin

          bmpWriter := TLazWriterBMP.create;
          bmpWriter.BitsPerPixel:=32;  //<----- needed to get an alpha channel
          img := TLazIntfImage.Create( RootNode.TextureRenderer.rbm.Width,RootNode.TextureRenderer.rbm.Height, [riqfRGB, riqfAlpha]);
          try
            img.CreateData;

            for y:=0 to RootNode.TextureRenderer.rbm.Height-1 do for x:=0 to RootNode.TextureRenderer.rbm.Width-1 do begin
              cs:=RootNode.TextureRenderer.rbm.Get32PixelPtr(x, y)^;
              c.blue:=(cs and $ff) shl 8;
              c.green:=(cs and $ff00);
              c.red:=(cs and $ff0000) shr 8;
              c.alpha:=(cs and $ff000000) shr 16;
              Img.Colors[x,y]:=c;
            end;

            img.SaveToFile(FileName, bmpWriter);
          finally
            img.Free;
            bmpWriter.Free;
          end;
        end else if SaveDialog1.FilterIndex=3 then begin

          SaveToWEBP(RootNode.TextureRenderer.rbm, filename);

        end else if SaveDialog1.FilterIndex=5 then begin

          SaveToDDS(RootNode.TextureRenderer.rbm,filename,1,true);

        end else if SaveDialog1.FilterIndex=2 then begin

          // Color data
           pic:=TPicture.Create;
           jpgImg := TJPEGImage.Create;
           try

              jpgImg.Width := RootNode.TextureRenderer.rbm.Width;
              jpgImg.Height := RootNode.TextureRenderer.rbm.Height;

              for y:=0 to RootNode.TextureRenderer.rbm.Height-1 do for x:=0 to RootNode.TextureRenderer.rbm.Width-1 do begin
                cs:=RootNode.TextureRenderer.rbm.Get32PixelPtr(x, y)^;
                c.blue:=(cs and $ff) shl 8;
                c.green:=(cs and $ff00);
                c.red:=(cs and $ff0000) shr 8;
                c.alpha:=(cs and $ff000000) shr 16;
                jpgImg.Canvas.Colors[x, y] := c;
              end;

             jpgImg.CompressionQuality:=97;
             jpgImg.SaveToFile(FileName);
           finally
             jpgImg.Free;
             pic.Free;
           end;

        end else if SaveDialog1.FilterIndex=1 then begin

          pngWriter := TLazWriterPNG.create;
          pngWriter.UseAlpha := true; //<----- needed to get an alpha channel
          pngWriter.WordSized := false;
          pngWriter.GrayScale:=false;
          img := TLazIntfImage.Create( RootNode.TextureRenderer.rbm.Width,RootNode.TextureRenderer.rbm.Height, [riqfRGB, riqfAlpha]);
          try
            img.CreateData;
            for y:=0 to RootNode.TextureRenderer.rbm.Height-1 do for x:=0 to RootNode.TextureRenderer.rbm.Width-1 do begin
              cs:=RootNode.TextureRenderer.rbm.Get32PixelPtr(x, y)^;
              c.blue:=(cs and $ff) shl 8;
              c.green:=(cs and $ff00);
              c.red:=(cs and $ff0000) shr 8;
              c.alpha:=(cs and $ff000000) shr 16;
              Img.Colors[x,y]:=c;
            end;

            img.SaveToFile(FileName, pngWriter);
          finally
            img.Free;
            pngWriter.Free;
          end;

        end;
        RootNode.TextureRenderer.UnCache;
        RootNode.TextureRenderer.Cache(false);
      end;
    end;
  end;
end;

procedure TRenderForm.SpeedButton2Click(Sender: TObject);
begin
   DoRenderTexture;
end;

procedure TRenderForm.SpeedButton3Click(Sender: TObject);
begin
  RenderOptionsForm.ShowModal;
end;

function GetAlphaFormatHandle: Word;
begin
  if FAlphaFormatHandle = 0 then
  begin
    FAlphaFormatHandle := RegisterClipboardFormat(RegisterName);
    if FAlphaFormatHandle = 0 then ShowMessage('Cant register alpha format');
   end;
   Result := FAlphaFormatHandle;
 end;

procedure TRenderForm.SpeedButton4Click(Sender: TObject);
  var
    i:Integer;
    GeneratorTree:TGeneratorNodeList;
    Node,RootNode:TGeneratorNode;
    pic:TPicture;
    Bytes:LongWord;
    H: HGLOBAL;
    P, Alpha: PByte;
begin

  RootNode:=nil;
  GeneratorTree:=MainForm.GeneratorTree;
  for i:=0 to GeneratorTree.count-1 do begin
    if GeneratorTree[i].OwnerId=-1 then RootNode:=GeneratorTree[i];
  end;
  if (RootNode<>nil)and(RootNode.TextureRenderer<>nil)and(RootNode.TextureRenderer.rbm<>nil) then begin

    RootNode.TextureRenderer.UnCache;
    RootNode.TextureRenderer.Cache(true);

    pic:=TPicture.Create;
    pic.Bitmap.TransparentMode:=tmFixed;
    pic.Bitmap.Transparent:=true;
    pic.Bitmap.PixelFormat:=pf32bit;
    pic.Bitmap.SetSize(RootNode.TextureRenderer.rbm.Width,RootNode.TextureRenderer.rbm.Height);
    RootNode.TextureRenderer.rbm.Canvas.DrawTo(pic.Bitmap.Canvas,0,0);
//    Image1.Picture.SaveToClipboardFormat(CF_Picture);
    Clipboard.Assign(pic.Bitmap);
    pic.Destroy;
{
    // Переносим альфу
    if not OpenClipboard(0) then begin
      ShowMessage('Clipboard error');
    end else begin
      try

        Bytes := 4 + (RootNode.TextureRenderer.rbm.Width * RootNode.TextureRenderer.rbm.Height);
        H := GlobalAlloc(GMEM_MOVEABLE and GMEM_DDESHARE, Bytes);
        if H = 0 then begin
          ShowMessage('Out of Memory');
          CloseClipboard;
          exit;
        end;

        P := GlobalLock(H);
        if P=nil then begin
          ShowMessage('Memory out of lock');
          CloseClipboard;
          exit;
        end;

        PLongWord(P)^:=Bytes - 4;
        inc(P, 4);

        for i:=0 to RootNode.TextureRenderer.rbm.Width * RootNode.TextureRenderer.rbm.Height-1 do begin
          P^:=0;
          Inc(P);
        end;

        GlobalUnlock(H);
        SetClipboardData(GetAlphaFormatHandle, H);
      finally
        CloseClipboard;
      end;

    end;
 }
    RootNode.TextureRenderer.UnCache;
    RootNode.TextureRenderer.Cache(false);
  end;
end;

procedure TRenderForm.DoRenderTexture;
  var
    i,j,k:Integer;
    GeneratorTree:TGeneratorNodeList;
    Node,RootNode:TGeneratorNode;
    maxL:Integer;
begin
  maxL:=0;
  GeneratorTree:=MainForm.GeneratorTree;

  if ( picture = nil ) then begin
    picture:=TSSPicture.Create;
  end;
  picture.SetSize(RenderTextureWidth,RenderTextureHeight);
  picture.bitmap.Canvas.Fill($00000000);

  //Picture.Bitmap.Width:=RenderTextureWidth;
 // Picture.Bitmap.Height:=RenderTextureHeight;

  Picture.bitmap.Canvas.Fill(0);

  ProgressBar1.Position:=0;
  ProgressBar1.Min:=0;
  ProgressBar1.Max:=GeneratorTree.Count;
  ProgressBar1.Step:=1;

  RootNode:=nil;
  for i:=0 to GeneratorTree.count-1 do begin
    if GeneratorTree[i].OwnerId=-1 then RootNode:=GeneratorTree[i];
    if GeneratorTree[i].TextureRenderer<>nil then begin
      GeneratorTree[i].TextureRenderer.UnCache;
      GeneratorTree[i].TextureRenderer.Destroy;
      GeneratorTree[i].TextureRenderer:=nil;
    end;
    if maxL<GeneratorTree[i].L then maxL:=GeneratorTree[i].L;
    if GeneratorTree[i].GeneratorNodeUnit=nil then begin
      ShowMessage('Texture not complited!');
      exit;
    end;
  end;
  if RootNode=nil then exit;

  k:=0;
  for j:=maxL downto 0 do begin
    for i:=0 to GeneratorTree.count-1 do if GeneratorTree[i].L=j then begin
      Node:=GeneratorTree[i];
      if Node.TextureRenderer=nil then begin
        Node.GeneratorNodeUnit.RenderTexture(RenderTextureWidth,RenderTextureHeight);
        inc(k);
        ProgressBar1.Position:=k;
        ProgressBar1.Repaint;
 //       RenderForm.Caption:=IntToStr(random(100));
        Application.ProcessMessages;
      end;
    end;
  end;

  RootNode.TextureRenderer.Cache(true); // Пререндер квадратиков

  Picture.Width:=RenderTextureWidth;
  Picture.Height:=RenderTextureHeight;
  //Image1.Picture.Bitmap.Width:=RenderTextureWidth;
  //Image1.Picture.Bitmap.Height:=RenderTextureHeight;

  Picture.bitmap.Canvas.Fill(0);

  picture.bitmap.Draw(0,0,RootNode.TextureRenderer.rbm);


 //TODO:  RootNode.TextureRenderer.rbm.Canvas.DrawTo(Image1.Canvas,0, 0);

  PictureView.CurrentPicture:=picture;

  PictureView.RecalculateScrollBars;

  PictureView.Repaint;
  PictureView.SetMode_ZoomAndMove;
end;
{******************************************************************************}
procedure TRenderForm.FormShow(Sender: TObject);
begin
  //
  RenderForm.DoubleBuffered:=true;
  PanelRight.DoubleBuffered:=true;

  PanelTop.DoubleBuffered:=true;

  //DoRenderTexture;
end;

procedure TRenderForm.FormCreate(Sender: TObject);
begin
  picture := nil;

  PictureView:=TPictureView.Create(Panel1);
  Panel1.InsertControl(PictureView);

end;

procedure TRenderForm.FormDestroy(Sender: TObject);
begin
  PictureView.CurrentPicture:=nil;

  if ( picture <> nil ) then begin
    picture.Destroy;
    picture:=nil;
  end;

  Panel1.RemoveControl(PictureView);
  PictureView.Free;
  PictureView := nil;
end;

initialization
  {$I RenderFormUnit.lrs}

end.

