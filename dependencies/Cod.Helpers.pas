{***********************************************************}
{                  Codruts Variabile Helpers                }
{                                                           }
{                        version 1.0                        }
{                                                           }
{***********************************************************}

{$SCOPEDENUMS ON}

unit Cod.Helpers;

interface
uses
  {$IFDEF MSWINDOWS}
  Winapi.GDIPOBJ,
  Winapi.GDIPAPI,
  Winapi.Windows,
  {$ENDIF}
  System.SysUtils, System.Classes, Types, UITypes, IOUtils, Math,
  System.Generics.Collections, Vcl.Themes, DateUtils, System.UIConsts;

type
  // TColor Helper
  TColorHelper = record helper for TColor
  public
    // Change value
    function GetR: byte;
    function GetG: byte;
    function GetB: byte;

    procedure SetR(Value: byte);
    procedure SetG(Value: byte);
    procedure SetB(Value: byte);

    // Props
    property R: byte read GetR write SetR;
    property G: byte read GetG write SetG;
    property B: byte read GetB write SetB;

    // Utilities
    function ColorGrayscale(ToneDown: integer = 3): TColor;
    function ColorInvert: TColor;
    function ChangeSaturation(ByIncrement: integer): TColor;
    function Blend(WithColor: TColor; BlendAmount: byte): TColor;
    function GetLightValue: byte;

    // GDI
    {$IFDEF MSWINDOWS}
    function MakeGDIBrush(Alpha: byte=255): TGPSolidBrush;
    function MakeGDIPen(Alpha: byte=255; Width: Single = 1): TGPPen;
    {$ENDIF}

    // Convert
    function ToString: string; overload; inline;
    function ToHex: string; overload; inline; // RR GG BB
    function ToRGB: TColor;
    function ToAlphaColor(Alpha: Byte): TAlphaColor;

    // Write utils
    procedure WriteTo(R, G, B: PByte); overload;
    procedure WriteTo(var R, G, B: Byte); overload;

    // Constructors
    class function Create(R, G, B: Byte): TColor; overload; static;
    class function Create(AString: string): TColor; overload; static;
    class function CreateHSB(Hue, Sat, Bri: Double): TColor; static; // to get absolute color, use 1, 1 for Sat and Bri
    class function RandomColor: TColor; overload; static;
    class function RandomColor(RangeMin, RangeMax: Byte): TColor; overload; static;
  end;

  // TAlphaColor Helper
  TAlphaColorHelper = record helper for TAlphaColor
  public
    // Change value
    function GetAlpha: byte;
    function GetR: byte;
    function GetG: byte;
    function GetB: byte;

    procedure SetAlpha(Value: byte);
    procedure SetR(Value: byte);
    procedure SetG(Value: byte);
    procedure SetB(Value: byte);

    // Props
    property Alpha: byte read GetAlpha write SetAlpha;
    property R: byte read GetR write SetR;
    property G: byte read GetG write SetG;
    property B: byte read GetB write SetB;

    // Utilities
    function ColorGrayscale(ToneDown: integer = 3): TAlphaColor;
    function ColorInvert: TAlphaColor;
    function ChangeSaturation(ByIncrement: integer): TAlphaColor;
    function Blend(WithColor: TAlphaColor; BlendAmount: byte): TAlphaColor;
    function GetLightValue: byte;

    // GDI
    {$IFDEF MSWINDOWS}
    function MakeGDIBrush: TGPSolidBrush;
    function MakeGDIPen(Width: Single = 1): TGPPen;
    {$ENDIF}

    // Convert
    function ToVclColor: TColor;
    function ToString: string;

    // Write utils
    procedure WriteTo(R, G, B, A: PByte); overload;
    procedure WriteTo(var R, G, B, A: Byte); overload;

    // Constructors
    class function Create(R, G, B: Byte; A: Byte = 255): TAlphaColor; overload; static;
    class function Create(AColor: TColor; A: Byte = 255): TAlphaColor; overload; static;
    class function Create(AString: string): TAlphaColor; overload; static;
    class function RandomColor(RandomAlpha: boolean=false): TAlphaColor; overload; static;
    class function RandomColor(RangeMin, RangeMax: Byte; RandomAlpha: boolean=false): TAlphaColor; overload; static;
  end;

  // TRect Helper
  TRectHelper = record helper for TRect
  public
    function GetBottomLeft: TPoint; inline;
    function GetTopRight: TPoint; inline;
    function Normalised: boolean; inline;
  end;

  // TPoint Helper
  TPointHelper = record helper for TPoint
  public
    function ToString: string;
    constructor FromString(S: string);
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

