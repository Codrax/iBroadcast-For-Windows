{***********************************************************}
{                  Codruts Variabile Helpers                }
{                                                           }
{                        version 0.2                        }
{                           ALPHA                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                   -- WORK IN PROGRESS --                  }
{***********************************************************}

{$SCOPEDENUMS ON}

unit Cod.Helpers.Vcl;

interface
uses
  System.SysUtils, System.Classes, IdHTTP, System.IniFiles,
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF}
  VCL.Graphics, Winapi.ActiveX, Winapi.URLMon, IOUtils, System.Generics.Collections,
  System.Generics.Defaults, Vcl.Imaging.pngimage, Vcl.Dialogs, Cod.Helpers,
  WinApi.GdipObj, WinApi.GdipApi, Win.Registry, Cod.GDI, Cod.Types, Vcl.Themes,
  DateUtils, Cod.Registry, UITypes, Vcl.Menus, Types, Vcl.Forms, Vcl.Controls,
  Vcl.StdCtrls;

type

  // Popup Menu Helper
  TPopupMenuHelper = class helper for TPopupMenu
  public
    procedure Popup(P: TPoint); overload; inline;
    procedure PopupAtMouseCursor; overload; inline;
  end;

  // List Box Helper
  TListBoxHelper = class helper for TListBox
  public
    function GetSelectedItems: TArray<integer>; overload; inline;
    function GetSelectedItemCount: integer; overload; inline;
  end;

  // Common Dialog Helper
  TCommonDialogHelper = class helper for TCommonDialog
  public
    function ExecuteNoStyle: boolean;
  end;

  // Canvas
  TCanvasHelper = class helper for TCanvas
    procedure DrawHighQuality(ARect: TRect; Bitmap: TBitmap; Opacity: Byte = 255; HighQuality: Boolean = False); overload;
    procedure DrawHighQuality(ARect: TRect; Graphic: TGraphic; Opacity: Byte = 255; HighQuality: Boolean = False); overload;

    procedure StretchDraw(DestRect, SrcRect: TRect; Bitmap: TBitmap; Opacity: Byte); overload;
    procedure StretchDraw(Rect: TRect; Graphic: TGraphic; AOpacity: Byte); overload;

    procedure MoveTo(P: TPoint); overload;
    procedure LineTo(P: TPoint); overload;

    procedure Line(P1, P2: TPoint);

    procedure CopyRect(const Dest: TRect; Canvas: TCanvas; const Source: TRect; Opacity: Byte); overload;

    procedure GDIText(Text: string; Rectangle: TRect; AlignH: TLayout = TLayout.Beginning; AlignV: TLayout = TLayout.Beginning; Angle: integer = 0);
    procedure GDITint(Rectangle: TRect; Color: TColor; Opacity: byte = 75);
    procedure GDIRectangle(Rectangle: TRect; Brush: TGDIBrush; Pen: TGDIPen);
    procedure GDIRoundRect(Rectangle: TRect; Roundness: integer; Brush: TGDIBrush; Pen: TGDIPen); overload;
    procedure GDIRoundRect(RoundRect: TRoundRect; Brush: TGDIBrush; Pen: TGDIPen); overload;
    procedure GDICircle(Rectangle: TRect; Brush: TGDIBrush; Pen: TGDIPen);
    procedure GDIPolygon(Points: TArray<TPoint>; Brush: TGDIBrush; Pen: TGDIPen);
    procedure GDILine(Line: TLine; Pen: TGDIPen);
    procedure GDIRoundedLine(Line: TLine; Pen: TGDIPen);
    procedure GDIRoundedCornerLine(Points: TPointsF; Pen: TGDIPen; Radius: single); overload;
    procedure GDIGraphic(Graphic: TGraphic; Rect: TRect); overload;
    procedure GDIGraphic(Graphic: TGraphic; Rect: TRect; Angle: integer); overload;
    procedure GDIGraphicRound(Graphic: TGraphic; Rect: TRect; Round: real);
  end;

  // TIniFile
  TIniFileHelper = class helper for TIniFile
  public
    function ReadString(const Section, Ident, Default: string; StringSize: integer=2047): string; overload;
  end;

