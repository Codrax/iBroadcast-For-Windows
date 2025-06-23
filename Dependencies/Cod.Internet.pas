{***********************************************************}
{                 Codruts Internet Utilities                }
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

unit Cod.Internet;

interface
  uses
  System.SysUtils, System.Classes, IdHTTP, IdSSLOpenSSL, IdIcmpClient, Types,
  {$IFDEF MSWINDOWS}
  Windows, Vcl.Graphics, Vcl.Imaging.jpeg, Vcl.Imaging.GIFImg, Vcl.Imaging.pngimage,
  URLMon, ActiveX, Variants, Winapi.IpTypes, Winapi.IpHlpApi, Win.ComObj,
  Winapi.WinInet,
  {$ENDIF}
  IOUtils, Cod.Files, Cod.StringUtils, Cod.MesssageConst, JSON;

type
  // Types
  TNetworkProtocol = (Unknown, TCP, UDP);
  TNetworkProtocolHelper = record helper for TNetworkProtocol
  public
    class function FromString(Value: string): TNetworkProtocol; static;

    function ToString: string;
  end;

  // Net utils
  {$IFDEF MSWINDOWS}
  function GetNetworkConnected: boolean;
  function GetAdapterDescription: string;
  function GetGatewayIP: string;
  function GetLocalIP: string;
  {$ENDIF}

  // UPnP
  {$IFDEF MSWINDOWS}
  function RegisterUPnPPort(const Port: Word; const Protocol: TNetworkProtocol; const Description: string): boolean;
  function UnregisterUPnPPort(const Port: Word; const Protocol: TNetworkProtocol): boolean;
  {$ENDIF}

  // General
  function DownloadFile(Source, Destination: string): Boolean;
  function GetInternetStream(URL: string; downloadfallback: boolean = true): TStream;
  {$IFDEF MSWINDOWS}
  function GetInternetImage(ImageURL: string; downloadfallback: boolean = true): TGraphic; overload;
  procedure GetInternetImage(ImageURL: string; var Image: TGraphic; downloadfallback: boolean = true); overload;
  {$ENDIF}

  // Indy Internet
  function PostJSONRequest(URL: string; RequestJSON: string): string;

  // Devices
  function PingDevice(Destination: string): boolean;

  // Util
  function DownloadFileHTTP(Source, Destination: string): Boolean;
  {$IFDEF MSWINDOWS}
  function DownloadFileMon(Source, Destination: string): Boolean;
  {$ENDIF}

  // String Data
  function MaskEmailAdress(Adress: string): string;

  // Utils
  function AnsiCharArrayToString(AnsiChars: array of AnsiChar): AnsiString;

implementation

function AnsiCharArrayToString(AnsiChars: array of AnsiChar): AnsiString;
begin
  Result := Copy(AnsiChars, 0, Length(AnsiChars));
end;

{$IFDEF MSWINDOWS}
function GetNetworkConnected: boolean;
var
  lpdwFlags: DWORD;
begin
  Result := InternetGetConnectedState(@lpdwFlags, 0);
end;

function GetAdapterDescription: string;
var
  AdapterInfo: PIP_ADAPTER_INFO;
  BufLen: ULONG;
  Res: DWORD;
  P: PIP_ADAPTER_INFO;
begin
  Result := '0.0.0.0';
  BufLen := 0;
  GetAdaptersInfo(nil, BufLen); // First call to get required buffer size
  GetMem(AdapterInfo, BufLen);
  try
    Res := GetAdaptersInfo(AdapterInfo, BufLen);
    if Res = ERROR_SUCCESS then
    begin
      P := AdapterInfo;
      Result := string(AnsiCharArrayToString(P.Description));
    end;
  finally
    FreeMem(AdapterInfo);
  end;
end;

function GetGatewayIP: string;
var
  AdapterInfo: PIP_ADAPTER_INFO;
  BufLen: ULONG;
  Res: DWORD;
  P: PIP_ADAPTER_INFO;