implementation

class function TColorHelper.Create(R, G, B: Byte): TColor;
begin
  Result := R or (G shl 8) or (B shl 16)
end;

function TColorHelper.Blend(WithColor: TColor; BlendAmount: byte): TColor;
begin
  Result := Create(
    R + (WithColor.R - R) * BlendAmount div 255,
    G + (WithColor.G - G) * BlendAmount div 255,
    B + (WithColor.B - B) * BlendAmount div 255);
end;

function TColorHelper.ChangeSaturation(ByIncrement: integer): TColor;
begin
  Result := Create(EnsureRange(R+ByIncrement, 0, 255),
    EnsureRange(G+ByIncrement, 0, 255),
    EnsureRange(B+ByIncrement, 0, 255));
end;

function TColorHelper.ColorGrayscale(ToneDown: integer): TColor;
begin
  const Val = (R + G + B) div ToneDown;
  Result := Create(Val, Val, Val);
end;

function TColorHelper.ColorInvert: TColor;
begin
  Result := Create(255-R, 255-G, 255-B);
end;

class function TColorHelper.Create(AString: string): TColor;
begin
  Result := StringToColor(AString);
end;

class function TColorHelper.CreateHSB(Hue, Sat, Bri: Double): TColor;
var
  f, h: Double;
  u, p, q, t: Byte;
begin
  u := Trunc(bri * 255 + 0.5);
  if sat = 0 then
    Exit(Create(u, u, u));

  h := (hue - Floor(hue)) * 6;
  f := h - Floor(h);
  p := Trunc(bri * (1 - sat) * 255 + 0.5);
  q := Trunc(bri * (1 - sat * f) * 255 + 0.5);
  t := Trunc(bri * (1 - sat * (1 - f)) * 255 + 0.5);

  case Trunc(h) of
    0: result := Create(u, t, p);
    1: result := Create(q, u, p);
    2: result := Create(p, u, t);
    3: result := Create(p, q, u);
    4: result := Create(t, p, u);
    5: result := Create(u, p, q);

    else result := $FFFFFF;
  end;
end;

function TColorHelper.GetLightValue: byte;
begin
  Result := (R + B + G) div 3;
end;

function TColorHelper.GetB: byte;
begin
  Result := Byte(Self shr 16);
end;

function TColorHelper.GetG: byte;
begin
  Result := Byte(Self shr 8);
end;

function TColorHelper.GetR: byte;
begin
  Result := Byte(Self);
end;

{$IFDEF MSWINDOWS}
function TColorHelper.MakeGDIBrush(Alpha: byte): TGPSolidBrush;
begin
  Result := TGPSolidBrush.Create( ToAlphaColor(Alpha) );
end;
{$ENDIF}

function TColorHelper.MakeGDIPen(Alpha: byte; Width: Single): TGPPen;
begin
  Result := TGPPen.Create( ToAlphaColor(Alpha), Width );
end;

class function TColorHelper.RandomColor(RangeMin, RangeMax: Byte): TColor;
begin
  Result := Create(RandomRange(RangeMin, RangeMax+1), RandomRange(RangeMin, RangeMax+1), RandomRange(RangeMin, RangeMax+1));