implementation

{ TCanvasHelper }
procedure TCanvasHelper.DrawHighQuality(ARect: TRect; Bitmap: TBitmap; Opacity: Byte = 255; HighQuality: Boolean = False);
begin
  DrawGraphicHighQuality(Self, ARect, Bitmap, Opacity, HighQuality);
end;

procedure TCanvasHelper.DrawHighQuality(ARect: TRect; Graphic: TGraphic; Opacity: Byte = 255; HighQuality: Boolean = False);
begin
  DrawGraphicHighQuality(Self, ARect, Graphic, Opacity, HighQuality);
end;

procedure TCanvasHelper.StretchDraw(DestRect, SrcRect: TRect; Bitmap: TBitmap; Opacity: Byte);
begin
  GraphicStretchDraw( Self, DestRect, SrcRect, BitMap, Opacity);
end;

procedure TCanvasHelper.StretchDraw(Rect: TRect; Graphic: TGraphic; AOpacity: Byte);
begin
  GraphicStretchDraw(Self, Rect, Graphic, AOpacity);
end;

procedure TCanvasHelper.CopyRect(const Dest: TRect; Canvas: TCanvas; const Source: TRect; Opacity: Byte);
var
  BlendFunction: TBlendFunction;
begin
  // Set up the blending parameters
  BlendFunction.BlendOp := AC_SRC_OVER;
  BlendFunction.BlendFlags := 0;
  BlendFunction.SourceConstantAlpha := Opacity;
  BlendFunction.AlphaFormat := AC_SRC_OVER;

  // Perform the alpha blending
  AlphaBlend(
    Self.Handle, Dest.Left, Dest.Top, Dest.Width, Dest.Height,
    Canvas.Handle, Source.Left, Source.Top, Source.Width, Source.Height,
    BlendFunction
  );
end;

procedure TCanvasHelper.GDIText(Text: string; Rectangle: TRect; AlignH,
  AlignV: TLayout; Angle: integer);
var
  AFont: TGPFont;
  AFormat: TGPStringFormat;
  FontStyle: integer;
begin
  // Font Style
  FontStyle := 0;
  if fsBold in Font.Style then
    FontStyle := FontStyle or FontStyleBold;
  if fsItalic in Font.Style then
    FontStyle := FontStyle or FontStyleItalic;
  if fsUnderline in Font.Style then
    FontStyle := FontStyle or FontStyleUnderline;
  if fsStrikeOut in Font.Style then
    FontStyle := FontStyle or FontStyleStrikeout;

  // Font
  AFont := TGPFont.Create(Font.Name, Font.Size, FontStyle, UnitPixel);
  AFormat:= TGPStringFormat.Create;
  try
    AFormat.SetAlignment(StringAlignment(integer(AlignH)));
    AFormat.SetLineAlignment(StringAlignment(integer(AlignV)));

    // Draw
    DrawText(Self, Text, Rectangle, AFont, AFormat, Font.Color.MakeGDIBrush, Angle);
  finally
    AFont.Free;
    AFormat.Free;
  end;
end;

procedure TCanvasHelper.GDITint(Rectangle: TRect; Color: TColor; Opacity: byte = 75);
begin
  TintPicture(Self, Rectangle, Color, Opacity);
end;

procedure TCanvasHelper.Line(P1, P2: TPoint);
begin
  MoveTo(P1);
  LineTo(P2);
end;

procedure TCanvasHelper.LineTo(P: TPoint);
begin
  LineTo(P.X, P.Y);
end;

procedure TCanvasHelper.MoveTo(P: TPoint);
begin
  MoveTo(P.X, P.Y);
end;

