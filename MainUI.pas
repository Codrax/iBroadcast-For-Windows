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
  Vcl.Imaging.pngimage, DebugForm, Cod.Visual.Slider, Cod.WindowsRT.MediaControls,
  Cod.ColorUtils, Cod.Graphics, Cod.VarHelpers, Cod.Types,
  Cod.Visual.StandardIcons, Imaging.jpeg, Threading, Cod.Dialogs,
  Vcl.Imaging.GIFImg, Cod.Visual.Panels, IOUtils, Cod.Internet,
  Cod.Audio, UITypes, Types, Math, Performance,  Cod.WindowsRT.AppRegistration,
  Cod.Math, System.IniFiles, System.Generics.Collections, Web.HTTPApp,
  Bass, System.Win.TaskbarCore, Vcl.Taskbar, Cod.Visual.CheckBox,
  Vcl.ControlList, Vcl.OleCtrls, SHDocVw, Vcl.Menus,
  Cod.WindowsRT.MasterVolume, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, CreatePlaylistForm, Offline, Cod.StringUtils, iBroadcastUtils,
  PickerDialogForm, Vcl.Clipbrd, DateUtils, Cod.Visual.Scrollbar, Cod.Windows,
  Cod.Version, Cod.ArrayHelpers, Cod.Components, RatingPopup, Cod.GDI,
  CodeSources, SpectrumVis3D, Vcl.Buttons, LoggingForm, Cod.CodrutSoftware.API.Update;

const
  WM_CUSTOMAPPMESSAGE = WM_USER + 100;
  WM_RESTOREMAINWINDOW = WM_CUSTOMAPPMESSAGE + 1;

type
  // Cardinals
  TViewStyle = (List, Cover);
  TRepeat = (Off, All, One);
  TSortType = (Default, Alphabetic, Year, Rating, Flipped);
  TSortTypes = set of TSortType;
  TSearchFlag = (ExactMatch, CaseSensitive, SearchInfo, SearchTrashed);
  TSearchFlags = set of TSearchFlag;
  TPlayType = (Streaming, Local, CloudDownload);
  TDownloadedKind = (None, Direct, Indirect); // for tracks downloaded from an album

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

    ItemID: string;

    Title: string;
    InfoShort: string;
    InfoLong: string;
    Rating: integer;

    HiddenItem: boolean;
    HiddenSearch: boolean;
    Trashed: boolean;

    Information: TArray<string>;

    Bounds: TRect;
    Source: TDataSource;

    (* Other data *)
    OnlyQueue: boolean;
    Loaded: boolean;

    (* Mix data *)
    function Hidden: boolean;
    function Downloaded: boolean;
    function Active: boolean;

    function HasSecondary: boolean;

    function IsDownloaded: TDownloadedKind;

    function ToggleDownloaded: boolean;

    (* Data Information *)
    function GetPremadeInfoList: string;
    function GetPicture: TJPEGImage;

    (* When Clicked *)
    procedure Execute;
    procedure ExecuteSecondary;
    procedure OpenInformation;

    (* UI *)
    function Invalid: boolean;

    (* Manage Library *)
    procedure TrashFromLibrary;
    procedure RestoreFromLibrary;

    (* Audo Load *)
    procedure LoadSourceID(ID: string; From: TDataSource);
    procedure LoadSource(AIndex: integer; From: TDataSource);
    procedure ReloadSource;

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
    TopbarContainer: TPanel;
    PagesHolder: TPanel;
    Song_Player: TPanel;
    Panel6: TPanel;
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
    Page_SubView: TPanel;
    DrawItem_Clone1: TPaintBox;
    Panel1: TPanel;
    SubView_Cover: CImage;
    Panel4: TPanel;
    SubView_Type: TLabel;
    Label5: TLabel;
    SortModeToggle: TPanel;
    Sort_Default: CButton;
    Sort_Alphabetic: CButton;
    Sort_Date: CButton;
    Sort_Rating: CButton;
    Button_Extend: CButton;
    Queue_Extend: TPanel;
    QueuePopupAnimate: TTimer;
    Panel5: TPanel;
    Player_Position: CSlider;
    Time_Pass: TLabel;
    QueueDraw: TPaintBox;
    QueueDownGo: TTimer;
    Label3: TLabel;
    Panel15: TPanel;
    Taskbar1: TTaskbar;
    ActionList1: TActionList;
    Action_Play: TAction;
    Action_Next: TAction;
    Action_Previous: TAction;
    CButton10: CButton;
    Page_Settings: TPanel;
    ScrollBox3: TScrollBox;
    Label24: TLabel;
    Setting_Graph: CCheckBox;
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
    Label33: TLabel;
    CButton1: CButton;
    LoginItems: TControlList;
    Label34: TLabel;
    Label35: TLabel;
    ICON_CONNECT: TLabel;
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
    Download_Status: TLabel;
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
    TracksControl: TPanel;
    Button_ShuffleTracks: CButton;
    HomeDraw: TPaintBox;
    Welcome_Label: TLabel;
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
    Artwork_Storage: TLabel;
    Settings_DisableAnimations: CCheckBox;
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
    Panel14: TPanel;
    Queue_Label: TLabel;
    Button_ClearQueue: CButton;
    QueueLoadWhenFinished: TTimer;
    ControlBarContainer: TPanel;
    Controlbar_Playlist: TPanel;
    CButton31: CButton;
    Label4: TLabel;
    Controlbar_Downloads: TPanel;
    Download_Filters: TPanel;
    Label38: TLabel;
    DownFilder_3: CButton;
    DownFilder_2: CButton;
    DownFilder_4: CButton;
    DownFilder_5: CButton;
    DownFilder_1: CButton;
    Label_Storage: TLabel;
    Label18: TLabel;
    N13: TMenuItem;
    Delete1: TMenuItem;
    Addtoplaylist1: TMenuItem;
    N14: TMenuItem;
    CopyID1: TMenuItem;
    CopyID2: TMenuItem;
    CopyID3: TMenuItem;
    CopyID4: TMenuItem;
    Panel10: TPanel;
    Download_SubView: CButton;
    CButton27: CButton;
    CButton28: CButton;
    Add_Type: TPopupMenu;
    Addtracks1: TMenuItem;
    Addalbum1: TMenuItem;
    Playartists1: TMenuItem;
    Playplaylist1: TMenuItem;
    Cleanupplaylist1: TMenuItem;
    ScrollPosition: CScrollbar;
    Scrollbar_6: CScrollbar;
    Scrollbar_4: CScrollbar;
    Scrollbar_1: CScrollbar;
    QueueScroll: CScrollbar;
    N15: TMenuItem;
    Addtracks2: TMenuItem;
    Setting_SongStreaming: CCheckBox;
    Button_Rating: CButton;
    Setting_Rating: CCheckBox;
    IdHTTP1: TIdHTTP;
    Panel11: TPanel;
    Song_Cover: CImage;
    Visualisation_Player: TPaintBox;
    VisualisationRenderer: TTimer;
    Setting_Visualisations: CCheckBox;
    Visual_Icon: TLabel;
    Button_SaveQueue: CButton;
    Trash1: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    Trash2: TMenuItem;
    N18: TMenuItem;
    Trash3: TMenuItem;
    Controlbar_Trash: TPanel;
    Label6: TLabel;
    CButton30: CButton;
    CButton32: CButton;
    CButton33: CButton;
    CButton35: CButton;
    CButton34: CButton;
    Search_Filters: TFlowPanel;
    Label31: TLabel;
    CCheckBox2: CCheckBox;
    CCheckBox3: CCheckBox;
    CCheckBox1: CCheckBox;
    CCheckBox4: CCheckBox;
    Restore1: TMenuItem;
    Restore2: TMenuItem;
    Restore3: TMenuItem;
    SaveAs1: TMenuItem;
    Controlbar_ArtistManage: TPanel;
    Label7: TLabel;
    CButton36: CButton;
    CButton37: CButton;
    SaveMusicDialog: TSaveDialog;
    Christmas_Mode: CImage;
    CButton38: CButton;
    Page_About: TPanel;
    ScrollBox1: TScrollBox;
    Version_Label: TLabel;
    Label28: TLabel;
    Label25: TLabel;
    CImage12: CImage;
    CImage13: CImage;
    Label26: TLabel;
    Label27: TLabel;
    Label11: TLabel;
    Latest_Version: TLabel;
    CButton15: CButton;
    CButton8: CButton;
    CButton14: CButton;
    CButton16: CButton;
    CButton18: CButton;
    CButton24: CButton;
    CButton26: CButton;
    CButton29: CButton;
    CButton39: CButton;
    CButton40: CButton;
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
    procedure QueueLoadWhenFinishedTimer(Sender: TObject);
    procedure CButton31Click(Sender: TObject);
    procedure PopupGeneralDelete(Sender: TObject);
    procedure Addtoplaylist1Click(Sender: TObject);
    procedure CopyIDGeneral(Sender: TObject);
    procedure CButton27Click(Sender: TObject);
    procedure CButton28Click(Sender: TObject);
    procedure Addtracks1Click(Sender: TObject);
    procedure Playplaylist1Click(Sender: TObject);
    procedure Playartists1Click(Sender: TObject);
    procedure Addalbum1Click(Sender: TObject);
    procedure Popup_PlaylistPopup(Sender: TObject);
    procedure PopupGeneralViewAlbum(Sender: TObject);
    procedure Cleanupplaylist1Click(Sender: TObject);
    procedure Quick_SearchKeyPress(Sender: TObject; var Key: Char);
    procedure Addtracks2Click(Sender: TObject);
    procedure Song_CoverMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Popup_TrackPopup(Sender: TObject);
    procedure Button_RatingClick(Sender: TObject);
    procedure Setting_RatingChange(Sender: CCheckBox; State: TCheckBoxState);
    procedure Artwork_StorageClick(Sender: TObject);
    procedure CButton29Click(Sender: TObject);
    procedure VisualisationRendererTimer(Sender: TObject);
    procedure Song_CoverClick(Sender: TObject);
    procedure Setting_VisualisationsChange(Sender: CCheckBox;
      State: TCheckBoxState);
    procedure Song_ArtistClick(Sender: TObject);
    procedure Queue_LabelClick(Sender: TObject);
    procedure Button_SaveQueueClick(Sender: TObject);
    procedure DeleteFilterSel(Sender: TObject);
    procedure PopupGeneralRestore(Sender: TObject);
    procedure Popup_AlbumPopup(Sender: TObject);
    procedure Popup_ArtistPopup(Sender: TObject);
    procedure CButton34Click(Sender: TObject);
    procedure SystemMenuOpen(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ArtistViewSel(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure CButton40Click(Sender: TObject);
    procedure CButton39Click(Sender: TObject);
  private
    { Private declarations }
    // Vars
    FAudioSpeed,
    FAudioVolume: single;

    // Detect mouse Back/Forward
    procedure WMAppCommand(var Msg: TMessage); message WM_APPCOMMAND;

    // Detect mouse Back/Forward
    procedure WMRestoreMainWindow(var Msg: TMessage); message WM_RESTOREMAINWINDOW;

    // Shutting down / Logging off
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession); message WM_QUERYENDSESSION;

    // Items
    function GetItemCount(OnlyVisible: boolean = false): cardinal;
    procedure LoadItemInfo;

    function GetTracksID: TArray<string>;
    function GetPageViewType: TDataSource;

    // Draw Box
    procedure RecalibrateScroll;
    procedure DrawItemCanvas(Canvas: TCanvas; ARect: TRect; Title, Info: string;
      Picture: TJpegImage; HasPlayButton, Active, Hovered: boolean; Downloaded: TDownloadedKind);
    procedure DrawWasClicked(Shift: TShiftState; Button: TMouseButton; ActiveZone: boolean);
    procedure SetDownloadIcon(Value: boolean; Source: TDataSource);

    // Drawing List
    procedure AddItems(IDArray: TArray<string>; Source: TDataSource;
      Clear: boolean = false; RemoveTrashed: boolean = false);

    // UI
    procedure ReselectPage;
    procedure TweakPageUI;
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

    // Event Proc
    procedure VolumeAppChange(Sender: TAppAudioManager; const NewVolume: Single; NewMute: boolean);
    procedure VolumeSysChange(Sender: TSystemAudioManager; const Volume: Single; Muted: boolean);

    (* Download Mode *)
    procedure DownloadStatusWorkDownload(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure DownloadStatusWorkBeginDownload(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);

    (* Cloud mode *)
    procedure DownloadStatusWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure DownloadStatusWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);

    procedure BackendUpdate(AUpdate: TDataSource);

    // Visualisations
    procedure VisualisationUICheck;
    procedure RenderVisualisations;
    procedure SetEnableVisualisations(ATo: boolean; Force: boolean = false);

    // Setters
    procedure SetAudioSpeed(const Value: single);
    procedure SetAudioVolume(const Value: single);

  public
    { Public declarations }
    procedure NavigatePath(Path: String; AddHistory: boolean = true);
    function GetPathValue(Name: string): string;
    procedure SetPathValue(Name: string; Data: string);

    // Player
    procedure PlaySong(Index: cardinal; StartPlay: boolean = true);
    procedure PlayCloudSongLocally(Endpoint: string);

    procedure SongUpdate;
    procedure StatusChanged;
    procedure UpdateRatingIcon;
    procedure UpdateVolumeIcon;
    procedure MediaControlsUpdateTimeline;
    procedure TickUpdate;

    procedure LoadPlayerSettings;

    procedure AddSongToHistory;

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

    procedure MusicSeekTo(Value: int64);
    procedure MusicSeekBy(Value: int64);

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

    procedure DeleteDownloaded(MusicID: string);

    // Font
    function GetSegoeIconFont: string;

    // Login
    procedure PrepareForLogin;
    procedure InitiateLogin;
    procedure PrepareLoginUI;

    procedure LoaderStopAnimation;

    procedure InitiateOfflineMode;
    procedure LoadOfflineModeData;
    function ObtainIDFromFileName(FileName: string): string;
    function HasOfflineBackup: boolean;

    // Data
    function CalculateLength(Seconds: cardinal): string;

    // Threads
    procedure ThreadSyncStatus(Str: string);
    procedure EdidThreadFinalised;

    // Update
    procedure StartCheckForUpdate;
    procedure GetVersionUpdateData;
    procedure BeginUpdate(DownloadURL: string);

    // Library
    procedure ReloadLibrary;

    // Application Tray
    procedure MinimiseToTray;
    procedure OpenFromTray;

    procedure CloseApplication;
    procedure CancelClose;

    // Forms
    procedure MinimizeToMiniPlayer;
    procedure RestoreMainWindow;

    // External Update
    procedure SetCurrentSongRating(AValue: integer);

    // Media event updates
    procedure MediaControlsButton(Sender: TTransportCompatibleClass; Button: TSystemMediaTransportControlsButton);
    procedure MediaControlsPos(Sender: TTransportCompatibleClass; Value: int64);
    procedure MediaControlsRate(Sender: TTransportCompatibleClass; Value: double);
    procedure MediaControlsShuffle(Sender: TTransportCompatibleClass; Value: boolean);
    procedure MediaControlsRepeat(Sender: TTransportCompatibleClass; Value: TMediaPlaybackAutoRepeatMode);

    // Utils
    function IntArrayToStr(AArray: TArray<integer>): string;
    function StrArrayToStr(AArray: TArray<string>): string;
    function StrToIntArray(Str: string): TArray<integer>;
    function StrToStrArray(Str: string): TArray<string>;

    // Properties
    property AudioSpeed: single read FAudioSpeed write SetAudioSpeed;
    property AudioVolume: single read FAudioVolume write SetAudioVolume;
  end;

  // Logging
  procedure AddToLog(ALog: string);

  procedure WorkStatusChange(Status: string);
  procedure WorkDataStatusChange(Status: string);

const
  // SYSTEM
  APP_NAME = 'Cod'#39's iBroadcast';
  APP_DESCRIPTION = 'Codrut'#39's iBroadcast for Windows';
  APP_USERMODELID = 'com.codrutsoft.ibroadcast';

  VERSION: TVersion = (Major:1; Minor:10; Maintenance: 3);

  API_APPNAME = 'ibroadcast';

  // UI
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
    'History', 'Account', 'Settings', 'About', 'Premium', 'Downloads', 'Trash'];

  ViewCompatibile: TArray<string> = ['albums', 'songs', 'artists', 'playlists',
    'genres', 'history', 'downloads', 'trash'];
  SubViewCompatibile: TArray<string> = ['viewalbum', 'viewartist',
    'viewplaylist', 'history'];

  // DOWNLOAD
  DOWNLOAD_DIR = 'downloaded\';
  TEMP_DIR = 'temp\';

  // Sizes
  QUEUE_MIN_SIZE = 1;

  // HOME
  HOME_COLUMNS = 5;

