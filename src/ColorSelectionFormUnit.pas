unit ColorSelectionFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Spin, Buttons, Grids, ColorBox, Gradient, RGBGraphics,
  SSColor, Windows, Math, SSConstantsUnit;

type

  { TColorSelectionForm }

  TColorSelectionForm = class(TForm)
    Button1: TButton;
    Edit1:   TEdit;
    Image1:  TImage;
    Image2:  TImage;
    Label2:  TLabel;
    Label3:  TLabel;
    Label4:  TLabel;
    LazGradient3: TLazGradient;
    LazGradient4: TLazGradient;
    Panel4:  TPanel;
    Panel5:  TPanel;
    Panel6:  TPanel;
    Panel7:  TPanel;
    Panel8:  TPanel;
    Panel9:  TPanel;
    PanelLeftHeader1: TPanel;
    PanelLeftHeader2: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseLeave(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

    CurrentH,CurrentS,CurrentL:Single;

    IsLeftMouseDown:boolean;
    SelectedFigure:Integer;
    ColorMode:Integer;

    hcx, hcy, hcr1, hcr2,ytop,ybottom,xleft,xright,xcenter,ycenter,LWidth,LHeight: integer;
    bitmap: TBitmap;

    rbm: TRGB32BitMap;

    SelectedColor,LastColor:TRGBAColor;

    pchange:TProcedureOfObject;

    procedure DrawHueCircle;

    procedure DrawHUERing(image: TRGB32BitMap; cx, cy, r1, r2, S, L: single);

    procedure DrawHUETriangle(image: TRGB32BitMap; cx, cy, r, H: single);

    function HitTestRing(x,y:Integer;applyfirst:boolean;var newH:Single):boolean;
    function HitTestTriangle(x,y:Integer;applyfirst:boolean;var newS,newL:Single):boolean;

    procedure PaintImage;



  end;

var
  ColorSelectionForm: TColorSelectionForm;

implementation

procedure TColorSelectionForm.DrawHUERing(image: TRGB32BitMap; cx, cy, r1, r2, S, L: single);
var
  x, y: integer;
  c:    TRGBAColor;
  H, r, dx, dy, r12, r12l, r22, r22l, a, b: single;
  cc:   DWord;
begin
  r12  := r1 * r1;
  r12l := (r1 + 2) * (r1 + 2);
  b    := (r1 + r1 + 2) / 2;
  r22  := r2 * r2;
  r22l := (r2 - 2) * (r2 - 2);
  a    := (r2 + r2 - 2) / 2;

  for y := hcy - hcr1 - 5 to hcy + hcr1 + 5 do
  begin
    for x := hcx - hcr1 - 5 to hcx + hcr1 + 5 do
    begin
      dx := (x - cx);
      dy := (y - cy);
      r  := dx * dx + dy * dy;
      if r >= r22l then
      begin
        if r > r22 then
        begin
          if r < r12 then
          begin
            H := 360 * arctan2(dy, dx) / (PI * 2);
            c.SetHUE(H, L, S);
            c.a := 1;
            image.Get32PixelPtr(x, y)^ := c.GetDWARGB;
          end
          else
          begin
            if r < r12l then
            begin
              r:=sqrt(r);
              if r > b then begin
                cc := round(200 * (r-b));
                image.Get32PixelPtr(x, y)^ := (cc shl 8) or (cc shl 16) or cc;
              end else begin

                H := 360 * arctan2(dy, dx) / (PI * 2);
                c.SetHUE(H, L, S);
                c.MulC(b-r);
                c.a:=1;
                image.Get32PixelPtr(x, y)^ := c.GetDWARGB;
              end;
            end;
          end;
        end
        else
        begin
          r:=sqrt(r);
          if r>a then begin

            H := 360 * arctan2(dy, dx) / (PI * 2);
            c.SetHUE(H, L, S);
            c.MulC(r-a);
            c.a:=1;
            image.Get32PixelPtr(x, y)^ := c.GetDWARGB;

          end else begin
            cc := round(200 *(a-r));
            image.Get32PixelPtr(x, y)^ := (cc shl 8) or (cc shl 16) or cc;
          end;
        end;
      end;
    end;
  end;

end;

procedure TColorSelectionForm.DrawHUETriangle(image: TRGB32BitMap; cx, cy, r, H: single);
  var
    y,x:Integer;
    tlx,trx,dx,dS,sZ,S,L,d:Single;
    c: TRGBAColor;
    cc: DWord;
begin
  ytop:=round(cy-r);
  ybottom:=round(cy-r*cos(2*PI/3));
  xcenter:=round(cx);
  ycenter:=round(cy);
  xleft:=round(cx+r*sin(-2*PI/3));
  xright:=round(cx+r*sin(2*PI/3));
  if ybottom<=ytop then exit;
  ds:=1/(ybottom-ytop);
  sZ:=(xright-cx);
  dx:=sZ*ds;
  tlx:=cx; trx:=cx;
  S:=0;
  for y:=ytop to ybottom do begin
    S :=1-(y-ytop)/(ybottom-ytop);
    for x:=round(tlx)-2 to round(trx)+2 do begin
      if x>=tlx-1 then begin
        if x<tlx then begin
          cc := round(200 *(tlx-x));
          image.Pixels[x + image.Width * y] := (cc shl 8) or (cc shl 16) or cc;
        end else begin
          if (x<=tlx+1) and (tlx<>trx) then begin
            L := (x-xleft)/(2*sZ);
            c.SetHUE(H, L, S);
            c.MulC(1-(tlx+1-x));
            c.a:=1;
            image.Get32PixelPtr(x, y)^ := c.GetDWARGB;
          end else begin
            if x<trx-1 then begin
              L := (x-xleft)/(2*sZ);
              c.SetHUE(H, L, S);
              c.a:=1;
              image.Get32PixelPtr(x, y)^ := c.GetDWARGB;
            end else begin
              if x<=trx then begin
                L := (x-xleft)/(2*sZ);
                c.SetHUE(H, L, S);
                c.MulC(trx-x);
                c.a:=1;
                image.Get32PixelPtr(x, y)^ := c.GetDWARGB;
              end else begin
                if x<=trx+1 then begin
                  cc := round(200 *(1-(trx+1-x)));
                  image.Get32PixelPtr(x, y)^ := (cc shl 8) or (cc shl 16) or cc;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    tlx:=tlx-dx;
    trx:=trx+dx;
  end;
  image.Canvas.OutlineColor:=0;
  image.Canvas.Line(xleft,ybottom+1,xright,ybottom+1);
end;

procedure TColorSelectionForm.DrawHueCircle;
var
  x, y: integer;
  r:    single;
  c:    TRGBAColor;
begin
  //if (LWidth<>Image1.Width) or (LHeight<>Image1.Height) then begin

    if rbm<>nil then rbm.Destroy;

    rbm := TRGB32BitMap.Create(Image1.Width, Image1.Height);

    hcx  := Image1.Width div 2;
    hcy  := Image1.Height div 2;
    hcr1 := hcx-10;
    hcr2 := hcr1-20;

    rbm.Canvas.DrawMode  := TDrawMode.dmFillAndOutline;

    rbm.Canvas.FillColor := $afafaf;
    rbm.Canvas.FillRect(0, 0, Image1.Width, Image1.Height);

    rbm.Canvas.OutlineColor := $000000;
    rbm.Canvas.FillColor    := $afafaf;

    if hcr2>0 then begin
      DrawHUERing(rbm, hcx, hcy, hcr1, hcr2,CurrentS,CurrentL);

      DrawHUETriangle(rbm, hcx, hcy, hcr2-10,CurrentH);
    end;

    LWidth:=Image1.Width;
    LHeight:=Image1.Height;
 // end;
  PaintImage;

end;

procedure TColorSelectionForm.PaintImage;
  var
    x,y:Integer;
    lx,ly,dx,cH:Single;
    c,a,b:TRGBAColor;
    r:TRect;
begin
  rbm.Canvas.DrawTo(Image1.Canvas, 0, 0);

  // Метка CurrentH
  Image1.Canvas.Pen.Color:=0;
  Image1.Canvas.Pen.Width:=1;
  Image1.Canvas.AntialiasingMode:=amOn;
  Image1.Canvas.MoveTo(round(hcr2*cos(CurrentH*PI/180))+xcenter,round(hcr2*sin(CurrentH*PI/180))+ycenter);
  Image1.Canvas.LineTo(round(hcr1*cos(CurrentH*PI/180))+xcenter,round(hcr1*sin(CurrentH*PI/180))+ycenter);

  // Метка CurrentS,CurrentL
  x:=round(CurrentL*(2*(xright-xcenter))+xleft);
  y:=round((1-CurrentS)*(ybottom-ytop)+ytop);
  dx:=(1-CurrentS)*(xright-xcenter);///(xbottom-xtop);
  if x<xcenter-dx then x:=round(xcenter-dx);
  if x>xcenter+dx then x:=round(xcenter+dx);

  Image1.Canvas.Pen.Color:=0;
  Image1.Canvas.Pen.Width:=1;
  Image1.Canvas.Brush.Style:=bsClear;
  Image1.Canvas.AntialiasingMode:=amOn;
  Image1.Canvas.Ellipse(x-4,y-4,x+4,y+4);
  Image1.Repaint;


  cH:=CurrentH; while cH<0 do cH:=cH+360;

  c.SetHUE(CurrentH,CurrentL,CurrentS);
  c.a:=0;

  SelectedColor:=c;
  if not CompareMem(@SelectedColor,@LastColor,sizeof(TRGBAColor)) then begin
    if pchange<>nil then pchange;
    LastColor:=SelectedColor;
  end;

  {$R-}
  {$Q-}
  Image2.Canvas.Pen.Color:=c.GetDWABGR;
  Image2.Canvas.Brush.Color:=c.GetDWABGR;
  Image2.Canvas.Rectangle(0,0,Image2.Width,Image2.Height);
  Image2.Repaint;

  Edit1.Caption:=IntToHex(c.GetDWABGR,6);
  {$Q+}
  {$R+}


{  ImageR.Canvas.Pen.Color:=0;
  ImageR.Canvas.Brush.Color:=$AFAFAF;
  ImageR.Canvas.Rectangle(0,0,ImageR.Width-1,ImageR.Height);
  a:=c; b:=c; a.r:=0; b.r:=1;
  r.Top:=1; r.Left:=1; r.Right:=ImageR.Width-2; r.Bottom:=ImageR.Height-1;
  ImageR.Canvas.GradientFill(r,a.GetDWABGR,b.GetDWABGR,gdHorizontal);

  ImageG.Canvas.Pen.Color:=0;
  ImageG.Canvas.Brush.Color:=$AFAFAF;
  ImageG.Canvas.Rectangle(0,0,ImageG.Width-1,ImageG.Height);
  a:=c; b:=c; a.g:=0; b.g:=1;
  r.Top:=1; r.Left:=1; r.Right:=ImageG.Width-2; r.Bottom:=ImageG.Height-1;
  ImageG.Canvas.GradientFill(r,a.GetDWABGR,b.GetDWABGR,gdHorizontal);

  ImageB.Canvas.Pen.Color:=0;
  ImageB.Canvas.Brush.Color:=$AFAFAF;
  ImageB.Canvas.Rectangle(0,0,ImageB.Width-1,ImageB.Height);
  a:=c; b:=c; a.b:=0; b.b:=1;
  r.Top:=1; r.Left:=1; r.Right:=ImageB.Width-2; r.Bottom:=ImageB.Height-1;
  ImageB.Canvas.GradientFill(r,a.GetDWABGR,b.GetDWABGR,gdHorizontal);

  ImageH.Canvas.Pen.Color:=0;
  ImageH.Canvas.Brush.Color:=$AFAFAF;
  ImageH.Canvas.Rectangle(0,0,ImageH.Width-1,ImageH.Height);
  ImageH.Canvas.Pen.Color:=$FFFFFF;
  ImageH.Canvas.Brush.Color:=$FFFFFF;
  if CurrentH<0 then cH:=360+CurrentH
  else cH:=CurrentH;
//  ImageH.Canvas.Rectangle(1,1,round((ImageH.Width-2)*cH/360+1),ImageH.Height-1);

  ImageS.Canvas.Pen.Color:=0;
  ImageS.Canvas.Brush.Color:=$AFAFAF;
  ImageS.Canvas.Rectangle(0,0,ImageS.Width-1,ImageS.Height);
  a.SetHUE(CurrentH,CurrentL,0);
  b.SetHUE(CurrentH,CurrentL,1);
  r.Top:=1; r.Left:=1; r.Right:=ImageB.Width-2; r.Bottom:=ImageB.Height-1;
  ImageS.Canvas.GradientFill(r,a.GetDWABGR,b.GetDWABGR,gdHorizontal);

  ImageL.Canvas.Pen.Color:=0;
  ImageL.Canvas.Brush.Color:=$AFAFAF;
  ImageL.Canvas.Rectangle(0,0,ImageL.Width-1,ImageL.Height);
  a.SetHUE(CurrentH,0,CurrentS);
  b.SetHUE(CurrentH,1,CurrentS);
  r.Top:=1; r.Left:=1; r.Right:=ImageL.Width-2; r.Bottom:=ImageL.Height-1;
  ImageL.Canvas.GradientFill(r,a.GetDWABGR,b.GetDWABGR,gdHorizontal);}
end;

function TColorSelectionForm.HitTestRing(x,y:Integer;applyfirst:boolean;var newH:Single):boolean;
  var
    r2:Single;
begin
  r2:=(x-xcenter)*(x-xcenter)+(y-ycenter)*(y-ycenter);
  if (r2>=hcr2*hcr2) and (r2<=hcr1*hcr1) then begin
    result:=true;
  end else result:=false;
  if result or applyfirst then begin
    newH:=360 *arctan2((y-ycenter),(x-xcenter)) / (PI * 2);
  end;
end;

function TColorSelectionForm.HitTestTriangle(x,y:Integer;applyfirst:boolean;var newS,newL:Single):boolean;
  var
    lfx,rtx,dx,t:Single;
begin
  result:=false;
  if not ((y<ytop) or (y>ybottom) or (ybottom<=ytop)) then begin
    dx:=(y-ytop)*(xright-xcenter)/(ybottom-ytop);
    lfx:=xcenter-dx;
    rtx:=xcenter+dx;
    result:=not (x<lfx) or (x>rtx);
  end;
  if result or applyfirst then begin
    if x<xleft then newL:=0
    else if x>xright then newL:=1
    else newL := (x-xleft)/(2*(xright-xcenter));

    if y<ytop then newS:=1
    else if y>ybottom then newS:=0
    else newS :=1-(y-ytop)/(ybottom-ytop);

    t:=0.5*(1-newS);
    if newL<0.5-t then newL:=0.5-t;
    if newL>0.5+t then newL:=0.5+t;
  end;
end;
{ TColorSelectionForm }

procedure TColorSelectionForm.FormShow(Sender: TObject);
begin
  SelectedColor.GetHUE(CurrentH,CurrentL,CurrentS);
  DrawHueCircle;
end;

procedure TColorSelectionForm.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var
    newH,newL,newS:Single;
begin
  IsLeftMouseDown:=true;
  //
  if ColorMode=0 then begin

    if HitTestRing(X,Y,false,CurrentH) then begin
//      Caption:='H='+FloatToStr(CurrentH);
      SelectedFigure:=1;

      DrawHUETriangle(rbm,xcenter,ycenter, hcr2-10, CurrentH);
      PaintImage;

    end else if HitTestTriangle(X,Y,false,CurrentS,CurrentL) then begin
//      Caption:='S='+FloatToStr(CurrentS)+' L='+FloatToStr(CurrentL);
      SelectedFigure:=2;

      DrawHUERing(rbm, hcx, hcy, hcr1, hcr2,CurrentS,CurrentL);

      PaintImage;

    end else begin
      SelectedFigure:=0;
    end;

  end;
end;

procedure TColorSelectionForm.Image1MouseLeave(Sender: TObject);
begin
  IsLeftMouseDown:=false;
  //
  if ColorMode=0 then begin

  end;
end;

procedure TColorSelectionForm.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if IsLeftMouseDown then begin
    //
    if ColorMode=0 then begin

      if SelectedFigure=1 then begin

        HitTestRing(X,Y,true,CurrentH);
//        Caption:='H='+FloatToStr(CurrentH);
        DrawHUETriangle(rbm,xcenter,ycenter, hcr2-10, CurrentH);
        PaintImage;

      end else if SelectedFigure=2 then begin

        HitTestTriangle(X,Y,true,CurrentS,CurrentL);
//        Caption:='S='+FloatToStr(CurrentS)+' L='+FloatToStr(CurrentL);
        DrawHUERing(rbm, hcx, hcy, hcr1, hcr2,CurrentS,CurrentL);
        PaintImage;

      end;

    end;

  end;
end;

procedure TColorSelectionForm.Image1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsLeftMouseDown:=false;
  //
  if ColorMode=0 then begin

  end;
end;

procedure TColorSelectionForm.SpeedButton3Click(Sender: TObject);
begin

  Close;
end;

procedure TColorSelectionForm.FormCreate(Sender: TObject);
begin
  rbm:=nil;
  ColorMode:=0;
  CurrentH:=0;
  CurrentS:=1;
  CurrentL:=0.5;

  DoubleBuffered:=true;
  Panel8.DoubleBuffered:=true;
  Panel9.DoubleBuffered:=true;

  pchange:=nil;
  LastColor.Eqv(0,0,0,0);
end;

procedure TColorSelectionForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TColorSelectionForm.FormDestroy(Sender: TObject);
begin
  if rbm<>nil then rbm.Destroy;
end;

initialization
  {$I ColorSelectionFormUnit.lrs}

end.

