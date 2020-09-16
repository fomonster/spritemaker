(*
** TOpenGLBox component
** by Kostas "Bad Sector" Michalopoulos
*)
unit openglboxcomponent;

{$mode objfpc}{$H+}

interface

{$IFNDEF WIN32}
{$DEFINE UseGTK}
{$ENDIF}

uses
  Classes, SysUtils, LMessages, LResources, Controls, Graphics, gl,
  {$IFDEF WIN32}
  Windows;
  {$ENDIF}
  {$IFDEF UseGTK}
  glx, gtk, gdk, x, xlib, xutil;
  {$ENDIF}
  
type
  TOpenGLBox = class(TWinControl)
  private
    {$IFDEF WIN32}
    FRC: HGLRC;
    GLDC: HDC;
    {$ENDIF}
    
    {$IFDEF UseGTK}
    FRC: GLXContext;
    FDisplay: xlib.PDisplay;
    FWindow: x.TWindow;
    FGLWin: x.TWindow;
    {$ENDIF}
    FMapped: Boolean;
    
    FRedBits, FGreenBits, FBlueBits, FDepthBits, FStencilBits: Integer;

    procedure WMPaint(var Message: TLMPaint); message LM_PAINT;
    procedure InitRC;
    procedure InitGL;
    procedure UpdateGL;
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy;

    procedure SwapBuffers;
  published
    property Width default 320;
    property Height default 240;
    property Align;
    property BorderSpacing;
    
    property RedBits: Integer read FRedBits write FRedBits default 8;
    property GreenBits: Integer read FGreenBits write FGreenBits default 8;
    property BlueBits: Integer read FBlueBits write FBlueBits default 8;
    property DepthBits: Integer read FDepthBits write FDepthBits default 24;
    property StencilBits: Integer read FStencilBits write FStencilBits default 0;
  end;


procedure Register;

implementation

{ TOpenGLBox }
constructor TOpenGLBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  {$IFDEF WIN32}
  FRC:=0;
  {$ENDIF}
  
  {$IFDEF UseGTK}
  FRC:=nil;
  FGLWin:=0;
  {$ENDIF}
  
  FMapped:=False;
end;

destructor TOpenGLBox.Destroy;
begin
  {$IFDEF WIN32}
  wglDeleteContext(FRC);
  FRC:=0;
  ReleaseDC(Handle, GLDC);
  GLDC:=0;
  {$ENDIF}
  
  {$IFDEF UseGTK}
  glXDestroyContext(FDisplay, FRC);
  XDestroyWindow(FDisplay, FGLWin);
  {$ENDIF}
end;

procedure TOpenGLBox.WMPaint(var Message: TLMPaint);
var
  Canvas: TCanvas;
begin
  if csDesigning in ComponentState then begin
    inherited WMPaint(Message);
    if Message.DC=0 then Exit;
    
    Canvas:=TControlCanvas.Create;
    TControlCanvas(Canvas).Control:=Self;

    Canvas.Lock;
    try
      Canvas.Handle := Message.DC;
      try

        Canvas.Brush.Color:=clBlack;
        Canvas.Rectangle(-1, -1, Width + 1, Height + 1);
        Canvas.Pen.Color:=clRed;
        Canvas.Line(0, 0, Width, Height);
        Canvas.Line(Width, 0, 0, Height);
      finally
        Canvas.Handle := 0;
      end;
    finally
      Canvas.Unlock;
    end;

    Canvas.Destroy;
    Exit;
  end;

  {$IFDEF WIN32}
  if (FRC=0) and (Message.DC <> 0) then begin
  {$ENDIF}
  {$IFDEF UseGTK}
  if (FRC=nil) and (Message.DC <> 0) then begin
  {$ENDIF}
    InitRC;
  end;
end;

procedure TOpenGLBox.InitRC;
// Windows rendering context initialization
{$IFDEF WIN32}
var
  pfd: TPIXELFORMATDESCRIPTOR;
  fmt: Integer;
