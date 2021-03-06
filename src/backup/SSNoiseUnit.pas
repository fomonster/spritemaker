{*******************************************************************************

  ������: SpaceSim
  �����: ����� �.�.
  ����: 2009 ���

  ���������� ������:


*******************************************************************************}
unit SSNoiseUnit;
{******************************************************************************}

{******************************************************************************}
interface
{******************************************************************************}

{******************************************************************************}
uses
{******************************************************************************}
  Classes, SysUtils;
{******************************************************************************}
procedure InitTurbulence(seed:Cardinal);
function Turbulence2Dia(x,y: Integer; const n: integer): Integer;

function Cerp(const a,b,x:Single):Single;inline;
function Lerp(const a,b,x:Single):Single;inline;
function GetFloatRnd(var seed:Cardinal):Single;inline;

function GetNoise1d(const rootseed:Cardinal;const x:Integer):Single;

function GetNoise2d(const rootseed:Cardinal;const x,y:Cardinal):Single;inline;
function GetLerpNoise2d(const rootseed:Cardinal;const x,y:Cardinal;px,py:Single):Single;overload;
function GetLerpNoise2d(const rootseed:Cardinal;const x,y,modx,mody:Cardinal;px,py:Single):Single;overload;
function GetCerpNoise2d(const rootseed:Cardinal;const x,y,modx,mody:Cardinal;px,py:Single):Single;overload;


function GetNoise3d(const rootseed:Cardinal;const x,y,z:Cardinal):Single;
function GetSmoothNoise2d1l(const rootseed:Cardinal;const x,y,z:Cardinal):Single;
function GetPerlingNoise2d1l(const rootseed:Cardinal;const x,y,z:Cardinal):Single;

{******************************************************************************}
implementation

 Uses SSConstantsUnit;
{******************************************************************************}
const
  B:  Integer = $100;
  BM: Integer = $FF;
  N:  Integer = $1000;
  Ni:  Integer = $400000;
  NM: Integer = $FFF;
  NP: Integer = 12;
  B2: Integer = $202; // B + B + 2;
{******************************************************************************}
var
  P:  array[0..$202] of Integer;
  G1: array[0..$202] of Double;
  G2: array[0..$202,0..1] of Double;
  G2i: array[0..$202,0..1] of Integer;
  G3: array[0..$202,0..2] of Double;
  G3i: array[0..$202,0..2] of Integer;
{******************************************************************************}
// �������� ������������ �� a �� b, ��� x - �������� ������������ (0..1)
function Lerp(const a,b,x:Single):Single;inline;
begin
  result:=a*(1-x)+b*x;
end;
{******************************************************************************}
// �������� ������������ �� a �� b, ��� x - �������� ������������ (0..1)
function Cerp(const a,b,x:Single):Single;inline;
  var
    f:Single;
begin
  f:=(1-cos(x*3.1415927))*0.5;
  result:=a*(1-f)+b*f;
end;
{*******************************************************************************

*******************************************************************************}
function GetFloatRnd(var seed:Cardinal):Single;
var
  r:Single;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  seed:=seed*16807;
  PCardinal(@r)^:=(seed and $007fffff) or $40000000;
  result:=r-3.0;
  {$Q+} // ��������� �������� �� ������������
end;
{*******************************************************************************
  ���������� ��� -1..1 � ���������� ���������� x �� ������ rootseed.
*******************************************************************************}
function GetNoise1d(const rootseed:Cardinal;const x:Integer):Single;
var
  r:Single;
  seed_t:Cardinal;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  seed_t:=rootseed*16807+x*57;
  seed_t:=((seed_t shr 11) * seed_t * x * 2531011 + 789221) * seed_t + 1376312589;
  PCardinal(@r)^:=(seed_t and $007fffff) or $40000000;
  result:=r-3.0;
  {$RANGECHECKS ON}
  {$Q+}
end;
{*******************************************************************************
  ��������� ��� -1..1 � ����� ����������� ����������� x � y �� ������ rootseed
*******************************************************************************}
function GetNoise2d(const rootseed:Cardinal;const x,y:Cardinal):Single;inline;
var
  r:Single;
  seed_t:Cardinal;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  seed_t:=rootseed*16807+x+y*57;
  seed_t:=((seed_t shr 11) * seed_t * x * 5531011 + 789221) * seed_t + 1376312589;
  seed_t:=((seed_t shr 11) * seed_t * y * 2531011 + 889221) * seed_t + 1736312589;
  PCardinal(@r)^:=(seed_t and $007fffff) or $40000000;
  result:=r-3.0;
  {$RANGECHECKS ON}
  {$Q+}
end;
{******************************************************************************}
function GetLerpNoise2d(const rootseed:Cardinal;const x,y:Cardinal;px,py:Single):Single;
  var
    v1,v2,v3,v4:Single;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  v1:=GetNoise2d(rootseed,x,y);
  v2:=GetNoise2d(rootseed,x+1,y);
  v3:=GetNoise2d(rootseed,x,y+1);
  v4:=GetNoise2d(rootseed,x+1,y+1);
  {$RANGECHECKS ON}
  {$Q+}
  result:=lerp(lerp(v1,v2,px),lerp(v3,v4,px),py);
