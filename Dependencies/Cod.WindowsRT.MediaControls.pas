{***********************************************************}
{               Codruts Windows Media Controls              }
{                                                           }
{                        version 1.0                        }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{              Copyright 2024 Codrut Software               }
{***********************************************************}

{$SCOPEDENUMS ON}

unit Cod.WindowsRT.MediaControls;

interface

uses
  // System
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Forms, IOUtils, System.Generics.Collections, Dialogs, ActiveX, ComObj,
  DateUtils,

  // Graphics
  Vcl.Graphics,

  // Windows RT (Runtime)
  Win.WinRT,
  Winapi.Winrt,
  Winapi.Winrt.Utils,
  Winapi.DataRT,

  // Winapi
  Winapi.CommonTypes,
  Winapi.Foundation,
  Winapi.Storage.Streams,

  // Media
  Winapi.Media,

  // Required
  Cod.WindowsRT.AsyncEvents,
  Cod.WindowsRT.Storage,
  Cod.WindowsRT.Runtime.Windows.Media,
  Cod.WindowsRT.MiscUtil,
  Cod.WindowsRT.AppRegistration,

  // Resources
  Cod.WindowsRT.Exceptions,
  Cod.WindowsRT.ResourceStrings,

  // Cod Utils
  Cod.WindowsRT,
  Cod.Registry;

