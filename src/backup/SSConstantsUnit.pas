{*******************************************************************************

   Sim3D Module : SimConstantsUnit
   Автор: Фомин С.С. 2008 г.
   Mail: fomonster@gmail.com

   Модуль, содержащий различные константы и определения.

*******************************************************************************}
unit SSConstantsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, VectorTypes;

var
  counterr:Integer;

  FullScreenModeIndex:Integer=0;

  sim_DecimalSeparator:Char = '.';
  sim_Epsilon:Single = 0.00001;
  sim_EpsilonDouble:Double = 0.00000000001;
  sim_MaxFloat:Single=1000000000;
  sim_MinFloat:Single=-1000000000;
  sim_scenechanged:boolean=true;

  sst_MaxSize:Integer = 1024;
  sst_MinSize:Integer = 16;

  ss_seed:Cardinal = 131322131;

  // Цвет фона области просмотра
//  sc_BackgroundColor:TVector3f = ($BD/255,$BD/255,$BD/255);
//  sc_BackgroundColor:TVector3f = ($7d/255,$a7/255,$d8/255);
  sc_BackgroundColor:TVector3f = (0,0,0);

  // Ширина бордюра области просмотра и цвета
  sv_BorderWidth:Integer = 2;
  sv_BorderColor:TVector3f = (130/255,127/255,117/255);
  sv_BorderColorActive:TVector3f = (240/255,237/255,147/255);
  sv_GridColorA:TVector3f = ($53/255,$47/255,$41/255);
  sv_GridColorB:TVector3f = ($73/255,$62/255,$57/255);
  // Ширина разделителя между областями просмотра
  sv_SplitterWidth:Integer = 6;
  
  // Режимы редактирования объекта инструментом
  // SelectedObjectsEditInstrument
  soei_Nothing:Integer =0;
  
  
  // Режимы работы камеры
  cm_Orto:Integer = 1;
  cm_Perspective:Integer = 2;
  cm_PerspectiveFromEyes:Integer = 3;

  cm_RotationSpeed:Single = 0.005;
  cm_MoveSeed:Single = 0.001;
  cm_MoveUpDownSeed:Single = 0.003;
  cm_MoveLeftRightSeed:Single = 0.003;

  cm_StartPosition_X:Single=0;
  cm_StartPosition_Y:Single=0;
  cm_StartPosition_Z:Single=22.34964371;
  cm_StartOrientation_X:Single=-0.2342235297;
  cm_StartOrientation_Y:Single=0.4157124162;
  cm_StartOrientation_Z:Single=0.1117019802;
  cm_StartOrientation_W:Single=0.8716911077;
  cm_MouseMXValue:Single=0.8900002837;
  cm_MouseMYValue:Single=-0.5249997973;

  cr_ObjectMode:Integer = 1;
  cr_ScreenMode:Integer = 2;
  cr_FlyMode:Integer = 3;

  // Режим перемещения мышки
  ctrlm_Usial:Integer = 1;
  ctrlm_GUI:Integer = 2;
  ctrlm_AsDirectInput:Integer = 3;
  
  // ID Кнопок
//  BtnId_StandardObjects:Integer = 1;
//  BtnId_Extendedobjects:Integer = 2;
//  BtnId_BackToMainMenuCreateObjects:Integer = 3;
///  Mnu_MenuCreateObject:Integer = 5;

  // Типы модификаторов
  Mdt_Nothing:Integer = 0;
  Mdt_CreateObjectBox:Integer = 1;
  Mdt_CreateObjectSphere:Integer = 2;
  Mdt_CreateObjectGeoSphere:Integer = 3;
  Mdt_CreateObjectCilinder:Integer = 4;
  Mdt_CreateObjectConus:Integer = 5;
  Mdt_CreateObjectTorus:Integer = 6;

  
  Gt_Mesh:Integer = 0;
  Gt_Spline:Integer = 1;
  

function irandom(var seed:Cardinal;const max:Cardinal):Cardinal;
function frandom(var seed:Cardinal):Single;
function GetWord(var s:String):String;
function RndColor:Cardinal;
procedure SSMsg(s:String);
function ReadTagInt(var s:String;var n:Integer):boolean;

implementation

  uses Windows;

procedure SSMsg(s:String);
begin
  MessageBox(0,PChar(s),PChar('Space Sim Message'),0);
end;

function GetWord(var s:String):String;
  var
    i,j:Integer;
    ss:String;
begin
  s:=trim(s)+' ';
  j:=pos('/',s);
  i:=pos(' ',s);
  if (i<j) or (j<=0) then begin
    result:=copy(s,1,i-1);
    delete(s,1,i);
  end else begin
    result:=copy(s,1,j-1);
    delete(s,1,j);
  end;
end;

function RndColor:Cardinal;
begin
  result:=random($ffffff);
end;

function frandom(var seed:Cardinal):Single; // -1..1
var
  r:Single;
begin
  {$R-} // Отключаем проверку на переполнение
  {$Q-}
  seed:=((seed shr 11) * seed * 15731 + 7789221) * seed + 8376312589;
  PCardinal(@r)^:=(seed and $007fffff) or $40000000;
  result:=r-3.0;
  {$Q+}
  {$R+} // Отключаем проверку на переполнение
end;

function irandom(var seed:Cardinal;const max:Cardinal):Cardinal; // 0..max-1
var
  r:Single;
  sd:Cardinal;
begin
  if ( max <= 0 ) then begin
    result := 0;
    exit;
  end;
  {$R-}
  {$Q-}
  seed:=seed * 543234 + 7874234234;
  seed:=round($FFFFFFFF * sin(seed xor $AAAAAAAA)+56872342);
  seed:=seed * 456455 + 9978234232;
  result:=seed mod max;
  {$RANGECHECKS ON}
  {$R+}
  {$Q+}
end;

function ReadTagInt(var s:String;var n:Integer):boolean;
  var
    si:String;
    i:Integer;
begin
  result:=false;
  if length(s)<=0 then exit;
  i:=1;
  while not (s[i] in ['0'..'9']) do begin
    if i>length(s) then exit;
    inc(i);
  end;
  si:='';
  while (s[i] in ['0'..'9']) do begin
    si:=si+s[i];
    inc(i);
  end;
  n:=StrToIntDef(si,0);
  delete(s,1,i);
  result:=true;
end;

end.