begin
  Result := '0.0.0.0';
  BufLen := 0;
  GetAdaptersInfo(nil, BufLen); // First call to get required buffer size
  GetMem(AdapterInfo, BufLen);
  try
    Res := GetAdaptersInfo(AdapterInfo, BufLen);
    if Res = ERROR_SUCCESS then
    begin
      P := AdapterInfo;
      while P <> nil do begin
        if (P^.GatewayList.IpAddress.S[0] <> #0) and
           (AnsiCharArrayToString(P^.GatewayList.IpAddress.S) <> '0.0.0.0') then
        begin
          Result := string(AnsiCharArrayToString(P^.GatewayList.IpAddress.S));
          Break;
        end;
        P := P^.Next;
      end;
    end;
  finally
    FreeMem(AdapterInfo);
  end;
end;

function GetLocalIP: string;
var
  AdapterInfo: PIP_ADAPTER_INFO;
  BufLen: ULONG;
  Res: DWORD;
  P: PIPAdapterInfo;
begin
  Result := '127.0.0.1';
  BufLen := 0;
  GetAdaptersInfo(nil, BufLen); // First call to get required buffer size
  GetMem(AdapterInfo, BufLen);
  try
    Res := GetAdaptersInfo(AdapterInfo, BufLen);
    if Res = ERROR_SUCCESS then
    begin
      P := AdapterInfo;
      while P <> nil do begin
        if (P^.IpAddressList.IpAddress.S[0] <> #0) and
           (AnsiCharArrayToString(P^.IpAddressList.IpAddress.S) <> '0.0.0.0') then
        begin
          Result := string(AnsiCharArrayToString(P^.IpAddressList.IpAddress.S));
          Break;
        end;
        P := P^.Next;
      end;
    end;
  finally
    FreeMem(AdapterInfo);
  end;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function RegisterUPnPPort(const Port: Word; const Protocol: TNetworkProtocol; const Description: string): boolean;
const
  CLSID_UPnPNAT = '{AE1E00AA-3FD5-403C-8A27-2BBDC30CD0E1}';
var
  UPnPNAT: OleVariant;
  Mappings: OleVariant;
begin
  Result := false;
  if Protocol = TNetworkProtocol.Unknown then
    raise Exception.Create('Unknown network protocol.');

  UPnPNAT := CreateOleObject('HNetCfg.NATUPnP');
  Mappings := UPnPNAT.StaticPortMappingCollection;
  if not VarIsNull(Mappings) then
    try
      // Add the port mapping
      Mappings.Add(Port, Protocol.ToString, Port, GetLocalIP, True, Description);
      Result := true;
    except
      Result := false;
    end;
end;

function UnregisterUPnPPort(const Port: Word; const Protocol: TNetworkProtocol): boolean;
const
  CLSID_UPnPNAT = '{AE1E00AA-3FD5-403C-8A27-2BBDC30CD0E1}';
var
  UPnPNAT: OleVariant;
  Mappings: OleVariant;
begin
  Result := false;
  if Protocol = TNetworkProtocol.Unknown then
    raise Exception.Create('Unknown network protocol.');

  UPnPNAT := CreateOleObject('HNetCfg.NATUPnP');
  Mappings := UPnPNAT.StaticPortMappingCollection;
  if not VarIsNull(Mappings) then
    // Remove mapping
    try
      Result := Mappings.Remove(Port, Protocol.ToString) = S_OK;
    except
      Result := false;
    end;
end;
{$ENDIF}

function DownloadFile(Source, Destination: string): Boolean;
begin
  Result := false;

  // Attempt 1 - IDHTTP
  if DownloadFileHTTP( Source, Destination ) then
    Exit(true);

  {$IFDEF MSWINDOWS}
  // Attempt 2 - UrlMon
  if DownloadFileMon( Source, Destination) then
    Exit(true);
  {$ENDIF}
end;

function PostJSONRequest(URL: string; RequestJSON: string): string;
var
  HTTP: TIdHTTP;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  Request: TJSONObject;
  RequestStream: TStringStream;
begin
  // Create HTTP and SSLIOHandler components
  HTTP := TIdHTTP.Create(nil);
  SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  Request := TJSONObject.Create;

  // Request
  RequestStream := TStringStream.Create(RequestJSON, TEncoding.UTF8);
  try
    // Set SSL/TLS options
    SSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    HTTP.IOHandler := SSLIOHandler;

    // Set headers
    HTTP.Request.ContentType := 'application/json';

    // Send POST
    Result := HTTP.Post(URL, RequestStream);
  finally
    // Free
    HTTP.Free;
    Request.Free;
    RequestStream.Free;
  end;
end;

function PingDevice(Destination: string): boolean;
var
  Icmp: TIdIcmpClient;
begin
  Icmp := TIdIcmpClient.Create(nil);
  try
    Icmp.Host := Destination;
    Icmp.ReceiveTimeout := 1000; // 1 second timeout
    Icmp.Ping;

    // Icmp.ReplyStatus.MsRoundTripTime.ToString is the response time in ms

    Result := Icmp.ReplyStatus.ReplyStatusType = rsEcho;
  finally
    Icmp.Free;
  end;
end;

function DownloadFileHTTP(Source, Destination: string): Boolean;
var
  HTTP: TIdHTTP;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  FileStream: TFileStream;
begin
  try
    // Attempt 1 - IDHTTP
    HTTP := TIdHTTP.Create(nil);
    HTTP.HandleRedirects := true;

    SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
    SSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    HTTP.IOHandler := SSLIOHandler;

    FileStream := TFileStream.Create(Destination, fmCreate);
    try
      HTTP.Get(Source, FileStream);

      Result := TFile.Exists(Destination);
    finally
      HTTP.Free;
      FileStream.Free;
    end;
  except
    Result := false;
  end;
end;

{$IFDEF MSWINDOWS}
function DownloadFileMon(Source, Destination: string): Boolean;
begin
  try
    Result := UrlDownloadToFile( nil, PChar(source), PChar( Destination ) , 0, nil ) = 0;
  except
    Result := False;
  end;
end;
{$ENDIF}

function GetInternetStream(URL: string; downloadfallback: boolean = true): TStream;
var
  HTTP: TIdHTTP;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  // Create stream
  Result := TMemoryStream.Create;

  // Create HTTP
  HTTP := TIdHTTP.Create;
  HTTP.HandleRedirects := true;

  SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  SSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
  HTTP.IOHandler := SSLIOHandler;
  try
    try
      // Get Image
      HTTP.Get(URL, Result);
      Result.Position := 0;
    except
      // Fallback
      if downloadfallback then begin
        const FilePath = 'C:\Windows\Temp\tempinternetstream' + GenerateString(10, [TStrGenFlag.LowercaseLetters, TStrGenFlag.Numbers]);
        if not DownloadFile(URL, FilePath) then
          Exit;

        // Load
        const FS = TFileStream.Create(FilePath, fmOpenRead);
        try
          Result.CopyFrom(FS, FS.Size);
          TFile.Delete(FilePath);
        finally
          FS.Free;
        end;
      end;
    end;
  finally
    // Free
    HTTP.Free;
  end;
end;

{$IFDEF MSWINDOWS}
function GetInternetImage(ImageURL: string; downloadfallback: boolean = true): TGraphic;
var
  ext: string;
begin
  ext := Copy(ImageURL, ImageURL.LastIndexOf('.') + 2, ImageURL.Length);

  if ext = 'bmp' then
    Result := TBitMap.Create
  else
  if ext = 'png' then
    Result := TPngImage.Create
  else
  if (ext = 'jpg') or (ext = 'jpeg') then
    Result := TJpegImage.Create
  else
  if ext = 'gif' then
    Result := TGifImage.Create
  else
    {Graphic := TGraphic.Create;}Result := TPngImage.Create;  // Default network image

  GetInternetImage(ImageURL, Result, downloadfallback);
end;

procedure GetInternetImage(ImageURL: string; var Image: TGraphic; downloadfallback: boolean = true);
var
  MS : TMemoryStream;
  HTTP: TIdHTTP;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  fname: string;
begin
  // Create stream
  MS := TMemoryStream.Create;
  HTTP := TIdHTTP.Create;
  HTTP.HandleRedirects := true;

  SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  SSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
  HTTP.IOHandler := SSLIOHandler;

  try
    try
      // Get Image
      HTTP.Get(ImageURL, MS);
      Ms.Seek(0, soFromBeginning);
      Image.LoadFromStream(MS);
    except

      // Fallback
      if downloadfallback then
        begin
          fname := 'C:\Windows\Temp\tempinternetimg' + ValidateFileName(Copy(ImageURL, ImageURL.LastIndexOf('.') + 1, ImageURL.Length));
          if DownloadFile(ImageURL, fname) then
            try
              Image.LoadFromFile(fname);
            except
              RaiseLastOSError;
            end;

          TFile.Delete(fname);
        end;
    end;
  finally
    // Free Memory
    FreeAndNil(MS);
    HTTP.Free;
  end;
end;
{$ENDIF}

function MaskEmailAdress(Adress: string): string;
var
  First, Second: string;
  I: Integer;
begin
  First := Copy( Adress, 1, Pos('@', Adress) -1);
  Second := Copy( Adress, Pos('@', Adress), length(Adress));

  for I := Low(First) + 1 to High(First) - 1 do
    First[I] := '*';

  Result := First + Second;
end;

{ TNetworkProtocolHelper }

class function TNetworkProtocolHelper.FromString(
  Value: string): TNetworkProtocol;
begin
  Result := TNetworkProtocol.Unknown;
  Value := Value.ToLower;

  for var X := Low(TNetworkProtocol) to High(TNetworkProtocol) do
    if X.ToString.ToLower = Value then
      Exit( X );
end;

function TNetworkProtocolHelper.ToString: string;
begin
  case Self of
    TNetworkProtocol.Unknown: Exit( UNKNOWN );
    TNetworkProtocol.TCP: Exit('TCP');
    TNetworkProtocol.UDP: Exit('UDP');
  end;
end;

end.