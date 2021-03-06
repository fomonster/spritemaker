unit MoveGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TMoveGeneratorNodeUnit=class(TGeneratorNodeUnit)

  deltax,deltay:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TMoveGeneratorNodeUnit.Create;
begin
  inherited;
  deltax:=0;
  deltay:=0;
  AddParam_Int('DeltaX',-1000,1000,@deltax);
  AddParam_Int('DeltaY',-1000,1000,@deltay);
end;

destructor TMoveGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TMoveGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Transform_Move(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,round(Node.TextureGenerator.Width*deltax/200),round(Node.TextureGenerator.Height*deltay/200));
  end;
end;

procedure TMoveGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.Transform_Move(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,round(Node.TextureRenderer.width*deltax/200),round(Node.TextureRenderer.height*deltay/200));

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  
  end;
end;

end.

