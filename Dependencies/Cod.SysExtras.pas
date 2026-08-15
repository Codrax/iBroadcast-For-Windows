{***********************************************************}
{                   Codrut System Extras                    }
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

{$SCOPEDENUMS ON}

unit Cod.SysExtras;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Variants, Vcl.Clipbrd, IOUtils, Winapi.ShellAPI, Cod.Files,
  Vcl.Forms, IdHTTP, IdSSLOpenSSL, Cod.StringUtils, DateUtils,
  Cod.ByteUtils, Cod.Types, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg, Winapi.MMSystem, System.Zip, Cod.Windows;

type
  TBeepType = (Information, Error, Confirmation, Warning);

// System
procedure SystemBeep(BeepType: TBeepType);
function GetWallpaperFileName(): string;
procedure OperationCompletedSuccessfully();

// Explorer
procedure ExplorerRun(Path: string); // this is good to run an app an user from a elevated process

// Zip
procedure ZipDirectory(const Directory, ZipFileName: string);
procedure UnzipToDirectory(const ZipFileName, TargetDirectory: string);

// Audio
procedure PlayResourceSound(ResourceName: string; Flags: cardinal);

// Network
function GetRandomIntegerAPI(Min: int64 = 0; Max: int64 = 100): int64;
function GetRandomIntegersAPI(Min: int64 = 0; Max: int64 = 100; Count: integer = 1): TArray<int64>;

// Programs
procedure TerminateApplication(ExeName: string; Force: boolean = false; KillChildren: boolean = false);

// Explorer
procedure RevealFileExplorer(FilePath: string);

// Image
procedure LoadPictureFileSignature(FileName: string; var BitMap: TBitMap);
procedure LoadGraphicAsBitmap(FileName: string; var BitMap: TBitMap);
procedure MsPaintEditPicture(PicturePath: string);

// DLL
procedure OpenWindowsPhotoViewer(ImagePath: string);
procedure OpenWindowsPrintDialogue(ImagePath: string); overload;

var
  LastRandomRequest: TTime = 0;

implementation

procedure SystemBeep(BeepType: TBeepType);
begin
  case BeepType of
    TBeepType.Information: MessageBeep(0);
    TBeepType.Error: MessageBeep(20);
    TBeepType.Confirmation: MessageBeep(70);
    TBeepType.Warning: MessageBeep(50);
  end;
end;

function GetWallpaperFileName(): string;
var
  Wallpaper: array[0..MAX_PATH - 1] of Char;
begin
    if SystemParametersInfo(SPI_GETDESKWALLPAPER, Length(Wallpaper), @Wallpaper[0], 1) then
      Result := Wallpaper
        else
          Result := '';
end;

procedure OperationCompletedSuccessfully();
resourcestring
  ErrInf = '%S%S';
var
  Error: EOSError;
begin
  Error := EOSError.CreateResFmt(@ErrInf, [SysErrorMessage(0), '']);

  raise Error at ReturnAddress;
end;

procedure ExplorerRun(Path: string);
begin
  ShellExecute(0, 'open', 'explorer.exe',  PChar(Format('"%s"', [Path])), nil, SW_NORMAL);
end;

procedure ZipDirectory(const Directory, ZipFileName: string);
var
  ZipFile: TZipFile;
  Files: TArray<string>;
  FileName, RelativeFileName, BaseDir: string;
