unit ZCircleGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TZCircleGeneratorNodeUnit=class(TGeneratorNodeUnit)

  px,py,sx,sy,irrx,irry,tp:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TZCircleGeneratorNodeUnit.Create;
begin
  inherited;
  tp:=1;
  px:=0;
  py:=0;
  sx:=500;
  sy:=500;
  irrx:=2;
  irry:=2;
  AddParam_List('Type','Circle=1,Square=2,SinSquare=3,Star=4,TechAlpha=5,Cell=6',@tp);
  AddParam_Int('ScaleX',1,10000,@sx);
  AddParam_Int('ScaleY',1,10000,@sy);
  AddParam_Int('OffsetX',-1000,1000,@px);
  AddParam_Int('OffsetY',-1000,1000,@py);
  AddParam_Int('Rotation',-180,180,@irrx);
end;

destructor TZCircleGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TZCircleGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
    ppx,ppy,spx,spy:Integer;
    irx:Single;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  Node.TextureGenerator.Primitive_Rect(0, 0, Node.Width, Node.Height, 0, 0, 0, 0);
  ppx:=Node.TextureGenerator.Width*px div 1000 + Node.TextureGenerator.Width div 2;
  ppy:=Node.TextureGenerator.Height*py div 1000 + Node.TextureGenerator.Height div 2;
  spx:=Node.TextureGenerator.Width*sx div 1000; if spx<=0 then spx:=1;
  spy:=Node.TextureGenerator.Height*sy div 1000; if spy<=0 then spy:=1;
  irx:=PI*irrx/180;
  case tp of
    1:Node.TextureGenerator.Primitive_ZCircle(ppx,ppy,spx,spy,irx,irry);
    2:Node.TextureGenerator.Primitive_ZSquare(ppx,ppy,spx,spy,irx,irry);
    3:Node.TextureGenerator.Primitive_ZSinSquare(ppx,ppy,spx,spy,irx,irry);
    4:Node.TextureGenerator.Primitive_ZStar(ppx,ppy,spx,spy,irx,irry);
    5:Node.TextureGenerator.Primitive_ZTechAlpha(ppx,ppy,spx,spy,irx,irry);
    6:Node.TextureGenerator.Primitive_ZCell(ppx,ppy,spx,spy,irx,irry);
  end;
end;

procedure TZCircleGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
    ppx,ppy,spx,spy:Integer;
    irx:Single;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
  Node.TextureRenderer:=TTextureGenerator.Create;
  Node.TextureRenderer.Width := _sizex;
  Node.TextureRenderer.Height := _sizey;
  Node.TextureRenderer.Primitive_Rect(0, 0, Node.Width, Node.Height, 0, 0, 0, 0);
  ppx:=Node.TextureRenderer.Width*px div 1000 + Node.TextureRenderer.Width div 2;
  ppy:=Node.TextureRenderer.Height*py div 1000 + Node.TextureRenderer.Height div 2;
  spx:=Node.TextureRenderer.Width*sx div 1000; if spx<=0 then spx:=1;
  spy:=Node.TextureRenderer.Height*sy div 1000; if spy<=0 then spy:=1;
  irx:=PI*irrx/180;
  case tp of
    1:Node.TextureRenderer.Primitive_ZCircle(ppx,ppy,spx,spy,irx,irry);
    2:Node.TextureRenderer.Primitive_ZSquare(ppx,ppy,spx,spy,irx,irry);
    3:Node.TextureRenderer.Primitive_ZSinSquare(ppx,ppy,spx,spy,irx,irry);
    4:Node.TextureRenderer.Primitive_ZStar(ppx,ppy,spx,spy,irx,irry);
    5:Node.TextureRenderer.Primitive_ZTechAlpha(ppx,ppy,spx,spy,irx,irry);
    6:Node.TextureRenderer.Primitive_ZCell(ppx,ppy,spx,spy,irx,irry);
  end;
end;

end.

