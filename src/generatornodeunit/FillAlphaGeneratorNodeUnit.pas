unit FillAlphaGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TFillAlphaGeneratorNodeUnit=class(TGeneratorNodeUnit)

  alpha:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TFillAlphaGeneratorNodeUnit.Create;
begin
  inherited;
  alpha:=0;
  AddParam_Int('Alpha',0,100,@Alpha);
end;

destructor TFillAlphaGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TFillAlphaGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.SetFrom(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator);
    Node.TextureGenerator.Transparency_FillAlpha(alpha/100);
  end;
end;

procedure TFillAlphaGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.SetFrom(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer);
    Node.TextureRenderer.Transparency_FillAlpha(alpha/100);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  end;
end;

end.

