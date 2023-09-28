unit Cod.VersionUpdate;

interface
  uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, IdSNTP,
  Registry, DateUtils, IdHTTP, Math, Cod.Math, Cod.Types, JSON, IdSSLOpenSSL;

  type
    TVersionRec = record
      Major,
      Minor,
      Maintanance,
      Build: cardinal;

      APIResponse: TJsonObject;

      procedure Clear;

      // Load
      procedure Parse(From: string);
      procedure NetworkLoad(URL: string);
      procedure HtmlLoad(URL: string);
      procedure APILoad(AppName: string; Endpoint: string = 'https://www.codrutsoft.com/api/');

      // Comparation
      function CompareTo(Version: TVersionRec): TRelation;
      function NewerThan(Version: TVersionRec): boolean;

      // Conversion
      function ToString(IncludeBuild: boolean = false): string; overload;
      function ToString(Separator: char; IncludeBuild: boolean = false): string; overload;
    end;

    function MakeVersion(Major, Minor, Maintanance: cardinal; Build: cardinal = 0): TVersionRec;

implementation

function MakeVersion(Major, Minor, Maintanance: cardinal; Build: cardinal = 0): TVersionRec;
begin
  Result.Major := Major;
  Result.Minor := Minor;
  Result.Maintanance := Maintanance;
  Result.Build := Build;
end;


{ TVersionRec }

procedure TVersionRec.NetworkLoad(URL: string);
var
  IdHttp: TIdHTTP;
  HTML: string;
begin
  IdHttp := TIdHTTP.Create(nil);
  try
    HTML := IdHttp.Get(URL);

    Parse(HTML);
  finally
    IdHttp.Free;
  end;
end;


function TVersionRec.NewerThan(Version: TVersionRec): boolean;
begin
  Result := CompareTo(Version) = TRelation.Bigger;
end;

procedure TVersionRec.APILoad(AppName, Endpoint: string);
var
  HTTP: TIdHTTP;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  Request: TJSONObject;
  RequestStream: TStringStream;
  Result: string;
begin
  // Create HTTP and SSLIOHandler components
  HTTP := TIdHTTP.Create(nil);
  SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  Request := TJSONObject.Create;

  // Build Request
  Request.AddPair('mode', 'getversion');
  Request.AddPair('app', AppName);

  // Request
  RequestStream := TStringStream.Create(Request.ToJSON, TEncoding.UTF8);
  try
    // Set SSL/TLS options
    SSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    HTTP.IOHandler := SSLIOHandler;

    // Set headers
    HTTP.Request.ContentType := 'application/json';

    // Send POST
    Result := HTTP.Post(Endpoint, RequestStream);

    // Parse
    APIResponse := TJSONObject.ParseJSONValue( Result ) as TJSONObject;

    // Parse response
    Parse(APIResponse.GetValue<string>('version'));
  finally
    // Free
    HTTP.Free;
    Request.Free;
    RequestStream.Free;
  end;
end;

procedure TVersionRec.Clear;
begin
  Major := 0;
  Minor := 0;
  Maintanance := 0;
  Build := 0;
end;

function TVersionRec.CompareTo(Version: TVersionRec): TRelation;
begin
  Result := GetNumberRelation(Major, Version.Major);
  if Result <> TRelation.Equal then
    Exit;

  Result := GetNumberRelation(Minor, Version.Minor);
  if Result <> TRelation.Equal then
    Exit;

  Result := GetNumberRelation(Maintanance, Version.Maintanance);
  if Result <> TRelation.Equal then
    Exit;

  Result := GetNumberRelation(Build, Version.Build);
end;

procedure TVersionRec.HtmlLoad(URL: string);
var
  IdHttp: TIdHTTP;
  HTML: string;
begin
  IdHttp := TIdHTTP.Create(nil);
  try
    IdHttp.Request.CacheControl := 'no-cache';
    HTML := IdHttp.Get(URL);

    HTML := Trim(HTML).Replace(#13, '').DeQuotedString;

    Parse(HTML);
  finally
    IdHttp.Free;
  end;
end;

procedure TVersionRec.Parse(From: string);
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
    Exit;

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
        2: Maintanance := Value;
        3: Build := Value;
      end;
    end;
end;

function TVersionRec.ToString(IncludeBuild: boolean): string;
begin
  Result := ToString('.', IncludeBuild);
end;

function TVersionRec.ToString(Separator: char; IncludeBuild: boolean): string;
begin
  Result := Major.ToString + Separator + Minor.ToString + Separator + Maintanance.ToString;

  if IncludeBuild then
    Result := Result + Separator + Build.ToString;
end;

end.