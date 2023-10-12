unit Cod.MasterVolume;

interface

uses
  SysUtils,
  Windows,
  ActiveX,
  ComObj,
  Cod.ArrayHelpers,
  MMSystem,
  MMDeviceAPI,
  AudioSessionService;

const
  CLSID_MMDeviceEnumerator: TGUID = '{BCDE0395-E52F-467C-8E3D-C4579291692E}';

  { Type Definitions }
  type
    { Types }
    TChannelTestProc = function(SessionControl2: IAudioSessionControl2): boolean;
    TAudioNotifyKind = (DisplayName, IconPath, SimpleVolume, ChannelVolume, GroupingParam, State, Disconnect);

    { Pre-def }
    TSystemAudioManager = class;
    TAppAudioManager = class;

    TNotifyChange = procedure(Sender: TAppAudioManager; const Notification: TAudioNotifyKind) of object;
    TDisplayNameChange = procedure(Sender: TAppAudioManager;const NewDisplayName: string) of object;
    TIconChange = procedure(Sender: TAppAudioManager; const NewIconPath: string) of object;
    TVolumeChange = procedure(Sender: TAppAudioManager; const NewVolume: Single; NewMute: boolean) of object;
    TChannelVolumeChange = procedure(Sender: TAppAudioManager;const ChannelCount: integer; NewChannelArray: Single; ChangedChannel: integer) of object;
    TGroupingChanged = procedure(Sender: TAppAudioManager; const NewGroupingParam: PGUID) of object;
    TStateChanged = procedure(Sender: TAppAudioManager; const NewState: TAudioSessionState) of object;
    TDisconnectChange = procedure(Sender: TAppAudioManager; const DisconnectReason: TAudioSessionDisconnectReason) of object;


    TSysVolumeChange = procedure(Sender: TSystemAudioManager; const Volume: Single; Muted: boolean) of object;
    TChannelsChange = procedure(Sender: TSystemAudioManager; const ChannelCount: integer) of object;

    { Event tracker }
    TAudioSystemEvent = class(TInterfacedObject, IAudioEndpointVolumeCallback)
      AudioManager: TSystemAudioManager;

      function OnNotify(pNotify: PAudioVolumeNotificationData): HRESULT; stdcall;
    end;

    TAudioSessionEvents = class(TInterfacedObject, IAudioSessionEvents)
    public
      AudioManager: TAppAudioManager;

      // Implement the IAudioSessionEvents methods here
      function OnDisplayNameChanged(NewDisplayName: LPCWSTR; EventContext: PGUID): HRESULT; stdcall;
      function OnIconPathChanged(NewIconPath: LPCWSTR; EventContext: PGUID): HRESULT; stdcall;
      function OnSimpleVolumeChanged(NewVolume    : Single;
                                     NewMute      : BOOL;
                                     EventContext : PGUID): HRESULT; stdcall;
      function OnChannelVolumeChanged(ChannelCount    : UINT;
                                      NewChannelArray : PSingle;
                                      ChangedChannel  : UINT;
                                      EventContext    : PGUID): HRESULT; stdcall;
      function OnGroupingParamChanged(NewGroupingParam,
                                      EventContext: PGUID): HRESULT; stdcall;
      function OnStateChanged(NewState: TAudioSessionState): HRESULT; stdcall;
      function OnSessionDisconnected(
                DisconnectReason: TAudioSessionDisconnectReason): HRESULT; stdcall;
    end;

    { Audio Channel Manager }
    TSystemAudioManager = class
    private
      FVolumeIntSys: IAudioEndpointVolume;

      FEvent: TAudioSystemEvent;
      FRegistered: boolean;
      FLastEvent: TAudioVolumeNotificationData;
      FVolumeChanged: TSysVolumeChange;
      FChannelsChange: TChannelsChange;

      function GetMute: boolean;
      function GetVolume: single;
      procedure SetMute(const Value: boolean);
      procedure SetVolume(const Value: single);
      function GetVolumeS: single;
      procedure SetVolumeS(const Value: single);

      procedure IndexLastEvent;
      procedure HandleChangeEvent(NotifyData: PAudioVolumeNotificationData);

    public
      // Volumes
      property Volume: single read GetVolume write SetVolume;
      property VolumeNonScalar: single read GetVolumeS write SetVolumeS;
      property Mute: boolean read GetMute write SetMute;

      // Data
      function Channels: cardinal;

      // Events
      function RegisterEventNotifier: boolean;
      function UnRegisterEventNotifier: boolean;

      property OnVolumeChange: TSysVolumeChange read FVolumeChanged write FVolumeChanged;
      property OnChannelsChange: TChannelsChange read FChannelsChange write FChannelsChange;

      // Common Volume
      procedure VolumeUp;
      procedure VolumeDown;

      // Constructors
      constructor Create;
      destructor Destroy; override;
    end;

    TAppAudioManager = class
    private
      FVolumeInt: ISimpleAudioVolume;
      FSessionCtrl: IAudioSessionControl2;

      FTest: TChannelTestProc;
      FEvents: TAudioSessionEvents;
      FConnected: boolean;
      FRegistered: boolean;
      FTag: integer;

      FNotifyChange: TNotifyChange;
      FDisplayNameChange: TDisplayNameChange;
      FIconChange: TIconChange;
      FVolumeChange: TVolumeChange;
      FChannelVolumeChange: TChannelVolumeChange;
      FGroupingChanged: TGroupingChanged;
      FStateChanged: TStateChanged;
      FDisconnectChange: TDisconnectChange;

      function GetVolume: single;
      procedure SetVolume(const Value: single);
      function GetMute: boolean;
      procedure SetMute(const Value: boolean);
      function GetDisplayName: string;
      procedure SetDisplayName(const Value: string);
      function GetIconPath: string;
      procedure SetIconPath(const Value: string);

    public
      // System
      property SessionControl2: IAudioSessionControl2 read FSessionCtrl write FSessionCtrl;
      property SimpleAudioVolume: ISimpleAudioVolume read FVolumeInt write FVolumeInt;

      // Properties
      property Volume: single read GetVolume write SetVolume;
      property Mute: boolean read GetMute write SetMute;
      property DisplayName: string read GetDisplayName write SetDisplayName;
      property IconPath: string read GetIconPath write SetIconPath;

      // Data
      function State: TAudioSessionState;
      function ProcessID: cardinal;
      function SessionIdentifier: string;

      property Tag: integer read FTag write FTag;

      // Events
      function RegisterEventNotifier: boolean;
      function UnRegisterEventNotifier: boolean;

      property OnNotifyChange: TNotifyChange read FNotifyChange write FNotifyChange; // global for all
      property OnDisplayNameChange: TDisplayNameChange read FDisplayNameChange write FDisplayNameChange;
      property OnIconChange: TIconChange read FIconChange write FIconChange;
      property OnVolumeChange: TVolumeChange read FVolumeChange write FVolumeChange;
      property OnChannelVolumeChange: TChannelVolumeChange read FChannelVolumeChange write FChannelVolumeChange;
      property OnGroupingChanged: TGroupingChanged read FGroupingChanged write FGroupingChanged;
      property OnStateChanged: TStateChanged read FStateChanged write FStateChanged;
      property OnDisconnectChange: TDisconnectChange read FDisconnectChange write FDisconnectChange;

      // Connect
      property Connected: boolean read FConnected;
      procedure ConnectMixer;
      function LoadVolumeController: boolean;

      // Constructors
      constructor Create;
      destructor Destroy; override;

      class function CreateApp: TAppAudioManager; overload;
      class function CreateApp(ChannelTest: TChannelTestProc): TAppAudioManager; overload;
    end;

  { System function }
  // Global
  function GetSystemVolumeInterface(out VolumeInterface: IAudioEndpointVolume): boolean;
  procedure SetMasterVolume(fLevelDB: single);
  function GetMasterVolume: Single;

  function GetMute: boolean;
  procedure SetMute(AMute: boolean);

  // Application
  function GetApplicationVolumeInterface(out VolumeInterface: ISimpleAudioVolume): boolean;
  procedure SetApplicationVolume(fLevelDB: single);
  function GetApplicationVolume: Single;

  function GetApplicationMute: boolean;
  procedure SetApplicationMute(AMute: boolean);

  // Volume Mixer
  procedure ActivateAudioSession;

  // Audio Interface Proc
  function GetApplicationSimpleAudio(out VolumeInterface: ISimpleAudioVolume; const ATestProc: TChannelTestProc): boolean;
  function GetApplicationSessionControl(out SessionControl2: IAudioSessionControl2; const ATestProc: TChannelTestProc): boolean;

  // Devices
  function GetCurrentAudioDeviceIndex: Integer;

  function EnumerateAudioOutputDevicesByID: TArray<string>;
  function EnumerateAudioOutputDevicesByName: TArray<string>;

