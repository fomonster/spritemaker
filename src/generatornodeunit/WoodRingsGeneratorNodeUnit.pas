unit WoodRingsGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TWoodRingsGeneratorNodeUnit=class(TGeneratorNodeUnit)

  w,h,ax,ay,Iterations,Radius,RootSeed:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TWoodRingsGeneratorNodeUnit.Create;
begin
  inherited;
  w:=12;
  h:=5;
  ax:=3;
  ay:=2;
  radius:=2;
  iterations:=1;
  rootseed:=1;
  AddParam_Int('Width',1,100,@w);
  AddParam_Int('Height',1,100,@h);
  AddParam_Int('ScaleX',1,20,@ax);
  AddParam_Int('ScaleY',1,20,@ay);
  AddParam_Int('Radius',0,200,@Radius);
  AddParam_Int('Iterations',1,5,@Iterations);
  AddParam_Int('RootSeed',1,1000,@RootSeed);
end;

destructor TWoodRingsGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TWoodRingsGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  Node.TextureGenerator.Generate_WoodRings(w,h,ax,ay,radius,iterations,rootseed);
  Node.TextureGenerator.Transparency_FillAlpha(1);
end;

procedure TWoodRingsGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
  Node.TextureRenderer:=TTextureGenerator.Create;
  Node.TextureRenderer.Width := _sizex;
  Node.TextureRenderer.Height := _sizey;
  Node.TextureRenderer.Generate_WoodRings(w,h,ax,ay,radius,iterations,rootseed);
  Node.TextureRenderer.Transparency_FillAlpha(1);
end;

end.