type
  TGlobalSystemMediaControlsSessionManager = class;
  TSystemMediaControlsSession = class;
  TPlaybackMediaPlayer = class;
  TWindowMediaTransportControls = class;
  TTransportCompatibleClass = class;

  TMediaControlAction = (Play,
    Pause,
    Stop,
    DoRecord,
    FastForward,
    Rewind,
    SkipNext,
    SkipPrevious,
    ChannelUp,
    ChannelDown
  );
  TMediaControlActions = set of TMediaControlAction;
  TMediaControlAbility = (
    Position,
    PlaybackRate,
    Shuffle,
    AutoRepeat
  );
  TMediaControlAbilities = set of TMediaControlAbility;
  TMediaPlaybackStatus = MediaPlaybackStatus;
  TMediaPlaybackType = MediaPlaybackType;
  TMediaAutoRepeatMode = MediaPlaybackAutoRepeatMode;
  TControlMediaPlaybackStatus = Control_GlobalSystemMediaTransportControlsSessionPlaybackStatus;
  TSystemMediaTransportControlsButton = SystemMediaTransportControlsButton;
  TSystemMediaTransportControlsProperty = SystemMediaTransportControlsProperty;
  TMediaPlaybackAutoRepeatMode = MediaPlaybackAutoRepeatMode;

  // Notify object managers
  TMediaNotifyPlaybackInfoChangedEventProc = procedure(Sender: TSystemMediaControlsSession) of object;
  TMediaNotifyPlaybackInfoChangedEvent = class(TSubscriptionEventHandler<TSystemMediaControlsSession,
    TMediaNotifyPlaybackInfoChangedEventProc>,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSession__Control_IPlaybackInfoChangedEventArgs,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSession__Control_IPlaybackInfoChangedEventArgs_Delegate_Base)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: Control_IGlobalSystemMediaTransportControlsSession; args: Control_IPlaybackInfoChangedEventArgs); safecall;
  end;
  TMediaTimelinePropertiesChangedEventProc = procedure(Sender: TSystemMediaControlsSession) of object;
  TMediaTimelinePropertiesChangedEvent = class(TSubscriptionEventHandler<TSystemMediaControlsSession,
    TMediaTimelinePropertiesChangedEventProc>,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSession__Control_ITimelinePropertiesChangedEventArgs,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSession__Control_ITimelinePropertiesChangedEventArgs_Delegate_Base)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: Control_IGlobalSystemMediaTransportControlsSession; args: Control_ITimelinePropertiesChangedEventArgs); safecall;
  end;
  TMediaPropertiesChangedEventProc = procedure(Sender: TSystemMediaControlsSession) of object;
  TMediaPropertiesChangedEvent = class(TSubscriptionEventHandler<TSystemMediaControlsSession,
    TMediaPropertiesChangedEventProc>,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSession__Control_IMediaPropertiesChangedEventArgs,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSession__Control_IMediaPropertiesChangedEventArgs_Delegate_Base)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: Control_IGlobalSystemMediaTransportControlsSession; args: Control_IMediaPropertiesChangedEventArgs); safecall;
  end;

  TSystemMediaSessionManagerCurrentSessionChangedEventProc = procedure(Sender: TGlobalSystemMediaControlsSessionManager) of object;
  TSystemMediaSessionManagerCurrentSessionChangedEvent = class(TSubscriptionEventHandler<TGlobalSystemMediaControlsSessionManager,
    TSystemMediaSessionManagerCurrentSessionChangedEventProc>,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSessionManager__Control_ICurrentSessionChangedEventArgs,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSessionManager__Control_ICurrentSessionChangedEventArgs_Delegate_Base)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: Control_IGlobalSystemMediaTransportControlsSessionManager; args: Control_ICurrentSessionChangedEventArgs); safecall;
  end;
  TSystemMediaSessionManagerSessionsChangedEventProc = procedure(Sender: TGlobalSystemMediaControlsSessionManager) of object;
  TSystemMediaSessionManagerSessionsChangedEvent = class(TSubscriptionEventHandler<TGlobalSystemMediaControlsSessionManager,
    TSystemMediaSessionManagerSessionsChangedEventProc>,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSessionManager__Control_ISessionsChangedEventArgs,
      TypedEventHandler_2__Control_IGlobalSystemMediaTransportControlsSessionManager__Control_ISessionsChangedEventArgs_Delegate_Base)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: Control_IGlobalSystemMediaTransportControlsSessionManager; args: Control_ISessionsChangedEventArgs); safecall;
  end;

  TPlaybackMediaPlayerButtonPressedEventProc = procedure(Sender: TTransportCompatibleClass; Button: TSystemMediaTransportControlsButton) of object;
  TPlaybackMediaPlayerButtonPressedEvent = class(TSubscriptionEventHandler<TTransportCompatibleClass,
    TPlaybackMediaPlayerButtonPressedEventProc>,
      TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsButtonPressedEventArgs,
      TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsButtonPressedEventArgs_Delegate_Base)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: ISystemMediaTransportControls; args: ISystemMediaTransportControlsButtonPressedEventArgs); safecall;
  end;

  TPlaybackMediaPlayerPropertyChangedEventProc = procedure(Sender: TTransportCompatibleClass; AProperty: TSystemMediaTransportControlsProperty) of object;
  TPlaybackMediaPlayerPropertyChangedEvent = class(TSubscriptionEventHandler<TTransportCompatibleClass,
    TPlaybackMediaPlayerPropertyChangedEventProc>,
      TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsPropertyChangedEventArgs,
      TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsPropertyChangedEventArgs_Delegate_Base)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: ISystemMediaTransportControls; args: ISystemMediaTransportControlsPropertyChangedEventArgs); safecall;
  end;
                                                                                                               // use in64 milliseconds instead of TimeSpan
  TMediaTransportControlsPlaybackPositionChangeRequestedEventProc = procedure(Sender: TTransportCompatibleClass; RequestedPosition: int64) of object;
  TMediaTransportControlsPlaybackPositionChangeRequestedEvent = class(TSubscriptionEventHandler<TTransportCompatibleClass,
    TMediaTransportControlsPlaybackPositionChangeRequestedEventProc>,
      TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsPlaybackPositionChangeRequestedEventArgs)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: ISystemMediaTransportControls; args: IPlaybackPositionChangeRequestedEventArgs); safecall;
  end;
  TMediaTransportControlsPlaybackRateChangeRequestedEventProc = procedure(Sender: TTransportCompatibleClass; RequestedPlaybackRate: double) of object;
  TMediaTransportControlsPlaybackRateChangeRequestedEvent = class(TSubscriptionEventHandler<TTransportCompatibleClass,
    TMediaTransportControlsPlaybackRateChangeRequestedEventProc>,
      TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsPlaybackRateChangeRequestedEventArgs)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: ISystemMediaTransportControls; args: IPlaybackRateChangeRequestedEventArgs); safecall;
  end;
  TMediaTransportControlsShuffleEnabledChangeRequestedEventProc = procedure(Sender: TTransportCompatibleClass; RequestedShuffle: boolean) of object;
  TMediaTransportControlsShuffleEnabledChangeRequestedEvent = class(TSubscriptionEventHandler<TTransportCompatibleClass,
    TMediaTransportControlsShuffleEnabledChangeRequestedEventProc>,
      TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsShuffleEnabledChangeRequestedEventArgs)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: ISystemMediaTransportControls; args: IShuffleEnabledChangeRequestedEventArgs); safecall;
  end;
  TMediaTransportControlsRepeatModeChangeRequestedEventProc = procedure(Sender: TTransportCompatibleClass; RequestRepeat: TMediaPlaybackAutoRepeatMode) of object;
  TMediaTransportControlsRepeatModeChangeRequestedEvent = class(TSubscriptionEventHandler<TTransportCompatibleClass,
    TMediaTransportControlsRepeatModeChangeRequestedEventProc>,
      TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsAutoRepeatModeChangeRequestedEventArgs)
  protected
    procedure Subscribe; override;
    procedure Unsubscribe; override;

    procedure Invoke(sender: ISystemMediaTransportControls; args: IAutoRepeatModeChangeRequestedEventArgs); safecall;
  end;

  // Manager
  TGlobalSystemMediaControlsSessionManager = class
  private
    FInterface: Control_IGlobalSystemMediaTransportControlsSessionManager;

    FOnCurrentSessionChanged: TSystemMediaSessionManagerCurrentSessionChangedEvent;
    FOnSessionsChanged: TSystemMediaSessionManagerSessionsChangedEvent;

    // Getters
    function GetActiveSession: TSystemMediaControlsSession;
    function GetSessionCount: Cardinal;
    function GetSession(Index: Cardinal): TSystemMediaControlsSession;
    function GetActiveSessionIndex: integer;

  public
    property Interfaced: Control_IGlobalSystemMediaTransportControlsSessionManager read FInterface;

    // Sessions
    property ActiveSession: TSystemMediaControlsSession read GetActiveSession;
    property ActiveSessionIndex: integer read GetActiveSessionIndex;

    // Listing
    property SessionCount: Cardinal read GetSessionCount;
    /// <summary>
    ///  Create a Media Class Session controller for the session ID provided. (must be freed)
    /// </summary>
    property Sessions[Index: Cardinal]: TSystemMediaControlsSession read GetSession;

    // Events
    property OnCurrentSessionChanged: TSystemMediaSessionManagerCurrentSessionChangedEvent read FOnCurrentSessionChanged;
    property OnSessionsChanged: TSystemMediaSessionManagerSessionsChangedEvent read FOnSessionsChanged;

    // Utils
    function GetIndexOf(Session: TSystemMediaControlsSession): Cardinal;

    // Constructors
    constructor Create;
    destructor Destroy; override;
  end;

  // Information
  TSystemMediaControlsMediaInformation = class
  private
    FInterface: Control_IGlobalSystemMediaTransportControlsSessionMediaProperties;

    // Util
    function GetAsString(HStr: HSTRING): string; // return string and free

    // Getters
    function GetTitle: string;
    function GetAlbumArtist: string;
    function GetAlbumTitle: string;
    function GetAlbumTrackCount: integer;
    function GetArtist: string;
    function GetGenres: TArray<string>;
    function GetSubtitle: string;
    function GetTrackNumber: integer;
    function GetThumbnail: TGraphic;
    function GetMediaPlaybackType: TMediaPlaybackType;

  public
    property Interfaced: Control_IGlobalSystemMediaTransportControlsSessionMediaProperties read FInterface;

    // Properties
    property Title: string read GetTitle;
    property AlbumArtist: string read GetAlbumArtist;
    property AlbumTitle: string read GetAlbumTitle;
    property Artist: string read GetArtist;
    property Subtitle: string read GetSubtitle;
    property MediaPlaybackType: TMediaPlaybackType read GetMediaPlaybackType;

    property Thumbnail: TGraphic read GetThumbnail;
    property Genres: TArray<string> read GetGenres;

    property TrackNumber: integer read GetTrackNumber;
    property AlbumTrackCount: integer read GetAlbumTrackCount;

    // Info
    function HasThumbnail: boolean; // Return if a thumbnail is present

    // Constructors
    constructor Create(AInterface: Control_IGlobalSystemMediaTransportControlsSessionMediaProperties);
    destructor Destroy; override;
  end;

  // Session
  TSystemMediaControlsSession = class
  private
    FInterface: Control_IGlobalSystemMediaTransportControlsSession;
    FMediaInformation: TSystemMediaControlsMediaInformation;

    FOnPlaybackInfoChanged: TMediaNotifyPlaybackInfoChangedEvent;
    FOnTimelineInfoChanged: TMediaTimelinePropertiesChangedEvent;
    FOnMediaPropertiesChanged: TMediaPropertiesChangedEvent;

    // Getters
    function GetStatus: TControlMediaPlaybackStatus;
    function GetPlaybackType: TMediaPlaybackType;
    function GetShuffle: boolean;
    function GetRepeatMode: TMediaAutoRepeatMode;
    function GetPlaybackPosition: int64;
    function GetPlaybackRate: double;
    function GetPlaybackEndTime: int64;
    function GetPlaybackStartTime: int64;
    function GetMediaInfo: TSystemMediaControlsMediaInformation;

    // Setters
    procedure SetStatus(const Value: TControlMediaPlaybackStatus);
    procedure SetShuffle(const Value: boolean);
    procedure SetRepeatMode(const Value: TMediaAutoRepeatMode);
    procedure SetPlaybackPosition(const Value: int64);
    procedure SetPlaybackRate(const Value: double);

  protected
    procedure CreateMediaInformation;
    procedure DestroyMediaInformation;

  public
    property Interfaced: Control_IGlobalSystemMediaTransportControlsSession read FInterface;

    // Info
    function GetAppUserModelId: string;
    property MediaInformation: TSystemMediaControlsMediaInformation read GetMediaInfo;

    // Controls
    function CallMediaControl(Control: TMediaControlAction): TAsyncBoolean;
    function SupportedMediaControls: TMediaControlActions;

    // Abilities
    function SupportedMediaAbilities: TMediaControlAbilities;

    // Properties
    property PlaybackType: TMediaPlaybackType read GetPlaybackType;
    property PlaybackStatus: TControlMediaPlaybackStatus read GetStatus write SetStatus;
          // SetStatus will attempt to use CallMediaControl() with Async
    property ShuffleEnabled: boolean read GetShuffle write SetShuffle;
    property RepeatMode: TMediaAutoRepeatMode read GetRepeatMode write SetRepeatMode;

    property PlaybackRate: double read GetPlaybackRate write SetPlaybackRate;
    property PlaybackPosition: int64 read GetPlaybackPosition write SetPlaybackPosition;

    /// <summary> Start time in milliseconds. </summary>
    property PlaybackStartTime: int64 read GetPlaybackStartTime;
    /// <summary> End time in milliseconds. </summary>
    property PlaybackEndTime: int64 read GetPlaybackEndTime;

    // Events
    property OnPlaybackInfoChanged: TMediaNotifyPlaybackInfoChangedEvent read FOnPlaybackInfoChanged;
    property OnTimelineInfoChanged: TMediaTimelinePropertiesChangedEvent read FOnTimelineInfoChanged;
    property OnMediaPropertiesChanged: TMediaPropertiesChangedEvent read FOnMediaPropertiesChanged;

    // Wrapped CallMediaControl() calls
    function TryPlay: TAsyncBoolean;
    function TryPause: TAsyncBoolean;
    function TryStop: TAsyncBoolean;
    function TryNext: TAsyncBoolean;
    function TryPrevious: TAsyncBoolean;

    function TrySetShuffle(Value: boolean): TAsyncBoolean;
    function TrySetRepeatMode(Value: TMediaAutoRepeatMode): TAsyncBoolean;
    function TrySetPlaybackRate(Value: Double): TAsyncBoolean;
    function TrySetPlaybackPosition(Value: int64): TAsyncBoolean;

    //
    function CanPlayPause: boolean;
    function TryPlayPause: TAsyncBoolean;

    // Constructors
    constructor Create(AInterface: Control_IGlobalSystemMediaTransportControlsSession);
    destructor Destroy; override;
  end;

  TControlsTimelineProperties = class
  private
    FInterface: ISystemMediaTransportControlsTimelineProperties;

    // Getters
    function GetEndTime: int64;
    function GetMaxSeekTime: int64;
    function GetMinSeekTime: int64;
    function GetPosition: int64;
    function GetStartTime: int64;

    // Setters
    procedure SetEndTime(const Value: int64);
    procedure SetMaxSeekTime(const Value: int64);
    procedure SetMinSeekTime(const Value: int64);
    procedure SetPosition(const Value: int64);
    procedure SetStartTime(const Value: int64);
  public
    property Interfaced: ISystemMediaTransportControlsTimelineProperties read FInterface;

    property Position: int64 read GetPosition write SetPosition;
    property StartTime: int64 read GetStartTime write SetStartTime;
    property EndTime: int64 read GetEndTime write SetEndTime;
    property MinSeekTime: int64 read GetMinSeekTime write SetMinSeekTime;
    property MaxSeekTime: int64 read GetMaxSeekTime write SetMaxSeekTime;

    // Constructors
    constructor Create;
    destructor Destroy; override;
  end;

  // Playback editors
  TAudioPlaybackMediaPlayerEditor = class;
  TVideoPlaybackMediaPlayerEditor = class;
  TImagePlaybackMediaPlayerEditor = class;

  // Transport compatible class
  TTransportCompatibleClass = class
  private
    FOnButtonPressed: TPlaybackMediaPlayerButtonPressedEvent;
    FOnPropertyChanged: TPlaybackMediaPlayerPropertyChangedEvent;
    FOnPlaybackPositionChangeRequested: TMediaTransportControlsPlaybackPositionChangeRequestedEvent;
    FOnPlaybackRateChangeRequested: TMediaTransportControlsPlaybackRateChangeRequestedEvent;
    FOnShuffleEnabledChangeRequested: TMediaTransportControlsShuffleEnabledChangeRequestedEvent;
    FOnRepeatModeChangeRequested: TMediaTransportControlsRepeatModeChangeRequestedEvent;

    FInformationMusic: TAudioPlaybackMediaPlayerEditor;
    FInformationVideo: TVideoPlaybackMediaPlayerEditor;
    FInformationImage: TImagePlaybackMediaPlayerEditor;

    FTimeline: TControlsTimelineProperties;

    // Getters
    function GetAppMediaID: string;
    function GetEnablePlayer: boolean;
    function GetMediaPlaybackType: TMediaPlaybackType;
    function GetPlaybackStatus: TMediaPlaybackStatus;
    function GetSupportedMediaControls: TMediaControlActions;
    function GetThumbnail: TGraphic;
    function GetAutoRepeatMode: TMediaPlaybackAutoRepeatMode;
    function GetPlaybackRate: double;
    function GetShuffleEnabled: boolean;

    // Setters
    procedure SetAppMediaID(const Value: string);
    procedure SetEnablePlayer(const Value: boolean);
    procedure SetMediaPlaybackType(const Value: TMediaPlaybackType);
    procedure SetPlaybackStatus(const Value: TMediaPlaybackStatus);
    procedure SetSupportedMediaControls(const Value: TMediaControlActions);
    procedure SetThumbnail(const Value: TGraphic);
    procedure SetAutoRepeatMode(const Value: TMediaPlaybackAutoRepeatMode);
    procedure SetPlaybackRate(const Value: double);
    procedure SetShuffleEnabled(const Value: boolean);

  protected
    function GetTransportControls: ISystemMediaTransportControls; virtual; abstract;
    function GetTransportControls2: ISystemMediaTransportControls2; virtual; abstract;
    function GetUpdater: ISystemMediaTransportControlsDisplayUpdater; virtual; abstract;

  public
    // Transport
    property TransportControls: ISystemMediaTransportControls read GetTransportControls;
    property TransportControls2: ISystemMediaTransportControls2 read GetTransportControls2;
    property Updater: ISystemMediaTransportControlsDisplayUpdater read GetUpdater;

    // Editors
    property InfoMusic: TAudioPlaybackMediaPlayerEditor read FInformationMusic;
    property InfoVideo: TVideoPlaybackMediaPlayerEditor read FInformationVideo;
    property InfoImage: TImagePlaybackMediaPlayerEditor read FInformationImage;

    // Properties
    property AppMediaID: string read GetAppMediaID write SetAppMediaID;
    property MediaPlaybackType: TMediaPlaybackType read GetMediaPlaybackType write SetMediaPlaybackType;
    property Thumbnail: TGraphic read GetThumbnail write SetThumbnail;

    // Timeline
    property Timeline: TControlsTimelineProperties read FTimeline;
    procedure PushTimeline;

    // Controls
    property SupportedMediaControls: TMediaControlActions read GetSupportedMediaControls write SetSupportedMediaControls;

    // Player
    property EnablePlayer: boolean read GetEnablePlayer write SetEnablePlayer;
    property PlaybackStatus: TMediaPlaybackStatus read GetPlaybackStatus write SetPlaybackStatus;
    property AutoRepeatMode: TMediaPlaybackAutoRepeatMode read GetAutoRepeatMode write SetAutoRepeatMode;
    property ShuffleEnabled: boolean read GetShuffleEnabled write SetShuffleEnabled;
    property PlaybackRate: double read GetPlaybackRate write SetPlaybackRate;

    // Event notifiers
    property OnButtonPressed: TPlaybackMediaPlayerButtonPressedEvent read FOnButtonPressed;
    property OnPropertyChanged: TPlaybackMediaPlayerPropertyChangedEvent read FOnPropertyChanged;
    property OnPlaybackPositionChangeRequested: TMediaTransportControlsPlaybackPositionChangeRequestedEvent read FOnPlaybackPositionChangeRequested;
    property OnPlaybackRateChangeRequested: TMediaTransportControlsPlaybackRateChangeRequestedEvent read FOnPlaybackRateChangeRequested;
    property OnShuffleEnabledChangeRequested: TMediaTransportControlsShuffleEnabledChangeRequestedEvent read FOnShuffleEnabledChangeRequested;
    property OnRepeatModeChangeRequested: TMediaTransportControlsRepeatModeChangeRequestedEvent read FOnRepeatModeChangeRequested;

    // Metadata
    procedure UpdateInformation;
    procedure ClearAllInformation;

    // Utils
    /// <summary>
    ///  Set the playback information regardless of media type.
    /// </summary>
    procedure SetEditorInformation(Title, Subtitle: string; Update: boolean=true);

    // Constructors
    constructor Create;
    destructor Destroy; override;
  end;

  // Custom application media player
  TPlaybackMediaPlayer = class(TTransportCompatibleClass)
  private
    FInterface: Playback_IMediaPlayer;
    FInterface2: Playback_IMediaPlayer2;
    FInterface3: Playback_IMediaPlayer3;
    FInterface4: Playback_IMediaPlayer4;
    FInterface5: Playback_IMediaPlayer5;
    FInterface6: Playback_IMediaPlayer6;
    FInterface7: Playback_IMediaPlayer7;

    FTransport: ISystemMediaTransportControls;
    FTransport2: ISystemMediaTransportControls2;
    FUpdater: ISystemMediaTransportControlsDisplayUpdater;

    // Getters
    function GetIsLooping: boolean;
    function GetIsMuted: boolean;
    function GetPlaybackRate: double;
    function GetPosition: int64;
    function GetVolume: double;

    // Setters
    procedure SetIsMuted(const Value: boolean);
    procedure SetPlaybackRate(const Value: double);
    procedure SetIsLooping(const Value: boolean);
    procedure SetPosition(const Value: int64);
    procedure SetVolume(const Value: double);

  protected
    function GetTransportControls: ISystemMediaTransportControls; override;
    function GetTransportControls2: ISystemMediaTransportControls2; override;
    function GetUpdater: ISystemMediaTransportControlsDisplayUpdater; override;

  public
    property Interfaced: Playback_IMediaPlayer read FInterface;

    // Properties
    property PlayVolume: double read GetVolume write SetVolume;
    /// <summary> Playback position in milliseconds. </summary>
    property PlayPosition: int64 read GetPosition write SetPosition;
    property PlayPlaybackRate: double read GetPlaybackRate write SetPlaybackRate;

    property IsMuted: boolean read GetIsMuted write SetIsMuted;
    property IsLooping: boolean read GetIsLooping write SetIsLooping;

    // Constructors
    constructor Create(AAppMediaID: string);
    destructor Destroy; override;
  end;

  // MediaTransportControls for a TWindow
  TWindowMediaTransportControls = class(TTransportCompatibleClass)
  private
    FInterface: ISystemMediaTransportControls;
    FInterface2: ISystemMediaTransportControls2;

    FUpdater: ISystemMediaTransportControlsDisplayUpdater;

    FInterop: ISystemMediaTransportControlsInterop;

    FWindowHWND: HWND;
    FWindowClassName: PChar;

  protected
    function GetTransportControls: ISystemMediaTransportControls; override;
    function GetTransportControls2: ISystemMediaTransportControls2; override;
    function GetUpdater: ISystemMediaTransportControlsDisplayUpdater; override;

  public
    property Interfaced: ISystemMediaTransportControls read FInterface;
    property Interfaced2: ISystemMediaTransportControls2 read FInterface2;

    // Constructors
    constructor Create; overload;
    constructor Create(WindowClassName: string); overload;
    destructor Destroy; override;
  end;

  // Custom editors
  TBasePlaybackMediaPlayerEditor = class
  private
    RequiredType: TMediaPlaybackType;

    FParent: TTransportCompatibleClass;
  protected
    procedure Initialize; virtual;

  public
    // Utils
    procedure TestAccess;

    // Constructors
    constructor Create(AParent: TTransportCompatibleClass);
    destructor Destroy; override;
  end;
  TAudioPlaybackMediaPlayerEditor = class(TBasePlaybackMediaPlayerEditor)
  private
    function GetAlbumArtist: string;
    function GetArtist: string;
    function GetTitle: string;
    procedure SetAlbumArtist(const Value: string);
    procedure SetArtist(const Value: string);
    procedure SetTitle(const Value: string);
  protected
    procedure Initialize; override;
  public
    // Properties
    property Title: string read GetTitle write SetTitle;
    property Artist: string read GetArtist write SetArtist;
    property AlbumArtist: string read GetAlbumArtist write SetAlbumArtist;
  end;
  TVideoPlaybackMediaPlayerEditor = class(TBasePlaybackMediaPlayerEditor)
  private
    function GetTitle: string;
    function GetSubtitle: string;
    procedure SetTitle(const Value: string);
    procedure SetSubtitle(const Value: string);
  protected
    procedure Initialize; override;
  public
    // Properties
    property Title: string read GetTitle write SetTitle;
    property Subtitle: string read GetSubtitle write SetSubtitle;
  end;
  TImagePlaybackMediaPlayerEditor = class(TBasePlaybackMediaPlayerEditor)
  private
    function GetTitle: string;
    function GetSubtitle: string;
    procedure SetTitle(const Value: string);
    procedure SetSubtitle(const Value: string);
  protected
    procedure Initialize; override;
  public
    // Properties
    property Title: string read GetTitle write SetTitle;
    property Subtitle: string read GetSubtitle write SetSubtitle;
  end;

