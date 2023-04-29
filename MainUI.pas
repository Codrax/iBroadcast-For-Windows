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
  Cod.Audio, UITypes, Types, VolumePopup, Math, Performance,
  Cod.Math, System.IniFiles, System.Generics.Collections, Web.HTTPApp,
  Bass, System.Win.TaskbarCore, Vcl.Taskbar, Cod.Visual.CheckBox, MiniPlay,
  InfoForm;

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

  // Source
  TDataSource = (Tracks, Albums, Artists, Playlists, None);
  TDataSources = set of TDataSource;

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

    (* Mix data *)
    function Hidden: boolean;

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
    Button_ToggleMenu: CButton;
    CImage1: CImage;
    Label1: TLabel;
    Label2: TLabel;
    CButton2: CButton;
    CButton3: CButton;
    CButton4: CButton;
    CButton5: CButton;
    CButton6: CButton;
    CButton7: CButton;
    TitlebarCompare: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Page_Title: TLabel;
    PagesHolder: TPanel;
    Song_Player: TPanel;
    Panel6: TPanel;
    Song_Cover: CImage;
    Panel7: TPanel;
    Panel8: TPanel;
    Song_Name: TLabel;
    Song_Artist: TLabel;
    Panel9: TPanel;
    Button_Next: CButton;
    Button_Prev: CButton;
    Button_Play: CButton;
    Button_Previous: CButton;
    GeneralDraw: TPanel;
    DrawItem: TPaintBox;
    ScrollPosition: TScrollBar;
    Page_Home: TPanel;
    ScrollBox1: TScrollBox;
    Welcome_Label: TLabel;
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
    Label11: TLabel;
    LoginBox: TPanel;
    Label12: TLabel;
    Login_ID: TEdit;
    Label13: TLabel;
    Login_UsrToken: TEdit;
    CButton13: CButton;
    CPanel1: CPanel;
    CImage4: CImage;
    Shape1: TShape;
    CImage5: CImage;
    Label14: TLabel;
    CImage6: CImage;
    LoginFailed: TPanel;
    Shape2: TShape;
    Label15: TLabel;
    Label16: TLabel;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    HideLoginPopup: TTimer;
    LoadingUIContainer: TPanel;
    CImage7: CImage;
    CImage8: CImage;
    Label17: TLabel;
    Label18: TLabel;
    LoadingGif: CPanel;
    CImage9: CImage;
    Shape6: TShape;
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
    Button_ReloadLib: CButton;
    QueueDraw: TPaintBox;
    QueueScroll: TScrollBar;
    Panel14: TPanel;
    Label23: TLabel;
    Button_ClearQueue: CButton;
    QueueSwitchAnimation: TTimer;
    QueueDownGo: TTimer;
    HomeDraw: TPaintBox;
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
    Label29: TLabel;
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
    Mini_Cast: CImage;
    SearchToggle: TPanel;
    Search_Button: CButton;
    SearchBox_Hold: TPanel;
    Quick_Search: TEdit;
    Label30: TLabel;
    Panel19: TPanel;
    SearchBox1: TSearchBox;
    SearchDraw: TPaintBox;
    ScrollBar_4: TScrollBar;
    Label31: TLabel;
    CCheckBox1: CCheckBox;
    Label32: TLabel;
    CCheckBox2: CCheckBox;
    CCheckBox3: CCheckBox;
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
    procedure LoadingUIContainerResize(Sender: TObject);
    procedure Complete_EmailClick(Sender: TObject);
    procedure DrawItemMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_PlayClick(Sender: TObject);
    procedure Button_VolumeClick(Sender: TObject);
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
    procedure WebSyncTimer(Sender: TObject);
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
    procedure Setting_GraphChange(Sender: CCheckBox; State: TCheckBoxState);
    procedure CButton16Click(Sender: TObject);
    procedure Button_MiniPlayerClick(Sender: TObject);
    procedure SearchDrawPaint(Sender: TObject);
    procedure SearchBox1InvokeSearch(Sender: TObject);
    procedure Search_ButtonClick(Sender: TObject);
    procedure Quick_SearchExit(Sender: TObject);
    procedure Quick_SearchChange(Sender: TObject);
    procedure Quick_SearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    // Items
    function GetItemCount: cardinal;
    procedure LoadItemInfo;

    function GetTracksID: TArray<integer>;

    // Draw Box
    procedure RecalibrateScroll;
    procedure DrawItemCanvas(Canvas: TCanvas; ARect: TRect; Title, Info: string;
      Picture: TJpegImage; Active: boolean);
    procedure DrawWasClicked(Shift: TShiftState = []);

    // UI
    procedure ReselectPage;
    function OpenDialog(Title, Text: string; AType: CMessageType = ctInformation; Buttons: TMsgDlgButtons = [mbOk]): integer;
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

  public
    { Public declarations }
    procedure NavigatePath(Path: String; AddHistory: boolean = true);

    // Player
    procedure PlaySong(Index: cardinal);

    procedure StatusChanged;
    procedure TickUpdate;

    // Page
    procedure PreviousPage;
    procedure CheckPages;

    // Draw
    procedure RedrawPaintBox;

    // Queue
    procedure AddQueue(MusicIndex: integer);
    procedure DeleteQueue(MusicIndex: integer);

    procedure QueueClear;
    procedure QueueNext;
    procedure QueuePrev;
    procedure QueueSetTo(Index: integer);

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

    // Font
    function GetSegoeIconFont: string;

    // Login
    procedure PrepareForLogin;
    procedure InitiateLogin;
    procedure StatLoginScreen;

    // Data
    function CalculateLength(Seconds: cardinal): string;

    // Libraru
    procedure ReloadLibrary;
  end;

