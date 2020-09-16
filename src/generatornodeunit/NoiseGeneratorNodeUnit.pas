unit NoiseGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TNoiseGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Width,Height,Iterations,Filter,Intensity,Distortion,RootSeed:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TNoiseGeneratorNodeUnit.Create;
begin
  inherited;
  Width:=8;
  Height:=8;
  Filter:=1;
  Iterations:=5;
  RootSeed:=1;
  Distortion:=0;
  Intensity:=50;
  AddParam_List('Mode','PERLIN LINERAR=0,PERLIN COSINUS=1,REGULAR=2,REGULAR LOW=3,CRATES LINEAR=4,CRATES SIN=5,FLASH LINEAR=6,FLASH COSINUS=7,LITLE=8',@Filter);
  AddParam_Int('Width',1,1000,@Width);
  AddParam_Int('Height',1,1000,@Height);
  AddParam_Int('Iterations',1,102,@Iterations);
  AddParam_Int('Intensity',0,100,@Intensity);
  AddParam_Int('Distortion',0,10000,@Distortion);
  AddParam_Int('RootSeed',1,1000,@RootSeed);
end;

destructor TNoiseGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TNoiseGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  Node.TextureGenerator.Generate_Noise(width, height, filter, iterations,Intensity/100,Distortion/10000, rootseed);
  Node.TextureGenerator.Transparency_FillAlpha(1);
end;

procedure TNoiseGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
  Node.TextureRenderer:=TTextureGenerator.Create;
  Node.TextureRenderer.Width := _sizex;
  Node.TextureRenderer.Height := _sizey;
  Node.TextureRenderer.Generate_Noise(width, height, filter, iterations,Intensity/100,Distortion/10000, rootseed);
  Node.TextureRenderer.Transparency_FillAlpha(1);
end;

end.

