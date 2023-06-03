unit MainUI;

{$SCOPEDENUMS ON}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  BroadcastAPI, Cod.SysUtils, Cod.Files, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.TitleBarCtrls, Vcl.StdActns, Vcl.ExtActns,
  Vcl.ActnList, System.Actions, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Cod.Visual.Button, Cod.Visual.Image, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, DebugForm, Cod.Visual.Slider,
  Cod.ColorUtils, Cod.Graphics, Cod.VarHelpers, Cod.Types,
  Cod.Visual.StandardIcons, Imaging.jpeg, Threading, Cod.Dialogs,
  Vcl.Imaging.GIFImg, Cod.Visual.Panels, IOUtils, Cod.Internet,
  Cod.Audio, UITypes, Types, Math, Performance,
  Cod.Math, System.IniFiles, System.Generics.Collections, Web.HTTPApp,
  Bass, System.Win.TaskbarCore, Vcl.Taskbar, Cod.Visual.CheckBox,
  Vcl.ControlList, Cod.StringUtils, Vcl.OleCtrls, SHDocVw, Vcl.Menus;

type
  // Cardinals
  TViewStyle = (List, Cover);
  TRepeat = (Off, All, One);
  TSortType = (Default, Alphabetic, Year, Rating, Flipped);
  TSortTypes = set of TSortType;
  TSearchFlag = (ExactMatch, CaseSensitive, SearchInfo);
  TSearchFlags = set of TSearchFlag;

  // View Save
  TViewSave = record
    PageRoot: string;
    View: TViewStyle;
  end;

  // History System
  THistorySet = record
    Location: string;
    ScrollPrev: integer;
  end;

  // Draw Item
  TDrawableItem = record
    Index: integer;

    ItemID: integer;

    Title: string;
    InfoShort: string;
    InfoLong: string;

    Active: boolean;
    HiddenItem: boolean;
    HiddenSearch: boolean;

    Information: TArray<string>;

    Bounds: TRect;
    Source: TDataSource;

    (* Other data *)
    OnlyQueue: boolean;

    (* Mix data *)
    function Hidden: boolean;
    function Downloaded: boolean;

    function ToggleDownloaded: boolean;

    (* Data Information *)
    function GetPremadeInfoList: string;
    function GetPicture: TJPEGImage;

    (* When Clicked *)
    procedure Execute;
    procedure OpenInformation;

    (* Audo Load *)
    procedure LoadSourceID(ID: integer; From: TDataSource);
    procedure LoadSource(AIndex: integer; From: TDataSource);

    (* Load Thread *)
    procedure StartPictureLoad;
  end;

  // Form
  TUIForm = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    PrimaryUIContainer: TPanel;
    SplitView1: TSplitView;
    CButton2: CButton;
    CButton3: CButton;
    CButton4: CButton;
    CButton5: CButton;
    CButton6: CButton;
    CButton7: CButton;
    TitlebarCompare: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PagesHolder: TPanel;
    Song_Player: TPanel;
    Panel6: TPanel;
    Song_Cover: CImage;
    Panel7: TPanel;
    Player_Information: TPanel;
    Song_Name: TLabel;
    Song_Artist: TLabel;
    Player_Controls: TPanel;
    Button_Next: CButton;
    Button_Prev: CButton;
    Button_Play: CButton;
    Button_Previous: CButton;
    GeneralDraw: TPanel;
    DrawItem: TPaintBox;
    ScrollPosition: TScrollBar;
    Page_Home: TPanel;
    Page_Account: TPanel;
    ScrollBox2: TScrollBox;
    Label8: TLabel;
    Complete_Email: TLabel;
    Complete_User: TLabel;
    CStandardIcon1: CStandardIcon;
    Complete_Verify: TLabel;
    Label9: TLabel;
    Complete_Premium: TLabel;
    CButton11: CButton;
    CButton12: CButton;
    LoginUIContainer: TPanel;
    CImage3: CImage;
    Label10: TLabel;
    Status_Work: TLabel;
    BoxContainer: TPanel;
    Robo_Panel: CPanel;
    CImage4: CImage;
    Robo_Background: TShape;
    CImage5: CImage;
    CImage6: CImage;
    LoginFailed: TPanel;
    Shape2: TShape;
    Label15: TLabel;
    Error_Login: TLabel;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    HideLoginPopup: TTimer;
    Track_Time: TTimer;
    PressNow: TTimer;
    ViewModeToggle: TPanel;
    SelectView_List: CButton;
    SelectView_Grid: CButton;
    Button_Shuffle: CButton;
    Button_Repeat: CButton;
    CButton9: CButton;
    Page_ViewAlbum: TPanel;
    DrawItem_Clone1: TPaintBox;
    Scrollbar_1: TScrollBar;
    Panel1: TPanel;
    CImage2: CImage;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    SortModeToggle: TPanel;
    Sort_Default: CButton;
    Sort_Alphabetic: CButton;
    Sort_Date: CButton;
    Sort_Rating: CButton;
    Page_ViewArtist: TPanel;
    DrawItem_Clone2: TPaintBox;
    Scrollbar_2: TScrollBar;
    Page_ViewPlaylist: TPanel;
    DrawItem_Clone3: TPaintBox;
    Scrollbar_3: TScrollBar;
    WebSync: TTimer;
    Button_Extend: CButton;
    Queue_Extend: TPanel;
    QueuePopupAnimate: TTimer;
    Panel5: TPanel;
    Player_Position: CSlider;
    Time_Pass: TLabel;
    QueueDraw: TPaintBox;
    QueueScroll: TScrollBar;
    QueueSwitchAnimation: TTimer;
    QueueDownGo: TTimer;
    Label3: TLabel;
    Panel15: TPanel;
    Panel10: TPanel;
    Label6: TLabel;
    Panel11: TPanel;
    CImage10: CImage;
    Panel16: TPanel;
    Label7: TLabel;
    Label19: TLabel;
    Panel12: TPanel;
    Label20: TLabel;
    Panel13: TPanel;
    CImage11: CImage;
    Panel17: TPanel;
    Label21: TLabel;
    Label22: TLabel;
    Taskbar1: TTaskbar;
    ActionList1: TActionList;
    Action_Play: TAction;
    Action_Next: TAction;
    Action_Previous: TAction;
    CButton10: CButton;
    Page_Settings: TPanel;
    ScrollBox3: TScrollBox;
    Label24: TLabel;
    Version_Label: TLabel;
    CButton15: CButton;
    Label28: TLabel;
    Label25: TLabel;
    Setting_Graph: CCheckBox;
    CImage12: CImage;
    CImage13: CImage;
    Label26: TLabel;
    Label27: TLabel;
    CButton8: CButton;
    CButton14: CButton;
    CButton16: CButton;
    MoreButtons: TPanel;
    Button_Performance: CButton;
    Button_MiniPlayer: CButton;
    Button_Volume: CButton;
    CButton17: CButton;
    Page_Search: TPanel;
    SearchToggle: TPanel;
    Search_Button: CButton;
    SearchBox_Hold: TPanel;
    Quick_Search: TEdit;
    Label30: TLabel;
    Panel19: TPanel;
    SearchBox1: TSearchBox;
    SearchDraw: TPaintBox;
    ScrollBar_4: TScrollBar;
    Label33: TLabel;
    CButton1: CButton;
    CButton18: CButton;
    LoginItems: TControlList;
    Label34: TLabel;
    Label35: TLabel;
    ICON_CONNECT: TLabel;
    Search_Filters: TPanel;
    Label31: TLabel;
    CCheckBox2: CCheckBox;
    CCheckBox3: CCheckBox;
    CCheckBox1: CCheckBox;
    CButton19: CButton;
    Settings_CheckUpdate: CCheckBox;
    CButton20: CButton;
    Search_Types: TPanel;
    Label36: TLabel;
    SType_Album: CButton;
    SType_Song: CButton;
    SType_Artist: CButton;
    SType_Playlist: CButton;
    Label32: TLabel;
    ImgSelector_2: CButton;
    ImgSelector_1: CButton;
    ImgSelector_3: CButton;
    ImgSelector_4: CButton;
    ImgSelector_5: CButton;
    Label14: TLabel;
    Label40: TLabel;
    Panel8: TPanel;
    Shape7: TShape;
    Panel9: TPanel;
    Panel18: TPanel;
    Label43: TLabel;
    Label44: TLabel;
    Panel20: TPanel;
    Label41: TLabel;
    Label42: TLabel;
    Panel21: TPanel;
    Label45: TLabel;
    Label46: TLabel;
    Panel22: TPanel;
    Label47: TLabel;
    Label48: TLabel;
    Panel23: TPanel;
    Label49: TLabel;
    Label50: TLabel;
    Data_Tracks: TLabel;
    Data_Playlists: TLabel;
    Data_Artists: TLabel;
    Data_Plays: TLabel;
    Data_Albums: TLabel;
    Panel24: TPanel;
    Shape8: TShape;
    Panel25: TPanel;
    Panel27: TPanel;
    Label54: TLabel;
    Label55: TLabel;
    Panel28: TPanel;
    Label57: TLabel;
    Label58: TLabel;
    Panel29: TPanel;
    Label60: TLabel;
    Label61: TLabel;
    Status_Bitrate: TLabel;
    CStandardIcon2: CStandardIcon;
    CStandardIcon3: CStandardIcon;
    CButton22: CButton;
    Download_Album: CButton;
    Download_Artist: CButton;
    Download_Playlist: CButton;
    Download_Status: TLabel;
    UpdateHold: TPanel;
    Version_Check: TWebBrowser;
    UpdateCheck: TTimer;
    Setting_ArtworkStore: CCheckBox;
    CButton25: CButton;
    Label29: TLabel;
    Settings_Threads: CSlider;
    Threads_Text: TLabel;
    StatusUpdaterMs: TTimer;
    Popup_Track: TPopupMenu;
    Popup_Album: TPopupMenu;
    Popup_Artist: TPopupMenu;
    Popup_Playlist: TPopupMenu;
    PlayQueue1: TMenuItem;
    Addtoqueue1: TMenuItem;
    N1: TMenuItem;
    Download1: TMenuItem;
    N2: TMenuItem;
    Information1: TMenuItem;
    N3: TMenuItem;
    ViewAlbum1: TMenuItem;
    ViewArtist1: TMenuItem;
    PlayQueue2: TMenuItem;
    Addtoqueue2: TMenuItem;
    N4: TMenuItem;
    ViewArtist2: TMenuItem;
    N5: TMenuItem;
    Download2: TMenuItem;
    N6: TMenuItem;
    Information2: TMenuItem;
    ViewAlbum2: TMenuItem;
    Addtrackstoqueue1: TMenuItem;
    N7: TMenuItem;
    Download3: TMenuItem;
    N9: TMenuItem;
    Information3: TMenuItem;
    ViewAlbum3: TMenuItem;
    Addtrackstoqueue2: TMenuItem;
    N10: TMenuItem;
    Download4: TMenuItem;
    N11: TMenuItem;
    Information4: TMenuItem;
    Page_Downloads: TPanel;
    Label18: TLabel;
    DownloadDraw: TPaintBox;
    ScrollBar_5: TScrollBar;
    Download_Filters: TPanel;
    Label38: TLabel;
    DownFilder_3: CButton;
    DownFilder_2: CButton;
    DownFilder_4: CButton;
    DownFilder_5: CButton;
    DownFilder_1: CButton;
    TracksControl: TPanel;
    Button_ShuffleTracks: CButton;
    HomeDraw: TPaintBox;
    Welcome_Label: TLabel;
    ScrollBar_6: TScrollBar;
    Panel26: TPanel;
    Page_Title: TLabel;
    Setting_DataSaver: CCheckBox;
    Setting_PlayerOnTop: CCheckBox;
    LoginBox: TPanel;
    CButton13: CButton;
    Label13: TLabel;
    Label16: TLabel;
    Login_UsrToken: TEdit;
    LoadingIcon: TPanel;
    LoadingGif: CPanel;
    Shape6: TShape;
    CImage9: CImage;
    Advanced_Login: TPanel;
    Login_ID: TEdit;
    Label12: TLabel;
    Panel30: TPanel;
    CButton21: CButton;
    CButton23: CButton;
    Panel31: TPanel;
    Mini_Cast: CImage;
    Button_ToggleMenu: CButton;
    CImage1: CImage;
    Label1: TLabel;
    Label2: TLabel;
    Label_Storage: TLabel;
    Artwork_Storage: TLabel;
    CButton24: CButton;
    Label11: TLabel;
    Settings_DisableAnimations: CCheckBox;
    CButton26: CButton;
    Setting_StartWindows: CCheckBox;
    Setting_TrayClose: CCheckBox;
    Setting_QueueSaver: CCheckBox;
    TrayIcon1: TTrayIcon;
    Popup_Tray: TPopupMenu;
    Tray_Toggle: TMenuItem;
    N8: TMenuItem;
    Exit1: TMenuItem;
    ShuffleAll1: TMenuItem;
    N12: TMenuItem;
    Latest_Version: TLabel;
    Panel14: TPanel;
    Label23: TLabel;
    Button_ClearQueue: CButton;
    procedure FormCreate(Sender: TObject);
    procedure Action_PlayExecute(Sender: TObject);
    procedure Button_ToggleMenuClick(Sender: TObject);
    procedure SplitView1Resize(Sender: TObject);
    procedure Button_PreviousClick(Sender: TObject);
    procedure NavigateButton(Sender: TObject);
    procedure DrawItemPaint(Sender: TObject);
    procedure ScrollPositionChange(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure CButton11Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CButton12Click(Sender: TObject);
    procedure LoginUIContainerResize(Sender: TObject);
    procedure CButton13Click(Sender: TObject);
    procedure HideLoginPopupTimer(Sender: TObject);
    procedure Complete_EmailClick(Sender: TObject);
    procedure DrawItemMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_PlayClick(Sender: TObject);
    procedure Track_TimeTimer(Sender: TObject);
    procedure Player_PositionChange(Sender: CSlider; Position, Max,
      Min: Integer);
    procedure Button_PerformanceClick(Sender: TObject);
    procedure DrawItemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PressNowTimer(Sender: TObject);
    procedure DrawItemMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SelectView_Click(Sender: TObject);
    procedure Button_RepeatClick(Sender: TObject);
    procedure SortButtons_Click(Sender: TObject);
    procedure Button_PrevClick(Sender: TObject);
    procedure Button_NextClick(Sender: TObject);
    procedure Button_ExtendClick(Sender: TObject);
    procedure QueuePopupAnimateTimer(Sender: TObject);
    procedure Button_ReloadLibClick(Sender: TObject);
    procedure QueueDrawPaint(Sender: TObject);
    procedure Button_ClearQueueClick(Sender: TObject);
    procedure QueueScrollChange(Sender: TObject);
    procedure QueueDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure QueueDrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QueueDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QueueSwitchAnimationTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure QueueDownGoTimer(Sender: TObject);
    procedure HomeDrawPaint(Sender: TObject);
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Button_ShuffleClick(Sender: TObject);
    procedure Player_PositionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Player_PositionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Action_NextExecute(Sender: TObject);
    procedure Action_PreviousExecute(Sender: TObject);
    procedure CButton16Click(Sender: TObject);
    procedure Button_MiniPlayerClick(Sender: TObject);
    procedure SearchDrawPaint(Sender: TObject);
    procedure SearchBox1InvokeSearch(Sender: TObject);
    procedure Search_ButtonClick(Sender: TObject);
    procedure Quick_SearchExit(Sender: TObject);
    procedure Quick_SearchChange(Sender: TObject);
    procedure Quick_SearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LoginItemsBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure CButton19Click(Sender: TObject);
    procedure SettingsApplyes(Sender: CCheckBox; State: TCheckBoxState);
    procedure CButton20Click(Sender: TObject);
    procedure SType_SongClick(Sender: TObject);
    procedure MenuToggled(Sender: TObject);
    procedure ArtworkSelectClick(Sender: TObject);
    procedure CButton21Click(Sender: TObject);
    procedure MenuStartedAnimation(Sender: TObject);
    procedure DownloadItem(Sender: TObject);
    procedure ChangeIconDownload(Sender: TObject);
    procedure UpdateCheckTimer(Sender: TObject);
    procedure Version_CheckNavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure CButton25Click(Sender: TObject);
    procedure MoveByHold(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SettingsApplyes2(Sender: CSlider; Position, Max, Min: Integer);
    procedure StatusUpdaterMsTimer(Sender: TObject);
    procedure PopupGeneralClick(Sender: TObject);
    procedure PopupMesure(Sender: TObject; ACanvas: TCanvas; var Width,
      Height: Integer);
    procedure PopupDraw(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
    procedure PopupGeneralInfo(Sender: TObject);
    procedure PopupGeneralDownload(Sender: TObject);
    procedure PopupGeneralAddTracks(Sender: TObject);
    procedure PopupGeneralViewArtist(Sender: TObject);
    procedure ViewAlbum1Click(Sender: TObject);
    procedure DownloadsFilterSel(Sender: TObject);
    procedure Button_ShuffleTracksClick(Sender: TObject);
    procedure ExperimentApply(Sender: CCheckBox; State: TCheckBoxState);
    procedure CButton23Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button_VolumeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CButton26Click(Sender: TObject);
    procedure PrepareStartupShortcut(Sender: CCheckBox; State: TCheckBoxState);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure TrayToggle(Sender: TObject);
    procedure Popup_TrayPopup(Sender: TObject);
    procedure Latest_VersionClick(Sender: TObject);
  private
    { Private declarations }
    // Detect mouse Back/Forward
    procedure WMAppCommand(var Msg: TMessage); message WM_APPCOMMAND;

    // Items
    function GetItemCount: cardinal;
    procedure LoadItemInfo;

    function GetTracksID: TArray<integer>;
    function GetPageViewType: TDataSource;

    // Draw Box
    procedure RecalibrateScroll;
    procedure DrawItemCanvas(Canvas: TCanvas; ARect: TRect; Title, Info: string;
      Picture: TJpegImage; Active, Downloaded: boolean);
    procedure DrawWasClicked(Shift: TShiftState = []; Button: TMouseButton = mbLeft);

    // Drawing List
    procedure AddItems(IDArray: TArray<integer>; Source: TDataSource; Clear: boolean = false);

    // UI
    procedure ReselectPage;
    procedure HideAllUI;

    (*Only for updating scrollbar components*)
    procedure SetScroll(Index: integer);
    
    procedure SetView(View: TViewStyle; NoAdd: boolean = false);

    // Sorting
    procedure Sort;
    procedure SetSort(Mode: TSortType);
    function GetSort(Index: integer): integer;

    // Page Views
    procedure AddView(APageRoot: string; AView: TViewStyle);
    procedure LoadView(APageRoot: string);

    // Data
    procedure TokenLoginInfo(Load: boolean);
    procedure ProgramSettings(Load: boolean);
    procedure PositionSettings(Load: boolean);
    procedure DownloadSettings(Load: boolean);
    procedure QueueSettings(Load: boolean);

  public
    { Public declarations }
    procedure NavigatePath(Path: String; AddHistory: boolean = true);

    // Player
    procedure PlaySong(Index: cardinal; StartPlay: boolean = true);

    procedure SongUpdate;
    procedure StatusChanged;
    procedure TickUpdate;

    // Page
    procedure PreviousPage;
    procedure CheckPages;

    // Draw
    procedure RedrawPaintBox;

    // Server
    procedure ReloadArtwork;

    // Queue
    procedure AddQueue(MusicIndex: integer; StartPlay: boolean = true);
    procedure DeleteQueue(MusicIndex: integer);

    procedure QueueClear;
    procedure QueueNext;
    procedure QueuePrev;
    procedure QueueSetTo(Index: integer; StartPlay: boolean = true);

    procedure QueuePlay;
    procedure QueueUpdated;
    procedure QueueChanged;

    procedure RecalculateQueuePos;

    procedure ToggleShuffle(Value: boolean);
    procedure ToggleRepeat;

    // Searching
    procedure FiltrateSearch(Term: string; Flags: TSearchFlags = [TSearchFlag.SearchInfo]);

    // Extra Forms
    procedure UpdateMiniPlayer;

    procedure ApplySettings;

    // Downlaods
    procedure UpdateDownloads;
    procedure ValidateDownloadFiles;
    procedure RedownloadItems;
    procedure CalculateGeneralStorage;

    procedure DeleteDownloaded(MusicID: integer);

    // Font
    function GetSegoeIconFont: string;

    // Login
    procedure PrepareForLogin;
    procedure InitiateLogin;
    procedure PrepareLoginUI;

    procedure InitiateOfflineMode;
    procedure LoadOfflineModeData;
    function ObtainIDFromFileName(FileName: string): integer;
    function HasOfflineBackup: boolean;

    // Data
    function CalculateLength(Seconds: cardinal): string;

    // Update
    procedure StartCheckForUpdate;

    // Library
    procedure ReloadLibrary;

    // Application Tray
    procedure MinimiseToTray;
    procedure OpenFromTray;

    // System
    function Version: string;

    procedure CloseApplication;

    // Utils
    function IntArrayToStr(AArray: TArray<integer>): string;
    function StrToIntArray(Str: string): TArray<integer>;
  end;

  // Utilities
  function OpenDialog(Title, Text: string; AType: CMessageType = ctInformation; Buttons: TMsgDlgButtons = [mbOk]): integer;

  // Logging
  procedure AddToLog(ALog: string);

const
  // SYSTEM
  V_MAJOR = 1;
  V_MINOR = 4;
  V_PATCH = 8;

  UPDATE_URL = 'http://vinfo.codrutsoftware.cf/version_iBroadcast';
  DOWNLOAD_UPDATE_URL = 'https://github.com/Codrax/iBroadcast-For-Windows/releases/';

  // UI
  BG_COLOR = $002C0C11;
  FN_COLOR = clWhite;

  ICON_FILL = #$E73B;

  ICON_PLAY = #$E768;
  ICON_PAUSE = #$E769;

  ICON_CLEAR = #$E894;
  ICON_DOWNLOAD = #$E896;
  ICON_DOWNLOADED = #$E73D;

  CAPTION_DOWNLOAD = 'Download';
  CAPTION_DOWNLOADED = 'Downloaded';

  CAPTION_EMAIL = 'Your email adress: %s';
  CAPTION_USER = 'iBroadcast user since %s';
  CAPTION_VERIFIED = 'Your account is verified. Verification date: %s';
  CAPTION_UNVERIFIED = 'You are at risk of losing you account. Please verify your email adress';
  CAPTION_PREMIUM = 'You are subscribed to premium, awesome! Thanks and enjoy iBroadcast!';
  CAPTION_NOTPREMIUM = 'You are not subscribed to premium';

  // PAGES
  PlayCaptions: TArray<string> = ['Home', 'Search', 'Albums', 'Songs', 'Playlists',
    'Artists', 'Genres', 'ViewAlbum', 'ViewPlaylist', 'ViewArtist', 'ViewGenres',
    'History', 'Account', 'Settings', 'About', 'Premium', 'Downloads'];

  ViewCompatibile: TArray<string> = ['albums', 'songs', 'artists', 'playlists',
    'genres', 'history'];
  SubViewCompatibile: TArray<string> = ['viewalbum', 'viewartist',
    'viewplaylist', 'history'];

  // DOWNLOAD
  DOWNLOAD_DIR = 'downloaded\';

var
  UIForm: TUIForm;

  // Player
  Player: TAudioPlayer;

  SeekPoint: integer;
  IsSeeking: boolean;
  NeedSeekUpdate: boolean;
  SeekTimeout: integer;

  // Application Data
  AppData: string;

  SmallSize: integer;
  OverrideOffline: boolean = false;
  IsOffline: boolean;
  HiddenToTray: boolean;

  // Downloads
  AllDownload: TIntegerList;
  DownloadQueue: TIntegerList;

  DownloadThread: TThread;
  DownloadThreadsE: integer;

  DownloadedTracks: TStringList;
  DownloadedAlbums: TStringList;
  DownloadedArtists: TStringList;
  DownloadedPlaylists: TStringList;

  DownloadsFilter: TDataSource;

  // Page System
  PageHistory: TArray<THistorySet>;

  BareRoot: string;
  LastValueID: integer;
  LastExecutedSource: TDataSource;

  Location,
  LocationExtra,
  LocationROOT: string;

  // View settings
  ViewStyle: TViewStyle = TViewStyle.Cover;

  CoverSpacing: integer = 10;
  CoverWidth: integer = 180;
  CoverHeight: integer = 240;
  CoverRadius: integer = 15;

  ListSpacing: integer = 10;
  ListHeight: integer = 115;
  ListRadius: integer = 15;

  QListSpacing: integer = 10;
  QListHeight: integer = 60;
  QListRadius: integer = 10;
  QRects: TArray<TRect>;

  MaxScroll: integer = 0;

  // Draw
  Press10Stat: cardinal = 0;
  MouseIsPress: boolean;
  IndexHover,
  IndexHoverID: integer;

  DrawItems: TArray<TDrawableItem>;

  ActiveDraw: TPaintBox;
  PauseDrawing: boolean;
  LastDrawBuffer: TBitMap;

  LastScrollValue: integer = -1;

  ListSort: TSortType;
  EnabledSorts: TSortTypes = [TSortType.Default, TSortType.Alphabetic, TSortType.Year, TSortType.Rating];
  SortingList: TArray<integer>;

  HomeFitItems: integer;

  // Popup Menu
  PopupDrawIndex: integer;
  PopupSource: TDataSource;

  // SYSTEM
  THREAD_MAX: cardinal = 15;

  // Logging
  EnableLogging: boolean;

  // Queue System
  PlayIndex: integer = -1;
  PlayID: integer = -1;

  QueuePos: integer;
  PlayQueue: TIntegerList;

  Shuffled: boolean;
  OriginalQueueValid: boolean;
  PlayQueueOriginal: TIntegerList;

  RepeatMode: TRepeat = TRepeat.All;

  // Server
  ArtworkID: integer = 0;

  // Queue Popup
  QueueAnProgress: integer;
  DestQueuePopup: integer;

  QueueHover: integer = -1;
  QueueDragItem: integer;
  QueueMouseDown: boolean;
  QueueDragPress: boolean;
  QueueCursorDown: TPoint;
  QueueCursor: TPoint;

  // Anim Switcheroooooooooooooooo!
  QueuePos1: integer;
  QueuePos2: integer;
  QueueSwitchProgress: integer;
  DrawnQueueButtons: boolean;

  StartingPoint: TPoint;

  // Page Specific Data
  SavedViews: TArray<TViewSave>;

  // Search
  LastFilterQuery: string;

  // Threading
  TotalThreads: cardinal;

  // Colors
  ItemColor: TColor;
  ItemActiveColor: TColor;
  TextColor: TColor;

implementation

{$R *.dfm}

uses
  // Forms
  InfoForm, VolumePopup, HelpForm, MiniPlay, NewVersionForm;

procedure TUIForm.Action_NextExecute(Sender: TObject);
begin
  QueueNext;
end;

procedure TUIForm.Action_PlayExecute(Sender: TObject);
begin
  if Player.PlayStatus = psPlaying then
    Player.Pause
  else
    Player.Play;

  StatusChanged;
end;

procedure TUIForm.Action_PreviousExecute(Sender: TObject);
begin
  QueuePrev;
end;

procedure TUIForm.AddItems(IDArray: TArray<integer>; Source: TDataSource;
  Clear: boolean);
var
  Start: integer;
  I: Integer;
begin
  // Clear
  if Clear then
    SetLength(DrawItems, 0);

  // Data
  Start := Length(DrawItems);

  SetLength(DrawItems, Length(DrawItems) + length(IDArray));

  // Load Data
  for I := 0 to High(IDArray) do
    begin
      DrawItems[Start + I].LoadSourceID( IDArray[I], Source );
    end;
end;

procedure TUIForm.AddQueue(MusicIndex: integer; StartPlay: boolean);
var
  WasStopped: boolean;
begin
  WasStopped := (Player.PlayStatus = TPlayStatus.psStopped)
    and (QueuePos = PlayQueue.Count - 1) and (PlayQueue.Count <> 0);

  PlayQueue.Add( MusicIndex );

  if WasStopped and StartPlay then
    QueueNext;

  // Update
  QueueUpdated;
  QueueChanged;
end;

procedure TUIForm.AddView(APageRoot: string; AView: TViewStyle);
var
  I, Index: Integer;
begin
  for I := 0 to High(SavedViews) do
    if SavedViews[I].PageRoot = APageRoot then
      begin
        SavedViews[I].View := AView;
        Exit;
      end;

  // Add New
  Index := Length(SavedViews);
  SetLength(SavedViews, Index+1);

  with SavedViews[Index] do
    begin
      PageRoot := APageRoot;
      View := AView;
    end;
end;

procedure TUIForm.ApplySettings;
begin
  AddToLog('Form.ApplySettings');
  Button_Performance.Visible := Setting_Graph.Checked;
  Button_Performance.Left := Button_Volume.Left + Button_Performance.Width;
  ArtworkStore := Setting_ArtworkStore.Checked;
  if ArtworkStore then
    InitiateArtworkStore
  else
    ClearArtworkStore;
  if Setting_DataSaver.Checked then
    DefaultArtSize := TArtSize.Small
  else
    DefaultArtSize := TArtSize.Medium;
  SplitView1.UseAnimation := not Settings_DisableAnimations.Checked;

  THREAD_MAX := Settings_Threads.Position;
  Threads_Text.Caption := THREAD_MAX.ToString;
end;

procedure TUIForm.Button_ExtendClick(Sender: TObject);
begin
  if EqualApprox(DestQueuePopup, Queue_Extend.Constraints.MaxHeight, 10) then
    begin
      DestQueuePopup := 1;
      CButton(Sender).BSegoeIcon := #$E70E;
    end
  else
    begin
      DestQueuePopup := Queue_Extend.Constraints.MaxHeight;
      CButton(Sender).BSegoeIcon := #$E70D;
    end;

  // Prepare
  QueueAnProgress := 1;

  // Scroll Position
  QueueScroll.Position := QueuePos * (QListHeight + QListSpacing);

  // Animations Disabled
  if Settings_DisableAnimations.Checked then
    begin
      Queue_Extend.Height := DestQueuePopup;
      Exit;
    end;
    //QueueAnProgress := DestQueuePopup div 2;

  // Animation Settings
  PauseDrawing := true;
  QueuePopupAnimate.Enabled := true;
end;

procedure TUIForm.Button_MiniPlayerClick(Sender: TObject);
begin
  Hide;
  MiniPlayer.PreparePosition;
  MiniPlayer.FormStyle := fsNormal;

  ExperimentalTop := Setting_PlayerOnTop.Checked;
  if ExperimentalTop then
    begin
      MiniPlayer.FormStyle := fsStayOnTop;
      ChangeMainForm(MiniPlayer);
    end;


  // Get data
  UpdateMiniPlayer;
end;

procedure TUIForm.Button_NextClick(Sender: TObject);
begin
  Action_Next.Execute;
end;

procedure TUIForm.Button_PlayClick(Sender: TObject);
begin
  Action_Play.Execute;
end;

procedure TUIForm.Button_PrevClick(Sender: TObject);
begin
  Action_Previous.Execute;
end;

procedure TUIForm.Button_PreviousClick(Sender: TObject);
begin
  PreviousPage;
end;

procedure TUIForm.Button_RepeatClick(Sender: TObject);
begin
  ToggleRepeat;
end;

procedure TUIForm.Button_ShuffleClick(Sender: TObject);
begin
  ToggleShuffle( not Shuffled );
end;

procedure TUIForm.Button_ShuffleTracksClick(Sender: TObject);
var
  I: Integer;
  RandomQueue: TArray<integer>;
begin
  if Length(DrawItems) = 0 then
    Exit;

  // Clear
  QueueClear;

  // Fisher-Yates shuffle algorithm
  RandomQueue := GenerateRandomSequence(Length(DrawItems));

  // Add to queue
  for I := 0 to High(RandomQueue) do
    if DrawItems[RandomQueue[I]-1].Source = TDataSource.Tracks then
        AddQueue(DrawItems[RandomQueue[I]-1].Index);

  // Play
  QueuePos := 0;
  QueuePlay;
end;

procedure TUIForm.CalculateGeneralStorage;
const
  STORAGE_PHRASE = '%S of internal storage used';
  STORAGE_PHRASE2 = 'Storage Used by Artwork: %S';
var
  Storage: string;
begin
  Storage := GetFolderSizeInStr( AppData + DOWNLOAD_DIR );
  Label_Storage.Caption := Format(STORAGE_PHRASE, [Storage]);

  Storage := GetFolderSizeInStr( GetArtworkStore() );
  Artwork_Storage.Caption := Format(STORAGE_PHRASE2, [Storage]);
end;

function TUIForm.CalculateLength(Seconds: cardinal): string;
var
  Minutes, Hours: cardinal;
begin
  Minutes := Seconds div 60;
  Seconds := Seconds - Minutes * 60;

  Hours := Minutes div 60;
  Minutes := Minutes - Hours * 60;

  Result := IntToStrIncludePrefixZeros(Minutes, 2) + ':' + IntToStrIncludePrefixZeros(Seconds, 2);

  if Hours > 0 then
    Result := IntToStrIncludePrefixZeros(Hours, 2) + ':' + Result;
end;

procedure TUIForm.Button_ReloadLibClick(Sender: TObject);
begin
  // UI
  PrepareLoginUI;

  // Reload
  TTask.Run(procedure
    begin

      // Load Library, Account, Queue
      ReLoadLibrary;

      // Show UI
      TThread.Synchronize(nil, procedure
        begin
          // Navigate to Home
          NavigatePath('Home');

          HideAllUI;
          TitlebarCompare.Show;
          PrimaryUIContainer.Show;
        end);
    end);
end;

procedure TUIForm.Button_ClearQueueClick(Sender: TObject);
begin
  QueueClear;
  QueueDraw.Repaint;
end;

procedure TUIForm.CButton11Click(Sender: TObject);
begin
  ShellRun( 'https://www.ibroadcast.com/premium/', false );
end;

procedure TUIForm.CButton12Click(Sender: TObject);
var
  FileName: string;
begin
  // Stop Audio
  if Player.PlayStatus = psPlaying then
    QueueClear;

  // Delete Token
  LOGIN_TOKEN := '';
  FileName := AppData + 'login.token';
  if TFile.Exists(FileName) then
    TFile.Delete(FileName);

  // Log Off
  LogOff;
end;

procedure TUIForm.CButton13Click(Sender: TObject);
begin
  APPLICATION_ID := Login_ID.Text;
  LOGIN_TOKEN := Login_UsrToken.Text;

  InitiateLogin;
end;

procedure TUIForm.CButton16Click(Sender: TObject);
var
  URL: string;
begin
  // Social Exec
  case CButton(Sender).Tag of
    1: URL  := 'https://www.codrutsoftware.cf/';
    2: URL  := 'https://www.youtube.com/LavaTechnology/';
    3: URL  := 'https://www.twitter.com/LAVAplanks/';
    4: URL  := 'mailto:petculescucodrut@outlook.com';
    5: URL  := 'https://www.paypal.me/codrutpetcu/';
  end;

  ShellRun(URL, false);
end;

procedure TUIForm.CButton19Click(Sender: TObject);
begin
  with Search_Filters do
    Visible := not Visible;
end;

procedure TUIForm.CButton20Click(Sender: TObject);
begin
  with Search_Types do
    Visible := not Visible;
end;

procedure TUIForm.CButton21Click(Sender: TObject);
begin
  HelpUI := THelpUI.Create(Application);
  try
    HelpUI.ShowModal;
  finally
    HelpUI.Free;
  end;
end;

procedure TUIForm.CButton23Click(Sender: TObject);
begin
  if OpenDialog('Advanced Login', 'Would you like to toggle Advanced Login?', ctQuestion, [mbYes, mbNo]) = mrYes then
    Advanced_Login.Visible := not Advanced_Login.Visible;

  if Advanced_Login.Visible then
    Advanced_Login.Top := 0;
end;

procedure TUIForm.CButton25Click(Sender: TObject);
begin
  ClearArtworkStore;

  InitiateArtworkStore;
end;

procedure TUIForm.CButton26Click(Sender: TObject);
var
  Folder: string;
begin
  Folder := AppData + DOWNLOAD_DIR;

  if TDirectory.Exists(Folder) then
    ShellRun(Folder, true)
  else
    OpenDialog('Opps', 'The Downloads folder does not exist yet');
end;

procedure TUIForm.DownloadsFilterSel(Sender: TObject);
var
  I: Integer;
  Previous: TDataSource;
begin
  Previous := DownloadsFilter;
  DownloadsFilter := TDataSource(CButton(Sender).Tag);

  // Same
  if DownloadsFilter = Previous then
    Exit;

  // Buttons
  for I := 0 to Download_Filters.ControlCount - 1 do
    if Download_Filters.Controls[I] is CButton then
      with CButton(Download_Filters.Controls[I]) do
        FlatButton := Tag = Integer(DownloadsFilter);

  // Load
  if (DownloadsFilter = TDataSource.None) or ((DownloadsFilter <> TDataSource.None) and (Previous = TDataSource.None) ) then
    begin
      LoadItemInfo;
      Sort;
    end;

  // Hide Data
  if (DownloadsFilter <> TDataSource.None) then
    for I := 0 to High(DrawItems) do
      DrawItems[I].HiddenItem := DrawItems[I].Source <> DownloadsFilter;

  // Scroll
  ScrollPosition.Position := 0;

  // Draw
  RedrawPaintBox;
end;

procedure TUIForm.ArtworkSelectClick(Sender: TObject);
begin
  // Artwork
  ArtworkID := CButton(Sender).Tag;

  ReloadArtwork;
end;

procedure TUIForm.SType_SongClick(Sender: TObject);
begin
  with CButton(Sender) do
    FlatButton := not FlatButton;
end;

procedure TUIForm.Button_ToggleMenuClick(Sender: TObject);
begin
  if not SplitView1.Locked then
    SplitView1.Opened := not SplitView1.Opened;
end;

procedure TUIForm.Button_PerformanceClick(Sender: TObject);
begin
  // CPU Usage Form
  PerfForm.AddNew.Enabled := true;

  PerfForm.Show;
end;

procedure TUIForm.Button_VolumeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    begin
      if ssAlt in Shift then
        ShellRun('sndvol.exe', true)
      else
        begin
          // Volume
          VolumePop.Top := Button_Volume.ClientToScreen(Point(0, 0)).Y - VolumePop.Height;
          VolumePop.Left := Button_Volume.ClientToScreen(Point(0, 0)).X - VolumePop.Width + Button_Volume.Width;

          VolumePop.CSlider1.Position := trunc(Player.Volume * 1000);

          VolumePop.Show;
        end;
    end;
end;

procedure TUIForm.NavigateButton(Sender: TObject);
begin                                              
  // Navigation Buttons
  case CButton(Sender).Tag of
    1: NavigatePath( 'Home' );
    2: NavigatePath( 'Search' );
    3: NavigatePath( 'Albums' );
    4: NavigatePath( 'Songs' );
    5: NavigatePath( 'Artists' );
    6: NavigatePath( 'Playlists' );
    7: NavigatePath( 'Downloads' );
    8: NavigatePath( 'History' );
    9: NavigatePath( 'Account' );
    10: NavigatePath( 'Settings' );
  end;
end;

procedure TUIForm.CheckPages;
begin
  Button_Previous.Enabled := Length(PageHistory) > 0;

  if Length(PageHistory) > 50 then
    begin
      Move( PageHistory[1], PageHistory[0], SizeOf(THistorySet) * (Length(PageHistory) - 1) );

      SetLength(PageHistory, Length(PageHistory) - 1);
    end;
end;

procedure TUIForm.CloseApplication;
begin
  AddToLog('Form.CloseApplication');
  // Tray Mode
  if Setting_TrayClose.Checked then
    HiddenToTray := true;

  // Mini Player
  if MiniPlayer.Visible then
    MiniPlayer.Close;

  // Close UI
  Close;
end;

procedure TUIForm.QueueChanged;
begin
  // Queue was modified
  Shuffled := false;
  OriginalQueueValid := false;
end;

procedure TUIForm.QueueClear;
begin
  PlayQueue.Clear;

  if Player.PlayStatus = TPlayStatus.psPlaying then
    Player.Stop;

  QueuePos := -1;

  // Update
  QueueUpdated;
  QueueChanged;
end;

procedure TUIForm.Complete_EmailClick(Sender: TObject);
begin
  Complete_Email.Caption := Complete_Email.Hint;
end;

procedure TUIForm.SettingsApplyes2(Sender: CSlider; Position, Max, Min: Integer);
begin
  ApplySettings;
end;

procedure TUIForm.LoginItemsBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
var
  Connect, Join, Location: string;
begin
  if Sessions[AIndex].Connected then
    Connect := 'Connected'
  else
    Connect := 'Disconnected';
  if Sessions[AIndex].Joinable then
    Join := 'Joinable'
  else
    Join := 'Unjoinable';
  if Sessions[AIndex].Location <> '' then
    Location := Sessions[AIndex].Location
  else
    Location := 'Unknown location';

  Label34.Caption := Sessions[AIndex].DeviceName + ' (' + Location + ')';
  Label35.Caption := Connect + ', ' + Join + ', Last Login:' + DateTimeToStr(Sessions[AIndex].LastLogin);
end;

procedure TUIForm.DeleteDownloaded(MusicID: integer);
var
  AFile: string;
  FileName: string;
  I: Integer;
begin
  AddToLog('Form.DeleteDownloaded(' + MusicID.ToString + ')');
  AFile := AppData + DOWNLOAD_DIR + MusicID.ToString;

  for I := 1 to 3 do
    begin
      case I of
        1: FileName := AFile + '.mp3';
        2: FileName := AFile + '.txt';
        3: FileName := AFile + ART_EXT;
      end;

      if TFile.Exists(FileName) then
        TFile.Delete(FileName);
    end;

end;

procedure TUIForm.DeleteQueue(MusicIndex: integer);
var
  WasPlaying: boolean;
begin
  WasPlaying := MusicIndex = QueuePos;

  PlayQueue.Delete( MusicIndex );

  if WasPlaying then
    QueuePlay;

  // Update
  QueueUpdated;
  QueueChanged;
end;

procedure TUIForm.DownloadSettings(Load: boolean);
const
  // Catrgories
  SECT = 'Downloads';
  DAT_TRACKS = 'Tracks';
  DAT_ALBUMS = 'Albums';
  DAT_ARTISTS = 'Artists';
  DAT_PLAYLISTS = 'Playlists';
var
  OPT: TIniFile;
  FileName: string;
begin
  FileName := AppData + 'downloadconfig.ini';
  if Load then
    // Load Data
    begin
      if not TFile.Exists(FileName) then
        Exit;

      OPT := TIniFIle.Create(FileName);
      try
        // Track Containers
        DownloadedTracks := StringToStringList( OPT.ReadString(SECT, DAT_TRACKS, ''), ',');
        DownloadedAlbums := StringToStringList( OPT.ReadString(SECT, DAT_ALBUMS, ''), ',');
        DownloadedArtists := StringToStringList( OPT.ReadString(SECT, DAT_ARTISTS, ''), ',');
        DownloadedPlaylists := StringToStringList( OPT.ReadString(SECT, DAT_PLAYLISTS, ''), ',');

      finally
        OPT.Free;
      end;
    end
  else
    // Save Data
    begin
      OPT := TIniFIle.Create(FileName);
      try
        // Track Containers
        OPT.WriteString(SECT, DAT_TRACKS, StringListToString(DownloadedTracks, ','));
        OPT.WriteString(SECT, DAT_ALBUMS, StringListToString(DownloadedAlbums, ','));
        OPT.WriteString(SECT, DAT_ARTISTS, StringListToString(DownloadedArtists, ','));
        OPT.WriteString(SECT, DAT_PLAYLISTS, StringListToString(DownloadedPlaylists, ','));
      finally
        OPT.Free;
      end;
    end;
end;

procedure TUIForm.ChangeIconDownload(Sender: TObject);
begin
  with CButton(Sender) do
    if Tag <> 0 then
      begin
        Text := CAPTION_DOWNLOADED;
        BSegoeIcon := ICON_DOWNLOADED;
      end
    else
      begin
        Text := CAPTION_DOWNLOAD;
        BSegoeIcon := ICON_DOWNLOAD;
      end;
end;

procedure TUIForm.DownloadItem(Sender: TObject);
var
  Item: TDrawAbleItem;
  Output: boolean;
begin
  Item.LoadSourceID(LocationExtra.ToInteger, GetPageViewType);

  Output := Item.ToggleDownloaded;

  // Button Update
  CButton(Sender).Tag := Output.ToInteger;
  CButton(Sender).OnEnter(Sender);
end;

procedure TUIForm.DrawItemCanvas(Canvas: TCanvas; ARect: TRect; Title,
  Info: string; Picture: TJpegImage; Active, Downloaded: boolean);
var
  TempRect: TRect;
  Dist: integer;
  S: string;
begin
  // Common
  with Canvas do
    begin
      // Fill
      Pen.Style := psClear;
      Brush.Style := bsSolid;

      if Active then
        Brush.Color := ItemActiveColor
      else
        Brush.Color := ItemColor;

      if ViewStyle = TViewStyle.Cover then
        RoundRect( ARect, CoverRadius, CoverRadius )
      else
        RoundRect( ARect, ListRadius, ListRadius );

      // Fix Image Bug
      if Picture <> nil then
        try
          Picture.Empty;
        except
          Picture := nil
        end;
    end;

  with Canvas do
    if ViewStyle = TViewStyle.Cover then
      begin
        // Text
        Brush.Style := bsClear;
        Font.Assign( Self.Font );

        TempRect := ARect;
        Inc(TempRect.Top, ARect.Width + CoverSpacing);
        Font.Size := Font.Size + 2;

        TempRect.Height := trunc(60/100 * TempRect.Height);

        S := TrimmifyText(Canvas, Title, TempRect.Width);;
        TextRect(TempRect, S, [tfCenter, tfBottom]);

        // Subtext
        Brush.Style := bsClear;
        Font.Assign( Self.Font );

        TempRect := ARect;
        Inc(TempRect.Top, ARect.Width + CoverSpacing);
        Font.Size := Font.Size - 2;

        Inc(TempRect.Top, trunc(60/100 * TempRect.Height));

        S := TrimmifyText(Canvas, Info, TempRect.Width);;
        TextRect(TempRect, S, [tfCenter, tfTop]);

        // Image
        TempRect := ARect;
        TempRect.Height := ARect.Width;

        if (Picture <> nil) and (not Picture.Empty)  then
          GDIGraphicRound( Picture, TempRect, CoverRadius )
        else
          begin
            Brush.Style := bsSolid;
            Brush.Color := ChangeColorSat(ItemColor, 20);

            RoundRect( TempRect, CoverRadius, CoverRadius );
          end;

        // Downloaded
        if Downloaded then
          begin
            Font.Assign(Self.Font);
            Font.Name := Self.GetSegoeIconFont;

            Font.Size := 26;
            Font.Color := clHighlight;

            S := ICON_FILL;
            Dist := TextWidth(s) * 2;
            TempRect := Rect( ARect.Right - Dist, ARect.Top + 5, ARect.Right, ARect.Top + Dist + 5);

            S := ICON_FILL;
            TextRect(TempRect, S, [tfCenter, tfTop]);

            Font.Size := 14;
            Font.Color := FN_COLOR;

            TempRect.Top := TempRect.Top + 8;
            S := ICON_DOWNLOAD;
            TextRect(TempRect, S, [tfCenter, tfVerticalCenter]);
          end;

      end
    else
      begin
        // Text
        Brush.Style := bsClear;
        Font.Assign( Self.Font );

        TempRect := ARect;
        Inc(TempRect.Left, ARect.Height + ListSpacing);
        Font.Size := Font.Size + 10;

        TempRect.Height := trunc(40/100 * TempRect.Height);

        Title := TrimmifyText(Canvas, Title, TempRect.Width);;
        TextRect(TempRect, Title, [tfLeft, tfBottom]);

        // Subtext
        Brush.Style := bsClear;
        Font.Assign( Self.Font );

        TempRect := ARect;
        Inc(TempRect.Left, ARect.Height + ListSpacing);
        Font.Size := Font.Size + 4;

        Inc(TempRect.Top, trunc(40/100 * TempRect.Height));
        TempRect.Bottom := ARect.Bottom;

        //Info := TrimmifyText(Canvas, Info, TempRect.Width);;
        TextRect(TempRect, Info, [tfLeft, tfTop, tfWordBreak]);

        // Image
        TempRect := ARect;
        TempRect.Width := ARect.Height;

        if (Picture <> nil) and (not Picture.Empty) then
          GDIGraphicRound( Picture, TempRect, CoverRadius )
        else
          begin
            Brush.Style := bsSolid;
            Brush.Color := ChangeColorSat(ItemColor, 20);

            RoundRect( TempRect, CoverRadius, CoverRadius );
          end;
      end;
end;

procedure TUIForm.DrawItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Anim
  Press10Stat := 0;
  PressNow.Enabled := true;

  // Press
  MouseIsPress := true;
end;

procedure TUIForm.DrawItemMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  I: Integer;
begin
  // Get Press position
    IndexHover := -1;
  IndexHoverID := -1;
  for I := 0 to High(DrawItems) do
    if DrawItems[I].Bounds.Contains( Point(X, Y) ) then
      begin
        IndexHover := I;
        IndexHoverID := GetSort( I );
        Break;
      end;

  // Cursor
  if IndexHoverID <> -1 then
    TPaintBox(Sender).Cursor := crHandPoint
  else
    TPaintBox(Sender).Cursor := crDefault;
end;

procedure TUIForm.DrawItemMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Draw Settings
  PressNow.Enabled := false;

  // Status
  Press10Stat := 10;
  Self.RedrawPaintBox;

  // Click
  if IndexHover <> -1 then
    DrawWasClicked(Shift, Button);

  // Reset
  MouseIsPress := false;
  Press10Stat := 0;

  // Redraw
  RedrawPaintBox;
end;

procedure TUIForm.DrawItemPaint(Sender: TObject);
var
  AWidth, AHeight, Index, I, X, Y: integer;

  FitX, ExtraSpacing: integer;

  ItemsCount: cardinal;
  ARect: TRect;

  Title, Info: string;
  Picture: TJpegImage;
begin
  // Count
  ItemsCount := Length(SortingList);

  // No drawing
  if PauseDrawing then
    begin
      TPaintBox(Sender).Canvas.Draw(0, 0, LastDrawBuffer);
      Exit;
    end;

  // Common
  AWidth := TPaintBox(Sender).Width;
  AHeight := TPaintBox(Sender).Height;

  // Draw mode
  if ViewStyle = TViewStyle.Cover then
    // View Style COVER
    begin               
      X := 0;
      Y := -ScrollPosition.Position;

      FitX := (AWidth div (CoverWidth + CoverSpacing));
      if FitX = 0 then
        Exit;
      ExtraSpacing := round((AWidth - FitX * (CoverWidth + CoverSpacing)) / FitX);

      for I := 0 to ItemsCount - 1 do
        begin
          // Index
          Index := GetSort( I );

          // Hidden
          if DrawItems[Index].Hidden then
            begin
              DrawItems[I].Bounds := Rect(0,0,0,0);
              Continue;
            end;

          // Rect
          ARect := Rect( X, Y, X + CoverWidth, Y + CoverHeight);

          DrawItems[I].Bounds := ARect;

          // Draw if visible
          if (Y + CoverHeight > 0) and (Y < AHeight) then
            begin
              //GetItemInfo( Index, Title, Info, Picture );
              Title := DrawItems[Index].Title;
              Info := DrawItems[Index].InfoShort;
              Picture := DrawItems[Index].GetPicture;


              if (Index = IndexHoverID) and (Press10Stat <> 0) then
                ARect.Inflate(-Press10Stat, -trunc(ARect.Height/ ARect.Width * Press10Stat));

              // Draw
              DrawItemCanvas(TPaintBox(Sender).Canvas, ARect, Title, Info,
                Picture, DrawItems[Index].Active, DrawItems[Index].Downloaded);
            end;
                           
          // Move Line
          Inc(X, CoverWidth + CoverSpacing + ExtraSpacing);

          if X + CoverWidth > AWidth then
            begin
              X := 0;
              Inc(Y, CoverHeight + CoverSpacing);
            end;

          if Y > AHeight then
            Break;
        end;
    end
  else
  // View Style LIST
    begin
      X := 0;
      Y := -ScrollPosition.Position;

      for I := 0 to ItemsCount - 1 do
        begin      
          // Index
          Index := GetSort( I );

          // Hidden
          if DrawItems[Index].Hidden then
            begin
              DrawItems[I].Bounds := Rect(0,0,0,0);
              Continue;
            end;
          
          // Rect
          ARect := Rect( X, Y, X + AWidth, Y + ListHeight);

          DrawItems[I].Bounds := ARect;

          // Draw if visible
          if (Y + CoverHeight > 0) and (Y < AHeight) then
            begin
              //GetItemInfo( Index, Title, Info, Picture );
              Title := DrawItems[Index].Title;
              Info := DrawItems[Index].InfoLong;
              Picture := DrawItems[Index].GetPicture;

              if (Index = IndexHoverID) and (Press10Stat <> 0) then
                ARect.Inflate(-Press10Stat, -Press10Stat);

              // Draw
              DrawItemCanvas(TPaintBox(Sender).Canvas, ARect, Title, Info,
                Picture, DrawItems[Index].Active, DrawItems[Index].Downloaded);
            end;

          // Move Line
          Inc(Y, ListHeight + ListSpacing);

          if Y > AHeight then
            Break; Continue
        end;
    end;


  // Copy draw buffer
  with TPaintBox(Sender).Canvas do
    begin
      LastDrawBuffer.Width := ClipRect.Width;
      LastDrawBuffer.Height := ClipRect.Height;

      LastDrawBuffer.Canvas.CopyRect(ClipRect, TPaintBox(Sender).Canvas, ClipRect);
    end;

  // Scroll
  try
    RecalibrateScroll;
  except
    ShowMessage('Error');
  end;
end;

procedure TUIForm.DrawWasClicked(Shift: TShiftState; Button: TMouseButton);
procedure SetDownloadIcon(Value: boolean; Source: TDataSource);
var
  Icon: string;
  Text: string;

  Menu: TMenuItem;
begin
  if Value then
    begin
      Icon := ICON_CLEAR;
      Text := 'Delete Download';
    end
  else
    begin
      Icon := ICON_DOWNLOAD;
      Text := 'Download';
    end;

  case Source of
    TDataSource.Tracks: Menu := Download1;
    TDataSource.Albums: Menu := Download2;
    TDataSource.Artists: Menu := Download3;
    TDataSource.Playlists: Menu := Download4;
    else Exit;
  end;

  Menu.Caption := Text;
  Menu.Hint := Icon;
end;
var
  Index: integer;
begin
  Index := GetSort(IndexHover);

  // Normal Click
  if Button = mbLeft then
    begin
      with DrawItems[Index] do
        begin
          if ssCtrl in Shift then
            OnlyQueue := true;

          if ssAlt in Shift then
            OpenInformation
          else
            Execute;

          OnlyQueue := false;
        end;
    end
  else
    // Right click
    begin
      PopupDrawIndex := Index;
      PopupSource := DrawItems[Index].Source;

      SetDownloadIcon( DrawItems[Index].Downloaded, PopupSource );
      
      case PopupSource of
        TDataSource.Tracks: Popup_Track.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
        TDataSource.Albums: Popup_Album.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
        TDataSource.Artists: Popup_Artist.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
        TDataSource.Playlists: Popup_Playlist.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
      end;
    end;
end;

procedure TUIForm.Exit1Click(Sender: TObject);
begin
  CloseApplication;
end;

procedure TUIForm.ExperimentApply(Sender: CCheckBox; State: TCheckBoxState);
begin
  if State = cbChecked then
    case OpenDialog('Experimental Feature Ahead!', 'The setting you are about to enable ' +
    'is experimental. This feature is unstable, you may use it at your own risk.'#13#13'Enable this feature?', ctWarning, [mbYes, mbNo]) of
      mrNo: CCheckBox(Sender).State := cbUnchecked;
    end;
end;

procedure TUIForm.FiltrateSearch(Term: string; Flags: TSearchFlags);
procedure RidOfSimbols(var DataStr: string);
var
  RPFlag: TReplaceFlags;
begin
  RPFlag := [rfReplaceAll, rfIgnoreCase];

  DataStr := StringReplace(DataStr, ' ', '', RPFlag);
  DataStr := StringReplace(DataStr, ',', '', RPFlag);
  DataStr := StringReplace(DataStr, '.', '', RPFlag);
  DataStr := StringReplace(DataStr, '#', '', RPFlag);
  DataStr := StringReplace(DataStr, '&', '', RPFlag);
  DataStr := StringReplace(DataStr, '%', '', RPFlag);
  DataStr := StringReplace(DataStr, '!', '', RPFlag);
  DataStr := StringReplace(DataStr, '@', '', RPFlag);
  DataStr := StringReplace(DataStr, #39, '', RPFlag);
  DataStr := StringReplace(DataStr, '*', '', RPFlag);
  DataStr := StringReplace(DataStr, '"', '', RPFlag);
  DataStr := StringReplace(DataStr, '`', '', RPFlag);
  DataStr := StringReplace(DataStr, '~', '', RPFlag);
  DataStr := StringReplace(DataStr, '-', '', RPFlag);
  DataStr := StringReplace(DataStr, '(', '', RPFlag);
  DataStr := StringReplace(DataStr, ')', '', RPFlag);
  DataStr := StringReplace(DataStr, '[', '', RPFlag);
  DataStr := StringReplace(DataStr, ']', '', RPFlag);
end;

function CompareFound(Data1, Data2: string; Flags: TSearchFlags): boolean;
var
  MashedCompare,
  MashedSource: string;
  (* Mashed Potatoes *)
begin
  // Mash Data
  MashedSource := Data2;
  MashedCompare := Data1;

  if not (TSearchFlag.CaseSensitive in Flags) then
    begin
      MashedSource := AnsiLowerCase(MashedSource);
      MashedCompare := AnsiLowerCase(MashedCompare);
    end;

  if not (TSearchFlag.ExactMatch in Flags) then
    begin
      RidOfSimbols(MashedSource);
      RidOfSimbols(MashedCompare);
    end;

  // Compare
  if TSearchFlag.ExactMatch in Flags then
    Result := MashedCompare = MashedSource
  else
    Result := Pos(MashedCompare, MashedSource) <> 0;
end;

var
  I: Integer;
  Found: boolean;
begin
  for I := 0 to High(DrawItems) do
    begin
      if Term = '' then
        DrawItems[I].HiddenSearch := false
      else
        begin
          Found := CompareFound(Term, DrawItems[I].Title, Flags)
            or ((TSearchFlag.SearchInfo in Flags) and CompareFound(Term, DrawItems[I].InfoLong, Flags));

          DrawItems[I].HiddenSearch := not Found;
        end;
    end;

  LastFilterQuery := Term;
end;

procedure
TUIForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Hide to tray
  if Setting_TrayClose.Checked and not HiddenToTray then
    begin
      Self.MinimiseToTray;

      CanClose := false;
      Exit;
    end;

  // Threads
  if (TotalThreads > 0) then
    if OpenDialog('Close Application', 'Are you sure? Some threads are still running', ctQuestion, [mbYes, mbNo]) = mrNo then
      begin
        CanClose := false;
        Exit;
      end;

  // Save Data
  TokenLoginInfo(false);
  ProgramSettings(false);
  PositionSettings(false);

  if not IsOffline then
    DownloadSettings(false);

  if Setting_QueueSaver.Checked then
    QueueSettings(false);

  // Free Memory
  Player.Free;
  PlayQueue.Free;
end;

procedure TUIForm.FormCreate(Sender: TObject);
var
  I, J: Integer;
begin
  AddToLog('Loading Form.Create.UX');
  // UX
  Color := BG_COLOR;
  Font.Color := FN_COLOR;
  with CustomTitleBar do
    begin
      Enabled := true;

      CaptionAlignment := taCenter;
      ShowIcon := false;

      SystemColors := false;
      SystemButtons := false;
      SystemHeight := false;

      Control := TitleBarPanel;

      PrepareCustomTitleBar( TForm(Self), Color, FN_COLOR);

      InactiveBackgroundColor := BackgroundColor;
      ButtonInactiveBackgroundColor := BackgroundColor;
    end;

  // AppData
  AppData := GetPathInAppData('Cods iBroadcast');

  AddToLog('Preparing Downloads');
  // Prepare Downloading
  AllDownload := TIntegerList.Create;
  DownloadQueue := TIntegerList.Create;

  DownloadedTracks := TStringList.Create;
  DownloadedAlbums := TStringList.Create;
  DownloadedArtists := TStringList.Create;
  DownloadedPlaylists := TStringList.Create;

  AddToLog('Creating Player');
  // Player
  Player := TAudioPlayer.Create;
  StatusChanged;

  // Queue
  PlayQueue := TIntegerList.Create;

  // Drawing
  LastDrawBuffer := TBitMap.Create;

  // Page Navigation
  SetLength(PageHistory, 0);

  AddToLog('Obtaining Form.Create.DEVICE_NAME');
  // Get Client Information
  DEVICE_NAME := Format(DEVICE_NAME_CONST, [GetCompleteUserName + #39's']);

  AddToLog('Getting system colors');
  // System Draw Colors
  ItemColor := ChangeColorSat($002C0C14, 20);
  ItemActiveColor := ColorBlend( ChangeColorSat($002C0C14, 20), clHighlight, 60 );
  TextColor := Self.Font.Color;

  AddToLog('Loading Settings');
  // Data
  PositionSettings(true);
  ProgramSettings(true);

  AddToLog('Getting Artwork Store');
  // Artwork Store
  MediaStoreLocation := AppData + 'artwork cache';
  InitiateArtworkStore;

  AddToLog('Loading Downloads');
  // Load Downloads
  DownloadSettings(true);

  AddToLog('Form.Create.ApplySettings');
  // Apply Loaded Settings
  UIForm.ApplySettings;

  // UI Preparation
  Queue_Extend.Height := 0;
  ICON_CONNECT.Font.Name := GetSegoeIconFont;
  Version_Label.Caption := 'Version ' + VERSION;

  AddToLog('Form.Create.CalculateGeneralStorage');
  // Storage
  CalculateGeneralStorage;

  AddToLog('Form.Create.PopupMenus');
  // Popup Menus
  for I := 0 to ComponentCount-1 do
    if Components[I] is TPopupMenu then
      with TPopupMenu(Components[I]) do
        for J := 0 to Items.Count-1 do
          begin
            Items[J].OnDrawItem := PopupDraw;
            Items[J].OnMeasureItem := PopupMesure;
          end;

  AddToLog('Form.Create.TokenLoginInfo');
  // Get login info
  try
    TokenLoginInfo(true);
  except
  end;

  // Load Existing session
  if (APPLICATION_ID <> '') and (LOGIN_TOKEN <> '') then
    begin
      AddToLog('Form.Create.InitiateLogin APPLICATION_ID, LOGIN_TOKEN <> NULL');
      InitiateLogin;
    end
  else
    // Login
    begin
      AddToLog('Form.Create.PrepareForLogin');
      // Prepae
      PrepareForLogin;
    end;
end;

procedure TUIForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Alt + Shift
  if (ssAlt in Shift) and (ssShift in Shift) then
    begin
      case Key of
        83: if TracksControl.Visible then
          Button_ShuffleTracksClick(Button_ShuffleTracks);
      end;
    end;

  // Alt
  if ssAlt in Shift then
    begin
      case Key of
        70: if SearchToggle.Visible then
          Search_ButtonClick(Search_Button);
        76: Action_Previous.Execute;
        77: Button_ToggleMenuClick( Button_ToggleMenu );
        78: Action_Next.Execute;
        79: Button_MiniPlayerClick( Button_MiniPlayer );
        80: Action_Play.Execute;
        82: Button_RepeatClick( Button_Repeat );
        83: Button_ShuffleClick( Button_Shuffle );
        86: if ViewModeToggle.Visible then
          begin
            if ViewStyle = TViewStyle.List then
              SetView( TViewStyle.Cover )
            else
              SetView( TViewStyle.List );

            RedrawPaintBox;
          end;
      end;
    end;

  Key := 0;
end;

procedure TUIForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  // Queue
  if QueueDraw.ClientToScreen( QueueDraw.ClientRect ).Contains( Mouse.CursorPos ) then
    QueueScroll.Position := QueueScroll.Position - WheelDelta div 20
  else
  // Draw Box
  if ActiveDraw <> nil then
    if ActiveDraw.ClientToScreen( ActiveDraw.ClientRect ).Contains( Mouse.CursorPos ) then
      ScrollPosition.Position := ScrollPosition.Position - WheelDelta div 16;
end;

procedure TUIForm.FormResize(Sender: TObject);
var
  OldMax, NewValue, NewMax: integer;
begin
  NewMax := ClientHeight div 2;
  OldMax := Queue_Extend.Constraints.MaxHeight;
  
  Queue_Extend.Constraints.MaxHeight := NewMax;
  if Queue_Extend.Height = OldMax then
    begin
      Queue_Extend.Height := NewMax;
      DestQueuePopup := Queue_Extend.Height;
    end;

  // Sizing
  SmallSize := 0;
  if Width < 1000 then
    SmallSize := 1;
  if Width < 800 then
    SmallSize := 2;
  if Width < 500 then
    SmallSize := 3;

  // Page resizing
  NewValue := HomeDraw.Width div (CoverWidth + CoverSpacing);
  if NewValue <> HomeFitItems then
    ReselectPage;

  // Buttons
  Button_Repeat.Visible := SmallSize < 1;
  Button_Shuffle.Visible := SmallSize < 1;
  MoreButtons.Visible := SmallSize < 2;

  // Panels
  UIForm.Panel1.Visible := SmallSize < 2;
  UIForm.Panel10.Visible := SmallSize < 2;
  UIForm.Panel12.Visible := SmallSize < 2;

  // Split View
  SplitView1.Locked := SmallSize > 1;
  if SplitView1.Locked and SplitView1.Opened then
    SplitView1.Opened := false;

  // Login Screen
  Robo_Background.Visible := (SmallSize < 2) and LoginBox.Visible;
  Robo_Panel.Visible := Robo_Background.Visible;

  // Menu bar
  Button_ToggleMenu.Visible := SmallSize < 2;
  Mini_Cast.Visible := SmallSize >= 2;

  // Fix Positioning
  if SmallSize = 0 then
    begin
      Button_Repeat.Left := Button_Prev.Left - Button_Prev.Width;
      Button_Shuffle.Left := Button_Next.Left + Button_Shuffle.Width;
    end;

  // Buttons 2
  if SmallSize < 3 then
    begin
      MoreButtons.Left := Button_Shuffle.Left + Button_Shuffle.Width;

      Button_MiniPlayer.Left := 0;
      Button_Volume.Left := Button_MiniPlayer.BoundsRect.Right;
      Button_Performance.Left := Button_Volume.BoundsRect.Right;
    end;

  // Extreme Tiny
  if SmallSize = 3 then
    begin
      SortModeToggle.Hide;
    end;

  // Fix All
  Button_Extend.Left := Panel7.Width;
end;

function TUIForm.GetItemCount: cardinal;
begin
  Exit( Length(DrawItems) );
end;

function TUIForm.GetPageViewType: TDataSource;
begin
  Result := TDataSource.None;

  if BareRoot = 'tracks' then
    Exit(TDataSource.Tracks);

  if BareRoot = 'viewalbum' then
    Exit(TDataSource.Albums);

  if BareRoot = 'viewartist' then
    Exit(TDataSource.Artists);

  if BareRoot = 'viewplaylist' then
    Exit(TDataSource.Playlists);
end;

function TUIForm.GetSegoeIconFont: string;
begin
  if (Screen.Fonts.IndexOf(FONT_SEGOE_FLUENT) <> -1) then
    Result := FONT_SEGOE_FLUENT
  else
    Result := FONT_SEGOE_METRO;
end;

function TUIForm.GetSort(Index: integer): integer;
begin
  Result := SortingList[Index];
end;

function TUIForm.GetTracksID: TArray<integer>;
begin
  if BareRoot = 'viewalbum' then
    Result := Albums[GetAlbum(LocationExtra.ToInteger)].TracksID;

  if BareRoot = 'viewartist' then
    Result := Artists[GetArtist(LocationExtra.ToInteger)].TracksID;

  if BareRoot = 'viewplaylist' then
    Result := Playlists[GetPlaylist(LocationExtra.ToInteger)].TracksID;

  if BareRoot = 'history' then
    Result := Playlists[GetPlaylistType('recently-played')].TracksID;
end;

function TUIForm.HasOfflineBackup: boolean;
var
  Folder: string;
begin
  Result := false;

  // Logged in offline
  if not TFile.Exists( AppData + 'login.token' ) then
    Exit;

  // Folder
  Folder := AppData + DOWNLOAD_DIR;

  // Files
  if TDirectory.Exists(Folder) then
    Result := Length( TDirectory.GetFiles(Folder) ) > 0;
end;

procedure TUIForm.HideAllUI;
begin
  LoginUIContainer.Hide;
  TitlebarCompare.Hide;
  PrimaryUIContainer.Hide;
  LoadingIcon.Hide;

  // Inside Login Box
  LoginFailed.Hide;
  LoginBox.Hide;

  // Disable verbose logging
  StatusUpdaterMs.Enabled := false;
end;

procedure TUIForm.HideLoginPopupTimer(Sender: TObject);
begin
  LoginFailed.Hide;

  HideLoginPopup.Enabled := false;
end;

procedure TUIForm.HomeDrawPaint(Sender: TObject);
var
  X, Y: integer;
  S: string;
  I, A, Start: integer;
  ARect: TRect;
begin
  ViewStyle := TViewStyle.Cover;

  with HomeDraw.Canvas do
    begin
      // Prepare
      Y := -ScrollPosition.Position;
      X := 0;

      // Font
      Font.Assign( Self.Font );

      // Albums
      for A := 1 to 4 do
        begin
          case A of
            1: S := 'Recently played albums';
            2: S := 'Favorite Tracks';
            3: S := 'Recently played tracks';
            4: S := 'From your playlists';
          end;
          Font.Size := 16;
          TextOut(X, Y, S);
          Inc(Y, TextHeight(S) + CoverSpacing);

          Start := (A-1) * HomeFitItems;
          for I := Start to Start + HomeFitItems - 1 do
            begin
              ARect := Rect(X, Y, X + CoverWidth, Y + CoverHeight);

              // Hidden
              if DrawItems[I].Hidden then
                begin
                  DrawItems[I].Bounds := Rect(0, 0, 0, 0);
                  Continue;
                end;

              // Bounds
              DrawItems[I].Bounds := ARect;
              if (I = IndexHoverID) and (Press10Stat <> 0) then
                    ARect.Inflate(-Press10Stat, -trunc(ARect.Width / ARect.Height * Press10Stat));

              // Draw
              if (Y + CoverHeight > 0) and (Y < HomeDraw.Height) then
                DrawItemCanvas(HomeDraw.Canvas, ARect, DrawItems[I].Title,
                  DrawItems[I].InfoShort, DrawItems[I].GetPicture,
                  DrawItems[I].Active, DrawItems[I].Downloaded);

              // Mext
              Inc(X, CoverWidth + CoverSpacing);
            end;

          Inc(Y, CoverHeight + CoverSpacing);
          X := 0;
        end;

      // Max Scroll
      MaxScroll := Y + ScrollPosition.Position;
      ScrollPosition.PageSize := 0;
      ScrollPosition.Max := MaxScroll - HomeDraw.Height;
    end;
end;

procedure TUIForm.PopupGeneralInfo(Sender: TObject);
begin
  // Click
  DrawItems[PopupDrawIndex].OpenInformation;
end;

procedure TUIForm.PopupGeneralViewArtist(Sender: TObject);
var
  ArtistID: integer;
  Item: TDrawableItem;
begin
  // View Artist
  case PopupSource of
    TDataSource.Tracks: ArtistID := Tracks[DrawItems[PopupDrawIndex].Index].ArtistID;
    TDataSource.Albums: ArtistID := Albums[DrawItems[PopupDrawIndex].Index].ArtistID;
    else Exit;
  end;

  // Validate
  if ArtistID = 0 then
    Exit;

  // Open
  Item.LoadSourceID(ArtistID, TDataSource.Artists);
  Item.Execute;
end;

procedure TUIForm.InitiateLogin;
var
  LoggedIn: boolean;
begin
  AddToLog('Form.InitiateLogin.PrepareLoginUI');
  // UI
  PrepareLoginUI;

  AddToLog('Form.InitiateLogin.OverrideOffline');
  // Offline Flag
  if OverrideOffline then
    begin
      InitiateOfflineMode;
      Exit;
    end;

  // Login User
  StatusUpdaterMs.Enabled := true;

  // Verbose
  WORK_STATUS := 'Contacting iBroadcast for login...';

  // Initiate Log in
  TTask.Run(procedure
    begin
      // Attempt log in
      try
        AddToLog('Attempting Login... Form.InitiateLogin.LoginUser');
        LoggedIn := LoginUser;
      except
        TThread.Synchronize(nil, procedure
          begin
            // Load offline mode if avalabile
            if HasOfflineBackup then
              begin
                AddToLog('Offline Mode... Form.InitiateLogin.InitiateOfflineMode');
                WORK_STATUS := 'Loading Offline Mode...';
                InitiateOfflineMode;
              end
            else
              // Network Error
              begin
                AddToLog('Network Error... Form.InitiateLogin.PrepareForLogin');
                PrepareForLogin;

                Error_Login.Caption := 'Can'#39't connect to the internet! Check your connection settings';
                LoginFailed.Show;
                HideLoginPopup.Enabled := true;
              end;
          end);

        Exit;
      end;

      // Logon succeded
      if LoggedIn then
        begin
          AddToLog('Logged In!');
          AddToLog('Form.InitiateLogin.ReLoadLibrary');
          // Load Library, Account, Queue
          ReLoadLibrary;

          // Show UI
          TThread.Synchronize(nil, procedure
            begin
              // Navigate to Home
              HideAllUI;
              TitlebarCompare.Show;
              PrimaryUIContainer.Show;

              AddToLog('Form.InitiateLogin.NavigatePath');
              // Home
              NavigatePath('Home');
            end);
      end
    else
      begin
        // Login unsuccessfull
        TThread.Synchronize(nil, procedure
          begin
            AddToLog('Login Unsuccessfull!');

            if LoadingIcon.Visible then
              begin
                AddToLog('Form.InitiateLogin.PrepareForLogin');
                PrepareForLogin;

                Error_Login.Caption := 'You sure that'#39's correct? The login failed!';
                LoginFailed.Show;
                HideLoginPopup.Enabled := true;
              end
            else
              // Prepare
              AddToLog('Form.InitiateLogin.PrepareForLogin');
              PrepareForLogin;
          end);
      end;
    end);
end;

procedure TUIForm.InitiateOfflineMode;
begin
  AddToLog('Form.InitiateOfflineMode');
  // Notify
  IsOffline := true;

  // Art
  ReloadArtwork;

  // Form
  Caption := Caption + ' - Offline Mode';

  // Pages
  HideAllUI;
  TitlebarCompare.Show;
  PrimaryUIContainer.Show;

  // Hide UX
  CButton3.Hide;
  CButton7.Hide;
  CButton2.Hide;

  // Load Data
  try
    LoadOfflineModeData;
  except
    Hide;
    OpenDialog('Cannot load offline mode!', 'Unfortunately a error occured and offline mode could not be loaded. Some files may be corrupt',
      ctError, [mbOk]);
    if OpenDialog('Delete data', 'Deleting all offline mode data may resolve the issue, but your songs will need to be redownloaded. Delete data?',
      ctQuestion, [mbYes, mbNo]) = mrYes then
        if OpenDialog('Final warning', 'All downloaded songs will be deleted. Confirm?', ctWarning, [mbYes, mbNo]) = mrYes then
          TDirectory.Delete( Appdata + DOWNLOAD_DIR, true );
          
    Application.Terminate;
  end;

  // Reset list
  UpdateDownloads;

  // Navigate
  NavigatePath('songs');
end;

function TUIForm.IntArrayToStr(AArray: TArray<integer>): string;
var
  I: Integer;
begin
  Result := '[';
  for I := 0 to High(AArray) do
    begin
      Result := Result + AArray[I].ToString;

      if I < High(AArray) then
        Result := Result + ',';
    end;

  Result := Result + ']';
end;

procedure TUIForm.Latest_VersionClick(Sender: TObject);
begin
  StartCheckForUpdate;
end;

procedure TUIForm.LoadItemInfo;
var
  I, A, P, Identifier: integer;
  ARoot: string;

  SelectItems, SomeArray: TArray<integer>;
  Contained: boolean;
begin
  // No items
  SetLength( DrawItems, 0 );

  // Get root
  ARoot := BareRoot;

  // Load Data                  

  (* Songs *)
  if ARoot = 'songs' then
    begin
      SetLength( DrawItems, Length(Tracks) );
      for I := 0 to High(DrawItems) do
        DrawItems[I].LoadSource(I, TDataSource.Tracks);
    end;

  (* Albums *)
  if ARoot = 'albums' then
    begin
      SetLength( DrawItems, Length(Albums) );
      for I := 0 to High(DrawItems) do
        DrawItems[I].LoadSource(I, TDataSource.Albums);
    end;

  (* Artists *)
  if ARoot = 'artists' then
    begin
      SetLength( DrawItems, Length(Artists) );
      for I := 0 to High(DrawItems) do
        DrawItems[I].LoadSource(I, TDataSource.Artists);
    end;

  (* Playlists *)
  if ARoot = 'playlists' then
    begin
      SetLength( DrawItems, Length(Playlists) );
      for I := 0 to High(DrawItems) do
        DrawItems[I].LoadSource(I, TDataSource.Playlists);
    end;

  (* Downloads *)
  if ARoot = 'downloads' then
    begin
      if DownloadsFilter = TDataSource.None then
        begin
          SetLength(SelectItems, AllDownload.Count);
          for I := 0 to AllDownload.Count - 1 do
            SelectItems[I] := AllDownload[I];

          AddItems(SelectItems, TDataSource.Tracks);
        end
      else
        begin
          // Tracks
          SetLength(SelectItems, DownloadedTracks.Count);
          for I := 0 to DownloadedTracks.Count- 1 do
            SelectItems[I] := DownloadedTracks[I].ToInteger;

          AddItems(SelectItems, TDataSource.Tracks);

          // Albums
          SetLength(SelectItems, DownloadedAlbums.Count);
          for I := 0 to DownloadedAlbums.Count- 1 do
            SelectItems[I] := DownloadedAlbums[I].ToInteger;

          AddItems(SelectItems, TDataSource.Albums);

          // Artists
          SetLength(SelectItems, DownloadedArtists.Count);
          for I := 0 to DownloadedArtists.Count- 1 do
            SelectItems[I] := DownloadedArtists[I].ToInteger;

          AddItems(SelectItems, TDataSource.Artists);

          // Playlists
          SetLength(SelectItems, DownloadedPlaylists.Count);
          for I := 0 to DownloadedPlaylists.Count- 1 do
            SelectItems[I] := DownloadedPlaylists[I].ToInteger;

          AddItems(SelectItems, TDataSource.Playlists);

          for I := 0 to High(DrawItems) do
            DrawItems[I].HiddenItem := DrawItems[I].Source <> DownloadsFilter;
        end;
    end;

  (* Search *)
  if ARoot = 'search' then
    begin
      SetLength( DrawItems, Length(Tracks) + Length(Albums) + Length(Artists) + Length(Playlists) );
      
      P := 0;
      // Tracks
      for I := 0 to High(Tracks) do
        begin        
          DrawItems[P + I].LoadSource(I, TDataSource.Tracks);
        end;
      Inc(P, Length(Tracks));

      // Albums
      for I := 0 to High(Albums) do
        begin        
          DrawItems[P + I].LoadSource(I, TDataSource.Albums);
        end;
      Inc(P, Length(Albums));

      // Albums
      for I := 0 to High(Artists) do
        begin        
          DrawItems[P + I].LoadSource(I, TDataSource.Artists);
        end;
      Inc(P, Length(Artists));

      // Playlists
      for I := 0 to High(Playlists) do
        begin        
          DrawItems[P + I].LoadSource(I, TDataSource.Playlists);
        end;
      //Inc(P, Length(Playlists));

      // Hide All
      for I := 0 to High(DrawItems) do
        DrawItems[I].HiddenSearch := true;
    end;

  (* Home Items *)
  if ARoot = 'home' then
    begin
      // Settings
      HomeFitItems := HomeDraw.Width div (CoverWidth + CoverSpacing);

      // Items
      (* Get albums!!! *)
      A := GetPlaylistType('recently-played');
      if A <> -1 then
        SomeArray := Playlists[A].TracksID
      else
        SomeArray := [];

      SetLength(SelectItems, 0);

      for I := 0 to High(SomeArray) do
        begin
          Contained := false;

          Identifier := Tracks[GetTrack(SomeArray[I])].AlbumID;
          if Identifier = -1 then
            Break;

          // Validate if it exists
          for A := 0 to High(SelectItems) do
            if SelectItems[A] = Identifier then
              Contained := true;

          // Add item
          if not Contained then
            begin
              P := Length(SelectItems);
              SetLength(SelectItems, P + 1);
              SelectItems[P] := Identifier;
            end;

          // Exit
          if Length(SelectItems) >= HomeFitItems then
            Break;
        end;

      (* Recent Albums *)
      P := 0;
      SetLength( DrawItems, HomeFitItems * 4 );
      for I := 0 to HomeFitItems - 1 do
        begin
          if P < Length(SelectItems) then
            DrawItems[I].LoadSourceID(SelectItems[P], TDataSource.Albums)
          else
            DrawItems[I].HiddenItem := true;

          Inc(P);
        end;

      (* Favorite Tracks *)
      P := 0;
      for I := HomeFitItems to HomeFitItems * 2 - 1 do
        begin
          A := GetPlaylistType('thumbsup');
          if A = -1 then
            Continue;

          SelectItems := Playlists[A].TracksID;

          if P < Length(SelectItems) then
            DrawItems[I].LoadSourceID(SelectItems[P], TDataSource.Tracks)
          else
            DrawItems[I].HiddenItem := true;

          Inc(P);
        end;

      (* History *)
      P := 0;
      for I := HomeFitItems * 2 to HomeFitItems * 3 - 1 do
        begin
          A := GetPlaylistType('recently-played');
          if A = -1 then
            Continue;

          SelectItems := Playlists[A].TracksID;

          if P < Length(SelectItems) then
            DrawItems[I].LoadSourceID(SelectItems[P], TDataSource.Tracks)
          else
            DrawItems[I].HiddenItem := true;

          Inc(P);
        end;

      (* Playlists *)
      P := 0;
      for I := HomeFitItems * 3 to HomeFitItems * 4 - 1 do
        begin
          if P < Length(Playlists) then
            DrawItems[I].LoadSource(P, TDataSource.Playlists)
          else
            DrawItems[I].HiddenItem := true;

          Inc(P);
        end;
    end;

  (* Sub View Items *)
  if InArray(ARoot, SubViewCompatibile) <> -1 then
    begin
      AddItems(GetTracksID, TDataSource.Tracks, true);
    end;

  // After load setup
  for I := 0 to High(DrawItems) do
    with DrawItems[I] do
      begin
        Title := StringReplace(Title, '&', '&&', [rfReplaceAll]);
        InfoShort := StringReplace(InfoShort, '&', '&&', [rfReplaceAll]);
        InfoLong := StringReplace(InfoLong, '&', '&&', [rfReplaceAll]);
      end;
end;

procedure TUIForm.LoadOfflineModeData;
var
  Folder, Repo: string;
  FileName: string;
  Files: TArray<string>;
  ST: TStringList;

  I, ValueID: Integer;
begin
  // Load Folder
  Folder := AppData + DOWNLOAD_DIR;
  
  // Load Tracks
  Files := TDirectory.GetFiles( Folder, '*.mp3' );
  SetLength(Tracks, Length(Files));
  for I := 0 to High(Files) do
    begin
      FileName := Files[I];
      try
        ValueID := ObtainIDFromFileName(FileName);
      except
        Continue;
      end;

      Tracks[I].ID := ValueID;
      Tracks[I].Title := ExtractFileName(FileName);

      // Data
      FileName := ChangeFileExt(FileName, '.txt');
      if TFile.Exists(FileName) then
        begin
          ST := TStringList.Create;
          try
            ST.LoadFromFile(FileName);

            with Tracks[I] do
              begin
                Title := ST[0];
                Year := ST[1].ToInteger;
                Genre := ST[2];
                LengthSeconds := ST[3].ToInteger;
                FileSize := ST[4].ToInteger;
                Rating := ST[5].ToInteger;
                Plays := ST[6].ToInteger;
                AudioType := ST[7];
              end;
          finally
            ST.Free;
          end;
        end;

      // Artwork
      FileName := ChangeFileExt(Filename, '.jpeg');
      if TFile.Exists(FileName) then
        begin
          Tracks[I].CachedImage := TJpegImage.Create;
          Tracks[I].CachedImage.LoadFromFile(FileName);
        end
          else
            Tracks[I].CachedImage := DefaultPicture;
    end;

  // Albums
  Repo := Folder + 'albums\';
  SetLength(Files, 0);
  if TDirectory.Exists(Repo) then
    Files := TDirectory.GetFiles( Repo, '*.txt' );
  SetLength(Albums, Length(Files));
  for I := 0 to High(Files) do
    begin
      ST := TStringList.Create;
      try
        ST.LoadFromFile(Files[I]);

        with Albums[I] do
          begin
            ID := ChangeFileExt(ExtractFileName(Files[I]), '').ToInteger;
          
            AlbumName := ST[0];
            TracksID := StrToIntArray(ST[1]);
            ArtistID := ST[2].ToInteger;
            Rating := ST[3].ToInteger;
            Year := ST[4].ToInteger;
          end;
      finally
        ST.Free;
      end;
    end;

  // Artists
  Repo := Folder + 'artists\';    
  SetLength(Files, 0);
  if TDirectory.Exists(Repo) then
    Files := TDirectory.GetFiles( Repo, '*.txt' );
  SetLength(Artists, Length(Files));
  for I := 0 to High(Files) do
    begin
      ST := TStringList.Create;
      try
        ST.LoadFromFile(Files[I]);

        with Artists[I] do
          begin
            ID := ChangeFileExt(ExtractFileName(Files[I]), '').ToInteger;
          
            ArtistName := ST[0];
            TracksID := StrToIntArray(ST[1]);
            Rating := ST[2].ToInteger;
          end;
      finally
        ST.Free;
      end;
    end;

  // Playlists
  Repo := Folder + 'playlists\';    
  SetLength(Files, 0);
  if TDirectory.Exists(Repo) then
    Files := TDirectory.GetFiles( Repo, '*.txt' );
  SetLength(Playlists, Length(Files));
  for I := 0 to High(Files) do
    begin
      ST := TStringList.Create;
      try
        ST.LoadFromFile(Files[I]);

        with Playlists[I] do
          begin
            ID := ChangeFileExt(ExtractFileName(Files[I]), '').ToInteger;
          
            Name := ST[0];
            TracksID := StrToIntArray(ST[1]);
            PlaylistType := ST[2];
            Description := ST[3];
          end;
      finally
        ST.Free;
      end;
    end;
end;

procedure TUIForm.LoadView(APageRoot: string);
var
  I: Integer;
begin
  for I := 0 to High(SavedViews) do
    if SavedViews[I].PageRoot = APageRoot then
      begin
        SetView( SavedViews[I].View, true );
        Exit;
      end;

  AddView(APageRoot, ViewStyle);
end;

procedure TUIForm.LoginUIContainerResize(Sender: TObject);
begin
  // Realign components
  BoxContainer.Left := LoginUIContainer.Width div 2 - BoxContainer.Width div 2;
  BoxContainer.Top := Status_Work.Top + Status_Work.Height * 2;

  CImage6.Left := 0;
  CImage6.Top := 0;

  CImage6.Width := LoginUIContainer.Width;
  CImage6.Height := LoginUIContainer.Height;

  if LoginUIContainer.Visible then
    BoxContainer.Repaint;
end;

procedure TUIForm.NavigatePath(Path: String; AddHistory: boolean);
var
  Root, MetaData: string;
  P: integer;
  Valid: integer;
  I: Integer;
begin
  AddToLog('Form.NavigatePath(%S, %B)');
  Root := Path;
  MetaData := '';

  // Already there
  if Location = Path then
    Exit;

  // Meta
  P := Pos(':', Path);
  if P <> 0 then
    begin
      Root := Copy( Path, 1, P -1);
      MetaData := Copy( Path, P + 1, Length(Path) );
    end;

  LocationExtra := MetaData;

  // Validate
  Valid := -1;
  for I := 0 to High(PlayCaptions) do
    if AnsiLowerCase(Root) = AnsiLowerCase(PlayCaptions[I]) then
      begin
        Valid := I;
        Break;
      end;

  if Valid = -1 then
    Exit;

  // Name
  Page_Title.Caption := PlayCaptions[Valid];

  // Set Location
  Location := Path;
  LocationROOT := ROOT;
  BareRoot := AnsiLowerCase(ROOT);

  // History
  if AddHistory then
    begin
      I := Length(PageHistory);
      SetLength(PageHistory, I + 1);
      with PageHistory[I] do
        begin
          Location := Path;

          if Length(PageHistory) > 1 then
            PageHistory[I - 1].ScrollPrev := ScrollPosition.Position;
        end;
    end;

  CheckPages;

  // Scroll (after history!)
  SetScroll(0);

  // View Compatability
  ReselectPage;
end;

function TUIForm.ObtainIDFromFileName(FileName: string): integer;
begin
  FileName := ExtractFileName(FileName);
  FileName := ChangeFileExt(FileName, '');  

  Result := FileName.ToInteger;
end;

procedure TUIForm.OpenFromTray;
begin
  Self.Show;
  HiddenToTray := false;
end;

procedure TUIForm.QueueNext;
begin
  if QueuePos < PlayQueue.Count - 1 then
    begin
      Inc(QueuePos);

      QueuePlay;
    end
      else
        if (RepeatMode = TRepeat.All) and (PlayQueue.Count > 0) then
          begin
            QueuePos := 0;

            QueuePlay;
          end;

  // Update
  QueueUpdated;
end;

function OpenDialog(Title, Text: string; AType: CMessageType;
  Buttons: TMsgDlgButtons): integer;
var
  Dialog: CDialog;
begin
  Dialog := CDialog.Create;

  // Text
  Dialog.Title := Title;
  Dialog.Text := Text;

  // Colors & Design
  Dialog.EnableFooter := false;
  Dialog.GlobalSyncTogle := false;

  Dialog.FormColor := UIForm.Color;
  Dialog.TextFont.Color := UIForm.Font.Color;

  Dialog.ButtonDesign.FlatButton := true;
  Dialog.ButtonDesign.FlatComplete := true;

  // Dialog
  Dialog.Buttons := Buttons;
  Dialog.Kind := AType;

  // Execute
  Result := Dialog.Execute;

  Dialog.Free;
end;

procedure AddToLog(ALog: string);
var
  F: TextFile;
  AFile,
  ADate: string;
begin
  // Use legacy writing for TextFile.Append
  if EnableLogging then
    begin
      ADate := DateTimeToStr(Now);
      AFile := ReplaceWinPath('shell:desktop\iBroadcast Log.txt');

      AssignFile(F, AFile);
      if TFile.Exists(AFile) then
        Append(F)
      else
        ReWrite(F);

      WriteLn(F, ADate + ': ' + ALog);

      // Close
      CloseFile(F);
    end;
end;

procedure TUIForm.QueueDownGoTimer(Sender: TObject);
begin
  QueueScroll.Position := QueueScroll.Position + TTimer(Sender).Tag;
end;

procedure TUIForm.QueueDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if QueueHover <> -1 then
    begin
      QueueMouseDown := true;
      QueueCursorDown := Point(X, Y);
      QueueDragItem := QueueHover
    end;
end;

procedure TUIForm.QueueDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  I: Integer;
  OffsetTrigger: integer;
  RespP: TPoint;
begin
  QueueHover := -1;
  for I := 0 to PlayQueue.Count - 1 do
    if I < Length(QRects) then
      if QRects[I].Contains(Point(X, Y)) then
          begin
            QueueHover := I;
            Break;
          end;

  // Cursor
  if QueueHover <> -1 then
    QueueDraw.Cursor := crHandPoint
  else
    QueueDraw.Cursor := crDefault;

  // Enable Drag
  QueueCursor := Point(X, Y);
  if not QueueDragPress and QueueMouseDown and (QueueCursorDown.Distance(QueueCursor) > QListHeight div 2) then
    begin
      QueueDragPress := true;

      QueuePos1 := QueueHover;
      QueuePos2 := QueueHover;
    end;

  // Drag
  if QueueDragPress then
    begin
      // Anim
      if (QueueHover <> QueuePos2) and (QueueHover <> -1) then
        begin
          QueuePos2 := QueueHover;

          QueueSwitchAnimation.Enabled := true;
        end;

      // Scroll
      OffsetTrigger := round(15/100 * QueueDraw.Height);
      QueueDownGo.Enabled := (Y > QueueDraw.Height - OffsetTrigger) or (Y < OffsetTrigger);
      if QueueDownGo.Enabled then
        begin
          if (Y <  QueueDraw.Height div 2) then
            begin
              RespP := QueueDraw.ClientToScreen(Point(0, OffsetTrigger));
              QueueDownGo.Tag := Mouse.CursorPos.Y - RespP.Y
            end
          else
            begin
              RespP := QueueDraw.ClientToScreen(Point(0, QueueDraw.Height - OffsetTrigger));
              QueueDownGo.Tag := Mouse.CursorPos.Y - RespP.Y
            end;
        end;
      
      // Draw
      QueueDraw.Repaint;
    end;

  // Draw Button
  if (QueueCursor.X > QueueDraw.Width - QListHeight) or DrawnQueueButtons then
    begin
      DrawnQueueButtons := false;

      QueueDraw.Repaint;
    end;
end;

procedure TUIForm.QueueDrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Drag
  if QueueDragPress then
    begin
      QueueDragPress := false;
      QueueDownGo.Enabled := false;
      
      // Switch
      PlayQueue.Move(QueueDragItem, QueuePos2);
      RecalculateQueuePos;


      // Paint
      QueueDraw.Repaint;
    end
  else
    // Click
    begin
      if (QueueCursor.X > QueueDraw.Width - QListHeight) then
        (* Delete *)
        DeleteQueue( QueueHover )
          else
            if QueueHover <> -1 then
              (* Play song *)
              QueueSetTo(QueueHover);
    end;

  // Mouse
  QueueMouseDown := false;
end;

procedure TUIForm.QueueDrawPaint(Sender: TObject);
var
  S: string;
  ARect, BRect: TRect;
  ItemHeight, TopDraw, ColonAlloc, ColonLeft,
  AHeight, AWidth: integer;
  Y, I, A, C: integer;

  Picture: TJpegImage;
  BackColor, ItemColor, ActiveItemColor,
  FontColor, ActiveFontColor: TColor;

  ItemToDraw: TDrawableItem;
begin
  with QueueDraw.Canvas do
    begin
      // Small Size
      if ClipRect.Height = 0 then
        Exit;

      // Data
      SetLength(QRects, PlayQueue.Count);

      // No items
      if PlayQueue.Count = 0 then
        begin
          Font.Assign(Self.Font);
          Font.Size := 28;
          Font.Name := GetSegoeIconFont;
          ARect := ClipRect;
          ARect.Height := ARect.Height div 2;

          S := #$E90B;
          TextRect( ARect, S, [tfBottom, tfCenter, tfSingleLine]);

          Font.Assign(Self.Font);
          Font.Size := 20;
          ARect := ClipRect;
          ARect.Top := ARect.Height div 2;

          S := 'Your queue is empty';
          TextRect( ARect, S, [tfTop, tfCenter]);

          Exit;
        end;

      // Draw
      TopDraw := trunc(TextHeight('ABC') * 1.2);

      ItemHeight := QListHeight + QListSpacing;

      AWidth := QueueDraw.Width;
      AHeight := QueueDraw.Height - TopDraw;

      // Sizing
      if SmallSize > 2 then
        begin
          ColonLeft := QListSpacing;
          ColonAlloc := (AWidth - ColonLeft - QListHeight)
        end
      else
        begin
          ColonLeft := QListHeight + QListSpacing;
          ColonAlloc := (AWidth - ColonLeft - QListHeight) div 4
        end;

      // Colors
      BackColor := Queue_Extend.Color;
      ItemColor := ChangeColorSat( BackColor, 20 );
      ActiveItemColor := ColorBlend(ItemColor, clHighlight, 80);
      FontColor := FN_COLOR;
      ActiveFontColor := ColorBlend(FontColor, clHighlight, 80);

      // Prepare
      Y := -QueueScroll.Position + TopDraw;

      Brush.Style := bsSolid;
      Pen.Style := psClear;

      // Begin Drawing each element
      for I := 0 to PlayQueue.Count - 1 do
        begin
          // Clear Rect
          QRects[I] := Rect(0,0,0,0);
        
          if (Y + ItemHeight > 0) and (Y < AWidth) then
            begin
              (* item Height without Spacing! *)
              // Skip
              if QueueDragPress then
                begin
                  (* Spacing 2 *)
                  if (I = QueuePos2) then
                    Inc(Y, trunc((QueueSwitchProgress / 100) * (QListHeight + QListSpacing)));

                  if (I = QueuePos1) then
                    (* Spacing *)
                    Inc(Y, trunc(((100-QueueSwitchProgress) / 100) * (QListHeight + QListSpacing)));

                  if (I = QueueDragItem) then
                    (* Skip *)
                    Continue;
                end;

              // Fill Color
              ARect := Rect(0, Y, AWidth, Y + QListHeight);

              if I = QueuePos then
                Brush.Color := ActiveItemColor
              else
                Brush.Color := ItemColor;

              RoundRect( ARect, QListRadius, QListRadius );

              // Rect
              QRects[I] := ARect;

              // Get Data
              ItemToDraw.LoadSource(PlayQueue[I], TDataSource.Tracks);

              // Text Style
              Font.Assign( Self.Font );
              Font.Name := 'Segoe UI';
              Font.Color := FontColor;
              Font.Size := 14;

              // Text
              if I = QueuePos then
                Font.Color := ActiveFontColor
              else
                Font.Color := FontColor;

              for A := 0 to 3 do
                begin
                  ARect := Rect( ColonLeft + ColonAlloc * A, Y,
                    ColonLeft + (A+1) * ColonAlloc, Y + QListHeight);

                  case A of
                    0: S := ItemToDraw.Title;
                    1: begin
                      C := GetAlbum(Tracks[ItemToDraw.Index].AlbumID);
                      if C <> -1 then
                        S := Albums[C].AlbumName;
                    end;
                    2: begin
                      C := GetArtist(Tracks[ItemToDraw.Index].ArtistID);
                      if C <> -1 then
                        S := Artists[C].ArtistName;
                    end;
                    3: S := CalculateLength(Tracks[ItemToDraw.Index].LengthSeconds);
                  end;

                  S := TrimmifyText(QueueDraw.Canvas, S, ARect.Width - QListSpacing);

                  TextRect(ARect, S, [tfSingleline, tfVerticalCenter]);
                end;

              // Buttons - Delete Icon
              if (I = QueueHover) and (QueueCursor.X > AWidth - QListHeight) then
                begin
                  DrawnQueueButtons := true;

                  Font.Size := 20;
                  Font.Color := FN_COLOR;
                  Font.Name := GetSegoeIconFont;
                  S := #$E74D;
                  Brush.Style := bsClear;

                  ARect := Rect( AWidth - QListHeight, Y, AWidth, Y + QListHeight);
                  BRect := ARect;

                  A := Trunc(Sqrt( 2 * Power(TextHeight(S), 2) ));
                  A := (BRect.Width - A) div 2;
                  BRect.Inflate(-A, -A);

                  GDICircle(BRect, GetRGB(255, 0, 0).MakeGDIBrush, nil);

                  TextRect(ARect, S, [tfSingleline, tfCenter, tfVerticalCenter]);
                end;


              // Picture
              if SmallSize < 3 then
                begin
                  ARect := Rect(0, Y, QListHeight, Y + QListHeight);

                  Picture := ItemToDraw.GetPicture;
                  if Picture <> nil then
                    StretchDraw(ARect, Picture, 255);
                end;
            end;

          // Next
          Inc(Y, ItemHeight);
        end;

      // Draw Another
      if QueueDragPress then
        begin
          Brush.Color := ChangeColorSat(ActiveItemColor, 120);

          ARect := Rect(0, QueueCursor.Y - QListHeight div 2, AWidth, QueueCursor.Y + QListHeight div 2);
          RoundRect( ARect, QListRadius, QListRadius );

          // Picture
          Picture := Tracks[PlayQueue[QueueDragItem]].GetArtwork;
            if Picture <> nil then
              GDIGraphicRound(Picture, Rect(ARect.Left, ARect.Top, ARect.Left + ARect.Height, ARect.Bottom), QListRadius);

          // Text
          Font.Color := clBlack;
          Font.Name := 'Segoe UI Bold';
          ARect.Left := ARect.Height + QListSpacing;

          S := Tracks[PlayQueue[QueueDragItem]].Title;
          TextRect(ARect, S, [tfSingleline, tfVerticalCenter]);

          Font.Size := 20;
          Font.Name := GetSegoeIconFont;
          S := #$E759;
          ARect.Right := ARect.Right - TextWidth(S);
          TextRect(ARect, S, [tfSingleline, tfRight, tfVerticalCenter]);
        end;

      // Top Line
      Brush.Color := BackColor;
      FillRect( Rect(0, 0, AWidth, TopDraw) );

      Pen.Style := psSolid;
      Pen.Color := clWhite;
      MoveTo(0, TopDraw);
      LineTo(AWidth, TopDraw);

      // Top Text
      for I := 0 to 3 do
        begin
          Font.Assign( Self.Font );
          Font.Name := 'Segoe UI Semibold';
          Font.Color := FontColor;
          Font.Size := 14;

          ARect := Rect( ColonLeft + ColonAlloc * I, 0,
            ColonLeft + (I+1) * ColonAlloc, TopDraw);

          case I of
            0: S := 'Title';
            1: S := 'Album';
            2: S := 'Artist';
            3: S := 'Length';
          end;

          TextRect(ARect, S, [tfTop]);
        end;
    end;

  // Scroll Fix
  QueueScroll.Max := (ItemHeight * PlayQueue.Count);

  if QueueScroll.Max > AHeight then
    QueueScroll.Max := QueueScroll.Max - AHeight div 2;
end;

procedure TUIForm.Player_PositionChange(Sender: CSlider; Position, Max,
  Min: Integer);
begin
  if Position < Player.Position then
    SeekPoint := Position
  else
    begin
      Player.Position := Position;
      SeekPoint := -1;
    end;
end;

procedure TUIForm.Player_PositionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsSeeking := true;
end;

procedure TUIForm.Player_PositionMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if SeekPoint <> -1 then
    begin
      Player.Position := SeekPoint;
      NeedSeekUpdate := true;
    end
      else
        IsSeeking := false;
end;

procedure TUIForm.PopupDraw(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean);
var
  Text: string;
  TextR: TRect;
  Radius: integer;
  Menu: TMenuItem;
begin
  // Draw
  with ACanvas do
    begin
      // Get Data
      Menu := TMenuItem(Sender);

      // Hover
      if Selected then
        begin
          Brush.Color := ChangeColorSat(BG_COLOR, 20);
          Radius := 20;
        end
      else
        begin
          Brush.Color := BG_COLOR;
          Radius := 0;
        end;

      // Fill
      Pen.Color := Brush.Color;
      RoundRect( ARect, Radius, Radius );

      // Line
      if Menu.IsLine then
        begin
          Pen.Style := psSolid;
          Pen.Color := FN_COLOR;
          MoveTo(10, ARect.Top + ARect.Height div 2);
          LineTo(ARect.Width - 10, ARect.Top + ARect.Height div 2);

          Exit;
        end;

      // Rect
      TextR := ARect;

      // Icon
      if Menu.Hint <> '' then
        begin
          TextR := ARect;
          TextR.Width := ARect.Height;

          Font.Assign( Self.Font );
          Font.Size := 16;
          Font.Name := GetSegoeIconFont;

          Text := Menu.Hint;
          TextRect( TextR, Text, [tfSingleLine, tfCenter, tfVerticalCenter]);

          TextR := ARect;
          TextR.Left := TextR.Left + TextR.Height + 5;
        end;

      // Text
      Font.Assign( Self.Font );
      if Menu.Default then
        Font.Style := [fsBold];
      Text := Menu.Caption;
      DrawTextRect( ACanvas, TextR, Text, [tffVerticalCenter], 5);
    end;
end;

procedure TUIForm.PopupGeneralAddTracks(Sender: TObject);
var
  ATracks: TArray<integer>;
  AIndex: integer;
  NextPlay: boolean;
  I, TrackID: Integer;
begin
  // Empty
  NextPlay := (PlayQueue.Count = 0) and (Player.PlayStatus <> psPlaying);

  // Add Tracks
  AIndex := DrawItems[PopupDrawIndex].Index;
  case PopupSource of
    TDataSource.Tracks: ATracks := [Tracks[AIndex].ID];
    TDataSource.Albums: ATracks := Albums[AIndex].TracksID;
    TDataSource.Artists: ATracks := Artists[AIndex].TracksID;
    TDataSource.Playlists: ATracks := Playlists[AIndex].TracksID;
  end;

  // Empty
  if Length(ATracks) = 0 then
    Exit;

  // Add
  for I := 0 to High(ATracks) do
    begin
      TrackID := GetTrack(ATracks[I]);
      if TrackID <> -1 then
        AddQueue( TrackID );
    end;

  // Play
  if NextPlay then
    begin
      QueuePos := 0;
      QueuePlay;
    end;
end;

procedure TUIForm.PopupGeneralClick(Sender: TObject);
begin
  // Click
  DrawItems[PopupDrawIndex].Execute;
end;

procedure TUIForm.PopupGeneralDownload(Sender: TObject);
begin
  // Download
  DrawItems[PopupDrawIndex].ToggleDownloaded;

  // Update
  UIForm.UpdateDownloads;
end;

procedure TUIForm.PopupMesure(Sender: TObject; ACanvas: TCanvas; var Width,
  Height: Integer);
begin
  // Mesure
  if not TMenuItem(Sender).IsLine then
    Inc(Height, 15);


  // Width
  Width := Canvas.TextWidth(TMenuItem(Sender).Caption) + 20;
  if TMenuItem(Sender).Hint <> '' then
    Width := Width + height;
end;

procedure TUIForm.Popup_TrayPopup(Sender: TObject);
begin
  // Minimise Button
  if Visible then
    Tray_Toggle.Caption := 'Minimise to Tray'
  else
    Tray_Toggle.Caption := 'Open from Tray';

  Tray_Toggle.Visible := not MiniPlayer.Visible;
  N12.Visible := Tray_Toggle.Visible;
end;

procedure TUIForm.PositionSettings(Load: boolean);
const
  // Catrgories
  SECT = 'Form Location';
var
  OPT: TIniFile;
  FileName: string;
  AState: TWindowState;
begin
  FileName := AppData + 'positions.ini';
  if Load then
    // Load Data
    begin
      if not TFile.Exists(FileName) then
        Exit;

      OPT := TIniFIle.Create(FileName);
      try
        // Track Containers
        AState := TWindowState(OPT.ReadInteger(SECT, 'State', Integer(wsNormal)));
        if AState = wsMinimized then
          AState := wsNormal;

        if AState = wsNormal then
          begin
            Width := OPT.ReadInteger(SECT, 'Width', Width);
            Height := OPT.ReadInteger(SECT, 'Height', Height);
          end;
      finally
        OPT.Free;
      end;
    end
  else
    // Save Data
    begin
      OPT := TIniFIle.Create(FileName);
      try
        // Track Containers
        OPT.WriteInteger(SECT, 'State', integer(WindowState));
        OPT.WriteInteger(SECT, 'Left', Left);
        OPT.WriteInteger(SECT, 'Top', Top);
        OPT.WriteInteger(SECT, 'Width', Width);
        OPT.WriteInteger(SECT, 'Height', Height);
      finally
        OPT.Free;
      end;
    end;
end;

procedure TUIForm.PlaySong(Index: cardinal; StartPlay: boolean);
var
  LocalName: string;
  Local: boolean;
begin
  // Play State
  PlayID := Tracks[Index].ID;
  PlayIndex := Index;

  // Is offline?
  LocalName := AppData + DOWNLOAD_DIR + PlayID.ToString + '.mp3';
  Local := TFile.Exists( LocalName );

  // Play
  if Local then
    Player.OpenFile( LocalName )
  else
    Player.OpenURL( STREAMING_ENDPOINT + Tracks[Index].StreamLocations );

  // Offline
  if not Player.IsFileOpen then
    begin
      Player.Pause;
      IsOffline := true;

      OpenDialog('It seems you are offline', 'There seems to be a problem loading this song.');
      Exit;
    end
      else
      // Back online
      if not Local then
        IsOffline := false;

  // Data
  if StartPlay then
    Player.Play;

  // Update
  SongUpdate;
end;

procedure TUIForm.PrepareForLogin;
begin
  AddToLog('Form.PrepareForLogin.HideAllUI');
  HideAllUI;

  LoginUIContainer.Show;
  LoginBox.Show;
  Status_Work.Caption := 'Please login below';

  AddToLog('Form.PrepareForLogin.OnResize');
  // Resize Ui
  OnResize(Self);
end;

procedure TUIForm.PrepareLoginUI;
begin
  AddToLog('Form.PrepareLoginUI');
  // UI
  if not LoginUIContainer.Visible then
      begin
        HideAllUI;
        LoginUIContainer.Show;
      end;
    LoginBox.Hide;
    LoadingIcon.Show;
end;

procedure TUIForm.PrepareStartupShortcut(Sender: CCheckBox;
  State: TCheckBoxState);
var
  Start: boolean;
  FileName: string;
begin
  Start := State = cbChecked;

  FileName := IncludeTrailingPathDelimiter(GetUserShellLocation(TUserShellLocation.shlStartup)) + 'Cods iBroadcast.lnk';
  if Start then
    CreateShortcut(Application.ExeName, FileName, 'Cods iBroadcast Player', '-tray')
  else
    if TFile.Exists(FileName) then
      TFile.Delete(FileName);
end;

procedure TUIForm.PressNowTimer(Sender: TObject);
begin
  Inc(Press10Stat, 2);

  // Draw
  RedrawPaintBox;

  // Stop
  if Press10Stat > 9 then
    PressNow.Enabled := false;
end;

procedure TUIForm.PreviousPage;
var
  Index: integer;
begin
  // Navigate
  Index := Length(PageHistory) - 2;
  if Index >= 0 then
    begin
      with PageHistory[Index] do
        begin
          NavigatePath( Location, false );
          SetScroll(ScrollPrev);
        end;

      SetLength(PageHistory, High(PageHistory));
    end;

  CheckPages;
end;

procedure TUIForm.QueuePrev;
begin
  if QueuePos > 0 then
    begin
      Dec(QueuePos);

      QueuePlay;
    end;

  // Update
  QueueUpdated;
end;

procedure TUIForm.QueueScrollChange(Sender: TObject);
begin
  QueueDraw.Repaint;
end;

procedure TUIForm.QueueSettings(Load: boolean);
var
  FileName: string;
  ST: TStringList;
  I, ATrack, APosition: Integer;
begin
  FileName := AppData + 'lastqueue.ini';
  if Load then
    // Load Data
    begin
      if not TFile.Exists(FileName) then
        Exit;

      ST := TStringList.Create;
      try
        // Track Containers
        ST.LoadFromFile(FileName);

        // Get Pos
        try
          APosition := ST[0].ToInteger;
        except
          APosition := -1;
        end;

        // Load Tracks
        if ST.Count > 1 then
          for I := 1 to ST.Count - 1 do
            begin
              // Convert
              try
                ATrack := ST[I].ToInteger;
              except
                Break;
              end;

              // Validate
              ATrack := GetTrack(ATrack);
              if ATrack = -1 then
                Continue;

              // Add
              AddQueue(ATrack, false);
            end;

        // Set Position
        if APosition <> -1 then
          begin
            QueuePos := APosition;
            PlaySong( PlayQueue[QueuePos], false );
          end;
      finally
        ST.Free;
      end;
    end
  else
    // Save Data
    begin
      // No Queue
      if PlayQueue.Count = 0 then
        begin
          if TFile.Exists(FileName) then
            TFile.Delete(FileName);

          Exit;
        end;

      // Create
      ST := TStringList.Create;
      try
        // Write Position
        ST.Add(QueuePos.ToString);

        // Track Containers
        for I := 0 to PlayQueue.Count - 1 do
          ST.Add(Tracks[PlayQueue[I]].ID.ToString);

        // Write
        ST.SaveToFile(FileName);
      finally
        ST.Free;
      end;
    end;
end;

procedure TUIForm.QueueSetTo(Index: integer; StartPlay: boolean);
begin
  if (Index >= 0) and (Index < PlayQueue.Count) and (QueuePos <> Index) then
    begin
      QueuePos := Index;

      if StartPlay then
        QueuePlay;
    end;

  QueueUpdated;
end;

procedure TUIForm.QueueSwitchAnimationTimer(Sender: TObject);
begin
  Inc(QueueSwitchProgress, 5);
  if QueueSwitchProgress > 100 then
    QueueSwitchProgress := 100;
  QueueDraw.Repaint;

  if QueueSwitchProgress = 100 then
    begin
      QueueSwitchAnimation.Enabled := false;

      QueuePos1 := QueuePos2; 
      
      QueueSwitchProgress := 0;
    end;
end;

procedure TUIForm.QueueUpdated;
begin
  AddToLog('Form.QueueUpdated');
  QueueDraw.Repaint;
end;

procedure TUIForm.Quick_SearchChange(Sender: TObject);
begin
  if not (SearchToggle.Visible and SearchBox_Hold.Visible) then
    Exit;

  FiltrateSearch( TEdit(Sender).Text );

  RedrawPaintBox;
end;

procedure TUIForm.Quick_SearchExit(Sender: TObject);
begin
  SearchBox_Hold.Hide;
  Search_Button.Show;
end;

procedure TUIForm.Quick_SearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then
    begin
      Self.FiltrateSearch('');
      RedrawPaintBox;

      Quick_SearchExit(Quick_Search);
    end;
end;

procedure TUIForm.ProgramSettings(Load: boolean);
const
  // Catrgories
  CAT_GENERAL = 'GeneralSettings';
  CAT_MINIPLAYER = 'MiniPlayer';
var
  OPT: TIniFile;
  FileName: string;
  I: Integer;
begin
  FileName := AppData + 'settings.ini';
  if Load then
    // Load Data
    begin
      if not TFile.Exists(FileName) then
        Exit;

      OPT := TIniFIle.Create(FileName);
      try
        // Views
        for I := 0 to High(ViewCompatibile) do
          if OPT.ValueExists('Views', ViewCompatibile[I]) then
            AddView(ViewCompatibile[I], TViewStyle(OPT.ReadInteger('Views', ViewCompatibile[I], 0)) );

          Setting_Graph.Checked := OPT.ReadBool(CAT_GENERAL, 'Enable Graph', true);
          SplitView1.Opened := OPT.ReadBool(CAT_GENERAL, 'Menu Opened', true);
          Settings_CheckUpdate.Checked := OPT.ReadBool(CAT_GENERAL, 'Audo Update Check', true);
          ArtworkID := OPT.ReadInteger(CAT_GENERAL, 'Artwork Id', 0);
          ArtworkStore := OPT.ReadBool(CAT_GENERAL, 'Artowork Store', true);
          Setting_ArtworkStore.Checked := ArtworkStore;
          THREAD_MAX := OPT.ReadInteger(CAT_GENERAL, 'Thread Count', 15);
          Settings_Threads.Position := THREAD_MAX;
          Setting_DataSaver.Checked := OPT.ReadBool(CAT_GENERAL, 'Data Saver', false);
          Setting_PlayerOnTop.Checked := OPT.ReadBool(CAT_GENERAL, 'Mini player on top', false);
          Settings_DisableAnimations.Checked := OPT.ReadBool(CAT_GENERAL, 'Disable Animations', false);
          Setting_StartWindows.Checked := OPT.ReadBool(CAT_GENERAL, 'Start with windows', false);
          Setting_TrayClose.Checked := OPT.ReadBool(CAT_GENERAL, 'Minimise to tray', false);
          Setting_QueueSaver.Checked := OPT.ReadBool(CAT_GENERAL, 'Save Queue', false);

          TransparentIndex := OPT.ReadInteger(CAT_MINIPLAYER, 'Opacity', 0);
      finally
        OPT.Free;
      end;
    end
  else
    // Save Data
    begin
      OPT := TIniFIle.Create(FileName);
      try
        // Views
        for I := 0 to High(SavedViews) do
          OPT.WriteInteger('Views', SavedViews[I].PageRoot, integer(SavedViews[I].View));

        OPT.WriteBool(CAT_GENERAL, 'Enable Graph', Setting_Graph.Checked);
        OPT.WriteBool(CAT_GENERAL, 'Menu Opened', SplitView1.Opened);
        OPT.WriteBool(CAT_GENERAL, 'Audo Update Check', Settings_CheckUpdate.Checked);
        OPT.WriteInteger(CAT_GENERAL, 'Artwork Id', ArtworkID);
        OPT.WriteBool(CAT_GENERAL, 'Artowork Store', ArtworkStore);
        OPT.WriteInteger(CAT_GENERAL, 'Thread Count', THREAD_MAX);
        OPT.WriteBool(CAT_GENERAL, 'Data Saver', Setting_DataSaver.Checked);
        OPT.WriteBool(CAT_GENERAL, 'Mini player on top', Setting_PlayerOnTop.Checked);
        OPT.WriteBool(CAT_GENERAL, 'Disable Animations', Settings_DisableAnimations.Checked);
        OPT.WriteBool(CAT_GENERAL, 'Start with windows', Setting_StartWindows.Checked);
        OPT.WriteBool(CAT_GENERAL, 'Minimise to tray', Setting_TrayClose.Checked);
        OPT.WriteBool(CAT_GENERAL, 'Save Queue', Setting_QueueSaver.Checked);

        OPT.WriteInteger(CAT_MINIPLAYER, 'Opacity', TransparentIndex);
      finally
        OPT.Free;
      end;
    end;
end;

procedure TUIForm.QueuePlay;
begin
  PlaySong( PlayQueue[QueuePos] );
end;

procedure TUIForm.QueuePopupAnimateTimer(Sender: TObject);
begin
  Inc(QueueAnProgress, 10);

  // Anim
  if DestQueuePopup > 0 then
    Queue_Extend.Height := trunc(Power(Queue_Extend.Constraints.MaxHeight, QueueAnProgress/100) )
  else
    Queue_Extend.Height := Queue_Extend.Constraints.MaxHeight - trunc(Power(Queue_Extend.Constraints.MaxHeight, QueueAnProgress/100) );

  // Realign
  Queue_Extend.Top := Song_Player.Top + Song_Player.Height;

  // End
  if QueueAnProgress >= 100 then
    begin
      Queue_Extend.Height := DestQueuePopup;

      PauseDrawing := false;
      QueuePopupAnimate.Enabled := false;
    end;
end;

procedure TUIForm.RecalculateQueuePos;
var
  I: integer;
begin
  for I := 0 to PlayQueue.Count - 1 do
    if Tracks[PlayQueue[I]].ID = PlayID then
      begin
        QueuePos := I;
        Break;
      end;
end;

procedure TUIForm.RecalibrateScroll;
var
  FitX, FitY: integer;
  PageSize, SmallChange: integer;
  ItemCount: integer;
begin
  if ActiveDraw = nil then
    Exit;

  // Count
  ItemCount := (GetItemCount);

  // Calculations based on view mode
  if ViewStyle = TViewStyle.Cover then
    begin
      FitX := (ActiveDraw.Width div (CoverWidth + CoverSpacing));
      FitY := (ActiveDraw.Height div (CoverHeight + CoverSpacing));

      PageSize := FitY * (CoverHeight + CoverSpacing);
      SmallChange := PageSize div 8;

      MaxScroll := trunc( (CoverHeight + CoverSpacing) * (ItemCount / FitX) );
      if MaxScroll > CoverHeight then
        MaxScroll := MaxScroll - CoverHeight;
    end
  else
    begin
      FitY := (ActiveDraw.Height div (ListHeight + ListSpacing));

      PageSize := FitY * (ListHeight + ListSpacing);
      SmallChange := (ListHeight + ListSpacing);

      MaxScroll := ItemCount * (ListHeight + ListSpacing);
      if MaxScroll > ListHeight then
        MaxScroll := MaxScroll - ListHeight;
    end;

  // Fix sizing
  if PageSize > MaxScroll then
    PageSize := MaxScroll - 1;

  // Apply changes
  if ScrollPosition.Position > MaxScroll then
    ScrollPosition.Position := MaxScroll;

  if ScrollPosition.PageSize <> PageSize then
    ScrollPosition.PageSize := PageSize;

  if ScrollPosition.Max <> MaxScroll then
    ScrollPosition.Max := MaxScroll;

  if ScrollPosition.SmallChange <> SmallChange then
    ScrollPosition.SmallChange := SmallChange;
end;

procedure TUIForm.RedownloadItems;
var
  Folder: string;

  FileName: string;
  ID, I: Integer;
begin
  AddToLog('Form.RedownloadItems');
  // Offline Mode
  if IsOffline then
    Exit;

  // Folder
  Folder := AppData + DOWNLOAD_DIR;

  // Create Folder
  if not TDirectory.Exists(Folder) then
    TDirectory.CreateDirectory(Folder);

  // Create Queue
  DownloadQueue.Clear;
  for I := 0 to AllDownload.Count - 1 do
    begin
      ID := AllDownload[I];

      FileName := Folder + ID.ToString + '.mp3';

      if not TFile.Exists( FileName ) then
        DownloadQueue.Add(ID);
    end;

  // Download Each
  DownloadThread := TThread.CreateAnonymousThread(procedure
    procedure SetStatus(Str: string);
    begin
      TThread.Synchronize(nil, procedure begin
        Download_Status.Caption := Str;
      end);
    end;
    label ThreadStop;
    var
      I: integer;
      Server, Local, Repo: string;
      Identifier, TrackIndex, Total, ThreadID: integer;
      ST: TStringList;
    begin
      ThreadID := DownloadThreadsE + 1;

      // Show Status UI
      TThread.Synchronize(nil, procedure
        begin
          if not Download_Status.Visible then
            Download_Status.Show;
        end);
      
      // Write Album, Artist Playlist metadata
      Repo := Folder + 'albums\';
      TDirectory.CreateDirectory(Repo);
      for I := 0 to DownloadedAlbums.Count - 1 do
        begin
          // Status
          SetStatus( 'Writing album metadata (' + (I+1).ToString + '/'
              + DownloadedAlbums.Count.ToString + ')');

          // Get File
          Local := Repo + DownloadedAlbums[I] + '.txt';
            
          if TFile.Exists(Local) then
            Continue;
            
          // Write
          ST := TStringList.Create;
          try
            with Albums[GetAlbum(DownloadedAlbums[I].ToInteger)] do
              begin              
                ST.Add( AlbumName );
                ST.Add( IntArrayToStr(TracksID) );
                ST.Add( ArtistID.ToString );
                ST.Add( Rating.ToString );
                ST.Add( Year.ToString );
              end;

            ST.SaveToFile( Local );
          finally
            ST.Free;
          end;
        end;

      Repo := Folder + 'artists\';
      TDirectory.CreateDirectory(Repo);
      for I := 0 to DownloadedArtists.Count - 1 do
        begin
          // Status
          SetStatus( 'Writing artist metadata (' + (I+1).ToString + '/'
              + DownloadedArtists.Count.ToString + ')');

          // Get File
          Local := Repo + DownloadedArtists[I] + '.txt';
            
          if TFile.Exists(Local) then
            Continue;
            
          // Write
          ST := TStringList.Create;
          try
            with Artists[GetArtist(DownloadedArtists[I].ToInteger)] do
              begin              
                ST.Add( ArtistName );
                ST.Add( IntArrayToStr(TracksID) );
                ST.Add( Rating.ToString );
              end;

            ST.SaveToFile( Local );
          finally
            ST.Free;
          end;
        end;

      Repo := Folder + 'playlists\';
      TDirectory.CreateDirectory(Repo);
      for I := 0 to DownloadedPlaylists.Count - 1 do
        begin
          // Status
          SetStatus( 'Writing artist metadata (' + (I+1).ToString + '/'
              + DownloadedPlaylists.Count.ToString + ')');

          // Get Playlist File
          Local := Repo + DownloadedPlaylists[I] + '.txt';
            
          if TFile.Exists(Local) then
            Continue;
            
          // Write
          ST := TStringList.Create;
          try
            with Playlists[GetPlaylist(DownloadedPlaylists[I].ToInteger)] do
              begin              
                ST.Add( Name );
                ST.Add( IntArrayToStr(TracksID) );
                ST.Add( PlaylistType );
                ST.Add( Description );
              end;

            ST.SaveToFile( Local );
          finally
            ST.Free;
          end;
        end;
        
      // Download Tracks
      Total := DownloadQueue.Count - 1;
      for I := Total downto 0 do
        begin
          // Please Exit mr Thread
          if DownloadThreadsE = ThreadID then
            begin
              goto ThreadStop;
            end;

          // Update
          SetStatus( 'Downloading songs... (' + (Total-I+1).ToString + '/'
              + (Total+1).ToString + ')');

          // Get Data
          Identifier := DownloadQueue[I];
          TrackIndex := GetTrack(Identifier);

          try
            Local := Folder + Identifier.ToString;
            Server := STREAMING_ENDPOINT + Tracks[TrackIndex].StreamLocations;
          except
            Continue;
          end;
          // Audio
          DownloadFile(Server, Local + '.mp3');

          // Data
          ST := TStringList.Create;
          try
            ST.Add(Tracks[TrackIndex].Title);
            ST.Add(Tracks[TrackIndex].Year.ToString);
            ST.Add(Tracks[TrackIndex].Genre);
            ST.Add(Tracks[TrackIndex].LengthSeconds.ToString);
            ST.Add(Tracks[TrackIndex].FileSize.ToString);
            ST.Add(Tracks[TrackIndex].Rating.ToString);
            ST.Add(Tracks[TrackIndex].Plays.ToString);
            ST.Add(Tracks[TrackIndex].AudioType);

            ST.SaveToFile(Local + '.txt')
          finally
            ST.Free;
          end;

          // Artwork
          Tracks[TrackIndex].GetArtwork().SaveToFile(local + ART_EXT);

          // Remove from list
          TThread.Synchronize(nil, procedure
            begin
              DownloadQueue.Delete(I);
            end);
        end;

      ThreadStop:
      TThread.Synchronize(nil, procedure begin
        Download_Status.Hide;

        // Storage
        CalculateGeneralStorage;
      end);
    end);

  // Start
  with DownloadThread do
    begin
      Priority := tpLowest;

      FreeOnTerminate := true;
      Start;
    end;
end;

procedure TUIForm.RedrawPaintBox;
begin
  // Queue Box
  if Queue_Extend.Height = Queue_Extend.Constraints.MaxHeight then
    QueueDraw.Repaint;

  // Normal UI
  if InArray( BareRoot, ViewCompatibile ) <> -1 then
    ActiveDraw := DrawItem
  else
    begin
      if BareRoot = 'viewalbum' then
        ActiveDraw := DrawItem_Clone1;

      if BareRoot = 'viewartist' then
        ActiveDraw := DrawItem_Clone2;

      if BareRoot = 'viewplaylist' then
        ActiveDraw := DrawItem_Clone3;

      if BareRoot = 'home' then
        ActiveDraw := HomeDraw;

      if BareRoot = 'search' then
        ActiveDraw := SearchDraw;

      if BareRoot = 'downloads' then
        ActiveDraw := DownloadDraw;
    end;

  if ActiveDraw <> nil then
    ActiveDraw.Repaint;
end;

procedure TUIForm.ReloadArtwork;
const
  ARTRES_NAME = 'Artwork';
var
  AName: string;
  Pict: TPngImage;
  Bmp: TBitMap;
  LoadID: integer;
begin
  // Free
  if (DefaultPicture <> nil) and (not DefaultPicture.Empty) then
    DefaultPicture.Free;

  // Get ID
  LoadID := ArtworkID;
  if IsOffline and (ArtworkID = 0) then
    LoadID := 1;

  // Load
  case LoadID of
    1..4: begin
      AName := ARTRES_NAME + ArtworkID.ToString;

      Pict := TPngImage.Create;
      try
        Pict.LoadFromResourceName(0, AName);

        Bmp := TBitMap.Create;
        try
          Bmp.Assign( Pict );

          DefaultPicture := TJpegImage.Create;
          DefaultPicture.Assign( Bmp );
        finally
          Bmp.Free;
        end;
      finally
        Pict.Free;
      end;
    end;

    // Default Artwork
    else
      DefaultPicture := GetSongArtwork('0', TArtSize.Small);
  end;

  // Buttons
  try
    ImgSelector_1.FlatButton := ArtworkID = 0;
    ImgSelector_2.FlatButton := ArtworkID = 1;
    ImgSelector_3.FlatButton := ArtworkID = 2;
    ImgSelector_4.FlatButton := ArtworkID = 3;
    ImgSelector_5.FlatButton := ArtworkID = 4;
  except
    (* For some unknown reason, 1/20 times, this gives a error :| *)
  end;
end;

procedure TUIForm.ReloadLibrary;
begin
  AddToLog('Form.ReloadLibrary');

  StatusUpdaterMs.Enabled := true;

  // Get Status
  WORK_STATUS := 'Loading your account...';
  LoadStatus;

  // Get Library
  WORK_STATUS := 'Loading your library...';
  LoadLibrary;

  // Update Downloads
  WORK_STATUS := 'Updating Downloads...';
  UpdateDownloads;

  // Get last queue
  WORK_STATUS := 'Updating Queue...';
  if Setting_QueueSaver.Checked then
    QueueSettings(true);

  // Default Artwork
  WORK_STATUS := 'Loading Artwork...';
  ReloadArtwork;

  // UI
  WORK_STATUS := 'Preparing User Interface...';
  Welcome_Label.Caption := Format(WELCOME_STRING, [Account.Username]);
  Complete_Email.Caption := Format(CAPTION_EMAIL, [MaskEmailAdress(Account.EmailAdress)]);
  Complete_Email.Hint := Format(CAPTION_EMAIL, [Account.EmailAdress]);

  Complete_User.Caption := Format(CAPTION_EMAIL, [datetostr(Account.CreationDate)]);

  if Account.Verified then
    Complete_Verify.Caption := Format(CAPTION_VERIFIED, [datetostr(Account.VerificationDate)])
  else
    Complete_Verify.Caption := CAPTION_UNVERIFIED;

  if Account.Premium then
    Complete_Premium.Caption := CAPTION_PREMIUM
  else
    Complete_Premium.Caption := CAPTION_NOTPREMIUM;

  Status_Bitrate.Caption := Account.BitRate + 'kbps';
  if Account.OneQueue then
    CStandardIcon2.SelectedIcon := ciconCheckmark
  else
    CStandardIcon2.SelectedIcon := ciconError;

  if Account.BetaTester then
    CStandardIcon3.SelectedIcon := ciconCheckmark
  else
    CStandardIcon3.SelectedIcon := ciconError;

  Data_Tracks.Caption := LibraryStatus.TotalTracks.ToString;
  Data_Playlists.Caption := Length(Playlists).ToString;
  Data_Artists.Caption := Length(Artists).ToString;
  Data_Plays.Caption := LibraryStatus.TotalPlays.ToString;
  Data_Albums.Caption := Length(Albums).ToString;

  // Items
  LoginItems.ItemCount := Length(Sessions);
  LoginItems.Height := LoginItems.ItemCount * LoginItems.ItemHeight;
end;

procedure TUIForm.ReselectPage;
var
  ViewC, ViewSC, MultiPage: boolean;
  I: Integer;
begin
 // View compatability
  ViewC := InArray( AnsiLowerCase(LocationROOT), ViewCompatibile) <> -1;
  ViewSC := InArray(BareRoot, SubViewCompatibile) <> -1;
  MultiPage := BareRoot = 'downloads';
  
  // Hide all
  for I := 0 to PagesHolder.ControlCount - 1 do
    if PagesHolder.Controls[I] is TPanel then
      TPanel(PagesHolder.Controls[I]).Hide;

  // Other panels
  EnabledSorts := [];
  ViewModeToggle.Visible := ViewC or ViewSC or MultiPage;
  SearchToggle.Visible := ViewSC or ViewC or MultiPage;
  TracksControl.Visible := ViewSC or (BareRoot = 'songs');

  if ViewSC or MultiPage then
    EnabledSorts := [TSortType.Default, TSortType.Alphabetic];

  // Show proper panels
  if ViewC then
    begin
      RedrawPaintBox;
      GeneralDraw.Show;
      ViewModeToggle.Show;

      LoadView(BareRoot);

      // Sort
      EnabledSorts := [TSortType.Default, TSortType.Alphabetic, TSortType.Year, TSortType.Rating];

      if (bareroot = 'artists') or (bareroot = 'playlists') then
        EnabledSorts := EnabledSorts - [TSortType.Year];
      if (bareroot = 'playlists') then
        EnabledSorts := EnabledSorts - [TSortType.Rating];
      if (bareroot = 'history') then
        EnabledSorts := [];
    end
  else
    begin
      for I := 0 to PagesHolder.ControlCount - 1 do
        if PagesHolder.Controls[I] is TPanel then
          with TPanel(PagesHolder.Controls[I]) do
            begin
              if AnsiLowerCase(Caption) = AnsiLowerCase(LocationROOT) then
                begin
                  Show;
                  Break;
                end;
            end;
    end;

  // Reorder UI
    SortModeToggle.Visible := EnabledSorts <> [];
  if SortModeToggle.Visible then
    SortModeToggle.Left := ViewModeToggle.Left - SortModeToggle.Left;

  if TracksControl.Visible then
    TracksControl.Left := 0;

  if SearchToggle.Visible then
    SearchToggle.Left := 0;
    
  // Load Information
  LoadItemInfo;

  // Sort Reset
  Sort;

  // Search Reset
  Quick_Search.Text := '';
end;

procedure TUIForm.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if ssShift in Shift then
    TScrollBox(Sender).HorzScrollBar.Position := TScrollBox(Sender).HorzScrollBar.Position - WheelDelta div 4
  else
    TScrollBox(Sender).VertScrollBar.Position := TScrollBox(Sender).VertScrollBar.Position - WheelDelta div 4;
end;

procedure TUIForm.ScrollPositionChange(Sender: TObject);
begin
  if LastScrollValue <> TScrollBar(Sender).Position then
    begin
      // Draw
      RedrawPaintBox;
      LastScrollValue := TScrollBar(Sender).Position;

      // Update others
      ScrollPosition.Position := TScrollBar(Sender).Position;

      Scrollbar_1.PageSize := ScrollPosition.PageSize;
      Scrollbar_2.PageSize := ScrollPosition.PageSize;
      Scrollbar_3.PageSize := ScrollPosition.PageSize;
      Scrollbar_4.PageSize := ScrollPosition.PageSize;
      Scrollbar_5.PageSize := ScrollPosition.PageSize;
      Scrollbar_6.PageSize := ScrollPosition.PageSize;

      Scrollbar_1.Max := ScrollPosition.Max;
      Scrollbar_2.Max := ScrollPosition.Max;
      Scrollbar_3.Max := ScrollPosition.Max;
      Scrollbar_4.Max := ScrollPosition.Max;
      Scrollbar_5.Max := ScrollPosition.Max;
      Scrollbar_6.Max := ScrollPosition.Max;

      Scrollbar_1.Position := TScrollBar(Sender).Position;
      Scrollbar_2.Position := TScrollBar(Sender).Position;
      Scrollbar_3.Position := TScrollBar(Sender).Position;
      Scrollbar_4.Position := TScrollBar(Sender).Position;
      Scrollbar_5.Position := TScrollBar(Sender).Position;
      ScrollBar_6.Position := TScrollBar(Sender).Position;
    end;
end;

procedure TUIForm.SearchBox1InvokeSearch(Sender: TObject);
var
  Flags: TSearchFlags;
begin
  if SearchBox1.Text = '' then
    begin
      MessageBeep(0);
      Exit;
    end;

  // Flag
  Flags := [];
  if CCheckBox2.Checked then
    Flags := Flags + [TSearchFlag.ExactMatch];
  if CCheckBox3.Checked then
    Flags := Flags + [TSearchFlag.CaseSensitive];
  if CCheckBox1.Checked then
    Flags := Flags + [TSearchFlag.SearchInfo];
    
  // Search
  FiltrateSearch(SearchBox1.Text, Flags);

  // Draw
  SearchDraw.Repaint;
end;

procedure TUIForm.SearchDrawPaint(Sender: TObject);
var
  X, Y: integer;
  AHeight, AWidth, 
  ExtraSpacing, FitX: integer;
  
  S: string;
  FoundCount: integer;
  I: integer;
  
  ARect: TRect;

  LastType: TDataSource;
  AllowedSources: TDataSources;
begin
  ViewStyle := TViewStyle.Cover;

  with SearchDraw.Canvas do
    begin
      // Prepare
      Y := -ScrollPosition.Position;
      X := 0;

      AHeight := SearchDraw.Height;
      AWidth := SearchDraw.Width;

      FitX := (AWidth div (CoverWidth + CoverSpacing));
      if FitX = 0 then
        Exit;

      ExtraSpacing := round((AWidth - FitX * (CoverWidth + CoverSpacing)) / FitX);

      // Sources
      AllowedSources := [];
      if not SType_Song.FlatButton then
        AllowedSources := AllowedSources + [TDataSource.Tracks];
      if not SType_Album.FlatButton then
        AllowedSources := AllowedSources + [TDataSource.Albums];
      if not SType_Artist.FlatButton then
        AllowedSources := AllowedSources + [TDataSource.Artists];
      if not SType_Playlist.FlatButton then
        AllowedSources := AllowedSources + [TDataSource.Playlists];

      // Found Count
      FoundCount := 0;
      for I := 0 to High(DrawItems) do
        if (not DrawItems[I].Hidden) and (DrawItems[I].Source in AllowedSources) then
          Inc(FoundCount);
      
      // Font
      Font.Assign( Self.Font );
      Font.Name := 'Segoe UI Semibold';

      // Text
      if FoundCount > 0 then
        S := 'Found ' + FoundCount.ToString + ' results for "' + LastFilterQuery + '"'
      else
         S := 'No results found for "' + LastFilterQuery + '"';

      if LastFilterQuery = '' then
        S := 'Type above to search';
         
      Font.Size := 22;
      TextOut(X, Y, S);
      Inc(Y, TextHeight(S) + CoverSpacing);

      if LastFilterQuery = '' then
        Exit;

      // Type
      LastType := TDataSource.None;

      // Draw All Items
      for I := 0 to GetItemCount do
        begin
          // Hidden
          if DrawItems[I].Hidden or not(DrawItems[I].Source in AllowedSources) then
            begin
              DrawItems[I].Bounds := Rect(0, 0, 0, 0);
              Continue;
            end;
          
          // Draw Header
          if LastType <> DrawItems[I].Source then
            begin
              Font.Assign( Self.Font );
              Font.Name := 'Segoe UI';
              Font.Size := 18;

              case DrawItems[I].Source of
                TDataSource.Tracks: S := 'Tracks';
                TDataSource.Albums: S := 'Albums';
                TDataSource.Artists: S := 'Artists';
                TDataSource.Playlists: S := 'Playlists';
              end;

              // Position
              if X <> 0 then
                Inc(Y, CoverHeight + CoverSpacing);
              X := 0;

              // Draw
              TextOut(X, Y, S);
              Inc(Y, TextHeight(S) + CoverSpacing);
            end;
          
          // Last Source
          LastType := DrawItems[I].Source;

          // Rect
          ARect := Rect(X, Y, X + CoverWidth, Y + CoverHeight);

          // Bounds
          DrawItems[I].Bounds := ARect;
          if (I = IndexHoverID) and (Press10Stat <> 0) then
                ARect.Inflate(-Press10Stat, -trunc(ARect.Width / ARect.Height * Press10Stat));

          // Draw
          if (Y + CoverHeight > 0) and (Y < AHeight) then
            DrawItemCanvas(SearchDraw.Canvas, ARect, DrawItems[I].Title,
            DrawItems[I].InfoShort, DrawItems[I].GetPicture,
            DrawItems[I].Active, DrawItems[I].Downloaded);

          // Move Line
          Inc(X, CoverWidth + CoverSpacing + ExtraSpacing);

          if X + CoverWidth > AWidth then
            begin
              X := 0;
              Inc(Y, CoverHeight + CoverSpacing);
            end;
        end;

      // Scroll
      ScrollPosition.PageSize := 0;
      ScrollPosition.Max := Y + ScrollPosition.Position;
    end;
end;

procedure TUIForm.Search_ButtonClick(Sender: TObject);
begin
  Search_Button.Hide;

  SearchBox_Hold.Show;
  Quick_Search.SetFocus;
end;

procedure TUIForm.SelectView_Click(Sender: TObject);
begin
  // Set
  SetView( TViewStyle(CButton(Sender).Tag) );

  RedrawPaintBox;
end;

procedure TUIForm.SetScroll(Index: integer);
begin
  RecalibrateScroll;

  // Scrollbars
  ScrollPosition.Position := Index;
  ScrollPositionChange(ScrollPosition);
end;

procedure TUIForm.SetSort(Mode: TSortType);
begin
  ListSort := Mode;

  // Sort
  Sort;
end;

procedure TUIForm.SettingsApplyes(Sender: CCheckBox; State: TCheckBoxState);
begin
  ApplySettings;
end;

procedure TUIForm.SetView(View: TViewStyle; NoAdd : boolean);
begin
  ViewStyle := View;

  // Custom Views
  if not NoAdd then
    if InArray(BareRoot, ViewCompatibile) <> -1 then
      AddView(BareRoot, View);

  // UI
  SelectView_List.UnderLine.Enable := View = TViewStyle.List;
  SelectView_Grid.UnderLine.Enable := View = TViewStyle.Cover;
end;

Procedure ArrayItemSort(AType: TSortType);
  function GetTitleValue(Index: integer): string;
  begin
    if InArray(BareRoot, SubViewCompatibile) <> -1 then
      Exit( DrawItems[SortingList[Index]].Title );
    if BareRoot = 'songs' then
      Exit( Tracks[SortingList[Index]].Title );
    if BareRoot = 'albums' then
      Exit( Albums[SortingList[Index]].AlbumName );
    if BareRoot = 'artists' then
      Exit( Artists[SortingList[Index]].ArtistName );
    if BareRoot = 'playlists' then
      Exit( Playlists[SortingList[Index]].Name );
  end;

  function GetDateValue(Index: integer): cardinal;
  begin
    Result := 0;
    if BareRoot = 'songs' then
      Exit( Tracks[SortingList[Index]].Year );
    if BareRoot = 'albums' then
      Exit( Albums[SortingList[Index]].Year );
  end;

  function GetRatingValue(Index: integer): cardinal;
  begin
    Result := 0;
    if BareRoot = 'songs' then
      Exit( Tracks[SortingList[Index]].Rating );
    if BareRoot = 'albums' then
      Exit( Albums[SortingList[Index]].Rating );
    if BareRoot = 'artists' then
      Exit( Artists[SortingList[Index]].Rating );
  end;

  function CompareItems(A, B: integer): boolean;
  begin
    case AType of
      TSortType.Year: Result := GetDateValue(A) < GetDateValue(B);
      TSortType.Rating: Result := GetRatingValue(A) > GetDateValue(B);

      // Default
      else Result := GetTitleValue(A) > GetTitleValue(B);
    end;
  end;

var
  i, j: Integer;
  temp: integer;
begin
  for i := High(SortingList) downto Low(SortingList) + 1 do
  begin
    for j := Low(SortingList) to i - 1 do
    begin
      if CompareItems(J, J+1) then
      begin
        temp := SortingList[j];
        SortingList[j] := SortingList[j + 1];
        SortingList[j + 1] := temp;
      end;
    end;
  end;
end;

procedure TUIForm.SongUpdate;
var
  A: integer;
begin
  // Invalid
  if (PlayIndex >= Length(Tracks)) or (PlayIndex < 0) then
    Exit;

  // Song Info
  Song_Name.Caption := Tracks[PlayIndex].Title;
  A := GetArtist(Tracks[PlayIndex].ArtistID);
  if A <> -1 then
    Song_Artist.Caption := Artists[A].ArtistName;

  try
    Song_Cover.Picture.Assign( Tracks[PlayIndex].GetArtwork() );
  except
    Abort;
  end;

  // Player
  Player_Position.Max := Player.Duration;
  Track_Time.Enabled := true;

  // UI
  Song_Player.Show;

  Taskbar1.ToolTip := '🎵' + Tracks[PlayIndex].Title + ' - ' + Song_Artist.Caption;

  // Update
  StatusChanged;
  UpdateMiniPlayer;
end;

procedure TUIForm.Sort;
var
  I: Integer;
begin
  // UI
  Sort_Default.UnderLine.Enable := ListSort = TSortType.Default;
  Sort_AlphaBetic.UnderLine.Enable := ListSort = TSortType.Alphabetic;
  Sort_Date.UnderLine.Enable := ListSort = TSortType.Year;
  Sort_Rating.UnderLine.Enable := ListSort = TSortType.Rating;

  Sort_Default.Visible := TSortType.Default in EnabledSorts;
  Sort_AlphaBetic.Visible := TSortType.Alphabetic in EnabledSorts;
  Sort_Date.Visible := TSortType.Year in EnabledSorts;
  Sort_Rating.Visible := TSortType.Rating in EnabledSorts;

  // Reorder
  Sort_Default.Left := 0;
  Sort_AlphaBetic.Left := 0;
  Sort_Date.Left := 0;      
  Sort_Rating.Left := 0;

  // Size
  SetLength(SortingList, GetItemCount );

  // Reset Array
  for I := 0 to High(SortingList) do
    SortingList[I] := I;

  // Sort Array
  case ListSort of
    TSortType.Default: Exit;
    TSortType.Flipped: for I := 0 to High(SortingList) do
                          SortingList[I] := High(SortingList) - I;
    else ArrayItemSort(ListSort);
  end;
end;

procedure TUIForm.SortButtons_Click(Sender: TObject);
begin
  // Sort
  SetSort( TSortType(CButton(Sender).Tag) );

  RedrawPaintBox;
end;

procedure TUIForm.MenuToggled(Sender: TObject);
begin
  OnResize(Self);
  PauseDrawing := false;
end;

procedure TUIForm.MinimiseToTray;
begin
  Self.Hide;
  HiddenToTray := true;
end;

procedure TUIForm.MoveByHold(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Self.Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TUIForm.MenuStartedAnimation(Sender: TObject);
begin
  PauseDrawing := true;
end;

procedure TUIForm.SplitView1Resize(Sender: TObject);
begin
  TitlebarCompare.Width := TSplitView(Sender).Width;
end;

procedure TUIForm.StartCheckForUpdate;
begin
  AddToLog('Form.StartCheckForUpdate');
  // Offline
  if IsOffline then
    begin
      Latest_Version.Caption := 'Latest version on server: You are offline';
      Exit;
    end;

  // Status
  Latest_Version.Caption := 'Latest version on server: Checking...';

  // Update
  Version_Check.Navigate(UPDATE_URL, SHDocVw.navNoReadFromCache);
end;

procedure TUIForm.StatusChanged;
var
  I: Integer;
begin
  AddToLog('Status changed! Form.StatusChanged');

  // Button Enable
  Button_Prev.Enabled := Player.IsFileOpen;
  Button_Play.Enabled := Player.IsFileOpen;
  Button_Next.Enabled := Player.IsFileOpen;

  // Tick
  TickUpdate;

  // Volume
  case ceil(Player.Volume * 4) of
    0: Button_Volume.BSegoeIcon := #$E74F;
    1: Button_Volume.BSegoeIcon := #$E992;
    2: Button_Volume.BSegoeIcon := #$E993;
    3: Button_Volume.BSegoeIcon := #$E994;
    else Button_Volume.BSegoeIcon := #$E995;
  end;

  // Repeat
  case RepeatMode of
    TRepeat.Off: Button_Repeat.BSegoeIcon := #$F5E7;
    TRepeat.All: Button_Repeat.BSegoeIcon := #$E8EE;
    TRepeat.One: Button_Repeat.BSegoeIcon := #$E8ED;
  end;

  // Shuffle
  if Shuffled then
    Button_Shuffle.BSegoeIcon := #$E8B1
  else
    Button_Shuffle.BSegoeIcon := #$E150;

  // Selected
  for I := 0 to High(DrawItems) do
    DrawItems[I].Active := (DrawItems[I].ItemID = PlayID) and (DrawItems[I].Source = TDataSource.Tracks);

  // Repaint UI
  RedrawPaintBox;

  // Mini Player
  if (MiniPlayer <> nil) and MiniPlayer.Visible then
    with MiniPlayer do
      begin
        Mini_Repeat.BSegoeIcon := Button_Repeat.BSegoeIcon;
        Mini_Shuffle.BSegoeIcon := Button_Shuffle.BSegoeIcon;
      end;
end;

procedure TUIForm.StatusUpdaterMsTimer(Sender: TObject);
begin
  if not Status_Work.Visible then
    Exit;
  Status_Work.Caption := WORK_STATUS;
end;

function TUIForm.StrToIntArray(Str: string): TArray<integer>;
var
  ACount: integer;
  P1, P2: integer;
  I: Integer;
begin
  SetLength(Result, 0);
  Str := Copy(Str, 2, Length(Str) - 2);

  // Empty
  if Str = '' then
    Exit;

  // Add ","
  Str := ',' + Str + ',';

  // Not Empty
  ACount := StrCount(',', Str);
  SetLength(Result, ACount - 1);

  // Load
  for I := 1 to ACount - 1 do
    begin
      P1 := StrPos(',', Str, I);
      P2 := StrPos(',', Str, I + 1);

      Result[I-1] := StrCopy(Str, P1, P2, true).ToInteger;
    end;
end;

procedure TUIForm.TickUpdate;
begin
  // Icon
  if not NeedSeekUpdate then
    if Player.PlayStatus = psPlaying then
      begin
        Button_Play.BSegoeIcon := ICON_PAUSE;

        // Taskbar
        Taskbar1.TaskBarButtons[1].ButtonState := [TThumbButtonState.Enabled, TThumbButtonState.Hidden];
        Taskbar1.TaskBarButtons[2].ButtonState := [TThumbButtonState.Enabled];
      end
    else
      begin
        Button_Play.BSegoeIcon := ICON_PLAY;

        // Taskbar
        Taskbar1.TaskBarButtons[1].ButtonState := [TThumbButtonState.Enabled];
        Taskbar1.TaskBarButtons[2].ButtonState := [TThumbButtonState.Enabled, TThumbButtonState.Hidden];
      end;

  // Progress
  if not IsSeeking then
    Player_Position.Position := Player.Position;

  Time_Pass.Caption := CalculateLength( trunc(Player.PositionSeconds) ) + ' / ' + CalculateLength( trunc(Player.DurationSeconds) );

  // Fix data
  if NeedSeekUpdate and (player.PlayStatus = psPlaying) and (SeekPoint <> -1) and Player.IsFileOpen then
    begin
      Player.Position := SeekPoint;

      if Player.Position = SeekPoint then
        begin
          IsSeeking := false;
          NeedSeekUpdate := false;

          SeekTimeout := 0;
        end;
    end;

  // Loop
  if EqualApprox(Player.DurationSeconds, Player.PositionSeconds, 0.1) and (Player.DurationSeconds > 0) and (PlayIndex <> -1) and (not IsOffline) then
    begin
      if RepeatMode = TRepeat.One then
        PlaySong( PlayIndex )
      else
        QueueNext;
    end;


  // Mini Player
  if (MiniPlayer <> nil) and MiniPlayer.Visible then
  with MiniPlayer do
    begin
      MiniButton_Play.BSegoeIcon := Button_Play.BSegoeIcon;

      MiniSetSeek;
    end;
end;

procedure TUIForm.ToggleRepeat;
begin
  if RepeatMode = TRepeat.One then
    RepeatMode := TRepeat.Off
  else
    RepeatMode := TRepeat(Integer(RepeatMode) + 1);

  StatusChanged;
end;

procedure TUIForm.ToggleShuffle(Value: boolean);
var
  I: Integer;
  RandIndex, Start: integer;
  RandomQueue: TArray<integer>;
begin
  if PlayQueue.Count = 0 then
    Exit;

  if Value then
    // Shuffle
    begin
      PlayQueueOriginal := TIntegerList.Create;
      for I := 0 to PlayQueue.Count - 1 do
        PlayQueueOriginal.Add( PlayQueue[I] );

      // Shuffle previous (simplist random algorithm)
      for I := 0 to QueuePos-1 do
        begin
          RandIndex := Random(QueuePos);
          PlayQueue.Move(I, RandIndex);
        end;

      // Shuffle next (Fisher-Yates shuffle algorithm)
      Randomize;
      RandomQueue := GenerateRandomSequence( PlayQueue.Count - QueuePos - 1 );
      Start := QueuePos + 1;
      for I := 0 to High(RandomQueue) do
        RandomQueue[I] := RandomQueue[I] + Start - 1;

      // Apply Order
      for I := 0 to High(RandomQueue) do
        PlayQueue.Move(I + Start, RandomQueue[I]);

      // Repos
      RecalculateQueuePos;

      // Done
      OriginalQueueValid := true;
    end
  else
    // Unshuffle
    begin
      if OriginalQueueValid then
        begin
          PlayQueue.Clear;
          for I := 0 to PlayQueueOriginal.Count - 1 do
            PlayQueue.Add( PlayQueueOriginal[I] );

          Self.RecalculateQueuePos;
        end;

      // Done
      OriginalQueueValid := false;
    end;

  // Set Value
  Shuffled := Value;

  // Update
  QueueUpdated;
  StatusChanged;
end;

procedure TUIForm.TokenLoginInfo(Load: boolean);
var
  ST: TStringList;
  FileName: string;
begin
  // Invalid
  if not Load and ((APPLICATION_ID = '') or (LOGIN_TOKEN = '')) then
    Exit;

  // File Name
  FileName := AppData + 'login.token';
  if Load then
    // Load Token
    begin
      if not TFile.Exists(FileName) then
        Exit;

      ST := TStringList.Create;
      try
        ST.LoadFromFile( FileName );

        APPLICATION_ID := ST[0];
        LOGIN_TOKEN := ST[1];
      finally
        ST.Free;
      end;
    end
  else
    // Save Token
    begin
      ST := TStringList.Create;
      try
        St.Add( APPLICATION_ID );
        St.Add( LOGIN_TOKEN );

        ST.SaveToFile( FileName );
      finally
        ST.Free;
      end;
    end;
end;

procedure TUIForm.Track_TimeTimer(Sender: TObject);
begin
  TickUpdate;
end;

procedure TUIForm.TrayIcon1DblClick(Sender: TObject);
begin
  if HiddenToTray then
    OpenFromTray;
end;

procedure TUIForm.TrayToggle(Sender: TObject);
begin
  if not MiniPlayer.Visible then
    begin
      if Visible then
        MinimiseToTray
      else
        OpenFromTray;
    end;
end;

procedure TUIForm.UpdateCheckTimer(Sender: TObject);
begin
  UpdateCheck.Enabled := false;

  if Settings_CheckUpdate.Checked then
    begin
      StartCheckForUpdate;
    end
      else
        UpdateHold.Hide;
end;

procedure TUIForm.UpdateDownloads;
procedure AddItems(Items: TArray<integer>);
  var
    I: Integer;
begin
  for I := 0 to High(Items) do
    AllDownload.Add( Items[I] );
end;

var
  Category: Integer;
  I, Index: Integer;
begin
  AddToLog('Form.UpdateDownloads');
  // Clear
  AllDownload.Clear;

  // Stop Thread
  if (DownloadThread <> nil) and (not DownloadThread.Finished) and DownloadThread.Started then
    Inc(DownloadThreadsE);

  // Load Each Type
  for Category := 1 to 4 do
    // Type
    case Category of
      1: begin
        // Load
        for I := 0 to DownloadedTracks.Count - 1 do
          AllDownload.Add( DownloadedTracks[I].ToInteger );
      end;
      2: begin
        for I := 0 to DownloadedAlbums.Count - 1 do
          begin
            Index := GetAlbum(DownloadedAlbums[I].ToInteger);

            if Index = -1 then
              Continue;

            AddItems( Albums[Index].TracksID );
          end;
      end;
      3:  begin
        for I := 0 to DownloadedArtists.Count - 1 do
          begin
            Index := GetArtist(DownloadedArtists[I].ToInteger);

            if Index = -1 then
              Continue;

            AddItems( Artists[Index].TracksID );
          end;
      end;
      4: begin
        for I := 0 to DownloadedPlaylists.Count - 1 do
          begin
            Index := GetPlaylist(DownloadedPlaylists[I].ToInteger);

            if Index = -1 then
              Continue;

            AddItems( Playlists[Index].TracksID );
          end;
      end;
    end;

  // Offline Mode, only load tracks, then exit
  if IsOffline then
    Exit;

  // Validate Queue
  for I := DownloadQueue.Count - 1 downto 0 do
    if AllDownload.IndexOf( DownloadQueue[I] ) = -1 then
      DownloadQueue.Delete(I);

  // Validate Files
  ValidateDownloadFiles;

  // Start Download Thread
  RedownloadItems;
end;

procedure TUIForm.UpdateMiniPlayer;
begin
  if (MiniPlayer <> nil) and MiniPlayer.Visible then
    with MiniPlayer do
      begin
        Mini_Song.Caption := Song_Name.Caption;
        Mini_Artist.Caption := Song_Artist.Caption;

        if QueuePos + 1 < PlayQueue.Count then
          Mini_NextSong.Caption := Tracks[PlayQueue[QueuePos + 1]].Title
        else
          Mini_NextSong.Caption := 'Queue End';

        if Song_Cover.Picture <> nil then
          Mini_Cover.Picture := Song_Cover.Picture;

         Mini_Seek.Max := UIForm.Player_Position.Max;
      end;
end;

procedure TUIForm.ValidateDownloadFiles;
var
  Files: TArray<string>;
  Folder: string;

  Name: string;
  Identifier, A, I: Integer;

  Exists: boolean;
begin
  AddToLog('Form.ValidateDownloadFiles');
  // Offline
  if IsOffline then
    Exit;

  // Folder
  Folder := AppData + DOWNLOAD_DIR;

  // Create Folder
  if not TDirectory.Exists(Folder) then
    TDirectory.CreateDirectory(Folder);

  // Load Items
  Files := TDirectory.GetFiles( Folder, '*.mp3' );

  for I := 0 to High(Files) do
    begin
      // Non audio
      if ExtractFileExt(Files[I]) <> '.mp3' then
        Continue;

      // Get ID
      Name := ChangeFileExt( ExtractFileName( Files[I] ), '' );
      try
        Identifier := Name.ToInteger;
      except
        Continue;
      end;

      // Compare
      Exists := false;
      for A := 0 to AllDownload.Count - 1 do
        if Identifier = AllDownload[A] then
          begin
            Exists := true;
            Break
          end;

      if not Exists then
        if DownloadQueue.IndexOf(Identifier) = -1 then
          try
            DeleteDownloaded( Identifier );
          except
            // Thread is still using the file. To be deleted on next launch
          end;
    end;
end;

function TUIForm.Version: string;
begin
  Result := V_MAJOR.ToString + '.' + V_MINOR.ToString + '.' + V_PATCH.ToString ;
end;

procedure TUIForm.Version_CheckNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  Doc: Variant;
  HTML: string;

  VerStr: TArray<string>;
  VMajor, VMinor, VPatch: integer;

  ANewVersion: boolean;
begin
  if not Assigned(Version_Check.Document) then
    Version_Check.Navigate('about:blank');

  Doc := Version_Check.Document;
  Doc.Clear;
  HTML := Doc.Body.InnerHTML;
  Doc.Close;

  HTML := Trim(HTML);

  // Get Str
  VerStr := GetAllSeparatorItems(HTML, '.');

  try
    VMajor := VerStr[0].ToInteger;
    VMinor := VerStr[1].ToInteger;
    VPatch := VerStr[2].ToInteger;
  except
    Exit;
  end;

  ANewVersion := true;

  // Analise
  if V_MAJOR > VMajor then
    ANewVersion := false
      else
        if V_MINOR > VMinor then
          ANewVersion := false
            else
              if V_PATCH >= VPatch then
                ANewVersion := false;

  // New Version
  if ANewVersion then
    begin
      NewVersion := TNewVersion.Create(Application);
      try
        with NewVersion do
          begin
            Version_Old.Caption := Version;
            Version_New.Caption := HTML;

            if ShowModal = mrOk then
              ShellRun( DOWNLOAD_UPDATE_URL, false );
          end;
      finally
        NewVersion.Free;
      end;
    end;

  // Update version
  Latest_Version.Caption := 'Latest version on server: ' + VMajor.ToString + '.' + VMinor.ToString + '.' + VPatch.ToString;
end;

procedure TUIForm.ViewAlbum1Click(Sender: TObject);
var
  AlbumID: integer;
  Item: TDrawableItem;
begin
  // View Artist
  case PopupSource of
    TDataSource.Tracks: AlbumID := Tracks[DrawItems[PopupDrawIndex].Index].AlbumID;
    else Exit;
  end;

  // Validate
  if AlbumID = 0 then
    Exit;

  // Open
  Item.LoadSourceID(AlbumID, TDataSource.Albums);
  Item.Execute;
end;

procedure TUIForm.WMAppCommand(var Msg: TMessage);
begin
  case GET_APPCOMMAND_LPARAM(Msg.LParam) of
    APPCOMMAND_BROWSER_BACKWARD:
    begin
      // Do "go back" code
      PreviousPage;
      Msg.Result := 1;
    end;
    APPCOMMAND_MEDIA_PREVIOUSTRACK: Action_Previous.Execute;
    APPCOMMAND_MEDIA_PLAY_PAUSE: Action_Play.Execute;
    APPCOMMAND_MEDIA_NEXTTRACK: Action_Next.Execute;
  end;
end;

{ TDrawableItem }

function TDrawableItem.Downloaded: boolean;
begin
  case Source of
    TDataSource.Tracks: Result := DownloadedTracks.IndexOf(ItemID.ToString) <> -1;
    TDataSource.Albums: Result := DownloadedAlbums.IndexOf(ItemID.ToString) <> -1;
    TDataSource.Artists: Result := DownloadedArtists.IndexOf(ItemID.ToString) <> -1;
    TDataSource.Playlists: Result := DownloadedPlaylists.IndexOf(ItemID.ToString) <> -1;
    else
      Result := false
  end;
end;

procedure TDrawableItem.Execute;
var
  I: integer;
  AName: string;
begin
  AddToLog('TDrawableItem[' + Index.ToString + '].Execute');

  case Source of
    TDataSource.Tracks: begin
      if (IndexHoverID <> PlayIndex) or (Player.PlayStatus <> psPlaying) then
        begin
          // Add to queue ONLY
          if OnlyQueue then
            begin
              PlayQueue.Add( Index );

              // Draw
              UIForm.QueueUpdated;

              // Play
              if (PlayQueue.Count = 1) and (Player.PlayStatus <> psPlaying) then
                begin
                  QueuePos := -1;
                  UIForm.QueueSetTo(0);
                end;

              // Exit
              Exit
            end;

          // Create new queue
          UIForm.QueueClear;

          for I := 0 to High(SortingList) do
            begin
              if DrawItems[SortingList[I]].Source <> TDataSource.Tracks then
                Continue;

              PlayQueue.Add( DrawItems[SortingList[I]].Index );
            end;

          // Select Item
          QueuePos := 0;
          for I := 0 to PlayQueue.Count - 1 do
            if Tracks[PlayQueue[I]].ID = ItemID then
              QueuePos := I;

          // Play
          UIForm.QueuePlay;

          // Draw
          UIForm.QueueUpdated;
        end;
    end;

    TDataSource.Albums: begin
      with Albums[Index] do
        begin
          AName := AlbumName;
          UIForm.Label5.Caption := GetPremadeInfoList;

          UIForm.CImage2.Picture.Assign( GetArtwork() );

          // Download button
          with UIForm do
            begin
              Download_Album.Visible := not IsOffline;
              Download_Album.Tag := (DownloadedAlbums.IndexOf( ItemID.ToString ) <> -1).ToInteger;
              Download_Album.OnEnter(Download_Album);
            end;

          UIForm.Page_Title.Caption := AlbumName;
        end;

      (* Navigate *)
      UIForm.NavigatePath('ViewAlbum:' + Albums[Index].ID.ToString);
      UIForm.Page_Title.Caption := AName;
    end;

    TDataSource.Artists: begin
      with Artists[Index] do
        begin
          AName := ArtistName;
          UIForm.Label19.Caption := GetPremadeInfoList;

          UIForm.CImage10.Picture.Assign( GetArtwork );

          // Download button
          with UIForm do
            begin
              Download_Artist.Visible := not IsOffline;
              Download_Artist.Tag := (DownloadedArtists.IndexOf( ItemID.ToString ) <> -1).ToInteger;
              Download_Artist.OnEnter(Download_Artist);
            end;

          UIForm.Page_Title.Caption := ArtistName;
        end;

      (* Navigate *)
      UIForm.NavigatePath('ViewArtist:' + Artists[Index].ID.ToString);
      UIForm.Page_Title.Caption := AName;
    end;
                                                                  
    TDataSource.Playlists: begin
      with Playlists[Index] do
        begin
          AName := Name;
          UIForm.Label22.Caption := GetPremadeInfoList;

          UIForm.CImage11.Picture.Assign( GetArtwork );

          // Download button
          with UIForm do
            begin
              Download_Playlist.Visible := not IsOffline;
              Download_Playlist.Tag := (DownloadedPlaylists.IndexOf( ItemID.ToString ) <> -1).ToInteger;
              Download_Playlist.OnEnter(Download_Playlist);
            end;

          UIForm.Page_Title.Caption := Name;
        end;

      (* Navigate *)
      UIForm.NavigatePath('ViewPlaylist:' + Playlists[Index].ID.ToString);
      UIForm.Page_Title.Caption := AName;
    end;
  end;

  // General Data
  LastValueID := ItemID;
  LastExecutedSource := Source;
end;

function TDrawableItem.GetPicture: TJPEGImage;
begin
  // Get Type
  case Source of
    TDataSource.Tracks:
      if Tracks[Index].ArtworkLoaded then
        Result := Tracks[Index].CachedImage
          else
            begin
              Result := DefaultPicture;

              StartPictureLoad;
            end;

    TDataSource.Albums:
      if Albums[Index].ArtworkLoaded then
        Result := Albums[Index].CachedImage
          else
            begin
              Result := DefaultPicture;

              StartPictureLoad;
            end;

    TDataSource.Artists:
      if Artists[Index].ArtworkLoaded then
        Result := Artists[Index].CachedImage
          else
            begin
              Result := DefaultPicture;

              StartPictureLoad;
            end;

    TDataSource.Playlists:
      if Playlists[Index].ArtworkLoaded then
        Result := Playlists[Index].CachedImage
          else
            begin
              Result := DefaultPicture;

              StartPictureLoad;
            end;

    else Result := DefaultPicture;
  end;
end;

function TDrawableItem.GetPremadeInfoList: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to High(Information) do
    begin
      Result := Result + Information[I] + #13;
    end;
end;

function TDrawableItem.Hidden: boolean;
begin
  Result := HiddenItem or HiddenSearch;
end;

procedure TDrawableItem.LoadSource(AIndex: integer; From: TDataSource);
var
  Temp, A: integer;
  Data1: string;
begin
  if AIndex = -1 then
    Exit;

  Index := AIndex;

  HiddenItem := false;
  HiddenSearch := false;
  Active := false;

  Source := From;

  case From of
    TDataSource.Tracks: begin
      ItemID := Tracks[Index].ID;

      Title := Tracks[Index].Title;

      // Info
      SetLength(Information, 10);
      Information[0] := 'Track Number: ' + Tracks[Index].TrackNumber.ToString;
      Information[1] := 'Released in: ' + Yearify(Tracks[Index].Year);
      Information[2] := 'Genre: ' + Tracks[Index].Genre;
      Information[3] := 'Length: ' + UIForm.CalculateLength( Tracks[Index].LengthSeconds );
      A := GetArtist(Tracks[Index].ArtistID);
      if A <> -1 then
        Data1 := Artists[A].ArtistName
      else
        Data1 := 'Unknown';

      Information[4] := 'Artist: ' + Data1;

      A := GetAlbum(Tracks[Index].AlbumID);
      if A <> -1 then
        Information[5] := 'Album: ' + Albums[A].AlbumName;
      Information[6] := 'Uploaded on: ' + DateToStr( Tracks[Index].DayUploaded );
      Information[7] := 'File Size: ' + SizeInString( Tracks[Index].FileSize );
      Information[8] := 'Rating: ' + Tracks[Index].Rating.ToString + '/10';
      Information[9] := 'Media Type: ' + Tracks[Index].AudioType;

      // Default Info
      InfoShort := Data1 + ' • ' + Yearify(Tracks[Index].Year);
      InfoLong := Information[1] + ', ' + Information[4] + ', ' +
        Information[3] + ', ' + Information[5] + ', ' + Information[8];
    end;

    TDataSource.Albums: begin
      ItemID := Albums[Index].ID;

      Title := Albums[Index].AlbumName;

      // Info
      SetLength(Information, 6);
      Information[0] := 'Total Tracks: ' + Length(Albums[Index].TracksID).ToString;
      Information[1] := 'Released in: ' + Yearify(Albums[Index].Year);
      Temp := GetArtist(Albums[Index].ArtistID);
      if Temp <> -1 then
        Information[2] := 'Artist: ' + Artists[Temp].ArtistName
          else
            Information[2] := 'Artist: Unknown';
      Information[3] := 'Rating: ' + Albums[Index].Rating.ToString;
      Information[4] := 'Disk: ' + Albums[Index].Disk.ToString;
      Temp := 0;
      for A := 0 to High(Albums[Index].TracksID) do
        Inc(Temp, Tracks[GetTrack(Albums[Index].TracksID[A])].LengthSeconds );
      Information[5] := 'Length: ' + UIForm.CalculateLength(Temp);

      // Default Info
      InfoShort := Length(Albums[Index].TracksID).ToString + ' Tracks • ' + Information[2];
      InfoLong := Information[0] + ', ' + Information[2] + ', ' +
        Information[1] + ', ' + Information[3] + ', ' + Information[4];
    end;

    TDataSource.Artists: begin
      ItemID := Artists[Index].ID;

      Title := Artists[Index].ArtistName;

      // Info
      SetLength(Information, 3);
      Information[0] := 'Total Tracks: ' + Length(Artists[Index].TracksID).ToString;
      Temp := 0;
      for A := 0 to High(Albums) do
        if Albums[A].ArtistID = ItemID then
          Inc(Temp);
      Information[1] := 'Album count: ' + Temp.ToString;
      Information[2] := 'Rating: ' + Artists[Index].Rating.ToString;

      // Default Info
      InfoShort :=  Length(Artists[Index].TracksID).ToString + ' Tracks • ' + Information[1];
      InfoLong := Information[0] + ', ' + Information[1] + ', ' +
        Information[2];
    end;

    TDataSource.Playlists: begin
      ItemID := Playlists[Index].ID;

      Title := Playlists[Index].Name;

      // Info
      SetLength(Information, 3);
      Information[0] := 'Total Tracks: ' + Length(Playlists[Index].TracksID).ToString;
      Temp := 0;
      for A := 0 to High(Playlists[Index].TracksID) do
        Inc(Temp, Tracks[GetTrack(Playlists[Index].TracksID[A])].LengthSeconds );

      Information[1] := 'Length: ' + UIForm.CalculateLength(Temp);
      Information[2] := 'Description: "' + Playlists[Index].Description + '"';

      // Default Info
      InfoShort := Length(Playlists[Index].TracksID).ToString + ' Tracks • ' + Copy(Information[1], 9, 9);
      InfoLong := Information[0] + ', ' + Information[1] + ', ' + Information[2];


    end;
  end;
end;

procedure TDrawableItem.LoadSourceID(ID: integer; From: TDataSource);
var
  Index: integer;
begin
  case From of
    TDataSource.Tracks: Index := GetTrack(ID);
    TDataSource.Albums: Index := GetAlbum(ID);
    TDataSource.Artists: Index := GetArtist(ID);
    TDataSource.Playlists: Index := GetPlaylist(ID);
    else Index := 0;
  end;

  LoadSource( Index, From );
end;

procedure TDrawableItem.OpenInformation;
begin
  with InfoBox do
    begin
      Caption := Title;
      Song_Name.Caption := Title;
      Song_Info.Caption := GetPremadeInfoList;

      Download_Item.Visible := not IsOffline;
      Download_Item.Tag := Downloaded.ToInteger;
      Download_Item.OnEnter(Download_Item);

      Song_Cover.Picture.Assign( Self.GetPicture );
    end;

  InfoBoxIndex := Index;
  InfoBoxPointer := @Self;

  InfoBox.FixUI;
  CenterFormInForm(InfoBox, UIForm, true);
end;

procedure TDrawableItem.StartPictureLoad;
var
  ThreadSource: TDataSource;
  ItemIndex,
  ItemIdentifier: integer;
  FileName: string;
  IsDownload: boolean;
begin
  // MAX Thread limit
  if TotalThreads > THREAD_MAX then
    Exit;

  // Self Access
  ThreadSource := Source;
  ItemIdentifier := ItemID;
  ItemIndex := index;
  if Source = TDataSource.Tracks then
    IsDownload := AllDownload.IndexOf(ItemID) <> -1;

  with TThread.CreateAnonymousThread(procedure
    begin
      // Thread Count
      Inc(TotalThreads);

      // Get artwork
      try
        case ThreadSource of
          TDataSource.Tracks: begin
            // Check Local
            if IsDownload and not Tracks[ItemIndex].ArtworkLoaded then
              begin
                FileName := AppData + DOWNLOAD_DIR + ItemIdentifier.ToString + ART_EXT;
                if TFile.Exists(FileName) then
                  begin
                    Tracks[ItemIndex].CachedImage := TJpegImage.Create;
                    Tracks[ItemIndex].CachedImage.LoadFromFile(FileName);
                  end;
              end;

            // Server Side
            Tracks[ItemIndex].GetArtwork();
          end;
          TDataSource.Albums: Albums[ItemIndex].GetArtwork();
          TDataSource.Artists: Artists[ItemIndex].GetArtwork();
          TDataSource.Playlists: Playlists[ItemIndex].GetArtwork();
        end;
      except
        // Due to media store, sometimes files are being used by two threads at the same time
        Dec(TotalThreads);
        Exit;
      end;

      // Synchronize
      TThread.Synchronize(nil, procedure
        begin
          if InfoBox.Visible and (ItemIndex = InfoBoxIndex) then
            (* Info Box *)
            InfoBox.Song_Cover.Picture.Assign( DrawItems[ItemIndex].GetPicture )
              else
                (* Box Draw *)
                UIForm.RedrawPaintBox;

          Dec(TotalThreads);
        end);

    end) do
      // Thread Prepare
      begin
        Priority := tpLowest;

        FreeOnTerminate := true;

        Start;
      end;
end;

function TDrawableItem.ToggleDownloaded: boolean;
var
  ListIndex: integer;
  LastValue: string;

  List: ^TStringList;
begin
  // Offline Mode
  if IsOffline then
    begin
      OpenDialog('Connect to a network', 'To change downloads, please connect to a network', ctInformation);

      Exit(false);
    end;

  // Download
  LastValue := ItemID.ToString;

  // Index
  case Source of
    TDataSource.Tracks: List := @DownloadedTracks;
    TDataSource.Albums: List := @DownloadedAlbums;
    TDataSource.Artists: List := @DownloadedArtists;
    TDataSource.Playlists: List := @DownloadedPlaylists;
    else Exit(false);
  end;

  ListIndex := List.IndexOf(LastValue);

  // Download / Delete
  if ListIndex = -1 then
    // Add
    List.Add( LastValue )
      else
        // Delete
        if OpenDialog('Are you sure?', 'Are you sure you wish to delete this from your downloads?', ctQuestion, [mbNo, mbYes]) = mrYes then
          List.Delete( ListIndex );

  Result := Downloaded;

  // Update
  UIForm.UpdateDownloads;
end;

end.