procedure TCanvasHelper.GDIRectangle(Rectangle: TRect; Brush: TGDIBrush;
  Pen: TGDIPen);
begin
  DrawRectangle(Self, Rectangle, Brush, Pen);
end;

procedure TCanvasHelper.GDIRoundedCornerLine(Points: TPointsF; Pen: TGDIPen; Radius: single);
begin
  DrawRoundedCornerLine(Self, Points, Pen, Radius);
end;

procedure TCanvasHelper.GDIRoundedLine(Line: TLine; Pen: TGDIPen);
begin
  DrawRoundedLine(Self, Line, Pen);
end;

procedure TCanvasHelper.GDIRoundRect(Rectangle: TRect; Roundness: integer;
  Brush: TGDIBrush; Pen: TGDIPen);
begin
  GDIRoundRect(TRoundRect.Create(Rectangle, Roundness), Brush, Pen);
end;

procedure TCanvasHelper.GDIRoundRect(RoundRect: TRoundRect; Brush: TGDIBrush; Pen: TGDIPen);
begin
  DrawRoundRect(Self, RoundRect, Brush, Pen);
end;

procedure TCanvasHelper.GDICircle(Rectangle: TRect; Brush: TGDIBrush; Pen: TGDIPen);
begin
  DrawCircle(Self, Rectangle, Brush, Pen);
end;

procedure TCanvasHelper.GDIPolygon(Points: TArray<TPoint>; Brush: TGDIBrush; Pen: TGDIPen);
begin
  DrawPolygon(Self, Points, Brush, Pen);
end;

procedure TCanvasHelper.GDILine(Line: TLine; Pen: TGDIPen);
begin
  DrawLine(Self, Line, Pen);
end;

procedure TCanvasHelper.GDIGraphic(Graphic: TGraphic; Rect: TRect);
begin
  DrawGraphic(Self, Graphic, Rect, 0);
end;

procedure TCanvasHelper.GDIGraphic(Graphic: TGraphic; Rect: TRect; Angle: integer);
begin
  DrawGraphic(Self, Graphic, Rect, Angle);
end;

procedure TCanvasHelper.GDIGraphicRound(Graphic: TGraphic; Rect: TRect; Round: real);
begin
  DrawGraphicRound(Self, Graphic, Rect, Round);
end;

{ TPopupMenuHelper }

procedure TPopupMenuHelper.Popup(P: TPoint);
begin
  Popup(P.X, P.Y);
end;

procedure TPopupMenuHelper.PopupAtMouseCursor;
begin
  Popup( Mouse.CursorPos );
end;

{ TIniFileHelper }

function TIniFileHelper.ReadString(const Section, Ident, Default: string;
  StringSize: integer): string;
var
  Buffer: PChar;
  BufSize: NativeInt;
begin
  BufSize := StringSize * SizeOf(char);
  Buffer := AllocMem(BufSize);
  try
    SetString(Result, Buffer, GetPrivateProfileString(MarshaledString(Section),
      MarshaledString(Ident), MarshaledString(Default), Buffer, Length(Buffer),
      MarshaledString(FileName)));
  finally
    FreeMem(Buffer, BufSize);
  end;
end;

{ TListBoxHelper }

function TListBoxHelper.GetSelectedItemCount: integer;
begin
  Result := 0;
  for var I := 0 to Items.Count-1 do
    if Selected[I] then
      Inc(Result);
end;

function TListBoxHelper.GetSelectedItems: TArray<integer>;
begin
  Result := [];
  for var I := 0 to Items.Count-1 do
    if Selected[I] then
      Result := Result + [I];
end;

{ TCommonDialogHelper }

function TCommonDialogHelper.ExecuteNoStyle: boolean;
begin
  TStyleManager.SystemHooks := TStyleManager.SystemHooks - [shDialogs];
  Result := Self.Execute;
  TStyleManager.SystemHooks := TStyleManager.SystemHooks + [shDialogs];
end;

end.