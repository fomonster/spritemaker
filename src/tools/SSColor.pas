{*******************************************************************************

  Проект: SpaceSim
  Автор: Фомин С.С.
  Дата: 2009 год

  Назначение модуля:


*******************************************************************************}
unit SSColor;

interface

  uses  math, SysUtils, SSConstantsUnit;
{******************************************************************************}

type

{******************************************************************************}
PRGBAColor=^TRGBAColor;
TRGBAColor = packed object
  r,g,b,a:Single;
  procedure Eqv(_r,_g,_b,_a:Single);
  procedure SetHUE(H, L, S:Single); // H=(-360..360) L,S=(-100..100)
  procedure GetHUE(var H, L, S:Single); // H=(-360..360) L,S=(-100..100)
  function GetDWBGR:DWord;
  function GetDWABGR:DWord;
  procedure SetDWABGR(dwc:DWord);
  function GetDWARGB:DWord;
  function GetDWB:DWord;

  function GetLighting:Single;

  function iR:Integer;
  function iG:Integer;
  function iB:Integer;
  function iA:Integer;

  procedure Add(c:TRGBAColor);
  procedure MulC(k:Single);
  procedure Blend(c:TRGBAColor);overload;
  procedure Blend(c:TRGBAColor;alpha:Single);overload;
end;

PRGBAColorArray = ^TRGBAColorArray;
TRGBAColorArray = array [0..10000000] of TRGBAColor;

PRGBAGradientPoint = ^TRGBAGradientPoint;
TRGBAGradientPoint = packed object
  color:TRGBAColor;
  h:Single;
  f1,f2,f3,f4:Single;
  procedure Eqv(_h,_r,_g,_b,_a:Single);

end;

PRGBAGradientPointArray = ^TRGBAGradientPointArray;
TRGBAGradientPointArray = array [0..10000000] of TRGBAGradientPoint;

TRGBAGradient = class
private
  RGBAGradientPointArray:PRGBAGradientPointArray;
public
  count:Integer;

  constructor Create;
  destructor Destroy;

  function Get(index:Integer):PRGBAGradientPoint;
  procedure Put(index:Integer;const value:TRGBAGradientPoint);
  procedure Clear;
  procedure SetLength(NewLength:Integer);

  procedure Add(h,r,g,b,a:Single);overload;
  procedure Add(h:Single;c:Cardinal);overload;
  procedure Add(h:Single;_c:TRGBAColor);overload;
  procedure Add(h,r,g,b,a,f1:Single);overload;
  procedure Add(h,r,g,b,a,f1,f2,f3,f4:Single);overload;

  procedure Sort;

  function GetColor(h:Single):TRGBAColor;
  function GetPoint(h:Single):TRGBAGradientPoint;

  property item[index : Integer]:PRGBAGradientPoint read Get;default;

end;

function HLStoRGB(hue,light,satur:Single):TRGBAColor;

implementation

{******************************************************************************}
procedure TRGBAColor.Eqv(_r,_g,_b,_a:Single);
begin
  r:=_r;
  g:=_g;
  b:=_b;
  a:=_a;
end;


function TRGBAColor.iR:Integer;
begin
  if r<0 then result:=0 else if r>1 then result:=255 else result:=round(r*255);
end;

function TRGBAColor.iG:Integer;
begin
  if g<0 then result:=0 else if g>1 then result:=255 else result:=round(g*255);
end;

function TRGBAColor.iB:Integer;
begin
  if b<0 then result:=0 else if b>1 then result:=255 else result:=round(b*255);
end;

function TRGBAColor.iA:Integer;
begin
  if a<0 then result:=0 else if a>1 then result:=255 else result:=round(a*255);
end;

procedure TRGBAColor.SetHUE(H, L, S:Single); // H=(-360..360) L,S=(-0..1)

function valore(n1,n2,hue:Single):Single;
begin
  if hue<0 then hue:=hue+360;
  if hue>360 then hue:=hue-360;
  if hue>=240 then result:=n1
  else if hue<60 then result:=n1+(n2-n1)*hue/60
  else if hue<180 then result:=n2
  else result:=n1+(n2-n1)*(240-hue)/60;
