{***********************************************************}
{                      Codrut Classes                       }
{                                                           }
{                        version 0.4                        }
{                           ALPHA                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                   -- WORK IN PROGRESS --                  }
{***********************************************************}

unit Cod.Types;

interface
  uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Variants, Vcl.Clipbrd, IOUtils, Math, Types;

  type
    // Cardinals
    TCorners = (crTopLeft, crTopRight, crBottomLeft, crBottomRight);

    TCompareResult = (crEqual, crBigger, crSmaller);

    TFileType = (dftText, dftBMP, dftPNG, dftJPEG, dftGIF, dftHEIC, dftTIFF,
    dftMP3, dftMP4, dftFlac, dftMDI, dftOGG, dftSND, dftM3U8, dftEXE, dftMSI,
    dftZip, dftGZip, dft7Zip, dftCabinet, dftTAR, dftRAR, dftLZIP, dftISO,
    dftPDF, dftHLP, dftCHM);

    // Graphic ans Canvas
    TRoundRect = record
      public
        Rect: TRect;

        RoundTL,
        RoundTR,
        RoundBL,
        RoundBR: integer;

        Corners: TCorners;

        function Left: integer;
        function Right: integer;
        function Top: integer;
        function Bottom: integer;
        function TopLeft: TPoint;
        function BottomRight: TPoint;
        function Height: integer;
        function Width: integer;

        procedure Offset(const DX, DY: Integer);

        procedure SetRoundness(Value: integer);
        function GetRoundness: integer;

        function RoundX: integer;
        function RoundY: integer;

        procedure Create(TopLeft, BottomRight: TPoint; Rnd: integer); overload;
        procedure Create(SRect: TRect; Rnd: integer); overload;
        procedure Create(Left, Top, Right, Bottom: integer; Rnd: integer); overload;
    end;

    TLine = record
      Point1: TPoint;
      Point2: TPoint;

      procedure Create(P1, P2: TPoint);

      procedure OffSet(const DX, DY: Integer);

      function Rect: TRect;
      function GetHeight: integer;
      function GetWidth: integer;

      function Center: TPoint;
    end;

    // Math & Array
    TIntegerList = class;

    TIntegerListSortCompare = function(List: TIntegerList; Index1, Index2: Integer): Integer;

    TIntegerList = class(TObject)
    private
      FList : TList;
      FDuplicates : TDuplicates;
      FSorted: Boolean;

      function GetItems(Index: Integer): Integer;
      procedure SetItems(Index: Integer; const Value: Integer);
      function GetCapacity: Integer;
      function GetCount: Integer;
      procedure SetCapacity(const Value: Integer);
      procedure SetCount(const Value: Integer);
      procedure SetSorted(const Value: Boolean);
      function GetHigh: Integer;

    protected
      procedure Sort; virtual;
      procedure QuickSort(L, R: Integer; SCompare: TIntegerListSortCompare);

    public
      constructor Create;
      destructor Destroy; override;

      function Add(Item: Integer) : Integer;
      procedure Insert(Index, Item: Integer);

      function First() : Integer;
      function Last() : Integer;

      function StringContents: string;
      procedure LoadFromString(AString: string; Separator: string = ',');

      procedure Clear;
      procedure Delete(Index: Integer);

      function IndexOf(const Value: integer): integer;
      function Find(aValue : Integer; var Index: Integer): Boolean; virtual;

      procedure Exchange(Index1, Index2: Integer);
      procedure Move(CurIndex, NewIndex: Integer);
      procedure Pack;

      property Capacity: Integer read GetCapacity write SetCapacity;
      property Count: Integer read GetCount write SetCount;
      property High: Integer read GetHigh;

      property Duplicates: TDuplicates read FDuplicates write FDuplicates;

      property Items[Index: Integer]: Integer read GetItems write SetItems; default;

      property Sorted : Boolean read FSorted write SetSorted;
    end;

  // Types
  function RoundRect(SRect: TRect; Rnd: integer): TRoundRect; overload;
  function RoundRect(SRect: TRect; RndX, RndY: integer): TRoundRect; overload;
  function RoundRect(X1, Y1, X2, Y2: integer; Rnd: integer): TRoundRect; overload;

  function Line(Point1, Point2: TPoint): TLine; overload;
  function Line(X1, Y1, X2, Y2: integer): TLine; overload;

  function CompareItems(Item, ToItem: string): TCompareResult; overload;
  function CompareItems(Item, ToItem: integer): TCompareResult; overload;

  // Utilities
  function DistancePoints(XPos, YPos, X, Y: Real): Real;
  function PointOnLine(X, Y, x1, y1, x2, y2, d: Integer): Boolean;

  { Rectangles }
  function GetValidRect(Point1, Point2: TPoint): TRect; overload;
  function GetValidRect(Points: TArray<TPoint>): TRect; overload;
  function GetValidRect(Rect: TRect): TRect; overload;
  procedure CenterRectInRect(var ARect: TRect; const ParentRect: TRect);
  function PointInRect(Point: TPoint; Rect: TRect): boolean;

  { Points }
  function SetPositionAroundPoint(Point: TPoint; Center: TPoint; degree: real; customradius: real = -1): TPoint;
  function PointAroundCenter(Center: TPoint; degree: real; customradius: real = -1): TPoint;
  function RotatePointAroundPoint(APoint: TPoint; ACenter: TPoint; ARotateDegree: real; ACustomRadius: real = -1): TPoint;
  function PointAngle(APoint: TPoint; ACenter: TPoint; offset: integer = 0): integer;


  // Conversion Functions
  function StringToBoolean(str: string): Boolean;
  function BooleanToString(value: boolean): String;
  function BooleanToYesNo(value: boolean): String;
  function IconToBitmap(icon: TIcon): TBitMap;
  function IntToStrIncludePrefixZeros(Value: integer; NumbersCount: integer): string;

  function DecToHex(Dec: int64): string;
  function HexToDec(Hex: string): int64;


  { Arrays }
  function InArray(Value: integer; arrayitem: array of integer): integer; overload;
  function InArray(Value: string; arrayitem: array of string): integer; overload;
  procedure ShuffleArray(var arr: TArray<Integer>);

