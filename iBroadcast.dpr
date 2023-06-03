program iBroadcast;

{$R *.dres}

uses
  Vcl.Forms,
  Cod.Instances,
  Cod.SysUtils,
  MainUI in 'MainUI.pas' {UIForm},
  BroadcastAPI in 'BroadcastAPI.pas',
  DebugForm in 'DebugForm.pas' {DebugUI},
  VolumePopup in 'VolumePopup.pas' {VolumePop},
  Performance in 'Performance.pas' {PerfForm},
  MiniPlay in 'MiniPlay.pas' {MiniPlayer},
  InfoForm in 'InfoForm.pas' {InfoBox},
  HelpForm in 'HelpForm.pas' {HelpUI},
  NewVersionForm in 'NewVersionForm.pas' {NewVersion};

{$R *.res}

var
  I: integer;
  Param: string;
  AllowDebug: boolean;
begin
  Application.Initialize;

  // Close if Other instance
  TerminateIfOtherInstanceExists;

  // Initiate Default
  AllowDebug := false;
  EnableLogging := false;

  // Parameter String
  for I := 1 to ParamCount do
    begin
      Param := GetParameter(I);
      if Param = '-debug' then
        AllowDebug := true;

      if Param = '-offline' then
        begin
          OverrideOffline := true;
        end;

      if Param = '-tray' then
        begin
          Application.ShowMainForm := false;
          HiddenToTray := true;
        end;

      if Param = '-logging' then
        EnableLogging := true;
    end;

  AddToLog('Started creating forms');

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUIForm, UIForm);
  Application.CreateForm(TVolumePop, VolumePop);
  Application.CreateForm(TPerfForm, PerfForm);
  Application.CreateForm(TMiniPlayer, MiniPlayer);
  Application.CreateForm(TInfoBox, InfoBox);
  Application.CreateForm(TNewVersion, NewVersion);

  // Debug
  AddToLog('Checking Debug Mode');
  if AllowDebug then
    begin
      Application.CreateForm(TDebugUI, DebugUI);
      DebugUI.Show;
      DebugUi.DataSync.Enabled := true;
    end;

  AddToLog('Executing Application');
  Application.Run;
end.