end;

  var
    cr,cg,cb,m1,m2,ih,il,isa : Single;
begin
  if l<0.5 then m2:=l*(1+s)
  else m2:=l+s*(1-l);
  m1:=2*l-m2;
  if (s=0) then begin
    r:=l; g:=l; b:=l;
  end else begin
    r:=valore(m1,m2,h+120);
//    if r<0 then r:=0; if r>1 then r:=1;
    g:=valore(m1,m2,h);
//    if g<0 then g:=0; if g>1 then g:=1;
    b:=valore(m1,m2,h-120);
//    if b<0 then b:=0; if b>1 then b:=1;
  end;
end;

procedure TRGBAColor.GetHUE(var H, L, S:Single); // H=(-360..360) L,S=(-100..100)
 var
   kmin,kmax,delta:Single;
begin
  kmin:=r;
  if g<kmin then kmin:=g;
  if b<kmin then kmin:=b;
  kmax:=r;
  if g>kmax then kmax:=g;
  if b>kmax then kmax:=b;
  l:=(kmin+kmax)/2;
  if kmin=kmax then begin
    s:=0; h:=0;
  end else begin
    if l<=0.5 then s:=(kmax-kmin)/(kmax+kmin)
    else s:=(kmax-kmin)/(2-kmax-kmin);
    delta:=kmax-kmin;
    if kmax=r then h:=(g-b)/delta;
    if kmax=g then h:=2+(b-r)/delta;
    if kmax=b then h:=4+(r-g)/delta;
    h := h*60;
    if h<0 then h:=h+360;
  end;
end;

//
function TRGBAColor.GetDWARGB:DWord;
  var
    irr,igg,ibb,iaa:DWord;
begin
  if r<0 then r:=0; if r>1 then r:=1;
  if g<0 then g:=0; if g>1 then g:=1;
  if b<0 then b:=0; if b>1 then b:=1;
  if a<0 then a:=0; if a>1 then a:=1;
  {$R-}
  irr:=round(r*255) shl 16; igg:=round(g*255) shl 8; ibb:=round(b*255); iaa:=round(a*255) shl 24;
  {$R+}
  result:=irr or igg or ibb or iaa;
end;

procedure TRGBAColor.SetDWABGR(dwc:DWord);
begin
  r:=(dwc and 255)/255;
  g:=((dwc shr 8) and 255)/255;
  b:=((dwc shr 16) and 255)/255;
  a:=((dwc shr 24) and 255)/255;
end;

function TRGBAColor.GetDWABGR:DWord;
  var
    irr,igg,ibb,iaa:DWord;
begin
  if r<0 then r:=0; if r>1 then r:=1;
  if g<0 then g:=0; if g>1 then g:=1;
  if b<0 then b:=0; if b>1 then b:=1;
  if a<0 then a:=0; if a>1 then a:=1;
  {$R-}
  {$Q-}
  irr:=round(b*255) shl 16; igg:=round(g*255) shl 8; ibb:=round(r*255); iaa:=round(a*255) shl 24;
  result:=irr or igg or ibb or iaa;
  {$Q+}
  {$R+}
end;

function TRGBAColor.GetDWBGR:DWord;
  var
    irr,igg,ibb,iaa:DWord;
begin
  if r<0 then r:=0; if r>1 then r:=1;
  if g<0 then g:=0; if g>1 then g:=1;
  if b<0 then b:=0; if b>1 then b:=1;
  if a<0 then a:=0; if a>1 then a:=1;
  {$R-}
  irr:=round(b*255) shl 16; igg:=round(g*255) shl 8; ibb:=round(r*255); iaa:=round(a*255) shl 24;
  result:=irr or igg or ibb;
  {$R+}
end;

function TRGBAColor.GetDWB:DWord;
  var
    irr,igg,ibb,iaa:DWord;
begin
  if r<0 then r:=0; if r>1 then r:=1;
  if g<0 then g:=0; if g>1 then g:=1;
  if b<0 then b:=0; if b>1 then b:=1;
  if a<0 then a:=0; if a>1 then a:=1;
  {$R-}
  irr:=round(r*a*255) shl 16; igg:=round(g*a*255) shl 8; ibb:=round(b*a*255); iaa:=round(a*255) shl 24;
  {$R+}
  result:=irr or igg or ibb or iaa;
