unit SimButton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, graphics, LCLType,LResources,
  LCLIntf ,Buttons, Dialogs, Types;

  
type

TSimButtonStyle = (sbsNormal,sbsYellow,sbsSim, sbsGray);

PSimButtonToggleCollector = ^TSimButtonToggleCollector;
TSimButtonToggleCollector = class;

PSimButton = ^TSimButton;
TSimButton = class(TCustomControl)

  private

    FButtonId:Integer;
    FToggleCollector:TSimButtonToggleCollector;
    FToggleCollectorIndex:Integer;
    FToggleGroupIndex:Integer;
    FToggleIndex:Integer;
    FDoToggle:boolean;
    FToggle:boolean;
    FFocused:boolean;
    FLeftTopColor:TColor;
    FLeftTopDownColor:TColor;
    FLeftTopOverColor:TColor;
    FRightBottomColor:TColor;
    FRightBottomDownColor:TColor;
    FRightBottomOverColor:TColor;
    FBaseColor:TColor;
    FDownColor:TColor;
    FOverColor:TColor;
    FFontColor:TColor;

    FDown:Boolean;
    FOver:Boolean;

    FStyle:TSimButtonStyle;

    procedure Gradient(ColorFrom,ColorTo:TColor);

  protected
  

  public

    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;

    procedure Paint; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);override;
    procedure MouseUp(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);override;
    procedure MouseMove(Shift: TShiftState;X, Y: Integer); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    function  GetBackground : TCanvas;
    procedure Click; override;
    procedure Resize; override;
    function Focused: Boolean; override;
    procedure SetFocus;override;
    procedure SetStyle(_style:TSimButtonStyle);
    procedure SetFontColor(c:TColor);
    procedure SetBaseColor(c:TColor);
    procedure SetDownColor(c:TColor);
    procedure SetOverColor(c:TColor);
    procedure SetLeftTopColor(c:TColor);
    procedure SetLeftTopDownColor(c:TColor);
    procedure SetLeftTopOverColor(c:TColor);
    procedure SetRightBottomColor(c:TColor);
    procedure SetRightBottomDownColor(c:TColor);
    procedure SetRightBottomOverColor(c:TColor);
    procedure AssignCollector(_collector:TSimButtonToggleCollector);


  published

    procedure OnToggleOn;virtual;
    procedure OnToggleOff;virtual;
//    property OnToggleOn;
//    property OnToggleOff;
    property Action;
    property Anchors;
    property Align;
    property Enabled;
    property Font;
    property Visible;
    property OnClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property TabOrder;
    property TabStop;
//    property NormalBlend : Extended read FNormalBlend write SetNormalBlend;
//    property OverBlend : Extended read FOverBlend write SetOverBlend;
    //property Caption: TCaption read GetText write SetText;
    property Id: Integer read FButtonId write FButtonId;
    property Down: Boolean read FDown write FDown;
    property FontColor: TColor read FFontColor write SetFontColor;
    property BaseColor: TColor read FBaseColor write SetBaseColor;
    property DownColor: TColor read FDownColor write SetDownColor;
    property OverColor: TColor read FOverColor write SetOverColor;
    property LeftTopColor: TColor read FLeftTopColor write SetLeftTopColor;
    property LeftTopDownColor: TColor read FLeftTopDownColor write SetLeftTopDownColor;
    property LeftTopOverColor: TColor read FLeftTopOverColor write SetLeftTopOverColor;
    property RightBottomColor: TColor read FRightBottomColor write SetColor;
    property RightBottomDownColor: TColor read FRightBottomDownColor write SetRightBottomDownColor;
    property RightBottomOverColor: TColor read FRightBottomOverColor write SetRightBottomOverColor;
    property Toggle: boolean read FToggle write FToggle;
    property ToggleIndex: Integer read FToggleIndex write FToggleIndex;
    property ToggleGroupIndex: Integer read FToggleGroupIndex write FToggleGroupIndex;

end;

{******************************************************************************}
//


PSimButtonLink = ^TSimButtonLink;
TSimButtonLink = class
  button:TSimButton; // ������ �� ������

  constructor Create;
  destructor Destroy;

end;

PSimButtonLinkArray = ^TSimButtonLinkArray;
TSimButtonLinkArray = array [0..0] of TSimButtonLink;