implementation

{ TSystemMediaControlsSession }

function TSystemMediaControlsSession.CanPlayPause: boolean;
begin
  Result := FInterface.GetPlaybackInfo.Controls.IsPlayPauseToggleEnabled;
end;

constructor TSystemMediaControlsSession.Create(
  AInterface: Control_IGlobalSystemMediaTransportControlsSession);
begin
  // Interface
  FInterface := AInterface;

  // Info
  FMediaInformation := nil;

  // Events
  FOnPlaybackInfoChanged := TMediaNotifyPlaybackInfoChangedEvent.Create(Self);
  FOnTimelineInfoChanged := TMediaTimelinePropertiesChangedEvent.Create(Self);
  FOnMediaPropertiesChanged := TMediaPropertiesChangedEvent.Create(Self);
end;

procedure TSystemMediaControlsSession.CreateMediaInformation;
var
  Operation: IAsyncOperation_1__Control_IGlobalSystemMediaTransportControlsSessionMediaProperties;
begin
  // Create async event
  Operation := FInterface.TryGetMediaPropertiesAsync;
  TAsyncAwait.Await( Operation );

  // Wait for value
  FMediaInformation := TSystemMediaControlsMediaInformation.Create( Operation.GetResults );

  // Clear operation
  Operation := nil;
