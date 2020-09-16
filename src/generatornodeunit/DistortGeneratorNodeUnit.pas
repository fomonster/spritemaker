unit DistortGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TDistortGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Direction,Distance,Mode:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TDistortGeneratorNodeUnit.Create;
begin
  inherited;
  Direction:=1000;
  Distance:=1000;
  Mode:=0;
  AddParam_List('Mode','SINSIN=0,SINCOS=1,COSSIN=2,COSCOS=3',@Mode);
  AddParam_Int('Direction',0,1000,@Direction);
  AddParam_Int('Distance',0,1000,@Distance);
end;

destructor TDistortGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TDistortGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 2) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded
                            and Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator.IsLoaded
                            and Node.GeneratorNodeList[Node.Childs[2]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Transform_Distort(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,
                                           Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator,
                                           Node.GeneratorNodeList[Node.Childs[2]].TextureGenerator,Direction/1000,Distance/1000,Mode);
                            
  end;
end;

procedure TDistortGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
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
    Node.TextureRenderer.Transform_Distort(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,
                                          Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer,
                                          Node.GeneratorNodeList[Node.Childs[2]].TextureRenderer,Direction/1000,Distance/1000,Mode);
  
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer:=nil;
    Node.GeneratorNodeList[Node.Childs[2]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[2]].TextureRenderer:=nil;
  end;
end;
  
end.