end;

function TRGBAColor.GetLighting:Single;
begin
  result:=r+g+b;
end;

procedure TRGBAColor.Add(c:TRGBAColor);
begin
  r:=r+c.r;
  g:=g+c.g;
  b:=b+c.b;
  a:=a+c.a;
end;

procedure TRGBAColor.MulC(k:Single);
begin
  r:=r*k;
  g:=g*k;
  b:=b*k;
  a:=a*k;
end;

procedure TRGBAColor.Blend(c:TRGBAColor);
  var
    ma:Single;
begin
  c.a:=(c.r+c.g+c.b)/3;
  ma:=1-c.a;
  r:=r*ma+c.r*c.a;
  g:=g*ma+c.g*c.a;
  b:=b*ma+c.b*c.a;
end;

procedure TRGBAColor.Blend(c:TRGBAColor;alpha:Single);
  var
    ma:Single;
begin
  ma:=1-alpha;
  r:=r*ma+c.r*alpha;
  g:=g*ma+c.g*alpha;
  b:=b*ma+c.b*alpha;
end;
{******************************************************************************}
procedure TRGBAGradientPoint.Eqv(_h,_r,_g,_b,_a:Single);
begin
  h:=_h;
  color.r:=_r;
  color.g:=_g;
  color.b:=_b;
  color.a:=_a;
end;
{******************************************************************************}
constructor TRGBAGradient.Create;
begin
  count:=0;
  RGBAGradientPointArray:=nil;
end;

destructor TRGBAGradient.Destroy;
begin
  Clear;
end;

function TRGBAGradient.Get(index:Integer):PRGBAGradientPoint;
begin
  if (RGBAGradientPointArray<>nil) and (index>=0) and (index<count)
    then result:=@(RGBAGradientPointArray^[index])
    else result:=nil;
end;

procedure TRGBAGradient.Put(index:Integer;const value:TRGBAGradientPoint);
begin
  if (index>=0) and (index<count)
    then RGBAGradientPointArray^[index]:=value;
end;

procedure TRGBAGradient.Clear;
  var
    i:Integer;
begin
{  for i:=0 to count-1 do
    RGBAGradientarray^[i].Destroy;}
  count:=0;
  Freemem(RGBAGradientPointArray);
  RGBAGradientPointArray:=nil;
end;

procedure TRGBAGradient.SetLength(NewLength:Integer);
  var
    i:Integer;
begin
  if NewLength = count then exit;
  if NewLength > 0 then begin
    if NewLength < count then begin
{      for i:=NewLength to count-1 do
        RGBAGradientPointArray^[i].Destroy;}
    end;
    ReAllocMem(RGBAGradientPointArray,sizeof(TRGBAGradientPoint) * NewLength);
    if NewLength > count then begin
{      for i:=count to NewLength-1 do
        RGBAGradientPointArray^[i].Eqv(0,0,0,0,0);}
    end;
    count:=NewLength;
  end else begin
    Clear;
  end;
end;

procedure TRGBAGradient.Add(h,r,g,b,a:Single);
begin
  SetLength(count+1);
  RGBAGradientPointArray^[count-1].Eqv(h,r,g,b,a);
end;

procedure TRGBAGradient.Add(h,r,g,b,a,f1:Single);overload;
begin
  SetLength(count+1);
  RGBAGradientPointArray^[count-1].Eqv(h,r,g,b,a);
  RGBAGradientPointArray^[count-1].f1:=f1;
end;

procedure TRGBAGradient.Add(h,r,g,b,a,f1,f2,f3,f4:Single);overload;
begin
  SetLength(count+1);
  RGBAGradientPointArray^[count-1].Eqv(h,r,g,b,a);
  RGBAGradientPointArray^[count-1].f1:=f1;
  RGBAGradientPointArray^[count-1].f2:=f2;
  RGBAGradientPointArray^[count-1].f3:=f3;
  RGBAGradientPointArray^[count-1].f4:=f4;
end;

procedure TRGBAGradient.Add(h:Single;_c:TRGBAColor);
begin
  SetLength(count+1);
  item[count-1]^.h:=h;
  item[count-1]^.color:=_c;
