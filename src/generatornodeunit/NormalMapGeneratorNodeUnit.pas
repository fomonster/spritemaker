unit NormalMapGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TNormalMapGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Relief,NormalMapSmooth,Invert:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TNormalMapGeneratorNodeUnit.Create;
begin
  inherited;
  Relief:=100;
  NormalMapSmooth:=3;
  Invert:=0;
  AddParam_List('Mode','Normal=0,Inverted=1',@Invert);
  AddParam_Int('Relief',0,200,@Relief);
  AddParam_Int('NMSmooth',0,50,@NormalMapSmooth);
end;

destructor TNormalMapGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TNormalMapGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Lighting_NormalMap(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,Relief/100,NormalMapSmooth,Invert);
  end;
end;

procedure TNormalMapGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.Lighting_NormalMap(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,Relief/100,NormalMapSmooth,Invert);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  end;
end;

end.

