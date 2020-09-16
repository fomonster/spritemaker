{*******************************************************************************

  Модуль главной формы.

      MainFormUnit.pas




*******************************************************************************}
unit MainFormUnit;
{******************************************************************************}
{$mode objfpc}{$H+}
{******************************************************************************}
interface
{******************************************************************************}
uses
{******************************************************************************}
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Menus, ComCtrls, PairSplitter, ExtCtrls, SSXMLUnit, GeneratorTreeUnit,
  SSTextureGeneratorUnit, StdCtrls, Calendar, Arrow, Spin, AsyncProcess,
  Buttons, RichView, RVStyle, Gradient, SimSpin, SimButton, SSColor, process,
  Windows, AboutFormUnit, ProtectionUnit, SSNodesView;
{******************************************************************************}
type
{******************************************************************************}
  { TMainForm }
  TMainForm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label1:     TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LazGradient1: TLazGradient;
    LazGradient2: TLazGradient;
    LazGradient5: TLazGradient;
    LazGradient6: TLazGradient;
    MainMenu1:  TMainMenu;
    MenuItem1:  TMenuItem;
    MenuItem14: TMenuItem;
    MenuItemInsertAfterLightingNormalMap: TMenuItem;
    MenuItemInsertAfterLightingReliefLighting: TMenuItem;
    MenuItemInsertAfterLighting: TMenuItem;
    MenuItemInsertAfterLightingLighting: TMenuItem;
    MenuItemGenerateTurbulence: TMenuItem;
    MenuItemInsertAfterColorColorize: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItemHelp: TMenuItem;
    MenuItemTransformTwistDisort: TMenuItem;
    MenuItemTransformTwist: TMenuItem;
    MenuItemInsertAfterProjectionCubeEnvironmentMapping: TMenuItem;
    MenuItemInsertAfterProjection: TMenuItem;
    MenuItemTransformWaves: TMenuItem;
    MenuItemCut: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItemInsertAfterCombineFillAlpha: TMenuItem;
    MenuItemCopy: TMenuItem;
    MenuItemPaste: TMenuItem;
    MenuItemInsertAfterColorColorGradient: TMenuItem;
    MenuItemTransformMove: TMenuItem;
    MenuItemTransformRotate: TMenuItem;
    MenuItemTransformFractalize: TMenuItem;
    MenuItemTransform: TMenuItem;
    MenuItemInsertAfterCombineAlphaFromColor: TMenuItem;
    MenuItemInsertAfterCombineMakeAlpha: TMenuItem;
    MenuItemInsertAfterTransparency: TMenuItem;
    MenuItemInsertAfterCombineAlphaMask: TMenuItem;
    MenuItemInsertAfterCombineBlend: TMenuItem;
    MenuItemInsertAfterFilterGaussianBlur: TMenuItem;
    MenuItemInsertAfterFilter: TMenuItem;
    MenuItemInsertAfterColorChangeHSB: TMenuItem;
    MenuItemInsertAfterCombine: TMenuItem;
    MenuItemInsertAfterColor: TMenuItem;
    MenuItemGenerateSolidColor: TMenuItem;
    MenuItemGenerateNoise: TMenuItem;
    MenuItemGenerateClouds: TMenuItem;
    MenuItemGenerateCells: TMenuItem;
    MenuItemGenerateWoodRings: TMenuItem;
    MenuItem2:  TMenuItem;
    MenuItemGenerateBricks: TMenuItem;
    MenuItemGenerateGradient: TMenuItem;
    MenuItem3:  TMenuItem;
    MenuItem4:  TMenuItem;
    MenuItem5:  TMenuItem;
    MenuItem6:  TMenuItem;
    MenuItem7:  TMenuItem;
    MenuItem8:  TMenuItem;
    MenuItem9:  TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;

    MenuItemInsert:      TMenuItem;
    MenuItemInsertAfter: TMenuItem;
    MenuItemDelete:      TMenuItem;

    MenuItemInsertPrimitive: TMenuItem;
    MenuItemInsertGenerate:  TMenuItem;

    MenuItemInsertCircle: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1:      TPanel;
    Panel2:      TPanel;
    PanelLeft3:  TPanel;
    PanelLeftHeader: TPanel;
    PanelLeftHeader1: TPanel;
    PanelLeftHeader2: TPanel;
    PanelRight2: TPanel;
    PanelLeft2:  TPanel;
    PanelRight:  TPanel;
    PanelLeft:   TPanel;
    PanelScreen2: TPanel;
    PanelTop:    TPanel;

    PanelScreen: TPanel;
    PopupMenu1: TPopupMenu;
    RichView1: TRichView;
    RVStyle1: TRVStyle;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Splitter1: TSplitter;
    SplitterVertical: TSplitter;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: integer);
    procedure Image1MouseMove(Sender: TObject; X, Y: integer);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemGenerateTurbulenceClick(Sender: TObject);
    procedure MenuItemInsertAfterColorColorizeClick(Sender: TObject);
    procedure MenuItemInsertAfterLightingLightingClick(Sender: TObject);
    procedure MenuItemInsertAfterLightingNormalMapClick(Sender: TObject);
    procedure MenuItemInsertAfterLightingReliefLightingClick(Sender: TObject);
    procedure MenuItemInsertAfterProjectionCubeEnvironmentMappingClick(Sender: TObject);
    procedure MenuItemCutClick(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItemCopyClick(Sender: TObject);
    procedure MenuItemDeleteClick(Sender: TObject);
    procedure MenuItemGenerateBricksClick(Sender: TObject);
    procedure MenuItemGenerateCellsClick(Sender: TObject);
    procedure MenuItemGenerateCloudsClick(Sender: TObject);
    procedure MenuItemGenerateGradientClick(Sender: TObject);
    procedure MenuItemGenerateNoiseClick(Sender: TObject);
    procedure MenuItemGeneratePerlinNoiseClick(Sender: TObject);
    procedure MenuItemGenerateSolidColorClick(Sender: TObject);
    procedure MenuItemGenerateWoodRingsClick(Sender: TObject);
    procedure MenuItemInsertAfterColorChangeHSBClick(Sender: TObject);
    procedure MenuItemInsertAfterColorColorGradientClick(Sender: TObject);
    procedure MenuItemInsertAfterCombineFillAlphaClick(Sender: TObject);
    procedure MenuItemInsertAfterCombineAlphaFromColorClick(Sender: TObject);
    procedure MenuItemInsertAfterCombineAlphaMaskClick(Sender: TObject);
    procedure MenuItemInsertAfterCombineBlendClick(Sender: TObject);
    procedure MenuItemInsertAfterCombineMakeAlphaClick(Sender: TObject);
    procedure MenuItemInsertAfterFilterGaussianBlurClick(Sender: TObject);
    procedure MenuItemInsertCircleClick(Sender: TObject);
    procedure MenuItemPasteClick(Sender: TObject);
    procedure MenuItemTransformFractalizeClick(Sender: TObject);
    procedure MenuItemTransformMoveClick(Sender: TObject);
    procedure MenuItemTransformRotateClick(Sender: TObject);
    procedure MenuItemTransformTwistClick(Sender: TObject);
    procedure MenuItemTransformTwistDisortClick(Sender: TObject);
    procedure MenuItemTransformWavesClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    GeneratorTree: TGeneratorNodeList;

    SelectedNode, OldSelectedNode: TGeneratorNode;

    FastCall:TObjectMethod;

    copyxml:TXMLNode;

    NodesView:TNodesView;

    filename: string;

    mouseDownOffsetX:integer;
    mouseDownOffsetY:integer;
    mouseDownX:integer;
    mouseDownY:integer;
    isMouseDown:boolean;

    procedure ShowProperties;
    procedure ShowClearProperties;

    procedure NewDocument;
    procedure SaveDocument;
    procedure SaveAsDocument;
    procedure LoadDocument;
    procedure Quit;

    procedure DeleteSelected;
    procedure CopySelected;
    procedure CutSelected;
    procedure PasteSelected;

    procedure SaveToXMLFile(_filename: string);
    procedure LoadFromXMLFile(_filename: string);
  end;
{******************************************************************************}
var
  MainForm: TMainForm;
{******************************************************************************}
implementation
{******************************************************************************}
uses SSConstantsUnit, ColorSelectionFormUnit, RenderFormUnit, ConstantsUnit;
 { TMainForm }
{******************************************************************************}


{*******************************************************************************
   Management
*******************************************************************************}
procedure TMainForm.NewDocument;
var
  node: TGeneratorNode;
  r:    integer;
begin
  // Тестовое заполнение текущего проекта
  if not IsDocSaved then
  begin
    r := MessageDlg('Save file?',
      'New created file is not saved! Save it or continue edit?', mtConfirmation,
      mbYesNoCancel, 0);
    if r = mrCancel then
      exit;
    if r = mrYes then
    begin
      SaveDocument;
    end;
  end;
  ShowClearProperties;
  GeneratorTree.StopThread;
  GeneratorTree.Clear;
  node     := GeneratorTree.Add;
  node.OwnerId := -1;
  node.IsNeedChange := True;
  filename := '';
  IsDocSaved:= True;
  GeneratorTree.StartThread;

  RenderTextureWidth := 512;
  RenderTextureHeight := 512;
end;
{******************************************************************************}
procedure TMainForm.SaveAsDocument;
begin
  ShowClearProperties;
  GeneratorTree.StopThread;
  SaveDialog1.Filter   := 'Texture Gen File|*.tgx';
  SaveDialog1.Filename:=OpenSaveFilePath+'\';
  SaveDialog1.InitialDir:=OpenSaveFilePath+'\';
  if SaveDialog1.Execute then
  begin
    if not FileExists(SaveDialog1.FileName) or
      (MessageDlg('Overwrite?', 'File exists! Are you sure overwrite it?',
      mtConfirmation, mbYesNo, 0) = mrYes) then
    begin
      OpenSaveFilePath:=ExtractFilePath(SaveDialog1.FileName);
      SaveToXMLFile(UTF8ToAnsi(SaveDialog1.FileName));
      filename := SaveDialog1.FileName;
      IsDocSaved  := True;
    end;
  end;
  GeneratorTree.StartThread;
end;
{******************************************************************************}
procedure TMainForm.SaveDocument;
begin
  ShowClearProperties;
  GeneratorTree.StopThread;
  if filename = '' then
    SaveAsDocument
  else
    SaveToXMLFile(UTF8ToAnsi(filename));
  IsDocSaved := True;
  GeneratorTree.StartThread;
end;
{******************************************************************************}
procedure TMainForm.LoadDocument;
var
  r: integer;
begin
  if not IsDocSaved then
  begin
    r := MessageDlg('Save file?','New created file is not saved! Save it or continue edit?', mtConfirmation,
      mbYesNoCancel, 0);
    if r = mrCancel then exit;
    if r = mrYes then begin
      SaveDocument;
    end;
  end;
  ShowClearProperties;
  GeneratorTree.StopThread;
  OpenDialog1.Filter   := 'Texture Gen File|*.tgx';
  OpenDialog1.FileName := OpenSaveFilePath+'\';
  OpenDialog1.InitialDir:=OpenSaveFilePath+'\';
  if OpenDialog1.Execute then
  begin
    OpenSaveFilePath:=ExtractFilePath(OpenDialog1.FileName);
    LoadFromXMLFile(UTF8ToAnsi(OpenDialog1.FileName));
    filename := OpenDialog1.FileName;
    IsDocSaved  := True;
  end;
  GeneratorTree.StartThread;
end;
{******************************************************************************}
procedure TMainForm.Quit;
begin
  GeneratorTree.StopThread;
  Close;
end;
{******************************************************************************}
procedure TMainForm.SaveToXMLFile(_filename: string);
var
  xml:  TXMLNode;
  i:    integer;
  Node: TXMLNode;
  RootNode: TGeneratorNode;
begin
  xml      := TXMLNode.Create;
  RootNode := nil;
  for i := 0 to GeneratorTree.Count - 1 do
  begin
    if GeneratorTree[i].OwnerId = -1 then
      RootNode := GeneratorTree[i];
  end;
  if RootNode = nil then
    exit;
  Node      := xml.SubNodes_Add;
  Node.Name := 'TextureGenerator';
  RootNode.SetToXML(GeneratorTree, Node);
  xml.SaveToXMLFile(_filename);
  xml.Destroy;
end;
{******************************************************************************}
procedure TMainForm.LoadFromXMLFile(_filename: string);
var
  xml:  TXMLNode;
  Node: TGeneratorNode;
begin
  xml := TXMLNode.Create;
  xml.LoadFromXMLFile(_filename);
  if xml['TextureGenerator'].IsNotEmpty and xml['TextureGenerator']
    ['generator'].IsNotEmpty then
  begin
    GeneratorTree.Clear;
    node := GeneratorTree.Add;
    node.OwnerId := -1;
    node.IsNeedChange := True;
    node.SetFromXML(GeneratorTree, xml['TextureGenerator']['generator']);

    NodesView.Repaint;
  end;
  xml.Destroy;
end;
{******************************************************************************}
procedure TMainForm.ShowClearProperties;
begin
  RichView1.Visible := False;
  RichView1.Clear;
  RichView1.Format;
  RichView1.Visible := True;
end;
{******************************************************************************}
procedure TMainForm.ShowProperties;
begin
  RichView1.Visible := False;
  RichView1.Clear;
  if SelectedNode.GeneratorNodeUnit <> nil then
    SelectedNode.GeneratorNodeUnit.ShowPropertiesPage(RichView1);
  RichView1.Format;
  RichView1.Visible := True;
end;
{******************************************************************************}

{******************************************************************************}
// DELETE
procedure TMainForm.DeleteSelected;
  var
    i,r:Integer;
begin
  GeneratorTree.StopThread;
  ShowClearProperties;
  if SelectedNode <> nil then begin
    IsDocSaved:=false;
    if SelectedNode.ChildsCount=0 then begin
      if SelectedNode.GeneratorNodeUnit<>nil then begin
        SelectedNode.GeneratorNodeUnit.Destroy;
        SelectedNode.GeneratorNodeUnit:=nil;
        if SelectedNode.TextureRenderer<>nil then begin
          SelectedNode.TextureRenderer.Destroy;
          SelectedNode.TextureRenderer:=nil;
        end;
        SelectedNode.TypeId:=TG_Empty;
        SelectedNode.IsNeedChange:=true;
      end;
    end else if SelectedNode.ChildsCount=1 then begin
      if SelectedNode.GeneratorNodeUnit<>nil then begin
        GeneratorTree.Delete(SelectedNode.Id);
        SelectedNode:=nil;
      end;
    end else if SelectedNode.ChildsCount>1 then begin
      r := MessageDlg('Delete tree?','All right tree childs will be deleted. Are you sure?', mtConfirmation,mbYesNo, 0);
      if r = mrYes then begin
        if SelectedNode.GeneratorNodeUnit<>nil then begin
          GeneratorTree.DeleteTree(SelectedNode.Id);
          SelectedNode:=nil;
        end;
      end;
    end;
  end;
  GeneratorTree.IsChanged:=true;
  GeneratorTree.StartThread;
end;
{******************************************************************************}
procedure TMainForm.CopySelected;
begin
  if (SelectedNode<>nil) and (SelectedNode.GeneratorNodeUnit<>nil) then begin
    copyxml.Destroy;
    copyxml:=TXMLNode.Create;
    SelectedNode.SetToXML(GeneratorTree,copyxml);
    copyxml.IsNotEmpty:=true;
  end;
end;
{******************************************************************************}
procedure TMainForm.PasteSelected;
  var
    r:Integer;
begin
  GeneratorTree.StopThread;
  ShowClearProperties;
  if (SelectedNode <> nil) and copyxml.IsNotEmpty then begin
    if (SelectedNode.TypeId=TG_Empty) or (MessageDlg('Node is not empty. Are you sure want paste?', mtConfirmation,mbYesNo, 0)=mrYes) then begin
      GeneratorTree.DeleteRoot(SelectedNode.id);
      SelectedNode.SetType(TG_Empty);
      SelectedNode.SetFromXML(GeneratorTree,copyxml['generator']);
    end;
  end;
  GeneratorTree.IsChanged:=true;
  GeneratorTree.StartThread;
end;
{******************************************************************************}
procedure TMainForm.CutSelected;
begin
  GeneratorTree.StopThread;
  ShowClearProperties;
  if (SelectedNode <> nil) and (SelectedNode.GeneratorNodeUnit<>nil) then begin
    copyxml.Destroy;
    copyxml:=TXMLNode.Create;
    SelectedNode.SetToXML(GeneratorTree,copyxml);
    copyxml.IsNotEmpty:=true;
    GeneratorTree.DeleteRoot(SelectedNode.id);
    SelectedNode.SetType(TG_Empty);
  end;
  GeneratorTree.IsChanged:=true;
  GeneratorTree.StartThread;
end;
{******************************************************************************}

{*******************************************************************************
   События формы
*******************************************************************************}
// Create - создание класса формы
procedure TMainForm.FormCreate(Sender: TObject);
var
  node: TGeneratorNode;
begin
  // Определяем путь к программе
  path := ExtractFilePath(ParamStr(0));

  FastCall:=nil;
  DateSeparator:='.';
  DecimalSeparator  := '.';

  copyxml:=TXMLNode.Create;
  copyxml.IsNotEmpty:=false;

  RenderTextureWidth := 512;
  RenderTextureHeight := 512;

  IsDocSaved := True;

  SelectedNode    := nil;
  OldSelectedNode := nil;

  MainForm.DoubleBuffered   := True;
//  ScrollBox1.DoubleBuffered := True;
  PanelLeft.DoubleBuffered  := True;
  PanelTop.DoubleBuffered   := True;
  //  TreeView1.DoubleBuffered:=true;

  // Инициализируем дерево генератора
  GeneratorTree := TGeneratorNodeList.Create;
  //          0
  //      /        \
  //     1         2
  //   /   \     /   \
  //  3     4   5     6
  //           / \   / \
  //          11 12 13 14

  NodesView:=TNodesView.Create(Panel1);
  NodesView.GeneratorTree:=GeneratorTree;
  Panel1.InsertControl(NodesView);
  //NodesView.SetBackgroundBitmap(Image1.Picture.Bitmap);
//  NodesView.BackgroundStyle:=bsTiledAndScrolled;
  NodesView.OnMouseDown:=@Image1MouseDown;
  NodesView.OnMouseUp:=@Image1MouseUp;
  NodesView.OnMouseMove:=@Image1MouseMove;

  //ShowMessage(ExtractFileExt(paramstr(1)));
  if (trim(paramstr(1))<>'') and FileExists(paramstr(1)) and (lowercase(ExtractFileExt(paramstr(1)))='.tgx') then begin
    LoadFromXMLFile(paramstr(1));
    filename:=AnsiToUtf8(paramstr(1));
    IsDocSaved:=true;
  end else begin
    NewDocument;
  end;

  RichView1.AllowSelection := False;
  RVStyle1.Color := PanelLeft.Color;


end;
{******************************************************************************}
// Destroy - уничтожение класса формы
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  NodesView.Destroy;
  GeneratorTree.Destroy;
  copyxml.Destroy;
end;
{******************************************************************************}
// Show - Показ формы
procedure TMainForm.FormShow(Sender: TObject);
begin
  //if not CheckProgramInstallation then begin
  //  halt;
  //end;
  LoadConfig;

{  Image1.Canvas.Pen.Color   := $FFFFFF;
  Image1.Canvas.Brush.Color := $FFFFFF;
  Image1.Canvas.Rectangle(0, 0, Image1.Width, Image1.Height);}
end;
{******************************************************************************}
// Close - закрытие формы
procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
  var
    r:Integer;
begin
  if not IsDocSaved then
  begin
    r := MessageDlg('Save file?','New created file is not saved! Save it or continue edit?', mtConfirmation,mbYesNoCancel, 0);
    if r = mrCancel then begin
      CloseAction := caNone;
      exit;
    end;
    if r = mrYes then SaveDocument;
  end;
  CloseAction := caFree;
  SaveConfig;
end;
{******************************************************************************}
// Hide - Скрытие формы
procedure TMainForm.FormHide(Sender: TObject);
begin

end;
{******************************************************************************}
// Нажатие кнопки мышки на главном окне
procedure TMainForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: integer);
var
  pos:TPoint;
  Node: TGeneratorNode;
  i:    integer;
