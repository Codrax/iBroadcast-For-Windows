unit Cod.Version;

interface
  uses
  System.SysUtils, System.Classes, IdSNTP,
  System.Types, DateUtils, IdHTTP, Math, Cod.Math,
  JSON, IdSSLOpenSSL;

type
  TVersion = record
    var
    Major,
    Minor,
    Maintenance,
    Build: cardinal;

    // CONST
    class function Empty: TVersion; static;

    // Main
    constructor Create(AMajor, AMinor, AMaintenance: cardinal; ABuild: cardinal=0); overload;
    constructor Create(AString: string); overload;
    procedure Clear;

    // Load
    procedure Parse(From: string);

    // Comparation
    function IsEmpty: boolean;
    function CompareTo(Version: TVersion): TValueRelationship;
    function NewerThan(Version: TVersion): boolean;
    function OlderThan(Version: TVersion): boolean;

    // Conversion
    function ToString: string; overload;
    function ToString(Separator: char): string; overload;

    // Operators
    class operator Equal(A, B: TVersion): Boolean;
    class operator NotEqual(A, B: TVersion): Boolean;
  end;

  function MakeVersion(Major, Minor, Maintenance: cardinal; Build: cardinal = 0): TVersion;

const
  VERSION_EMPTY: TVersion = (Major:0; Minor:0; Maintenance:0; Build:0);

implementation

function MakeVersion(Major, Minor, Maintenance: cardinal; Build: cardinal = 0): TVersion;
begin
  Result.Major := Major;
  Result.Minor := Minor;
  Result.Maintenance := Maintenance;
  Result.Build := Build;
end;


{ TVersion }

function TVersion.NewerThan(Version: TVersion): boolean;
begin
  Result := CompareTo(Version) = GreaterThanValue;
end;

class operator TVersion.NotEqual(A, B: TVersion): Boolean;
begin
  Result := A.CompareTo(B) <> EqualsValue;
end;

function TVersion.OlderThan(Version: TVersion): boolean;
begin
  Result := CompareTo(Version) = LessThanValue;
end;

procedure TVersion.Clear;
begin
  Major := 0;
  Minor := 0;
  Maintenance := 0;
  Build := 0;
end;

function TVersion.CompareTo(Version: TVersion): TValueRelationship;
begin
  Result := GetNumberRelation(Major, Version.Major);
  if Result <> EqualsValue then
    Exit;

  Result := GetNumberRelation(Minor, Version.Minor);
  if Result <> EqualsValue then
    Exit;

  Result := GetNumberRelation(Maintenance, Version.Maintenance);
  if Result <> EqualsValue then
    Exit;

  Result := GetNumberRelation(Build, Version.Build);
end;

constructor TVersion.Create(AString: string);
begin
  Parse( AString );
end;

constructor TVersion.Create(AMajor, AMinor, AMaintenance, ABuild: cardinal);
begin
  Major := AMajor;
  Minor := AMinor;
  Maintenance := AMaintenance;
  Build := ABuild;
end;

function TVersion.IsEmpty: boolean;
begin
  Result := CompareTo(VERSION_EMPTY) = EqualsValue;
end;

class operator TVersion.Equal(A, B: TVersion): Boolean;
begin
  Result := A.CompareTo(B) = EqualsValue;
end;

class function TVersion.Empty: TVersion;
begin
  Result := VERSION_EMPTY;
end;

procedure TVersion.Parse(From: string);
var
  Separator: char;
  Splitted: TArray<string>;
  I: Integer;
  Value: cardinal;
  AVersions: integer;
begin
  // Separator
  if From.IndexOf('.') <> -1 then
    Separator := '.'
  else
  if From.IndexOf(',') <> -1 then
    Separator := ','
  else
  if From.IndexOf('-') <> -1 then
    Separator := '-'
  else
    Separator := #0;

  // Values
  Splitted := From.Split(Separator);

  AVersions := Length(Splitted);
  if AVersions < 0 then
    Exit;

  // Write
  Clear;

  for I := 0 to AVersions-1 do
    begin
      Value := Splitted[I].ToInteger;
      case I of
        0: Major := Value;
        1: Minor := Value;
        2: Maintenance := Value;
        3: Build := Value;
        else Break;
      end;
    end;
end;

function TVersion.ToString: string;
begin
  Result := ToString('.');
end;

function TVersion.ToString(Separator: char): string;
begin
  Result := Major.ToString + Separator + Minor.ToString + Separator + Maintenance.ToString + Separator + Build.ToString;
end;

end.