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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, IdHTTP,
  VCL.Graphics, Winapi.ActiveX, URLMon, IOUtils, Imaging.GIFImg, Imaging.jpeg,
  Imaging.pngimage, IdSSLOpenSSL;

  function GetInternetImage(imageurl: string; downloadfallback: boolean = true): TGraphic;

  function DownloadFile(Source, Destination: string): Boolean;
  function DownloadFileEx(Source, Dest: string): Boolean;

  // String Data
  function MaskEmailAdress(Adress: string): string;

implementation

function DownloadFile(Source, Destination: string): Boolean;
var
  IdHTTP1: TIdHTTP;
  FileStream: TFileStream;
begin
  try
    // Attempt 1 - IDHTTP
    IdHTTP1 := TIdHTTP.Create(nil);
    FileStream := TFileStream.Create(Destination, fmCreate);
    try
      IdHTTP1.Get(Source, FileStream);

      Result := TFile.Exists(Destination);
    finally
      IdHTTP1.Free;
      FileStream.Free;
    end;
  except
    // Attempt 2 - UrlMon
    try
      Result := UrlDownloadToFile( nil, PChar(source), PChar( Destination ) , 0, nil ) = 0;
    except
      // Failure
      Result := False;
    end;
  end;
end;

function DownloadFileEx(Source, Dest: string): Boolean;
begin
    try
      Result := UrlDownloadToFile( nil, PChar(source), PChar( Dest ) , 0, nil ) = 0;
    except
      Result := False;
    end;
end;

function GetInternetImage(imageurl: string; downloadfallback: boolean = true): TGraphic;
var
  MS : TMemoryStream;
  HTTP: TIdHTTP;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  fname, ext: string;
begin
  // Create stream
  MS := TMemoryStream.Create;
  HTTP := TIdHTTP.Create;
  SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  SSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
  HTTP.IOHandler := SSLIOHandler;

  ext := Copy(imageurl, imageurl.LastIndexOf('.') + 2, imageurl.Length);

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
    {Graphic := TGraphic.Create;}Result := TBitMap.Create;

  try
    try
      // Get Image
      HTTP.get(imageurl, MS);
      Ms.Seek(0,soFromBeginning);
      Result.LoadFromStream(MS);
    except

      // Fallback
      if downloadfallback then
        begin
          fname := 'C:\Windows\Temp\tempinternetimg' + Copy(imageurl, imageurl.LastIndexOf('.') + 1, imageurl.Length);
          if DownloadFile(imageurl, fname) then
            try
              Result.LoadFromFile(fname);
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