end;

class function TColorHelper.RandomColor: TColor;
begin
  Result := Create(Random(256), Random(256), Random(256));
end;

procedure TColorHelper.SetB(Value: byte);
begin                              // Typecast value to larger bit size, $00*3
  Self := (Self and $00FFFF) or (TColor(Value) shl 16);
end;

procedure TColorHelper.SetG(Value: byte);
begin                              // Typecast value to larger bit size, $00*3
  Self := (Self and $FF00FF) or (TColor(Value) shl 8);
end;

procedure TColorHelper.SetR(Value: byte);
begin                              // Typecasting is not required
  Self := (Self and $FFFF00) or (Value);
end;

function TColorHelper.ToAlphaColor(Alpha: Byte): TAlphaColor;
begin
  Result := TAlphaColor.Create(Self.R, Self.G, Self.B, Alpha);
end;

function TColorHelper.ToHex: string;
begin
  Result := '#' +
    IntToHex( Self.R, 2 ) +
    IntToHex( Self.G, 2 ) +
    IntToHex( Self.B, 2 );
end;

function TColorHelper.ToRGB: TColor;
begin
  {$IFDEF MSWINDOWS}
  if Self < 0 then
    Result := GetSysColor(Self and $000000FF)
  else
  {$ENDIF} Result := Self;
end;

// Color
function TColorHelper.ToString: string;
begin
  Result := ColorToString( Self );
end;

procedure TColorHelper.WriteTo(var R, G, B: Byte);
begin
  R := GetR;
  G := GetG;
  B := GetB;
end;

procedure TColorHelper.WriteTo(R, G, B: PByte);
begin
  if R <> nil then
    R^ := GetR;
  if G <> nil then
    G^ := GetG;
  if B <> nil then
    B^ := GetB;
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

{ TRectHelper }

function TRectHelper.GetBottomLeft: TPoint;
begin
  Result := Point(Left, Bottom);
end;

function TRectHelper.GetTopRight: TPoint;
begin
  Result := Point(Right, Top);
end;

function TRectHelper.Normalised: boolean;
begin
  Result := (Top <= Bottom) and (Left <= Right);
end;

{ TPointHelper }

constructor TPointHelper.FromString(S: string);
begin
  const I = S.Split([','], 2);
  X := I[0].ToInteger;
  Y := I[1].ToInteger;
end;

function TPointHelper.ToString: string;
begin
  Result := Format('%D,%D', [X, Y]);
end;

{ TAlphaColorHelper }

class function TAlphaColorHelper.Create(AColor: TColor; A: Byte): TAlphaColor;
begin
  {$R-}
  Result := ((AColor.B) or ((AColor.G) shl 8) or ((AColor.R) shl 16) or (A shl 24));
  {$R+}
end;

class function TAlphaColorHelper.Create(R, G, B, A: Byte): TAlphaColor;
begin
  Result := (B or (G shl 8) or (R shl 16) or (A shl 24));
end;

function TAlphaColorHelper.Blend(WithColor: TAlphaColor; BlendAmount: byte): TAlphaColor;
begin
  Result := Create(
    R + (WithColor.R - R) * BlendAmount div 255,
    G + (WithColor.G - G) * BlendAmount div 255,
    B + (WithColor.B - B) * BlendAmount div 255,
  Alpha);
end;

function TAlphaColorHelper.ChangeSaturation(ByIncrement: integer): TAlphaColor;
begin
  Result := Create(EnsureRange(R+ByIncrement, 0, 255),
    EnsureRange(G+ByIncrement, 0, 255),
    EnsureRange(B+ByIncrement, 0, 255), Alpha);
end;

function TAlphaColorHelper.ColorGrayscale(ToneDown: integer = 3): TAlphaColor;
begin
  const Val = (R + G + B) div ToneDown;

  Result := Create(Val, Val, Val);
end;

