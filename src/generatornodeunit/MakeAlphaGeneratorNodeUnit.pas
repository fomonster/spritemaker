unit MakeAlphaGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TMakeAlphaGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Inversed:Integer;

  speRadius:TSpinEditOnPanel;
  speRadiusTB:TTrackBarOnPanel;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TMakeAlphaGeneratorNodeUnit.Create;
begin
  inherited;
  Inversed:=0;
  AddParam_Int('Inversed',0,1,@Inversed);
end;

destructor TMakeAlphaGeneratorNodeUnit.Destroy;
begin
  inherited;
end;

procedure TMakeAlphaGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 1) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded
                            and Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.SetFrom(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator);
    Node.TextureGenerator.Transparency_MakeAlpha(Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator,Inversed);
  end;
end;

procedure TMakeAlphaGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
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

    Node.TextureRenderer.SetFrom(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer);
    Node.TextureRenderer.Transparency_MakeAlpha(Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer,Inversed);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;

    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer:=nil;
                            
  end;
end;

end.

