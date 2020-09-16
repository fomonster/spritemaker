unit GradientGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TGradientGeneratorNodeUnit=class(TGeneratorNodeUnit)

  w,h,grtype,RootSeed:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TGradientGeneratorNodeUnit.Create;
begin
  inherited;
  w:=8;
  h:=8;
  grtype:=3;
  RootSeed:=1;
  AddParam_List('Gradient','VERTICAL=0,HORIZONTAL=1,RADIAL SHORT=2,RADIAL SPHERE=3,RADIAL FLAT SPHERE=4,RELIEF=5,RADIAL SINUS=6,VERTICAL LINE=7,HORIZONTAL LINE=8,STAR=9,SMALL STAR=10,DANCEPOOL=11',@grtype);
  AddParam_Int('Width',1,1000,@w);
  AddParam_Int('Height',1,1000,@h);
  AddParam_Int('RootSeed',1,1000,@RootSeed);
end;

destructor TGradientGeneratorNodeUnit.Destroy;
begin
  inherited;
end;

procedure TGradientGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  Node.TextureGenerator.Generate_Gradient(w, h,grtype,rootseed);
  Node.TextureGenerator.Transparency_FillAlpha(1);
end;

procedure TGradientGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
  Node.TextureRenderer:=TTextureGenerator.Create;
  Node.TextureRenderer.Width := _sizex;
  Node.TextureRenderer.Height := _sizey;
  Node.TextureRenderer.Generate_Gradient(w, h,grtype,rootseed);
  Node.TextureRenderer.Transparency_FillAlpha(1);
end;

end.