TCollectorProcedureClick = procedure (ButtonI:TSimButton) of Object;

TSimButtonToggleCollector = class

private
  buttonlinkarray:PSimButtonLinkArray;

public

  OnBtnsClick:TCollectorProcedureClick;

  count:Integer;

  constructor Create;
  destructor Destroy;

  function Get(index:Integer):TSimButtonLink;
  procedure Put(index:Integer;const value:TSimButtonLink);

  procedure Clear;
  procedure SetLength(NewLength:Integer);

  function Add:TSimButtonLink;
  function Insert(index:Integer):TSimButtonLink;
  function Push:TSimButtonLink;
  procedure Pop;
  procedure Delete(index:Integer);

  property item[index : Integer]:TSimButtonLink read Get;default;

  // Button special functions
  
  procedure OnButtonsClick(Button:TSimButton);
  procedure AllAnotherToggleButtonsDoUp(_groupindex,_index:Integer;calltoggleoff:boolean);

end;
  

implementation

//  USes SimMenuFormUnit;

constructor TSimButton.Create(AOwner: TComponent);
begin
  inherited;
  FDoToggle:=false;
  FOver:=false;
  FDown:=false;
  Caption:='';
  FToggle:=false;
  FToggleGroupIndex:=-1;
  FToggleIndex:=-1;
  FToggleCollector:=nil;
  SetStyle(sbsSim);
end;

destructor TSimButton.Destroy;
begin
  if FToggleCollector<>nil then begin
    FToggleCollector.Delete(FToggleCollectorIndex);
  end;
  inherited;
end;

procedure TSimButton.SetFontColor(c:TColor);begin FFontColor:=c;end;
procedure TSimButton.SetBaseColor(c:TColor);begin FBaseColor:=c;end;
procedure TSimButton.SetDownColor(c:TColor);begin FDownColor:=c;end;
procedure TSimButton.SetOverColor(c:TColor);begin FOverColor:=c;end;
procedure TSimButton.SetLeftTopColor(c:TColor);begin FLeftTopColor:=c;end;
procedure TSimButton.SetLeftTopDownColor(c:TColor);begin FLeftTopDownColor:=c;end;
procedure TSimButton.SetLeftTopOverColor(c:TColor);begin FLeftTopOverColor:=c;end;
procedure TSimButton.SetRightBottomColor(c:TColor);begin FRightBottomColor:=c;end;
procedure TSimButton.SetRightBottomDownColor(c:TColor);begin FRightBottomDownColor:=c;end;
procedure TSimButton.SetRightBottomOverColor(c:TColor);begin FRightBottomOverColor:=c;end;

procedure TSimButton.SetStyle(_style:TSimButtonStyle);
begin
  if _style = sbsNormal then begin
    FFontColor:=clBlack;
    FBaseColor:=clBtnFace;
    FDownColor:=clBtnFace;
    FOverColor:=clBtnFace;
    FLeftTopColor:=clBtnHiLight;
    FLeftTopDownColor:=clBtnShadow;
    FLeftTopOverColor:=clBtnHiLight;
    FRightBottomColor:=clBtnShadow;
    FRightBottomDownColor:=clBtnHiLight;
    FRightBottomOverColor:=clBtnShadow;
  end else if _style = sbsYellow then begin
    FFontColor:=clBlack;
    FBaseColor:=clBtnFace;
    FDownColor:=clYellow;
    FOverColor:=clBtnFace;
    FLeftTopColor:=clBtnHiLight;
    FLeftTopDownColor:=clBtnShadow;
    FLeftTopOverColor:=clBtnHiLight;
    FRightBottomColor:=clBtnShadow;
    FRightBottomDownColor:=clBtnHiLight;
    FRightBottomOverColor:=clBtnShadow;
  end else if _style = sbsGray then begin
    FFontColor:=clBlack;
    FBaseColor:= $C6C6C6;
    FDownColor:=$B6B6B6;
    FOverColor:=$CFCFCF;
    FLeftTopColor:=$8F8F8F;
    FLeftTopDownColor:=$303030;
    FLeftTopOverColor:=$8F8F8F;
    FRightBottomColor:=$8F8F8F;
    FRightBottomDownColor:=$303030;
    FRightBottomOverColor:=$8F8F8F;
  end else if _style = sbsSim then begin
    FFontColor:=clBlack;
    FBaseColor:=$00E1CBBD;
    FDownColor:=$00ECDFD7;
    FOverColor:=$00E4D1C5;
    FLeftTopColor:=$0057DFEE;
    FLeftTopDownColor:=clBtnShadow;
    FLeftTopOverColor:=$0078E6F1;
    FRightBottomColor:=$0057DFEE;
    FRightBottomDownColor:=clBtnHiLight;
    FRightBottomOverColor:=$0078E6F1;
  end;// else if style = sbsYellow then begin
