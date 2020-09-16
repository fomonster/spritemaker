unit BricksGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TBricksGeneratorNodeUnit=class(TGeneratorNodeUnit)

  w,h,border,shifts,widthvariation,slidevariation,rootseed:integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TBricksGeneratorNodeUnit.Create;
begin
  inherited;
  w:=3;
  h:=7;
  border:=40;
  shifts:=300;
  widthvariation:=200;
  slidevariation:=300;
  rootseed:=1;
  AddParam_Int('Width',1,1000,@w);
  AddParam_Int('Height',1,1000,@h);
  AddParam_Int('Border',1,1000,@border);
  AddParam_Int('Shifts',0,1000,@shifts);
  AddParam_Int('WidthVariation',0,1000,@widthvariation);
  AddParam_Int('SlideVariation',0,1000,@slidevariation);
  AddParam_Int('RootSeed',1,1000,@RootSeed);
end;

destructor TBricksGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TBricksGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  Node.TextureGenerator.Generate_Bricks(w,h,border/1000,
                                   shifts/1000,widthvariation/1000,
                                   slidevariation/1000,rootseed);
  Node.TextureGenerator.Transparency_FillAlpha(1);

end;

procedure TBricksGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
  Node.TextureRenderer:=TTextureGenerator.Create;
  Node.TextureRenderer.Width := _sizex;
  Node.TextureRenderer.Height := _sizey;
  Node.TextureRenderer.Generate_Bricks(w,h,border/1000,
                                   shifts/1000,widthvariation/1000,
                                   slidevariation/1000,rootseed);
  Node.TextureRenderer.Transparency_FillAlpha(1);
end;

end.

