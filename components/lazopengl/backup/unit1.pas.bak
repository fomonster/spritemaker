unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, openglboxcomponent;

type
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    OpenGLBox1: TOpenGLBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  gl;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  glClearColor(0, 0, 0, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  
  glBegin(GL_TRIANGLES);
  glColor3f(1, 0, 0); glVertex2f(0, 0.5);
  glColor3f(0, 1, 0); glVertex2f(-0.5, 0);
  glColor3f(0, 0, 1); glVertex2f(0.5, -0.5);
  glEnd();
  
  OpenGLBox1.SwapBuffers;
end;

initialization
  {$I unit1.lrs}

end.

