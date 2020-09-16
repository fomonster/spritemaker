{*******************************************************************************

  Проект: SpaceSim
  Автор: Фомин С.С.
  Дата: 2009 год

  Назначение модуля:


*******************************************************************************}
unit EnumFolder;

interface

uses
  Classes, SysUtils;

type
  PSearchRec = ^TSearchRec;
  TEnumFolder = class
  private
    FBasePath: string;
    FList: TStrings;
    FSR: PSearchRec;
    FIsFolderFirst: Boolean;
    FBasePos: Integer;
    FNextProc: procedure of object;
    function GetAbsPath: string;
    function GetRelPath: string;
    procedure ClearList;
    function GetPathType(Path: string): Integer;
    procedure PushSR(Dir: string);
    procedure PopSR;
    procedure Next1;
    procedure Next2;
  public
    constructor Create(BasePath: string; IsFolderFirst: Boolean = True);
    destructor Destroy; override;
    procedure First;
    procedure Next;
    function Eof: Boolean;
    property AbsPath: string read GetAbsPath;
    property RelPath: string read GetRelPath;
    property SR: PSearchRec read FSR;
  end;

implementation

{ TEnumFolder }

constructor TEnumFolder.Create(BasePath: string; IsFolderFirst: Boolean);
begin
  inherited Create;
  FList := TStringList.Create;
  FBasePath := ExcludeTrailingBackslash(BasePath);
  FIsFolderFirst := IsFolderFirst;
  if IsFolderFirst then
    FNextProc := Next1
  else
    FNextProc := Next2;
end;

destructor TEnumFolder.Destroy;
begin
  ClearList;
  FList.Free;
  inherited;
end;

procedure TEnumFolder.ClearList;
begin
  while (FList.Count > 0) do
    PopSR;
end;

function TEnumFolder.GetAbsPath: string;
begin
  Result := FList[0] + SR.Name;
end;

function TEnumFolder.GetRelPath: string;
begin
  Result := Copy(AbsPath, FBasePos, MaxInt);
end;

function TEnumFolder.GetPathType(Path: string): Integer;
begin
  New(FSR);
  if (FindFirst(Path, faAnyFile, SR^) <> 0) then
    Result := -1 { Not found }
  else
  begin
    if (SR.Attr and faDirectory <> 0) then
    begin
      FBasePos := Length(Path) + 2;
      Path := ExtractFilePath(Path);
      FList.InsertObject(0, Path, TObject(SR));
      Result := 1; { Folder }
    end
    else
    begin
      Path := ExtractFilePath(Path);
      FBasePos := Length(Path) + 1;
      FList.InsertObject(0, Path, TObject(SR));
      Result := 0; { File }
    end;
  end;
end;

function TEnumFolder.Eof: Boolean;
begin
  Result := (FList.Count = 0);
end;

procedure TEnumFolder.First;
begin
  FSR := nil;
  ClearList;
  case GetPathType(FBasePath) of
    { Folder }
    1:
      if not FIsFolderFirst then
      begin
        PushSR(FBasePath);
        Next;
      end;
    { File }
    0: ;
  end;
end;

procedure TEnumFolder.Next;
begin
  FNextProc;
end;

procedure TEnumFolder.Next1;
begin
  { Push folder }
  if (SR.Attr and faDirectory <> 0) then
    PushSR(FList[0] + FSR.Name);

  while (FList.Count > 0) and (FindNext(SR^) <> 0) do
    PopSR;
end;

procedure TEnumFolder.Next2;
begin
  while (FList.Count > 0) do
    if (FindNext(SR^) <> 0) then
    begin
      PopSR;
      Break;
    end
    else if (SR.Attr and faDirectory <> 0) then
      PushSR(FList[0] + FSR.Name)
    else
      Break;
end;

procedure TEnumFolder.PushSR(Dir: string);
begin
  New(FSR);
  FindFirst(Dir + '\*.*', faAnyFile, FSR^);
  FindNext(FSR^); { Skip "." and ".." }
  FList.InsertObject(0, Dir + '\', TObject(FSR));
end;

procedure TEnumFolder.PopSR;
begin
  FList.Delete(0);
  FindClose(SR^);
  Dispose(SR);
  if FList.Count > 0 then
    FSR := PSearchRec(FList.Objects[0])
  else
    FSR := nil;
end;

end.