end;

destructor TSystemMediaControlsSession.Destroy;
begin
  // Unregister events
  TSubscriptionEventHandlerBase.TryMultiUnsubscribe([
    FOnPlaybackInfoChanged,
    FOnTimelineInfoChanged,
    FOnMediaPropertiesChanged
  ]);
  FOnPlaybackInfoChanged := nil;
  FOnTimelineInfoChanged := nil;
  FOnMediaPropertiesChanged := nil;

  // Free media info
  if FMediaInformation <> nil then
    FMediaInformation.Free;

  // Clear main interface
  FInterface := nil;

  inherited;
end;

procedure TSystemMediaControlsSession.DestroyMediaInformation;
begin
  if FMediaInformation <> nil then
    FreeAndNil(FMediaInformation);
end;

function TSystemMediaControlsSession.GetAppUserModelId: string;
begin
  const HStr = FInterface.SourceAppUserModelId;
  try
    Result := HStr.ToString;
  finally
    HStr.Free;
  end;
end;

function TSystemMediaControlsSession.GetMediaInfo: TSystemMediaControlsMediaInformation;
begin
  if FMediaInformation = nil then
    CreateMediaInformation;

  Result := FMediaInformation;
end;

function TSystemMediaControlsSession.GetPlaybackEndTime: int64;
begin
  Result := FInterface.GetTimelineProperties.EndTime.ToMilliseconds;
end;

function TSystemMediaControlsSession.GetPlaybackPosition: int64;
begin
  Result := FInterface.GetTimelineProperties.Position.ToMilliseconds;
end;

function TSystemMediaControlsSession.GetPlaybackRate: double;
begin
  const Reference = FInterface.GetPlaybackInfo.PlaybackRate;
  if Reference <> nil then
    Result := Reference.Value
  else
    Result := 0;
end;

function TSystemMediaControlsSession.GetPlaybackStartTime: int64;
begin
  Result := FInterface.GetTimelineProperties.StartTime.ToMilliseconds;
end;

function TSystemMediaControlsSession.GetPlaybackType: TMediaPlaybackType;
begin
  const PlaybackReference = FInterface.GetPlaybackInfo.PlaybackType;
  if PlaybackReference <> nil then
    Result := PlaybackReference.Value
  else
    Result := TMediaPlaybackType.Unknown;
end;

function TSystemMediaControlsSession.GetRepeatMode: TMediaAutoRepeatMode;
begin
  const Reference = FInterface.GetPlaybackInfo.AutoRepeatMode;
  if Reference <> nil then
    Result := Reference.Value
  else
    Result := TMediaAutoRepeatMode(0);
end;

function TSystemMediaControlsSession.GetShuffle: boolean;
begin
  const Reference = FInterface.GetPlaybackInfo.IsShuffleActive;
  if Reference <> nil then
    Result := Reference.Value
  else
    Result := false;
end;

function TSystemMediaControlsSession.GetStatus: TControlMediaPlaybackStatus;
begin
  Result := FInterface.GetPlaybackInfo.PlaybackStatus; // typecast
end;

procedure TSystemMediaControlsSession.SetPlaybackPosition(const Value: int64);
begin
  TrySetPlaybackPosition(Value).Await;
end;

procedure TSystemMediaControlsSession.SetPlaybackRate(const Value: double);
begin
  TrySetPlaybackRate(Value).Await;
end;

procedure TSystemMediaControlsSession.SetRepeatMode(const Value: TMediaAutoRepeatMode);
begin
  TrySetRepeatMode(Value).Await;
end;

procedure TSystemMediaControlsSession.SetShuffle(const Value: boolean);
begin
  TrySetShuffle(Value).Await;
end;

procedure TSystemMediaControlsSession.SetStatus(
  const Value: TControlMediaPlaybackStatus);
var
  Async: TAsyncBoolean;
begin
  Async := nil;

  // Get async event
  case Value of
    //TMediaPlaybackStatus.Closed: ;
    //TMediaPlaybackStatus.Opened: ;
    //TMediaPlaybackStatus.Changing: ;
    TControlMediaPlaybackStatus.Stopped: Async := CallMediaControl( TMediaControlAction.Stop );
    TControlMediaPlaybackStatus.Playing: Async := CallMediaControl( TMediaControlAction.Play );
    TControlMediaPlaybackStatus.Paused: Async := CallMediaControl( TMediaControlAction.Pause );
  end;

  // Wait for async
  if Async <> nil then
    Async.Await;
end;

function TSystemMediaControlsSession.SupportedMediaAbilities: TMediaControlAbilities;
begin
  Result := [];
  if FInterface.GetPlaybackInfo.Controls.IsPlaybackPositionEnabled then
    Result := Result + [TMediaControlAbility.Position];
  if FInterface.GetPlaybackInfo.Controls.IsPlaybackRateEnabled then
    Result := Result + [TMediaControlAbility.PlaybackRate];
  if FInterface.GetPlaybackInfo.Controls.IsShuffleEnabled then
    Result := Result + [TMediaControlAbility.Shuffle];
  if FInterface.GetPlaybackInfo.Controls.IsRepeatEnabled then
    Result := Result + [TMediaControlAbility.AutoRepeat];
end;

function TSystemMediaControlsSession.SupportedMediaControls: TMediaControlActions;
begin
  Result := [];
  if FInterface.GetPlaybackInfo.Controls.IsPlayEnabled then
    Result := Result + [TMediaControlAction.Play];
  if FInterface.GetPlaybackInfo.Controls.IsPauseEnabled then
    Result := Result + [TMediaControlAction.Pause];
  if FInterface.GetPlaybackInfo.Controls.IsStopEnabled then
    Result := Result + [TMediaControlAction.Stop];
  if FInterface.GetPlaybackInfo.Controls.IsRecordEnabled then
    Result := Result + [TMediaControlAction.DoRecord];
  if FInterface.GetPlaybackInfo.Controls.IsFastForwardEnabled then
    Result := Result + [TMediaControlAction.FastForward];
  if FInterface.GetPlaybackInfo.Controls.IsRewindEnabled then
    Result := Result + [TMediaControlAction.Rewind];
  if FInterface.GetPlaybackInfo.Controls.IsNextEnabled then
    Result := Result + [TMediaControlAction.SkipNext];
  if FInterface.GetPlaybackInfo.Controls.IsPreviousEnabled then
    Result := Result + [TMediaControlAction.SkipPrevious];
  if FInterface.GetPlaybackInfo.Controls.IsChannelUpEnabled then
    Result := Result + [TMediaControlAction.ChannelUp];
  if FInterface.GetPlaybackInfo.Controls.IsChannelDownEnabled then
    Result := Result + [TMediaControlAction.ChannelDown];
end;

function TSystemMediaControlsSession.CallMediaControl(
  Control: TMediaControlAction): TAsyncBoolean;
begin
  Result := TAsyncBoolean.Create;
  case Control of
    TMediaControlAction.Play: FInterface.TryPlayAsync.Completed := Result;
    TMediaControlAction.Pause: FInterface.TryPauseAsync.Completed := Result;
    TMediaControlAction.Stop: FInterface.TryStopAsync.Completed := Result;
    TMediaControlAction.DoRecord: FInterface.TryRecordAsync.Completed := Result;
    TMediaControlAction.FastForward: FInterface.TryFastForwardAsync.Completed := Result;
    TMediaControlAction.Rewind: FInterface.TryRewindAsync.Completed := Result;
    TMediaControlAction.SkipNext: FInterface.TrySkipNextAsync.Completed := Result;
    TMediaControlAction.SkipPrevious: FInterface.TrySkipPreviousAsync.Completed := Result;
    TMediaControlAction.ChannelUp: FInterface.TryChangeChannelUpAsync.Completed := Result;
    TMediaControlAction.ChannelDown: FInterface.TryChangeChannelDownAsync.Completed := Result;

    else
      raise Exception.Create('Control not supported.');
  end;
