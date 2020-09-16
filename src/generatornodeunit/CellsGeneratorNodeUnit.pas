unit CellsGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TCellsGeneratorNodeUnit=class(TGeneratorNodeUnit)

  w,h,squaretype,irregularity,distribution,rootseed,scale:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TCellsGeneratorNodeUnit.Create;
begin
  inherited;
  w:=10;
  h:=10;
  squaretype:=5;
  irregularity:=500;
  distribution:=400;
  rootseed:=1;
  scale:=100;
  AddParam_List('SquareType','Square=0,Cell=1,Circle=2,TechAlpha=3,Star=4,SinSquare=5',@squaretype);
  AddParam_Int('Width',1,1000,@w);
  AddParam_Int('Height',1,1000,@h);
  AddParam_Int('Irregularity',0,1000,@irregularity);
  AddParam_Int('Distribution',0,1000,@distribution);
  AddParam_Int('Scale',0,300,@Scale);
  AddParam_Int('RootSeed',1,1000,@RootSeed);
end;

destructor TCellsGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TCellsGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  Node.TextureGenerator.Generate_Cells(w,h,squaretype,irregularity/100,distribution/1000,scale/100,rootseed);
  Node.TextureGenerator.Transparency_FillAlpha(1);
end;

procedure TCellsGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
  Node.TextureRenderer:=TTextureGenerator.Create;
  Node.TextureRenderer.Width := _sizex;
  Node.TextureRenderer.Height := _sizey;
  Node.TextureRenderer.Generate_Cells(w,h,squaretype,irregularity/100,distribution/1000,scale/100,rootseed);
  Node.TextureRenderer.Transparency_FillAlpha(1);
end;

end.

