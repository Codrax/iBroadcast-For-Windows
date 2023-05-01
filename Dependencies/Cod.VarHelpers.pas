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

unit Cod.VarHelpers;

interface
  uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, IdHTTP,
  VCL.Graphics, Winapi.ActiveX, URLMon, IOUtils, System.Generics.Collections,
  Cod.ColorUtils, System.Generics.Defaults, Vcl.Imaging.pngimage,
  WinApi.GdipObj, WinApi.GdipApi, Win.Registry, Cod.GDI, Cod.Types,
  DateUtils, Cod.WinRegister;

  type
    // Color Helper
    TColorHelper = record helper for TColor
    public
      function ToString: string; overload; inline;
      function ToInteger: integer; overload; inline;
      function ToRGB: CRGB; overload; inline;
    end;

    // TDateTime Helper
    TDateTimeHelper = record helper for TDateTime
    public
      function ToString: string; overload; inline;
      function ToInteger: integer; overload; inline;

      function Day: integer;
      function Month: integer;
      function Year: integer;

      function Hour: integer;
      function Minute: integer;
      function Second: integer;
      function Millisecond: integer;
    end;

    // TArray colection
    TArrayUtils<T> = class
    public
      class function Contains(const x : T; const anArray : array of T) : boolean;
      class function GetIndex(const x : T; const anArray : array of T) : integer;
    end;

    // TArray generic types
    TArrayArrayHelper = record helper for TArray<TArray>
    public
      function Count: integer; overload; inline;
      procedure SetToLength(ALength: integer);
    end;

    TStringArrayHelper = record helper for TArray<string>
    public
      function Count: integer; overload; inline;
      procedure SetToLength(ALength: integer);
    end;

    TIntegerArrayHelper = record helper for TArray<integer>
    public
      function Count: integer; overload; inline;
      procedure SetToLength(ALength: integer);
    end;

    TRealArrayHelper = record helper for TArray<real>
    public
      function Count: integer; overload; inline;
      procedure SetToLength(ALength: integer);
    end;

    // TFont
    TAdvFont = type string;

    TAdvFontHelper = record helper for TAdvFont
      function ToString: string;
      procedure FromString(AString: string);
    end;

    // Canvas
    TCanvasHelper = class helper for TCanvas
      procedure DrawHighQuality(ARect: TRect; Bitmap: TBitmap; Opacity: Byte = 255; HighQuality: Boolean = False); overload;
      procedure DrawHighQuality(ARect: TRect; Graphic: TGraphic; Opacity: Byte = 255; HighQuality: Boolean = False); overload;

      procedure StretchDraw(DestRect, SrcRect: TRect; Bitmap: TBitmap; Opacity: Byte); overload;
      procedure StretchDraw(Rect: TRect; Graphic: TGraphic; AOpacity: Byte); overload;

      procedure GDITint(Rectangle: TRect; Color: TColor; Opacity: byte = 75);
      procedure GDIRectangle(Rectangle: TRect; Brush: TGDIBrush; Pen: TGDIPen);
      procedure GDIRoundRect(RoundRect: TRoundRect; Brush: TGDIBrush; Pen: TGDIPen);
      procedure GDICircle(Rectangle: TRect; Brush: TGDIBrush; Pen: TGDIPen);
      procedure GDIPolygon(Points: TArray<TPoint>; Brush: TGDIBrush; Pen: TGDIPen);
      procedure GDILine(Line: TLine; Pen: TGDIPen);
      procedure GDIGraphic(Graphic: TGraphic; Rect: TRect);
      procedure GDIGraphicRound(Graphic: TGraphic; Rect: TRect; Round: real);
    end;

    // Registry
    TRegHelper = Cod.WinRegister.TRegHelper;

implementation

{ TArrayUtils<T> }

class function TArrayUtils<T>.Contains(const x: T; const anArray: array of T): boolean;
var
  y : T;
  lComparer: IEqualityComparer<T>;
begin
  lComparer := TEqualityComparer<T>.Default;
  for y in anArray do
  begin
    if lComparer.Equals(x, y) then
      Exit(True);
  end;
  Exit(False);
end;

class function TArrayUtils<T>.GetIndex(const x : T; const anArray : array of T) : integer;
var
  I: Integer;
  y: T;
  lComparer: IEqualityComparer<T>;
begin
  lComparer := TEqualityComparer<T>.Default;
  for I := Low(anArray) to High(anArray) do
    begin
      y := anArray[I];

      if lComparer.Equals(x, y) then
        Exit(I);
    end;
    Exit(-1);
end;

// Color
function TColorHelper.ToString: string;
begin
  Result := colortostring( Self );
end;

function TColorHelper.ToInteger: integer;
begin
  Result := ColorToRgb( Self );
end;

function TColorHelper.ToRGB: CRGB;
begin
  Result := GetRGB( Self );
end;

// Date Time
function TDateTimeHelper.ToString: string;
begin
  Result := DateTimeToStr( Self );
end;

function TDateTimeHelper.ToInteger: integer;
begin
  Result := DateTimeToUnix(Self);
end;

function TDateTimeHelper.Day: integer;
begin
  Result := DayOf( Self );
end;

function TDateTimeHelper.Month: integer;
begin
  Result := MonthOf( Self );
end;

function TDateTimeHelper.Year: integer;
begin
  Result := YearOf( Self );
end;

function TDateTimeHelper.Hour: integer;
begin
  Result := HourOf( Self );
end;

function TDateTimeHelper.Minute: integer;
begin
  Result := MinuteOf( Self );
end;

function TDateTimeHelper.Second: integer;
begin
  Result := SecondOf( Self );
end;

function TDateTimeHelper.Millisecond: integer;
begin
  Result := MillisecondOf( Self );
end;

// TArray Generic Helpers

function TArrayArrayHelper.Count: integer;
begin
  Result := length(Self);
end;

function TStringArrayHelper.Count: integer;
begin
  Result := length(Self);
end;

function TIntegerArrayHelper.Count: integer;
begin
  Result := length(Self);
end;

function TRealArrayHelper.Count: integer;
begin
  Result := length(Self);
end;

procedure TArrayArrayHelper.SetToLength(ALength: integer);
begin
  SetLength(Self, ALength);
end;

procedure TStringArrayHelper.SetToLength(ALength: integer);
begin
  SetLength(Self, ALength);
end;

procedure TIntegerArrayHelper.SetToLength(ALength: integer);
begin
  SetLength(Self, ALength);
end;

procedure TRealArrayHelper.SetToLength(ALength: integer);
begin
  SetLength(Self, ALength);
end;

// TFont
function TAdvFontHelper.ToString: string;
begin

end;

procedure TAdvFontHelper.FromString(AString: string);
begin
  //TFont(Self).
end;

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

procedure TCanvasHelper.GDITint(Rectangle: TRect; Color: TColor; Opacity: byte = 75);
begin
  TintPicture(Self, Rectangle, Color, Opacity);
end;

procedure TCanvasHelper.GDIRectangle(Rectangle: TRect; Brush: TGDIBrush; Pen: TGDIPen);
begin
  DrawRectangle(Self, Rectangle, Brush, Pen);
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
  DrawGraphic(Self, Graphic, Rect);
end;

procedure TCanvasHelper.GDIGraphicRound(Graphic: TGraphic; Rect: TRect; Round: real);
begin
  DrawGraphicRound(Self, Graphic, Rect, Round);
end;

end.