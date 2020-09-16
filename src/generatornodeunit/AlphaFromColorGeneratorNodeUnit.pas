unit AlphaFromColorGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TAlphaFromColorGeneratorNodeUnit=class(TGeneratorNodeUnit)

  method,constant,red,green,blue:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TAlphaFromColorGeneratorNodeUnit.Create;
begin
  inherited;
  method:=0;
  constant:=0;
  red:=100;
  green:=0;
  blue:=0;
  AddParam_Int('Method',0,1,@method);
  AddParam_Int('Constant',0,100,@constant);
  AddParam_Int('Red',0,100,@red);
  AddParam_Int('Green',0,100,@green);
  AddParam_Int('Blue',0,100,@blue);
end;

destructor TAlphaFromColorGeneratorNodeUnit.Destroy;
begin
  inherited;
end;

procedure TAlphaFromColorGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.SetFrom(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator);
    Node.TextureGenerator.Transparency_AlphaFromColor(method,constant/100,red/100,green/100,blue/100);
  end;
end;

procedure TAlphaFromColorGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
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
    Node.TextureRenderer.Transparency_AlphaFromColor(method,constant/100,red/100,green/100,blue/100);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;

  end;
end;

end.

