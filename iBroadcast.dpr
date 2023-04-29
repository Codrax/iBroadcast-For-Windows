program iBroadcast;

uses
  Vcl.Forms,
  Cod.SysUtils,
  MainUI in 'MainUI.pas' {UIForm},
  BroadcastAPI in 'BroadcastAPI.pas',
  DebugForm in 'DebugForm.pas' {DebugUI},
  VolumePopup in 'VolumePopup.pas' {VolumePop},
  Performance in 'Performance.pas' {PerfForm},
  MiniPlay in 'MiniPlay.pas' {MiniPlayer},
  InfoForm in 'InfoForm.pas' {InfoBox};

{$R *.res}

var
  I: integer;
  Param: string;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUIForm, UIForm);
  Application.CreateForm(TDebugUI, DebugUI);
  Application.CreateForm(TVolumePop, VolumePop);
  Application.CreateForm(TPerfForm, PerfForm);
  Application.CreateForm(TMiniPlayer, MiniPlayer);
  Application.CreateForm(TInfoBox, InfoBox);
  // Parameter String
  for I := 1 to ParamCount do
    begin
      Param := GetParameter(I);
      if Param = '-debug' then
        DebugUI.Show;

      DebugUi.DataSync.Enabled := true;
    end;

  Application.Run;
end.