implementation

procedure ActivateAudioSession;
var
  AEnumerator: IMMDeviceEnumerator;
  ADevice: IMMDevice;
  ASessionManager: IAudioSessionManager2;
  ASessionControl: IAudioSessionControl;
begin
  // Create the device enumerator
  CoCreateInstance(CLSID_MMDeviceEnumerator, nil, CLSCTX_ALL, IID_IMMDeviceEnumerator, AEnumerator);

  // Get the default audio device.
  AEnumerator.GetDefaultAudioEndpoint(eRender, eConsole, ADevice);

  // Get the audio client.
  ADevice.Activate(IID_IAudioSessionManager2, CLSCTX_ALL, nil, ASessionManager);

  // Create session
  ASessionManager.GetAudioSessionControl(nil, 0, ASessionControl);
end;

function Proc_TestAppChannel(SessionControl2: IAudioSessionControl2): boolean;
var
  AExtID: cardinal;
begin
  Result := false;
  if Succeeded(SessionControl2.GetProcessId(AExtID)) then
    Result := GetCurrentProcessId = AExtID;
end;

function GetApplicationVolumeInterface(out VolumeInterface: ISimpleAudioVolume): boolean;
begin
  Result := GetApplicationSimpleAudio(VolumeInterface, Proc_TestAppChannel);
