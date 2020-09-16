unit RotateGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TRotateGeneratorNodeUnit=class(TGeneratorNodeUnit)

  angle:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit, SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TRotateGeneratorNodeUnit.Create;
begin
  inherited;
  angle:=0;
  AddParam_Int('Angle',-360,360,@angle);
end;

destructor TRotateGeneratorNodeUnit.Destroy;
begin
  inherited;
end;

procedure TRotateGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Transform_Rotate(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,angle);
  end;
end;

procedure TRotateGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.Transform_Rotate(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,angle);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  
  end;
end;

end.