end;

function TSystemMediaControlsSession.TryPause: TAsyncBoolean;
begin
  Result := CallMediaControl(TMediaControlAction.Pause);
end;

function TSystemMediaControlsSession.TryPlay: TAsyncBoolean;
begin
  Result := CallMediaControl(TMediaControlAction.Play);
end;

function TSystemMediaControlsSession.TryPlayPause: TAsyncBoolean;
begin
  Result := TAsyncBoolean.Create;
  FInterface.TryTogglePlayPauseAsync.Completed := Result;
end;

function TSystemMediaControlsSession.TryNext: TAsyncBoolean;
begin
  Result := CallMediaControl(TMediaControlAction.SkipNext);
end;

function TSystemMediaControlsSession.TryPrevious: TAsyncBoolean;
begin
  Result := CallMediaControl(TMediaControlAction.SkipPrevious);
end;

function TSystemMediaControlsSession.TrySetPlaybackPosition(
  Value: int64): TAsyncBoolean;
begin
  Result := TAsyncBoolean.Create;
  FInterface.TryChangePlaybackPositionAsync( TimeSpan.CreateMilliseconds(Value).Duration ).Completed := Result;
end;

function TSystemMediaControlsSession.TrySetPlaybackRate(
  Value: Double): TAsyncBoolean;
begin
  Result := TAsyncBoolean.Create;
  FInterface.TryChangePlaybackRateAsync(Value).Completed := Result;
end;

function TSystemMediaControlsSession.TrySetRepeatMode(
  Value: TMediaAutoRepeatMode): TAsyncBoolean;
begin
  Result := TAsyncBoolean.Create;
  FInterface.TryChangeAutoRepeatModeAsync(Value).Completed := Result;
end;

function TSystemMediaControlsSession.TrySetShuffle(
  Value: boolean): TAsyncBoolean;
begin
  Result := TAsyncBoolean.Create;
  FInterface.TryChangeShuffleActiveAsync(Value).Completed := Result;
end;

function TSystemMediaControlsSession.TryStop: TAsyncBoolean;
begin
  Result := CallMediaControl(TMediaControlAction.Stop);
end;

{ TGlobalSystemMediaControlsSessionManager }

constructor TGlobalSystemMediaControlsSessionManager.Create;
var
  Operation: IAsyncOperation_1__Control_IGlobalSystemMediaTransportControlsSessionManager;
begin
  // Create async event
  Operation := TControl_GlobalSystemMediaTransportControlsSessionManager.RequestAsync;
  TAsyncAwait.Await( Operation );

  // Wait for value
  FInterface := Operation.GetResults;

  // Clear operation
  Operation := nil;

  // Events
  FOnCurrentSessionChanged := TSystemMediaSessionManagerCurrentSessionChangedEvent.Create(Self);
  FOnSessionsChanged := TSystemMediaSessionManagerSessionsChangedEvent.Create(Self);
end;

destructor TGlobalSystemMediaControlsSessionManager.Destroy;
begin
  TSubscriptionEventHandlerBase.TryMultiUnsubscribe([
    FOnCurrentSessionChanged,
    FOnSessionsChanged
  ]);
  FOnCurrentSessionChanged := nil;
  FOnSessionsChanged := nil;

  // Clear main interface
  FInterface := nil;

  inherited;
end;

function TGlobalSystemMediaControlsSessionManager.GetActiveSession: TSystemMediaControlsSession;
begin
  Result := TSystemMediaControlsSession.Create( FInterface.GetCurrentSession );
end;

function TGlobalSystemMediaControlsSessionManager.GetActiveSessionIndex: integer;
begin
  Result := -1;

  const Active = FInterface.GetCurrentSession;
  for var I: int64 := 0 to int64(FInterface.GetSessions.Size)-1 do
    if FInterface.GetSessions.GetAt(I).SourceAppUserModelId.ToStringAndDestroy = Active.SourceAppUserModelId.ToStringAndDestroy then
      Exit(I);
end;

function TGlobalSystemMediaControlsSessionManager.GetIndexOf(
  Session: TSystemMediaControlsSession): Cardinal;
begin
  FInterface.GetSessions.IndexOf( Session.Interfaced, Result );
end;

function TGlobalSystemMediaControlsSessionManager.GetSession(
  Index: Cardinal): TSystemMediaControlsSession;
begin
  Result := TSystemMediaControlsSession.Create( FInterface.GetSessions.GetAt(Index) );
end;

function TGlobalSystemMediaControlsSessionManager.GetSessionCount: Cardinal;
begin
  Result := FInterface.GetSessions.Size;
end;

{ TMediaNotifyPlaybackInfoChangedEvent }

procedure TMediaNotifyPlaybackInfoChangedEvent.Invoke(
  sender: Control_IGlobalSystemMediaTransportControlsSession;
  args: Control_IPlaybackInfoChangedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent );
end;

procedure TMediaNotifyPlaybackInfoChangedEvent.Subscribe;
begin
  inherited;
  Token := Parent.FInterface.add_PlaybackInfoChanged( Self );
end;

procedure TMediaNotifyPlaybackInfoChangedEvent.Unsubscribe;
begin
  inherited;
  Parent.FInterface.remove_PlaybackInfoChanged( Token );
end;

{ TMediaTimelinePropertiesChangedEvent }

procedure TMediaTimelinePropertiesChangedEvent.Invoke(
  sender: Control_IGlobalSystemMediaTransportControlsSession;
  args: Control_ITimelinePropertiesChangedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent );
end;

procedure TMediaTimelinePropertiesChangedEvent.Subscribe;
begin
  inherited;
  Token := Parent.FInterface.add_TimelinePropertiesChanged( Self );
end;

procedure TMediaTimelinePropertiesChangedEvent.Unsubscribe;
begin
  inherited;
  Parent.FInterface.remove_TimelinePropertiesChanged( Token );
end;

{ TMediaPropertiesChangedEvent }

procedure TMediaPropertiesChangedEvent.Invoke(
  sender: Control_IGlobalSystemMediaTransportControlsSession;
  args: Control_IMediaPropertiesChangedEventArgs);
begin
  // Destroy parent MediaInfo, as It's now not up to date
  Parent.DestroyMediaInformation;

  // Update events
  for var I := 0 to Count-1 do
    Items[I]( Parent );
end;

procedure TMediaPropertiesChangedEvent.Subscribe;
begin
  inherited;
  Token := Parent.FInterface.add_MediaPropertiesChanged( Self );
end;

procedure TMediaPropertiesChangedEvent.Unsubscribe;
begin
  inherited;
  Parent.FInterface.remove_MediaPropertiesChanged( Token );
end;

{ TSystemMediaControlsMediaInformation }

constructor TSystemMediaControlsMediaInformation.Create(
  AInterface: Control_IGlobalSystemMediaTransportControlsSessionMediaProperties);
begin
  // Interface
  FInterface := AInterface;
end;

destructor TSystemMediaControlsMediaInformation.Destroy;
begin
  // Clear main interface
  FInterface := nil;

  inherited;
end;

function TSystemMediaControlsMediaInformation.GetAlbumArtist: string;
begin
  Result := GetAsString( FInterface.AlbumArtist );
end;

function TSystemMediaControlsMediaInformation.GetAlbumTitle: string;
begin
  Result := GetAsString( FInterface.AlbumTitle );
end;

function TSystemMediaControlsMediaInformation.GetAlbumTrackCount: integer;
begin
  Result := FInterface.AlbumTrackCount;
end;

function TSystemMediaControlsMediaInformation.GetArtist: string;
begin
  Result := GetAsString( FInterface.Artist );
end;

function TSystemMediaControlsMediaInformation.GetAsString(
  HStr: HSTRING): string;
begin
  try
    Result := HStr.ToString;
  finally
    HStr.Free;
  end;
end;

function TSystemMediaControlsMediaInformation.GetGenres: TArray<string>;
begin
  const GList = FInterface.Genres;
  SetLength( Result, GList.Size );

  for var I := 0 to High(Result) do
    Result[I] := GetAsString( GList.GetAt(I) );
end;

function TSystemMediaControlsMediaInformation.GetMediaPlaybackType: TMediaPlaybackType;
begin
  Result := FInterface.PlaybackType.Value;
end;

function TSystemMediaControlsMediaInformation.GetSubtitle: string;
begin
  Result := GetAsString( FInterface.Subtitle );
end;

function TSystemMediaControlsMediaInformation.GetThumbnail: TGraphic;
var
  RandomAccessStreamWithContentType: IRandomAccessStreamWithContentType;
begin
  if not HasThumbnail then
    Exit(nil);

  // Get data async
  const Operation = FInterface.Thumbnail.OpenReadAsync;
  TAsyncAwait.Await( Operation );
  RandomAccessStreamWithContentType := Operation.GetResults;

  // Read to bytes
  const Bytes = RandomAccessStreamGetContents( TInstanceFactory.Query<IRandomAccessStream>(RandomAccessStreamWithContentType, IRandomAccessStream) );

  // Result
  const S = TMemoryStream.Create;
  try
    S.Write(Bytes, Length(Bytes));
    Result := LoadGraphicFromStream(S);
  finally
    S.Free;
  end;