end;

procedure SetApplicationVolume(fLevelDB: single);
var
  SimpleVolume: ISimpleAudioVolume;
begin
  if GetApplicationVolumeInterface(SimpleVolume) then
    if not Succeeded(SimpleVolume.SetMasterVolume(fLevelDB, nil)) then
      RaiseLastOSError;
end;

function GetApplicationVolume: Single;
var
  SimpleVolume: ISimpleAudioVolume;
begin
  if GetApplicationVolumeInterface(SimpleVolume) then
    if not Succeeded(SimpleVolume.GetMasterVolume(Result)) then
      RaiseLastOSError;
end;

function GetApplicationMute: boolean;
var
  SimpleVolume: ISimpleAudioVolume;
  IsMute: longbool;
begin
  Result := false;
  if GetApplicationVolumeInterface(SimpleVolume) then
    if Succeeded(SimpleVolume.GetMute(IsMute)) then
      Result := IsMute
    else
      RaiseLastOSError;
end;

procedure SetApplicationMute(AMute: boolean);
var
  SimpleVolume: ISimpleAudioVolume;
begin
  if GetApplicationVolumeInterface(SimpleVolume) then
    if not Succeeded(SimpleVolume.SetMute(AMute.ToInteger, nil)) then
      RaiseLastOSError;
end;

function GetApplicationSimpleAudio(out VolumeInterface: ISimpleAudioVolume; const ATestProc: TChannelTestProc): boolean;
var
  SessionControl2: IAudioSessionControl2;
