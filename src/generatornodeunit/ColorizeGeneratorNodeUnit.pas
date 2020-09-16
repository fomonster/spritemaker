unit ColorizeGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit, SSColor;

type

TColorizeGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Mode,Method:Integer;
  color:TRGBAColor;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TColorizeGeneratorNodeUnit.Create;
begin
  inherited;
  Mode:=0;
  Color.Eqv(0,0,0,0);
  AddParam_List('Method','1-C^2=0,C^2=1,1-C^3=2,C^3=3,1-C^4=4,C^4=5,DIV=6,SIN=7,1-SIN=8',@Method);
  AddParam_Color('Color',@Color);
  AddParam_Int('Mode',0,10000,@Mode);
end;

destructor TColorizeGeneratorNodeUnit.Destroy;
begin
  inherited;
end;

procedure TColorizeGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.SetFrom(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator);
    Node.TextureGenerator.Color_Colorize(color,mode,Method);
  end;
end;

procedure TColorizeGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
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
    Node.TextureRenderer.Color_Colorize(color,mode,Method);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  end;
end;

end.