implementation


function RoundRect(SRect: TRect; Rnd: integer): TRoundRect;
var
  rec: TRoundRect;
begin
  rec.Create(SRect, Rnd);
  Result := rec;
end;

function RoundRect(SRect: TRect; RndX, RndY: integer): TRoundRect; overload;
var
  rec: TRoundRect;
begin
  rec.Create(SRect, (RndX + RndY) div 2);
  Result := rec;
end;

function RoundRect(X1, Y1, X2, Y2: integer; Rnd: integer): TRoundRect;
var
  rec: TRoundRect;
begin
  rec.Create(Rect(X1, Y1, X2, Y2), Rnd);
  Result := rec;
end;

function Line(Point1, Point2: TPoint): TLine;
begin
  Result.Point1 := Point1;
  Result.Point2 := Point2;
end;

function Line(X1, Y1, X2, Y2: integer): TLine;
begin
  Result.Point1 := Point(X1, Y1);
  Result.Point2 := Point(X2, Y2);
end;

function CompareItems(Item, ToItem: string): TCompareResult;
begin
  Result := crSmaller;

  if Item > ToItem then
    Result := crBigger
      else
        if Item = ToItem then
          Result := crEqual;
end;

function CompareItems(Item, ToItem: integer): TCompareResult; overload;
begin
  Result := crSmaller;

  if Item > ToItem then
    Result := crBigger
      else
        if Item = ToItem then
          Result := crEqual;
end;

function DistancePoints(XPos, YPos, X, Y: Real): Real;
begin
  Result:=sqrt(
    Power(XPos-X,2)+Power(YPos-Y,2));