end;

function TSystemMediaControlsMediaInformation.GetTitle: string;
begin
  Result := GetAsString( FInterface.Title );
end;

function TSystemMediaControlsMediaInformation.GetTrackNumber: integer;
begin
  Result := FInterface.TrackNumber;
end;

function TSystemMediaControlsMediaInformation.HasThumbnail: boolean;
begin
  Result := FInterface.Thumbnail <> nil;
end;

{ TSystemMediaSessionManagerCurrentSessionChangedEvent }

procedure TSystemMediaSessionManagerCurrentSessionChangedEvent.Invoke(
  sender: Control_IGlobalSystemMediaTransportControlsSessionManager;
  args: Control_ICurrentSessionChangedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent );
end;

procedure TSystemMediaSessionManagerCurrentSessionChangedEvent.Subscribe;
begin
  inherited;
  Token := Parent.FInterface.add_CurrentSessionChanged( Self );
end;

procedure TSystemMediaSessionManagerCurrentSessionChangedEvent.Unsubscribe;
begin
  inherited;
  Parent.FInterface.remove_CurrentSessionChanged( Token );
end;

{ TSystemMediaSessionManagerSessionsChangedEvent }

procedure TSystemMediaSessionManagerSessionsChangedEvent.Invoke(
  sender: Control_IGlobalSystemMediaTransportControlsSessionManager;
  args: Control_ISessionsChangedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent );
end;

procedure TSystemMediaSessionManagerSessionsChangedEvent.Subscribe;
begin
  inherited;
  Token := Parent.FInterface.add_SessionsChanged( Self );
end;

procedure TSystemMediaSessionManagerSessionsChangedEvent.Unsubscribe;
begin
  inherited;
  Parent.FInterface.remove_SessionsChanged( Token );
end;

{ TPlaybackMediaPlayer }

constructor TPlaybackMediaPlayer.Create(AAppMediaID: string);
begin
  inherited Create;

  // Interface
  FInterface := TPlayback_MediaPlayer.Create;

  // Editors
  FInformationMusic := TAudioPlaybackMediaPlayerEditor.Create(Self);
  FInformationVideo := TVideoPlaybackMediaPlayerEditor.Create(Self);
  FInformationImage := TImagePlaybackMediaPlayerEditor.Create(Self);

  // Required!
  FInterface.QueryInterface(Playback_IMediaPlayer2, FInterface2);

  // Other interfaces
  if Supports(FInterface, Playback_IMediaPlayer3) then
    FInterface.QueryInterface(Playback_IMediaPlayer3, FInterface3);
  if Supports(FInterface, Playback_IMediaPlayer4) then
    FInterface.QueryInterface(Playback_IMediaPlayer4, FInterface4);
  if Supports(FInterface, Playback_IMediaPlayer5) then
    FInterface.QueryInterface(Playback_IMediaPlayer5, FInterface5);
  if Supports(FInterface, Playback_IMediaPlayer6) then
    FInterface.QueryInterface(Playback_IMediaPlayer6, FInterface6);
  if Supports(FInterface, Playback_IMediaPlayer7) then
    FInterface.QueryInterface(Playback_IMediaPlayer7, FInterface7);

  // Get transport
  FTransport := FInterface2.SystemMediaTransportControls;
  if Supports(FTransport, ISystemMediaTransportControls2) then
    FTransport.QueryInterface(ISystemMediaTransportControls2, FTransport2);

  // Set preparation
  FTransport.IsEnabled := false;

  // Get info updater
  FUpdater := FTransport.DisplayUpdater;

  // Set ID
  AppMediaID := AAppMediaID;
end;

destructor TPlaybackMediaPlayer.Destroy;
begin
  inherited;
end;

function TPlaybackMediaPlayer.GetIsLooping: boolean;
begin
  Result := FInterface.IsLoopingEnabled;
end;

function TPlaybackMediaPlayer.GetIsMuted: boolean;
begin
  Result := FInterface.IsMuted;
end;

function TPlaybackMediaPlayer.GetPlaybackRate: double;
begin
  Result := FInterface.PlaybackRate;
end;

function TPlaybackMediaPlayer.GetPosition: int64;
begin
  Result := FInterface.Position.Duration;
end;

function TPlaybackMediaPlayer.GetTransportControls: ISystemMediaTransportControls;
begin
  Result := FTransport;
end;

function TPlaybackMediaPlayer.GetTransportControls2: ISystemMediaTransportControls2;
begin
  Result := FTransport2;
end;

function TPlaybackMediaPlayer.GetUpdater: ISystemMediaTransportControlsDisplayUpdater;
begin
  Result := FUpdater;
end;

function TPlaybackMediaPlayer.GetVolume: double;
begin
  Result := FInterface.Volume;
end;


procedure TPlaybackMediaPlayer.SetIsLooping(const Value: boolean);
begin
  FInterface.IsLoopingEnabled := Value;
end;

procedure TPlaybackMediaPlayer.SetIsMuted(const Value: boolean);
begin
  FInterface.IsMuted := Value;
end;

procedure TPlaybackMediaPlayer.SetPlaybackRate(const Value: double);
begin
  FInterface.PlaybackRate := Value;
end;

procedure TPlaybackMediaPlayer.SetPosition(const Value: int64);
begin
  FInterface.Position := TimeSpan.CreateMilliseconds(Value);
end;

procedure TPlaybackMediaPlayer.SetVolume(const Value: double);
begin
  FInterface.Volume := Value;
end;

{ TBasePlaybackMediaPlayerEditor }

procedure TBasePlaybackMediaPlayerEditor.TestAccess;
begin
  if FParent.MediaPlaybackType <> RequiredType then
    raise Exception.Create('The player playback type does not match the editor type.');
end;

constructor TBasePlaybackMediaPlayerEditor.Create(
  AParent: TTransportCompatibleClass);
begin
  inherited Create;

  FParent := AParent;

  Initialize;
end;

destructor TBasePlaybackMediaPlayerEditor.Destroy;
begin
  FParent := nil;
  inherited;
end;

procedure TBasePlaybackMediaPlayerEditor.Initialize;
begin
  RequiredType := TMediaPlaybackType.Unknown;
end;

{ TAudioPlaybackMediaPlayerEditor }

function TAudioPlaybackMediaPlayerEditor.GetAlbumArtist: string;
begin
  Result := FParent.Updater.MusicProperties.AlbumArtist.ToStringAndDestroy;
end;

function TAudioPlaybackMediaPlayerEditor.GetArtist: string;
begin
  Result := FParent.Updater.MusicProperties.Artist.ToStringAndDestroy;
end;

function TAudioPlaybackMediaPlayerEditor.GetTitle: string;
begin
  Result := FParent.Updater.MusicProperties.Title.ToStringAndDestroy;
end;

procedure TAudioPlaybackMediaPlayerEditor.Initialize;
begin
  inherited;
  RequiredType := TMediaPlaybackType.Music;
end;

procedure TAudioPlaybackMediaPlayerEditor.SetAlbumArtist(const Value: string);
begin
  FParent.Updater.MusicProperties.AlbumArtist := HString.Create(Value);
end;

procedure TAudioPlaybackMediaPlayerEditor.SetArtist(const Value: string);
begin
  FParent.Updater.MusicProperties.Artist := HString.Create(Value);
end;

procedure TAudioPlaybackMediaPlayerEditor.SetTitle(const Value: string);
begin
  FParent.Updater.MusicProperties.Title := HString.Create(Value);
end;

{ TVideoPlaybackMediaPlayerEditor }

function TVideoPlaybackMediaPlayerEditor.GetSubtitle: string;
begin
  Result := FParent.Updater.VideoProperties.Subtitle.ToStringAndDestroy;
end;

function TVideoPlaybackMediaPlayerEditor.GetTitle: string;
begin
  Result := FParent.Updater.VideoProperties.Title.ToStringAndDestroy;
end;

procedure TVideoPlaybackMediaPlayerEditor.Initialize;
begin
  inherited;
  RequiredType := TMediaPlaybackType.Video;
end;

procedure TVideoPlaybackMediaPlayerEditor.SetSubtitle(const Value: string);
begin
  FParent.Updater.VideoProperties.Subtitle := HString.Create(Value);
end;

procedure TVideoPlaybackMediaPlayerEditor.SetTitle(const Value: string);
begin
  FParent.Updater.VideoProperties.Title := HString.Create(Value);
end;

{ TImagePlaybackMediaPlayerEditor }

function TImagePlaybackMediaPlayerEditor.GetSubtitle: string;
begin
  Result := FParent.Updater.ImageProperties.Subtitle.ToStringAndDestroy;
end;

function TImagePlaybackMediaPlayerEditor.GetTitle: string;
begin
  Result := FParent.Updater.ImageProperties.Title.ToStringAndDestroy;
end;

procedure TImagePlaybackMediaPlayerEditor.Initialize;
begin
  inherited;
  RequiredType := TMediaPlaybackType.Image;
end;

