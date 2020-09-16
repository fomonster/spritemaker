unit EnvironmentMappingGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TEnvironmentMappingGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Plane,Mode:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TEnvironmentMappingGeneratorNodeUnit.Create;
begin
  inherited;
  Plane:=0;
  AddParam_List('Plane','LEFT=0,RIGHT=1,UP=2,DOWN=3,FRONT=4,BACK=5',@Plane);
  AddParam_List('Mode','SPHERE=0,GEO2=1,GEO4=2,GEOSIN=3,TEST=4',@Mode);
end;

destructor TEnvironmentMappingGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TEnvironmentMappingGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Project_EnvironmentMapping(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,Plane,Mode);
  end;
end;

procedure TEnvironmentMappingGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.Project_EnvironmentMapping(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,Plane,Mode);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  end;
end;

end.