begin
  Result := false;
  if GetApplicationSessionControl(SessionControl2, ATestProc) then
    // Get the simple audio volume interface
    if Succeeded(SessionControl2.QueryInterface(IID_ISimpleAudioVolume, VolumeInterface)) then
      begin
        Result := true;
      end;
end;

function GetApplicationSessionControl(out SessionControl2: IAudioSessionControl2; const ATestProc: TChannelTestProc): boolean;
var
  Enumerator: IMMDeviceEnumerator;
  Device: IMMDevice;
  SessionManager: IAudioSessionManager2;
  SessionEnumerator: IAudioSessionEnumerator;
  SessionControl: IAudioSessionControl;
  TotalSessions, i: integer;
begin
  Result := false;

  // Initialize COM and create the device enumerator
  CoInitialize(nil);
  if Succeeded(CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, Enumerator)) then
  begin
    // Get the default audio endpoint (usually speakers)
    if Succeeded(Enumerator.GetDefaultAudioEndpoint(eRender, eMultimedia, Device)) then
    begin
      // Get the session manager for the audio endpoint
      if Succeeded(Device.Activate(IID_IAudioSessionManager2, CLSCTX_INPROC_SERVER, nil, SessionManager)) then
      begin
        // Get the session enumerator
        if Succeeded(SessionManager.GetSessionEnumerator(SessionEnumerator)) then
        begin
          // Iterate through sessions to find your application
          if Succeeded(SessionEnumerator.GetCount(TotalSessions)) then
            for i := 0 to TotalSessions - 1 do
            begin
              if Succeeded(SessionEnumerator.GetSession(i, SessionControl)) then
              begin
                if Succeeded(SessionControl.QueryInterface(IID_IAudioSessionControl2, SessionControl2)) then
                  if ATestProc(SessionControl2) then
                    begin
                      Result := true;

                      // Exit loop
                      Break;
                    end;
              end;
            end;
        end;
      end;
    end;
  end;

  // Release interfaces and uninitialize COM when done
  SessionControl := nil;
  SessionEnumerator := nil;
  SessionManager := nil;
  Device := nil;
  Enumerator := nil;
  CoUninitialize;
end;

function GetSystemVolumeInterface(out VolumeInterface: IAudioEndpointVolume): boolean;
var
  pEndpointVolume: IAudioEndpointVolume;
  LDeviceEnumerator: IMMDeviceEnumerator;
  Dev: IMMDevice;
begin
  Result := false;
  if Succeeded(CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, LDeviceEnumerator)) then
    if Succeeded(LDeviceEnumerator.GetDefaultAudioEndpoint($00000000, $00000000, Dev)) then
      if Succeeded(Dev.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, pEndpointVolume)) then
        begin
          VolumeInterface := pEndpointVolume;
          Result := true;
        end;
end;

procedure SetMasterVolume(fLevelDB: single);
var
  pEndpointVolume: IAudioEndpointVolume;
begin
  if GetSystemVolumeInterface(pEndpointVolume) then
    if not Succeeded(pEndpointVolume.SetMasterVolumeLevelScalar(fLevelDB, nil)) then
      RaiseLastOSError;
end;

function GetMasterVolume: Single;
var
  pEndpointVolume: IAudioEndpointVolume;
begin
  if GetSystemVolumeInterface(pEndpointVolume) then
    if not Succeeded(pEndpointVolume.GetMasterVolumeLevelScalar(Result)) then
      RaiseLastOSError;
end;

function GetMute: boolean;
var
  pEndpointVolume: IAudioEndpointVolume;
  IsMute: longbool;
begin
  Result := false;
  if GetSystemVolumeInterface(pEndpointVolume) then
    if Succeeded(pEndpointVolume.GetMute(IsMute)) then
      Result := IsMute
    else
      RaiseLastOSError;
end;

procedure SetMute(AMute: boolean);
var
  pEndpointVolume: IAudioEndpointVolume;
begin
  if GetSystemVolumeInterface(pEndpointVolume) then
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