procedure TImagePlaybackMediaPlayerEditor.SetSubtitle(const Value: string);
begin
  FParent.Updater.ImageProperties.Subtitle := HString.Create(Value);
end;

procedure TImagePlaybackMediaPlayerEditor.SetTitle(const Value: string);
begin
  FParent.Updater.ImageProperties.Title := HString.Create(Value);
end;

{ TPlaybackMediaPlayerButtonPressedEvent }

procedure TPlaybackMediaPlayerButtonPressedEvent.Invoke(
  sender: ISystemMediaTransportControls;
  args: ISystemMediaTransportControlsButtonPressedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent, args.Button );
end;

procedure TPlaybackMediaPlayerButtonPressedEvent.Subscribe;
begin
  inherited;
  Token := Parent.TransportControls.add_ButtonPressed( Self );
end;

procedure TPlaybackMediaPlayerButtonPressedEvent.Unsubscribe;
begin
  inherited;
  Parent.TransportControls.remove_ButtonPressed( Token );
end;

{ TPlaybackMediaPlayerPropertyChangedEvent }

procedure TPlaybackMediaPlayerPropertyChangedEvent.Invoke(
  sender: ISystemMediaTransportControls;
  args: ISystemMediaTransportControlsPropertyChangedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent, args.&Property );
end;

procedure TPlaybackMediaPlayerPropertyChangedEvent.Subscribe;
begin
  Token := Parent.TransportControls.add_PropertyChanged( Self );
end;

procedure TPlaybackMediaPlayerPropertyChangedEvent.Unsubscribe;
begin
  inherited;
  Parent.TransportControls.remove_ButtonPressed( Token );
end;

{ TWindowMediaTransportControls }

function WindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := DefWindowProc(hWnd, Msg, wParam, lParam);
end;

constructor TWindowMediaTransportControls.Create(WindowClassName: string);
var
  wnd: WNDCLASS;
begin
  inherited Create;

  // Registration
  if not AppRegistration.RegisteredAny then
    OutputDebugString('WARNING: The application model ID is not registered. Player info will be incorrect.');
    {raise Exception.Create(RSWinRTExceptionRegistrationNotDone);}

  // Create class
  FWindowClassName := PChar(WindowClassName);

  wnd.style := 0;
  wnd.lpfnWndProc := @WindowProc; // Provide a valid window procedure
  wnd.cbClsExtra := 0;
  wnd.cbWndExtra := 0;
  wnd.hInstance := HInstance;     // Use the correct instance handle
  wnd.hIcon := 0;
  wnd.hCursor := LoadCursor(0, IDC_ARROW);
  wnd.hbrBackground := GetStockObject(WHITE_BRUSH);
  wnd.lpszMenuName := nil;
  wnd.lpszClassName := FWindowClassName;

  if winapi.Windows.RegisterClass(wnd) = 0 then
    RaiseLastOSError;

  FWindowHWND := CreateWindowExW(0, FWindowClassName, FWindowClassName, 0,
    CW_USEDEFAULT, CW_USEDEFAULT, 0, 0, 0,
    0, HInstance, nil);

  // Interface
  FInterop := TSystemMediaTransportControlsInterop.Factory;
  if Failed(
    FInterop.GetForWindow(FWindowHWND, TInstanceFactory.GetGUID<ISystemMediaTransportControls>, FInterface)
    ) then
      raise Exception.Create('Could not initiate Media Transport Controls');

  if Supports(FInterface, ISystemMediaTransportControls2) then
    FInterface.QueryInterface(ISystemMediaTransportControls2, FInterface2);

  // Set preparation
  FInterface.IsEnabled := false;
  FInterface2.ShuffleEnabled := false;
  FInterface2.AutoRepeatMode := TMediaPlaybackAutoRepeatMode.None;
  FInterface2.PlaybackRate := 1;

  // Get info updater
  FUpdater := FInterface.DisplayUpdater;
end;

constructor TWindowMediaTransportControls.Create;
begin
  Create( AppRegistration.AppUserModelID+'media-window-class' );
end;

destructor TWindowMediaTransportControls.Destroy;
begin
  if not DestroyWindow(FWindowHWND) then
    RaiseLastOSError;

  inherited;

  FInterface := nil;
  FInterface2 := nil;
  FUpdater := nil;
end;

function TWindowMediaTransportControls.GetTransportControls: ISystemMediaTransportControls;
begin
  Result := FInterface;
end;

function TWindowMediaTransportControls.GetTransportControls2: ISystemMediaTransportControls2;
begin
  Result := FInterface2;
end;

function TWindowMediaTransportControls.GetUpdater: ISystemMediaTransportControlsDisplayUpdater;
begin
  Result := FUpdater;
end;

{ TTransportCompatibleClass }

procedure TTransportCompatibleClass.ClearAllInformation;
begin
  Updater.ClearAll;
end;

constructor TTransportCompatibleClass.Create;
begin
  // Editors
  FInformationMusic := TAudioPlaybackMediaPlayerEditor.Create(Self);
  FInformationVideo := TVideoPlaybackMediaPlayerEditor.Create(Self);
  FInformationImage := TImagePlaybackMediaPlayerEditor.Create(Self);

  // Properties
  FTimeline := TControlsTimelineProperties.Create;

  // Events
  FOnButtonPressed := TPlaybackMediaPlayerButtonPressedEvent.Create(Self);
  FOnPropertyChanged := TPlaybackMediaPlayerPropertyChangedEvent.Create(Self);
  FOnPlaybackPositionChangeRequested := TMediaTransportControlsPlaybackPositionChangeRequestedEvent.Create(Self);
  FOnPlaybackRateChangeRequested := TMediaTransportControlsPlaybackRateChangeRequestedEvent.Create(Self);
  FOnShuffleEnabledChangeRequested := TMediaTransportControlsShuffleEnabledChangeRequestedEvent.Create(Self);
  FOnRepeatModeChangeRequested := TMediaTransportControlsRepeatModeChangeRequestedEvent.Create(Self);
end;

destructor TTransportCompatibleClass.Destroy;
begin
  // Unregister events
  TSubscriptionEventHandlerBase.TryMultiUnsubscribe([
    FOnButtonPressed,
    FOnPropertyChanged,
    FOnPlaybackPositionChangeRequested,
    FOnPlaybackRateChangeRequested,
    FOnShuffleEnabledChangeRequested,
    FOnRepeatModeChangeRequested
  ]);
  FOnButtonPressed := nil;
  FOnPropertyChanged := nil;
  FOnPlaybackPositionChangeRequested := nil;
  FOnPlaybackRateChangeRequested := nil;
  FOnShuffleEnabledChangeRequested := nil;
  FOnRepeatModeChangeRequested := nil;

  // Free editors
  FInformationMusic.Free;
  FInformationVideo.Free;
  FInformationImage.Free;

  inherited;
end;

function TTransportCompatibleClass.GetAppMediaID: string;
begin
  Updater.AppMediaId.ToStringAndDestroy;
end;

function TTransportCompatibleClass.GetAutoRepeatMode: TMediaPlaybackAutoRepeatMode;
begin
  Result := TransportControls2.AutoRepeatMode;
end;

function TTransportCompatibleClass.GetEnablePlayer: boolean;
begin
  Result := TransportControls.IsEnabled;
end;

function TTransportCompatibleClass.GetMediaPlaybackType: TMediaPlaybackType;
begin
  Result := Updater.&Type;
end;

function TTransportCompatibleClass.GetPlaybackRate: double;
begin
  Result := TransportControls2.PlaybackRate;
end;

function TTransportCompatibleClass.GetPlaybackStatus: TMediaPlaybackStatus;
begin
  Result := TransportControls.PlaybackStatus;
end;

function TTransportCompatibleClass.GetShuffleEnabled: boolean;
begin
  Result := TransportControls2.ShuffleEnabled;
end;

function TTransportCompatibleClass.GetSupportedMediaControls: TMediaControlActions;
begin
  Result := [];
  if TransportControls.IsPlayEnabled then
    Result := Result + [TMediaControlAction.Play];
  if TransportControls.IsPauseEnabled then
    Result := Result + [TMediaControlAction.Pause];
  if TransportControls.IsStopEnabled then
    Result := Result + [TMediaControlAction.Stop];
  if TransportControls.IsRecordEnabled then
    Result := Result + [TMediaControlAction.DoRecord];
  if TransportControls.IsFastForwardEnabled then
    Result := Result + [TMediaControlAction.FastForward];
  if TransportControls.IsRewindEnabled then
    Result := Result + [TMediaControlAction.Rewind];
  if TransportControls.IsNextEnabled then
    Result := Result + [TMediaControlAction.SkipNext];
  if TransportControls.IsPreviousEnabled then
    Result := Result + [TMediaControlAction.SkipPrevious];
  if TransportControls.IsChannelUpEnabled then
    Result := Result + [TMediaControlAction.ChannelUp];
  if TransportControls.IsChannelDownEnabled then
    Result := Result + [TMediaControlAction.ChannelDown];
end;

function TTransportCompatibleClass.GetThumbnail: TGraphic;
var
  RandomAccessStreamWithContentType: IRandomAccessStreamWithContentType;
