unit VolumePopup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cod.Visual.Slider, Vcl.StdCtrls, BASS,
  Cod.MasterVolume, Vcl.ExtCtrls, ActiveX, MMDeviceApi, Math, MMSystem,
  Cod.Visual.Button;

type
  TVolumePop = class(TForm)
    Panel1: TPanel;
    Label6: TLabel;
    CButton18: CButton;
    Panel8: TPanel;
    Label15: TLabel;
    Panel9: TPanel;
    Label5: TLabel;
    Speed_Value: TLabel;
    Slider_Speed: CSlider;
    Panel10: TPanel;
    Label10: TLabel;
    Panel11: TPanel;
    Label11: TLabel;
    Bass_Value: TLabel;
    Slider_Bass: CSlider;
    Panel12: TPanel;
    Label14: TLabel;
    Panel13: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    System_Value: TLabel;
    Slider_System: CSlider;
    Panel3: TPanel;
    System_Background: TLabel;
    System_Volume: TLabel;
    Panel4: TPanel;
    Label2: TLabel;
    App_Value: TLabel;
    Slider_App: CSlider;
    Panel5: TPanel;
    App_Background: TLabel;
    App_Volume: TLabel;
    Panel6: TPanel;
    Label3: TLabel;
    Out_Device: TLabel;
    Panel7: TPanel;
    Label7: TLabel;
    Label4: TLabel;
    procedure Slider_SystemChange(Sender: CSlider; Position, Max, Min: Integer);
    procedure FormDeactivate(Sender: TObject);
    procedure Speaker_PickChange(Sender: TObject);
    procedure Speaker_PickDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure System_VolumeClick(Sender: TObject);
    procedure Slider_SystemMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Slider_AppChange(Sender: CSlider; Position, Max, Min: Integer);
    procedure Slider_AppMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure App_VolumeClick(Sender: TObject);
    procedure Slider_BassChange(Sender: CSlider; Position, Max, Min: Integer);
    procedure CButton18Click(Sender: TObject);
    procedure Slider_SpeedChange(Sender: CSlider; Position, Max, Min: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    ShowAdvVolume: boolean;

    procedure UpdateIconStatus;

    procedure UpdateMainForm;
  public
    { Public declarations }
    procedure FullUpdate;

    procedure UpdateTheSize;

    procedure LoadVolume;
    procedure LoadSelectedDevice;
  end;

var
  VolumePop: TVolumePop;

implementation

uses
  MainUI;

{$R *.dfm}

procedure TVolumePop.Slider_AppChange(Sender: CSlider; Position, Max,
  Min: Integer);
var
  AMute: boolean;
begin
  // Set
  try
    App_Value.Caption := (Position div 10).ToString;

    VolumeApplication.Volume := Position / 1000;

    // Muting
    AMute := VolumeApplication.Mute;
    if AMute and (Position > 0) then
      VolumeApplication.Mute := false;

    if not AMute and (Position = 0) then
      VolumeApplication.Mute := true;
  except
    //BASS_SetVolume( Position / 1000 );
  end;

  // Icon
  UpdateIconStatus;

  // Form Status
  UpdateMainForm;
end;

procedure TVolumePop.Slider_AppMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PlaySound('SYSTEMEXCLAMATION', 0, SND_ASYNC);
end;

procedure TVolumePop.Slider_BassChange(Sender: CSlider; Position, Max,
  Min: Integer);
begin
  try
    Bass_Value.Caption := (Position div 10).ToString;

    UIForm.AudioVolume := Position / 1000;
  except
  end;

  // Update icons for coloring
  UpdateIconStatus;
end;

procedure TVolumePop.Slider_SpeedChange(Sender: CSlider; Position, Max,
  Min: Integer);
begin
  try
    Speed_Value.Caption := (Position / 10).ToString;

    UIForm.AudioSpeed := Position / 10;
  except
  end;
end;

procedure TVolumePop.Slider_SystemChange(Sender: CSlider; Position, Max, Min: Integer);
var
  AMute: boolean;
begin
  // Set
  try
    System_Value.Caption := (Position div 10).ToString;

    VolumeSystem.Volume := Position / 1000;

    // Muting
    AMute := VolumeSystem.Mute;
    if AMute and (Position > 0) then
      VolumeSystem.Mute := false;

    if not AMute and (Position = 0) then
      VolumeSystem.Mute := true;
  except
    //BASS_SetVolume( Position / 1000 );
  end;

  // Icon
  UpdateIconStatus;
end;

procedure TVolumePop.Slider_SystemMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PlaySound('SYSTEMEXCLAMATION', 0, SND_ASYNC or SND_SYSTEM);
end;

procedure TVolumePop.CButton18Click(Sender: TObject);
begin
  ShowAdvVolume := not Panel8.Visible;

  // UI
  if ShowAdvVolume then
    CButton(Sender).BSegoeIcon := #$E010
  else
    CButton(Sender).BSegoeIcon := #$E011;

  // Update
  UpdateTheSize;
end;

procedure TVolumePop.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil( VolumePop );
end;

procedure TVolumePop.FormDeactivate(Sender: TObject);
begin
  Hide;
end;

procedure TVolumePop.FullUpdate;
begin
  LoadVolume;

  // Selected
  LoadSelectedDevice;
end;

procedure TVolumePop.System_VolumeClick(Sender: TObject);
begin
  VolumeSystem.Mute := not VolumeSystem.Mute;
  UpdateIconStatus;

  UpdateMainForm;
end;

procedure TVolumePop.App_VolumeClick(Sender: TObject);
begin
  VolumeApplication.Mute := not VolumeApplication.Mute;
  UpdateIconStatus;

  UpdateMainForm;
end;

procedure TVolumePop.LoadSelectedDevice;
var
  deviceInfo: BASS_DEVICEINFO;
begin
  if BASS_GetDeviceInfo(GetCurrentAudioDeviceIndex+2, deviceInfo) then
    Out_Device.Caption := String(deviceInfo.name)
  else
    Out_Device.Caption := 'Unknown device';

  Out_Device.Hint := Out_Device.Caption;
end;

procedure TVolumePop.LoadVolume;
begin
  // Volume
  try
    Slider_App.Position := trunc(VolumeApplication.Volume * 1000);
    Slider_System.Position := trunc(VolumeSystem.Volume * 1000);
    Slider_Bass.Position := trunc(UIForm.AudioVolume * 1000);
  except
    Slider_System.Position := trunc(Player.SystemVolume * 1000);
  end;
  System_Value.Caption := (Slider_System.Position div 10).ToString;
  App_Value.Caption := (Slider_App.Position div 10).ToString;
  Bass_Value.Caption := (Slider_Bass.Position div 10).ToString;

  // Speed
  try
    Slider_Speed.Position := trunc(UIForm.AudioSpeed * 10);
  except
  end;
  Speed_Value.Caption := (Slider_Speed.Position / 10).ToString;

  // Icon
  UpdateIconStatus;
end;

procedure TVolumePop.Speaker_PickChange(Sender: TObject);
begin
  LoadSelectedDevice;
end;

procedure TVolumePop.Speaker_PickDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  AText: string;
  ARect: TRect;
begin
  with TComboBox(Control).Canvas do
    begin
      // Fill
      ARect := Rect;
      ARect.Inflate(2, 2);

      Pen.Style := psClear;
      Brush.Style := bsSolid;

      if odSelected in State then
        Brush.Color := clHighlight
      else
        Brush.Color := TComboBox(Control).Color;

      FillRect(ARect);


      // Rects
      ARect := Rect;
      ARect.Width := ARect.Height;
      Rect.Left := Rect.Left + ARect.Width + 3;

      // Prepare
      Brush.Style := bsClear;

      // Text
      Font.Assign( TComboBox(Control).Font );
      AText := TComboBox(Control).Items[Index];

      TextRect( Rect, AText, [tfSingleLine, tfVerticalCenter] );

      // Icon
      Font.Name := 'Segoe Fluent Icons';
      Font.Size := 20;
      AText := #$E7F5;
      TextRect( ARect, AText, [tfSingleLine, tfVerticalCenter] );
    end;
end;

procedure TVolumePop.UpdateIconStatus;
var
  AMute: boolean;
begin
  // App
  case ceil(VolumeApplication.Volume * 4) of
    0: App_Volume.Caption := #$E992;
    1: App_Volume.Caption := #$E993;
    2: App_Volume.Caption := #$E994;
    else App_Volume.Caption := #$E995;
  end;

  AMute := VolumeApplication.Mute;
  if AMute then
    App_Volume.Caption := #$E74F;

  App_Background.Visible := not AMute;

  // System
  case ceil(VolumeSystem.Volume * 4) of
    0: System_Volume.Caption := #$E992;
    1: System_Volume.Caption := #$E993;
    2: System_Volume.Caption := #$E994;
    else System_Volume.Caption := #$E995;
  end;

  AMute := VolumeSystem.Mute;
  if AMute then
    System_Volume.Caption := #$E74F;

  System_Background.Visible := not AMute;

  // Danger
  if Slider_Bass.Position > 1000 then
    begin
      Bass_Value.Font.Color := clRed;
    end
  else
    begin
      Bass_Value.Font.Color := Self.Font.Color;
    end;
end;

procedure TVolumePop.UpdateMainForm;
begin
  UIForm.UpdateVolumeIcon;
end;

procedure TVolumePop.UpdateTheSize;
var
  PrevHeight: integer;
begin
  // Calc
  PrevHeight := Height;

  // UI
  Panel8.Visible := ShowAdvVolume;

  // Resize
  Self.Height := 10;

  // Add
  Top := Top + PrevHeight - Height;
end;

end.