{ TAppAudioManager }

procedure TAppAudioManager.ConnectMixer;
begin
  FConnected := false;

  // Load session control
  if GetApplicationSessionControl(FSessionCtrl, FTest) then
    // Load volume controller
    if LoadVolumeController then
      FConnected := true
    else
      RaiseLastOSError;
end;

class function TAppAudioManager.CreateApp(
  ChannelTest: TChannelTestProc): TAppAudioManager;
begin
  Result := TAppAudioManager.Create;

  with Result do
    begin
      FTest := ChannelTest;

      // Connect
      ConnectMixer;
    end;
end;

destructor TAppAudioManager.Destroy;
begin
  if FRegistered then
    UnRegisterEventNotifier;

  FVolumeInt := nil;
  FSessionCtrl := nil;

  inherited;
end;

class function TAppAudioManager.CreateApp: TAppAudioManager;
begin
  Result := TAppAudioManager.Create;

  Result.ConnectMixer;
end;

constructor TAppAudioManager.Create;
begin
  // Defaukt
  FTest := Proc_TestAppChannel;

  FEvents := TAudioSessionEvents.Create;
  FEvents.AudioManager := Self;
end;

function TAppAudioManager.GetDisplayName: string;
var
  AChar: PChar;
begin
  if Succeeded(FSessionCtrl.GetDisplayName(AChar)) then
    Result := AChar
  else
    RaiseLastOSError;
end;

function TAppAudioManager.GetIconPath: string;
var
  AChar: PChar;
begin
  if Succeeded(FSessionCtrl.GetIconPath(AChar)) then
    Result := AChar
  else
    RaiseLastOSError;
end;

function TAppAudioManager.GetMute: boolean;
var
  IsMute: longbool;
begin
  Result := false;
  if Succeeded(FVolumeInt.GetMute(IsMute)) then
    Result := IsMute
  else
    RaiseLastOSError;
end;

function TAppAudioManager.GetVolume: single;
begin
  if not Succeeded(FVolumeInt.GetMasterVolume(Result)) then
    RaiseLastOSError;
end;

function TAppAudioManager.LoadVolumeController: boolean;
begin
  Result := Succeeded(FSessionCtrl.QueryInterface(IID_ISimpleAudioVolume, FVolumeInt));
end;

function TAppAudioManager.ProcessID: cardinal;
begin
  if not Succeeded(FSessionCtrl.GetProcessId(Result)) then
    RaiseLastOSError;
end;

function TAppAudioManager.RegisterEventNotifier: boolean;
begin
  Result := Succeeded(FSessionCtrl.RegisterAudioSessionNotification(FEvents));
  FRegistered := Result;
end;

function TAppAudioManager.SessionIdentifier: string;
var
  AChar: PChar;
begin
  if Succeeded(FSessionCtrl.GetSessionIdentifier(AChar)) then
    Result := AChar
  else
    RaiseLastOSError;
end;

procedure TAppAudioManager.SetDisplayName(const Value: string);
var
  AChar: PChar;
begin
  AChar := PChar(Value);

  if not Succeeded(FSessionCtrl.SetDisplayName(AChar, nil)) then
    RaiseLastOSError;
end;

procedure TAppAudioManager.SetIconPath(const Value: string);
var
  AChar: PChar;
begin
  AChar := PChar(Value);

  if not Succeeded(FSessionCtrl.SetIconPath(AChar, nil)) then
    RaiseLastOSError;
end;

procedure TAppAudioManager.SetMute(const Value: boolean);
begin
  if not Succeeded(FVolumeInt.SetMute(Value.ToInteger, nil)) then
    RaiseLastOSError;
end;

procedure TAppAudioManager.SetVolume(const Value: single);
begin
  if not Succeeded(FVolumeInt.SetMasterVolume(Value, nil)) then
    RaiseLastOSError;
end;