end;

function PointOnLine(X, Y, x1, y1, x2, y2, d: Integer): Boolean;
var
  l, p: real;
begin
  p := sqrt( power((y2-y1), 2) + power((x2-x1), 2));
  if p = 0 then
    p := 1;
  l := ((X - x1)*(y2-y1)+(y1-y)*(x2-x1) ) / p;

  if abs(l) <= d then
    Result := true
  else
    Result := false;
end;

function GetValidRect(Point1, Point2: TPoint): TRect;
begin
  if Point1.X < Point2.X then
    Result.Left := Point1.X
  else
    Result.Left := Point2.X;

  if Point1.Y < Point2.Y then
    Result.Top := Point1.Y
  else
    Result.Top := Point2.Y;

  Result.Width := abs( Point2.X - Point1.X);
  Result.Height := abs( Point2.Y - Point1.Y);
end;

function GetValidRect(Points: TArray<TPoint>): TRect; overload
var
  I: Integer;
begin
  if Length( Points ) = 0 then
    Exit;

  Result.TopLeft := Points[0];
  Result.BottomRight := Points[0];

  for I := 1 to High(Points) do
    begin
      if Points[I].X < Result.Left then
        Result.Left := Points[I].X;
      if Points[I].Y < Result.Top then
        Result.Top := Points[I].Y;

      if Points[I].X > Result.Right then
        Result.Right := Points[I].X;
      if Points[I].Y > Result.Bottom then
        Result.Bottom := Points[I].Y;
    end;
end;

function GetValidRect(Rect: TRect): TRect;
begin
  if Rect.TopLeft.X < Rect.BottomRight.X then
    Result.Left := Rect.TopLeft.X
  else
    Result.Left := Rect.BottomRight.X;

  if Rect.TopLeft.Y < Rect.BottomRight.Y then
    Result.Top := Rect.TopLeft.Y
  else
    Result.Top := Rect.BottomRight.Y;

  Result.Width := abs( Rect.BottomRight.X - Rect.TopLeft.X);
  Result.Height := abs( Rect.BottomRight.Y - Rect.TopLeft.Y);
end;

procedure CenterRectInRect(var ARect: TRect; const ParentRect: TRect);
begin
  ARect.Offset((ParentRect.Width div 2 - ARect.Width div 2) - ARect.Left,
               (ParentRect.Height div 2 - ARect.Height div 2) - ARect.Top);
end;

function PointInRect(Point: TPoint; Rect: TRect): boolean;
begin
  Result := Rect.Contains(Point);
end;

function SetPositionAroundPoint(Point: TPoint; Center: TPoint; degree: real; customradius: real = -1): TPoint;
var
  r, dg, dsin, dcos: real;
begin
  dg := (degree * pi / 180);

  dsin := sin(dg);
  dcos := cos(dg);

  if customradius = -1 then
    r := DistancePoints(Center.X, Center.Y, Point.X, Point.Y)
  else
    r := customradius;

  // Apply New Properties
  Result.X := round( Center.X + r * dsin );
  Result.Y := round( Center.Y + r * dcos );
end;

function PointAroundCenter(Center: TPoint; degree: real; customradius: real = -1): TPoint;
var
  r, dg, dsin, dcos: real;
begin
  dg := (degree * pi / 180);

  dsin := sin(dg);
  dcos := cos(dg);

  r := customradius;

  // Apply New Properties
  Result.X := round( Center.X + r * dsin );
  Result.Y := round( Center.Y + r * dcos );
end;

function RotatePointAroundPoint(APoint: TPoint; ACenter: TPoint; ARotateDegree: real; ACustomRadius: real): TPoint;
var
  r, dg, cosa, sina, ncos, nsin, dsin, dcos: real;
