unit FractalizeGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TFractalizeGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Iterations,Blend:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TFractalizeGeneratorNodeUnit.Create;
begin
  inherited;
  Iterations:=10;
  Blend:=0;
  AddParam_Int('Iterations',0,100,@Iterations);
  AddParam_Int('Blend',0,2,@Blend);
end;

destructor TFractalizeGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TFractalizeGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Transform_Fractalize(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,Iterations,Blend);
  end;
end;

procedure TFractalizeGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.Transform_Fractalize(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,Iterations,Blend);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  end;
end;

end.