function TAppAudioManager.State: TAudioSessionState;
begin
  if not Succeeded(FSessionCtrl.GetState(Result)) then
    RaiseLastOSError;
end;

function TAppAudioManager.UnRegisterEventNotifier: boolean;
begin
  Result := Succeeded(FSessionCtrl.UnregisterAudioSessionNotification(FEvents));
  FRegistered := false;
end;

{ TSystemAudioManager }

function TSystemAudioManager.Channels: cardinal;
begin
  if not Succeeded(FVolumeIntSys.GetChannelCount(Result)) then
    RaiseLastOSError;
end;

constructor TSystemAudioManager.Create;
begin
  GetSystemVolumeInterface(FVolumeIntSys);

  FEvent := TAudioSystemEvent.Create;
  FEvent.AudioManager := Self;
end;

destructor TSystemAudioManager.Destroy;
begin
  if FRegistered then
    UnRegisterEventNotifier;

  FVolumeIntSys := nil;

  inherited;
end;

function TSystemAudioManager.GetMute: boolean;
var
  IsMute: longbool;
begin
  Result := false;
  if Succeeded(FVolumeIntSys.GetMute(IsMute)) then
    Result := IsMute
  else
    RaiseLastOSError;
end;

function TSystemAudioManager.GetVolume: single;
begin
  if not Succeeded(FVolumeIntSys.GetMasterVolumeLevelScalar(Result)) then
    RaiseLastOSError;
end;

function TSystemAudioManager.GetVolumeS: single;
begin
  if not Succeeded(FVolumeIntSys.GetMasterVolumeLevelScalar(Result)) then
    RaiseLastOSError;
end;

procedure TSystemAudioManager.HandleChangeEvent(
  NotifyData: PAudioVolumeNotificationData);
begin
  if FLastEvent.nChannels <> NotifyData.nChannels then
    if Assigned(OnChannelsChange) then
      OnChannelsChange(Self, NotifyData.nChannels);

  if (FLastEvent.fMasterVolume <> NotifyData.fMasterVolume) or (FLastEvent.bMuted <> NotifyData.bMuted) then
    if Assigned(OnVolumeChange) then
      OnVolumeChange(Self, NotifyData.fMasterVolume, NotifyData.bMuted);

  // Last Event
  FLastEvent.bMuted := NotifyData.bMuted;
  FLastEvent.fMasterVolume := NotifyData.fMasterVolume;
  FLastEvent.nChannels := NotifyData.nChannels;
end;

procedure TSystemAudioManager.IndexLastEvent;
begin
  FLastEvent.bMuted := Mute;
  FLastEvent.fMasterVolume := Volume;
  FLastEvent.nChannels := Channels;
end;

function TSystemAudioManager.RegisterEventNotifier: boolean;
begin
  Result := Succeeded(FVolumeIntSys.RegisterControlChangeNotify(FEvent));

  FRegistered := Result;

  // Index
  IndexLastEvent;
end;

procedure TSystemAudioManager.SetMute(const Value: boolean);
begin
  if not Succeeded(FVolumeIntSys.SetMute(Value.ToInteger, nil)) then
    RaiseLastOSError;
end;

procedure TSystemAudioManager.SetVolume(const Value: single);
begin
  if not Succeeded(FVolumeIntSys.SetMasterVolumeLevelScalar(Value, nil)) then
    RaiseLastOSError;
end;

procedure TSystemAudioManager.SetVolumeS(const Value: single);
begin
  if not Succeeded(FVolumeIntSys.SetMasterVolumeLevel(Value, nil)) then
    RaiseLastOSError;
end;

function TSystemAudioManager.UnRegisterEventNotifier: boolean;
begin
  Result := Succeeded(FVolumeIntSys.UnregisterControlChangeNotify(FEvent));

  FRegistered := false;
end;

procedure TSystemAudioManager.VolumeDown;
begin
  if not Succeeded(FVolumeIntSys.VolumeStepDown(nil)) then
    RaiseLastOSError;
end;

