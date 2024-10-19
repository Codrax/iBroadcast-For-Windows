unit Cod.WindowsRT.MiscUtil;

interface

uses
  // System
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Forms, IOUtils, System.Generics.Collections, Dialogs, ActiveX, ComObj,
  DateUtils,

  // Graphics
  Vcl.Graphics,

  // Windows RT (Runtime)
  Win.WinRT,
  Winapi.Winrt,
  Winapi.Winrt.Utils,
  Winapi.DataRT,

  // Winapi
  Winapi.CommonTypes,
  Winapi.Foundation,
  Winapi.Storage.Streams,

  // Required
  Cod.WindowsRT.AsyncEvents,
  Cod.WindowsRT.Storage,
  Cod.WindowsRT.Runtime.Windows.Media,

  // Imaging
  Imaging.jpeg,
  Imaging.pngimage,
  Imaging.GIFImg,

  // Cod Utils
  Cod.WindowsRT,
  Cod.ArrayHelpers,
  Cod.Registry;

function LoadGraphicFromStream(S: TStream): TGraphic;

implementation

function LoadGraphicFromStream(S: TStream): TGraphic;
function TestStreamBytes(ABytes: TBytes): boolean;
var
  ACopied: TBytes;
begin
  S.Position := 0;
  SetLength(ACopied, Length(ABytes));
  S.ReadData(ACopied, Length(ABytes));

  Result := TArrayUtils<Byte>.CheckEquality(ACopied, ABytes);
end;
const
  BMP_SIGN: TBytes = [ $42, $4D ];
  PNG_SIGN: TBytes = [ $89, $50, $4E, $47, $0D, $0A, $1A, $0A ];
  GIF_SIGN: TBytes = [ $47, $49, $46 ];
  JPEG_SIGN: array[0..1] of TBytes = (
    [ $FF, $D8, $FF ],
    [ $49, $46, $00, $01 ]
  );
begin
  Result := nil;

  // Try different file formats
  if TestStreamBytes(BMP_SIGN) then
    Result := TBitMap.Create
  else
  if TestStreamBytes(PNG_SIGN) then
    Result := TPNGImage.Create
  else
  if TestStreamBytes(GIF_SIGN) then
    Result := TGifImage.Create
  else
  if TestStreamBytes(JPEG_SIGN[0]) or TestStreamBytes(JPEG_SIGN[1]) then
    Result := TJpegImage.Create;

  // Load if succeeded
  if Result <> nil then begin
    // Load
    S.Position := 0;
    Result.LoadFromStream(S);
  end;
end;

end.
