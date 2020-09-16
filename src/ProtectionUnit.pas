unit ProtectionUnit;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, Windows, Registry, Dialogs, md5, rc6, SSXMLUnit, Controls,
  Types, LResources, LCLIntf, InterfaceBase, FileUtil,
  LCLStrConsts, LCLType, LCLProc, Forms, Themes,
  GraphType, Graphics, Buttons, ButtonPanel, StdCtrls, ExtCtrls, LCLClasses;

const
  hKeyHandle:HKEY = HKEY_CURRENT_USER;
  trialDays:integer = 30;
var
  CryptoKey1,CryptoKey2,CryptoKey3,CryptoKey4:String;
  ProgramRegKey,SeqProgramRegKey,InstallParamValue:String;
  SecretDate,SecretDiskSerial:String;

  Serial:String;
  SerialName:String;
  SerialId:String;
  SerialDate:String;

procedure SaveConfig;
procedure LoadConfig;


implementation

uses
   ConstantsUnit, SSConstantsUnit, SSNoiseUnit, AboutFormUnit, MainFormUnit;



function EncodeBase64(const inStr: string): string;

  function Encode_Byte(b: Byte): char;
    const
      Base64Code: string[64] = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  begin
    Result := Base64Code[(b and $3F)+1];
  end;

var
  i: Integer;
begin
  {$Q-}
  {$R-}
  i := 1;
  Result:= '';
  while i <= Length(InStr) do
  begin
    Result := Result + Encode_Byte(Byte(inStr[i]) shr 2);
    Result := Result + Encode_Byte((Byte(inStr[i]) shl 4) or (Byte(inStr[i+1]) shr 4));
    if i+1 <= Length(inStr) then Result := Result + Encode_Byte((Byte(inStr[i+1]) shl 2) or (Byte(inStr[i+2]) shr 6))
    else Result := Result + '=';
    if i+2 <= Length(inStr) then Result := Result + Encode_Byte(Byte(inStr[i+2]))
    else Result := Result + '=';
    Inc(i, 3);
  end;
  {$Q+}
  {$R+}
end;

// Base64 decoding
function DecodeBase64(const CinLine: string): string;
const
  RESULT_ERROR = -2;
var
  inLineIndex: Integer;
  c: Char;
  x: SmallInt;
  c4: Word;
  StoredC4: array[0..3] of SmallInt;
  InLineLength: Integer;
begin
  {$Q-}
  {$R-}
  Result := '';
  inLineIndex := 1;
  c4 := 0;
  InLineLength := Length(CinLine);

  while inLineIndex <=InLineLength do
  begin
    while (inLineIndex <= InLineLength) and (c4 < 4) do
    begin
      c := CinLine[inLineIndex];
      case c of
        '+'     : x := 62;
        '/'     : x := 63;
        '0'..'9': x := Ord(c) - (Ord('0')-52);
        '='     : x := -1;
        'A'..'Z': x := Ord(c) - Ord('A');
        'a'..'z': x := Ord(c) - (Ord('a')-26);
      else
        x := RESULT_ERROR;
      end;
      if x <> RESULT_ERROR then
      begin
        StoredC4[c4] := x;
        Inc(c4);
      end;
      Inc(inLineIndex);
    end;

    if c4 = 4 then
    begin
      c4 := 0;
      Result := Result + Char((StoredC4[0] shl 2) or (StoredC4[1] shr 4));
      if StoredC4[2] = -1 then Exit;
      Result := Result + Char((StoredC4[1] shl 4) or (StoredC4[2] shr 2));
      if StoredC4[3] = -1 then Exit;
      Result := Result + Char((StoredC4[2] shl 6) or (StoredC4[3]));
    end;
  end;
  {$Q+}
  {$R+}
end;

function SaveEncryptedFile(filename,datastr,key:String):boolean;
  var
    fs:TFileStream;
    ss:TStringStream;
    j:Integer;
    s:AnsiString;