function TAlphaColorHelper.ColorInvert: TAlphaColor;
begin
  Result := Create(255-R, 255-G, 255-B, Alpha);
end;

class function TAlphaColorHelper.Create(AString: string): TAlphaColor;
begin
  if AString[1] = '#' then
    Result := StrToInt('$' + Copy(AString, 2, 8))
  else
    Exit( AString.ToInteger );
end;

function TAlphaColorHelper.GetAlpha: byte;
begin
  Result := (Self and $FF000000) shr 24;
end;

function TAlphaColorHelper.GetR: byte;
begin
  Result := (Self and $00FF0000) shr 16;
end;

{$IFDEF MSWINDOWS}
function TAlphaColorHelper.MakeGDIBrush: TGPSolidBrush;
begin
  Result := TGPSolidBrush.Create( Self );
end;

function TAlphaColorHelper.MakeGDIPen(Width: Single): TGPPen;
begin
  Result := TGPPen.Create( Self, Width );
end;
class function TAlphaColorHelper.RandomColor(RangeMin, RangeMax: Byte;
  RandomAlpha: boolean): TAlphaColor;
begin
  if RandomAlpha then
    Result := Create(RandomRange(RangeMin, RangeMax+1), RandomRange(RangeMin, RangeMax+1), RandomRange(RangeMin, RangeMax+1), RandomRange(RangeMin, RangeMax+1))
  else
    Result := Create(RandomRange(RangeMin, RangeMax+1), RandomRange(RangeMin, RangeMax+1), RandomRange(RangeMin, RangeMax+1), RandomRange(RangeMin, RangeMax+1));
end;

{$ENDIF}

class function TAlphaColorHelper.RandomColor(RandomAlpha: boolean): TAlphaColor;
begin
  if RandomAlpha then
    Result := Create(Random(256), Random(256), Random(256), Random(256))
  else
    Result := Create(Random(256), Random(256), Random(256), 255);
end;

function TAlphaColorHelper.GetG: byte;
begin
  Result := (Self and $0000FF00) shr 8;
end;

function TAlphaColorHelper.GetLightValue: byte;
begin
  Result := (R + B + G) div 3;
end;

function TAlphaColorHelper.GetB: byte;
begin
  Result := (Self and $000000FF);
end;

procedure TAlphaColorHelper.SetAlpha(Value: byte);
begin                              // Typecast value to larger bit size, $00*4
  Self := (Self and $00FFFFFF) or (TAlphaColor(Value) shl 24);
end;

procedure TAlphaColorHelper.SetR(Value: byte);
begin                              // Typecast value to larger bit size, $00*4
  Self := (Self and $FF00FFFF) or (TAlphaColor(Value) shl 16);
end;

function TAlphaColorHelper.ToString: string;
begin
  Result := '#' + IntToHex(Self, 8);
end;

function TAlphaColorHelper.ToVclColor: TColor;
begin
  // Better to use GetRGB, as FXColor is AARRGGBB, while TColor is 00BBGGRR
  Result := TColor.Create(GetR, GetG, GetB);
end;

procedure TAlphaColorHelper.WriteTo(var R, G, B, A: Byte);
begin
  R := GetR;
  G := GetG;
  B := GetB;
  A := GetAlpha;
end;

procedure TAlphaColorHelper.WriteTo(R, G, B, A: PByte);
begin
  if R <> nil then
    R^ := GetR;
  if G <> nil then
    G^ := GetG;
  if B <> nil then
    B^ := GetB;
  if A <> nil then
    A^ := GetAlpha;
end;

procedure TAlphaColorHelper.SetG(Value: byte);
begin                              // Typecast value to larger bit size, $00*4
  Self := (Self and $FFFF00FF) or (TAlphaColor(Value) shl 8);
end;

procedure TAlphaColorHelper.SetB(Value: byte);
begin                              // Typecasting is not required
  Self := (Self and $FFFFFF00) or (Value);
end;

end.