begin
  dg := (ARotateDegree * pi / 180);

  dsin := sin(dg);
  dcos := cos(dg);

  if ACustomRadius = -1 then
    r := DistancePoints(ACenter.X, ACenter.Y, APoint.X, APoint.Y)
  else
    r := ACustomRadius;

  cosa := (APoint.X - ACenter.X) / r;
  sina := (APoint.Y - ACenter.Y) / r;

  nsin := sina * dcos + dsin * cosa;
  ncos := cosa * dcos - sina * dsin;


  // Apply New Properties
  Result.X := round( ACenter.X + r * ncos );
  Result.Y := round( ACenter.Y + r * nsin );
end;

function PointAngle(APoint: TPoint; ACenter: TPoint; offset: integer): integer;
var
  alpha, r: real;
begin
  r := sqrt( Power(APoint.X - ACenter.X,2)+Power(APoint.Y - ACenter.Y,2) );

  if APoint.Y >= ACenter.Y then
    alpha := ArcCos( (APoint.X - ACenter.X) / r)
  else
    alpha := 2 * pi - ArcCos( (APoint.X - ACenter.X) / r);

  Result := offset + round(180 * alpha / pi);

  if offset <> 0 then
  begin
    if Result < 0 then
      Result := Result + 360;
    if Result > 360 then
      Result := Result - 360;
  end;
end;

function StringToBoolean(str: string): boolean;
begin
  if (str = 'true') or (str = '1') or (str = '-1') then
    Result := true
  else
    Result := false;
end;

function BooleanToString(value: boolean): string;
begin
  if value then
    Result := 'true'
  else
    Result := 'false'
end;

function BooleanToYesNo(value: boolean): String;
begin
  if value then
    Result := 'yes'
  else
    Result := 'no'
end;

function IconToBitmap(icon: TIcon): TBitMap;
begin
  Result := TBitmap.Create;
  Result.Height := Icon.Height;
  Result.Width  := Icon.Width;
  Result.Canvas.Draw(0, 0, Icon);

  Result.Transparent := true;
  Result.TransparentMode := tmAuto;
end;

function IntToStrIncludePrefixZeros(Value: integer; NumbersCount: integer): string;
var
  ResLength: integer;
  I: Integer;
begin
  Result := IntToStr( abs(Value) );

  ResLength := Length( Result );
  if ResLength < NumbersCount then
    begin
      for I := 1 to NumbersCount - ResLength do
        Result := '0' + Result;

      if Value < 0 then
        Result := '-' + Result;
    end;
end;

function DecToHex(Dec: int64): string;
var
  I: Integer;
begin
  //result:= digits[Dec shr 4]+digits[Dec and $0F];
  Result := IntToHex(Dec);

  for I := 1 to length(Result) do
      if (Result[1] = '0') and (Length(Result) > 2) then
        Result := Result.Remove(0, 1)
      else
        Break;

  if Result = '' then
        Result := '00';
end;

function HexToDec(Hex: string): int64;
begin
  Result := StrToInt64('$' + Hex);
end;

function InArray(Value: integer; arrayitem: array of integer): integer; overload;
var
  I: integer;
begin
  Result := -1;
  for I := 0 to length(arrayitem) - 1 do
    if arrayitem[I] = Value then
    begin
      Result := I;
      Break;
    end;
end;

function InArray(Value: string; arrayitem: array of string): integer; overload;
var
  I: integer;
begin
  Result := -1;
  for I := 0 to length(arrayitem) - 1 do
    if arrayitem[I] = Value then
    begin
      Result := I;
      Break;
    end;
end;

procedure ShuffleArray(var arr: TArray<Integer>);
var
  i, j, temp: Integer;
begin
  // shuffle the array using Fisher-Yates algorithm
  for i := Length(arr) - 1 downto 1 do
  begin
    j := Random(i + 1); // generate a random index between 0 and i
    temp := arr[j];
    arr[j] := arr[i];
    arr[i] := temp;
  end;
end;

{ TRoundRect }

