unit iBroadcastUtils;

interface
uses
  Types, SysUtils, Cod.Dialogs, Windows, Vcl.Dialogs, Classes, Variants,
  Graphics;

  // Dialogs
  function OpenDialog(Title, Text: string; AType: CMessageType = ctInformation; Buttons: TMsgDlgButtons = [mbOk]): integer;

  // String
  function MashString(AString: string): string;
  procedure RidOfSimbols(var DataStr: string);

const
  BG_COLOR = $002C0C11;
  FN_COLOR = clWhite;

var
  // App Config
  AllowDebug: boolean;

  // Application Settings
  IsOffline: boolean;
  SmallSize: integer;
  OverrideOffline: boolean = false;
  HiddenToTray: boolean;

implementation

function OpenDialog(Title, Text: string; AType: CMessageType = ctInformation; Buttons: TMsgDlgButtons = [mbOk]): integer;
var
  Dialog: CDialog;
begin
  Dialog := CDialog.Create;

  // Text
  Dialog.Title := Title;
  Dialog.Text := Text;

  // Colors & Design
  Dialog.EnableFooter := false;
  Dialog.GlobalSyncTogle := false;

  Dialog.FormColor := BG_COLOR;
  Dialog.TextFont.Color := FN_COLOR;

  Dialog.ButtonDesign.FlatButton := true;
  Dialog.ButtonDesign.FlatComplete := true;

  // Dialog
  Dialog.Buttons := Buttons;
  Dialog.Kind := AType;

  // Execute
  Result := Dialog.Execute;

  Dialog.Free;
end;

function MashString(AString: string): string;
begin
  Result := AString;
  Result := AnsiLowerCase(Result);
  RidOfSimbols(Result);
end;

procedure RidOfSimbols(var DataStr: string);
var
  RPFlag: TReplaceFlags;
begin
  RPFlag := [rfReplaceAll, rfIgnoreCase];

  DataStr := StringReplace(DataStr, ' ', '', RPFlag);
  DataStr := StringReplace(DataStr, ',', '', RPFlag);
  DataStr := StringReplace(DataStr, '.', '', RPFlag);
  DataStr := StringReplace(DataStr, '#', '', RPFlag);
  DataStr := StringReplace(DataStr, '&', '', RPFlag);
  DataStr := StringReplace(DataStr, '%', '', RPFlag);
  DataStr := StringReplace(DataStr, '!', '', RPFlag);
  DataStr := StringReplace(DataStr, '@', '', RPFlag);
  DataStr := StringReplace(DataStr, #39, '', RPFlag);
  DataStr := StringReplace(DataStr, '*', '', RPFlag);
  DataStr := StringReplace(DataStr, '"', '', RPFlag);
  DataStr := StringReplace(DataStr, '`', '', RPFlag);
  DataStr := StringReplace(DataStr, '~', '', RPFlag);
  DataStr := StringReplace(DataStr, '-', '', RPFlag);
  DataStr := StringReplace(DataStr, '(', '', RPFlag);
  DataStr := StringReplace(DataStr, ')', '', RPFlag);
  DataStr := StringReplace(DataStr, '[', '', RPFlag);
  DataStr := StringReplace(DataStr, ']', '', RPFlag);
end;

end.
