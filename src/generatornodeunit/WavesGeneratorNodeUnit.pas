unit WavesGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TWavesGeneratorNodeUnit=class(TGeneratorNodeUnit)

  method,ax,bx,ay,by:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TWavesGeneratorNodeUnit.Create;
begin
  inherited;
  method:=0;
  ax:=0;
  bx:=0;
  ay:=0;
  by:=0;
  AddParam_Int('method',0,3,@method);
  AddParam_Int('ax',-1000,1000,@ax);
  AddParam_Int('bx',-100,100,@bx);
  AddParam_Int('ay',-1000,1000,@ay);
  AddParam_Int('by',-100,100,@by);
end;

destructor TWavesGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TWavesGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Transform_Waves(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,method,ax/500,bx,ay/500,by);
  end;
end;

procedure TWavesGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.Transform_Waves(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,method,ax/500,bx,ay/500,by);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  end;
end;

end.