begin
  if not HandleAllocated then Exit;
  GLDC:=GetDC(Handle);
  
  ZeroMemory(@pfd, SizeOf(pfd));
  pfd.nSize:=SizeOf(pfd);
  pfd.nVersion:=1;
  pfd.dwFlags:=PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  pfd.iPixelType:=PFD_TYPE_RGBA;
  pfd.cColorBits:=RedBits + GreenBits + BlueBits;
  pfd.cDepthBits:=DepthBits;
  pfd.iLayerType:=PFD_MAIN_PLANE;
  fmt:=ChoosePixelFormat(GLDC, pfd);
  SetPixelFormat(GLDC, fmt, @pfd);
  FRC:=wglCreateContext(GLDC);
  wglMakeCurrent(GLDC, FRC);
end;
{$ENDIF}

// GTK rendering context initialization
{$IFDEF UseGTK}
var
  GWindow: gdk.PGdkWindow;
  XVInfo: PXVisualInfo;
  AttrList: array [0..12] of Integer;
  WinAttr: TXSetWindowAttributes;
  CMap: TColormap;
begin
//  HandleNeeded;
  if not HandleAllocated then Exit;
  GWindow:=PGtkWidget(Handle)^.window;
  FWindow:=PGdkWindowPrivate(GWindow)^.xwindow;
  FDisplay:=PGdkWindowPrivate(GWindow)^.xdisplay;
  AttrList[0]:=GLX_RGBA;
  AttrList[1]:=GLX_DOUBLEBUFFER;
  AttrList[2]:=GLX_RED_SIZE;
  AttrList[3]:=FRedBits;
  AttrList[4]:=GLX_GREEN_SIZE;
  AttrList[5]:=FGreenBits;
  AttrList[6]:=GLX_BLUE_SIZE;
  AttrList[7]:=FBlueBits;
  AttrList[8]:=GLX_DEPTH_SIZE;
  AttrList[9]:=FDepthBits;
  AttrList[10]:=GLX_STENCIL_SIZE;
  AttrList[11]:=FStencilBits;
  AttrList[12]:=0;
  XVInfo:=glXChooseVisual(FDisplay, DefaultScreen(FDisplay), @AttrList[0]);

  CMap:=XCreateColormap(FDisplay, FWindow, XVInfo^.visual, AllocNone);

  FillChar(WinAttr, SizeOf(WinAttr), 0);
  WinAttr.event_mask:=ExposureMask;
  WinAttr.colormap:=CMap;

  FGLWin:=XCreateWindow(FDisplay, FWindow, 0, 0, Width, Height, 0, XVInfo^.depth, InputOutput, XVInfo^.visual, CWColormap, @WinAttr);
//  Form1.Caption:=IntToStr(PtrInt(FGLWin));

  FRC:=glXCreateContext(FDisplay, XVInfo, nil, True);
  glXMakeCurrent(FDisplay, FGLWin, FRC);

  InitGL;
end;
{$ENDIF}

procedure TOpenGLBox.InitGL;
begin
  glShadeModel(GL_SMOOTH);
  glClearColor(0, 0, 0, 0);
  glClearDepth(1);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
  Resize;
  glFlush();
end;

procedure TOpenGLBox.UpdateGL;
var
  h: Integer;
begin
  {$IFDEF UseGTK}
  if FGLWin=0 then Exit;
  {$ENDIF}

  h:=Height;
  if h < 1 then h:=1;
  glViewport(0, 0, Width, Height);
end;

procedure TOpenGLBox.Resize;
begin
  inherited Resize;
  {$IFDEF UseGTK}
  if (not HandleAllocated) or (FGLWin=0) then Exit;
  if (Width > 0) and (Height > 0) then begin
    if not FMapped then begin
      FMapped:=True;
      XMapWindow(FDisplay, FGLWin);
    end;
    XResizeWindow(FDisplay, FGLWin, Width, Height)
  end else begin
    if FMapped then begin
      XUnmapWindow(FDisplay, FGLWin);
      FMapped:=False;
    end;
  end;
  {$ENDIF}
  UpdateGL;
end;

procedure TOpenGLBox.SwapBuffers;
begin
{$IFDEF WIN32}
  Windows.SwapBuffers(GLDC);
{$ENDIF}

{$IFDEF UseGTK}
  if (not HandleAllocated) or (FGLWin=0) then Exit;
  glXSwapBuffers(FDisplay, FGLWin);
{$ENDIF}
end;


procedure Register;
begin
  RegisterComponents('Additional', [TOpenGLBox]);
end;

initialization
  {$i openglbox.lrs}
end.