end;
{******************************************************************************}
function GetLerpNoise2d(const rootseed:Cardinal;const x,y,modx,mody:Cardinal;px,py:Single):Single;
  var
    v1,v2,v3,v4:Single;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  v1:=GetNoise2d(rootseed,x mod modx,y mod mody);
  v2:=GetNoise2d(rootseed,(x+1) mod modx,y mod mody);
  v3:=GetNoise2d(rootseed,x mod modx,(y+1) mod mody);
  v4:=GetNoise2d(rootseed,(x+1) mod modx,(y+1) mod mody);
  {$RANGECHECKS ON}
  {$Q+}
  result:=lerp(lerp(v1,v2,px),lerp(v3,v4,px),py);
end;
{******************************************************************************}
function GetCerpNoise2d(const rootseed:Cardinal;const x,y,modx,mody:Cardinal;px,py:Single):Single;
  var
    v1,v2,v3,v4:Single;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  v1:=GetNoise2d(rootseed,x mod modx,y mod mody);
  v2:=GetNoise2d(rootseed,(x+1) mod modx,y mod mody);
  v3:=GetNoise2d(rootseed,x mod modx,(y+1) mod mody);
  v4:=GetNoise2d(rootseed,(x+1) mod modx,(y+1) mod mody);
  result:=cerp(cerp(v1,v2,px),cerp(v3,v4,px),py);
  {$RANGECHECKS ON}
  {$Q+}
end;
{*******************************************************************************
 ���������� ��� -1..1 � ����� ����������� ����������� x,y � � �� ������ rootseed
*******************************************************************************}
function GetNoise3d(const rootseed:Cardinal;const x,y,z:Cardinal):Single;
var
  r:Single;
  seed_t:Cardinal;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  seed_t:=rootseed*16807+x+y*57;
  seed_t:=((seed_t shr 11) * seed_t * x * 15731 + 789221) * seed_t + 1376312589;
  seed_t:=((seed_t shr 11) * seed_t * y * 15713 + 879221) * seed_t + 1367312589;
  seed_t:=((seed_t shr 11) * seed_t * z * 15173 + 897221) * seed_t + 1363712589;
  PCardinal(@r)^:=(seed_t and $007fffff) or $40000000;
  result:=r-3.0;
  {$RANGECHECKS ON}
  {$Q+}
end;
{*******************************************************************************
 ���������� ��� -1..1 � ����� ����������� ����������� x,y � � �� ������ rootseed
*******************************************************************************}
function GetSmoothNoise2d1l(const rootseed:Cardinal;const x,y,z:Cardinal):Single;
  var
    corners,sides,center:Single;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  corners := ( GetNoise3d(rootseed,x-1,y-1,z)+GetNoise3d(rootseed,x+1,y-1,z)+
               GetNoise3d(rootseed,x-1,y+1,z)+GetNoise3d(rootseed,x+1,y+1,z) ) / 16.0;
  sides := ( GetNoise3d(rootseed,x-1,y,z)+GetNoise3d(rootseed,x+1,y,z)+
               GetNoise3d(rootseed,x,y+1,z)+GetNoise3d(rootseed,x,y-1,z) ) / 8.0;
  center := ( GetNoise3d(rootseed,x,y,z) ) / 4.0;
  result:=corners+sides+center;
  {$RANGECHECKS ON}
  {$Q+}
end;
{******************************************************************************}
function GetLerpNoise2d1l(const rootseed:Cardinal;const x,y,z:Cardinal;px,py:Single):Single;
  var
    v1,v2,v3,v4:Single;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  v1:=GetNoise3d(rootseed,x,y,z);
  v2:=GetNoise3d(rootseed,x+1,y,z);
  v3:=GetNoise3d(rootseed,x,y+1,z);
  v4:=GetNoise3d(rootseed,x+1,y+1,z);
  result:=lerp(lerp(v1,v2,px),lerp(v3,v4,px),py);
  {$RANGECHECKS ON}
  {$Q+}
end;
{******************************************************************************}
function GetCerpNoise2d1l(const rootseed:Cardinal;const x,y,z:Cardinal;px,py:Single):Single;
  var
    v1,v2,v3,v4:Single;
    dx,dy:Integer;
begin
  {$Q-} // ��������� �������� �� ������������
  {$RANGECHECKS OFF}
  v1:=GetNoise3d(rootseed,x,y,z);
  v2:=GetNoise3d(rootseed,x+1,y,z);
  v3:=GetNoise3d(rootseed,x,y+1,z);
  v4:=GetNoise3d(rootseed,x+1,y+1,z);
  result:=cerp(cerp(v1,v2,px),cerp(v3,v4,px),py);
  {$RANGECHECKS ON}
  {$Q+}
