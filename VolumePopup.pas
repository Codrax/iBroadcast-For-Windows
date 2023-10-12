unit VolumePopup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cod.Visual.Slider, Vcl.StdCtrls, BASS,
  Cod.MasterVolume, Vcl.ExtCtrls, ActiveX, MMDeviceApi, Math, MMSystem;

type
  TVolumePop = class(TForm)
    Panel1: TPanel;
    Speaker_Pick: TComboBox;
    Panel2: TPanel;
    Slider_System: CSlider;
    Label1: TLabel;
    Panel3: TPanel;
    System_Background: TLabel;
    System_Volume: TLabel;
    System_Value: TLabel;
    Panel4: TPanel;
    Label2: TLabel;
    App_Value: TLabel;
    Slider_App: CSlider;
    Panel5: TPanel;
    App_Background: TLabel;
    App_Volume: TLabel;
    Label6: TLabel;
    procedure Slider_SystemChange(Sender: CSlider; Position, Max, Min: Integer);
    procedure FormDeactivate(Sender: TObject);
    procedure Speaker_PickChange(Sender: TObject);
    procedure Speaker_PickMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure Speaker_PickDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure System_VolumeClick(Sender: TObject);
    procedure Slider_SystemMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Slider_AppChange(Sender: CSlider; Position, Max, Min: Integer);
    procedure Slider_AppMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure App_VolumeClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateIconStatus;

    procedure UpdateMainForm;
  public
    { Public declarations }
    procedure FullUpdate;

    procedure LoadVolume;
    procedure LoadDevices;
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

procedure TVolumePop.FormDeactivate(Sender: TObject);
begin
  Hide;
end;

procedure TVolumePop.FullUpdate;
begin
  LoadVolume;
  LoadDevices;

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

procedure TVolumePop.LoadDevices;
var
  deviceIndex: Integer;
  deviceInfo: BASS_DEVICEINFO;
begin
  Speaker_Pick.Clear;

  // Start with the first device (1 is "Default")
  deviceIndex := 2;

  // Loop through available devices until BASS_GetDeviceInfo returns nil
  while BASS_GetDeviceInfo(deviceIndex, deviceInfo) do
  begin
    // Print or use deviceInfo structure (e.g., deviceInfo.name, deviceInfo.driver)
    Speaker_Pick.Items.Add( string(deviceInfo.name) );

    // Move to the next device
    Inc(deviceIndex);
  end;
end;

procedure TVolumePop.LoadSelectedDevice;
begin
  Speaker_Pick.ItemIndex := GetCurrentAudioDeviceIndex;
end;

procedure TVolumePop.LoadVolume;
begin
  try
    Slider_App.Position := trunc(VolumeApplication.Volume * 1000);
    Slider_System.Position := trunc(VolumeSystem.Volume * 1000);
  except
    Slider_System.Position := trunc(Player.Volume * 1000);
  end;
  System_Value.Caption := (Slider_System.Position div 10).ToString;
  App_Value.Caption := (Slider_App.Position div 10).ToString;

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

procedure TVolumePop.Speaker_PickMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  with TComboBox(Control).Canvas do
    begin
      Height := Speaker_Pick.Canvas.TextHeight('A') + 20;
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
end;

procedure TVolumePop.UpdateMainForm;
begin
  UIForm.UpdateVolumeIcon;
end;

end.
