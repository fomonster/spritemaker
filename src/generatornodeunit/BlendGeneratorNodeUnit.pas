unit BlendGeneratorNodeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GeneratorNodeUnit, RichView, RVStyle, SimSpin, SSXMLUnit;

type

TBlendGeneratorNodeUnit=class(TGeneratorNodeUnit)

  Method,Mode:Integer;

  constructor Create;override;
  destructor Destroy;override;

  procedure Generate;override;
  procedure RenderTexture(_sizex,_sizey:Integer);override;
end;

implementation

  Uses GeneratorTreeUnit,SSConstantsUnit, SSTextureGeneratorUnit, ConstantsUnit;

constructor TBlendGeneratorNodeUnit.Create;
begin
  inherited;
  Method:=0;
  Mode:=0;
  AddParam_List('Method','A + B=0,A - B=1,A * B=2,A xor B=3,A or B=4,A and B=5,A.hue + B.hue=6,A.hue - B.hue=7,A.hue * B.hue=8,A + B.brightness=9,A + B.rgb*B.a=10,A*(1-B.a) + B.rgb*B.a=11,A - B MOD=12,(A*1.5+0.5)*B=13,(A*2+0.5)*B=14,(A+0.5)'+'*B=15,A*(0.5+1.5*B)=16,A*(0.5+2*B)=17,A*(0.5+B)=18',@Method);
  AddParam_List('Mode','RGB1=0,RGBA=1',@Mode);
end;

destructor TBlendGeneratorNodeUnit.Destroy;
begin
  inherited;

end;

procedure TBlendGeneratorNodeUnit.Generate;
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 1) and Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator.IsLoaded
                            and Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator.IsLoaded then begin
    
    Node.TextureGenerator.Combine_Blend(Node.GeneratorNodeList[Node.Childs[0]].TextureGenerator,Node.GeneratorNodeList[Node.Childs[1]].TextureGenerator,Method,Mode);
  end;
end;

procedure TBlendGeneratorNodeUnit.RenderTexture(_sizex,_sizey:Integer);
  var
    Node:TGeneratorNode;
begin
  Node:=TGeneratorNode(GeneratorNodePtr);
  if (Node.ChildsCount > 1) and (Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.IsLoaded
                            and (Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer<>nil) and Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer.IsLoaded
  then begin

    if Node.TextureRenderer<>nil then Node.TextureRenderer.Destroy;
    Node.TextureRenderer:=TTextureGenerator.Create;
    Node.TextureRenderer.Width := _sizex;
    Node.TextureRenderer.Height := _sizey;

    Node.TextureRenderer.Combine_Blend(Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer,Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer,Method,Mode);
  
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[0]].TextureRenderer:=nil;
    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer.Destroy;
    Node.GeneratorNodeList[Node.Childs[1]].TextureRenderer:=nil;
  end;
end;
  
end.