const
  // UI
  BG_COLOR = $002C0C11;
  FN_COLOR = clWhite;

  ICON_PLAY = #$E768;
  ICON_PAUSE = #$E769;

  CAPTION_EMAIL = 'Your email adress: %s';
  CAPTION_USER = 'iBroadcast user since %s';
  CAPTION_VERIFIED = 'Your account is verified. Verification date: %s';
  CAPTION_UNVERIFIED = 'You are at risk of losing you account. Please verify your email adress';
  CAPTION_PREMIUM = 'You are subscribed to premium, awesome! Thanks and enjoy iBroadcast!';
  CAPTION_NOTPREMIUM = 'You are not subscribed to premium';

  // PAGES
  PlayCaptions: TArray<string> = ['Home', 'Search', 'Albums', 'Songs', 'Playlists',
  'Artists', 'Genres', 'ViewAlbum', 'ViewPlaylist', 'ViewArtist', 'ViewGenres',
  'History', 'Account', 'Settings', 'About', 'Premium'];

  ViewCompatibile: TArray<string> = ['albums', 'songs', 'artists', 'playlists', 'genres', 'history'];
  SubViewCompatibile: TArray<string> = ['viewalbum', 'viewartist', 'viewplaylist', 'history'];

  // SYSTEM
  THREAD_MAX = 5;

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

  // Page System
  PageHistory: TArray<THistorySet>;

  BareRoot: string;

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

  LastScrollValue: integer;

  ListSort: TSortType;
  EnabledSorts: TSortTypes = [TSortType.Default, TSortType.Alphabetic, TSortType.Year, TSortType.Rating];
  SortingList: TArray<integer>;

  HomeFitItems: integer;

  // Queue System
  PlayIndex: integer = -1;
  PlayID: integer = -1;

  QueuePos: integer;
  PlayQueue: TIntegerList;

  Shuffled: boolean;
  OriginalQueueValid: boolean;
  PlayQueueOriginal: TIntegerList;

  RepeatMode: TRepeat = TRepeat.All;

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