end;

procedure TRGBAGradient.Add(h:Single;c:Cardinal);overload;
begin
  SetLength(count+1);
  item[count-1]^.h:=h;
  item[count-1]^.color.Eqv(((c shr 16) and 255)/255,((c shr 8) and 255)/255,(c and 255)/255,((c shr 24) and 255)/255);
end;

procedure TRGBAGradient.Sort;
  var
    i,j:Integer;
    t:Single;
begin
  for i:=0 to count-2 do begin
    for j:=i+1 to count-1 do begin
      if item[i]^.h>item[j]^.h then begin
        t:=item[i]^.h;
        item[i]^.h:=item[j]^.h;
        item[j]^.h:=t;

        t:=item[i]^.color.g;
        item[i]^.color.g:=item[j]^.color.g;
        item[j]^.color.g:=t;

        t:=item[i]^.color.b;
        item[i]^.color.b:=item[j]^.color.b;
        item[j]^.color.b:=t;

        t:=item[i]^.color.r;
        item[i]^.color.r:=item[j]^.color.r;
        item[j]^.color.r:=t;

        t:=item[i]^.color.a;
        item[i]^.color.a:=item[j]^.color.a;
        item[j]^.color.a:=t;
      end;
    end;
  end;
end;

function TRGBAGradient.GetColor(h:Single):TRGBAColor;
  var
    i:Integer;
    a,b,c:Integer;
    ddx,k1,k2:Single;
begin
  if count<=0 then begin
    result.Eqv(1,1,1,0);
  end else if count=1 then begin
    result:=RGBAGradientPointArray^[0].color;
  end else begin
    a:=1;
    b:=count;
    while b-a>1 do begin
      c:=(a+b) div 2;
      if item[c-1].h>h then b:=c else a:=c;
    end;
    dec(a); dec(b);
    ddx:=(RGBAGradientPointArray^[b].h-RGBAGradientPointArray^[a].h);
    if abs(ddx)<0.001 then begin
      result:=RGBAGradientPointArray^[a].color;
    end else begin
      k2:=(h-RGBAGradientPointArray^[a].h)/ddx;
      k1:=1-k2;
      result.r:=RGBAGradientPointArray^[a].color.r*k1+RGBAGradientPointArray^[b].color.r*k2;
      result.g:=RGBAGradientPointArray^[a].color.g*k1+RGBAGradientPointArray^[b].color.g*k2;
      result.b:=RGBAGradientPointArray^[a].color.b*k1+RGBAGradientPointArray^[b].color.b*k2;
      result.a:=RGBAGradientPointArray^[a].color.a*k1+RGBAGradientPointArray^[b].color.a*k2;
    end;
  end;
end;

function TRGBAGradient.GetPoint(h:Single):TRGBAGradientPoint;
  var
    i:Integer;
    a,b,c:Integer;
    ddx,k1,k2:Single;
begin
  if count<=0 then begin
    result.color.Eqv(1,1,1,0);
    result.f1:=0;
    result.f2:=0;
    result.f3:=0;
    result.f4:=0;
  end else if count=1 then begin
    result:=RGBAGradientPointArray^[0];
  end else begin
    a:=1;
    b:=count;
    while b-a>1 do begin
      c:=(a+b) div 2;
      if item[c-1].h>h then b:=c else a:=c;
    end;
    dec(a); dec(b);
    ddx:=(RGBAGradientPointArray^[b].h-RGBAGradientPointArray^[a].h);
    if ddx<0.001 then begin
      result:=RGBAGradientPointArray^[a];
    end else begin
      k2:=(h-RGBAGradientPointArray^[a].h)/ddx;
      k1:=1-k2;
      result.color.r:=RGBAGradientPointArray^[a].color.r*k1+RGBAGradientPointArray^[b].color.r*k2;
      result.color.g:=RGBAGradientPointArray^[a].color.g*k1+RGBAGradientPointArray^[b].color.g*k2;
      result.color.b:=RGBAGradientPointArray^[a].color.b*k1+RGBAGradientPointArray^[b].color.b*k2;
      result.color.a:=RGBAGradientPointArray^[a].color.a*k1+RGBAGradientPointArray^[b].color.a*k2;
      result.f1:=RGBAGradientPointArray^[a].f1*k1+RGBAGradientPointArray^[b].f1*k2;
      result.f2:=RGBAGradientPointArray^[a].f2*k1+RGBAGradientPointArray^[b].f2*k2;
      result.f3:=RGBAGradientPointArray^[a].f3*k1+RGBAGradientPointArray^[b].f3*k2;
      result.f4:=RGBAGradientPointArray^[a].f4*k1+RGBAGradientPointArray^[b].f4*k2;
    end;
  end;