begin
  GetCursorPos(pos);
  // Проверка нажития кнопки мышки на картинках текстур
  Node := GeneratorTree.Event_HitTest(X, Y);
  //if not CheckBox1.Checked then exit;
  if Node <> nil then
  begin

    // Есть попадание в картинку выбираем её
    SelectedNode := Node;
    GeneratorTree.Selection_UnSelectAll;
    SelectedNode.IsSelected   := True;
    SelectedNode.IsNeedRender := True;
    ShowProperties;

    // если нажали правой кнопкой, то показываем меню
    if Button = mbRight then
    begin
      if Node.TypeId = 0 then
      begin
        MenuItemInsert.Visible      := True;
        MenuItemInsertAfter.Visible := False;
        MenuItemDelete.Visible      := False;
        MenuItemCopy.Visible      := False;
        MenuItemCut.Visible      := False;
      end
      else
      begin
        MenuItemInsert.Visible      := False;
        MenuItemInsertAfter.Visible := True;
        MenuItemDelete.Visible      := True;
        MenuItemCopy.Visible      := True;
        MenuItemCut.Visible      := True;
      end;

      MenuItemPaste.Visible  := copyxml.IsNotEmpty;

      PopupMenu1.PopUp;
    end;

  end else begin

    // Начинаем таскать
    isMouseDown:=true;
    mouseDownX:=pos.X;
    mouseDownY:=pos.Y;
    mouseDownOffsetX:=NodesView.GetHPos;
    mouseDownOffsetY:=NodesView.GetVPos;

  end;