end;
{******************************************************************************}
function GetPerlingNoise2d1l(const rootseed:Cardinal;const x,y,z:Cardinal):Single;
  var
    m,r,dx,dy:Single;
    n,n1,ax,ay,nx,ny:Integer;
begin
  result:=0;
  // if (x<0) or (y<0) then exit;
  {$RANGECHECKS OFF}
  {$Q-} // ��������� �������� �� ������������

  m:=1;
  n:=8;
  r:=0;
  
  while n>=2 do begin
  
    n1:=1 shl n;
    
    ax:=x div n1;
    nx:=x mod n1;
    dx:=nx/n1;
    
    ay:=y div n1;
    ny:=y mod n1;
    dy:=ny/n1;

    r:=r+GetCerpNoise2d1l(rootseed,ax,ay,z+n,dx,dy)*m;
    m:=m*0.5;
    n:=n-1;
    
  end;
  result:=r;
  {$Q+}
  {$RANGECHECKS ON}
end;
{******************************************************************************}
procedure InitTurbulence(seed:Cardinal);
var
  I,J,T: integer;
  len: double;
  r_seed:Cardinal;
begin
  randseed := seed;
  r_seed := seed;
  for i := 0 to B - 1 do begin
    P[i] := i;

    G1[i] := frandom(r_seed);

    G2[i,0] := frandom(r_seed); // -1..1
    G2[i,1] := frandom(r_seed); // -1..1

    G2i[i,0] := trunc(G2[i,0] * 1024);
    G2i[i,1] := trunc(G2[i,1] * 1024);

    G3[i,0] := frandom(r_seed);
    G3[i,1] := frandom(r_seed);
    G3[i,2] := frandom(r_seed);
    G3i[i,0] := trunc(G3[i,0] * 1024);
    G3i[i,1] := trunc(G3[i,1] * 1024);
    G3i[i,2] := trunc(G3[i,2] * 1024);
  end;

  for i := 0 to B - 1 do begin
    j := Trunc(Random * B);
    T := P[i];
    P[i] := P[j];
    P[j] := T;
  end;

  for i := 0 to B + 1 do begin
    P[B + i] := P[i];

    G1[B + i] := G1[i];

    G2[B + i][0] := G2[i][0];
    G2[B + i][1] := G2[i][1];

    G2i[B + i][0] := G2i[i][0];
    G2i[B + i][1] := G2i[i][1];

    G3[B + i][0] := G3[i][0];
    G3[B + i][1] := G3[i][1];
    G3[B + i][2] := G3[i][2];

    G3i[B + i][0] := G3i[i][0];
    G3i[B + i][1] := G3i[i][1];
    G3i[B + i][2] := G3i[i][2];
  end;
end;
{******************************************************************************}
function noise2Di(const x,y: Integer): Integer;
var
  bx0,bx1,by0,by1: integer;
  b00,b10,b01,b11: integer;
  rx0, rx1, ry0, ry1: integer;
  sx, sy,t,a,b,u,v: integer;
  i,j: integer;
  r: integer;
begin
  {$Q-}
  {$R-}
  t := x + $40000000;
  bx0 := (t shr 10) and $FF;
  bx1 := (bx0 + 1) and $FF;
  i := P[bx0];
  rx0 := t and 1023;
  rx1 := rx0 - 1024;

  t := y + $40000000;
  by0 := (t shr 10) and $FF;
  by1 := (by0 + 1) and $FF;
  j := P[bx1];
  ry0 := t and 1023;
  ry1 := ry0 - 1024;

  b00 := P[i + by0];
  b10 := P[j + by0];
  b01 := P[i + by1];
  b11 := P[j + by1];

  sx := (rx0 * rx0 * (3072 - 2 * rx0)) shr 20;
  sy := (ry0 * ry0 * (3072 - 2 * ry0)) shr 20;

  u := (rx0 * G2i[b00][0] + ry0 * G2i[b00][1]);
  v := (rx1 * G2i[b10][0] + ry0 * G2i[b10][1]);
  a := (u shl 10) + sx * (v - u);
asm
 SAR a,20
end;

  u := (rx0 * G2i[b01][0] + ry1 * G2i[b01][1]);
  v := (rx1 * G2i[b11][0] + ry1 * G2i[b11][1]);
  b := (u shl 10)  + sx * (v - u);
asm
  //TODO:SAR b,20
end;

  r := a shl 10  + sy * (b - a);
asm
  //TODO:SAR r,10
end;

  result := r;
  {$Q+}
  {$R+}
end;
{******************************************************************************}
function turbulence2Dia(x,y: Integer; const n: integer): Integer;
var
  r, i: integer;
  a: integer;
begin
  r := 0;
  a := 1;

  for i := n - 1 downto 0 do begin
    Inc(r, abs(Noise2Di(x,y)) div a);
    x := x shl 1;
    y := y shl 1;
    a := a shl 1;
  end;
  Result := r;
end;
{******************************************************************************}

initialization
  InitTurbulence(100);

{******************************************************************************}
finalization

{******************************************************************************}
end.
{******************************************************************************}