var
  UIForm: TUIForm;

  // System
  VersionChecker: TStandardVersionCheckerUpdateUrl;

  // Player
  Player: TAudioPlayer;

  SeekPoint: integer;
  IsSeeking: boolean;
  NeedSeekUpdate: boolean;
  SeekUpdateStatus: TPlayStatus;
  SeekTimeout: integer;

  // Application Data
  AppData: string;

  // Audio Manager
  VolumeApplication: TAppAudioManager;
  VolumeSystem: TSystemAudioManager;

  // Spectrums
  Spectrum_Player,
  Spectrum_Mini: TSpectrum;

  // Downloads
  AllDownload: TStringList;
  DownloadQueue: TStringList;

  DownloadThread: TThread;
  DownloadThreadsE: integer;

  DownloadedTracks: TStringList;
  DownloadedAlbums: TStringList;
  DownloadedArtists: TStringList;
  DownloadedPlaylists: TStringList;

  DownloadsFilter: TDataSource;

  // Trash
  TrashFilter: TDataSource = TDataSource.Tracks;

  // Page System
  PageHistory: TArray<THistorySet>;

  BareRoot: string;
  LastValueID: string;
  LastExecutedSource: TDataSource;

  Location,
  LocationExtra,
  LocationROOT: string;
  LocationPath: TStringArray;

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
  IndexPress,
  IndexHover,
  IndexHoverSort: integer;
  HoverActiveZone: boolean;

  EnableVisualisations: boolean = true;

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
  PopupDrawItem: TDrawableItem;
  PopupSource: TDataSource;

  // Cloud Download
  CloudDownloadLocalThread: TThread;
  ServerCloudDownload,
  ServerCloudPlay, // Tells to play the song after download
  LastThreadFileLocked: boolean; // Tells if the file is currrently locked
  DownloadWorkCount,
  DownloadLastPercent: integer;
  CloudDownloadWorkCount,
  CloudDownloadLastPercent: integer;

  // SYSTEM
  THREAD_MAX: cardinal = 10;
  THREAD_EDITOR_MAX: cardinal = 1;
  LastUpdateCheck: TDate;

  // Logging
  EnableLogging: boolean = false;
  EnableLog32: boolean = false;
  PrivacyEnabled: boolean = true;

  // Queue System
  PlayIndex: integer = -1;
  PlayID: string = '';
  PlayTimeStamp: TDateTime;

  QueuePos: integer;
  PlayQueue: TIntegerList;
  { INFO: Uses Play-Index instead of Play-ID for performance benefits,
    the downside being if the library changes during runtime /
    the queue is re-loaded after the library changes }

  Shuffled: boolean;
  OriginalQueueValid: boolean;
  PlayQueueOriginal: TIntegerList;

  RepeatMode: TRepeat = TRepeat.All;

  // Server
  ArtworkID: integer = 1;

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

  // Player
  MediaControls: TWindowMediaTransportControls;
  LastTimeLineUpdate: TDateTime;

  // Page Specific Data
  SavedViews: TArray<TViewSave>;

  // Search
  LastFilterQuery: string;

  // Threading
  TotalThreads: cardinal;

  EditorThread: cardinal;

  // Colors
  ItemColor: TColor;
  ItemActiveColor: TColor;
  TextColor: TColor;

  // Special time
  ChristmasMode: boolean;

implementation

{$R *.dfm}

uses
  // Forms
  InfoForm, VolumePopup, MiniPlay, NewVersionForm;

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

procedure TUIForm.Addalbum1Click(Sender: TObject);
var
  Songs, PickerItems: TArray<string>;
  Index, I: Integer;
  J: Integer;
begin
  PickItems(PickerItems, TPickType.Album, true);

  for J := 0 to High(PickerItems) do
    begin
      Songs := Albums[GetAlbum(PickerItems[J])].TracksID;

      for I := 0 to High(Songs) do
        begin
          Index := GetTrack(Songs[I]);
          AddQueue(Index);
        end;
    end;
end;

procedure TUIForm.AddItems(IDArray: TArray<string>; Source: TDataSource;
  Clear, RemoveTrashed: boolean);
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

      DrawItems[Start + I].HiddenItem := RemoveTrashed and DrawItems[Start + I].Trashed;
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

procedure TUIForm.AddSongToHistory;
var
  Item: THistoryItem;
begin
  Item.TrackID := PlayID;
  Item.TimeStamp := Now;

  // Push
  with TThread.CreateAnonymousThread(procedure
    begin
      // Status
      ThreadSyncStatus('Pushing history to server...');

      // Push
      PushHistory([Item]);

      // Finish
      EdidThreadFinalised;
    end) do
      begin
        Priority := tpLowest;

        FreeOnTerminate := true;
        Start;
      end;
end;

procedure TUIForm.Addtoplaylist1Click(Sender: TObject);
var
  Existing,
  Selected,
  Hidden: TArray<string>;
  I: Integer;
  AIndex: integer;
  ID: string;
procedure AddToHidden(Items: TArray<string>);
var
  I, Index: integer;
begin
  Hidden := [];

  for I := 0 to High(Items) do
    begin
      Index := GetPlaylistOfType(Items[I]);
      if Index <> -1 then
        Hidden.AddValue(Playlists[Index].ID);
    end;
end;
begin
  ID := PopupDrawItem.ItemID;

  // Hide system playlists
  AddToHidden(['thumbsup', 'recently-played', 'recently-uploaded']);

  // Load
  Existing := GetSongPlaylists(ID);
  if not PickItems(Selected, TPickType.Playlist, true, Existing, Hidden) then
    Exit;

  // Remove same
  for I := High(Existing) downto 0 do
    begin
      AIndex := Selected.Find(Existing[I]);

      if AIndex <> -1 then
        begin
          // Remove from playlists
          Selected.Delete(AIndex);
          Existing.Delete(I);
        end;
    end;

  // Thread
  if EditorThread < THREAD_EDITOR_MAX then
    with TThread.CreateAnonymousThread(procedure
      begin
        var
          I: integer;

        // Status
        ThreadSyncStatus('Changing playlists...');

        // Increase
        Inc(EditorThread);

        // Remove from deleted
        for I := 0 to High(Existing) do
          DeleteFromPlaylist(Existing[I], [ID]);

        // Add to new
        for I := 0 to High(Selected) do
          AppentToPlaylist(Selected[I], [ID]);

        // Decrease
        Dec(EditorThread);

        // Finish
        EdidThreadFinalised
      end) do
          begin
            Priority := tpLowest;

            FreeOnTerminate := true;
            Start;
          end;
end;

procedure TUIForm.Addtracks1Click(Sender: TObject);
var
  Songs: TArray<string>;
  Index, I: Integer;
begin
  PickItems(Songs, TPickType.Song, true);

  for I := 0 to High(Songs) do
    begin
      Index := GetTrack(Songs[I]);
      AddQueue(Index);
    end;
end;

procedure TUIForm.Addtracks2Click(Sender: TObject);
var
  Existing,
  Selected: TArray<string>;
  I: Integer;
  AIndex: integer;
  ID: string;
