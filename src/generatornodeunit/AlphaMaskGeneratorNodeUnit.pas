unit AlphaMaskGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TAlphaMaskGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Inversed:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TAlphaMaskGeneratorNodeUnit.Create;
begin
  inherited;
  Inversed:=0;
  AddParam_Int('Inversed',0,1,@Inversed);
end;

destructor TAlphaMaskGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TAlphaMaskGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 2) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded
                            and Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator.IsLoaded
                            and Node.GeneratorNodeList[Node.Childs[2]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Combine_AlphaMask(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,
                                            Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator,
                                            Node.GeneratorNodeList[Node.Childs[2]].TextureGenerator,Inversed);
                            
  end;
end;

procedure TAlphaMaskGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 2) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded
                            and (Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer.IsLoaded
                            and (Node.GeneratorNodeList[Node.Childs[2]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[2]].TextureRenderer.IsLoaded
  then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;
    Node.TextureRenderer.Combine_AlphaMask(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,
                                           Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer,
                                           Node.GeneratorNodeList[Node.Childs[2]].TextureRenderer,Inversed);
  
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer:=nil;
    Node.GeneratorNodeList[Node.Childs[2]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[2]].TextureRenderer:=nil;
  end;
end;
  
end.

