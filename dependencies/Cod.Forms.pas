{$SCOPEDENUMS ON}

unit Cod.Forms;

interface
uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows, Winapi.Messages, Winapi.DwmApi,
  Winapi.UxTheme,
  {$ENDIF}
  Classes, Vcl.Graphics, System.Types,
  System.Math, Vcl.Forms, System.SysUtils, Vcl.Controls, Cod.SysUtils,
  Cod.Windows, Cod.Helpers, Cod.Types, Cod.StringUtils,
  Cod.ArrayHelpers;

type
  {$IFDEF MSWINDOWS}
  // Dwm api
  AccentPolicy = packed record
    AccentState: Integer;
    AccentFlags: Integer;
    GradientColor: Integer;
    AnimationId: Integer;
  end;
  WindowCompositionAttributeData = packed record
    Attribute: Cardinal;
    Data: Pointer;
    SizeOfData: Integer;
  end;
  {$ENDIF}

// Positions
procedure CenterFormInForm(form, primaryform: TForm; alsoopen: boolean = false);
procedure CenterFormOnScreen(form: TForm);
procedure ChangeMainForm(NewForm: TForm);
function MouseAboveForm(form: TForm): boolean;
{$IFDEF MSWINDOWS}
function GetHoveredControl: TControl; // works for any form

// Display
procedure PrepareCustomTitleBar(var TitleBar: TForm; const Background: TColor; Foreground: TColor);

// Menus
procedure OpenFormSystemMenu(Form: TForm; Position: TPoint); overload;
procedure OpenFormSystemMenu(Form: TForm); overload;

// Flags
procedure SetFormAllowClose(Form: TForm; Allow: boolean);
{$ENDIF}

implementation

procedure CenterFormInForm(form, primaryform: TForm; alsoopen: boolean);
begin
  if form.Position <> poDesigned then
    form.Position := poDesigned;

  form.Left := primaryform.Left + primaryform.Width div 2 -form.Width div 2;
  form.Top := primaryform.Top + primaryform.Height div 2 -form.Height div 2;

  if alsoopen then
    form.Show;
end;

procedure CenterFormOnScreen(form: TForm);
begin
  form.Left := Screen.Width div 2 - form.Width div 2;
  form.Top := Screen.Height div 2 - form.Height div 2;
end;

procedure ChangeMainForm(NewForm: TForm);
begin
  Pointer((@Application.MainForm)^) := NewForm;
end;

function MouseAboveForm(form: TForm): boolean;
begin
  Result := false;

  if (mouse.CursorPos.X > form.Left)
    and (mouse.CursorPos.Y > form.Top)
    and (mouse.CursorPos.X < form.Left + form.Width)
    and (mouse.CursorPos.Y < form.Top + form.Height) then
      Result := true;
end;

{$IFDEF MSWINDOWS}
function GetHoveredControl: TControl;
var
  P: TPoint;
  Handle: HWND;
begin
  GetCursorPos(P);
  Handle := WindowFromPoint(P);
  Result := FindControl(Handle);

  //
  if (Result <> nil) and (not Result.InheritsFrom(TControl)) then
    Result := nil;
end;

procedure PrepareCustomTitleBar(var TitleBar: TForm; const Background: TColor; Foreground: TColor);
var
  CB, CF, SCB, SCF: integer;
begin
  if BackGround.GetLightValue < 100 then
    CB := 30
  else
    CB := -30;

  if Foreground.GetLightValue < 100 then
    CF := 30
  else
    CF := -30;

  SCF := CF div 2;
  SCB := CF div 2;

  with TitleBar.CustomTitleBar do
    begin
      BackgroundColor := BackGround;
      InactiveBackgroundColor := BackGround.ChangeSaturation(CB);
      ButtonBackgroundColor := BackGround;
      ButtonHoverBackgroundColor := BackGround.ChangeSaturation(SCB);
      ButtonInactiveBackgroundColor := BackGround.ChangeSaturation(CB);
      ButtonPressedBackgroundColor := BackGround.ChangeSaturation(CB);

      ForegroundColor := Foreground;
      ButtonForegroundColor := Foreground;
      ButtonHoverForegroundColor := ForeGround.ChangeSaturation(SCF);
      InactiveForegroundColor := Foreground.ChangeSaturation(CF);
      ButtonInactiveForegroundColor := Foreground.ChangeSaturation(CF);
      ButtonPressedForegroundColor := Foreground.ChangeSaturation(CF);
    end;
end;

procedure OpenFormSystemMenu(Form: TForm; Position: TPoint);
var
  Handle: HMENU;
  cmd: integer;
function EnableBool(Value: boolean): UINT;
begin
  if Value then
    Result := MF_BYCOMMAND or MF_ENABLED
  else
    Result := MF_BYCOMMAND or MF_GRAYED;
end;
begin
  // Get the handle to the system menu
  Handle := GetSystemMenu(Form.Handle, False);

  // Enable / disable the items
  EnableMenuItem(Handle, SC_RESTORE,
    EnableBool((Form.WindowState = TWindowState.wsMaximized) and (biMaximize in Form.BorderIcons))
    );
  EnableMenuItem(Handle, SC_MOVE, EnableBool(Form.WindowState <> TWindowState.wsMaximized));
  EnableMenuItem(Handle, SC_SIZE,
    EnableBool((Form.WindowState <> TWindowState.wsMaximized) and (Form.BorderStyle in [bsSizeable, bsSizeToolWin]))
    );

  EnableMenuItem(Handle, SC_MAXIMIZE,
    EnableBool((Form.WindowState <> TWindowState.wsMaximized) and (biMaximize in Form.BorderIcons) and (Form.BorderStyle in [bsSizeable, bsSingle]))
  );
  EnableMenuItem(Handle, SC_MINIMIZE,
    EnableBool((Form.WindowState <> TWindowState.wsMinimized) and (biMinimize in Form.BorderIcons) and (Form.BorderStyle in [bsSizeable, bsSingle, bsDialog]))
  );

  // Get CMD
  cmd := Integer(
    TrackPopupMenu(Handle, TPM_RETURNCMD or TPM_LEFTALIGN or TPM_TOPALIGN, Position.X, Position.Y, 0,
      Form.Handle, nil)
    );

  // If a valid command is selected, send it to the system for default processing
  if cmd <> 0 then
    SendMessage(Form.Handle, WM_SYSCOMMAND, cmd, 0);
end;

procedure OpenFormSystemMenu(Form: TForm);
begin
  OpenFormSystemMenu(Form, Mouse.CursorPos);
end;

procedure SetFormAllowClose(Form: TForm; Allow: boolean);
var
  Handle: HMENU;
function EnableBool(Value: boolean): UINT;
begin
  if Value then
    Result := MF_BYCOMMAND or MF_ENABLED
  else
    Result := MF_BYCOMMAND or MF_GRAYED;
end;
begin
  // Get the handle to the system menu
  Handle := GetSystemMenu(Form.Handle, False);

  // Set
  EnableMenuItem(Handle, SC_CLOSE, EnableBool(Allow) );
end;
{$ENDIF}

end.
