unit SimTrackBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TOnChange= procedure (sender:TObject) of object;
  TSimOrientation=(jtbHorizontal,jtbVertical);

  TSimTrackBar = class(TCustomControl)
  private
    FHitRect:TRect;
    FTrackRect:TRect;
    FTumbRect:TRect;
    FTumbPosition:Integer;
    FTumbMin:Integer;
    FTumbmax:Integer;
    FValue: Integer;
    FMinimum: Integer;
    FMaximum: Integer;
    FTrackColor: TColor;
    FTumbColor: TColor;
    FBackColor: TColor;
    FTumbWidth: Integer;
    FTumbHeight: Integer;
    FTrackHeight: Integer;
    FShowCaption: boolean;
    FCaptionColor: TColor;
    FTrackBorder: boolean;
    FTumbBorder: boolean;
    FBackBorder: boolean;
    FCaptionBold: boolean;
    FOrientation: TSimOrientation;
    FBackBitmap: TBitmap;

    FOnChange: TOnChange;

    canv: TCanvas;

    procedure SetMaximum(const Value: Integer);
    procedure SetMinimum(const Value: Integer);
    procedure SetValue(const Value: Integer);
    procedure SetBackColor(const Value: TColor);
    procedure SetTrackColor(const Value: TColor);
    procedure SetTumbColor(const Value: TColor);
    procedure SetTumbWidth(const Value: Integer);
    procedure SetTrackRect;
    procedure SetTumbMinMax;
    procedure SetTumbRect;
    procedure SetTumbHeight(const Value: Integer);
    procedure SetTrackHeight(const Value: Integer);
    procedure UpdatePosition;
    procedure SetOnChange(const Value: TOnChange);
    procedure UpdateValue;
    procedure SetCaptionColor(const Value: TColor);
    procedure SetShowCaption(const Value: boolean);
    procedure SetBackBorder(const Value: boolean);
    procedure SetTrackBorder(const Value: boolean);
    procedure SetTumbBorder(const Value: boolean);
    procedure SetCaptionBold(const Value: boolean);
    procedure SetOrientation(const Value: TSimOrientation);
    procedure SetBackBitmap(const Value: TBitmap);
    procedure BackBitmapChanged(sender:TObject);

    { Private declarations }
  protected
    { Protected declarations }
    procedure DoOnChange(NewValue:Integer);
    procedure MouseDown(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);override;
    procedure MouseUp(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure Resize; override;
  public
    { Public declarations }
    constructor Create (AOwner:TComponent);override;
    procedure Paint; override;
  published
    { Published declarations }
    property Min:Integer read FMinimum write SetMinimum;
    property Max:Integer read FMaximum write SetMaximum;
    property Position:Integer read FValue write SetValue;
    property Orientation:TSimOrientation read FOrientation write SetOrientation;
    property BackBitmap:TBitmap read FBackBitmap write SetBackBitmap;
    property BackColor:TColor read FBackColor write SetBackColor;
    property BackBorder:boolean read FBackBorder write SetBackBorder;
    property TrackColor:TColor read FTrackColor write SetTrackColor;
    property TrackBorder:boolean read FTrackBorder write SetTrackBorder;
    property TumbColor:TColor read FTumbColor write SetTumbColor;
    property TumbBorder:boolean read FTumbBorder write SetTumbBorder;
    property TumbWidth:Integer read FTumbWidth write SetTumbWidth;
    property TumbHeight:Integer read FTumbHeight write SetTumbHeight;
    property TrackHeight:Integer read FTrackHeight write SetTrackHeight;
    property ShowCaption:boolean read FShowCaption write SetShowCaption;
    property CaptionColor:TColor read FCaptionColor write SetCaptionColor;
    property CaptionBold:boolean read FCaptionBold write SetCaptionBold;
    property OnChange:TOnChange read FOnChange write SetOnChange;
  end;

implementation

constructor TSimTrackBar.Create(AOwner: TComponent);
begin
  inherited;
  width:=150;
  height:=24;
  FOrientation:=jtbHorizontal;
  FTrackHeight:=6;
  FTumbWidth:=20;
  FTumbHeight:=16;
  FBackColor:=clsilver;
  FTrackColor:=clgray;
  FTrackBorder:=true;
  FTumbColor:=clsilver;
  FCaptioncolor:=clblack;
  FShowCaption:=true;
  FMinimum:=0;
  FMaximum:=100;
  FValue:=0;
  FBackBitmap := TBitmap.Create;
  FBackBitmap.OnChange := BackBitmapChanged;
end;

procedure TSimTrackBar.Paint;
var
  R:TRect;
  s:string;

 function ClipMapRect(r:TRect):TRect;
 begin
   result.Left:=r.Left-Canvas.ClipRect.Left;
   result.Top:=r.Top-Canvas.ClipRect.Top;
   result.Right:=r.Right-Canvas.ClipRect.Left;
   result.Bottom:=r.Bottom-Canvas.ClipRect.Top;
 end;

{ procedure DrawBackBitmap;
  var
    ix, iy: Integer;
    BmpWidth, BmpHeight: Integer;
    hCanvas, BmpCanvas: THandle;
    bm: Tbitmap;
  begin
    bm := FBackBitmap;
    begin
      BmpWidth := bm.Width;
      BmpHeight := bm.Height;
      BmpCanvas := bm.Canvas.Handle;
      hCanvas := THandle(canvas.handle);
      for iy := 0 to ClientHeight div BmpHeight do
        for ix := 0 to ClientWidth div BmpWidth do
          BitBlt(hCanvas, ix * BmpWidth, iy * BmpHeight,
            BmpWidth, BmpHeight, BmpCanvas,
            0, 0, SRCCOPY);
    end;
  end; }


  procedure DrawBackGround;
  begin
    canv.pen.style:=psSolid;
    canv.brush.style:=bsSolid;
    canv.pen.color:=FBackColor;
    canv.brush.color:=FBackColor;
    canv.Rectangle(ClipMapRect(Rect(0,0,Width,Height)));
  end;

  procedure DrawTrack;
    var
      r:TRect;
  begin
    r:=ClipMapRect(FTrackRect);
    canv.brush.color:=FTrackColor;
    canv.FillRect(r);
    canv.pen.style:=pssolid;
  end;

  procedure DrawTumb;
    var
      r:TRect;
  begin
    r:=ClipMapRect(FTumbRect);
    canv.brush.color:=$5f5f5f;
    canv.FillRect(r);
    canv.pen.style:=pssolid;
    canv.pen.Color:=FTumbColor;
    canv.Rectangle(r);
  end;

  var
    buffer: TBitmap;

begin

  SetTumbMinMax;
  SetTumbRect;
  SetTrackRect;

  buffer := TBitmap.Create;
  buffer.Width := Canvas.ClipRect.Right-Canvas.ClipRect.Left+1;
  buffer.Height := Canvas.ClipRect.Bottom-Canvas.ClipRect.Top+1;
  canv:=buffer.Canvas;

//  if assigned(FBackBitmap) and (FBackBitmap.Height <> 0) and (FBackBitmap.Width <> 0) then
//    DrawBackBitmap
//  else

  DrawBackground;
  DrawTrack;
  DrawTumb;

  Canvas.Draw(Canvas.ClipRect.Left, Canvas.ClipRect.Top, buffer);
  buffer.Free;
end;


procedure TSimTrackBar.UpdateValue;
begin
  FValue:=round(FMinimum+(FTumbPosition-FTumbMin)/(FTumbMax-FTumbMin)*(FMaximum-FMinimum));
end;

procedure TSimTrackBar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if (ssleft in shift) then begin
    case Orientation of
      jtbHorizontal: FTumbPosition:=x;
      jtbVertical  : FTumbPosition:=y;
    end;
    if FTumbPosition<FTumbMin then FTumbPosition:=FTumbMin;
    if FTumbPosition>FTumbMax then FTumbPosition:=FTumbMax;
    UpdateValue;
    SetTumbRect;
    invalidate;
    DoOnChange(FValue);
  end;
end;

procedure TSimTrackBar.MouseDown(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  if (ssleft in shift) then
    if ptinRect(FHitRect,point(x,y)) then
    begin
      case Orientation of
        jtbHorizontal: FTumbPosition:=x;
        jtbVertical  : FTumbPosition:=y;
      end;
      if FTumbPosition<FTumbMin then FTumbPosition:=FTumbMin;
      if FTumbPosition>FTumbMax then FTumbPosition:=FTumbMax;
      UpdateValue;
      SetTumbRect;
      invalidate;
      DoOnChange(FValue);
    end;
end;

procedure TSimTrackBar.MouseUp(Button: TMouseButton;Shift:TShiftState;X,Y:Integer);
begin


end;

procedure TSimTrackBar.SetTumbMinMax;
begin
  case Orientation of
  jtbHorizontal:
    begin
      FTumbMin:=5+(FTumbwidth div 2);
      FTumbMax:=Width-FTumbMin;
    end;
  jtbVertical:
    begin
      FTumbMin:=5+(FTumbHeight div 2);
      FTumbMax:=Height-FTumbMin;
    end;
  end;
end;

procedure TSimTrackBar.SetTrackRect;
var dy,dx:Integer;
begin
  case Orientation of
  jtbHorizontal:
  begin
    dy:=(height-FTrackHeight) div 2;
    FTrackRect:=Rect(FTumbMin,dy,FTumbMax,height-dy);
    FHitRect:=FTrackrect;
    inflateRect(FHitRect,0,(FTumbHeight-FTrackHeight) div 2);
  end;
  jtbVertical:
  begin
    dx:=(Width-FTrackHeight) div 2;
    FTrackRect:=Rect(dx,FTumbMin,Width-dx,FTumbMax);
    FHitRect:=FTrackrect;
    inflateRect(FHitRect,(FTumbWidth-FTrackHeight) div 2,0);
  end;
  end;
end;

procedure TSimTrackBar.SetTumbRect;
var dx,dy:Integer;
begin
  case Orientation of
  jtbHorizontal:
    begin
      dx:=FTumbWidth div 2;
      dy:=(height-FTumbHeight) div 2;
      FTumbrect:=Rect(FTumbPosition-dx,dy,FTumbPosition+dx,height-dy);
    end;
  jtbVertical:
    begin
      dy:=FTumbHeight div 2;
      dx:=(Width-FTumbWidth) div 2;
      FTumbrect:=Rect(dx,FTumbPosition-dy,Width-dx,FTumbPosition+dy);
    end;
  end;
end;

procedure TSimTrackBar.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  invalidate;
end;

procedure TSimTrackBar.SetMaximum(const Value: Integer);
begin
  if value>FMinimum then
  begin
    FMaximum := Value;
    if FValue>FMaximum then
      FValue:=FMaximum;
    UpdatePosition;
  end;
end;

procedure TSimTrackBar.SetMinimum(const Value: Integer);
begin
  if value<FMaximum then
  begin
    FMinimum := Value;
    if FValue<FMinimum then
      FValue:=FMinimum;
    UpdatePosition;
  end;
end;

procedure TSimTrackBar.UpdatePosition;
var fac:extended;
begin
  if (FMaximum-FMinimum) <> 0 then fac:=(FValue-FMinimum)/(FMaximum-FMinimum)
                              else fac:=0;
  FTumbPosition:=FTumbMin+round((FTumbMax-FTumbMin)*fac);
  invalidate;
  //Repaint;
end;

procedure TSimTrackBar.SetTrackColor(const Value: TColor);
begin
  FTrackColor := Value;
  invalidate;
end;

procedure TSimTrackBar.SetTumbColor(const Value: TColor);
begin
  FTumbColor := Value;
  invalidate;
end;

procedure TSimTrackBar.SetValue(const Value: Integer);
begin
  FValue := Value;
  if (FValue<FMinimum) then FValue:=FMinimum;
  if (FValue>FMaximum) then FValue:=FMaximum;
  UpdatePosition;
  invalidate;
end;



procedure TSimTrackBar.SetTumbWidth(const Value: Integer);
begin
  FTumbWidth := Value;
  SetTumbMinMax;
  SetTumbrect;
  SetTrackRect;
  invalidate;
end;

procedure TSimTrackBar.SetTumbHeight(const Value: Integer);
begin
  if value<height then
  begin
    FTumbHeight := Value;
    SetTumbMinMax;
    SetTumbrect;
    SetTrackrect;
    invalidate;
  end;
end;

procedure TSimTrackBar.SetTrackHeight(const Value: Integer);
begin
  case Orientation of
  jtbHorizontal:
  begin
    if value<(Height) then
    begin
    FTrackHeight := Value;
    setTrackrect;
    invalidate;
    end;
  end;
  jtbVertical:
  begin
    if value<(Width) then
    begin
    FTrackHeight := Value;
    setTrackrect;
    invalidate;
    end;
  end;
  end;
end;

procedure TSimTrackBar.SetOnChange(const Value: TOnChange);
begin
  FOnChange := Value;
end;

procedure TSimTrackBar.DoOnChange(NewValue: Integer);
begin
  if assigned(OnChange) then OnChange(self);
end;

procedure TSimTrackBar.Resize;
begin
  inherited;
  SetTumbMinMax;
  SetTrackRect;
  UpdatePosition;
end;

procedure TSimTrackBar.SetCaptionColor(const Value: TColor);
begin
  FCaptionColor := Value;
  invalidate;
end;

procedure TSimTrackBar.SetShowCaption(const Value: boolean);
begin
  FShowCaption := Value;
  invalidate;
end;

procedure TSimTrackBar.SetBackBorder(const Value: boolean);
begin
  FBackBorder := Value;
  invalidate
end;

procedure TSimTrackBar.SetTrackBorder(const Value: boolean);
begin
  FTrackBorder := Value;
  invalidate
end;

procedure TSimTrackBar.SetTumbBorder(const Value: boolean);
begin
  FTumbBorder := Value;
  invalidate;
end;

procedure TSimTrackBar.SetCaptionBold(const Value: boolean);
begin
  FCaptionBold := Value;
  invalidate;
end;

procedure TSimTrackBar.SetOrientation(const Value: TSimOrientation);
var tmp:Integer;
begin
    FOrientation:= Value;
    if (csDesigning in ComponentState) then
    begin
    tmp:=width;
    width:=height;
    height:=tmp;
    tmp:=FTumbWidth;
    FTumbWidth:=FTumbheight;
    FTumbHeight:=tmp;
    end;
    invalidate;
end;

procedure TSimTrackBar.SetBackBitmap(const Value: TBitmap);
begin
  FBackBitmap.assign(Value);
end;

procedure TSimTrackBar.BackBitmapChanged(sender: TObject);
begin
  invalidate;
end;

end.