end;
{******************************************************************************}
// Нажатие кнопки мышки на главном окне
procedure TMainForm.Image1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: integer);
begin
  isMouseDown:=false;

end;
// Нажатие кнопки мышки на главном окне
procedure TMainForm.Image1MouseMove(Sender: TObject;  X, Y: integer);
  var
    pos:TPoint;
begin
  GetCursorPos(pos);
  if ( isMouseDown ) then begin
    NodesView.SetVPos(mouseDownOffsetY - ( pos.Y - mouseDownY) );
    NodesView.SetHPos(mouseDownOffsetX - ( pos.X - mouseDownX) );
  end;
end;

{******************************************************************************}
// Timer - периодическое выполнение
procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  // Периодическое выполнение по таймеру
  if FastCall<>nil then begin
    FastCall();
    FastCall:=nil;
  end else GeneratorTree.FrameMove;
end;
{******************************************************************************}

{*******************************************************************************
   Вставка примитивов в дерево.

   INSERT PRIMITIVE
*******************************************************************************}
// ZCircle
procedure TMainForm.MenuItemInsertCircleClick(Sender: TObject);
begin
 if SelectedNode <> nil then begin
   SelectedNode.SetType(TG_Primitive_ZCircle);
   ShowProperties;
 end;
end;
{******************************************************************************}

