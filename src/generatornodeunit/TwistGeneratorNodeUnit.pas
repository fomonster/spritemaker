unit TwistGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TTwistGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Amount,Size,ZoomIn,ZoomOut,XPos,YPos:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;

end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TTwistGeneratorNodeUnit.Create;
begin
  inherited;
  Amount:=0;
  Size:=0;
  ZoomIn:=0;
  ZoomOut:=500;
  XPos:=0;
  YPos:=0;
  AddParam_Int('Amount',-5000,5000,@Amount);
  AddParam_Int('Size',0,500,@Size);
  AddParam_Int('ZoomIn',-5000,5000,@ZoomIn);
  AddParam_Int('ZoomOut',0,5000,@ZoomOut);
  AddParam_Int('XPos',-1000,1000,@XPos);
  AddParam_Int('YPos',-1000,1000,@YPos);
end;

destructor TTwistGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TTwistGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded then begin
    Node.TextureGenerator.Transform_Twist(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,Amount/500,Size/500,ZoomIn/500,ZoomOut/500,XPos/1000,YPos/1000);
  end;
end;

procedure TTwistGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 0) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.Transform_Twist(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,Amount/500,Size/500,ZoomIn/500,ZoomOut/500,XPos/1000,YPos/1000);

    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
  end;
end;

end.

