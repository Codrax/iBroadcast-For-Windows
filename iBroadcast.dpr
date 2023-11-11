program iBroadcast;

{$R *.dres}

uses
  Vcl.Forms,
  Cod.Instances,
  Cod.SysUtils,
  Cod.Dialogs,
  MainUI in 'MainUI.pas' {UIForm},
  BroadcastAPI in 'BroadcastAPI.pas',
  DebugForm in 'DebugForm.pas' {DebugUI},
  VolumePopup in 'VolumePopup.pas' {VolumePop},
  Performance in 'Performance.pas' {PerfForm},
  MiniPlay in 'MiniPlay.pas' {MiniPlayer},
  InfoForm in 'InfoForm.pas' {InfoBox},
  HelpForm in 'HelpForm.pas' {HelpUI},
  NewVersionForm in 'NewVersionForm.pas' {NewVersion},
  CreatePlaylistForm in 'CreatePlaylistForm.pas' {CreatePlaylist},
  Offline in 'Offline.pas' {OfflineForm},
  PickerDialogForm in 'PickerDialogForm.pas' {PickerDialog},
  iBroadcastUtils in 'iBroadcastUtils.pas',
  RatingPopup in 'RatingPopup.pas' {RatingPopupForm},
  CodeSources in 'CodeSources.pas' {SourceUI},
  SpectrumVis3D in 'SpectrumVis3D.pas',
  LoggingForm in 'LoggingForm.pas' {Logging};

{$R *.res}

var
  I: integer;
  Param: string;
begin
  Application.Initialize;

  // Close if Other instance
  TerminateIfOtherInstanceExists;

  {Application.CreateForm(TCreatePlaylist, CreatePlaylist);
  Application.Run;     }

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

      if Param = '-logtoken' then
        PrivacyEnabled := false;

      if Param = '-exportpost' then
        ExportPost := true;

      if Param = '-log32' then
        EnableLog32 := true;
    end;

  AddToLog('======================');
  AddToLog('Started iBroadcast version ' + Version);
  AddToLog('Started creating forms');

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUIForm, UIForm);
  Application.CreateForm(TMiniPlayer, MiniPlayer);
  Application.CreateForm(TInfoBox, InfoBox);

  // Log
  if EnableLog32 then
    begin
      Application.CreateForm(TLogging, Logging);
      Logging.Show;
      AddToLog('Created log form');
    end;

  // Debug
  AddToLog('Checking debug mode');
  if AllowDebug then
    begin
      // Debug form
      DebugUI := TDebugUI.Create(Application);

      DebugUI.Show;
      DebugUi.DataSync.Enabled := true;

      // UI
      with UIForm do
        begin
          CopyID1.Visible := true;
          CopyID2.Visible := true;
          CopyID3.Visible := true;
          CopyID4.Visible := true;
        end;
    end;

  AddToLog('Executing Application');
  Application.Run;
end.