procedure TRoundRect.Create(TopLeft, BottomRight: TPoint; Rnd: integer);
begin
  Rect := TRect.Create(TopLeft, BottomRight);

  SetRoundness( Rnd );
end;

procedure TRoundRect.Create(SRect: TRect; Rnd: integer);
begin
  Rect := SRect;

  SetRoundness( Rnd );
end;

function TRoundRect.Bottom: integer;
begin
  Result := Rect.Bottom;
end;

function TRoundRect.BottomRight: TPoint;
begin
  Result := Rect.BottomRight;
end;

procedure TRoundRect.Create(Left, Top, Right, Bottom, Rnd: integer);
begin
  Rect := TRect.Create(Left, Top, Right, Bottom);

  SetRoundness( Rnd );
end;

function TRoundRect.GetRoundness: integer;
begin
  Result := round( (Self.RoundTL + Self.RoundTR + Self.RoundBL + Self.RoundBR) / 4 );
end;

function TRoundRect.Height: integer;
begin
  Result := Rect.Height;
end;

function TRoundRect.Left: integer;
begin
  Result := Rect.Left;
end;

procedure TRoundRect.Offset(const DX, DY: Integer);
begin
  Rect.Offset(DX, DY);
end;

function TRoundRect.Right: integer;
begin
  Result := Rect.Right;
end;

function TRoundRect.RoundX: integer;
begin
  Result := round( (Self.RoundTL + Self.RoundTR + Self.RoundBL + Self.RoundBR) / 4 );
end;

function TRoundRect.RoundY: integer;
begin
    Result := round( (Self.RoundTL + Self.RoundTR + Self.RoundBL + Self.RoundBR) / 4 );
end;

procedure TRoundRect.SetRoundness(Value: integer);
begin
  RoundTL := Value;
  RoundTR := Value;
  RoundBL := Value;
  RoundBR := Value;
end;

function TRoundRect.Top: integer;
begin
  Result := Rect.Top;
end;

function TRoundRect.TopLeft: TPoint;
begin
  Result := Rect.TopLeft;
end;

function TRoundRect.Width: integer;
begin
  Result := Rect.Width;
end;

{ TLine }

procedure TLine.Create(P1, P2: TPoint);
begin
  Point1 := P1;
  Point2 := P2;
end;

function TLine.GetHeight: integer;
begin
  Result := abs(Point1.Y - Point2.Y);
end;

function TLine.GetWidth: integer;
begin
  Result := abs(Point1.X - Point2.X);
end;

procedure TLine.OffSet(const DX, DY: Integer);
begin
  Inc( Point1.X, DX );
  Inc( Point1.Y, DY );
  Inc( Point2.X, DX );
  Inc( Point2.Y, DY );
end;

function TLine.Rect: TRect;
begin
  Result := GetValidRect(Point1, Point2);
end;

function TLine.Center: TPoint;
begin
  Result := Point( (Point1.X + Point2.X) div 2, (Point1.Y + Point2.Y) div 2);
end;

{ TIntegerList }

function IntegerListCompare(List: TIntegerList; Index1, Index2:
Integer): Integer;
begin
  if (List[Index1] < List[Index2]) then
    Result := -1
  else if (List[Index1] > List[Index2]) then
    Result := 1
  else
    Result := 0;
end;

function TIntegerList.Add(Item: Integer) : Integer;
begin
  if not Sorted then
    Result := FList.Count
  else
    if Find(Item, Result) then
      case Duplicates of
        dupIgnore : Exit;
//        dupError  : Error(@SDuplicateString, 0);
        dupError  : Exit;
      end;

  Insert(Result, Item);
end;

procedure TIntegerList.Clear;
begin
  FList.Clear;
end;

constructor TIntegerList.Create;
begin
  inherited;
  FList := TList.Create;
end;

procedure TIntegerList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TIntegerList.Destroy;
begin
  FList.Free;

  inherited;
