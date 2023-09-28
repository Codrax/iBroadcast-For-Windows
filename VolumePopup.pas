unit VolumePopup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cod.Visual.Slider, Vcl.StdCtrls, BASS,
  Cod.MasterVolume, Vcl.ExtCtrls, ActiveX, MMDeviceApi, Math;

type
  TVolumePop = class(TForm)
    Panel1: TPanel;
    CSlider1: CSlider;
    Label1: TLabel;
    Speaker_Pick: TComboBox;
    Text_Value: TLabel;
    Panel2: TPanel;
    Icon_Volume: TLabel;
    Icon_Background: TLabel;
    procedure CSlider1Change(Sender: CSlider; Position, Max, Min: Integer);
    procedure FormDeactivate(Sender: TObject);
    procedure Speaker_PickChange(Sender: TObject);
    procedure Speaker_PickMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure Speaker_PickDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Icon_VolumeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

procedure SetDefaultAudioDeviceByIndex(deviceIndex: Integer);
var
  MMDeviceEnumerator: IMMDeviceEnumerator;
  DeviceCollection: IMMDeviceCollection;
  MMDevice: IMMDevice;
begin
  // Initialize COM
  CoInitialize(nil);

  // Initialize the Core Audio API
  if Succeeded(CoCreateInstance(CLSID_MMDeviceEnumerator, nil, CLSCTX_ALL, IID_IMMDeviceEnumerator, MMDeviceEnumerator)) then
  begin
    // Enumerate audio output devices
    if Succeeded(MMDeviceEnumerator.EnumAudioEndpoints(eRender, DEVICE_STATE_ACTIVE, DeviceCollection)) then
    begin
      // Get the audio device by index
      if Succeeded(DeviceCollection.Item(deviceIndex, MMDevice)) then
      begin
        // Set the selected device as the default audio endpoint for rendering
        //if Succeeded(MMDeviceEnumerator.SetDefaultAudioEndpoint(eRender, eConsole, MMDevice)) then
        begin
          // The audio output device has been successfully changed to the one with the specified index
          // You can perform additional actions or handle success here
        end;
      end;
    end;
  end;
end;

procedure TVolumePop.CSlider1Change(Sender: CSlider; Position, Max, Min: Integer);
var
  AMute: boolean;
begin
  // Set
  try
    Text_Value.Caption := (Position div 10).ToString;

    SetMasterVolume( Position / 1000 );

    // Muting
    AMute := GetMute;
    if AMute and (Position > 0) then
      SetMute(false);

    if not AMute and (Position = 0) then
      SetMute(true);
  except
    //BASS_SetVolume( Position / 1000 );
  end;

  // Icon
  UpdateIconStatus;

  // Form Status
  UpdateMainForm;
end;

procedure TVolumePop.FormCreate(Sender: TObject);
begin
  EnumerateAudioOutputDevicesByName;
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

procedure TVolumePop.Icon_VolumeClick(Sender: TObject);
begin
  SetMute( not GetMute );
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
    CSlider1.Position := trunc(GetMasterVolume * 1000);
  except
    CSlider1.Position := trunc(Player.Volume * 1000);
  end;
  Text_Value.Caption := (VolumePop.CSlider1.Position div 10).ToString;

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
  VolumeIndex: integer;
  AMute: boolean;
begin
  VolumeIndex := ceil(CSlider1.Position / CSlider1.Max * 4);

  case VolumeIndex of
    0: Icon_Volume.Caption := #$E992;
    1: Icon_Volume.Caption := #$E993;
    2: Icon_Volume.Caption := #$E994;
    else Icon_Volume.Caption := #$E995;
  end;

  AMute := GetMute;
  if AMute then
    Icon_Volume.Caption := #$E74F;

  Icon_Background.Visible := not AMute;
end;

procedure TVolumePop.UpdateMainForm;
begin
  UIForm.StatusChanged;
end;

end.
