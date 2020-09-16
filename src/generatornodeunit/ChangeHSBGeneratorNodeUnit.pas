unit ChangeHSBGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TChangeHSBGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Hue,Saturation,Brightness:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TChangeHSBGeneratorNodeUnit.Create;
begin
  inherited;
  hue:=0;
  saturation:=0;
  brightness:=0;
  AddParam_Int('hue',-360,360,@hue);
  AddParam_Int('saturation',-100,100,@saturation);
  AddParam_Int('brightness',-100,100,@brightness);
end;

destructor TChangeHSBGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TChangeHSBGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.SetFrom(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator);
    Node.TextureGenerator.Color_ChangeHSB(hue,brightness,saturation);
  end;
end;

procedure TChangeHSBGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
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
    Node.TextureRenderer.Color_ChangeHSB(hue,brightness,saturation);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  end;
end;

end.