end;

procedure TIntegerList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TIntegerList.Find(aValue: Integer; var Index: Integer):
Boolean;
var
  L, H, I, C: Integer;

  function IntegerCompare(aValue1, aValue2: Integer) : Integer;
  begin
    if (aValue1 < aValue2) then
      Result := -1
    else if (aValue1 > aValue2) then
      Result := 1
    else
      Result := 0;
  end;

begin
  Result := False;
  L := 0;
  H := FList.Count - 1;

  while (L <= H) do begin
    I := (L + H) shr 1;
    C := IntegerCompare(Items[I], aValue);

    if (C < 0) then
      L := I + 1
    else begin
      H := I - 1;

      if (C = 0) then begin
        Result := True;
        if (Duplicates <> dupAccept) then
          L := I;
      end;
    end;
  end;

  Index := L;
end;

function TIntegerList.First(): Integer;
begin
  Result := Integer(FList.First());
end;

function TIntegerList.GetCapacity() : Integer;
begin
  Result := FList.Capacity;
end;

function TIntegerList.GetCount() : Integer;
begin
  Result := FList.Count;
end;

function TIntegerList.GetHigh: Integer;
begin
  Result := Count - 1;
end;

function TIntegerList.GetItems(Index: Integer): Integer;
begin
  Result := Integer(FList.Items[Index]);
end;

function TIntegerList.IndexOf(const Value: integer): integer;
begin
  if not Find( Value, Result ) then
    Result := -1;
end;

procedure TIntegerList.Insert(Index, Item: Integer);
begin
  FList.Insert(Index, Pointer(Item));
end;

function TIntegerList.Last() : Integer;
begin
  Result := Integer(FList.Last());
end;

procedure TIntegerList.LoadFromString(AString: string; Separator: string);
var
  P, E: integer;
begin
  if (AString = '') or (Separator = '') then
    Exit;

  AString := AString + Separator;

  Self.SetCount(0);
  P := 0;
  repeat
    E := Pos( Separator, AString, P + 1);

    if E > 0 then
      Self.Add( strtoint( Copy(AString, P+1, E - P-1) ) );

    P := E;
  until P = 0;
end;

procedure TIntegerList.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TIntegerList.Pack;
begin
  FList.Pack;
end;

procedure TIntegerList.QuickSort(L, R: Integer; SCompare:
TIntegerListSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;

    repeat
      while (SCompare(Self, I, P) < 0) do
        Inc(I);

      while (SCompare(Self, J, P) > 0) do
        Dec(J);

      if (I <= J) then begin
        Exchange(I, J);

        if (P = I) then
          P := J
        else if (P = J) then
          P := I;

        Inc(I);
        Dec(J);
      end;
    until (I > J);

    if (L < J) then
      QuickSort(L, J, SCompare);
    L := I;
  until (I >= R);
end;

procedure TIntegerList.SetCapacity(const Value: Integer);
begin
  FList.Capacity := Value;
end;

procedure TIntegerList.SetCount(const Value: Integer);
begin
  FList.Count := Value;
end;

procedure TIntegerList.SetItems(Index: Integer; const Value: Integer);
begin
  FList.Items[Index] := Pointer(Value);
end;

procedure TIntegerList.SetSorted(const Value: Boolean);
begin
  if (FSorted <> Value) then begin
    if Value then
      Sort;
    FSorted := Value;
  end;
end;

procedure TIntegerList.Sort;
begin
  if not Sorted and (FList.Count > 1) then begin
//    Changing;
    QuickSort(0, FList.Count - 1, IntegerListCompare);
//    Changed;
  end;
end;

function TIntegerList.StringContents: string;
var
  I: Integer;
begin
  for I := 0 to Self.Count - 1 do
    Result := Result + inttostr( Self[I] ) + ',';
  Result := Copy( Result, 0, Length(Result) - 1 );
end;

{ THexByte }

end.