begin
  ID := PopupDrawItem.ItemID;

  // Offline
  if IsOffline then
    begin
      OfflineDialog('Cannot edit playlist in Offline Mode. Please connect to the internet.');
      Exit;
    end;

  // Load
  Existing := Playlists[GetPlaylist(ID)].TracksID;
  if not PickItems(Selected, TPickType.Song, true, Existing, []) then
    Exit;

  // Remove same
  for I := High(Existing) downto 0 do
    begin
      AIndex := Selected.Find(Existing[I]);

      if AIndex <> -1 then
        begin
          // Remove from playlists
          Selected.Delete(AIndex);
          Existing.Delete(I);
        end;
    end;

  // Thread
  if EditorThread < THREAD_EDITOR_MAX then
    with TThread.CreateAnonymousThread(procedure
      begin
        // Increase
        Inc(EditorThread);

        // Status
        ThreadSyncStatus('Changing playlist...');

        try
          // Add new tracks
          AppentToPlaylist(ID, Selected);

          // Delete tracks
          DeleteFromPlaylist(ID, Existing);
        except
          // Offline
          TThread.Synchronize(nil,
            procedure
              begin
                OfflineDialog('We can'#39't modify the playlist. Are you connected to the internet?');
              end);
        end;

        // Decrease
        Dec(EditorThread);

        // Finish
        EdidThreadFinalised
      end) do
          begin
            Priority := tpLowest;

            FreeOnTerminate := true;
            Start;
          end;
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
      DestQueuePopup := QUEUE_MIN_SIZE;
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
  MinimizeToMiniPlayer;
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

procedure TUIForm.Button_SaveQueueClick(Sender: TObject);
var
  ATracks: TArray<string>;
  I, AIndex: Integer;
  AName: string;
begin
  // Empty
  if PlayQueue.Count = 0 then
    begin
      OpenDialog('Queue empty', 'The play queue is empty');
      Exit;
    end;

  // Name
  if not OpenQuery('Create new playlist', 'Enter the name for the new playlist', AName) then
    Exit;

  // Save queue as playlist
  ATracks := [];
  for I := 0 to PlayQueue.Count-1 do
    begin
      AIndex := PlayQueue[I];

      if AIndex <> -1 then
        ATracks.AddValue( Tracks[AIndex].ID );
    end;

  // Create
  CreateNewPlayList(AName, '', false, ATracks);
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

procedure TUIForm.CancelClose;
begin
  // Alpha Blend (hide flickering window)
  AlphaBlend := false;
  AlphaBlendValue := 255;
end;

procedure TUIForm.Button_RatingClick(Sender: TObject);
var
  P: TPoint;
begin
  RatingPopupForm := TRatingPopupForm.Create(Self);
  with RatingPopupForm do
    try
      PrepButtons( ValueRatingMode );

      with CButton(Sender) do
        P := ClientToScreen(Point(Width div 2, 0));

      Top := P.Y - Height - 10;
      Left := P.X - Width div 2;

      Show;
    finally
      // Free;
      { Freed by self }
    end;
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

procedure TUIForm.BackendUpdate(AUpdate: TDataSource);
procedure UpdateAndDraw;
begin
  // Thread syncronise, in some cases this is called from a NON-UI thread
  TThread.Synchronize(nil,
    procedure
    begin
      LoadItemInfo;
      Sort;
      RedrawPaintBox;
    end);
end;
const
  ANY_UPD: TStringArray = ['trash', 'search'];
var
  ARoot: string;
begin
  ARoot := BareRoot;

  // Update for any view
  if ANY_UPD.Find(ARoot) <> -1 then
    begin
      UpdateAndDraw;

      Exit;
    end;
                 
  // Specific Update
  if ARoot <> '' then
    case AUpdate of
      TDataSource.Tracks: begin
        if (SubViewCompatibile.Find(ARoot) <> -1) or (ARoot = 'tracks') then
          UpdateAndDraw;
      end;

      TDataSource.Albums: begin
        if (ARoot = 'viewalbum') or (ARoot = 'albums') then
          UpdateAndDraw;
      end;

      TDataSource.Artists: begin
        if (ARoot = 'viewartist') or (ARoot = 'artists') then
          UpdateAndDraw;
      end;

      TDataSource.Playlists: begin
        if (ARoot = 'viewplaylist') or (ARoot = 'playlists') then
          UpdateAndDraw;
      end;
    end;
end;

procedure TUIForm.BeginUpdate(DownloadURL: string);
var
  Installer: string;
begin
  try
    Installer := ReplaceWinPath('%TMP%\installer_ibroadcast.exe');
    if DownloadFile(DownloadURL, Installer) then
      begin
        ShellRun(Installer, true, '-ad', true);
        Application.Terminate;
      end;
  except
    OpenDialog('Update failed.', 'An error occured downloading the latest version.');
  end;
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
    1: URL  := 'https://www.codrutsoft.com/';
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
  ShellRun('https://docs.codrutsoft.com/apps/ibroadcast/', true);
end;

procedure TUIForm.CButton23Click(Sender: TObject);
begin
  if Advanced_Login.Visible
    or (OpenDialog('Advanced Login', 'Would you like to toggle Advanced Login?', ctQuestion, [mbYes, mbNo]) = mrYes) then
    Advanced_Login.Visible := not Advanced_Login.Visible;

  if Advanced_Login.Visible then
    Advanced_Login.Top := 0;

  // Draw
  LoginBox.Invalidate;
end;

procedure TUIForm.CButton25Click(Sender: TObject);
begin
  ClearArtworkStore;

  InitiateArtworkStore;
  CalculateGeneralStorage;
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

procedure TUIForm.CButton27Click(Sender: TObject);
var
  Item: TDrawAbleItem;
begin
  Item.LoadSourceID(LocationExtra, GetPageViewType);
  Item.OpenInformation;
end;

procedure TUIForm.CButton28Click(Sender: TObject);
var
  P: TPoint;
begin
  with CButton(Sender) do
    begin
      P := ClientToScreen(Point(0, Height));
      Add_Type.Popup( P.X, P.Y);
    end;
end;

procedure TUIForm.CButton29Click(Sender: TObject);
begin
  SourceUI := TSourceUI.Create(Application);
    with SourceUI do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TUIForm.CButton31Click(Sender: TObject);
begin
  CreatePlaylist := TCreatePlaylist.Create(Self);
  try
    CreatePlaylist.ShowModal;

    // Update by BackendUpdate
  finally
    CreatePlaylist.Free;
  end;
end;

procedure TUIForm.CButton34Click(Sender: TObject);
begin
  if OpenDialog('Are you sure?', 'Are you sure you want to empty the trash? This action is irreversible.', ctQuestion, [mbYes, mbNo]) = mrYes then
    CompleteEmptyTrash;
end;

procedure TUIForm.CButton39Click(Sender: TObject);
begin
  ShellRun('https://www.codrutsoft.com/apps/ibroadcast/', true);
end;

procedure TUIForm.CButton40Click(Sender: TObject);
begin
  with TThread.CreateAnonymousThread(procedure
    begin
      // Visible UI Wait
      TThread.Synchronize(nil, procedure
        begin
          TLabel(Sender).Enabled := false;
          TLabel(Sender).Caption := 'Latest version on server: 🕑 Checking...';
        end);
      Sleep(750);

      // Start
      TThread.Synchronize(nil, procedure
        begin
          TLabel(Sender).Enabled := true;
          // Check
          StartCheckForUpdate;
        end);
    end) do
      begin
        FreeOnTerminate := true;
        Start;
      end;
end;

procedure TUIForm.ArtistViewSel(Sender: TObject);
begin
  // Sel
  if CButton(Sender).Tag = 0 then
    SetPathValue('viewmode', 'tracks')
  else
    SetPathValue('viewmode', 'albums');

  LoadItemInfo;
  Sort;
  TweakPageUI;

  // Draw
  RedrawPaintBox;
end;

procedure TUIForm.DeleteFilterSel(Sender: TObject);
var
  I: Integer;
  Previous: TDataSource;
begin
  Previous := TrashFilter;
  TrashFilter := TDataSource(CButton(Sender).Tag);

  // Same
  if TrashFilter = Previous then
    Exit;

  // Buttons
  for I := 0 to Controlbar_Trash.ControlCount - 1 do
    if Controlbar_Trash.Controls[I] is CButton then
      with CButton(Controlbar_Trash.Controls[I]) do
        FlatButton := Tag = Integer(TrashFilter);

  // Load
  LoadItemInfo;
  Sort;

  // Scroll
  ScrollPosition.Position := 0;

  // Draw
  RedrawPaintBox;
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

procedure TUIForm.DownloadStatusWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  Percent: integer;
begin
  // Abort Download
  if not ServerCloudDownload then
    begin
      EdidThreadFinalised;

      // Stop
      TIdHttp(ASender).Disconnect(true);
    end;

  // Status
  Percent := round(AWorkCount / CloudDownloadWorkCount * 100);

  if Percent <> CloudDownloadLastPercent then
    begin
      CloudDownloadLastPercent := Percent;

      ThreadSyncStatus(Format('Downloading cloud song %D%%', [Percent]));
    end;
end;

procedure TUIForm.DownloadStatusWorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  CloudDownloadWorkCount := AWorkCountMax;
end;

procedure TUIForm.DownloadStatusWorkBeginDownload(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  DownloadWorkCount := AWorkCountMax;
end;

procedure TUIForm.DownloadStatusWorkDownload(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCount: Int64);
var
  Percent: integer;
begin
  // Status
  Percent := round(AWorkCount / DownloadWorkCount * 100);

  if Percent <> DownloadLastPercent then
    begin
      DownloadLastPercent := Percent;

      ThreadSyncStatus(Format('Downloading song %D%%', [Percent]));
    end;
end;

procedure TUIForm.ArtworkSelectClick(Sender: TObject);
begin
  // Artwork
  ArtworkID := CButton(Sender).Tag;

  ReloadArtwork;
end;

procedure TUIForm.Artwork_StorageClick(Sender: TObject);
begin
  with TThread.CreateAnonymousThread(procedure
    begin
      // Visible UI Wait
      TThread.Synchronize(nil, procedure
        begin
          TLabel(Sender).Enabled := false;
          TLabel(Sender).Caption := 'Storage Used by Artwork: 🕑 Calculating...';
        end);
      Sleep(750);

      // Start
      TThread.Synchronize(nil, procedure
        begin
          TLabel(Sender).Enabled := true;
          CalculateGeneralStorage;
        end);
    end) do
      begin
        FreeOnTerminate := true;
        Start;
      end;
end;

procedure TUIForm.SType_SongClick(Sender: TObject);
begin
  with CButton(Sender) do
    FlatButton := not FlatButton;

  // Draw
  RedrawPaintBox;
end;

procedure TUIForm.Button_ToggleMenuClick(Sender: TObject);
begin
  if Settings_DisableAnimations.Checked then
    LockWindowUpdate(Handle);

  if not SplitView1.Locked then
    SplitView1.Opened := not SplitView1.Opened;
    
  if Settings_DisableAnimations.Checked then
    LockWindowUpdate(0);  
end;

procedure TUIForm.Button_PerformanceClick(Sender: TObject);
begin
  // CPU Usage Form
  if PerfForm = nil then
    PerfForm := TPerfForm.Create(Application);
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
          // Create
          if VolumePop = nil then
            VolumePop := TVolumePop.Create(Application);

          // Volume
          VolumePop.Top := Button_Volume.ClientToScreen(Point(0, 0)).Y - VolumePop.Height;
          VolumePop.Left := Button_Volume.ClientToScreen(Point(0, 0)).X - VolumePop.Width + Button_Volume.Width;

          VolumePop.FullUpdate;

          VolumePop.Show;

          VolumePop.UpdateTheSize;
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
    11: NavigatePath( 'Trash' );
    12: NavigatePath( 'About' );
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

procedure TUIForm.Cleanupplaylist1Click(Sender: TObject);
begin
  if IsOffline then
    OfflineDialog('Cannot clean playlist in Offline Mode. Please connect to the internet.')
  else
    if OpenDialog('Start cleanup?', 'Cleanup will remove invalid songs that iBroadcast may have left and update the playlist accordingly. No data loss will occur, only invalid enteries will be removed.',
      ctQuestion, [mbYes, mbNo]) = mryes then
      if (EditorThread < THREAD_EDITOR_MAX) then
        with TThread.CreateAnonymousThread(procedure
          begin
            // Increase
            Inc(EditorThread);

            // Status
            ThreadSyncStatus('Repairing Playlist...');

            // Delete
            try
              TouchupPlaylist(PopupDrawItem.ItemID);

              // Redraw
              TThread.Synchronize(nil,
                procedure
                  begin
                    LoadItemInfo;
                    RedrawPaintBox;
                    Sort;
                  end);
            except
              // Offline
              TThread.Synchronize(nil,
                procedure
                  begin
                    OfflineDialog('We can'#39't repair the playlist. Are you connected to the internet?');
                  end);
            end;

            // Decrease
            Dec(EditorThread);

            // Finish
            EdidThreadFinalised
          end) do
            begin
              Priority := tpLowest;

              FreeOnTerminate := true;
              Start;
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

  // Alpha Blend (hide flickering window)
  AlphaBlend := true;
  AlphaBlendValue := 0;

  // Close UI
  Show;
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

procedure TUIForm.CopyIDGeneral(Sender: TObject);
begin
  // Copy to clipboard
  Clipboard.AsText := PopupDrawItem.ItemID;
end;

procedure TUIForm.SettingsApplyes2(Sender: CSlider; Position, Max, Min: Integer);
begin
  ApplySettings;
end;

procedure TUIForm.Setting_RatingChange(Sender: CCheckBox;
  State: TCheckBoxState);
begin
  ValueRatingMode := State = cbChecked;

  // Icon
  UpdateRatingIcon;
end;

procedure TUIForm.Setting_VisualisationsChange(Sender: CCheckBox;
  State: TCheckBoxState);
begin
  SetEnableVisualisations( State = cbChecked );
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

procedure TUIForm.DeleteDownloaded(MusicID: string);
var
  AFile: string;
  FileName: string;
  I: Integer;
begin
  AddToLog('Form.DeleteDownloaded(' + MusicID + ')');
  AFile := AppData + DOWNLOAD_DIR + MusicID;

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
  Item.LoadSourceID(LocationExtra, GetPageViewType);

  Output := Item.ToggleDownloaded;

  // Button Update
  CButton(Sender).Tag := Output.ToInteger;
  CButton(Sender).OnEnter(Sender);
end;

procedure TUIForm.DrawItemCanvas(Canvas: TCanvas; ARect: TRect; Title,
  Info: string; Picture: TJpegImage; HasPlayButton, Active, Hovered: boolean; Downloaded: TDownloadedKind);
var
  TempRect, SecondTempRect: TRect;
  Dist: integer;
  S: string;
  Br: TGDIBrush;
  Pn: TGDIPen;
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

        // Play direct button
        if HasPlayButton and Hovered then begin
          SecondTempRect := ARect;
          SecondTempRect.Height := ARect.Width;

          // Darken fade
          Br := GetRGB(10, 10, 10, 75).MakeGDIBrush;
          try
            GDIRoundRect( SecondTempRect, CoverRadius, Br, nil);
          finally
            Br.Free;
          end;

          // Center
          TempRect := SecondTempRect;
          TempRect.Height := TempRect.Width;
          TempRect.Inflate(-55, -55);

          Br := GetRGB(200, 200, 200, 150).MakeGDIBrush;
          Pn := GetRGB(200, 200, 200, 150).MakeGDIPen(3);
          try
            if HoverActiveZone then
              GDICircle(TempRect, Br, Pn)
            else
              GDICircle(TempRect, nil, Pn);
          finally
            Br.Free;
            Pn.Free;
          end;

          // Triangle
          Pen.Color := TColors.White;
          Pen.Style := psSolid;
          Pen.Width := 3;
          Brush.Style := bsClear;

          Pn := GetRGB(255, 255, 255, 200).MakeGDIPen(3);
          try
            TempRect.Inflate(-round(TempRect.Width / 3.5), -round(TempRect.Width / 3.5));
            GDIPolygon([
              Point(TempRect.Left, TempRect.Top),
              Point(TempRect.Right, TempRect.Top + TempRect.Height div 2), // Right tip
              Point(TempRect.Left, TempRect.Bottom) // Bottom left
            ], nil, Pn);
          finally
            Pn.Free;
          end;
        end;

        // Downloaded
        if Downloaded <> TDownloadedKind.None then
          begin
            Font.Assign(Self.Font);
            Font.Name := Self.GetSegoeIconFont;

            Font.Size := 26;
            if Downloaded = TDownloadedKind.Direct then
              Font.Color := TColors.Orangered
            else
              Font.Color := TColors.Dodgerblue;

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

        // Downloaded
        if Downloaded <> TDownloadedKind.None then
          begin
            Font.Assign(Self.Font);
            Font.Name := Self.GetSegoeIconFont;

            Font.Size := 26;
            if Downloaded = TDownloadedKind.Direct then
              Font.Color := TColors.Orangered
            else
              Font.Color := TColors.Dodgerblue;

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
      end;
end;

procedure TUIForm.DrawItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Anim
  Press10Stat := 0;
  PressNow.Enabled := true;

  // Down
  IndexPress := IndexHover;

  // Press
  MouseIsPress := true;
end;

procedure TUIForm.DrawItemMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  I: Integer;
  APoint: TPoint;
begin
  const LastIndexHover = IndexHover;
  const LastHoverActiveZone = HoverActiveZone;
  APoint := Point(X, Y);

  // Get Press position
  IndexHover := -1;
  IndexHoverSort := -1;
  HoverActiveZone := false;
  for I := 0 to High(DrawItems) do
    if DrawItems[I].Bounds.Contains( APoint ) then
      begin
        IndexHover := I;
        IndexHoverSort := GetSort( I );

        // Active zone?
        if DrawItems[I].HasSecondary then begin
          var R: TRect;
          R := DrawItems[I].Bounds;
          if ViewStyle = TViewStyle.Cover then
            R.Height := R.Width
          else
            R.Width := R.Height;
          R.Inflate(-55, -55);
          HoverActiveZone := R.Contains( APoint );
        end;

        Break;
      end;

  // Cancel press
  if MouseIsPress and (IndexHover <> IndexPress) then begin
    MouseIsPress := false;

    // Press status
    PressNow.Enabled := false;
    Press10Stat := 0;

    // Draw
    RedrawPaintBox;
  end;

  // Draw
  if (LastIndexHover <> IndexHover) or (LastHoverActiveZone = HoverActiveZone) then
    RedrawPaintBox;

  // Cursor
  if IndexHoverSort <> -1 then
    TPaintBox(Sender).Cursor := crHandPoint
  else
    TPaintBox(Sender).Cursor := crDefault;
end;

procedure TUIForm.DrawItemMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not MouseIsPress then
    Exit;

  // Draw Settings
  PressNow.Enabled := false;

  // Status
  Press10Stat := 10;
  Self.RedrawPaintBox;

  // Click
  if IndexHover <> -1 then
    DrawWasClicked(Shift, Button, HoverActiveZone);

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


              if (Index = IndexHoverSort) and (Press10Stat <> 0) and not HoverActiveZone then
                ARect.Inflate(-Press10Stat, -trunc(ARect.Height/ ARect.Width * Press10Stat));

              // Draw
              DrawItemCanvas(TPaintBox(Sender).Canvas, ARect, Title, Info,
                Picture,  DrawItems[Index].HasSecondary, DrawItems[Index].Active, Index = IndexHoverSort, DrawItems[Index].IsDownloaded);
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

              if (Index = IndexHoverSort) and (Press10Stat <> 0) and not HoverActiveZone then
                ARect.Inflate(-Press10Stat, -Press10Stat);

              // Draw
              DrawItemCanvas(TPaintBox(Sender).Canvas, ARect, Title, Info,
                Picture, DrawItems[Index].HasSecondary, DrawItems[Index].Active, Index = IndexHoverSort, DrawItems[Index].IsDownloaded);
            end;

          // Move Line
          Inc(Y, ListHeight + ListSpacing);

          if Y > AHeight then
            Break; Continue
        end;
    end;

  // Nothing here
  if (X = 0) and (Y = 0) and (ScrollPosition.Position = 0) then
    begin
      Title := 'Crickets... Nothing is here...';
      ARect := TPaintBox(Sender).ClientRect;
      
      TPaintBox(Sender).Canvas.TextRect(ARect, Title, 
        [tfSingleLine, tfCenter, tfVerticalCenter]);
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

procedure TUIForm.DrawWasClicked(Shift: TShiftState; Button: TMouseButton; ActiveZone: boolean);
var
  Index: integer;
begin
  Index := GetSort(IndexHover);

  // Normal Click
  if Button = mbLeft then begin
    with DrawItems[Index] do begin
      if ssCtrl in Shift then
        OnlyQueue := true;

      // Run
      if ActiveZone then
        ExecuteSecondary
      else begin
        if ssAlt in Shift then
          OpenInformation
        else
          Execute;
      end;

      OnlyQueue := false;
    end;
  end
  else begin
    // Right click
    PopupDrawIndex := Index;
    PopupSource := DrawItems[Index].Source;

    PopupDrawItem := DrawItems[Index];

    SetDownloadIcon( DrawItems[Index].Downloaded, PopupSource );

    case PopupSource of
      TDataSource.Tracks: begin
        Popup_Track.Tag := 0;
        Popup_Track.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
      end;
      TDataSource.Albums: Popup_Album.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
      TDataSource.Artists: Popup_Artist.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
      TDataSource.Playlists: Popup_Playlist.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
    end;
  end;
end;

procedure TUIForm.EdidThreadFinalised;
begin
  TThread.Synchronize(nil, procedure begin
    if Download_Status.Visible then
      Download_Status.Hide;
  end);
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
  SearchTrashed: boolean;
begin
  SearchTrashed := TSearchFlag.SearchTrashed in Flags;

  for I := 0 to High(DrawItems) do
    begin
      DrawItems[I].HiddenSearch := false;

      if Term = '' then
        Continue;

      if not SearchTrashed and DrawItems[I].Trashed then
        begin
          DrawItems[I].HiddenSearch := true;
          Continue;
        end;
        
      // Compare
      Found := CompareFound(Term, DrawItems[I].Title, Flags)
        or ((TSearchFlag.SearchInfo in Flags) and CompareFound(Term, DrawItems[I].InfoLong, Flags))
        or (DrawItems[I].ItemID = Term);

      // Visible
      DrawItems[I].HiddenSearch := not Found;
    end;

  LastFilterQuery := Term;
end;

procedure
TUIForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  I: Integer;
begin
  // Hide to tray
  if Setting_TrayClose.Checked and not HiddenToTray and not LoginUIContainer.Visible then
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
        CancelClose;
        Exit;
      end;

  // Audio Notifiers
  VolumeApplication.UnRegisterEventNotifier;
  VolumeSystem.UnRegisterEventNotifier;

  VolumeApplication.Free;
  VolumeSystem.Free;

  // Save Data
  TokenLoginInfo(false);
  ProgramSettings(false);
  PositionSettings(false);

  if not IsOffline then
    DownloadSettings(false);

  if Setting_QueueSaver.Checked then
    QueueSettings(false);

  // Disable Timers
  for I := 0 to Self.ComponentCount-1 do
    if Components[I] is TTimer then
      (Components[I] as TTimer).Enabled := false;

  // Free Memory
  Player.Free;
  PlayQueue.Free;
end;

procedure TUIForm.FormCreate(Sender: TObject);
var
  I, J: Integer;
begin
  // Style
  Cod.Components.CustomAccentColor := $00E60073;

  // Log Config
  OnWorkStatusChange := WorkStatusChange;
  OnDataWorkStatusChange := WorkDataStatusChange;

  // Log
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

  // Christmas mode
  const DayOfTheCurrentYear = DayOfTheYear(Now);
  ChristmasMode := (DayOfTheCurrentYear > 365-20) or (DayOfTheCurrentYear <= 10);

  // Christmas mode UI
  Christmas_Mode.Visible := ChristmasMode;
  if ChristmasMode then
    WELCOME_STRING := WELCOME_STRING_SPECIAL;

  // AppData
  AppData := GetPathInAppData('Cods iBroadcast', 'CodrutSoftware', TAppDataType.Local, true);

  // Audio Manager
  AddToLog('Form.Create.Create.Audio.Interfaces');
  // bass allready added application to volume mixer
  VolumeApplication := TAppAudioManager.CreateApp;
  VolumeSystem := TSystemAudioManager.Create;

  // Event
  AddToLog('Form.Create.Create.Audio.NotifyEvents');
  VolumeApplication.RegisterEventNotifier;
  VolumeSystem.RegisterEventNotifier;

  VolumeApplication.OnVolumeChange := VolumeAppChange;
  VolumeSystem.OnVolumeChange := VolumeSysChange;

  AddToLog('Preparing Downloads');
  // Prepare Downloading
  AllDownload := TStringList.Create;
  DownloadQueue := TStringList.Create;

  DownloadedTracks := TStringList.Create;
  DownloadedAlbums := TStringList.Create;
  DownloadedArtists := TStringList.Create;
  DownloadedPlaylists := TStringList.Create;

  AddToLog('Creating Player');
  // Player
  Player := TAudioPlayer.Create;
  StatusChanged;

  // Build spectrums
  Spectrum_Player := TSpectrum.Create(Visualisation_Player.Width, Visualisation_Player.Height);
  Spectrum_Player.Height := Visualisation_Player.Height - 20;
  Spectrum_Player.Peak := TColors.Hotpink;
  Spectrum_Player.BackColor := Song_Player.Color;

  // Queue
  PlayQueue := TIntegerList.Create;

  // Drawing
  LastDrawBuffer := TBitMap.Create;

  // Page Navigation
  SetLength(PageHistory, 0);

  // Media controls
  MediaControls.OnButtonPressed.Add( MediaControlsButton );
  MediaControls.OnPlaybackPositionChangeRequested.Add( MediaControlsPos );
  MediaControls.OnPlaybackRateChangeRequested.Add( MediaControlsRate );
  MediaControls.OnShuffleEnabledChangeRequested.Add( MediaControlsShuffle );
  MediaControls.OnRepeatModeChangeRequested.Add( MediaControlsRepeat );

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
  Version_Label.Caption := 'Version ' + Version.ToString();

  AddToLog('Form.Create.CalculateGeneralStorage');
  // Storage
  CalculateGeneralStorage;

  // Prepare Var
  FAudioSpeed := 1;
  FAudioVolume := 1;

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
    if PrivacyEnabled then
      AddToLog(Format('Form.Create.TokenLoginInfo LoginDataLoaded, ID<PRIVATE>, TOKEN<PRIVATE>', [APPLICATION_ID, LOGIN_TOKEN]))
    else
      AddToLog(Format('Form.Create.TokenLoginInfo LoginDataLoaded, ID<%S>, TOKEN<%S>', [APPLICATION_ID, LOGIN_TOKEN]));
  except
  end;

  // Update Events
  OnUpdateType := BackendUpdate;

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
          Search_ButtonClick(Search_Button); // F
        76: Action_Previous.Execute; // L
        77: Button_ToggleMenuClick( Button_ToggleMenu ); // M
        78: Action_Next.Execute; // N
        79: Button_MiniPlayerClick( Button_MiniPlayer ); // O
        80: Action_Play.Execute; // P
        81: Button_Extend.OnClick(Button_Extend); // Q
        82: Button_RepeatClick( Button_Repeat ); // R
        83: Button_ShuffleClick( Button_Shuffle ); // S
        86: if ViewModeToggle.Visible then // V
          begin
            if ViewStyle = TViewStyle.List then
              SetView( TViewStyle.Cover )
            else
              SetView( TViewStyle.List );

            RedrawPaintBox;
          end;
      end;
    end;

  // Ctrl
  if ssCtrl in Shift then
    begin
      case Key of
        70: if SearchToggle.Visible then
          Search_ButtonClick(Search_Button); // F
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
  if Width < 1200 then
    SmallSize := 1;
  if Width < 1000 then
    SmallSize := 2;
  if Width < 800 then
    SmallSize := 3;
  if Width < 500 then
    SmallSize := 4;

  // Page resizing
  NewValue := HomeDraw.Width div (CoverWidth + CoverSpacing);
  if NewValue <> HomeFitItems then
    ReselectPage;

  // Buttons
  Button_Repeat.Visible := SmallSize < 2;
  Button_Shuffle.Visible := SmallSize < 2;
  MoreButtons.Visible := SmallSize < 3;
  Button_Rating.Visible := SmallSize < 1;

  // Panels
  UIForm.Panel1.Visible := SmallSize < 3;

  // Split View
  SplitView1.Locked := SmallSize > 2;
  if SplitView1.Locked and SplitView1.Opened then
    SplitView1.Opened := false;

  // Queue
  Queue_Label.Visible := SmallSize < 3;
  Button_SaveQueue.Visible := SmallSize < 3;

  // Login Screen
  Robo_Background.Visible := (SmallSize < 3) and LoginBox.Visible;
  Robo_Panel.Visible := Robo_Background.Visible;

  // Menu bar
  Button_ToggleMenu.Visible := SmallSize < 3;
  Mini_Cast.Visible := not Button_ToggleMenu.Visible;

  // Fix Positioning
  if SmallSize < 2 then
    begin
      Button_Repeat.Left := Button_Prev.Left - Button_Prev.Width;
      Button_Shuffle.Left := Button_Next.Left + Button_Shuffle.Width;
    end;

  // Buttons 2
  if SmallSize < 4 then
    begin
      MoreButtons.Left := Button_Shuffle.Left + Button_Shuffle.Width;

      Button_MiniPlayer.Left := 0;
      Button_Volume.Left := Button_MiniPlayer.BoundsRect.Right;
      Button_Performance.Left := Button_Volume.BoundsRect.Right;
    end;

  // Extreme Tiny
  if SmallSize = 4 then
    begin
      SortModeToggle.Hide;
    end;

  // Fix All
  Button_Extend.Left := Panel7.Width;
end;

function TUIForm.GetItemCount(OnlyVisible: boolean): cardinal;
var
  I: Integer;
begin
  if OnlyVisible then
    begin
      Result := 0;
      for I := 0 to High(DrawItems) do
        if not DrawItems[I].Hidden then
          Inc(Result);
    end
      else
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

function TUIForm.GetPathValue(Name: string): string;
var
  I, P: integer;
  V: ^string;
begin
  ///  This function searchs for a parameter in the path. Such as "position=10"
  ///  The result being "10" and the Value being "position"
  Result := '';
  for I := 0 to High(LocationPath) do
    begin
      V := @LocationPath[I];

      P := V^.IndexOf('=');
      if P <> 0 then
        if Copy(V^, 1, P) = Name then
          Exit(Copy(V^, P+2, Length(V^) ));
    end;
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

function TUIForm.GetTracksID: TArray<string>;
var
  Index: integer;
begin
  if BareRoot = 'viewalbum' then
    begin
      Index := GetAlbum(LocationExtra);
      if Index <> -1 then
        Result := Albums[Index].TracksID
      else
        Result := [];
    end;

  if BareRoot = 'viewartist' then
    begin
      Index := GetArtist(LocationExtra);
      if Index <> -1 then
        Result := Artists[Index].TracksID
      else
        Result := [];
    end;

  if BareRoot = 'viewplaylist' then
    begin
      Index := GetPlaylist(LocationExtra);
      if Index <> -1 then
        Result := Playlists[Index].TracksID
      else
        Result := [];
    end;

  if BareRoot = 'history' then
    begin
      Index := GetPlaylistOfType('recently-played');
      if Index <> -1 then
        Result := Playlists[Index].TracksID
      else
        Result := [];
    end;
end;

procedure TUIForm.GetVersionUpdateData;
begin
  // Fetch update
  VersionChecker.Load;
  if not VersionChecker.Loaded then begin
    Latest_Version.Caption := 'Latest version on server: Server Error';
    Exit;
  end;

  // UI
  Latest_Version.Caption := 'Latest version on server: ' + VersionChecker.ServerVersion.ToString;

  // Download UI
  if VersionChecker.ServerVersion.NewerThan(VERSION) then begin
    NewVersion := TNewVersion.Create(Self);
    with NewVersion do
      try
        Version_Old.Caption := VERSION.ToString();
        Version_New.Caption := VersionChecker.ServerVersion.ToString();

        if ShowModal <> mrOk then
          Exit;

        // Start download
        BeginUpdate( VersionChecker.UpdateUrl );
      finally
        Free;
      end;
  end;
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
  FitX, ExtraSpacing: integer;
  AWidth: integer;
begin
  ViewStyle := TViewStyle.Cover;

  // No drawing
  if PauseDrawing then
    begin
      TPaintBox(Sender).Canvas.Draw(0, 0, LastDrawBuffer);
      Exit;
    end;

  // Common
  AWidth := TPaintBox(Sender).Width;

  // Draw
  with HomeDraw.Canvas do
    begin
      // Prepare
      Y := -ScrollPosition.Position;
      X := 0;

      FitX := (AWidth div (CoverWidth + CoverSpacing));
      if FitX = 0 then
        Exit;
      ExtraSpacing := round((AWidth - FitX * (CoverWidth + CoverSpacing)) / FitX);

      // Albums
      for A := 1 to HOME_COLUMNS do
        begin
          case A of
            1: S := 'Recently played albums';
            2: S := 'Favorite Tracks';
            3: S := 'Recently played tracks';
            4: S := 'From your playlists';
            5: S := 'Recently added tracks';
          end;

          // Data
          Start := (A-1) * HomeFitItems;

          if Start+3 <= High(DrawItems) then
            if DrawItems[Start].Invalid and DrawItems[Start+1].Invalid
              and DrawItems[Start+2].Invalid and DrawItems[Start+3].Invalid then
                Continue;

          // Font
          Font.Assign( Self.Font );
          Font.Size := 16;
          TextOut(X, Y, S);

          // Draw Text
          Inc(Y, TextHeight(S) + CoverSpacing);

          // Items
          for I := Start to Start + HomeFitItems - 1 do
            begin
              if Start > High(DrawItems) then
                Break;

              ARect := Rect(X, Y, X + CoverWidth, Y + CoverHeight);

              // Hidden
              if DrawItems[I].Hidden then
                begin
                  DrawItems[I].Bounds := Rect(0, 0, 0, 0);
                  Continue;
                end;

              // Bounds
              DrawItems[I].Bounds := ARect;
              if (I = IndexHoverSort) and (Press10Stat <> 0) and not HoverActiveZone then
                    ARect.Inflate(-Press10Stat, -trunc(ARect.Width / ARect.Height * Press10Stat));

              // Draw
              if (Y + CoverHeight > 0) and (Y < HomeDraw.Height) then
                DrawItemCanvas(HomeDraw.Canvas, ARect, DrawItems[I].Title,
                  DrawItems[I].InfoShort, DrawItems[I].GetPicture,
                  DrawItems[I].HasSecondary, DrawItems[I].Active, I = IndexHoverSort, DrawItems[I].IsDownloaded);

              // Mext
              Inc(X, CoverWidth + CoverSpacing + ExtraSpacing);
            end;

          Inc(Y, CoverHeight + CoverSpacing);
          X := 0;
        end;

      // Max Scroll
      MaxScroll := Y + ScrollPosition.Position;
      ScrollPosition.PageSize := 0;
      ScrollPosition.Max := MaxScroll - HomeDraw.Height;
    end;

  // Copy draw buffer
  with TPaintBox(Sender).Canvas do
    begin
      LastDrawBuffer.Width := ClipRect.Width;
      LastDrawBuffer.Height := ClipRect.Height;

      LastDrawBuffer.Canvas.CopyRect(ClipRect, TPaintBox(Sender).Canvas, ClipRect);
    end;
end;

procedure TUIForm.PopupGeneralInfo(Sender: TObject);
begin
  // Click
  PopupDrawItem.OpenInformation;
end;

procedure TUIForm.PopupGeneralRestore(Sender: TObject);
begin
  if (EditorThread < THREAD_EDITOR_MAX) then
  with TThread.CreateAnonymousThread(procedure
      begin
        // Increase
        Inc(EditorThread);

        // Status
        ThreadSyncStatus('Restoring Item...');

        // Delete
        try
          PopupDrawItem.RestoreFromLibrary;

          // Update by BackendUpdate
        except
          // Offline
          TThread.Synchronize(nil,
            procedure
              begin
                OfflineDialog('We can'#39't restore this item. Are you connected to the internet?');
              end);
        end;

        // Decrease
        Dec(EditorThread);

        // Finish
        EdidThreadFinalised
      end) do
        begin
          Priority := tpHigher;

          FreeOnTerminate := true;
          Start;
        end;
end;

procedure TUIForm.PopupGeneralViewArtist(Sender: TObject);
var
  ArtistID: string;
  Item: TDrawableItem;
begin
  // View Artist
  case PopupSource of
    TDataSource.Tracks: ArtistID := Tracks[PopupDrawItem.Index].ArtistID;
    TDataSource.Albums: ArtistID := Albums[PopupDrawItem.Index].ArtistID;
    else Exit;
  end;

  // Validate
  if ArtistID = '' then
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
  with TThread.CreateAnonymousThread(procedure
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
          try
            ReLoadLibrary;
          except
            on E: Exception do begin
              LoaderStopAnimation;
              WORK_STATUS := 'An error occured. Check the logs for more information.';
              AddToLog('InitiateLogin.WORK_STATUS EXCEPTION:'+E.Message);
              Exit;
            end;
          end;

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
    end) do
      begin
        Priority := tpHigher;

        FreeOnTerminate := true;
        Start;
      end;
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
  CButton35.Hide;

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

procedure TUIForm.Queue_LabelClick(Sender: TObject);
begin
  // Scroll Position
  QueueScroll.Position := Max(
    QueuePos * (QListHeight + QListSpacing) - QueueDraw.Height div 2,
    0
    );
end;

procedure TUIForm.LoaderStopAnimation;
begin
  LoadingGif.Hide;
end;

procedure TUIForm.LoadItemInfo;
var
  I, A, P: integer;
  ID: string;
  ARoot: string;

  SelectItems, SomeArray: TArray<string>;
  Contained: boolean;
procedure AddItem(Index: integer; AType: TDataSource); 
var
  I: integer;
begin
  I := Length(DrawItems);
  SetLength(DrawItems, I+1);
  DrawItems[I].LoadSource(Index, AType);
end;
begin
  // No items
  DrawItems := [];

  // Get root
  ARoot := BareRoot;

  // Load Data

  (* Songs *)
  if ARoot = 'songs' then
    for I := 0 to High(Tracks) do
      if not Tracks[I].IsInTrash then
        AddItem(I, TDataSource.Tracks);

  (* Albums *)
  if ARoot = 'albums' then
    for I := 0 to High(Albums) do
      if not Albums[I].IsInTrash then
        AddItem(I, TDataSource.Albums);

  (* Artists *)
  if ARoot = 'artists' then
    for I := 0 to High(Artists) do
      if not Artists[I].IsInTrash then
        AddItem(I, TDataSource.Artists);
    

  (* Playlists *)
  if ARoot = 'playlists' then
    for I := 0 to High(Playlists) do
      AddItem(I, TDataSource.Playlists);

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
          (* Also show trashed tracks! *)
        
          // Tracks
          SetLength(SelectItems, DownloadedTracks.Count);
          for I := 0 to DownloadedTracks.Count- 1 do
            SelectItems[I] := DownloadedTracks[I];

          AddItems(SelectItems, TDataSource.Tracks);

          // Albums
          SetLength(SelectItems, DownloadedAlbums.Count);
          for I := 0 to DownloadedAlbums.Count- 1 do
            SelectItems[I] := DownloadedAlbums[I];

          AddItems(SelectItems, TDataSource.Albums);

          // Artists
          SetLength(SelectItems, DownloadedArtists.Count);
          for I := 0 to DownloadedArtists.Count- 1 do
            SelectItems[I] := DownloadedArtists[I];

          AddItems(SelectItems, TDataSource.Artists);

          // Playlists
          SetLength(SelectItems, DownloadedPlaylists.Count);
          for I := 0 to DownloadedPlaylists.Count- 1 do
            SelectItems[I] := DownloadedPlaylists[I];

          AddItems(SelectItems, TDataSource.Playlists);

          for I := 0 to High(DrawItems) do
            DrawItems[I].HiddenItem := DrawItems[I].Source <> DownloadsFilter;
        end;
    end;

  (* Trashed *)
  if ARoot = 'trash' then
    begin
      case TrashFilter of
        TDataSource.Tracks: begin
          for I := 0 to High(Tracks) do
            if Tracks[I].IsInTrash then
              AddItem(I, TDataSource.Tracks);
        end;
        TDataSource.Albums: begin
          for I := 0 to High(Albums) do
            if Albums[I].IsInTrash then
              AddItem(I, TDataSource.Albums);
        end;
        TDataSource.Artists: begin
          for I := 0 to High(Artists) do
            if Artists[I].IsInTrash then
              AddItem(I, TDataSource.Artists);
        end;
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
        begin
          DrawItems[I].HiddenSearch := true;
        end;

      // Load previous query
      if SearchBox1.Text <> '' then
        SearchBox1.OnInvokeSearch(SearchBox1);
    end;

  (* Home Items *)
  if ARoot = 'home' then
    begin
      // Settings
      HomeFitItems := HomeDraw.Width div (CoverWidth + CoverSpacing);

      // Items
      (* Get albums!!! *)
      A := GetPlaylistOfType('recently-played');
      AddToLog('LoadItemInfo.Home.recently-played A=' + A.ToString);

      if A <> -1 then
        SomeArray := Playlists[A].TracksID
      else
        SomeArray := [];

      SetLength(SelectItems, 0);

      for I := 0 to High(SomeArray) do
        begin
          Contained := false;

          ID := '';
          P := GetTrack(SomeArray[I]);
          if P > -1 then
            ID := Tracks[P].AlbumID;
          if ID = '' then
            Continue;

          // Validate if it exists
          for A := 0 to High(SelectItems) do
            if SelectItems[A] = ID then
              Contained := true;

          // Add item
          if not Contained then
            begin
              P := Length(SelectItems);
              SetLength(SelectItems, P + 1);
              SelectItems[P] := ID;
            end;

          // Exit
          if Length(SelectItems) >= HomeFitItems then
            Break;
        end;

      (* Total Colums *)
      SetLength( DrawItems, HomeFitItems * HOME_COLUMNS );

      AddToLog('LoadItemInfo.Home.RecentAlbums');
      (* Recent Albums *)
      P := 0;
      for I := 0 to HomeFitItems - 1 do
        begin
          if P < Length(SelectItems) then
            DrawItems[I].LoadSourceID(SelectItems[P], TDataSource.Albums)
          else
            DrawItems[I].HiddenItem := true;

          Inc(P);
        end;

      AddToLog('LoadItemInfo.Home.FavoriteTracks');
      (* Favorite Tracks *)
      P := 0;
      for I := HomeFitItems to HomeFitItems * 2 - 1 do
        begin
          // Get thumbsup playlist
          A := GetPlaylistOfType('thumbsup');
          if A = -1 then
            Continue;

          // Get Playlist
          SelectItems := Playlists[A].TracksID;

          // Load from source
          if P < Length(SelectItems) then
            DrawItems[I].LoadSourceID(SelectItems[P], TDataSource.Tracks)
          else
            DrawItems[I].HiddenItem := true;

          Inc(P);
        end;

      AddToLog('LoadItemInfo.Home.History');
      (* History *)
      P := 0;
      for I := HomeFitItems * 2 to HomeFitItems * 3 - 1 do
        begin
          A := GetPlaylistOfType('recently-played');
          if A = -1 then
            Continue;

          SelectItems := Playlists[A].TracksID;

          if P < Length(SelectItems) then
            DrawItems[I].LoadSourceID(SelectItems[P], TDataSource.Tracks)
          else
            DrawItems[I].HiddenItem := true;

          Inc(P);
        end;

      AddToLog('LoadItemInfo.Home.Playlists');
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

      AddToLog('LoadItemInfo.Home.RecentlyAdded');
      (* Recently added *)
      P := 0;
      for I := HomeFitItems * 4 to HomeFitItems * 5 - 1 do
        begin
          A := GetPlaylistOfType('recently-uploaded');
          if A = -1 then
            Continue;

          SelectItems := Playlists[A].TracksID;

          if P < Length(SelectItems) then
            DrawItems[I].LoadSourceID(SelectItems[P], TDataSource.Tracks)
          else
            DrawItems[I].HiddenItem := true;

          Inc(P);
        end;
    end;

  (* Sub View Items *)
  if InArray(ARoot, SubViewCompatibile) <> -1 then
    begin
      if (ARoot = 'viewartist') and (GetPathValue('viewmode') = 'albums') then
        begin
          for I := 0 to High(Albums) do
            if Albums[I].ArtistID = LocationExtra then
              AddItem(I, TDataSource.Albums);
        end
      else
        AddItems(GetTracksID, TDataSource.Tracks, true, true);
    end;

  AddToLog('LoadItemInfo.AfterLoadSetup');
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

  I: integer;
  ValueID: string;
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
                ArtistID := ST[8];
                AlbumID := ST[9];
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
            ID := ChangeFileExt(ExtractFileName(Files[I]), '');
          
            AlbumName := ST[0];
            TracksID := StrToStrArray(ST[1]);
            ArtistID := ST[2];
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
            ID := ChangeFileExt(ExtractFileName(Files[I]), '');
          
            ArtistName := ST[0];
            TracksID := StrToStrArray(ST[1]);
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
            ID := ChangeFileExt(ExtractFileName(Files[I]), '');
          
            Name := ST[0];
            TracksID := StrToStrArray(ST[1]);
            PlaylistType := ST[2];
            Description := ST[3];
          end;
      finally
        ST.Free;
      end;
    end;
end;

procedure TUIForm.LoadPlayerSettings;
begin
  // Load settings
  Player.Speed := AudioSpeed;
  Player.Volume := AudioVolume;
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
  Root: string;
  Values: TArray<string>;
  Valid: integer;
  I: Integer;
  Data: TDrawableItem;
begin
  AddToLog(Format('Form.NavigatePath(%S, ' + booleantostring(AddHistory) + ')', [Path]));

  // Already there
  if Location = Path then
    Exit;

  // Meta
  AddToLog('NavigatePath.LocationValues');
  Values := Path.Split([':']);

  // Max param count
  SetLength(Values, 10);

  AddToLog('NavigatePath.Validate');
  // Validate
  Root := Values[0];
  Valid := -1;
  for I := 0 to High(PlayCaptions) do
    if AnsiLowerCase(Root) = AnsiLowerCase(PlayCaptions[I]) then
      begin
        Valid := I;
        Break;
      end;

  if Valid = -1 then
    Exit;

  AddToLog('NavigatePath.Page_Title.Caption. Valid=' + Valid.ToString);
  // Name
  Page_Title.Caption := PlayCaptions[Valid];

  // Set Location
  Location := Path;
  LocationROOT := Values[0];
  BareRoot := AnsiLowerCase(Values[0]);
  LocationExtra := Values[1];
  LocationPath := Values;

  AddToLog('NavigatePath.LoadSubViewData');
  // Load Sub-View Data
  if LocationExtra <> '' then
    begin
      // Album
      if BareRoot = 'viewalbum' then
        begin
          SubView_Type.Caption := 'Album View';
          I := BroadcastAPI.GetAlbum(LocationExtra);

          if I <> -1 then
            Data.LoadSource(I, TDataSource.Albums);

          Download_SubView.Tag := (DownloadedAlbums.IndexOf( Data.ItemID ) <> -1).ToInteger;
        end;

      // Artist
      if BareRoot = 'viewartist' then
        begin
          SubView_Type.Caption := 'Artist View';
          I := BroadcastAPI.GetArtist(LocationExtra);

          if I <> -1 then
            Data.LoadSource(I, TDataSource.Artists);

          Download_SubView.Tag := (DownloadedArtists.IndexOf( Data.ItemID ) <> -1).ToInteger;
        end;

      if BareRoot = 'viewplaylist' then
        begin
          SubView_Type.Caption := 'Playlist View';
          I := BroadcastAPI.GetPlaylist(LocationExtra);

          if I <> -1 then
            Data.LoadSource(I, TDataSource.Playlists);

          Download_SubView.Tag := (DownloadedPlaylists.IndexOf( Data.ItemID ) <> -1).ToInteger;
        end;

      // Load
      with Data do
        if Loaded then
          begin
            Label5.Caption := GetPremadeInfoList;
            SubView_Cover.Picture.Assign( GetPicture );

            // Download BT
            Download_SubView.Enabled := not IsOffline;
            Download_SubView.OnEnter(Download_SubView);

            // Title
            Page_Title.Caption := Data.Title;
          end;
    end;

  AddToLog('NavigatePath.History');
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

  AddToLog('NavigatePath.CheckPages');
  CheckPages;

  AddToLog('NavigatePath.SetScroll');
  // Scroll (after history!)
  SetScroll(0);

  AddToLog('NavigatePath.ReselectPage');
  // View Compatability
  ReselectPage;
end;

function TUIForm.ObtainIDFromFileName(FileName: string): string;
begin
  FileName := ExtractFileName(FileName);
  FileName := ChangeFileExt(FileName, '');  

  Result := FileName;
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

procedure AddToLog(ALog: string);
var
  F: TextFile;
  AFile,
  ADate: string;
begin
  // Use legacy writing for TextFile.Append
  if EnableLogging or EnableLog32 then
    begin
      // File logging
      if EnableLogging then
        begin
          ADate := DateTimeToStr(Now);
          AFile := ReplaceWinPath('shell:desktop\iBroadcast Log.txt');

          ALog := ADate + ': ' + ALog;

          AssignFile(F, AFile);
          if TFile.Exists(AFile) then
            Append(F)
          else
            ReWrite(F);

          WriteLn(F, ALog);

          // Close
          CloseFile(F);
        end;

      // UI logging
      if EnableLog32 then
        if (Logging <> nil) and Logging.Visible then
          Logging.Log.Lines.Add(ALog);
    end;
end;

procedure WorkStatusChange(Status: string);
begin
  AddToLog('Work Status Changed: ' + Status);
end;

procedure WorkDataStatusChange(Status: string);
begin
  AddToLog('Work Data Status Changed: ' + Status);
end;

procedure TUIForm.QueueDownGoTimer(Sender: TObject);
begin
  QueueScroll.Position := QueueScroll.Position + TTimer(Sender).Tag;
end;

procedure TUIForm.QueueDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then
    Exit;

  // Drag
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

          QueuePos1 := QueuePos2;
          //QueueSwitchAnimation.Enabled := true;
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
  if Button = mbRight then
    begin
      if QueueHover <> -1 then
        begin
          const ID = Tracks[PlayQueue[QueueHover]].ID;

          PopupDrawItem.LoadSourceID(ID, TDataSource.Tracks);

          PopupDrawIndex := -1;
          PopupSource := TDataSource.Tracks;

          SetDownloadIcon( PopupDrawItem.Downloaded, PopupSource );

          // Default
          Popup_Track.Tag := 1;
          Popup_Track.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
        end;
    end;

  if Button = mbLeft then
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
  Br: TGDIBrush;
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
          ColonAlloc := (AWidth - ColonLeft) div 2
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
                  if (I = QueueDragItem) then begin
                    Inc( Y, QListHeight+QListSpacing);

                    (* Skip *)
                    Continue;
                  end;
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
                  S := StringReplace(S, '&', '&&', [rfReplaceAll]);

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

                  Br := GetRGB(255, 0, 0).MakeGDIBrush;
                  try
                    GDICircle(BRect, Br, nil);
                  finally
                    Br.Free;
                  end;

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
          ARect.Inflate(-3, -3);

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

procedure TUIForm.QueueLoadWhenFinishedTimer(Sender: TObject);
begin
  if not PrimaryUIContainer.Visible then
    Exit;

  QueueLoadWhenFinished.Enabled := false;

  // Play
  try
    PlaySong(PlayQueue[QueuePos], false);
  except
    PlayQueue.Clear;
  end;
end;

procedure TUIForm.Playartists1Click(Sender: TObject);
var
  Songs, PickerItems: TArray<string>;
  Index, I: Integer;
  J: Integer;
begin
  PickItems(PickerItems, TPickType.Artist, true);

  for J := 0 to High(PickerItems) do
    begin
      Songs := Artists[GetArtist(PickerItems[J])].TracksID;

      for I := 0 to High(Songs) do
        begin
          Index := GetTrack(Songs[I]);
          AddQueue(Index);
        end;
    end;
end;

procedure TUIForm.PlayCloudSongLocally(Endpoint: string);
var
  Folder,
  LocalName: string;
  HTTP: TIdHTTP;
  FileStream: TFileStream;
begin
  // Close file if open
  Player.Stop;
  Player.CloseFile;

  // Thread
  CloudDownloadLocalThread := TThread.CreateAnonymousThread(procedure
  var
    I: Integer;
  begin
      // Timeout for last thread
      for I := 1 to 10 do
        begin
          if not LastThreadFileLocked then
            Break;
          Sleep(500);
        end;

      // Download started
      ServerCloudDownload := true;

      // Status
      ThreadSyncStatus('Downloading cloud song...');

      // Prepare
      Folder := AppData + TEMP_DIR;
      LocalName := Folder + 'currentsong.mp3';

      if not TDirectory.Exists(Folder) then
        TDirectory.CreateDirectory(Folder);

      // Download
      try
        // Download - IDHTTP
        HTTP := TIdHTTP.Create(nil);

        // Events
        HTTP.OnWorkBegin := Self.DownloadStatusWorkBegin;
        HTTP.OnWork := Self.DownloadStatusWork;
        LastThreadFileLocked := true;

        // File
        FileStream := TFileStream.Create(LocalName, fmCreate);
        try
          HTTP.Get(Endpoint, FileStream);
        finally
          HTTP.Free;
          FileStream.Free;

          // Not locked
          LastThreadFileLocked := false;
        end;

        // Check not cancelled in the meantime
        if ServerCloudDownload then
          TThread.Synchronize(nil,
            procedure
              begin
                // Open
                Player.OpenFile( LocalName );

                // Play
                LoadPlayerSettings;
                if ServerCloudPlay then
                  Player.Play;

                // Status
                SongUpdate;
              end);
      except
        // Offline
        if ServerCloudDownload then
          TThread.Synchronize(nil,
            procedure
              begin
                OfflineDialog('The song could not be downloaded');
              end);
      end;

      if ServerCloudDownload then
        begin
          // Finish
          EdidThreadFinalised;

          // Mark Done
          TThread.Synchronize(nil,
            procedure
            begin
              ServerCloudDownload := false;
            end);
        end;
  end);

  with CloudDownloadLocalThread do
      begin
        // High priority
        Priority := tpHigher;

        FreeOnTerminate := true;
        Start;
      end;
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
      SeekUpdateStatus := Player.PlayStatus;
      Player.Position := SeekPoint;
      NeedSeekUpdate := true;
    end
      else
        IsSeeking := false;
end;

procedure TUIForm.Playplaylist1Click(Sender: TObject);
var
  Songs, PickerItems: TArray<string>;
  Index, I: Integer;
  J: Integer;
begin
  PickItems(PickerItems, TPickType.Playlist, true);

  for J := 0 to High(PickerItems) do
    begin
      Songs := Playlists[GetPlaylist(PickerItems[J])].TracksID;

      for I := 0 to High(Songs) do
        begin
          Index := GetTrack(Songs[I]);
          AddQueue(Index);
        end;
    end;
end;

procedure TUIForm.PopupDraw(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean);
var
  Text: string;
  TextR: TRect;
  Radius: integer;
  Menu: TMenuItem;
  AForeground,
  ABackground: TColor;
begin
  // Draw
  with ACanvas do
    begin
      // Get Data
      Menu := TMenuItem(Sender);

      // Hover
      if Selected then
        begin
          ABackground := clWhite;
          AForeground := clBlack;
          Radius := 0;

          // Advanced Colors
          if Menu.Hint = '' then
            begin
              ABackground := clRed;
              AForeground := clWhite;
            end;
        end
      else
        begin
          ABackground := BG_COLOR;
          AForeground := FN_COLOR;
          Radius := 0;
        end;

      // Diabled
      if not Menu.Enabled then
        begin
          ABackground := ColorToGrayScale(BG_COLOR);
          AForeground := clGray;
        end;

      // Fill
      Pen.Color := ABackground;
      Brush.Color := ABackground;
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
          Font.Color := AForeground;
          Font.Size := 16;
          Font.Name := GetSegoeIconFont;

          Text := Menu.Hint;
          TextRect( TextR, Text, [tfSingleLine, tfCenter, tfVerticalCenter]);

          TextR := ARect;
          TextR.Left := TextR.Left + TextR.Height + 5;
        end;

      // Text
      Font.Assign( Self.Font );
      Font.Color := AForeground;
      if Menu.Default then
        Font.Style := [fsBold];
      Text := Menu.Caption;
      DrawTextRect( ACanvas, TextR, Text, [TTextFlag.VerticalCenter, TTextFlag.ShowAccelChar], 5);
    end;
end;

procedure TUIForm.PopupGeneralAddTracks(Sender: TObject);
var
  ATracks: TArray<string>;
  AIndex: integer;
  NextPlay: boolean;
  I, index: integer;
begin
  // Empty
  NextPlay := (PlayQueue.Count = 0) and (Player.PlayStatus <> psPlaying);

  // Add Tracks
  AIndex := PopupDrawItem.Index;
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
      Index := GetTrack(ATracks[I]);
      if Index <> -1 then
        AddQueue( Index );
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
  PopupDrawItem.Execute;
end;

procedure TUIForm.PopupGeneralDelete(Sender: TObject);
begin
  if (EditorThread < THREAD_EDITOR_MAX) and
    (OpenDialog('Are you sure?', Format('Are you really sure you want to delete "%S"?', [PopupDrawItem.Title]), ctQuestion, [mbYes, mbNo]) = mrYes) then
    with TThread.CreateAnonymousThread(procedure
      begin
        // Increase
        Inc(EditorThread);

        // Status
        ThreadSyncStatus('Deleting Item...');

        // Delete
        try
          PopupDrawItem.TrashFromLibrary;

          // Update by BackendUpdate
        except
          // Offline
          TThread.Synchronize(nil,
            procedure
              begin
                OfflineDialog('We can'#39't delete this item. Are you connected to the internet?');
              end);
        end;

        // Decrease
        Dec(EditorThread);

        // Finish
        EdidThreadFinalised
      end) do
        begin
          Priority := tpHigher;

          FreeOnTerminate := true;
          Start;
        end;
end;

procedure TUIForm.PopupGeneralDownload(Sender: TObject);
begin
  // Download
  PopupDrawItem.ToggleDownloaded;

  // Update
  UIForm.UpdateDownloads;

  // Redraw
  RedrawPaintBox;
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

procedure TUIForm.Popup_AlbumPopup(Sender: TObject);
begin
  // Trash
  Restore2.Visible := PopupDrawItem.Trashed;
  Trash2.Visible := not Restore2.Visible;
end;

procedure TUIForm.Popup_ArtistPopup(Sender: TObject);
begin
  // Trash
  Restore3.Visible := PopupDrawItem.Trashed;
  Trash3.Visible := not Restore3.Visible;
end;

procedure TUIForm.Popup_PlaylistPopup(Sender: TObject);
begin
  // Disable delete for system playlists
  if PopupDrawItem.Index <> -1 then
    begin
      Delete1.Enabled := Playlists[PopupDrawItem.Index].PlaylistType = '';
      Addtracks2.Enabled := Delete1.Enabled;
    end;
end;

procedure TUIForm.Popup_TrackPopup(Sender: TObject);
begin
  // Check not started from play icon
  PlayQueue1.Visible := Popup_Track.Tag = 0;

  // Trash
  Restore1.Visible := PopupDrawItem.Trashed;
  Trash1.Visible := not Restore1.Visible;
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
  NetworkName,
  LocalName: string;
  Local: boolean;
  APlay: TPlayType;
begin
  // Play State
  PlayID := Tracks[Index].ID;
  PlayIndex := Index;
  PlayTimeStamp := Now;

  // Push History
  if StartPlay and not IsOffline then
    AddSongToHistory;

  // Network location
  NetworkName := Tracks[Index].GetStreamingURL;

  // Is offline?
  LocalName := AppData + DOWNLOAD_DIR + PlayID + '.mp3';
  Local := TFile.Exists( LocalName );

  // Calculate Type
  if Local then
    APlay := TPlayType.Local
  else
    if Setting_SongStreaming.Checked then
      APlay := TPlayType.Streaming
    else
      APlay := TPlayType.CloudDownload;

  // Stop cloud download thread
  if ServerCloudDownload then
    begin
      // This will stop the download in the OnWork event
      ServerCloudDownload := false;
    end;

  // Play
  case APlay of
    TPlayType.Streaming: Player.OpenURL( Tracks[Index].GetStreamingURL );
    TPlayType.Local: Player.OpenFile( LocalName );
    TPlayType.CloudDownload: begin

      // Auto-Play
      ServerCloudPlay := StartPlay;

      // Play
      PlayCloudSongLocally( NetworkName );
    end;
  end;

  // Offline
  if not Player.IsFileOpen and not (APlay = TPlayType.CloudDownload) then
    begin
      Player.Pause;
      IsOffline := true;

      OfflineDialog('There seems to be a problem loading this song.');
      Exit;
    end
      else
      // Back online
      if not Local then
        IsOffline := false;

  // Data
  if StartPlay then
    begin
      LoadPlayerSettings;
      Player.Play;
      Player.PlayStatus;
    end;

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

  FileName := IncludeTrailingPathDelimiter(GetUserShellLocation(TUserShellLocation.Startup)) + 'Cods iBroadcast.lnk';
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
              // Validate
              ATrack := GetTrack(ST[I]);
              if ATrack = -1 then
                Continue;

              // Add
              AddQueue(ATrack, false);
            end;

        // Set Position
        if APosition <> -1 then
          begin
            QueuePos := APosition;

            // Fake play
            QueueLoadWhenFinished.Enabled := true;
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
          ST.Add(Tracks[PlayQueue[I]].ID);

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
  ScrollPosition.Position := 0;

  RedrawPaintBox;
end;

procedure TUIForm.Quick_SearchExit(Sender: TObject);
begin
  SearchBox_Hold.Hide;
  Search_Button.Show;
end;

procedure TUIForm.Quick_SearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
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
  CAT_VIEWS = 'Views';
  CAT_INFO = 'Information';
var
  OPT: TIniFile;
  FileName: string;
  I: Integer;
begin
  FileName := AppData + 'settings.ini';

  OPT := TIniFIle.Create(FileName);
  with OPT do
    if Load then
    // Load Data
      try
        // Views
        for I := 0 to High(ViewCompatibile) do
          if OPT.ValueExists('Views', ViewCompatibile[I]) then
            AddView(ViewCompatibile[I], TViewStyle(OPT.ReadInteger(CAT_VIEWS, ViewCompatibile[I], 0)) );

        // General
        Setting_Graph.Checked := ReadBool(CAT_GENERAL, 'Enable Graph', Setting_Graph.Checked);
        SplitView1.Opened := ReadBool(CAT_GENERAL, 'Menu Opened', SplitView1.Opened);
        Settings_CheckUpdate.Checked := ReadBool(CAT_GENERAL, 'Audo Update Check', Settings_CheckUpdate.Checked);
        ArtworkID := ReadInteger(CAT_GENERAL, 'Artwork Id', ArtworkID);
        ArtworkStore := ReadBool(CAT_GENERAL, 'Artowork Store', ArtworkStore);
        Setting_ArtworkStore.Checked := ArtworkStore;
        THREAD_MAX := ReadInteger(CAT_GENERAL, 'Thread Count', THREAD_MAX);
        Settings_Threads.Position := THREAD_MAX;
        Setting_DataSaver.Checked := ReadBool(CAT_GENERAL, 'Data Saver', Setting_DataSaver.Checked);
        Setting_PlayerOnTop.Checked := ReadBool(CAT_GENERAL, 'Mini player on top', Setting_PlayerOnTop.Checked);
        Setting_SongStreaming.Checked := ReadBool(CAT_GENERAL, 'Song Streaming', Setting_SongStreaming.Checked);
        Settings_DisableAnimations.Checked := ReadBool(CAT_GENERAL, 'Disable Animations', Settings_DisableAnimations.Checked);
        Setting_StartWindows.Checked := ReadBool(CAT_GENERAL, 'Start with windows', Setting_StartWindows.Checked);
        Setting_TrayClose.Checked := ReadBool(CAT_GENERAL, 'Minimise to tray', Setting_TrayClose.Checked);
        Setting_QueueSaver.Checked := ReadBool(CAT_GENERAL, 'Save Queue', Setting_QueueSaver.Checked);
        Setting_Rating.Checked := ReadBool(CAT_GENERAL, 'Prefer rating', Setting_Rating.Checked);
        ValueRatingMode := Setting_Rating.Checked;
        SetEnableVisualisations( ReadBool(CAT_GENERAL, 'Visualisations', EnableVisualisations), true);

        // Mini player
        TransparentIndex := ReadInteger(CAT_MINIPLAYER, 'Opacity', 0);

        // Info
        LastUpdateCheck := ReadDate(CAT_INFO, 'Last update check', LastUpdateCheck);
        if LastUpdateCheck > Now then
            LastUpdateCheck := Now;
      finally
        OPT.Free;
      end
    else
      try
        // Views
        for I := 0 to High(SavedViews) do
          OPT.WriteInteger(CAT_VIEWS, SavedViews[I].PageRoot, integer(SavedViews[I].View));

        // General
        WriteBool(CAT_GENERAL, 'Enable Graph', Setting_Graph.Checked);
        WriteBool(CAT_GENERAL, 'Menu Opened', SplitView1.Opened);
        WriteBool(CAT_GENERAL, 'Audo Update Check', Settings_CheckUpdate.Checked);
        WriteInteger(CAT_GENERAL, 'Artwork Id', ArtworkID);
        WriteBool(CAT_GENERAL, 'Artowork Store', ArtworkStore);
        WriteInteger(CAT_GENERAL, 'Thread Count', THREAD_MAX);
        WriteBool(CAT_GENERAL, 'Data Saver', Setting_DataSaver.Checked);
        WriteBool(CAT_GENERAL, 'Mini player on top', Setting_PlayerOnTop.Checked);
        WriteBool(CAT_GENERAL, 'Song Streaming', Setting_SongStreaming.Checked);
        WriteBool(CAT_GENERAL, 'Disable Animations', Settings_DisableAnimations.Checked);
        WriteBool(CAT_GENERAL, 'Start with windows', Setting_StartWindows.Checked);
        WriteBool(CAT_GENERAL, 'Minimise to tray', Setting_TrayClose.Checked);
        WriteBool(CAT_GENERAL, 'Save Queue', Setting_QueueSaver.Checked);
        WriteBool(CAT_GENERAL, 'Prefer rating', Setting_Rating.Checked);
        WriteBool(CAT_GENERAL, 'Visualisations', EnableVisualisations);

        // Mini player
        WriteInteger(CAT_MINIPLAYER, 'Opacity', TransparentIndex);

        // Info
        WriteDate(CAT_INFO, 'Last update check', LastUpdateCheck);
      finally
        OPT.Free;
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
  if DestQueuePopup > QUEUE_MIN_SIZE then
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
  ItemCount := (GetItemCount(true));

  // Calculations based on view mode
  if ViewStyle = TViewStyle.Cover then
    begin
      FitX := (ActiveDraw.Width div (CoverWidth + CoverSpacing));
      FitY := (ActiveDraw.Height div (CoverHeight + CoverSpacing));

      PageSize := FitY * (CoverHeight + CoverSpacing);
      SmallChange := PageSize div 8;

      MaxScroll := trunc( (CoverHeight + CoverSpacing) * (ItemCount / FitX) );
      if (MaxScroll > CoverHeight) and (FitY > 0) then
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
  ID: string;
  I: Integer;
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

      FileName := Folder + ID + '.mp3';

      if not TFile.Exists( FileName ) then
        DownloadQueue.Add(ID);
    end;

  // Download Each
  DownloadThread := TThread.CreateAnonymousThread(procedure
    label ThreadStop;
    var
      I: integer;
      Server, Local, Repo: string;
      ID: string;
      TrackIndex, Index, Total, ThreadID: integer;
      ST: TStringList;
    begin
      ThreadID := DownloadThreadsE + 1;

      // Write Album, Artist Playlist metadata
      Repo := Folder + 'albums\';
      TDirectory.CreateDirectory(Repo);
      for I := 0 to DownloadedAlbums.Count - 1 do
        begin
          // Status
          ThreadSyncStatus( 'Writing album metadata (' + (I+1).ToString + '/'
              + DownloadedAlbums.Count.ToString + ')');

          // Get File
          Local := Repo + DownloadedAlbums[I] + '.txt';

          // Write
          Index := GetAlbum(DownloadedAlbums[I]);
          if Index = -1 then
            Continue;
          ST := TStringList.Create;
          try
            with Albums[Index] do
              begin
                ST.Add( AlbumName );
                ST.Add( StrArrayToStr(TracksID) );
                ST.Add( ArtistID );
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
          ThreadSyncStatus( 'Writing artist metadata (' + (I+1).ToString + '/'
              + DownloadedArtists.Count.ToString + ')');

          // Get File
          Local := Repo + DownloadedArtists[I] + '.txt';
            
          // Write
          Index := GetArtist(DownloadedArtists[I]);
          if Index = -1 then
            Continue;
          ST := TStringList.Create;
          try
            with Artists[Index] do
              begin
                ST.Add( ArtistName );
                ST.Add( StrArrayToStr(TracksID) );
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
          ThreadSyncStatus( 'Writing playlist metadata (' + (I+1).ToString + '/'
              + DownloadedPlaylists.Count.ToString + ')');

          // Get Playlist File
          Local := Repo + DownloadedPlaylists[I] + '.txt';

          // Write
          Index := GetPlaylist(DownloadedPlaylists[I]);
          if Index = -1 then
            Continue;
          ST := TStringList.Create;
          try
            with Playlists[Index] do
              begin
                ST.Add( Name );
                ST.Add( StrArrayToStr(TracksID) );
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
          ThreadSyncStatus( 'Downloading songs... (' + (Total-I+1).ToString + '/'
              + (Total+1).ToString + ')');

          // Get Data
          ID := DownloadQueue[I];
          TrackIndex := GetTrack(ID);

          if TrackIndex = -1 then
            Continue;
          try
            Local := Folder + ID;
            Server := Tracks[TrackIndex].GetStreamingURL;
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
            ST.Add(Tracks[TrackIndex].ArtistID);
            ST.Add(Tracks[TrackIndex].AlbumID);

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
        // Finish
        EdidThreadFinalised;

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
        ActiveDraw := DrawItem_Clone1;

      if BareRoot = 'viewplaylist' then
        ActiveDraw := DrawItem_Clone1;

      if BareRoot = 'home' then
        ActiveDraw := HomeDraw;

      if BareRoot = 'search' then
        ActiveDraw := SearchDraw;
    end;

  if ActiveDraw <> nil then
    ActiveDraw.Repaint;
end;

procedure TUIForm.ReloadArtwork;
const
  ARTRES_NAME = 'Artwork';
var
  AName: string;
  LoadID: integer;
  ResStream: TResourceStream;
procedure LoadDefaultArtwork;
begin
  DefaultPicture := GetSongArtwork('0', TArtSize.Small);
end;
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

      try
        ResStream := TResourceStream.Create(0, AName, RT_RCDATA);

        try
          DefaultPicture := TJpegImage.Create;
          DefaultPicture.LoadFromStream(ResStream);
        finally
          ResStream.Free;
        end;
      except
        LoadDefaultArtwork;

        AddToLog('Error loading custom artwork from memory stream.');
      end;
    end;
      // Default Artwork
      else
        LoadDefaultArtwork;
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
  AddToLog('Form.ReloadLibrary Status:' + WORK_STATUS);
  LoadStatus;

  // Get Library
  WORK_STATUS := 'Loading your library...';
  AddToLog('Form.ReloadLibrary Status:' + WORK_STATUS);
  LoadLibrary;

  // Update Downloads
  WORK_STATUS := 'Updating Downloads...';
  AddToLog('Form.ReloadLibrary Status:' + WORK_STATUS);
  UpdateDownloads;

  // Get last queue
  WORK_STATUS := 'Updating Queue...';
  AddToLog('Form.ReloadLibrary Status:' + WORK_STATUS);
  if Setting_QueueSaver.Checked and (PlayQueue.Count = 0) then
    QueueSettings(true);

  // Default Artwork
  WORK_STATUS := 'Loading Artwork...';
  AddToLog('Form.ReloadLibrary Status:' + WORK_STATUS);
  ReloadArtwork;

  // UI
  WORK_STATUS := 'Preparing User Interface...';
  AddToLog('Form.ReloadLibrary Status:' + WORK_STATUS);
  Welcome_Label.Caption := Format(WELCOME_STRING, [Account.Username]);
  Complete_Email.Caption := Format(CAPTION_EMAIL, [MaskEmailAdress(Account.EmailAdress)]);
  Complete_Email.Hint := Format(CAPTION_EMAIL, [Account.EmailAdress]);

  Complete_User.Caption := Format(CAPTION_USER, [datetostr(Account.CreationDate)]);

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

  // No longer offline
  if IsOffline then
    IsOffline := false;
end;

procedure TUIForm.RenderVisualisations;
var
  FFTFata: TFFTData;
begin
  if (Player = nil) or (not Player.IsFileOpen) or (Player.PlayStatus <> TPlayStatus.psPlaying) then
    Exit;

  BASS_ChannelGetData(Player.Stream, @FFTFata, BASS_DATA_FFT1024);

  if Visible then
    Spectrum_Player.Draw(Visualisation_Player.Canvas.Handle, FFTFata, 0, -10);

  if MiniPlayer.Visible then
    Spectrum_Mini.Draw(MiniPlayer.Visualisation_Mini.Canvas.Handle, FFTFata, 0, -10);
end;

procedure TUIForm.ReselectPage;
var
  ViewC, // Main View compatibile
  ViewSC, // Sub-View compatibile
  MultiPage: boolean; // Multiple item types
  I: Integer;
  MainPanel: TPanel;
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

      // Reset toolbars
      Controlbar_Playlist.Parent := ControlBarContainer;
      Controlbar_Downloads.Parent := ControlBarContainer;
      Controlbar_Trash.Parent := ControlBarContainer;

      // Toolbars
      if bareroot = 'playlists' then
        Controlbar_Playlist.Parent := GeneralDraw;

      if bareroot = 'downloads' then
        Controlbar_Downloads.Parent := GeneralDraw;

      if bareroot = 'trash' then
        Controlbar_Trash.Parent := GeneralDraw;
    end
  else
    begin
      MainPanel := nil;

      // Find
      for I := 0 to PagesHolder.ControlCount - 1 do
        if PagesHolder.Controls[I] is TPanel then
          with TPanel(PagesHolder.Controls[I]) do
            if Pos(AnsiLowerCase(LocationROOT),AnsiLowerCase(Caption)) <> 0 then
              begin
                MainPanel := TPanel(PagesHolder.Controls[I]);
                Break;
              end;

      if MainPanel <> nil then
        begin
          // Show
          MainPanel.Show;

          // Reset toolbars
          Controlbar_ArtistManage.Parent := ControlBarContainer;

          // Toolbars
          if bareroot = 'viewartist' then
            Controlbar_ArtistManage.Parent := MainPanel;
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

  AddToLog('ReselectPage.LoadItemInfo');
  // Load Information
  LoadItemInfo;

  AddToLog('ReselectPage.Sort');
  // Sort Reset
  Sort;

  AddToLog('ReselectPage.UIPageTweak');
  // UI Tweaks
  TweakPageUI;

  AddToLog('ReselectPage.Quick_Search.Text.Set');
  // Search Reset
  Quick_Search.Text := '';
end;

procedure TUIForm.RestoreMainWindow;
begin
  // Close mini player
  if MiniPlayer.Visible then
    MiniPlayer.RestoreMainForm;

  // Restore from tray
  if HiddenToTray then
    OpenFromTray;

  // Bring to top
  BringToTopAndFocusWindow(Handle);
end;

procedure TUIForm.SaveAs1Click(Sender: TObject);
var
  Index: integer;
  LocalName,
  URL: string;
  HTTP: TIdHTTP;
  FileStream: TFileStream;
begin
  // URL
  Index := GetTrack(PopupDrawItem.ItemID);
  if Index = -1 then
    Exit;
  URL := Tracks[Index].GetStreamingURL;

  // Dialog
  SaveMusicDialog.FileName := PopupDrawItem.Title;

  if not SaveMusicDialog.Execute then
    Exit;

  // Save
  with TThread.CreateAnonymousThread(procedure
  var
    I: Integer;
  begin
      // Timeout for last thread
      for I := 1 to 10 do
        begin
          if not LastThreadFileLocked then
            Break;
          Sleep(500);
        end;

      // Status
      ThreadSyncStatus('Downloading song...');

      // Prepare
      LocalName := SaveMusicDialog.FileName;

      // Download
      try
        // Download - IDHTTP
        HTTP := TIdHTTP.Create(nil);

        // Events
        HTTP.OnWorkBegin := Self.DownloadStatusWorkBeginDownload;
        HTTP.OnWork := Self.DownloadStatusWorkDownload;
        LastThreadFileLocked := true;

        // File
        FileStream := TFileStream.Create(LocalName, fmCreate);
        try
          HTTP.Get(URL, FileStream);
        finally
          HTTP.Free;
          FileStream.Free;

          // Not locked
          LastThreadFileLocked := false;
        end;
      except
        on E: Exception do
        // Offline
        TThread.Synchronize(nil,
          procedure
            begin
              OfflineDialog('The song could not be downloaded. Error:'#13+E.Message);
            end);
      end;

      // Finish
      EdidThreadFinalised;
  end) do
    begin
      Priority := tpLower;

      FreeOnTerminate := true;
      Start;
    end;
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
  if LastScrollValue <> CScrollBar(Sender).Position then
    begin
      // Draw
      RedrawPaintBox;
      LastScrollValue := CScrollBar(Sender).Position;

      // Update others
      ScrollPosition.Position := CScrollBar(Sender).Position;

      Scrollbar_1.PageSize := ScrollPosition.PageSize;
      Scrollbar_4.PageSize := ScrollPosition.PageSize;
      Scrollbar_6.PageSize := ScrollPosition.PageSize;

      Scrollbar_1.Max := ScrollPosition.Max;
      Scrollbar_4.Max := ScrollPosition.Max;
      Scrollbar_6.Max := ScrollPosition.Max;

      Scrollbar_1.Position := CScrollBar(Sender).Position;
      Scrollbar_4.Position := CScrollBar(Sender).Position;
      ScrollBar_6.Position := CScrollBar(Sender).Position;
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
  if CCheckBox4.Checked then
    Flags := Flags + [TSearchFlag.SearchTrashed];
    
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

  // No drawing
  if PauseDrawing then
    begin
      TPaintBox(Sender).Canvas.Draw(0, 0, LastDrawBuffer);
      Exit;
    end;

  // Common
  AHeight := SearchDraw.Height;
  AWidth := SearchDraw.Width;

  // Draw
  with SearchDraw.Canvas do
    begin
      // Prepare
      Y := -ScrollPosition.Position;
      X := 0;

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
      for I := 0 to GetItemCount-1 do
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
          if (I = IndexHoverSort) and (Press10Stat <> 0) and not HoverActiveZone then
                ARect.Inflate(-Press10Stat, -trunc(ARect.Width / ARect.Height * Press10Stat));

          // Draw
          if (Y + CoverHeight > 0) and (Y < AHeight) then
            DrawItemCanvas(SearchDraw.Canvas, ARect, DrawItems[I].Title,
            DrawItems[I].InfoShort, DrawItems[I].GetPicture,
            DrawItems[I].HasSecondary, DrawItems[I].Active, I = IndexHoverSort, DrawItems[I].IsDownloaded);

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

  // Copy draw buffer
  with TPaintBox(Sender).Canvas do
    begin
      LastDrawBuffer.Width := ClipRect.Width;
      LastDrawBuffer.Height := ClipRect.Height;

      LastDrawBuffer.Canvas.CopyRect(ClipRect, TPaintBox(Sender).Canvas, ClipRect);
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

procedure TUIForm.SetAudioSpeed(const Value: single);
begin
  if FAudioSpeed <> Value then
    begin
      FAudioSpeed := Value;

      if Player.IsFileOpen then
        Player.Speed := Value;
    end;
end;

procedure TUIForm.SetAudioVolume(const Value: single);
begin
  if FAudioVolume <> Value then
    begin
      FAudioVolume := Value;

      if Player.IsFileOpen then
        Player.Volume := Value;
    end;
end;

procedure TUIForm.SetCurrentSongRating(AValue: integer);
begin
  // Offline
  if IsOffline then
    begin
      OfflineDialog('Cannot change rating in Offline Mode. Please connect to the internet.');
      Exit;
    end;

  with TThread.CreateAnonymousThread(procedure
    begin
      // Status
      ThreadSyncStatus('Changing rating...');

      const ID = PlayID;

      var Success: boolean;
      Success := false;
      try
        // Add new tracks
        Success := UpdateTrackRating(ID, AValue, false); // Change manaully
      except
        // Offline
        TThread.Synchronize(nil,
          procedure
            begin
              OfflineDialog('We can'#39't change the track rating. Are you connected to the internet?');
            end);
      end;

      // Set
      Tracks[PlayIndex].Rating := AValue;

      // Add to thumbsup playlist
      TrackRatingToLikedPlaylist(ID);

      // Change UI
      if Success then
        TThread.Synchronize(nil, procedure
          begin
            // Update
            UpdateRatingIcon;
          end);

      // Finish
      EdidThreadFinalised;
    end) do
      begin
        FreeOnTerminate := true;
        Start;
      end;
end;

procedure TUIForm.SetDownloadIcon(Value: boolean; Source: TDataSource);
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

procedure TUIForm.SetEnableVisualisations(ATo, Force: boolean);
begin
  if not Force and (EnableVisualisations = ATo) then
    Exit;

  // UI
  Setting_Visualisations.Checked := ATo;

  // State
  EnableVisualisations := ATo;

  // Check
  VisualisationUICheck;
end;

procedure TUIForm.SetPathValue(Name, Data: string);
label Navigate;
var
  I, P: integer;
  V: ^string;
  APath: string;
begin
  // Replace mode
  for I := 0 to High(LocationPath) do
    begin
      V := @LocationPath[I];

      P := V^.IndexOf('=');
      if P <> 0 then
        if Copy(V^, 1, P) = Name then
          begin
            LocationPath[I] := Format('%S=%S', [Name, Data]);
            goto Navigate;
          end;
    end;

  // Insert mode
  for I := 0 to High(LocationPath) do
    if LocationPath[I] = '' then
      begin
        LocationPath[I] := Format('%S=%S', [Name, Data]);
        goto Navigate;
      end;

  // Set page
  Navigate:
  APath := '';
  for I := 0 to High(LocationPath) do
    begin
      V := @LocationPath[I];

      if V^ = '' then
        Continue;

      if I > 0 then
        APath := APath + ':';

      APath := APath + V^;
    end;

  NavigatePath(APath);
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
    if (InArray(BareRoot, SubViewCompatibile) <> -1) or (BareRoot = 'downloads') then
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
      TSortType.Rating: Result := GetRatingValue(A) < GetRatingValue(B);

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
  end;

  // Player
  Player_Position.Max := Player.Duration;
  Track_Time.Enabled := true;

  // UI
  Song_Player.Show;

  Taskbar1.ToolTip := '🎵' + Tracks[PlayIndex].Title + ' - ' + Song_Artist.Caption;

  // Update rating
  UpdateRatingIcon;

  // Update media controls
  MediaControls.EnablePlayer := true;
  MediaControls.MediaPlaybackType := TMediaPlaybackType.Music;
  MediaControls.PlaybackStatus := TMediaPlaybackStatus.Stopped;

  if Song_Cover.Picture <> nil then
    MediaControls.Thumbnail := Song_Cover.Picture.Graphic;
  MediaControls.InfoMusic.Title := Tracks[PlayIndex].Title;
  MediaControls.InfoMusic.Artist := Artists[A].ArtistName;
  MediaControls.UpdateInformation;

  // Update
  StatusChanged;
  UpdateMiniPlayer;
end;

procedure TUIForm.Song_ArtistClick(Sender: TObject);
var
  ArtistID: string;
  Item: TDrawableItem;
  APlay: integer;
begin
  APlay := GetTrack(PlayID);

  // View Artist
  if APlay = -1 then
    Exit;

  // Validate
  ArtistID := Tracks[APlay].ArtistID;
  if ArtistID = '' then
    Exit;

  // Open
  Item.LoadSourceID(Tracks[APlay].ArtistID, TDataSource.Artists);
  Item.Execute;
end;

procedure TUIForm.Song_CoverClick(Sender: TObject);
begin
  SetEnableVisualisations(not EnableVisualisations);
end;

procedure TUIForm.Song_CoverMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    begin
      PopupDrawItem.LoadSourceID(PlayID, TDataSource.Tracks);

      PopupDrawIndex := -1;
      PopupSource := TDataSource.Tracks;

      SetDownloadIcon( PopupDrawItem.Downloaded, PopupSource );

      // Default
      Popup_Track.Tag := 1;
      Popup_Track.Popup( Mouse.CursorPos.X, Mouse.CursorPos.Y );
    end;
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
  LockWindowUpdate(TopbarContainer.Handle);
  Sort_Default.Left := 0;
  Sort_AlphaBetic.Left := 0;
  Sort_Date.Left := 0;      
  Sort_Rating.Left := 0;

  SortModeToggle.Width := 1;

  LockWindowUpdate(0);
  
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

procedure TUIForm.MinimizeToMiniPlayer;
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

procedure TUIForm.MoveByHold(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Self.Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TUIForm.MusicSeekBy(Value: int64);
begin
  MusicSeekTo( Player.Position + Value );
end;

procedure TUIForm.MusicSeekTo(Value: int64);
begin
  // Range
  Value := EnsureRange(Value, 0, Player.Duration);

  // Seek point
  SeekPoint := Value;

  // Value
  SeekUpdateStatus := Player.PlayStatus;
  Player.Position := SeekPoint;
  NeedSeekUpdate := true;
end;

procedure TUIForm.MediaControlsButton(Sender: TTransportCompatibleClass;
  Button: TSystemMediaTransportControlsButton);
begin
  case Button of
    TSystemMediaTransportControlsButton.Stop: begin
      Player.Stop;
      StatusChanged;
    end;
    TSystemMediaTransportControlsButton.Play: begin
      Player.Play;
      StatusChanged;
    end;
    TSystemMediaTransportControlsButton.Pause: begin
      Player.Pause;
      StatusChanged;
    end;

    TSystemMediaTransportControlsButton.FastForward: MusicSeekBy( 3000 );
    TSystemMediaTransportControlsButton.Rewind: MusicSeekBy( -3000 );
    TSystemMediaTransportControlsButton.Next: Action_Next.Execute;
    TSystemMediaTransportControlsButton.Previous: Action_Previous.Execute;
  end;
end;

procedure TUIForm.MediaControlsPos(Sender: TTransportCompatibleClass;
  Value: int64);
begin
  MusicSeekTo( Value );
end;

procedure TUIForm.MediaControlsRate(Sender: TTransportCompatibleClass;
  Value: double);
begin
  UIForm.AudioSpeed := Value;
end;

procedure TUIForm.MediaControlsRepeat(Sender: TTransportCompatibleClass;
  Value: TMediaPlaybackAutoRepeatMode);
begin
  case Value of
    TMediaPlaybackAutoRepeatMode.None: RepeatMode := TRepeat.Off;
    TMediaPlaybackAutoRepeatMode.Track: RepeatMode := TRepeat.One;
    TMediaPlaybackAutoRepeatMode.List: RepeatMode := TRepeat.All;
  end;

  StatusChanged;
end;

procedure TUIForm.MediaControlsShuffle(Sender: TTransportCompatibleClass;
  Value: boolean);
begin
  ToggleShuffle( not Shuffled );

  // Player
  UpdateMiniPlayer;
end;

procedure TUIForm.MediaControlsUpdateTimeline;
begin
  MediaControls.Timeline.StartTime := 0;
  MediaControls.Timeline.EndTime := Player.Duration;
  MediaControls.Timeline.Position := Player.Position;

  MediaControls.PushTimeline;

  LastTimeLineUpdate := Now;
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

  if UpdateCheck.Enabled then
    UpdateCheck.Enabled := false;

  // Status
  Latest_Version.Caption := 'Latest version on server: Checking...';

  // Status
  LastUpdateCheck := Now;

  // Update
  GetVersionUpdateData;
end;

procedure TUIForm.StatusChanged;
begin
  AddToLog('Status changed! Form.StatusChanged');

  // Button Enable
  //Button_Prev.Enabled := Player.IsFileOpen;
  Button_Play.Enabled := Player.IsFileOpen;
  //Button_Next.Enabled := Player.IsFileOpen;

  // Tick
  TickUpdate;

  // Volume
  UpdateVolumeIcon;

  if VolumeApplication.Mute then
    Button_Volume.BSegoeIcon := #$E74F;

  // Repeat
  case RepeatMode of
    TRepeat.Off: Button_Repeat.BSegoeIcon := #$F5E7;
    TRepeat.All: Button_Repeat.BSegoeIcon := #$E8EE;
    TRepeat.One: Button_Repeat.BSegoeIcon := #$E8ED;
  end;

  // Visualisations
  VisualisationUICheck;

  // Shuffle
  if Shuffled then
    Button_Shuffle.BSegoeIcon := #$E8B1
  else
    Button_Shuffle.BSegoeIcon := #$E150;

  // Repaint UI
  RedrawPaintBox;

  // Update media controls
  if not Player.IsFileOpen then
    MediaControls.PlaybackStatus := TMediaPlaybackStatus.Stopped
  else
    case Player.PlayStatus of
      TPlayStatus.psStopped: MediaControls.PlaybackStatus := TMediaPlaybackStatus.Stopped;
      TPlayStatus.psPaused: MediaControls.PlaybackStatus := TMediaPlaybackStatus.Paused;
      TPlayStatus.psPlaying: MediaControls.PlaybackStatus := TMediaPlaybackStatus.Playing;
      TPlayStatus.psStalled: MediaControls.PlaybackStatus := TMediaPlaybackStatus.Changing;
    end;

  MediaControlsUpdateTimeline;

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

  if TotalWorkCount <> 0 then
    Status_Work.Caption := Format('%S %D%%', [WORK_STATUS, round(WorkCount/TotalWorkCount*100)])
  else
    Status_Work.Caption := WORK_STATUS;
end;

function TUIForm.StrArrayToStr(AArray: TArray<string>): string;
var
  I: Integer;
begin
  Result := '[';
  for I := 0 to High(AArray) do
    begin
      Result := Result + AArray[I];

      if I < High(AArray) then
        Result := Result + ',';
    end;

  Result := Result + ']';
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

function TUIForm.StrToStrArray(Str: string): TArray<string>;
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

      Result[I-1] := StrCopy(Str, P1, P2, true);
    end;
end;

procedure TUIForm.ThreadSyncStatus(Str: string);
begin
  TThread.Synchronize(nil, procedure begin
    if SplitView1.Opened and not Download_Status.Visible then
      Download_Status.Show;

    Download_Status.Caption := Str;
  end);
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

  if Player.IsFileOpen then
    Time_Pass.Caption := Format('%S / %S',
      [CalculateLength( trunc(Player.PositionSeconds) ),
       CalculateLength( trunc(Player.DurationSeconds) )])
  else
    Time_Pass.Caption := '0:00 / 0:00';

  // Media controls
  if MillisecondsBetween(LastTimeLineUpdate, Now) > 2000 then
    MediaControlsUpdateTimeline;

  // Fix data
  if NeedSeekUpdate and (player.PlayStatus = psPlaying) and (SeekPoint <> -1) and Player.IsFileOpen then
    begin
      Player.Position := SeekPoint;

      if Player.Position = SeekPoint then
        begin
          IsSeeking := false;
          NeedSeekUpdate := false;

          SeekTimeout := 0;

          // Was paused in Audio Stream
          if SeekUpdateStatus = psPaused then
            Player.Pause;
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

procedure TUIForm.SystemMenuOpen(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  {if Button = mbRight then
    begin
      // System Menu
      Inc(X, ClientOrigin.X);
      Inc(Y, ClientOrigin.Y);
      TrackPopupMenu(GetSystemMenu(Handle, true), 0, X, Y, 0, Handle, nil);
    end;   }
end;

procedure TUIForm.VisualisationRendererTimer(Sender: TObject);
begin
  RenderVisualisations;
end;

procedure TUIForm.VisualisationUICheck;
var
  VisualShow: boolean;
begin
  { The play status is Stalled when It's buffering the song (streaming only) }
  VisualShow := EnableVisualisations and (Player.PlayStatus in [TPlayStatus.psPlaying, TPlayStatus.psStalled]);

  // Lock form
  LockWindowUpdate(Song_Player.Handle);

  // UI
  VisualisationRenderer.Enabled := VisualShow;

  Visualisation_Player.Visible := VisualShow;
  Song_Cover.Visible := not VisualShow;

  Visual_Icon.Visible := EnableVisualisations and not VisualShow;

  // Unlock form
  LockWindowUpdate(0);
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
  RestoreMainWindow;
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

procedure TUIForm.TweakPageUI;
begin
  (* Individual page general tweaks *)

  // Artist Page
  if bareroot = 'viewartist' then
    begin
      // Reset
      CButton37.FlatButton := GetPathValue('viewmode') = 'albums';
      CButton36.FlatButton := not CButton37.FlatButton;

      // Fix shuffle
      Button_ShuffleTracks.Hide;
    end;
end;

procedure TUIForm.UpdateCheckTimer(Sender: TObject);
begin
  UpdateCheck.Enabled := false;

  // Check
  if Settings_CheckUpdate.Checked and (DaysBetween(LastUpdateCheck, Now) > 0)then
    StartCheckForUpdate;
end;

procedure TUIForm.UpdateDownloads;
procedure AddItems(Items: TArray<string>);
  var
    I, J: Integer;
    Find: integer;
begin
  for I := 0 to High(Items) do
    begin
      Find := -1;
      for J := 0 to AllDownload.Count-1 do
        if AllDownload[J] = Items[I] then
          begin
            Find := J;
            Break;
          end;

    if Find = -1 then
      AllDownload.Add( Items[I] );
    end;
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
          AllDownload.Add( DownloadedTracks[I] );
      end;
      2: begin
        for I := 0 to DownloadedAlbums.Count - 1 do
          begin
            Index := GetAlbum(DownloadedAlbums[I]);

            if Index = -1 then
              Continue;

            AddItems( Albums[Index].TracksID );
          end;
      end;
      3:  begin
        for I := 0 to DownloadedArtists.Count - 1 do
          begin
            Index := GetArtist(DownloadedArtists[I]);

            if Index = -1 then
              Continue;

            AddItems( Artists[Index].TracksID );
          end;
      end;
      4: begin
        for I := 0 to DownloadedPlaylists.Count - 1 do
          begin
            Index := GetPlaylist(DownloadedPlaylists[I]);

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

procedure TUIForm.UpdateRatingIcon;
begin
  if Setting_Rating.Checked then
  // Rating
  case Tracks[PlayIndex].Rating of
    0: Button_Rating.BSegoeIcon := #$E1CE;
    1: Button_Rating.BSegoeIcon := #$F0E5;
    2..7: Button_Rating.BSegoeIcon := #$F0E7;
    8..9: Button_Rating.BSegoeIcon := #$F0E9;
    10: Button_Rating.BSegoeIcon := #$E0B5;
  end
    else
  // Thumbs
  case Tracks[PlayIndex].Rating of
    0: Button_Rating.BSegoeIcon := #$E19D;
    1: Button_Rating.BSegoeIcon := #$E19E;
    2..4: Button_Rating.BSegoeIcon := #$E7C6;
    6..9: Button_Rating.BSegoeIcon := #$E1CF;
    5,10: Button_Rating.BSegoeIcon := #$E19F; // iBroadcast servers use a rating of 5 for LIKE, sometimes...
  end;
end;

procedure TUIForm.UpdateVolumeIcon;
var
  VolPosition: integer;
  VolMute: boolean;
begin
  try
    VolPosition := ceil(VolumeApplication.Volume * 4);
    VolMute := VolumeApplication.Mute;
  except
    VolPosition := ceil(Player.Volume * 4);
    VolMute := false;
  end;
  case VolPosition of
    0: Button_Volume.BSegoeIcon := #$E992;
    1: Button_Volume.BSegoeIcon := #$E993;
    2: Button_Volume.BSegoeIcon := #$E994;
    else Button_Volume.BSegoeIcon := #$E995;
  end;

  if VolMute then
    Button_Volume.BSegoeIcon := #$E74F;
end;

procedure TUIForm.ValidateDownloadFiles;
{ This function deleted files that are no longer needed }
var
  Files: TArray<string>;
  Folder, AFolder: string;

  Name: string;
  A, I: Integer;
  ID: string;

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

  // Delete Songs
  Files := [];
  if TDirectory.Exists(Folder) then
    Files := TDirectory.GetFiles( Folder, '*.mp3' );
  for I := 0 to High(Files) do
    begin
      // Get ID
      Name := ChangeFileExt( ExtractFileName( Files[I] ), '' );
      try
        ID := Name;
      except
        Continue;
      end;

      // Compare
      Exists := false;
      for A := 0 to AllDownload.Count - 1 do
        if ID = AllDownload[A] then
          begin
            Exists := true;
            Break
          end;

      // Delete
      if not Exists then
        if DownloadQueue.IndexOf(ID) = -1 then
          try
            DeleteDownloaded( ID );
          except
            // Thread is still using the file. To be deleted on next launch
          end;
    end;

  // Delete albums
  Files := [];
  AFolder := Folder + 'albums\';
  if TDirectory.Exists(AFolder) then
    Files := TDirectory.GetFiles( AFolder, '*.txt' );
  for I := 0 to High(Files) do
    begin
      // Get ID
      Name := ChangeFileExt( ExtractFileName( Files[I] ), '' );

      if DownloadedAlbums.IndexOf(Name) = -1 then
        try
          TFile.Delete(Files[I]);
        finally
          // Thread is still using the file. To be deleted on next launch
        end;
    end;

  // Delete artists
  Files := [];
  AFolder := Folder + 'artists\';
  if TDirectory.Exists(AFolder) then
    Files := TDirectory.GetFiles( AFolder, '*.txt' );
  for I := 0 to High(Files) do
    begin
      // Get ID
      Name := ChangeFileExt( ExtractFileName( Files[I] ), '' );

      if DownloadedArtists.IndexOf(Name) = -1 then
        try
          TFile.Delete(Files[I]);
        finally
          // Thread is still using the file. To be deleted on next launch
        end;
    end;

  // Delete playlists
  Files := [];
  AFolder := Folder + 'playlists\';
  if TDirectory.Exists(AFolder) then
    Files := TDirectory.GetFiles( AFolder, '*.txt' );
  for I := 0 to High(Files) do
    begin
      // Get ID
      Name := ChangeFileExt( ExtractFileName( Files[I] ), '' );

      if DownloadedPlaylists.IndexOf(Name) = -1 then
        try
          TFile.Delete(Files[I]);
        finally
          // Thread is still using the file. To be deleted on next launch
        end;
    end;

  { Check for server-deleted files }
  // Tracks
  for I := DownloadedTracks.Count-1 downto 0 do
    begin
      try
        ID:= DownloadedTracks[I];
      except
        Continue;
      end;

      if GetTrack(ID) = -1 then
        begin
          var AIndex: integer;
          AIndex := DownloadedTracks.IndexOf(DownloadedTracks[I]);

          // Delete from downloads
          if AIndex <> -1 then
            begin
              DownloadedTracks.Delete(AIndex);

              AIndex := AllDownload.IndexOf(ID);
              if AIndex <> -1 then
                AllDownload.Delete(AIndex);
            end;
        end;
    end;

  // Albums
  for I := DownloadedAlbums.Count-1 downto 0 do
    begin
      try
        ID:= DownloadedAlbums[I];
      except
        Continue;
      end;

      if GetAlbum(ID) = -1 then
        begin
          var AIndex: integer;
          AIndex := DownloadedAlbums.IndexOf(DownloadedAlbums[I]);

          // Delete from downloads
          if AIndex <> -1 then
            DownloadedAlbums.Delete(AIndex);
        end;
    end;

  // Artists
  for I := DownloadedArtists.Count-1 downto 0 do
    begin
      try
        ID:= DownloadedArtists[I];
      except
        Continue;
      end;

      if GetArtist(ID) = -1 then
        begin
          var AIndex: integer;
          AIndex := DownloadedArtists.IndexOf(DownloadedArtists[I]);

          // Delete from downloads
          if AIndex <> -1 then
            DownloadedArtists.Delete(AIndex);
        end;
    end;

  // Playlists
  for I := DownloadedPlaylists.Count-1 downto 0 do
    begin
      try
        ID:= DownloadedPlaylists[I];
      except
        Continue;
      end;

      if GetPlaylist(ID) = -1 then
        begin
          var AIndex: integer;
          AIndex := DownloadedPlaylists.IndexOf(DownloadedPlaylists[I]);

          // Delete from downloads
          if AIndex <> -1 then
            DownloadedPlaylists.Delete(AIndex);
        end;
    end;
end;

procedure TUIForm.VolumeAppChange(Sender: TAppAudioManager;
  const NewVolume: Single; NewMute: boolean);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      UpdateVolumeIcon;

      if (VolumePop <> nil) and VolumePop.Visible then
        VolumePop.LoadVolume;
    end);
end;

procedure TUIForm.VolumeSysChange(Sender: TSystemAudioManager;
  const Volume: Single; Muted: boolean);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if (VolumePop <> nil) and VolumePop.Visible then
        VolumePop.LoadVolume;
    end);
end;

procedure TUIForm.PopupGeneralViewAlbum(Sender: TObject);
var
  AlbumID: string;
  Item: TDrawableItem;
begin
  // View Artist
  case PopupSource of
    TDataSource.Tracks: AlbumID := Tracks[PopupDrawItem.Index].AlbumID;
    else Exit;
  end;

  // Validate
  if AlbumID = '' then
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

procedure TUIForm.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
  //inherited;
  CloseApplication;
end;

procedure TUIForm.WMRestoreMainWindow(var Msg: TMessage);
begin
  RestoreMainWindow;
end;

{ TDrawableItem }

procedure TDrawableItem.TrashFromLibrary;
begin
  case Source of
    TDataSource.Tracks: DeleteTrack(ItemID);
    TDataSource.Albums: DeleteAlbum(ItemID);
    TDataSource.Artists: DeleteArtist(ItemID);
    TDataSource.Playlists: DeletePlayList(ItemID);
  end;
end;

function TDrawableItem.Active: boolean;
begin
  Result := (Source = TDataSource.Tracks) and (ItemID = PlayID);
end;

function TDrawableItem.Downloaded: boolean;
begin
  case Source of
    TDataSource.Tracks: Result := DownloadedTracks.IndexOf(ItemID) <> -1;
    TDataSource.Albums: Result := DownloadedAlbums.IndexOf(ItemID) <> -1;
    TDataSource.Artists: Result := DownloadedArtists.IndexOf(ItemID) <> -1;
    TDataSource.Playlists: Result := DownloadedPlaylists.IndexOf(ItemID) <> -1;
    else
      Result := false
  end;
end;

procedure TDrawableItem.Execute;
var
  I: integer;
begin
  AddToLog('TDrawableItem[' + Index.ToString + '].Execute');

  case Source of
    TDataSource.Tracks: begin
      if (ItemID <> PlayID) or (Player.PlayStatus <> psPlaying) then
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
              if DrawItems[SortingList[I]].Trashed then
                Continue;

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
      (* Navigate *)
      UIForm.NavigatePath('ViewAlbum:' + Albums[Index].ID);
    end;

    TDataSource.Artists: begin
      (* Navigate *)
      UIForm.NavigatePath('ViewArtist:' + Artists[Index].ID);
    end;

    TDataSource.Playlists: begin
      (* Navigate *)
      UIForm.NavigatePath('ViewPlaylist:' + Playlists[Index].ID);
    end;

    else Exit;
  end;

  // General Data
  LastValueID := ItemID;
  LastExecutedSource := Source;
end;

procedure TDrawableItem.ExecuteSecondary;
var
  I: integer;
  ATracks: TArray<string>;
begin
  AddToLog('TDrawableItem[' + Index.ToString + '].ExecuteSecondary');

  case Source of
    TDataSource.Albums: begin
      ATracks := Albums[Index].TracksID;
    end;

    TDataSource.Artists: begin
      ATracks := Artists[Index].TracksID;
    end;

    TDataSource.Playlists: begin
      ATracks := Playlists[Index].TracksID;
    end;

    else Exit;
  end;

  // Create new queue
  UIForm.QueueClear;

  // Draw
  UIForm.QueueUpdated;

  // Empty
  if Length(ATracks) = 0 then
    Exit;

  // Add
  for I := 0 to High(ATracks) do
    begin
      const Index = GetTrack(ATracks[I]);
      if Index <> -1 then
        PlayQueue.Add( Index );
    end;

  // Play
  QueuePos := 0;
  UIForm.QueuePlay;

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

function TDrawableItem.HasSecondary: boolean;
begin
  Result := Source in [TDataSource.Albums, TDataSource.Artists, TDataSource.Playlists];
end;

function TDrawableItem.Hidden: boolean;
begin
  Result := HiddenItem or HiddenSearch{or (Trashed and not ShowTrashed)};
end;

function TDrawableItem.Invalid: boolean;
begin
  Result := (Index = -1) or (ItemID = '') or (Title = '');
end;

function TDrawableItem.IsDownloaded: TDownloadedKind;
begin
  Result := TDownloadedKind.None;
  if Downloaded then
    Result := TDownloadedKind.Direct;

  if (Result = TDownloadedKind.None) and (Source = TDataSource.Tracks) then
    begin
      var I: integer;
      for I := 0 to AllDownload.Count-1 do
        if AllDownload[I] = ItemID then
          Exit(TDownloadedKind.Indirect);
    end;
end;

procedure TDrawableItem.LoadSource(AIndex: integer; From: TDataSource);
var
  Temp, A, APos: integer;
  Data1: string;
begin
  if AIndex = -1 then
    Exit;

  Index := AIndex;

  HiddenItem := false;
  HiddenSearch := false;
  Loaded := true;
  Trashed := false;

  Source := From;

  case From of
    TDataSource.Tracks: begin
      ItemID := Tracks[Index].ID;

      Title := Tracks[Index].Title;
      Rating := Tracks[Index].Rating;

      Trashed := Tracks[Index].IsInTrash;

      // Info
      SetLength(Information, 11);
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
      Information[10] := 'Trashed: ' + booleantostring(Trashed);

      // Default Info
      InfoShort := Data1 + ' • ' + Yearify(Tracks[Index].Year);
      InfoLong := Information[1] + ', ' + Information[4] + ', ' +
        Information[3] + ', ' + Information[5] + ', ' + Information[8];
    end;

    TDataSource.Albums: begin
      ItemID := Albums[Index].ID;

      Title := Albums[Index].AlbumName;
      Rating := Albums[Index].Rating;

      Trashed := Albums[Index].IsInTrash;

      // Info
      SetLength(Information, 7);
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
        begin
          APos := GetTrack(Albums[Index].TracksID[A]);
          if APos <> -1 then
            Inc(Temp, Tracks[APos].LengthSeconds );
        end;
      Information[5] := 'Length: ' + UIForm.CalculateLength(Temp);
      Information[6] := 'Trashed: ' + booleantostring(Trashed);

      // Default Info
      InfoShort := Length(Albums[Index].TracksID).ToString + ' Tracks • ' + Information[2];
      InfoLong := Information[0] + ', ' + Information[2] + ', ' +
        Information[1] + ', ' + Information[3] + ', ' + Information[4];
    end;

    TDataSource.Artists: begin
      ItemID := Artists[Index].ID;

      Title := Artists[Index].ArtistName;
      Rating := Artists[Index].Rating;

      Trashed := Artists[Index].IsInTrash;

      // Info
      SetLength(Information, 4);
      Information[0] := 'Total Tracks: ' + Length(Artists[Index].TracksID).ToString;
      Temp := 0;
      for A := 0 to High(Albums) do
        if Albums[A].ArtistID = ItemID then
          Inc(Temp);
      Information[1] := 'Album count: ' + Temp.ToString;
      Information[2] := 'Rating: ' + Artists[Index].Rating.ToString;
      Information[3] := 'Trashed: ' + booleantostring(Trashed);

      // Default Info
      InfoShort :=  Length(Artists[Index].TracksID).ToString + ' Tracks • ' + Information[1];
      InfoLong := Information[0] + ', ' + Information[1] + ', ' +
        Information[2];
    end;

    TDataSource.Playlists: begin
      ItemID := Playlists[Index].ID;

      Title := Playlists[Index].Name;
      Rating := 0; // Playlists do not have ratings

      Trashed := false; // Playlists cannot be in the trash

      // Info
      SetLength(Information, 3);
      Information[0] := 'Total Tracks: ' + Length(Playlists[Index].TracksID).ToString;
      Temp := 0;
      for A := 0 to High(Playlists[Index].TracksID) do
        begin
          APos := GetTrack(Playlists[Index].TracksID[A]);
          if APos <> -1 then
            Inc(Temp, Tracks[APos].LengthSeconds );
        end;

      Information[1] := 'Length: ' + UIForm.CalculateLength(Temp);
      Information[2] := 'Description: "' + Playlists[Index].Description + '"';

      // Default Info
      InfoShort := Length(Playlists[Index].TracksID).ToString + ' Tracks • ' + Copy(Information[1], 9, 9);
      InfoLong := Information[0] + ', ' + Information[1] + ', ' + Information[2];
    end;
  end;
end;

procedure TDrawableItem.LoadSourceID(ID: string; From: TDataSource);
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
  // Leload
  ReloadSource;

  // UI
  with InfoBox do
    begin
      Caption := Title;
      Song_Name.Text := Title;
      Song_Info.Lines.Text := GetPremadeInfoList;
      Song_Rating.Rating := Rating;

      Download_Item.Visible := not IsOffline;
      Download_Item.Tag := Downloaded.ToInteger;
      Download_Item.OnEnter(Download_Item);

      Song_Cover.Picture.Assign( Self.GetPicture );
    end;

  InfoBoxIndex := Index;
  InfoBoxPointer := @Self;

  InfoBox.Prepare;
  CenterFormInForm(InfoBox, UIForm, true);
end;

procedure TDrawableItem.ReloadSource;
begin
  LoadSourceID(ItemID, Source);
end;

procedure TDrawableItem.RestoreFromLibrary;
begin
  case Source of
    TDataSource.Tracks: RestoreTrack(ItemID);
    TDataSource.Albums: RestoreAlbum(ItemID);
    TDataSource.Artists: RestoreArtist(ItemID);
    TDataSource.Playlists: (* nothing *);
  end;
end;

procedure TDrawableItem.StartPictureLoad;
var
  ThreadSource: TDataSource;
  ItemIndex: integer;
  ItemIdentifier: string;
  FileName: string;
  IsDownload: boolean;
  AImagePointer: TJPegImage;
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
            // Check Local mp3 download! Different from Artowork Store!!!
            if IsDownload and not Tracks[ItemIndex].ArtworkLoaded then
              begin
                FileName := AppData + DOWNLOAD_DIR + ItemIdentifier + ART_EXT;
                if TFile.Exists(FileName) then
                  begin
                    Tracks[ItemIndex].Status := Tracks[ItemIndex].Status + [TWorkItem.DownloadingImage];

                    Tracks[ItemIndex].CachedImage := TJpegImage.Create;
                    Tracks[ItemIndex].CachedImage.LoadFromFile(FileName);

                    Tracks[ItemIndex].Status := Tracks[ItemIndex].Status - [TWorkItem.DownloadingImage];
                  end;
              end;

            // Server Side + get pointer
            AImagePointer := Tracks[ItemIndex].GetArtwork();
          end;
          TDataSource.Albums: AImagePointer := Albums[ItemIndex].GetArtwork();
          TDataSource.Artists: AImagePointer := Artists[ItemIndex].GetArtwork();
          TDataSource.Playlists: AImagePointer := Playlists[ItemIndex].GetArtwork();
        end;
      except
        // Due to media store, sometimes files are being used by two threads at the same time
        Dec(TotalThreads);
        Exit;
      end;

      // Synchronize
      TThread.Synchronize(nil, procedure
        begin
          if AImagePointer <> nil then
            if InfoBox.Visible and (ItemIndex = InfoBoxIndex) then begin
              (* Info Box *)
              InfoBox.Song_Cover.Picture.Assign( AImagePointer );

              (* Media controls *)
              MediaControls.Thumbnail := AImagePointer;
            end
                else
              (* Info View Page *)
              if UIForm.Page_SubView.Visible and (ItemIdentifier = LocationExtra) then
                begin
                  UIForm.SubView_Cover.Picture.Assign(AImagePointer);
                  UIForm.RedrawPaintBox;
                end
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
      OfflineDialog('To change downloads, please connect to a network');

      Exit(false);
    end;

  // Download
  LastValue := ItemID;

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

initialization
  VersionChecker := TStandardVersionCheckerUpdateUrl.Create(API_APPNAME, VERSION);

  // Register
  AppRegistration.AppUserModelID := APP_USERMODELID;
  AppRegistration.AppName := APP_NAME;
  AppRegistration.AppDescription := APP_DESCRIPTION;

  // Media
  MediaControls := TWindowMediaTransportControls.Create;

  MediaControls.MediaPlaybackType := TMediaPlaybackType.Music;
  MediaControls.SupportedMediaControls := [TMediaControlAction.Play,
    TMediaControlAction.Pause, TMediaControlAction.Stop,
    TMediaControlAction.SkipPrevious, TMediaControlAction.SkipNext,
    TMediaControlAction.FastForward, TMediaControlAction.Rewind];

  MediaControls.EnablePlayer := false;

finalization
  VersionChecker.Free;
  MediaControls.Free;
end.
