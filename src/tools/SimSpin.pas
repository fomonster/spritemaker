unit SimSpin;

{$mode objfpc}{$H+}

interface

uses

  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, ExtCtrls, RichView, ConstantsUnit,StdCtrls,
  spin, SimButton,SimTrackbar;

type

  TObjectMethod=procedure of object;

  TButtonOnPanel = class(TSimButton)

    public
    IsCallback:boolean;

    pclick:TProcedureOfObject;

    constructor Create(AOwner: TComponent); override;
    procedure Click; override;

  end;

  TToggleButtonOnPanel = class(TSimButton)

    public
    IsCallback:boolean;

    ptoggleon:TProcedureOfObject;
    ptoggleoff:TProcedureOfObject;


    constructor Create(AOwner: TComponent); override;

    procedure MouseDown(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);override;

    procedure OnToggleOn;override;
    procedure OnToggleOff;override;

  end;

  TSpinEditOnPanel = class(TSpinEdit)
    public
    IsCallback:boolean;
    pchange:TProcedureOfObject;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Change; override;
    procedure SetValue(v:integer);
    procedure GetValue(var v:integer);
    procedure SetChangeCallback(method:TObjectMethod);
  end;

  TFloatSpinEditOnPanel = class(TFloatSpinEdit)
  public
    IsCallback:boolean;
    pchange:TProcedureOfObject;
    constructor Create(AOwner: TComponent); override;
    procedure Change; override;
    procedure SetValue(v:Single);
    procedure GetValue(var v:Single);
    procedure SetChangeCallback(method:TObjectMethod);
  end;

  TTrackBarOnPanel = class(TSimTrackBar)
  public
    IsCallback:boolean;
    pchange:TProcedureOfObject;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Change(Sender: TObject);
    procedure SetValue(v:Integer);
    procedure GetValue(var v:Integer);
    procedure SetChangeCallback(method:TObjectMethod);
  end;

  TImageOnPanel = class(TImage)
  public
    IsCallback:boolean;
    pchange:TProcedureOfObject;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Change(Sender: TObject);
    procedure SetChangeCallback(method:TObjectMethod);
  end;

  TComboBoxOnPanel = class(TComboBox)
  public
    IsCallback:boolean;
    pchange:TProcedureOfObject;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure Change(Sender: TObject);
    procedure SetValue(v:Integer);
    procedure GetValue(var v:Integer);
    procedure SetChangeCallback(method:TObjectMethod);
  end;

procedure AddLabel(RichView1:TRichView;width,fontsize:Integer;fontname,caption:String);
function MergeIntegerInput(RichView1:TRichView;min,max,value,width:Integer;center:Boolean;onchange:TProcedureOfObject):TSpinEditOnPanel;
function MergeFloatInput(RichView1:TRichView;min,max,value:Single;width:Integer;center:Boolean;onchange:TProcedureOfObject):TFloatSpinEditOnPanel;
function MergeTrackbar(RichView1:TRichView;min,max,value:Integer;width:Integer;center:Boolean;onchange:TProcedureOfObject):TTrackBarOnPanel;
function MergeImage(RichView1:TRichView;width,height:Integer;center:Boolean;onchange:TProcedureOfObject):TImageOnPanel;
function MergeButton(RichView1:TRichView;caption:String;width:Integer;onclick:TProcedureOfObject):TButtonOnPanel;
function MergeComboBox(RichView1:TRichView;width:Integer;center:Boolean;onchange:TProcedureOfObject):TComboBoxOnPanel;
function AddButton(RichView1:TRichView;caption:String;width:Integer;onclick:TProcedureOfObject):TButtonOnPanel;
procedure AddTittle(RichView1:TRichView;caption:String);

procedure AddField(RichView:TRichView;name:String;var spe:TSpinEditOnPanel;var speTB:TTrackBarOnPanel;min,max,value:Integer;onchange,onchangeTB:TProcedureOfObject);

implementation

  Uses MainFormUnit, RVStyle;

//******************************************************************************
// TButtonOnPanel
constructor TButtonOnPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IsCallback:=false;
  Width := 150;
  Height := 20;
  Caption := '';
  SetStyle(sbsGray);
  Toggle:=false;
 // TabStop := False;
 // Align:=alTop;
end;

procedure TButtonOnPanel.Click;
begin
  //Application.MessageBox('Yes, it works!','Demo', MB_OK or MB_ICONEXCLAMATION);
  if pclick <> nil then begin
{    while AppForm.nextproc <> nil do begin
      Application.ProcessMessages;
    end;}
    pclick;
  end;
end;

//******************************************************************************
// TToggleButtonOnPanel
constructor TToggleButtonOnPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IsCallback:=false;
  Width := 150;
  Height := 20;
  Caption := '';
  SetStyle(sbsGray);
  Toggle:=true;
  ptoggleon:=nil;
  ptoggleoff:=nil;
end;