{*******************************************************************************
   Эти функции вставляют в пустой лист дерева генератор.

   INSERT GENERATE
*******************************************************************************}
//
procedure TMainForm.MenuItemGenerateSolidColorClick(Sender: TObject);
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.SetType(TG_Generate_SolidColor);
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemGenerateNoiseClick(Sender: TObject);
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.SetType(TG_Generate_Noise);
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemGenerateTurbulenceClick(Sender: TObject);
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.SetType(TG_Generate_Turbulence);
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemGeneratePerlinNoiseClick(Sender: TObject);
begin

end;
//
procedure TMainForm.MenuItemGenerateGradientClick(Sender: TObject);
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.SetType(TG_Generate_Gradient);
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemGenerateBricksClick(Sender: TObject);
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.SetType(TG_Generate_Bricks);
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemGenerateWoodRingsClick(Sender: TObject);
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.SetType(TG_Generate_WoodRings);
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemGenerateCellsClick(Sender: TObject);
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.SetType(TG_Generate_Cells);
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemGenerateCloudsClick(Sender: TObject);
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.SetType(TG_Generate_Clouds);
    ShowProperties;
  end;
end;
{******************************************************************************}

{*******************************************************************************
  Эти функции вставляют в дерево комбинированные генераторы.

  INSERT AFTER
*******************************************************************************}
//
procedure TMainForm.MenuItemInsertAfterColorChangeHSBClick(Sender: TObject);
  var
    Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Color_ChangeHSB);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterColorColorGradientClick(Sender: TObject);
  var
    Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Color_ColorGradient);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterColorColorizeClick(Sender: TObject);
  var
    Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Color_Colorize);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
{******************************************************************************}
//
procedure TMainForm.MenuItemInsertAfterLightingLightingClick(Sender: TObject);
var
  Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Lighting_Lighting);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterLightingNormalMapClick(Sender: TObject);
