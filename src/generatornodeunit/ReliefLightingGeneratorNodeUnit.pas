unit ReliefLightingGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TReliefLightingGeneratorNodeUnit=class(TGeneratorNodeUnit)

  LightX,LightY,LightZ,Relief,NormalMapSmooth,Invert:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TReliefLightingGeneratorNodeUnit.Create;
begin
  inherited;
  LightX:=0;
  LightY:=0;
  LightZ:=0;
  Relief:=100;
  Invert:=0;
  NormalMapSmooth:=3;
  AddParam_Int('LightX',-100,100,@LightX);
  AddParam_Int('LightY',-100,100,@LightY);
  AddParam_Int('LightZ',-100,100,@LightZ);
  AddParam_List('Mode','Normal=0,Inverted=1',@Invert);
  AddParam_Int('Relief',0,200,@Relief);
  AddParam_Int('NMSmooth',0,50,@NormalMapSmooth);
end;

destructor TReliefLightingGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TReliefLightingGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 1) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded
                            and Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Lighting_ReliefLighting(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator,LightX/50,LightY/50,LightZ/50,Relief/100,NormalMapSmooth,Invert);
  end;
end;

procedure TReliefLightingGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 1) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded
                            and (Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer.IsLoaded then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.Lighting_ReliefLighting(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer,LightX/50,LightY/50,LightZ/50,Relief/100,NormalMapSmooth,Invert);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;

    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer:=nil;
  end;
end;

end.

