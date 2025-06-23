program iBroadcast;

{$R *.dres}

uses
  Vcl.Forms,
  Cod.Instances,
  Cod.SysUtils,
  Cod.Dialogs,
  MainUI in 'MainUI.pas' {UIForm},
  BroadcastAPI in 'BroadcastAPI.pas',
  SpectrumVis3D in 'Utils\SpectrumVis3D.pas',
  iBroadcastUtils in 'Utils\iBroadcastUtils.pas',
  DebugForm in 'Forms\DebugForm.pas' {DebugUI},
  VolumePopup in 'Forms\VolumePopup.pas' {VolumePop},
  Performance in 'Forms\Performance.pas' {PerfForm},
  MiniPlay in 'Forms\MiniPlay.pas' {MiniPlayer},
  InfoForm in 'Forms\InfoForm.pas' {InfoBox},
  NewVersionForm in 'Forms\NewVersionForm.pas' {NewVersion},
  CreatePlaylistForm in 'Forms\CreatePlaylistForm.pas' {CreatePlaylist},
  Offline in 'Forms\Offline.pas' {OfflineForm},
  PickerDialogForm in 'Forms\PickerDialogForm.pas' {PickerDialog},
  RatingPopup in 'Forms\RatingPopup.pas' {RatingPopupForm},
  CodeSources in 'Forms\CodeSources.pas' {SourceUI},
  LoggingForm in 'Forms\LoggingForm.pas' {Logging};

{$R *.res}

var
  I: integer;
  Param: string;
begin
  Application.Initialize;

  // Close if Other instance
  SetSemaphore(APP_USERMODELID); // use application app user model ID
  InitializeInstance(true, false);

  if HasOtherInstance then begin
    SendOtherWindowMessageAuto(WM_RESTOREMAINWINDOW, 0, 0);
    BringOtherWindowToTopAuto;

    Halt( 1 );
  end;

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
  AddToLog('Started iBroadcast version ' + VERSION.ToString);
  AddToLog('Started creating forms');

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUIForm, UIForm);
  Application.CreateForm(TMiniPlayer, MiniPlayer);
  Application.CreateForm(TInfoBox, InfoBox);
  // Write instance data (use try, just to be on the safe side)
  try
    PutAppInfo( Application.MainForm.Handle );
  except
  end;

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
