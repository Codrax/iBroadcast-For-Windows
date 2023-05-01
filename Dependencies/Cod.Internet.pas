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
  VCL.Graphics, Winapi.ActiveX, URLMon, IOUtils, Imaging.GIFImg, Imaging.jpeg, Imaging.pngimage;

  function GetInternetImage(imageurl: string; downloadfallback: boolean = true): TGraphic;

  function DownloadFile(Source, Dest: string): Boolean;

  // String Data
  function MaskEmailAdress(Adress: string): string;

implementation

function DownloadFile(Source, Dest: string): Boolean;
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
  HTP: TIdHTTP;
  fname, ext: string;
begin
  // Create stream
  MS := TMemoryStream.Create;
  HTP := TIdHTTP.Create;

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
      HTP.get(imageurl, MS);
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
    HTP.Free;
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