var
  Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Lighting_NormalMap);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterLightingReliefLightingClick(
  Sender: TObject);
var
  Node, ChildNode1: TGeneratorNode;
begin
if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Lighting_ReliefLighting);
    Node.IsSelected := True;
    SelectedNode    := Node;

    Node.IsNeedChange := True;
    Node.IsNeedRender := True;

    ChildNode1 := GeneratorTree.InsertChildTreeNode(Node);
    ChildNode1.IsNeedChange := True;
    ChildNode1.IsNeedRender := True;

    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterFilterGaussianBlurClick(Sender: TObject);
var
  Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Filter_GaussianBlur);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
{******************************************************************************}
//
procedure TMainForm.MenuItemInsertAfterCombineBlendClick(Sender: TObject);
var
  Node, ChildNode1: TGeneratorNode;
begin
if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Combine_Blend);
    Node.IsSelected := True;
    SelectedNode    := Node;

    Node.IsNeedChange := True;
    Node.IsNeedRender := True;

    ChildNode1 := GeneratorTree.InsertChildTreeNode(Node);
    ChildNode1.IsNeedChange := True;
    ChildNode1.IsNeedRender := True;

    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterCombineMakeAlphaClick(Sender: TObject);
var
  Node, ChildNode1, ChildNode2: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Transparency_MakeAlpha);
    Node.IsSelected := True;
    SelectedNode    := Node;

    Node.IsNeedChange := True;
    Node.IsNeedRender := True;

    ChildNode1 := GeneratorTree.InsertChildTreeNode(Node);
    ChildNode1.IsNeedChange := True;
    ChildNode1.IsNeedRender := True;

    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterCombineAlphaFromColorClick(Sender: TObject);
