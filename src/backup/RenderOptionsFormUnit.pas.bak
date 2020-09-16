unit RenderOptionsFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, StdCtrls, ComCtrls, Gradient, ConstantsUnit;

type

  { TRenderOptionsForm }

  TRenderOptionsForm = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LazGradient1: TLazGradient;
    LazGradient5: TLazGradient;
    Panel1: TPanel;
    PanelLeftHeader1: TPanel;
    PanelRight: TPanel;
    PanelRight2: TPanel;
    PanelScreen: TPanel;
    PanelScreen2: TPanel;
    PanelTop: TPanel;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  RenderOptionsForm: TRenderOptionsForm;

implementation

{ TRenderOptionsForm }

procedure TRenderOptionsForm.SpeedButton1Click(Sender: TObject);
begin
  RenderTextureWidth:=StrToIntDef(ComboBox1.Text,256);
  RenderTextureHeight:=StrToIntDef(ComboBox2.Text,256);
  Close;
end;

procedure TRenderOptionsForm.FormShow(Sender: TObject);
begin
  ComboBox1.Text:=IntToStr(RenderTextureWidth);
  ComboBox2.Text:=IntToStr(RenderTextureHeight);
end;

initialization
  {$I RenderOptionsFormUnit.lrs}

end.