end;
{******************************************************************************}

function HLStoRGB1(rn1,rn2,hue:Single):Single;
begin
  if hue>360 then hue:=hue-360;
  if hue<0 then hue:=hue+360;
  if hue<60 then result:=rn1+(rn2-rn1)*hue/60
  else if hue<180 then result:=rn2
  else if hue<240 then result:=rn1+(rn2-rn1)*(240-hue)/60
  else result:=rn1;
end;

function HLStoRGB(hue,light,satur:Single):TRGBAColor;
  var
    rh,rl,rs,rm1,rm2:Single;
begin
  rh:=0; rl:=0; rs:=0;
  if hue>0 then rh:=hue; if rh>360 then rh:=360;
  if satur>0 then rs:=satur; if rs>1 then rs:=1;
  if light>0 then rl:=light; if rl>1 then rl:=1;
  if (rl<0.5) then rm2:=rl*(1+rs)
  else rm2:=rl+rs-rl*rs;
  rm1:=2*rl-rm2;
  if rs=0 then result.Eqv(rl,rl,rl,1)
  else result.Eqv(HLStoRGB1(rm1, rm2, rh+120),HLStoRGB1(rm1, rm2, rh),HLStoRGB1(rm1,rm2,rh-120),1);
end;


Procedure RGBToHLS_(R, G, B : Word; var H, L, S : integer);
Var
  cr,cg,cb,m1,m2,ir,ig,ib,ih,il,isa:real;
Begin
//  m1 := MaxWord(MaxWord(r, g), b) / 63;
//  m2 := MinWord(MinWord(r, g), b) / 63;
  ir := r / 63;
  ig := g / 63;
  ib := b / 63;

  il := (m1 + m2) / 2;
  if m1 = m2 then begin
    isa := 0;
    ih := 0;
  end else begin
    if il <= 0.5 then isa := (m1 - m2) / (m1 + m2) else
      isa := (m1 - m2) / (2 - m1 - m2);
    cr := (m1 - ir) / (m1 - m2);
    cg := (m1 - ig) / (m1 - m2);
    cb := (m1 - ib) / (m1 - m2);
    if ir = m1 then ih := cb - cg;
    if ig = m1 then ih := 2 + cr - cb;
    if ib = m1 then ih := 4 + cg - cr;
  end;
  h := round(60 * ih);
  if h < 0 then h := h + 360;
  l := round(il * 100);
  s := round(isa * 100);
End;

Procedure HLSToRGB_(H, L, S : Word; var R, G, B : Word);

Function XRGB(HH, mm1, mm2 : Real) : Real;
Begin
  if hh < 0 then hh := hh + 360;
  if hh > 360 then hh := hh - 360;
  if hh < 60 then xrgb := mm1 + (mm2 - mm1) * hh / 60 else
    if hh < 180 then xrgb := mm2 else
      if hh < 240 then xrgb := mm1 + (mm2 - mm1) * (240 - hh) / 60 else
        xrgb := mm1;
End;

Var
  cr,cg,cb,m1,m2,ir,ig,ib,ih,il,isa : Real;
Begin
  il := l / 100;
  ih := h;
  isa := s / 100;
  if il <= 0.5 then m2 := il * (1 + isa) else m2 := il + isa - il * isa;
  m1 :=2 * il - m2;
  if s = 0 then begin
    ir := il;
    ig := il;
    ib := il
  end else begin
    ir := XRGB(ih + 120, m1, m2);
    ig := XRGB(ih , m1, m2);
    ib := XRGB(ih - 120, m1, m2);
  end;
  r := round(ir * 63);
  g := round(ig * 63);
  b := round(ib * 63);
End;

end.