var
  Node, ChildNode1, ChildNode2: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Transparency_AlphaFromColor);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterCombineFillAlphaClick(Sender: TObject);
var
  Node, ChildNode1, ChildNode2: TGeneratorNode;
begin
  if SelectedNode <> nil then begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Transparency_FillAlpha);
    Node.IsSelected := True;
    SelectedNode := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterCombineAlphaMaskClick(Sender: TObject);
var
  Node, ChildNode1, ChildNode2: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Combine_AlphaMask);
    Node.IsSelected   := True;
    SelectedNode      := Node;
    Node.IsNeedChange := True;
    Node.IsNeedRender := True;

    ChildNode1 := GeneratorTree.InsertChildTreeNode(Node);
    ChildNode1.IsNeedChange := True;
    ChildNode1.IsNeedRender := True;

    ChildNode2 := GeneratorTree.InsertChildTreeNode(Node);
    ChildNode2.IsNeedChange := True;
    ChildNode2.IsNeedRender := True;

    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemInsertAfterProjectionCubeEnvironmentMappingClick(Sender: TObject);
var
  Node, ChildNode1, ChildNode2: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Project_EnvironmentMapping);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
{******************************************************************************}
//
procedure TMainForm.MenuItemTransformFractalizeClick(Sender: TObject);
var
  Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Transform_Fractalize);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemTransformMoveClick(Sender: TObject);