begin
  if Updater.Thumbnail = nil then
    Exit(nil);

  // Get data async
  const Operation = Updater.Thumbnail.OpenReadAsync;
  TAsyncAwait.Await( Operation );
  RandomAccessStreamWithContentType := Operation.GetResults;

  // Read to bytes
  const Bytes = RandomAccessStreamGetContents( TInstanceFactory.Query<IRandomAccessStream>(RandomAccessStreamWithContentType, IRandomAccessStream) );

  // Result
  const S = TMemoryStream.Create;
  try
    S.Write(Bytes, Length(Bytes));
    Result := LoadGraphicFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TTransportCompatibleClass.PushTimeline;
begin
  GetTransportControls2.UpdateTimelineProperties( FTimeline.Interfaced );
end;

procedure TTransportCompatibleClass.SetAppMediaID(const Value: string);
begin
  Updater.AppMediaId := HString.Create(Value);
end;

procedure TTransportCompatibleClass.SetAutoRepeatMode(
  const Value: TMediaPlaybackAutoRepeatMode);
begin
  TransportControls2.AutoRepeatMode := Value;
end;

procedure TTransportCompatibleClass.SetEditorInformation(Title,
  Subtitle: string; Update: boolean);
begin
  case MediaPlaybackType of
    TMediaPlaybackType.Music: begin
      InfoMusic.Title := Title;
      InfoMusic.Artist := '';
      InfoMusic.AlbumArtist := Subtitle;
    end;
    TMediaPlaybackType.Video: begin
      InfoVideo.Title := Title;
      InfoVideo.Subtitle := Subtitle;
    end;
    TMediaPlaybackType.Image: begin
      InfoImage.Title := Title;
      InfoImage.Subtitle := Subtitle;
    end;
  end;

  // Update
  if Update then
    UpdateInformation;
end;

procedure TTransportCompatibleClass.SetEnablePlayer(const Value: boolean);
begin
  TransportControls.IsEnabled := Value;
end;

procedure TTransportCompatibleClass.SetMediaPlaybackType(
  const Value: TMediaPlaybackType);
begin
  Updater.&Type := Value;
end;

procedure TTransportCompatibleClass.SetPlaybackRate(const Value: double);
begin
  TransportControls2.PlaybackRate := Value;
end;

procedure TTransportCompatibleClass.SetPlaybackStatus(
  const Value: TMediaPlaybackStatus);
begin
  TransportControls.PlaybackStatus := Value;
end;

procedure TTransportCompatibleClass.SetShuffleEnabled(const Value: boolean);
begin
  TransportControls2.ShuffleEnabled := Value;
end;

procedure TTransportCompatibleClass.SetSupportedMediaControls(
  const Value: TMediaControlActions);
begin
  TransportControls.IsPlayEnabled := TMediaControlAction.Play in Value;
  TransportControls.IsPauseEnabled := TMediaControlAction.Pause in Value;
  TransportControls.IsStopEnabled := TMediaControlAction.Stop in Value;
  TransportControls.IsRecordEnabled := TMediaControlAction.DoRecord in Value;
  TransportControls.IsFastForwardEnabled := TMediaControlAction.FastForward in Value;
  TransportControls.IsRewindEnabled := TMediaControlAction.Rewind in Value;
  TransportControls.IsNextEnabled := TMediaControlAction.SkipNext in Value;
  TransportControls.IsPreviousEnabled := TMediaControlAction.SkipPrevious in Value;
  TransportControls.IsChannelUpEnabled := TMediaControlAction.ChannelUp in Value;
  TransportControls.IsChannelDownEnabled := TMediaControlAction.ChannelDown in Value;
end;

procedure TTransportCompatibleClass.SetThumbnail(const Value: TGraphic);
var
  RandomAccessStream: IRandomAccessStream;
begin
  const S = TMemoryStream.Create;
  var Bytes: TBytes;
  try
    Value.SaveToStream(S);

    SetLength(Bytes, S.Size);

    S.Position := 0;
    S.ReadData(@Bytes[0], S.Size);
  finally
    S.Free;
  end;

  RandomAccessStream := RandomAccessStreamMakeWithData(Bytes);

  // Set thumbnail
  Updater.Thumbnail := TRandomAccessStreamReference.CreateFromStream(RandomAccessStream);
end;

procedure TTransportCompatibleClass.UpdateInformation;
begin
  Updater.Update;
end;

{ TControlsTimelineProperties }

constructor TControlsTimelineProperties.Create;
begin
  FInterface := TSystemMediaTransportControlsTimelineProperties.Create;
end;

destructor TControlsTimelineProperties.Destroy;
begin
  FInterface := nil;
  inherited;
end;

function TControlsTimelineProperties.GetEndTime: int64;
begin
  Result := FInterface.EndTime.ToMilliseconds;
end;

function TControlsTimelineProperties.GetMaxSeekTime: int64;
begin
  Result := FInterface.MaxSeekTime.ToMilliseconds;
end;

function TControlsTimelineProperties.GetMinSeekTime: int64;
begin
  Result := FInterface.MinSeekTime.ToMilliseconds;
end;

function TControlsTimelineProperties.GetPosition: int64;
begin
  Result := FInterface.Position.ToMilliseconds;
end;

function TControlsTimelineProperties.GetStartTime: int64;
begin
  Result := FInterface.StartTime.ToMilliseconds;
end;

procedure TControlsTimelineProperties.SetEndTime(const Value: int64);
begin
  FInterface.EndTime := TimeSpan.CreateMilliseconds(Value);
end;

procedure TControlsTimelineProperties.SetMaxSeekTime(const Value: int64);
begin
  FInterface.MaxSeekTime := TimeSpan.CreateMilliseconds(Value);
end;

procedure TControlsTimelineProperties.SetMinSeekTime(const Value: int64);
begin
  FInterface.MinSeekTime := TimeSpan.CreateMilliseconds(Value);
end;

procedure TControlsTimelineProperties.SetPosition(const Value: int64);
begin
  FInterface.Position := TimeSpan.CreateMilliseconds(Value);
end;

procedure TControlsTimelineProperties.SetStartTime(const Value: int64);
begin
  FInterface.StartTime := TimeSpan.CreateMilliseconds(Value);
end;

{ TMediaTransportControlsPlaybackPositionChangeRequestedEvent }

procedure TMediaTransportControlsPlaybackPositionChangeRequestedEvent.Invoke(
  sender: ISystemMediaTransportControls;
  args: IPlaybackPositionChangeRequestedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent, args.RequestedPlaybackPosition.ToMilliseconds );
end;

procedure TMediaTransportControlsPlaybackPositionChangeRequestedEvent.Subscribe;
begin
  inherited;
  Token := Parent.TransportControls2.add_PlaybackPositionChangeRequested( Self );
end;

procedure TMediaTransportControlsPlaybackPositionChangeRequestedEvent.Unsubscribe;
begin
  inherited;
  Parent.TransportControls2.remove_PlaybackPositionChangeRequested( Token );
end;

{ TMediaTransportControlsPlaybackRateChangeRequestedEvent }

procedure TMediaTransportControlsPlaybackRateChangeRequestedEvent.Invoke(
  sender: ISystemMediaTransportControls;
  args: IPlaybackRateChangeRequestedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent, args.RequestedPlaybackRate );
end;

procedure TMediaTransportControlsPlaybackRateChangeRequestedEvent.Subscribe;
begin
  inherited;
  Token := Parent.TransportControls2.add_PlaybackRateChangeRequested( Self );
end;

procedure TMediaTransportControlsPlaybackRateChangeRequestedEvent.Unsubscribe;
begin
  inherited;
  Parent.TransportControls2.remove_PlaybackRateChangeRequested( Token );
end;

{ TMediaTransportControlsShuffleEnabledChangeRequestedEvent }

procedure TMediaTransportControlsShuffleEnabledChangeRequestedEvent.Invoke(
  sender: ISystemMediaTransportControls;
  args: IShuffleEnabledChangeRequestedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent, args.RequestedShuffleEnabled );
end;

procedure TMediaTransportControlsShuffleEnabledChangeRequestedEvent.Subscribe;
begin
  inherited;
  Token := Parent.TransportControls2.add_ShuffleEnabledChangeRequested( Self );
end;

procedure TMediaTransportControlsShuffleEnabledChangeRequestedEvent.Unsubscribe;
begin
  inherited;
  Parent.TransportControls2.remove_ShuffleEnabledChangeRequested( Token );
end;

{ TMediaTransportControlsRepeatModeChangeRequestedEvent }

procedure TMediaTransportControlsRepeatModeChangeRequestedEvent.Invoke(
  sender: ISystemMediaTransportControls;
  args: IAutoRepeatModeChangeRequestedEventArgs);
begin
  for var I := 0 to Count-1 do
    Items[I]( Parent, args.RequestedAutoRepeatMode );
end;

procedure TMediaTransportControlsRepeatModeChangeRequestedEvent.Subscribe;
begin
  inherited;
  Token := Parent.TransportControls2.add_AutoRepeatModeChangeRequested( Self );
end;

procedure TMediaTransportControlsRepeatModeChangeRequestedEvent.Unsubscribe;
begin
  inherited;
  Parent.TransportControls2.remove_AutoRepeatModeChangeRequested( Token );
end;

end.