procedure TUIForm.AddQueue(MusicIndex: integer);
var
  WasStopped: boolean;
begin
  WasStopped := (Player.PlayStatus = TPlayStatus.psStopped)
    and (QueuePos = PlayQueue.Count - 1) and (PlayQueue.Count <> 0);

  PlayQueue.Add( MusicIndex );

  if WasStopped then
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

procedure TUIForm.Button_ExtendClick(Sender: TObject);
begin
  if EqualApprox(DestQueuePopup, Queue_Extend.Constraints.MaxHeight, 10) then
    begin
      DestQueuePopup := 0;
      CButton(Sender).BSegoeIcon := #$E70E;
    end
  else
    begin
      DestQueuePopup := Queue_Extend.Constraints.MaxHeight;
      CButton(Sender).BSegoeIcon := #$E70D;
    end;

  QueueAnProgress := 1;
  QueuePopupAnimate.Enabled := true;
end;

procedure TUIForm.Button_MiniPlayerClick(Sender: TObject);
begin
  Hide;
  MiniPlayer.PreparePosition;

  // Get data
  UpdateMiniPlayer
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
  // Login User
  HideAllUI;

  LoadingUIContainer.Show;
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
begin
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
  end;

  ShellRun(URL, false);
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

procedure TUIForm.Button_VolumeClick(Sender: TObject);
begin
  // Volume
  VolumePop.Top := Button_Volume.ClientToScreen(Point(0, 0)).Y - VolumePop.Height;
  VolumePop.Left := Button_Volume.ClientToScreen(Point(0, 0)).X - VolumePop.Width + Button_Volume.Width;

  VolumePop.CSlider1.Position := trunc(Player.Volume * 1000);

  VolumePop.Show;
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
    7: NavigatePath( 'History' );
    8: NavigatePath( 'Account' );
    9: NavigatePath( 'Settings' );
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

procedure TUIForm.DrawItemCanvas(Canvas: TCanvas; ARect: TRect; Title,
  Info: string; Picture: TJpegImage; Active: boolean);
var
  TempRect: TRect;
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

        Title := TrimmifyText(Canvas, Title, TempRect.Width);;
        TextRect(TempRect, Title, [tfCenter, tfBottom]);

        // Subtext
        Brush.Style := bsClear;
        Font.Assign( Self.Font );

        TempRect := ARect;
        Inc(TempRect.Top, ARect.Width + CoverSpacing);
        Font.Size := Font.Size - 2;

        Inc(TempRect.Top, trunc(60/100 * TempRect.Height));

        Info := TrimmifyText(Canvas, Info, TempRect.Width);;
        TextRect(TempRect, Info, [tfCenter, tfTop]);

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
  Press10Stat := 0;

  // Click
  if IndexHoverID <> -1 then
    begin
      DrawWasClicked(Shift);
    end;

  // Reset
  MouseIsPress := false;

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
                ARect.Inflate(-Press10Stat, -trunc(ARect.Width / ARect.Height * Press10Stat));

              // Draw
              DrawItemCanvas(TPaintBox(Sender).Canvas, ARect, Title, Info,
                Picture, DrawItems[Index].Active);
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
                ARect.Inflate(-Press10Stat, -trunc(ARect.Width / ARect.Height * Press10Stat));

              // Draw
              DrawItemCanvas(TPaintBox(Sender).Canvas, ARect, Title, Info,
                Picture, DrawItems[Index].Active);
            end;

          // Move Line
          Inc(Y, ListHeight + ListSpacing);

          if Y > AHeight then
            Break; Continue
        end;
    end;


  // Scroll
  try
    RecalibrateScroll;
  except
    ShowMessage('Error');
  end;
end;

procedure TUIForm.DrawWasClicked(Shift: TShiftState);
var
  Index: integer;
