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

unit Cod.Internet;

interface
  uses
  System.SysUtils, System.Classes, IdHTTP, IdSSLOpenSSL,
  {$IFDEF MSWINDOWS}
  Vcl.Graphics, Vcl.Imaging.jpeg, Vcl.Imaging.GIFImg, Vcl.Imaging.pngimage,
  URLMon,
  {$ENDIF}
  IOUtils, Cod.Files, Cod.StringUtils;

  // General
  function DownloadFile(Source, Destination: string): Boolean;
  function GetInternetStream(URL: string; downloadfallback: boolean = true): TStream;
  {$IFDEF MSWINDOWS}
  function GetInternetImage(ImageURL: string; downloadfallback: boolean = true): TGraphic; overload;
  procedure GetInternetImage(ImageURL: string; var Image: TGraphic; downloadfallback: boolean = true); overload;
  {$ENDIF}

  // Util
  function DownloadFileHTTP(Source, Destination: string): Boolean;
  {$IFDEF MSWINDOWS}
  function DownloadFileMon(Source, Destination: string): Boolean;
  {$ENDIF}

  // String Data
  function MaskEmailAdress(Adress: string): string;

implementation

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

function DownloadFileHTTP(Source, Destination: string): Boolean;
var
  HTTP: TIdHTTP;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  FileStream: TFileStream;
begin
  try
    // Attempt 1 - IDHTTP
    HTTP := TIdHTTP.Create(nil);
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

end.