begin
  result:=false;
  try
    try
      s:=datastr;
      for j:=1 to 32 do s:=s+char(irandom(ss_seed,256));
      ss:=TStringStream.Create(s);
      fs:=nil;
      if FileExists(filename) then DeleteFile(PChar(filename));
      fs:=TFileStream.Create(filename,fmOpenWrite or fmCreate or fmShareDenyWrite);

      result:=EncryptCopy(fs,ss,ss.Size,key);
    except
      on e:Exception do begin
        //ShowMessage(e.Message);
      end;
    end;
  finally
    ss.Destroy;
    if ( fs <> nil ) then begin
      fs.Destroy;
    end;
  end;
end;

function LoadDecryptedFile(filename:String;var datastr:String;key:String):boolean;
  var
    fs:TFileStream;
    ss:TStringStream;
    j:Integer;
    s:String;
begin
  result:=false;
  s:=datastr;
  if not FileExists(filename) then exit;
  try
    try
      ss:=TStringStream.Create('');
      fs:=nil;
      fs:=TFileStream.Create(filename,fmOpenRead or fmShareDenyRead);
      result:=DecryptCopy(ss,fs,fs.Size,key);
      ss.Seek(0,0);
      s:=ss.ReadString(ss.Size);
      datastr:=copy(s,1,length(s)-32);
    except
      on e:Exception do begin
        //ShowMessage(e.Message);
      end;
    end;
  finally
    ss.Destroy;
    if ( fs <> nil ) then begin
      fs.Destroy;
    end;
  end;
end;


function EncryptString(src,key:String):String;
  var
    ss,ds:TStringStream;
    s:String;
    j:Integer;
begin
  s:=src;
  for j:=1 to 32 do s:=s+char(irandom(ss_seed,256));
  ss:=TStringStream.Create(s);
  ds:=TStringStream.Create('');
  EncryptCopy(ds,ss,ss.Size,key);
  ds.Seek(0,0);
  s:=ds.ReadString(ds.Size);
  result:=EncodeBase64(s);
  ss.Destroy;
  ds.Destroy;
end;

function DecryptString(src,key:String):String;
  var
    ss,ds:TStringStream;
    s:String;
begin
  ss:=TStringStream.Create(DecodeBase64(src));
  ds:=TStringStream.Create('');
  DecryptCopy(ds,ss,ss.Size,key);
  ds.Seek(0,0);
  s:=ds.ReadString(ds.Size);
  result:=copy(s,1,length(s)-32);
  ds.Destroy;
  ss.Destroy;
end;

// Сохраняем конфиг в зашифрованном виде
procedure SaveConfig;
  var
    xml,n1,n2:TXMLNode;
begin
  try
    xml:=TXMLNode.Create;
    n1:=xml.SubNodes_Add;
    n1.name:='SpriteMakerConfig';
    n2:=n1.SubNodes_Add;
    n2.name:='params';
    n2.Attribute_Add('OpenSaveFilePath')^.Value:=EncodeBase64(OpenSaveFilePath);
    n2.Attribute_Add('SavePicturePath')^.Value:=EncodeBase64(SavePicturePath);
    n2.Attribute_Add('RenderTextureWidth')^.Value:=IntToStr(RenderTextureWidth);
    n2.Attribute_Add('RenderTextureHeight')^.Value:=IntToStr(RenderTextureHeight);
    SaveEncryptedFile(path+'config.cfg',xml.SaveToXMLString,CryptoKey3);
  finally
    xml.Destroy;
  end;
end;

procedure LoadConfig;
  var
    xml,n1,n2:TXMLNode;
    s:String;
begin
  xml:=TXMLNode.Create;
  if LoadDecryptedFile(path+'config.cfg',s,CryptoKey3) then begin
    xml.LoadFromXMLString(s);
    OpenSaveFilePath:=DecodeBase64(xml['SpriteMakerConfig']['params'].Attribute_Str('OpenSaveFilePath'));
    SavePicturePath:=DecodeBase64(xml['SpriteMakerConfig']['params'].Attribute_Str('SavePicturePath'));
    RenderTextureWidth:=xml['SpriteMakerConfig']['params'].Attribute_Int('RenderTextureWidth');
    RenderTextureHeight:=xml['SpriteMakerConfig']['params'].Attribute_Int('RenderTextureHeight');
    if RenderTextureWidth < 2 then RenderTextureWidth:=256;
    if RenderTextureHeight < 2 then RenderTextureHeight:=256;
    xml.Destroy;
  end;