procedure TSystemAudioManager.VolumeUp;
begin
  if not Succeeded(FVolumeIntSys.VolumeStepUp(nil)) then
    RaiseLastOSError;
end;

{ TAudioSessionEvents }

function TAudioSessionEvents.OnChannelVolumeChanged(ChannelCount: UINT;
  NewChannelArray: PSingle; ChangedChannel: UINT; EventContext: PGUID): HRESULT;
begin
  if Assigned(AudioManager.OnNotifyChange) then
    AudioManager.OnNotifyChange(AudioManager, TAudioNotifyKind.ChannelVolume);

  if Assigned(AudioManager.OnChannelVolumeChange) then
    AudioManager.OnChannelVolumeChange(AudioManager, ChannelCount,
      NewChannelArray^, ChangedChannel);

  Result := S_OK;
end;

function TAudioSessionEvents.OnDisplayNameChanged(NewDisplayName: LPCWSTR;
  EventContext: PGUID): HRESULT;
begin
  if Assigned(AudioManager.OnNotifyChange) then
    AudioManager.OnNotifyChange(AudioManager, TAudioNotifyKind.DisplayName);

  if Assigned(AudioManager.OnDisplayNameChange) then
    AudioManager.OnDisplayNameChange(AudioManager, NewDisplayName);

  Result := S_OK;
end;

function TAudioSessionEvents.OnGroupingParamChanged(NewGroupingParam,
  EventContext: PGUID): HRESULT;
begin
  if Assigned(AudioManager.OnNotifyChange) then
    AudioManager.OnNotifyChange(AudioManager, TAudioNotifyKind.GroupingParam);

  if Assigned(AudioManager.OnGroupingChanged) then
    AudioManager.OnGroupingChanged(AudioManager, NewGroupingParam);

  Result := S_OK;
end;

function TAudioSessionEvents.OnIconPathChanged(NewIconPath: LPCWSTR;
  EventContext: PGUID): HRESULT;
begin
  if Assigned(AudioManager.OnNotifyChange) then
    AudioManager.OnNotifyChange(AudioManager, TAudioNotifyKind.IconPath);

  if Assigned(AudioManager.OnIconChange) then
    AudioManager.OnIconChange(AudioManager, NewIconPath);

  Result := S_OK;
end;

function TAudioSessionEvents.OnSessionDisconnected(
  DisconnectReason: TAudioSessionDisconnectReason): HRESULT;
begin
  if Assigned(AudioManager.OnNotifyChange) then
    AudioManager.OnNotifyChange(AudioManager, TAudioNotifyKind.Disconnect);

  if Assigned(AudioManager.OnDisconnectChange) then
    AudioManager.OnDisconnectChange(AudioManager, DisconnectReason);

  Result := S_OK;
end;

function TAudioSessionEvents.OnSimpleVolumeChanged(NewVolume: Single;
  NewMute: BOOL; EventContext: PGUID): HRESULT;
begin
  if Assigned(AudioManager.OnNotifyChange) then
    AudioManager.OnNotifyChange(AudioManager, TAudioNotifyKind.SimpleVolume);

  if Assigned(AudioManager.OnVolumeChange) then
    AudioManager.OnVolumeChange(AudioManager, NewVolume, NewMute);

  Result := S_OK;
end;

function TAudioSessionEvents.OnStateChanged(
  NewState: TAudioSessionState): HRESULT;
begin
  if Assigned(AudioManager.OnNotifyChange) then
    AudioManager.OnNotifyChange(AudioManager, TAudioNotifyKind.State);

  if Assigned(AudioManager.OnStateChanged) then
    AudioManager.OnStateChanged(AudioManager, NewState);

  Result := S_OK;
end;

{ TAudioSystemEvent }

function TAudioSystemEvent.OnNotify(
  pNotify: PAudioVolumeNotificationData): HRESULT;
begin
  AudioManager.HandleChangeEvent(pNotify);
  Result := S_OK;
end;

end.