//         end;
end;

function TSimButton.Focused: Boolean;
begin
  FFocused:=FFocused OR (Inherited Focused);
  Result := FFocused;
end;

procedure TSimButton.SetFocus;
begin
  inherited;
  if Parent.Visible then Repaint;
end;

procedure TSimButton.MouseEnter;
begin
  FOver:=true;
  inherited;
  if Parent.Visible then Repaint;
end;

procedure TSimButton.MouseLeave;
begin
  FOver:=false;
  if not FToggle then FDown:=false;
  inherited;
  if Parent.Visible then Repaint;
end;

procedure TSimButton.OnToggleOn;
begin

end;

procedure TSimButton.OnToggleOff;
begin

end;

procedure TSimButton.MouseDown(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
 try
  if FToggle then begin
    if not FDown then begin
      FDown:=True;
      FDoToggle:=true;
      if FToggleCollector<>nil then begin
        FToggleCollector.AllAnotherToggleButtonsDoUp(FToggleGroupIndex,FToggleIndex,true);
        FToggleCollector.OnButtonsClick(self);
      end else OnToggleOn;
    end else begin
{      FDown:=False;
      if FToggleCollector<>nil then begin
        FToggleCollector.OnButtonsClick(self);
      end else OnToggleOff;}
    end;
  end else begin
    FDown:=true;
  end;
  if Parent.Visible then Repaint;
  inherited;
 except
   On E : exception do begin
//    Form2.Memo1.Lines.Add('Runtime error! TSimButton.MouseDown ('+E.ClassName+' - '+E.Message+')');

  end;
 end;
end;

procedure TSimButton.MouseUp(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
 try
  if FToggle then begin
    if FDown then
    if FDoToggle then FDoToggle:=false
    else begin
      FDown:=False;
      if FToggleCollector<>nil then begin
        FToggleCollector.OnButtonsClick(self);
      end else OnToggleOff;
    end;
  end else begin
    FDown:=false;
    if FToggleCollector<>nil then begin
      FToggleCollector.OnButtonsClick(self);
    end;
  end;
  if Parent.Visible then Repaint;
  inherited;
 except
   On E : exception do begin
//    Form2.Memo1.Lines.Add('Runtime error! TSimButton.MouseDown ('+E.ClassName+' - '+E.Message+')');

  end;
 end;
end;

procedure TSimButton.MouseMove(Shift: TShiftState;X, Y: Integer);
begin

  inherited;
end;

procedure TSimButton.DoEnter;
begin
  FFocused:=true;
  inherited;
  if Parent.Visible then Repaint;
end;

procedure TSimButton.DoExit;
begin
  FFocused:=false;
  inherited;
  if Parent.Visible then Repaint;
end;

procedure TSimButton.KeyUp(var Key: Word; Shift: TShiftState);
begin

  inherited;
end;

function  TSimButton.GetBackground : TCanvas;
begin

  inherited;
end;

procedure TSimButton.Click;
begin
  inherited;
end;

procedure TSimButton.Resize;
begin

  inherited;
end;

procedure TSimButton.Gradient(ColorFrom,ColorTo:TColor);
var
  A1,A2,A3,B1,B2,B3:Integer;
  I : Integer; { color band index }
  R : Byte; { a color band's R value }
  G : Byte; { a color band's G value }
  B : Byte; { a color band's B value }
begin
  A1 := GetRValue (ColorToRGB (ColorFrom));
  A2 := GetGValue (ColorToRGB (ColorFrom));
  A3 := GetBValue (ColorToRGB (ColorFrom));
  { calculate difference of from and to RGB values}
  B1 := GetRValue (ColorToRGB (ColorTo));
  B2 := GetGValue (ColorToRGB (ColorTo));
  B3 := GetBValue (ColorToRGB (ColorTo));
  for i:=0 to Canvas.Height-1 do
    with Canvas do begin
      Pen.Color:=RGB(A1-(A1-B1)*i div Canvas.Height, A2-(A2-B2)*i div Canvas.Height, A3-(A3-B3)*i div Canvas.Height);
      Rectangle(0,I,Canvas.Width-1,I+1);
    end;
end;

procedure TSimButton.Paint;
  var
    TextSize : TSize;
begin
  if Visible then begin

    Canvas.Font.Color := Font.Color;
    Canvas.Font := Font;

    Canvas.Brush.Style:=bsSolid;

    Width := Self.Width;
    Height := Self.Height;


    // �������� �������
    if FDown then begin
//      Canvas.Pen.Color:=FDownColor;
//      Canvas.Brush.Color:=FDownColor;
//      Canvas.Rectangle(1,1,Width-1,Height-1);
      Gradient($CFCFCF,$9F9F9F);

      Canvas.Pen.Color:=FLeftTopDownColor;
      Canvas.MoveTo(Width-1,0);
      Canvas.LineTo(0,0);
      Canvas.LineTo(0,Height-1);

      Canvas.Pen.Color:=FRightBottomDownColor;
      Canvas.MoveTo(Width-1,0);
      Canvas.LineTo(Width-1,Height-1);
      Canvas.LineTo(0,Height-1);
    end else if FOver then begin
//      Canvas.Pen.Color:=FOverColor;
//      Canvas.Brush.Color:=FOverColor;
//      Canvas.Rectangle(1,1,Width-1,Height-1);
      Gradient($EFEFEF,$BFBFBF);

      Canvas.Pen.Color:=FLeftTopOverColor;
      Canvas.MoveTo(Width-1,0);
      Canvas.LineTo(0,0);
      Canvas.LineTo(0,Height-1);

      Canvas.Pen.Color:=FRightBottomOverColor;
      Canvas.MoveTo(Width-1,0);
      Canvas.LineTo(Width-1,Height-1);
      Canvas.LineTo(0,Height-1);
    end else begin
//      Canvas.Pen.Color:=FBaseColor;
//      Canvas.Brush.Color:=FBaseColor;
//      Canvas.Rectangle(1,1,Width-1,Height-1);
      Gradient($DFDFDF,$AFAFAF);

      Canvas.Pen.Color:=FLeftTopColor;
      Canvas.MoveTo(Width-1,0);
      Canvas.LineTo(0,0);
      Canvas.LineTo(0,Height-1);

      Canvas.Pen.Color:=FRightBottomColor;
      Canvas.MoveTo(Width-1,0);
      Canvas.LineTo(Width-1,Height-1);
      Canvas.LineTo(0,Height-1);
    end;

    if Caption<>'' then begin
      Canvas.Font.Color:=FFontColor;
      Canvas.Brush.Style:=bsClear;
      TextSize:=Canvas.TextExtent(Caption);
      if FDown
      then Canvas.TextOut((Width-TextSize.cx) div 2+1,(Height-TextSize.cy) div 2+1,Caption)
      else Canvas.TextOut((Width-TextSize.cx) div 2,(Height-TextSize.cy) div 2,Caption);
    end;

    if FFocused then begin
      Canvas.DrawFocusRect(RECT(3,3,Width-3,Height-3));
    end;

  end;
  inherited Paint;
end;

procedure TSimButton.AssignCollector(_collector:TSimButtonToggleCollector);
begin
  FToggleCollector:=_collector;
  FToggleCollectorIndex:=FToggleCollector.count;
  with FToggleCollector.Add do begin
    button:=self;
  end;
end;
{******************************************************************************}
// TSimButtonLink

constructor TSimButtonLink.Create;
begin
  button:=nil;
end;

destructor TSimButtonLink.Destroy;
begin
  button:=nil;
end;

{******************************************************************************}
// TSimButtonToggleCollector
constructor TSimButtonToggleCollector.Create;
begin
  count:=0;
  buttonlinkarray:=nil;
end;

destructor TSimButtonToggleCollector.Destroy;
begin
  Clear;
end;

function TSimButtonToggleCollector.Get(index:Integer):TSimButtonLink;
begin
  if (buttonlinkarray<>nil) and (index>=0) and (index<count)
    then result:=buttonlinkarray^[index]
    else result:=nil;
end;

procedure TSimButtonToggleCollector.Put(index:Integer;const value:TSimButtonLink);
begin
  if (index>=0) and (index<count)
    then buttonlinkarray^[index]:=value;
end;

procedure TSimButtonToggleCollector.Clear;
  var
    i:Integer;
begin
  for i:=0 to count-1 do
    buttonlinkarray^[i].Destroy;
  count:=0;
  Freemem(buttonlinkarray);
  buttonlinkarray:=nil;
end;

procedure TSimButtonToggleCollector.SetLength(NewLength:Integer);
  var
    i:Integer;
begin
  if NewLength = count then exit;
  if NewLength > 0 then begin
    if NewLength < count then begin
      for i:=NewLength to count-1 do
        buttonlinkarray^[i].Destroy;
    end;
    ReAllocMem(buttonlinkarray,sizeof(TSimButtonLink) * NewLength);
    if NewLength > count then begin
      for i:=count to NewLength-1 do
        buttonlinkarray^[i]:=TSimButtonLink.Create;
    end;
    count:=NewLength;
  end else begin
    Clear;
  end;
end;

function TSimButtonToggleCollector.Add:TSimButtonLink;
begin
  SetLength(count+1);
  Result:=buttonlinkarray^[count-1];
end;

function TSimButtonToggleCollector.Insert(index:Integer):TSimButtonLink;
  var
    i:Integer;
begin
  if (index>=0) and (index<=count) then begin
    ReAllocMem(buttonlinkarray,sizeof(TSimButtonLink) * (count+1));
    if index < count then begin
      System.Move(buttonlinkarray^[index],buttonlinkarray^[index+1],(count-index)*sizeof(TSimButtonLink));
    end;
    buttonlinkarray^[index]:=TSimButtonLink.Create;
    inc(count);
    result:=buttonlinkarray^[index];
  end else result:=nil;
end;

function TSimButtonToggleCollector.Push:TSimButtonLink;
begin
  SetLength(count+1);
  Result:=buttonlinkarray^[count-1];
end;

procedure TSimButtonToggleCollector.Pop;
begin
  Delete(count-1);
end;

procedure TSimButtonToggleCollector.Delete(index:Integer);
begin
  if (index>=0) and (index<count) then begin
    buttonlinkarray^[index].Destroy;
    if index < count-1 then begin
      System.Move(buttonlinkarray^[index+1],buttonlinkarray^[index],(count-index-1)*sizeof(TSimButtonLink));
    end;
    dec(count);
    ReAllocMem(buttonlinkarray,sizeof(TSimButtonLink) * count);
  end;
end;

procedure TSimButtonToggleCollector.AllAnotherToggleButtonsDoUp(_groupindex,_index:Integer;calltoggleoff:boolean);
  var
    i:Integer;
begin
 try
  for i:=0 to count-1 do begin
    if (self[i].button<>nil) then begin
      if (self[i].button.ToggleGroupIndex=_groupindex) and (self[i].button.FToggleIndex<>_index) then begin
        if Self[i].button.FDown and Self[i].button.FToggle then begin
          self[i].button.FDown:=false;
          if calltoggleoff then
            self[i].button.OnToggleOff;
          if Self[i].button.Parent.Visible then self[i].button.Repaint;
        end;
      end;
    end;
  end;
 except
   On E : exception do begin
    //Form2.Memo1.Lines.Add('Runtime error! TSimButtonToggleCollector.AllAnotherToggleButtonsDoUp ('+E.ClassName+' - '+E.Message+')');

   end;
 end;
end;

procedure TSimButtonToggleCollector.OnButtonsClick(Button:TSimButton);
begin
 try
  if OnBtnsClick<>nil then OnBtnsClick(Button);
  if Button.FDown then begin
     Button.OnToggleOn;
  end else begin
     Button.OnToggleOff;
  end;
 except
   On E : exception do begin
//    Form2.Memo1.Lines.Add('Runtime error! TSimButtonToggleCollector.OnButtonsClick ('+E.ClassName+' - '+E.Message+')');
   end;
 end;
end;

{******************************************************************************}

end.

