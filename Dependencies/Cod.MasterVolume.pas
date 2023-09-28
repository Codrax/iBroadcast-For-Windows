unit Cod.MasterVolume;

interface
uses
  SysUtils,
  Windows,
  ActiveX,
  ComObj,
  Cod.ArrayHelpers,
  MMSystem,
  MMDeviceAPI;

const
  CLSID_MMDeviceEnumerator: TGUID = '{BCDE0395-E52F-467C-8E3D-C4579291692E}';

  procedure SetMasterVolume(fLevelDB: single);
  function GetMasterVolume: Single;

  function GetMute: boolean;
  procedure SetMute(AMute: boolean);

  function GetCurrentAudioDeviceIndex: Integer;

  function EnumerateAudioOutputDevicesByID: TArray<string>;
  function EnumerateAudioOutputDevicesByName: TArray<string>;

implementation

procedure SetMasterVolume(fLevelDB: single);
var
  pEndpointVolume: IAudioEndpointVolume;
  LDeviceEnumerator: IMMDeviceEnumerator;
  Dev: IMMDevice;
begin
  if not Succeeded(CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, LDeviceEnumerator)) then
   RaiseLastOSError;
  if not Succeeded(LDeviceEnumerator.GetDefaultAudioEndpoint($00000000, $00000000, Dev)) then
   RaiseLastOSError;

  if not Succeeded( Dev.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, pEndpointVolume)) then
   RaiseLastOSError;

  if not Succeeded(pEndpointVolume.SetMasterVolumeLevelScalar(fLevelDB, nil)) then
   RaiseLastOSError;
end;

function GetMasterVolume: Single;
var
  pEndpointVolume: IAudioEndpointVolume;
  LDeviceEnumerator: IMMDeviceEnumerator;
  Dev: IMMDevice;
  VolumeLevel: Single;
begin
  if not Succeeded(CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, LDeviceEnumerator)) then
    RaiseLastOSError;
  if not Succeeded(LDeviceEnumerator.GetDefaultAudioEndpoint($00000000, $00000000, Dev)) then
    RaiseLastOSError;

  if not Succeeded(Dev.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, pEndpointVolume)) then
    RaiseLastOSError;

  if not Succeeded(pEndpointVolume.GetMasterVolumeLevelScalar(VolumeLevel)) then
    RaiseLastOSError;

  Result := VolumeLevel;
end;

function GetMute: boolean;

var
  pEndpointVolume: IAudioEndpointVolume;
  LDeviceEnumerator: IMMDeviceEnumerator;
  Dev: IMMDevice;
  IsMute: longbool;
begin
  if not Succeeded(CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, LDeviceEnumerator)) then
    RaiseLastOSError;
  if not Succeeded(LDeviceEnumerator.GetDefaultAudioEndpoint($00000000, $00000000, Dev)) then
    RaiseLastOSError;

  if not Succeeded(Dev.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, pEndpointVolume)) then
    RaiseLastOSError;

  if not Succeeded(pEndpointVolume.GetMute(IsMute)) then
    RaiseLastOSError;

  Result := IsMute;
end;

procedure SetMute(AMute: boolean);
var
  pEndpointVolume: IAudioEndpointVolume;
  LDeviceEnumerator: IMMDeviceEnumerator;
  Dev: IMMDevice;
begin
  if not Succeeded(CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, LDeviceEnumerator)) then
   RaiseLastOSError;
  if not Succeeded(LDeviceEnumerator.GetDefaultAudioEndpoint($00000000, $00000000, Dev)) then
   RaiseLastOSError;

  if not Succeeded( Dev.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, pEndpointVolume)) then
   RaiseLastOSError;

  if not Succeeded(pEndpointVolume.SetMute(AMute.ToInteger, nil)) then
   RaiseLastOSError;
end;

function GetCurrentAudioDeviceIndex: Integer;
var
  MMDeviceEnumerator: IMMDeviceEnumerator;
  DeviceCollection: IMMDeviceCollection;
  DeviceCount, I: Cardinal;
  MMDevice: IMMDevice;
  DeviceID: LPWSTR;
  DefaultDeviceID: LPWSTR;
begin
  Result := -1; // Initialize as -1 to indicate no current device found

  if Succeeded(CoCreateInstance(CLSID_MMDeviceEnumerator, nil, CLSCTX_ALL, IID_IMMDeviceEnumerator, MMDeviceEnumerator)) then
  begin
    if Succeeded(MMDeviceEnumerator.GetDefaultAudioEndpoint(eRender, eConsole, MMDevice)) then
    begin
      if Succeeded(MMDevice.GetId(DeviceID)) then
      begin
        if Succeeded(MMDeviceEnumerator.EnumAudioEndpoints(eRender, DEVICE_STATE_ACTIVE, DeviceCollection)) then
        begin
          DeviceCollection.GetCount(DeviceCount);
          for I := 0 to DeviceCount - 1 do
          begin
            if Succeeded(DeviceCollection.Item(I, MMDevice)) then
            begin
              if Succeeded(MMDevice.GetId(DefaultDeviceID)) then
              begin
                if SameText(DeviceID, DefaultDeviceID) then
                begin
                  Result := I; // Found the index of the current device
                  Break;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function EnumerateAudioOutputDevicesByID: TArray<string>;
var
  MMDeviceEnumerator: IMMDeviceEnumerator;
  DeviceCollection: IMMDeviceCollection;
  MMDevice: IMMDevice;
  I: Integer;
  DeviceTotal: cardinal;
  DeviceID: LPWSTR;
begin
  // Initialize COM
  CoInitialize(nil);

  // Initialize the Core Audio API
  if Succeeded(CoCreateInstance(CLSID_MMDeviceEnumerator, nil, CLSCTX_ALL, IID_IMMDeviceEnumerator, MMDeviceEnumerator)) then
  begin
    // Enumerate audio output devices
    if Succeeded(MMDeviceEnumerator.EnumAudioEndpoints(eRender, DEVICE_STATE_ACTIVE, DeviceCollection)) then
    begin
      // Get the count of audio output devices
      DeviceCollection.GetCount(DeviceTotal);

      // Loop through the devices and print their information
      for I := 0 to DeviceTotal - 1 do
      begin
        if Succeeded(DeviceCollection.Item(I, MMDevice)) then
        begin
          if Succeeded(MMDevice.GetId(DeviceID)) then
          begin
            // DeviceID contains the unique identifier of the device
            Result.AddValue( DeviceID );
          end;
        end;
      end;
    end;
  end;
end;

function EnumerateAudioOutputDevicesByName: TArray<string>;
var
  i: Integer;
  waveOutCaps: TWAVEOUTCAPS;
begin
  // This is not a great solution. Using Bass to read all devices is a better way.
  for i := 0 to waveOutGetNumDevs - 1 do
  begin
    if waveOutGetDevCaps(i, @waveOutCaps, SizeOf(TWAVEOUTCAPS)) = MMSYSERR_NOERROR then
    begin
      // Add string
      result.AddValue( Trim(waveOutCaps.szPname) );
    end;
  end;
end;

end.