begin
  if not TDirectory.Exists(Directory) then
    raise Exception.CreateFmt('Directory "%s" does not exist.', [Directory]);

  BaseDir := IncludeTrailingPathDelimiter(Directory);

  ZipFile := TZipFile.Create;
  try
    ZipFile.Open(ZipFileName, zmWrite);
    try
      Files := TDirectory.GetFiles(Directory, '*', TSearchOption.soAllDirectories);
      for FileName in Files do
      begin
        // Calculate relative path
        RelativeFileName := Copy(FileName, Length(BaseDir) + 1, MaxInt);

        // Convert Windows \ to ZIP /
        RelativeFileName := StringReplace(RelativeFileName, '\', '/', [rfReplaceAll]);

        // Add file
        ZipFile.Add(FileName, RelativeFileName);
      end;
    finally
      ZipFile.Close;
    end;
  finally
    ZipFile.Free;
  end;
end;

procedure UnzipToDirectory(const ZipFileName, TargetDirectory: string);
var
  ZipFile: TZipFile;
  AFileName: string;
begin
  if not TFile.Exists(ZipFileName) then
    raise Exception.CreateFmt('ZIP file "%s" does not exist.', [ZipFileName]);

  if not TDirectory.Exists(TargetDirectory) then
    TDirectory.CreateDirectory(TargetDirectory);

  ZipFile := TZipFile.Create;
  try
    ZipFile.Open(ZipFileName, zmRead);
    try
      for AFileName in ZipFile.FileNames do
        // Extract
        ZipFile.Extract(AFileName, TargetDirectory, True);
    finally
      ZipFile.Close;
    end;
  finally
    ZipFile.Free;
  end;
end;

procedure PlayResourceSound(ResourceName: string; Flags: cardinal);
var
  ResStream: TResourceStream;
begin
  ResStream := TResourceStream.Create(HInstance, ResourceName, RT_RCDATA);

  try
    ResStream.Position := 0;
    SndPlaySound(ResStream.Memory, SND_MEMORY or Flags);
  finally
    ResStream.Free;
  end;
end;

function GetRandomIntegerAPI(Min: int64; Max: int64): int64;
begin
  Result := GetRandomIntegersAPI(Min, Max, 1)[0];
end;

function GetRandomIntegersAPI(Min: int64; Max: int64; Count: integer): TArray<int64>;
(* Random.org provided random number *)
var
  FHTTP: TIdHTTP;
  Request,
  HTTPResponse: string;
  ResItems: TArray<string>;

  I, MsTime: integer;
begin
  // Count
  SetLength(Result, Count);

  // Creade IdHTTP
  FHTTP                         := TIdHTTP.Create(nil);
  FHTTP.Request.AcceptLanguage  := 'en';
  FHTTP.Request.UserAgent       := 'Mozilla/5.0';
  FHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  (TIdSSLIOHandlerSocketOpenSSL(FHTTP.IOHandler)).SSLOptions.SSLVersions := [sslvTLSv1_2];

  try
    // Prepare
    Request := 'https://www.random.org/integers/?col=1&base=10&format=plain';
    Request := Request + '&num=' + Count.ToString + '&min=' + min.ToString + '&max=' + Max.ToString;

    // Avoid Server Overload
    MsTime := MillisecondsBetween(LastRandomRequest, Now);
    if (MsTime < 1000) and (LastRandomRequest <> 0) then
      Sleep(1000 - MsTime);

    // Ping
    HTTPResponse := FHTTP.Get(Request);

    // Last Request
    LastRandomRequest := Now;

    // Parse
    ResItems := GetAllSeparatorItems(HTTPResponse, #$A);
    for I := 0 to High(Result) do
      Result[I] := ResItems[I].ToInt64;
  finally
    // Free
    FHTTP.Free;
  end;
end;

procedure TerminateApplication(ExeName: string; Force: boolean = false; KillChildren: boolean = false);
var
  parameters: string;
begin
  // Default
  parameters := '/im';

  parameters := parameters + ' ' + ExeName;

  // Extra param
  if Force then
    parameters := parameters + ' /f';

  if KillChildren then
    parameters := parameters + ' /t';

  ShellExecute(0, 'open', 'taskkill', PChar(parameters), nil, 0);
end;

procedure RevealFileExplorer(FilePath: string);
begin
  ShellExecute(0, 'open', 'explorer.exe', PChar(Format('/select, %S', [FilePath])), nil, 1);
end;

procedure LoadPictureFileSignature(FileName: string; var BitMap: TBitMap);
var
  Sign: TFileType;
  G: TGraphic;
begin
  Sign := ReadFileSignature(FileName);

  case Sign of
    TFileType.BMP: BitMap.LoadFromFile(FileName);
    TFileType.PNG: begin
      G := TPngImage.Create;
      try
        G.LoadFromFile(FileName);

        BitMap.Assign(G);
      finally
        G.Free;
      end;
    end;
    TFileType.JPEG: begin
      G := TJPEGImage.Create;
      try
        G.LoadFromFile(FileName);

        BitMap.Assign(G);
      finally
        G.Free;
      end;
    end;
    TFileType.GIF: begin
      G := TGifImage.Create;
      try
        G.LoadFromFile(FileName);

        BitMap.Assign(G);
      finally
        G.Free;
      end;
    end;
    //dftHEIC: ;
    //dftTIFF: ;
  end;
end;

procedure LoadGraphicAsBitmap(FileName: string; var BitMap: TBitMap);
var
  P: TPicture;
begin
  // Determine File Type
  P := TPicture.Create;
  try
    // Load
    P.LoadFromFile(FileName);

    // Bitmap
    BitMap := TBitMap.Create;

    BitMap.PixelFormat := pf32bit;
    Bitmap.TransparentMode := tmAuto;

    // Assign
    BitMap.Assign(P.Graphic);
  finally
    // Free Mem
    P.Free;
  end;
end;

procedure MsPaintEditPicture(PicturePath: string);
var
  mspath: string;
begin
  mspath := ReplaceWinPath('%localappdata%\Microsoft\WindowsApps\') + 'mspaint.exe';

  ShellExecute(0, nil, PChar(mspath),
      PChar('"' + PicturePath + '"'), nil, 1);
end;

procedure OpenWindowsPhotoViewer(ImagePath: string);
begin
  ShellExecute(0, 'open', PWideChar(ReplaceWinPath('%systemroot%\System32\rundll32.exe')), PChar('"PhotoViewer.dll", ImageView_Fullscreen ' + ImagePath), 'C:\Program Files\Windows Photo Viewer\', 1);
end;

procedure OpenWindowsPrintDialogue(ImagePath: string);
begin
  ShellExecute(0, 'print', PChar(ImagePath), nil, nil, SW_SHOWNORMAL);
end;

end.