end;

function GetBiosNumber: string;
begin

  result := string(pchar(ptr($FEC71,$0)));
end;

function GetHardDiskSerial(const DriveLetter: Char): string;
var
  NotUsed:     DWORD;
  VolumeFlags: DWORD;
  VolumeInfo:  array[0..MAX_PATH] of Char;
  VolumeSerialNumber: DWORD;
  s:String;
begin
  {$R-}
  {$Q-}
  s:=DriveLetter + ':\';
  GetVolumeInformation(PChar(s),
    nil, SizeOf(VolumeInfo), @VolumeSerialNumber, NotUsed,
    VolumeFlags, nil, 0);
  Result := Format('%8.8X',
    [VolumeSerialNumber])
  {$R+}
  {$Q+}
end;

procedure SaveRegistration;
  var
    rfl:TRegistry;
    xml,n1,n2:TXMLNode;
    s:String;
begin
  try
    try
    // Читаем информацию о регистрации программы
    rfl := TRegistry.Create(KEY_WRITE);
    rfl.RootKey:=hKeyHandle;
    rfl.OpenKey(ProgramRegKey, true);
  //  s:=trim(DecryptString(rfl.ReadString('RegistrationKey'),CryptoKey4));
    xml:=TXMLNode.Create;
    n1:=xml.SubNodes_Add;
    n1.name:='RegistrationKey';
    n1.Attribute_Add('Serial')^.Value:=Serial;
    rfl.WriteString('RegistrationKey',EncryptString(xml.SaveToXMLString,CryptoKey4));
    except
      on e:Exception do begin
        ShowMessage(e.message);
      end;
    end;
  finally
    rfl.Destroy;
    xml.Destroy;
  end;
end;


initialization

  // Set CryptoKey1
  // Создаем ключ для расшифрования строк с путями к реестру
  //InputBox('Sec','Key',md5x4('This Sergey key is not allow crack it!'));
  CryptoKey1:='3B348784B27DD924DCB4BA0DA214D1B5';
  // Расшифровываем ветки реестра
  //InputBox('Sec','Key',EncryptString('Software\SpriteMaker\',CryptoKey1));
  ProgramRegKey:=DecryptString('Ih7llhpAqxT0fdbvTPFzgJOPTHTbuZ+NKMJW8rTPNrwsALP7DEiCoCby8aSio/NaviTuZ94=',CryptoKey1);
  //InputBox('Sec','Key',EncryptString('Software\Classes\SmHelper\',CryptoKey1));
  SeqProgramRegKey:=DecryptString('qZlDg1YMGhBCPwej4h3rNTAuobcJjcbLT6EaU4Fhx6Bh2m+aVpg6kvbUcdxxNnZM3rRkb5y+JO5n3g==',CryptoKey1);
  // Расшифровываем ключ 2 - секретная командная строка
  //  InputBox('Sec','Key',EncryptString('It is not a secret, that i love my mother.',CryptoKey1));
  CryptoKey2:=DecryptString('jdiPXlxb21kFLzirUeWKi38uceggTivrGdQKNkwJebTSd/EScZX0rbLDLHdVCj0bvOGCkUn9kVXxtZKYZKBUqcNdXoEtsvXBOkE=',CryptoKey1);
  // CryptoKey3 = 1425EF2A63A7E26D0D3CEB36430C5652 - Хеш CryptoKey2
  CryptoKey3:=md5x4(CryptoKey2);
  // Это ключ шифрования данных в реестре (привязан к серийному номеру жесткого диска)
  CryptoKey4:=md5x4(GetHardDiskSerial(paramstr(0)[1])+CryptoKey3);

finalization

end.