begin
  Index := GetSort(IndexHover);

  if ssAlt in Shift then
    DrawItems[Index].OpenInformation
  else
    DrawItems[Index].Execute;
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
            or CompareFound(Term, DrawItems[I].InfoLong, Flags);

          DrawItems[I].HiddenSearch := not Found;
        end;
    end;

  LastFilterQuery := Term;
end;

procedure
TUIForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Threads
  if TotalThreads > 0 then
    if OpenDialog('Close Application', 'Are you sure? Some threads are still running', ctQuestion, [mbYes, mbNo]) = mrNo then
      begin
        CanClose := false;
        Exit;
      end;

  Player.Free;
  PlayQueue.Free;

  // Save Data
  TokenLoginInfo(false);

  ProgramSettings(false);
end;

procedure TUIForm.FormCreate(Sender: TObject);
begin
  // UX
  Color := BG_COLOR;
  Font.Color := clWhite;
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

  // Player
  Player := TAudioPlayer.Create;
  StatusChanged;

  // Queue
  PlayQueue := TIntegerList.Create;

  // Page Navigation
  SetLength(PageHistory, 0);

  // Get Client Information
  DEVICE_NAME := Format(DEVICE_NAME_CONST, [GetCompleteUserName + #39's']);

  // System Draw Colors
  ItemColor := ChangeColorSat($002C0C14, 20);
  ItemActiveColor := ColorBlend( ChangeColorSat($002C0C14, 20), clHighlight, 60 );
  TextColor := Self.Font.Color;

  // Data
  ProgramSettings(true);

  // Queue UI
  Queue_Extend.Height := 0;

  // Get login info
  try
    TokenLoginInfo(true);
  except
  end;

  // Load Existing session
  if (APPLICATION_ID <> '') and (LOGIN_TOKEN <> '') then
    begin
      InitiateLogin;
    end
  else
    // Login
    begin
      // Prepae
      PrepareForLogin;
    end;
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

function TUIForm.GetSegoeIconFont: string;
begin
  if (Screen.Fonts.IndexOf(FONT_SEGOE_FLUENT) <> -1) then
    Font.Name := FONT_SEGOE_FLUENT
  else
    Font.Name := FONT_SEGOE_METRO;
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

procedure TUIForm.HideAllUI;
begin
  LoginUIContainer.Hide;
  TitlebarCompare.Hide;
  PrimaryUIContainer.Hide;
  LoadingUIContainer.Hide;
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
  I: integer;
  ARect: TRect;
begin
  ViewStyle := TViewStyle.Cover;

  with HomeDraw.Canvas do
    begin
      // Prepare
      Y := 0;
      X := 0;

      // Font
      Font.Assign( Self.Font );

      // Albums
      S := 'Recently Played Albums';
      Font.Size := 16;
      TextOut(X, Y, S);
      Inc(Y, TextHeight(S) + CoverSpacing);

      for I := 0 to HomeFitItems - 1 do
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
          DrawItemCanvas(HomeDraw.Canvas, ARect, DrawItems[I].Title, DrawItems[I].InfoShort, DrawItems[I].GetPicture, DrawItems[I].Active);

          // Mext
          Inc(X, CoverWidth + CoverSpacing);
        end;

      Inc(Y, CoverHeight + CoverSpacing);
      X := 0;

      // Favorites
      S := 'Favorite Tracks';
      Font.Size := 16;
      TextOut(X, Y, S);
      Inc(Y, TextHeight(S) + CoverSpacing);

      for I := HomeFitItems to HomeFitItems * 2 - 1 do
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
          DrawItemCanvas(HomeDraw.Canvas, ARect, DrawItems[I].Title, DrawItems[I].InfoShort, DrawItems[I].GetPicture, DrawItems[I].Active);

          // Mext
          Inc(X, CoverWidth + CoverSpacing);
        end;

      Inc(Y, CoverHeight + CoverSpacing);
      X := 0;

      // History
      S := 'Recently playes tracks';
      Font.Size := 16;
      TextOut(X, Y, S);
      Inc(Y, TextHeight(S) + CoverSpacing);

      for I := HomeFitItems * 2 to HomeFitItems * 3 - 1 do
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
          DrawItemCanvas(HomeDraw.Canvas, ARect, DrawItems[I].Title, DrawItems[I].InfoShort, DrawItems[I].GetPicture, DrawItems[I].Active);

          // Mext
          Inc(X, CoverWidth + CoverSpacing);
        end;

      Inc(Y, CoverHeight + CoverSpacing);
      X := 0;

      // Playlists
      S := 'From your playlists';
      Font.Size := 16;
      TextOut(X, Y, S);
      Inc(Y, TextHeight(S) + CoverSpacing);

      for I := HomeFitItems * 3 to HomeFitItems * 4 - 1 do
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
          DrawItemCanvas(HomeDraw.Canvas, ARect, DrawItems[I].Title, DrawItems[I].InfoShort, DrawItems[I].GetPicture, false);

          // Mext
          Inc(X, CoverWidth + CoverSpacing);
        end;

      Inc(Y, CoverHeight + CoverSpacing);



      // Height
      HomeDraw.Height := Y;
    end;
end;

procedure TUIForm.InitiateLogin;
begin
  // Login User
  StatLoginScreen;

  LoadingUIContainer.Show;
  TTask.Run(procedure
    begin
      if LoginUser then
        begin
          // Load Library, Account, Queue
          ReLoadLibrary;

          // Default Load
          DefaultPicture := GetSongArtwork('0', TArtSize.Small);

          // Show UI
          TThread.Synchronize(nil, procedure
            begin
              // Navigate to Home
              NavigatePath('Home');

              HideAllUI;
              TitlebarCompare.Show;
              PrimaryUIContainer.Show;
            end);
      end
    else
      begin
        // Login unsuccessfull
        TThread.Synchronize(nil, procedure
          begin
            if LoadingUIContainer.Visible then
              begin
                PrepareForLogin;

                LoginFailed.Show;
                HideLoginPopup.Enabled := true;
              end
            else
              // Prepare
              PrepareForLogin;
          end);
      end;
    end);
end;

procedure TUIForm.LoadingUIContainerResize(Sender: TObject);
begin
  // Realign components
  LoadingGif.Left := LoadingUIContainer.Width div 2 - LoadingGif.Width div 2;
  LoadingGif.Top := Label18.Top + Label18.Height * 3;

  CImage7.Left := 0;
  CImage7.Top := 0;

  CImage7.Width := LoadingUIContainer.Width;
  CImage7.Height := LoadingUIContainer.Height;
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
      SomeArray := Playlists[GetPlaylistType('recently-played')].TracksID;
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
          SelectItems := Playlists[GetPlaylistType('thumbsup')].TracksID;

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
          SelectItems := Playlists[GetPlaylistType('recently-played')].TracksID;

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
      SelectItems := GetTracksID;

      SetLength( DrawItems, Length(SelectItems) );
      for I := 0 to High(SelectItems) do
        DrawItems[I].LoadSource(GetTrack( SelectItems[I] ), TDataSource.Tracks);
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
  LoginBox.Left := LoginUIContainer.Width div 2 - LoginBox.Width div 2;
  LoginBox.Top := Label11.Top + Label11.Height * 2;

  CImage6.Left := 0;
  CImage6.Top := 0;

  CImage6.Width := LoginUIContainer.Width;
  CImage6.Height := LoginUIContainer.Height;
end;

procedure TUIForm.NavigatePath(Path: String; AddHistory: boolean);
var
  Root, MetaData: string;
  P: integer;
  Valid: integer;
  I: Integer;
begin
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

function TUIForm.OpenDialog(Title, Text: string; AType: CMessageType;
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

  Dialog.FormColor := Self.Color;
  Dialog.TextFont.Color := Self.Font.Color;

  Dialog.ButtonDesign.FlatButton := true;
  Dialog.ButtonDesign.FlatComplete := true;

  // Dialog
  Dialog.Buttons := Buttons;
  Dialog.Kind := AType;

  // Execute
  Result := Dialog.Execute;

  Dialog.Free;
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
begin
  for I := 0 to PlayQueue.Count - 1 do
    if QRects[I].Contains(Point(X, Y)) then
        begin
          QueueHover := I;
          Break;
        end;

  // Cusros
  if I <> -1 then
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
      QueueDownGo.Enabled := (Y > 85/100 *  QueueDraw.Height) or (Y < 15/100 *  QueueDraw.Height);
      if (Y <  QueueDraw.Height div 2) then
        QueueDownGo.Tag := -5
      else
        QueueDownGo.Tag := 5;
      
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
  Y, I, A: integer;

  Picture: TJpegImage;
  BackColor, ItemColor, ActiveItemColor,
  FontColor, ActiveFontColor: TColor;

  ItemToDraw: TDrawableItem;
begin
  with QueueDraw.Canvas do
    begin
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
          TextRect( ARect, S, [tfBottom, tfCenter]);

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
      FontColor := clWhite;
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
                    1: S := Albums[GetAlbum(Tracks[ItemToDraw.Index].AlbumID)].AlbumName;
                    2: S := Artists[GetArtist(Tracks[ItemToDraw.Index].ArtistID)].ArtistName;
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
                  Font.Color := clWhite;
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
                    GDIGraphicRound(Picture, ARect, QListRadius);
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
            0: S := 'Title' + IndexHover.ToString;
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

procedure TUIForm.PlaySong(Index: cardinal);
begin
  // Play State
  PlayID := Tracks[Index].ID;
  PlayIndex := Index;

  // Play
  Player.OpenURL( STREAMING_ENDPOINT + Tracks[Index].StreamLocations );

  // Song Info
  Song_Name.Caption := Tracks[Index].Title;
  Song_Artist.Caption := Tracks[Index].Title;
  Song_Cover.Picture.Assign( Tracks[Index].GetArtwork() );

  // Player
  Player_Position.Max := Player.Duration;
  Track_Time.Enabled := true;

  // Data
  Player.Play;

  // UI
  Song_Player.Show;

  Taskbar1.ToolTip := '🎵' + Tracks[Index].Title + ' - ' + Artists[GetArtist(Tracks[Index].ArtistID)].ArtistName;

  // Update
  StatusChanged;
  UpdateMiniPlayer;
end;

procedure TUIForm.PrepareForLogin;
begin
  HideAllUI;

  LoginFailed.Hide;
  LoginUIContainer.Show;
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
  Index := Length(PageHistory) - 2;
  if Index > 0 then
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

procedure TUIForm.QueueSetTo(Index: integer);
begin
  if (QueuePos >= 0) and (QueuePos < PlayQueue.Count) and (QueuePos <> Index) then
    begin
      QueuePos := Index;

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

          Setting_Graph.Checked := OPT.ReadBool('GeneralSettins', 'Enable Graph', true);
          Setting_GraphChange(Setting_Graph, Setting_Graph.State);
          SplitView1.Opened := OPT.ReadBool('GeneralSettins', 'Menu Opened', true);

          TransparentIndex := OPT.ReadInteger('MiniPlayer', 'Opacity', 0);
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

        OPT.WriteBool('GeneralSettins', 'Enable Graph', Setting_Graph.Checked);
        OPT.WriteBool('GeneralSettins', 'Menu Opened', SplitView1.Opened);

        OPT.WriteInteger('MiniPlayer', 'Opacity', TransparentIndex);
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
  Inc(QueueAnProgress, 5);

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
    end;

  if ActiveDraw <> nil then
    ActiveDraw.Repaint;
end;

procedure TUIForm.ReloadLibrary;
begin
  // Get Data
  LoadLibrary;

  // UI
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
end;

procedure TUIForm.ReselectPage;
var
  ViewC, ViewSC: boolean;
  I: Integer;
begin
 // View compatability
  ViewC := InArray( AnsiLowerCase(LocationROOT), ViewCompatibile) <> -1;
  ViewSC := InArray(BareRoot, SubViewCompatibile) <> -1;
  
  // Hide all
  for I := 0 to PagesHolder.ControlCount - 1 do
    if PagesHolder.Controls[I] is TPanel then
      TPanel(PagesHolder.Controls[I]).Hide;

  // Other panels
  EnabledSorts := [];
  ViewModeToggle.Visible := ViewC;
  SearchToggle.Visible := ViewSC or ViewC;
  if SearchToggle.Visible then
    SearchToggle.Left := 0;

  if ViewSC then
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
  TScrollBox(Sender).VertScrollBar.Position := TScrollBox(Sender).VertScrollBar.Position - WheelDelta div 8;
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

      Scrollbar_1.Max := ScrollPosition.Max;
      Scrollbar_2.Max := ScrollPosition.Max;
      Scrollbar_3.Max := ScrollPosition.Max;
      Scrollbar_4.Max := ScrollPosition.Max;

      Scrollbar_1.Position := TScrollBar(Sender).Position;
      Scrollbar_2.Position := TScrollBar(Sender).Position;
      Scrollbar_3.Position := TScrollBar(Sender).Position;
      Scrollbar_4.Position := TScrollBar(Sender).Position;
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
      ExtraSpacing := round((AWidth - FitX * (CoverWidth + CoverSpacing)) / FitX);

      // Sources
      AllowedSources := [TDataSource.Tracks, TDataSource.Albums, TDataSource.Artists, TDataSource.Playlists];
      
      // Found Count
      FoundCount := 0;
      for I := 0 to High(DrawItems) do
        if not DrawItems[I].Hidden then
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
            DrawItemCanvas(SearchDraw.Canvas, ARect, DrawItems[I].Title, DrawItems[I].InfoShort, DrawItems[I].GetPicture, DrawItems[I].Active);

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
end;

procedure TUIForm.SetSort(Mode: TSortType);
begin
  ListSort := Mode;

  // Sort
  Sort;
end;

procedure TUIForm.Setting_GraphChange(Sender: CCheckBox; State: TCheckBoxState);
begin
  Button_Performance.Visible := State = cbChecked;
  Button_Performance.Left := Button_Volume.Left + Button_Performance.Width;
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

  SortModeToggle.Visible := EnabledSorts <> [];
  if SortModeToggle.Visible then
    SortModeToggle.Left := ViewModeToggle.Left - SortModeToggle.Left;

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

procedure TUIForm.SplitView1Resize(Sender: TObject);
begin
  TitlebarCompare.Width := TSplitView(Sender).Width;
end;

procedure TUIForm.StatLoginScreen;
begin
  HideAllUI;
end;

procedure TUIForm.StatusChanged;
var
  I: Integer;
begin
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
  if (Player.Duration = Player.Position) and (PlayIndex <> -1) then
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
  RandIndex: integer;
begin
  if Value then
    // Shuffle
    begin
      PlayQueueOriginal := TIntegerList.Create;
      for I := 0 to PlayQueue.Count - 1 do
        PlayQueueOriginal.Add( PlayQueue[I] );

      // Shuffle previous
      for I := 0 to QueuePos-1 do
        begin
          RandIndex := Random(QueuePos);
          PlayQueue.Move(I, RandIndex);
        end;

      // Shuffle next
      for I := QueuePos+1 to PlayQueue.Count - 1 do
        begin
          RandIndex := RandomRange(QueuePos+1, PlayQueue.Count);
          PlayQueue.Move(I, RandIndex);
        end;

      // Repos
      Self.RecalculateQueuePos;

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

procedure TUIForm.UpdateMiniPlayer;
begin
  if (MiniPlayer <> nil) and MiniPlayer.Visible then
    with MiniPlayer do
      begin
        Mini_Song.Caption := Song_Name.Caption;
        Mini_Artist.Caption := Song_Artist.Caption;

        if Song_Cover.Picture <> nil then
          Mini_Cover.Picture := Song_Cover.Picture;

         Mini_Seek.Max := UIForm.Player_Position.Max;
      end;
end;

procedure TUIForm.WebSyncTimer(Sender: TObject);
begin
  if True then

end;

{ TDrawableItem }

procedure TDrawableItem.Execute;
var
  I: integer;
  AName: string;
begin
  case Source of
    TDataSource.Tracks: begin
      if (IndexHoverID <> PlayIndex) or (Player.PlayStatus <> psPlaying) then
        begin
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

          UIForm.Page_Title.Caption := Name;
        end;

      (* Navigate *)
      UIForm.NavigatePath('ViewPlaylist:' + Playlists[Index].ID.ToString);
      UIForm.Page_Title.Caption := AName;
    end;
  end;
end;

function TDrawableItem.GetPicture: TJPEGImage;
begin
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
      Information[4] := 'Artist: ' + Artists[GetArtist(Tracks[Index].ArtistID)].ArtistName;
      Information[5] := 'Album: ' + Albums[GetAlbum(Tracks[Index].AlbumID)].AlbumName;
      Information[6] := 'Uploaded on: ' + DateToStr( Tracks[Index].DayUploaded );
      Information[7] := 'File Size: ' + SizeInString( Tracks[Index].FileSize );
      Information[8] := 'Rating: ' + Tracks[Index].Rating.ToString + '/10';
      Information[9] := 'Media Type: ' + Tracks[Index].AudioType;

      // Default Info
      InfoShort := Artists[GetArtist(Tracks[Index].ArtistID)].ArtistName + ' • ' + Yearify(Tracks[Index].Year);
      InfoLong := Information[1] + ', ' + Information[4] + ', ' +
        Information[3] + ', ' + Information[5] + ', ' + Information[8];
    end;

    TDataSource.Albums: begin
      ItemID := Albums[Index].ID;

      Title := Albums[Index].AlbumName;

      // Info
      SetLength(Information, 5);
      Information[0] := 'Total Tracks: ' + Length(Albums[Index].TracksID).ToString;
      Information[1] := 'Released in: ' + Yearify(Albums[Index].Year);
      Temp := GetArtist(Albums[Index].ArtistID);
      if Temp <> -1 then
        Information[2] := 'Artist: ' + Artists[Temp].ArtistName
          else
            Information[2] := 'Unknown Artist';
      Information[3] := 'Rating: ' + Albums[Index].Rating.ToString;
      Information[4] := 'Disk: ' + Albums[Index].Disk.ToString;

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
      Song_Name.Caption := Title;
      Song_Info.Caption := GetPremadeInfoList;

      Song_Cover.Picture.Assign( Self.GetPicture );
    end;

  InfoBox.FixUI;
  CenterFormInForm(InfoBox, UIForm, true);
end;

procedure TDrawableItem.StartPictureLoad;
var
  ThreadSource: TDataSource;
  ItemIndex: integer;
begin
  // MAX Thread limit
  if TotalThreads > THREAD_MAX then
    Exit;

  // Self Access
  ThreadSource := Source;
  ItemIndex := index;

  with TThread.CreateAnonymousThread(procedure
    begin
      // Thread Count
      Inc(TotalThreads);

      // Get artwork
      case ThreadSource of
        TDataSource.Tracks: Tracks[ItemIndex].GetArtwork();
        TDataSource.Albums: Albums[ItemIndex].GetArtwork();
        TDataSource.Artists: Artists[ItemIndex].GetArtwork();
        TDataSource.Playlists: Playlists[ItemIndex].GetArtwork();
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

end.