procedure TToggleButtonOnPanel.MouseDown(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
end;

procedure TToggleButtonOnPanel.OnToggleOn;
begin
  if ptoggleon<>nil then begin
    ptoggleon;
  end;
end;

procedure TToggleButtonOnPanel.OnToggleOff;
begin
  if ptoggleoff<>nil then begin
    ptoggleoff;
  end;
end;

//******************************************************************************
// TSpinEditOnPanel
constructor TSpinEditOnPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  pchange:=nil;
  IsCallback:=false;
  Width := 150;
  Height := 20;
  Caption := '';
end;

destructor TSpinEditOnPanel.Destroy;
begin
  pchange:=nil;
  IsCallback:=false;
  inherited;
end;

procedure TSpinEditOnPanel.Change;
begin
  if self=nil then exit;
  if Assigned(pchange) and IsCallback then pchange;
end;

procedure TSpinEditOnPanel.SetValue(v:Integer);
  var
    ptmp:procedure of object;
begin
  if self=nil then exit;
  ptmp:=pchange;
  pchange:=nil;
  IsCallback:=false;
  Value:=v;
  IsCallback:=true;
  pchange:=ptmp;
end;

procedure TSpinEditOnPanel.GetValue(var v:Integer);
  var
    ptmp:procedure of object;
begin
  if self=nil then exit;
  v:=Value;
end;

procedure TSpinEditOnPanel.SetChangeCallback(method:TObjectMethod);
begin
  if self=nil then exit;
  pchange:=method;
end;

//******************************************************************************
// TFloatSpinEditOnPanel
constructor TFloatSpinEditOnPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 150;
  Height := 20;
  Caption := '';
  pchange:=nil;
  IsCallback:=false;
end;

procedure TFloatSpinEditOnPanel.Change;
begin
  if self=nil then exit;
  if (pchange<>nil)and IsCallback then pchange;
end;

procedure TFloatSpinEditOnPanel.SetValue(v:Single);
  var
    ptmp:procedure of object;
begin
  if self=nil then exit;
  ptmp:=pchange;
  pchange:=nil;
  IsCallback:=false;
  Value:=v;
  IsCallback:=true;
  pchange:=ptmp;
end;

procedure TFloatSpinEditOnPanel.GetValue(var v:Single);
  var
    ptmp:procedure of object;
begin
  if self=nil then exit;
  v:=Value;
end;

procedure TFloatSpinEditOnPanel.SetChangeCallback(method:TObjectMethod);
begin
  if self=nil then exit;
  pchange:=method;
end;

//******************************************************************************
// TTrackBarOnPanel
constructor TTrackBarOnPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  pchange:=nil;
  OnChange:=@Change;
  Width := 250;
  Height := 20;
  Caption := '';
  IsCallback:=true;
end;

destructor TTrackBarOnPanel.Destroy;
begin
  pchange:=nil;
  OnChange:=nil;
  IsCallback:=false;
  inherited;
end;

procedure TTrackBarOnPanel.Change(Sender: TObject);
begin
  if self=nil then exit;
  if Assigned(pchange) and IsCallback then pchange;
end;

procedure TTrackBarOnPanel.SetValue(v:Integer);
  var
    ptmp:TNotifyEvent;
begin
  if self=nil then exit;
  ptmp:=OnChange;
  IsCallback:=false;
  OnChange:=nil;
  Position:=v;
  IsCallback:=true;
  OnChange:=ptmp;
end;

procedure TTrackBarOnPanel.GetValue(var v:Integer);
  var
    ptmp:TNotifyEvent;
begin
  if self=nil then exit;
  ptmp:=OnChange;
  OnChange:=nil;
  v:=Position;
  OnChange:=ptmp;
end;

procedure TTrackBarOnPanel.SetChangeCallback(method:TObjectMethod);
begin
  if self=nil then exit;
  pchange:=method;
end;

//******************************************************************************
// TImageOnPanel
constructor TImageOnPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  pchange:=nil;
  OnClick:=@Change;
  Width := 250;
  Height := 20;
  Caption := '';
  IsCallback:=true;
end;

destructor TImageOnPanel.Destroy;
begin
  pchange:=nil;
  OnClick:=nil;
  IsCallback:=false;
  inherited;
end;

procedure TImageOnPanel.Change(Sender: TObject);
begin
  if self=nil then exit;
  if Assigned(pchange) and IsCallback then pchange;
end;

procedure TImageOnPanel.SetChangeCallback(method:TObjectMethod);
begin
  if self=nil then exit;
  pchange:=method;
end;

//******************************************************************************
// ComboBOX
constructor TComboBoxOnPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  pchange:=nil;
  OnClick:=nil;
  IsCallback:=false;
  OnChange:=@Change;
end;

destructor TComboBoxOnPanel.Destroy;
begin
  inherited;
end;

procedure TComboBoxOnPanel.Change(Sender: TObject);
begin
  if self=nil then exit;
  if Assigned(pchange) and IsCallback then pchange;
end;

procedure TComboBoxOnPanel.SetValue(v:integer);
  var
    ptmp:TNotifyEvent;
    i:Integer;
begin
  if self=nil then exit;
  ptmp:=OnChange;
  IsCallback:=false;
  OnChange:=nil;
  //TODO:  for i:=0 to Items.Count-1 do
    //TODO:if Items.Objects[i]=v then ItemIndex:=i;
  IsCallback:=true;
  OnChange:=ptmp;
end;

procedure TComboBoxOnPanel.GetValue(var v:Integer);
  var
    ptmp:TNotifyEvent;
begin
  if self=nil then exit;
  ptmp:=OnChange;
  OnChange:=nil;
  //TODO:v:=integer(Items.Objects[ItemIndex]);
  OnChange:=ptmp;
end;

procedure TComboBoxOnPanel.SetChangeCallback(method:TObjectMethod);
begin
  if self=nil then exit;
  pchange:=method;
end;

// Adding Components to RichView
procedure AddLabel(RichView1:TRichView;width,fontsize:Integer;fontname,caption:String);
  var
    lab:TLabel;
begin
  lab:=TLabel.Create(RichView1);
  lab.Caption:=caption;
  lab.Font.Size:=fontsize;
  lab.Font.Name:=fontname;
  lab.AutoSize:=false;
  lab.Width:=width;
  RichView1.AddControl(lab,false);
end;

function MergeIntegerInput(RichView1:TRichView;min,max,value,width:Integer;center:Boolean;onchange:TProcedureOfObject):TSpinEditOnPanel;
begin
  result:=TSpinEditOnPanel.Create(RichView1);
  result.IsCallback:=false;
  result.MinValue:=min;
  result.MaxValue:=max;
  result.Value:=value;
  result.Width := width;
  result.pchange:=onchange;
  RichView1.MergeControl(result,center);
  Result.IsCallback:=true;
end;

function MergeFloatInput(RichView1:TRichView;min,max,value:Single;width:Integer;center:Boolean;onchange:TProcedureOfObject):TFloatSpinEditOnPanel;
begin
  result:=TFloatSpinEditOnPanel.Create(RichView1);
  result.IsCallback:=false;
  result.MinValue:=min;
  result.MaxValue:=max;
  result.Value:=value;
  result.Width := width;
  result.pchange:=onchange;
  RichView1.MergeControl(result,center);
  result.IsCallback:=true;
end;

function MergeTrackbar(RichView1:TRichView;min,max,value:Integer;width:Integer;center:Boolean;onchange:TProcedureOfObject):TTrackBarOnPanel;
begin
  result:=TTrackBarOnPanel.Create(RichView1);
  result.IsCallback:=false;
  result.Min:=min;
  result.Max:=max;
  result.Position:=value;
  result.Width := width;
  result.pchange:=onchange;
  RichView1.MergeControl(result,center);
  result.IsCallback:=true;
end;

function AddButton(RichView1:TRichView;caption:String;width:Integer;onclick:TProcedureOfObject):TButtonOnPanel;
begin
  result:=TButtonOnPanel.Create(RichView1);
  result.Caption:=caption;
  result.pclick:=onclick;
  if width>0 then result.Width:=width;
  RichView1.AddControl(result, true);
end;

function MergeButton(RichView1:TRichView;caption:String;width:Integer;onclick:TProcedureOfObject):TButtonOnPanel;
begin
  result:=TButtonOnPanel.Create(RichView1);
  result.Caption:=caption;
  result.pclick:=onclick;
  if width>0 then result.Width:=width;
  RichView1.MergeControl(result, false);
end;

procedure AddTittle(RichView1:TRichView;caption:String);
begin
  RichView1.AddBreakLine($00A44531,2);
  RichView1.AddFromNewLine(' '+Trim(caption), rvsKeyword);
end;

function MergeImage(RichView1:TRichView;width,height:Integer;center:Boolean;onchange:TProcedureOfObject):TImageOnPanel;
begin
  result:=TImageOnPanel.Create(RichView1);
  result.IsCallback:=false;
  result.Width := width;
  result.pchange:=onchange;
  RichView1.MergeControl(result,center);
  result.IsCallback:=true;
end;

function MergeComboBox(RichView1:TRichView;width:Integer;center:Boolean;onchange:TProcedureOfObject):TComboBoxOnPanel;
begin
  result:=TComboBoxOnPanel.Create(RichView1);
  result.IsCallback:=false;
  result.Width := width;
  result.pchange:=onchange;
  RichView1.MergeControl(result,center);
  result.IsCallback:=true;
end;

procedure AddField(RichView:TRichView;name:String;var spe:TSpinEditOnPanel;var speTB:TTrackBarOnPanel;min,max,value:Integer;onchange,onchangeTB:TProcedureOfObject);
begin
  AddLabel(RichView,80,10,'Arial',name);
  speTB:=MergeTrackbar(RichView,min,max,0,280,true,onchangeTB);
  spe:=MergeIntegerInput(RichView,min,max,0,80,true,onchange);
  speTB.SetValue(value);
  spe.SetValue(value);
end;

end.