var
  Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Transform_Move);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemTransformRotateClick(Sender: TObject);
var
  Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Transform_Rotate);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemTransformTwistClick(Sender: TObject);
var
  Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Transform_Twist);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemTransformTwistDisortClick(Sender: TObject);
var
  Node, ChildNode1, ChildNode2: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Transform_Distort);
    Node.IsSelected   := True;
    SelectedNode      := Node;
    Node.IsNeedChange := True;
    Node.IsNeedRender := True;

    ChildNode1 := GeneratorTree.InsertChildTreeNode(Node);
    ChildNode1.IsNeedChange := True;
    ChildNode1.IsNeedRender := True;

    ChildNode2 := GeneratorTree.InsertChildTreeNode(Node);
    ChildNode2.IsNeedChange := True;
    ChildNode2.IsNeedRender := True;

    ShowProperties;
  end;
end;
//
procedure TMainForm.MenuItemTransformWavesClick(Sender: TObject);
  var
    Node: TGeneratorNode;
begin
  if SelectedNode <> nil then
  begin
    SelectedNode.IsSelected := False;
    SelectedNode.IsNeedRender := True;
    Node := GeneratorTree.InsertTreeNode(SelectedNode);
    Node.SetType(TG_Transform_Waves);
    Node.IsSelected := True;
    SelectedNode    := Node;
    ShowProperties;
  end;
