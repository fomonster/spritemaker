program TextureMaker;

{$mode objfpc}{$H+}


uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazgradient, lazrichview, 
  MainFormUnit, RenderFormUnit, RenderOptionsFormUnit,SSPictureViewScroll, AboutFormUnit,
  ColorSelectionFormUnit;


{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='SpriteMaker - spritepacker.com';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TColorSelectionForm, ColorSelectionForm);
  Application.CreateForm(TRenderForm, RenderForm);
  Application.CreateForm(TRenderOptionsForm, RenderOptionsForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.

