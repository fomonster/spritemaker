unit SolidColorGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSColor, SSXMLUnit;

type

TSolidColorGeneratorNodeUnit=class(TGeneratorNodeUnit)

  color:TRGBAColor;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit, ColorSelectionFormUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TSolidColorGeneratorNodeUnit.Create;
begin
  inherited;
  color.Eqv(1,1,0,1);
  AddParam_Color('Color',@color);
end;

destructor TSolidColorGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TSolidColorGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  Node.TextureGenerator.Generate_SolidColor(Color.r,Color.g,Color.b,1);
end;

procedure TSolidColorGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
  Node.TextureRenderer:=TTextureGenerator.Create;
  Node.TextureRenderer.Width := _sizex;
  Node.TextureRenderer.Height := _sizey;
  Node.TextureRenderer.Generate_SolidColor(Color.r,Color.g,Color.b,1);
end;

end.