end;
{******************************************************************************}

{*******************************************************************************
  Нажатие пунктов меню
*******************************************************************************}

{******************************************************************************}
// RENDER MENU
procedure TMainForm.MenuItem14Click(Sender: TObject);
begin
  RenderForm.ShowModal;
end;
{******************************************************************************}
// NEW
procedure TMainForm.MenuItem4Click(Sender: TObject);
begin
  NewDocument;
end;
// NEW
procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  NewDocument;
end;
{******************************************************************************}
// LOAD
procedure TMainForm.MenuItem6Click(Sender: TObject);
begin
  LoadDocument;
end;
// LOAD
procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  LoadDocument;
end;
{******************************************************************************}
// SAVE
procedure TMainForm.MenuItem7Click(Sender: TObject);
begin
  SaveDocument;
end;
// SAVE
procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
  SaveDocument;
end;
// SAVE AS
procedure TMainForm.MenuItem8Click(Sender: TObject);
begin
  SaveAsDocument;
end;
{******************************************************************************}
// DELETE
procedure TMainForm.MenuItemDeleteClick(Sender: TObject);
begin
  DeleteSelected;
end;
// DELETE
procedure TMainForm.MenuItem16Click(Sender: TObject);
begin
  DeleteSelected;
end;
{******************************************************************************}
// PASTE
procedure TMainForm.SpeedButton5Click(Sender: TObject);
begin
  PasteSelected;
end;
// PASTE
procedure TMainForm.MenuItemPasteClick(Sender: TObject);
begin
  PasteSelected;
end;
// PASTE
procedure TMainForm.MenuItem13Click(Sender: TObject);
begin
  PasteSelected;
end;
{******************************************************************************}
// COPY
procedure TMainForm.MenuItem11Click(Sender: TObject);
begin
  CopySelected;
end;
// COPY
procedure TMainForm.SpeedButton6Click(Sender: TObject);
begin
  CopySelected;
end;
// COPY
procedure TMainForm.MenuItemCopyClick(Sender: TObject);
begin
  CopySelected;
end;
{******************************************************************************}
// CUT
procedure TMainForm.MenuItem12Click(Sender: TObject);
begin
  CutSelected;
end;
// CUT
procedure TMainForm.MenuItemCutClick(Sender: TObject);
begin
  CutSelected;
end;
{******************************************************************************}
// Quit
procedure TMainForm.MenuItem10Click(Sender: TObject);
begin
  Quit;
end;
// Render
procedure TMainForm.SpeedButton4Click(Sender: TObject);
begin
  RenderForm.ShowModal;
end;
// About
procedure TMainForm.MenuItemAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

{******************************************************************************}

initialization
  {$I MainFormUnit.lrs}
finalization

end.

