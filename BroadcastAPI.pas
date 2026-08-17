unit BroadcastAPI;

{$SCOPEDENUMS ON}
{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

//{$DEFINE GENRES}
{$DEFINE LOG}

interface
uses
  // Required Units
  SysUtils, Classes, Graphics, Generics.Collections,
  IdHTTP, IdGlobal, IdSSLOpenSSL, IdURI, DateUtils, Forms,
  {$IFDEF FPC}fpjson, {$ELSE}Imaging.jpeg,{$ENDIF}
  Cod.Types, Cod.Files, Cod.ArrayHelpers, Cod.JSON, Cod.JSON.Utils,
  Cod.Version, UnitInfo
  {$IFDEF FPC}, Cod.Platform.Lazarus{$ELSE}, IOUtils{$ENDIF};

type
  // Cardinals
  TArtSize = (Small, Medium, Large);
  TWorkItem = (DownloadingImage);
  TWorkItems = set of TWorkItem;

  // Source
  TDataSource = (None, Tracks, Albums, Artists, Playlists{$IFDEF GENRES}, Genres{$ENDIF});
  TDataSources = set of TDataSource;

  // Loading
  TLoad = (Track, Album, Artist, PlayList);
  TLoadSet = set of TLoad;

  // Flags
  TAPIOperationFlag = (ConnectionFailed, TokenRefreshed);
  TAPIOperationFlags = set of TAPIOperationFlag;

const
  LOAD_SET_ALL = [Low(TLoad)..High(TLoad)];
type
  // Procs
  TDataTypeUpdate = procedure(AUpdate: TDataSource) of object;

  { TCollageMaker }
  TCollageMaker = class
  private
    TempResult: TJPEGImage;

    procedure Build;
  public
    Image1,
    Image2,
    Image3,
    Image4: TJPEGImage;

    function Make: TJPEGImage;
  end;

  { TSaveArtClass }

  TSaveArtClass = class
  private
    procedure SaveFile;
  public
    Image: TJPEGImage;
    FilePath: string;

    procedure Save;
  end;

  // Records
  TTrackHistoryItem = record
    TrackID: string;
    TimeStamp: TDateTime;
  end;

  TLibraryStatus = record
    TotalTracks: integer;
    TotalPlays: integer;

    TokenExpireDate: TDateTime;
    LastLibraryModified: TDateTime;
    UpdateTimestamp: TDateTime;

    (* Loading *)
    procedure LoadFrom(AObj: IJObject);
  end;

  TAccount = record
    Username: string;
    OneQueue: boolean;
    BitRate: string;

    UserID: string;
    CreationDate: TDateTime;

    Verified: boolean;
    BetaTester: boolean;

    EmailAdress: string;
    Premium: boolean;
    VerificationDate: TDateTime;

    (* Loading *)
    procedure LoadFrom(AObj: IJObject);
  end;

  { TTrackItem }

  TTrackItem = record
    (* Song properties in their JSON order, "?" is a unknown property *)
    ID: string;

    TrackNumber: cardinal;

    Year: cardinal;
    Title: string;

    Genre: string;

    LengthSeconds: cardinal;
    AlbumID: string;
    ArtworkID: string;
    ArtistID: string;

    // ??? Some ID integer
    DayUploaded: TDate;
    IsInTrash: boolean;
    FileSize: integer;

    UploadLocation: string;
    // ??? empty string

    Rating: cardinal;
    Plays: cardinal;

    StreamLocations: string;
    AudioType: string;

    ReplayGain: string;
    UploadTime: TTime;
    // ??? Tag Array

    // Extra Data
    CachedImage,
    CachedImageLarge: TJpegImage;
    Status: TWorkItems;

    (* Utils *)
    function GetStreamingURL: string;

    (* Artwork *)
    function ArtworkLoaded(Large: boolean = false): boolean;
    function GetArtwork(Large: boolean = false): TJPEGImage;

    (* Loading *)
    procedure LoadFrom(Key: string; AArr: IJArray);
  end;

  TAlbumItem = record
    (* Album properties in their JSON order, "?" is a unknown property *)
    ID: string;

    AlbumName: string;

    TracksID: TArray<string>;
    ArtistID: string;

    IsInTrash: boolean;

    Rating: cardinal;
    Disk: cardinal;
    Year: cardinal;

    // ??? - Artist_aditional
    // ??? - ICatID

    CachedImage: TJpegImage;
    Status: TWorkItems;

    (* Artwork *)
    function ArtworkLoaded: boolean;
    function GetArtwork: TJPEGImage;

    (* Loading *)
    procedure LoadFrom(Key: string; AArr: IJArray);
  end;

  { TArtistItem }

  TArtistItem = record
    (* Album properties in their JSON order, "?" is a unknown property *)
    ID: string;

    ArtistName: string;

    TracksID: TArray<string>;
    IsInTrash: boolean;

    Rating: cardinal;
    ArtworkID: string;

    // ??? - ICatID

    // Extra Data
    CachedImage,
    CachedImageLarge: TJpegImage;
    Status: TWorkItems;

    (* Artwork *)
    function HasArtwork: boolean;
    function ArtworkLoaded(Large: boolean = false): boolean;
    function GetArtwork(Large: boolean = false): TJPEGImage;

    (* Loading *)
    procedure LoadFrom(Key: string; AArr: IJArray);
  end;

  { TPlaylistItem }

  TPlaylistItem = record
    (* Album properties in their JSON order, "?" is a unknown property *)
    ID: string;

    Name: string;

    TracksID: TArray<string>;
    // ??? UID
    // ??? system_created
    // ??? public_id

    PlaylistType: string;

    Description: string;
    ArtworkID: string;
    // ??? SortType

    // Extra Data
    CachedImage,
    CachedImageLarge: TJpegImage;
    Status: TWorkItems;

    (* Artwork *)          
    function HasArtwork: boolean;
    function ArtworkLoaded(Large: boolean = false): boolean;
    function GetArtwork(Large: boolean = false): TJPEGImage;

    (* Loading *)
    procedure LoadFrom(Key: string; AArr: IJArray);
  end;

  { TGenreItem }
  {$IFDEF GENRES}
  TGenreItem = record
    (* Album properties in their JSON order, "?" is a unknown property *)
    ID: string;

    TracksID: TStringArray;

    CachedImage: TJpegImage;
    Status: TWorkItems;

    (* Artwork *)
    function ArtworkLoaded: boolean;
    function GetArtwork: TJPEGImage;
  end;
  {$ENDIF}

  // Arrays
  TArtists = TArray<TArtistItem>;
  TAlbums = TArray<TAlbumItem>;
  TTracks = TArray<TTrackItem>;
  TPlaylists = TArray<TPlaylistItem>;
  {$IFDEF GENRES}
  TGenres = TArray<TGenreItem>;
  {$ENDIF}

// Get Data
function GetTrack(ID: string): integer;
function GetAlbum(ID: string): integer;
function GetArtist(ID: string): integer;
function GetPlaylist(ID: string): integer;
{$IFDEF GENRES}
function GetGenre(ID: string): integer;
{$ENDIF}

function GetData(ID: string; Source: TDataSource): integer;
function GetItemID(Index: integer; Source: TDataSource): string;

function GetPlaylistOfType(AType: string): integer; (* thumbsup, recently-played, recently-uploaded *)

// Utils
function StringToDateTime(const ADateTimeStr: string; CovertUTC: boolean = true): TDateTime;
function StringToTime(const ADateTimeStr: string; CovertUTC: boolean = true): TTime;
function DateTimeToString(ADateTime: TDateTime; CovertUTC: boolean = true): string;
function DateToString(ADateTime: TDate; CovertUTC: boolean = true): string;
function Yearify(Year: cardinal): string;

// Memory
procedure APIFreeMemory;

// Artwork Store
procedure AddToArtworkStore(ID: string; Cache: TJpegImage; AType: TDataSource);
function ExistsInStore(ID: string; AType: TDataSource): boolean;
function GetArtStoreCachePath(ID: string; Extension: string; AType: TDataSource): string;
function GetArtStoreCache(ID: string; AType: TDataSource): TJpegImage;
function GetArtworkStore(AType: TDataSource = TDataSource.None): string;
procedure ClearArtworkStore;
procedure InitiateArtworkStore;

// Tracks
function UpdateTrackRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;
function GetSongPlaylists(ID: string): TArray<string>;

function TrackRatingToLikedPlaylist(const HTTP: TIdHTTP; ID: string): boolean;

// Rating
function RatingToString(Rating: integer): string;

// Albums
function UpdateAlbumRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;

// Artists
function UpdateArtistRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;

// Playlist
function CreateNewPlayList(const HTTP: TIdHTTP; Name, Description: string; MakePublic: boolean; Tracks: TArray<string>): boolean; overload;
function AppentToPlaylist(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
function PrependToPlaylist(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
function ChangePlayList(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
function DeleteFromPlaylist(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
function TouchupPlaylist(const HTTP: TIdHTTP; ID: string): boolean;
function UpdatePlayList(const HTTP: TIdHTTP; ID: string; Name, Description: string; ReloadLibrary: boolean): boolean;
function DeletePlayList(const HTTP: TIdHTTP; ID: string): boolean;
{$IFDEF GENRES}
function DeleteGenre(const HTTP: TIdHTTP; ID: string): boolean;
{$ENDIF}
function DeleteTracks(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
function DeleteAlbum(const HTTP: TIdHTTP; ID: string): boolean;
function DeleteArtist(const HTTP: TIdHTTP; ID: string): boolean;
function RestoreTracks(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
function RestoreAlbum(const HTTP: TIdHTTP; ID: string): boolean;
function RestoreArtist(const HTTP: TIdHTTP; ID: string): boolean;
function EmptyTrash(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
function CompleteEmptyTrash(const HTTP: TIdHTTP): boolean;

// History
function PushHistory(const HTTP: TIdHTTP; Items: TArray<TTrackHistoryItem>): boolean;

// Library
function LoadStatus(const HTTP: TIdHTTP): boolean;
function LoadLibrary(const HTTP: TIdHTTP; LoadSet: TLoadSet=LOAD_SET_ALL): boolean;
{$IFDEF GENRES}
procedure LoadLibraryGenres;
{$ENDIF}
procedure EmptyLibrary;

// Additional Data
function GetSongArtwork(ID: string; Size: TArtSize = TArtSize.Small): TJpegImage;
function SongArtCollage(ID1, ID2, ID3, ID4: string): TJpegImage;

// Status
procedure SetWorkStatus(Status: string);
procedure SetDataWorkStatus(Status: string);

procedure ResetWork;

// Utils
function CalculateLength(Seconds: cardinal): string;

///  V2
// Builders
function V2_CreateHTTP: TIdHTTP;
function V2_GetBody: IJObject;

// Requests
function V2_RequestPost(const HTTP: TIdHTTP; const Body: IJValue; const Endpoint: string; const Authorization: string=''): IJValue; overload;
function V2_RequestPost(const HTTP: TIdHTTP; const Body: TStringList; const Endpoint: string; const Authorization: string=''): IJValue; overload;

///  Actions
// Login
function V2_Login_AuthorizeURL(const State: string; const ACodeChallange: string): string;
function V2_Login_Token_GetFromCode(const HTTP: TIdHTTP; const ACode: string; const ACodeVerifier: string): boolean;
function V2_Login_Token_Refresh(const HTTP: TIdHTTP): boolean;
function V2_Login_Token_Revoke(const HTTP: TIdHTTP): boolean;

// Login - processer & modifier
function V2_Login_LoggedIn(const HTTP: TIdHTTP; out Flags: TAPIOperationFlags): boolean;

const
  // Formattable Strings
  DEVICE_NAME_CONST = '%S' + ' iBroadcast for Windows';
  WELCOME_STRING = 'Welcome, %S';
  WELCOME_STRING_SPECIAL = 'Happy holidays, %S';

  // App
  APP_NAME = 'Cod''s iBroadcast';
  APP_VERSION: TVersion = (Major:APP_VERSION_MAJOR; Minor:APP_VERSION_MINOR; Maintenance: APP_VERSION_MAINTENANCE; Build: 0);

  APP_USERMODELID = 'com.codrutsoft.ibroadcast';
  APP_IDENTIFIER = APP_USERMODELID;
  APP_DESCRIPTION = 'Codrut'#39's iBroadcast for Windows';

  APP_USERAGENT = APP_NAME+'/%s';

  // Endpoints
  ENDPOINT_API = 'https://api.ibroadcast.com/';
  ENDPOINT_API_LIBRARY = 'https://library.ibroadcast.com/';
  ENDPOINT_ARTWORK = 'https://artwork.ibroadcast.com/artwork/%S-%U';
  ENDPOINT_STREAMING = 'https://streaming.ibroadcast.com';

  // OAuth2
  OAUTH2_CLIENT_ID = '9ad81c4a98db11f1b50eb49691aa2236';
  OAUTH2_CLIENT_SECRET = '6ef778c35907804c3babcd3f98e5f4c1d38301de50efbfc6fbd403c82bb99a06';
  OAUTH2_REDIRECT_URI = 'http://127.0.0.1:49321/';
  OAUTH2_SCOPE = 'user.account:read user.devices:read user.library:read user.library:write';
  OAUTH2_LISTEN_PORT: word = 49321;

  // Artwork Store
  ART_EXT = '.jpeg';

var
  // App Device token
  LOGIN_TOKEN: string;

  // Auth
  OAuth2_RefreshToken: string;
  OAuth2_AccessToken: string;
  OAuth2_Expiry: TDateTime;

  // Notify
  OnWorkStatusChange: procedure(Status: string);
  OnDataWorkStatusChange: procedure(Status: string);

  // Cover Settings
  DefaultArtSize: TArtSize = TArtSize.Medium;

  // Login Information
  DEVICE_NAME: string;

  // Verbose Loggins
  WORK_STATUS: string;
  DATA_WORK_STATUS: string;

  // Work
  WorkCount: int64;
  TotalWorkCount: int64;

  // Setings
  ValueRatingMode: boolean = false; // use rating stars
  AllowArtCollage: boolean = true; { Bug fixed, error is no more }

  // Notify Events
  OnUpdateType: TDataTypeUpdate;

  // Artwork Store
  ArtworkStore: boolean = true;
  MediaStoreLocation: string;

  // Library
  LibraryStatus: TLibraryStatus;
  Account: TAccount;

  Tracks: TTracks;
  Albums: TAlbums;
  Artists: TArtists;
  Playlists: TPlaylists;
  {$IFDEF GENRES}
  Genres: TGenres;
  {$ENDIF}

  DefaultPicture: TJPEGImage;

  // Debug & logs
  EnableLogging: boolean = false;
  DebugMode: boolean;

var
  V2_HTTP: TIdHTTP;

implementation

uses
  MainUI;

function V2_CreateHTTP: TIdHTTP;
var
  V2_SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := TIdHTTP.Create(nil);

  // Init SSL
  V2_SSL := TIdSSLIOHandlerSocketOpenSSL.Create(Result);
  V2_SSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
  Result.IOHandler := V2_SSL;
end;

function V2_GetBody: IJObject;
begin
  Result := TJObject.CreateNew;
  Result.Put('client', APP_IDENTIFIER);
  Result.Put('version', APP_VERSION.ToString);
  Result.Put('device_name', APP_NAME);
  Result.Put('user_agent', Format(APP_USERAGENT, [APP_VERSION.ToString]));
end;

function V2_RequestPost(const HTTP: TIdHTTP; const Body: IJValue; const Endpoint: string; const Authorization: string): IJValue;
var
  ResponseStream, RequestStream: TStringStream;
begin
  Result := nil;

  // Set options
  HTTP.HTTPOptions := HTTP.HTTPOptions + [hoNoProtocolErrorException, hoWantProtocolErrorContent, hoWaitForUnexpectedData];

  // Set headers
  HTTP.Request.CustomHeaders.Clear;

  if Body <> nil then
    HTTP.Request.ContentType := 'application/json; charset=utf-8';

  if Authorization <> '' then
    HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Authorization);

  // Send request and receive response
  RequestStream := TStringStream.Create('', TEncoding.UTF8);
  ResponseStream := TStringStream.Create('', TEncoding.UTF8);
  if Body <> nil then
    RequestStream.WriteString(Body.ToJSON);
  try
    try
      {$IFDEF LOG}if DebugMode then AddToLog('POST: '+Endpoint);{$ENDIF}
      HTTP.Post(Endpoint, RequestStream, ResponseStream);
      {$IFDEF LOG}if DebugMode then AddToLog('HEADERS:'+sLineBreak+string.Join(sLineBreak, HTTP.Request.RawHeaders.ToStringArray));{$ENDIF}
      {$IFDEF LOG}if DebugMode then AddToLog('BODY:'+sLineBreak+RequestStream.DataString);{$ENDIF}

      // Parse response and extract numbers
      if (ResponseStream.Size > 0) and (ResponseStream.DataString <> 'OK') then
        Result := TJValue.ParseJson(ResponseStream.DataString);
      {$IFDEF LOG}if DebugMode then AddToLog('RESPONSE:'+ResponseStream.DataString+sLineBreak+sLineBreak);{$ENDIF}
    except
      on E: Exception do begin
        {$IFDEF LOG}AddToLog(E.ClassName+': '+E.Message);{$ENDIF}
        Exit;
      end;
    end;
  finally
    RequestStream.Free;
    ResponseStream.Free;
  end;
end;

function V2_RequestPost(const HTTP: TIdHTTP; const Body: TStringList; const Endpoint: string; const Authorization: string=''): IJValue; overload;
var
  ResponseStream: TStringStream;
begin
  Result := nil;

  // Set options
  HTTP.HTTPOptions := HTTP.HTTPOptions + [hoNoProtocolErrorException, hoWantProtocolErrorContent, hoWaitForUnexpectedData];

  // Set headers
  HTTP.Request.CustomHeaders.Clear;

  if Body <> nil then
    HTTP.Request.ContentType := 'application/x-www-form-urlencoded; charset=utf-8';

  if Authorization <> '' then
    HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Authorization);

  // Send request and receive response
  ResponseStream := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      {$IFDEF LOG}if DebugMode then AddToLog('POST: '+Endpoint);{$ENDIF}
      HTTP.Post(Endpoint, Body, ResponseStream);
      {$IFDEF LOG}if DebugMode then AddToLog('HEADERS:'+sLineBreak+string.Join(sLineBreak, HTTP.Request.RawHeaders.ToStringArray)); {$ENDIF}
      {$IFDEF LOG}if DebugMode then AddToLog('BODY:'+sLineBreak+Body.Text);{$ENDIF}

      // Parse response and extract numbers
      if (ResponseStream.Size > 0) then begin
        if ResponseStream.DataString = 'OK' then
          Exit( TJNull.CreateNew );
        Result := TJValue.ParseJson(ResponseStream.DataString);
      end;
      {$IFDEF LOG}if DebugMode then AddToLog('RESPONSE:'+ResponseStream.DataString+sLineBreak+sLineBreak);{$ENDIF}
    except
      on E: Exception do begin
        {$IFDEF LOG}AddToLog(E.ClassName+': '+E.Message);{$ENDIF}
        Exit;
      end;
    end;
  finally
    ResponseStream.Free;
  end;
end;

function V2_Login_AuthorizeURL(const State: string; const ACodeChallange: string): string;
begin
  Result :=
    'https://oauth.ibroadcast.com/authorize?' +
    'client_id=' + TIdURI.ParamsEncode(OAUTH2_CLIENT_ID) +
    '&state=' + TIdURI.ParamsEncode(State) +
    '&response_type=' + TIdURI.ParamsEncode('code') +
    '&code_challenge=' + TIdURI.ParamsEncode(ACodeChallange) +
    '&code_challenge_method=S256' +
    '&scope=' + TIdURI.ParamsEncode(OAUTH2_SCOPE);
end;

function V2_Login_Token_GetFromCode(const HTTP: TIdHTTP; const ACode: string; const ACodeVerifier: string): boolean;
var
  Params: TStringList;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;
  //
  Params := TStringList.Create;
  try
    Params.Add('grant_type=authorization_code');
    Params.Add('code=' + ACode);
    Params.Add('client_id=' + OAUTH2_CLIENT_ID);
    Params.Add('redirect_uri=' + OAUTH2_REDIRECT_URI);
    Params.Add('code_verifier=' + ACodeVerifier);

    // Send
    Response := V2_RequestPost(HTTP, Params,'https://oauth.ibroadcast.com/token');
  finally
    Params.Free;
  end;

  //
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  if not (Obj.KeyExists('access_token') and Obj.KeyExists('expires_in') and Obj.KeyExists('refresh_token')) then
    Exit;

  //
  OAuth2_RefreshToken := Obj['refresh_token'].AsString;
  OAuth2_AccessToken := Obj['access_token'].AsString;
  OAuth2_Expiry := IncSecond(Now, Obj['expires_in'].AsInteger);

  //
  Result := true;
end;

function V2_Login_Token_Refresh(const HTTP: TIdHTTP): boolean;
var
  Params: TStringList;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;
  //
  Params := TStringList.Create;
  try
    Params.Add('grant_type=refresh_token');
    Params.Add('refresh_token=' + OAuth2_RefreshToken);
    Params.Add('client_id=' + OAUTH2_CLIENT_ID);
    Params.Add('redirect_uri=' + OAUTH2_REDIRECT_URI);

    // Send
    Response := V2_RequestPost(HTTP, Params,'https://oauth.ibroadcast.com/token');
  finally
    Params.Free;
  end;

  //
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  if not (Obj.KeyExists('access_token') and Obj.KeyExists('expires_in') and Obj.KeyExists('refresh_token')) then
    Exit;

  //
  OAuth2_RefreshToken := Obj['refresh_token'].AsString;
  OAuth2_AccessToken := Obj['access_token'].AsString;
  OAuth2_Expiry := IncSecond(Now, Obj['expires_in'].AsInteger);

  //
  Result := true;
end;

function V2_Login_Token_Revoke(const HTTP: TIdHTTP): boolean;
var
  Params: TStringList;
  Response: IJValue;        
  Obj: IJObject;
begin
  Result := false;
  //
  Params := TStringList.Create;
  try
    Params.Add('refresh_token=' + OAuth2_RefreshToken);
    Params.Add('client_id=' + OAUTH2_CLIENT_ID);

    // Send
    Response := V2_RequestPost(HTTP, Params,'https://oauth.ibroadcast.com/revoke');
  finally
    Params.Free;
  end;

  //
  if Response = nil then
    Exit;
  if Response.IsObject then begin
    Obj := Response.AsObject;
    Result := not Obj.KeyExists('error');
    if not Result then Exit;
  end;
  Result := true;

  OAuth2_RefreshToken := '';
  OAuth2_AccessToken := '';
  OAuth2_Expiry := 0;
end;

function V2_Login_LoggedIn(const HTTP: TIdHTTP; out Flags: TAPIOperationFlags): boolean;
var
  Response: IJValue;
  Body: IJObject;
  Obj: IJObject;

  Succeeded: boolean;
begin
  Result := false;
  Flags := [];

  Body := V2_GetBody;
  Body.Put('mode', 'status');

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  Succeeded := Response <> nil;
  if not Succeeded then
    Flags := Flags + [TAPIOperationFlag.ConnectionFailed];
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;

  // Logged in
  Result := Obj.KeyExists('authenticated') and Obj['authenticated'].AsBoolean;

  // Migrate refresh token (if access token failed, or it expired/expires in the next 30 minutes)
  if OAuth2_RefreshToken <> '' then
    if (Succeeded and not Result)
      or (IncMinute(Now, 30) >= OAuth2_Expiry) then begin
      Result := V2_Login_Token_Refresh(HTTP);

      Flags := Flags + [TAPIOperationFlag.TokenRefreshed];
    end;

  // Clear login on server confirmation
  if Succeeded and not Result then begin
    OAuth2_RefreshToken := '';
    OAuth2_AccessToken := '';
    OAuth2_Expiry := 0;
  end;
end;

procedure APIFreeMemory;
var
  I: Integer;
begin
  for I := 0 to High(Tracks) do
    begin
      if Tracks[I].CachedImage <> nil then
        Tracks[I].CachedImage.Free;
      if Tracks[I].CachedImageLarge <> nil then
        Tracks[I].CachedImageLarge.Free;
    end;
end;

procedure AddToArtworkStore(ID: string; Cache: TJpegImage; AType: TDataSource);
var
  LifeSaver: TSaveArtClass;
begin
  // gud
  LifeSaver := TSaveArtClass.Create;
  try
    LifeSaver.Image := Cache;
    LifeSaver.FilePath:=GetArtStoreCachePath(ID, ART_EXT, AType);

    LifeSaver.Save;
  finally
    LifeSaver.Free;
  end;
end;

function ExistsInStore(ID: string; AType: TDataSource): boolean;
var
  Path: string;
begin
  if not ArtworkStore then
    Exit(false);

  Path := GetArtStoreCachePath(ID, ART_EXT, AType);

  Result := fileexists( Path );
end;

function GetArtStoreCachePath(ID: string; Extension: string; AType: TDataSource
  ): string;
begin
  {$IFDEF GENRES}
  if AType in [TDataSource.Genres] then
      ID := ValidateFileName(ID);
  {$ENDIF}
  Result := GetArtworkStore(AType) + ID + Extension;
end;

function GetArtStoreCache(ID: string; AType: TDataSource): TJpegImage;
var
  Path: string;
begin
  Path := GetArtStoreCachePath(ID, ART_EXT, AType);

  Result := TJpegImage.Create;
  Result.LoadFromFile(Path);
end;

function GetArtworkStore(AType: TDataSource): string;
begin
  Result := IncludeTrailingPathDelimiter(MediaStoreLocation);
  case AType of
    TDataSource.Tracks: Result := Result + 'tracks';
    TDataSource.Albums: Result := Result + 'albums';
    TDataSource.Artists: Result := Result + 'artists';
    TDataSource.Playlists: Result := Result + 'playlists';
    {$IFDEF GENRES}TDataSource.Genres: Result := Result + 'genres';{$ENDIF}
  end;

  Result := IncludeTrailingPathDelimiter(Result);
end;

procedure ClearArtworkStore;
var
  Path: string;
begin
  Path := GetArtworkStore;

  if TDirectory.Exists(Path) then
    TDirectory.Delete(Path, true);
end;

procedure InitiateArtworkStore;
var
  ArtRoot: string;
begin
  if not ArtworkStore then
    Exit;

  ArtRoot := GetArtworkStore;

  if not TDirectory.Exists(ArtRoot) then
    TDirectory.CreateDirectory(ArtRoot);

  TDirectory.CreateDirectory(GetArtworkStore(TDataSource.Tracks));
  TDirectory.CreateDirectory(GetArtworkStore(TDataSource.Albums));
  TDirectory.CreateDirectory(GetArtworkStore(TDataSource.Artists));
  TDirectory.CreateDirectory(GetArtworkStore(TDataSource.Playlists));
  {$IFDEF GENRES}
  TDirectory.CreateDirectory(GetArtworkStore(TDataSource.Genres));
  {$ENDIF}
end;

function UpdateTrackRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;       
  SetWorkStatus('Setting track rating');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'ratetrack');
  Body.Put('track_id', ID);
  Body.Put('rating', Rating);

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  if ReloadLibrary then
    LoadLibrary(HTTP, [TLoad.Track]);
end;

function GetSongPlaylists(ID: string): TArray<string>;
var
  I: Integer;
begin
  // Search
  Result := [];
  for I := 0 to High(Playlists) do

    if TArrayUtils<string>.Contains(ID, Playlists[I].TracksID) then
      Result := Result + [Playlists[I].ID];
end;

function TrackRatingToLikedPlaylist(const HTTP: TIdHTTP; ID: string): boolean;
var
  Index, SongIndex: integer;
  Fav: boolean;
  IsFav: boolean;
begin
  Result := false;

  SongIndex := GetTrack(ID);
  Index := GetPlaylistOfType('thumbsup');

  if (Index <> -1) and (SongIndex <> -1) then
    begin
      Fav := TArrayUtils<string>.Contains(ID, Playlists[Index].TracksID);
      if ValueRatingMode then
        IsFav := Tracks[SongIndex].Rating = 10
      else
        IsFav := Tracks[SongIndex].Rating in [10, 5];

      if IsFav <> Fav then
        begin
          if IsFav then
            Result := PrependToPlaylist(HTTP, Playlists[Index].ID, [ID])
          else
            Result := DeleteFromPlaylist(HTTP, Playlists[Index].ID, [ID]);
        end;
    end;
end;

function RatingToString(Rating: integer): string;
begin
  if ValueRatingMode then
    begin
      if Rating <> 0 then
        Result := Format('%D/%D', [Rating, 10])
      else
        Result := 'Not rated';
    end
  else
    case Rating of
      10, 5: Result := 'Liked';
      1: Result := 'Disliked';
      else Result := 'Not rated';
    end;
end;

function UpdateAlbumRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;       
  SetWorkStatus('Setting album rating');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'ratealbum');
  Body.Put('album_id', ID);
  Body.Put('rating', Rating);

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  if ReloadLibrary then
    LoadLibrary(HTTP, [TLoad.Album]);
end;

function UpdateArtistRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;       
  SetWorkStatus('Setting artist rating');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'rateartist');
  Body.Put('name', ID);
  Body.Put('description', Rating);

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  if ReloadLibrary then
    LoadLibrary(HTTP, [TLoad.Artist]);
end;

function CreateNewPlayList(const HTTP: TIdHTTP; Name, Description: string; MakePublic: boolean; Tracks: TArray<string>): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;       
  SetWorkStatus('Creating playlist');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'createplaylist');
  Body.Put('name', Name);
  Body.Put('description', Description);
  Body.Put('make_public', MakePublic);
  Body.Put('tracks', ArrayToJArray(Tracks));

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function AppentToPlaylist(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  SetWorkStatus('Appending tracks to playlist');
  
  Result := false;
  //
  Body := V2_GetBody;
  Body.Put('mode', 'appendplaylist');
  Body.Put('playlist', ID);
  Body.Put('tracks', ArrayToJArray(Tracks));

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function PrependToPlaylist(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
begin                                                    
  Result := ChangePlayList(HTTP, ID, TArrayUtils<string>.ConcatUnique(Tracks, Playlists[GetPlaylist(ID)].TracksID));
end;

function ChangePlayList(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;
  SetWorkStatus('Modifying playlist');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'updateplaylist');
  Body.Put('playlist', ID);
  Body.Put('tracks', ArrayToJArray(Tracks));

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function DeleteFromPlaylist(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
begin
  Result := ChangePlaylist(HTTP, ID, TArrayUtils<string>.Subtract(Playlists[GetPlaylist(ID)].TracksID, Tracks));
end;

function TouchupPlaylist(const HTTP: TIdHTTP; ID: string): boolean;
var
  Tracks: TArray<string>;
  I: integer;
begin
  SetWorkStatus('Repairing playlist');
  
  //
  Tracks := Playlists[GetPlaylist(ID)].TracksID;
  for I := High(Tracks) downto 0 do
    if GetTrack(Tracks[I]) = -1 then
      TArrayUtils<string>.Delete(I, Tracks);
  
  //
  Result := ChangePlayList(HTTP, ID, Tracks);
end;

function UpdatePlayList(const HTTP: TIdHTTP; ID: string; Name, Description: string; ReloadLibrary: boolean): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;       
  SetWorkStatus('Updating playlist');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'updateplaylist');
  Body.Put('playlist', ID);
  Body.Put('name', Name);
  Body.Put('description', Description);

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  if ReloadLibrary then
    LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function DeletePlayList(const HTTP: TIdHTTP; ID: string): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;       
  SetWorkStatus('Deleting playlist');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'deleteplaylist');
  Body.Put('playlist', ID);

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

{$IFDEF GENRES}
function DeleteGenre(const HTTP: TIdHTTP; ID: string): boolean;
var
  Index: integer;
begin
  Result := false;
  Index := GetGenre(ID);

  if Index <> -1 then
    Result := DeleteTracks(HTTP, Genres[Index].TracksID);
end;
{$ENDIF}

function DeleteTracks(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;       
  SetWorkStatus('Deleting tracjs');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'trash');
  Body.Put('tracks', ArrayToJArray(Tracks));

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.Track, TLoad.Album, TLoad.Artist, TLoad.PlayList]);
end;

function RestoreTracks(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;       
  SetWorkStatus('Restoring tracks');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'restore');
  Body.Put('tracks', ArrayToJArray(Tracks));

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.Track, TLoad.Album, TLoad.Artist, TLoad.PlayList]);
end;

function EmptyTrash(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;       
  SetWorkStatus('Restoring tracks');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'empty_trash');
  Body.Put('tracks', ArrayToJArray(Tracks));

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.Track, TLoad.Album, TLoad.Artist, TLoad.PlayList]);
end;

function CompleteEmptyTrash(const HTTP: TIdHTTP): boolean;
var
  ATracks: TArray<string>;
  I: integer;
begin
  ATracks := [];
  for I := 0 to High(Tracks) do
    if Tracks[I].IsInTrash then
      ATracks := ATracks + [Tracks[I].ID];

  // Empty
  Result := EmptyTrash(HTTP, ATracks);
end;

function RestoreAlbum(const HTTP: TIdHTTP; ID: string): boolean;
var
  Index: integer;
begin
  Result := false;
  Index := GetAlbum(ID);

  if Index <> -1 then
    Result := RestoreTracks(HTTP, Albums[Index].TracksID);
end;

function RestoreArtist(const HTTP: TIdHTTP; ID: string): boolean;
var
  Index: integer;
begin
  Result := false;
  Index := GetArtist(ID);

  if Index <> -1 then
    Result := RestoreTracks(HTTP, Artists[Index].TracksID);
end;

function DeleteAlbum(const HTTP: TIdHTTP; ID: string): boolean;
var
  Index: integer;
begin
  Result := false;
  Index := GetAlbum(ID);

  if Index <> -1 then
    Result := DeleteTracks(HTTP, Albums[Index].TracksID);
end;

function DeleteArtist(const HTTP: TIdHTTP; ID: string): boolean;
var
  Index: integer;
begin
  Result := false;
  Index := GetArtist(ID);

  if Index <> -1 then
    Result := DeleteTracks(HTTP, Artists[Index].TracksID);
end;

function PushHistory(const HTTP: TIdHTTP; Items: TArray<TTrackHistoryItem>): boolean;
var
  PlaysMap: TDictionary<string, int64>;
  Day: TDate;

  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;

  CurrentCount: int64;
  I: integer;

  ObjHistory, ObjDetail, ObjTrackEvent: IJObject;
  ArrHistory, ObjTrackEvents: IJArray;
begin
  Result := false;
  SetWorkStatus('Pushing history to server');
  //
  if Length(Items) = 0 then
    Exit;
  //
  Body := V2_GetBody;
  Body.Put('mode', 'status');

  // Calculate Count
  PlaysMap := TDictionary<string, int64>.Create;
  try
    Day := Items[0].Timestamp;
    for I := 0 to High(Items) do
      begin
        if not PlaysMap.TryGetValue(Items[I].TrackID, CurrentCount) then
          CurrentCount := 0;
        Inc(CurrentCount);

        PlaysMap.AddOrSetValue(Items[I].TrackID, CurrentCount);
      end;

    ArrHistory := TJArray.CreateNew;
    begin
      ObjHistory := TJObject.CreateNew;
      begin
        ObjHistory.Put('day', DateToString(Day));
        ObjHistory.Put('plays', DictionaryToJObject(PlaysMap));

        ObjDetail := TJObject.CreateNew;
        begin
          for I := 0 to High(Items) do begin
            ObjTrackEvents := TJArray.CreateNew;
            begin
              ObjTrackEvent := TJObject.CreateNew;
              begin
                ObjTrackEvent.Put('event', 'play');
                ObjTrackEvent.Put('ts', DateTimeToString(Items[I].TimeStamp));
              end;
              //
              ObjTrackEvents.Add(ObjTrackEvent);
            end;
            //
            ObjDetail.Put(Items[I].TrackID, ObjTrackEvents);
          end;
        end;
        //
        Body.Put('detail', ObjDetail);
      end;
      //
      ArrHistory.Add(ObjHistory)
    end;
    //
    Body.Put('history', ArrHistory);
  finally
    PlaysMap.Free;
  end;
  
  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load (load history playlist)
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function LoadStatus(const HTTP: TIdHTTP): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;
begin
  Result := false;
  SetWorkStatus('Contacting iBroadcast API servers...');
  //
  Body := V2_GetBody;
  Body.Put('mode', 'status');

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Load status
  SetWorkStatus('Loading library status...');
  if Obj.KeyExists('status') and Obj['status'].IsObject then
    LibraryStatus.LoadFrom(Obj.Memory['status'].AsObject);

  // Account
  SetWorkStatus('Loading your account...');
  if Obj.KeyExists('user') and Obj['user'].IsObject then
    Account.LoadFrom(Obj.Memory['user'].AsObject);
end;

function LoadLibrary(const HTTP: TIdHTTP; LoadSet: TLoadSet): boolean;
var
  Body: IJObject;
  Response: IJValue;
  Obj: IJObject;

  ObjLibrary, ObjLibItem: IJObject;

  I: integer;
  Key: string;
  Item: IJValue;

  Index: integer;
begin
  Result := false;
  SetWorkStatus('Downloading iBroadcast Library...');
  //
  Body := V2_GetBody;

  Response := V2_RequestPost(HTTP, Body, ENDPOINT_API_LIBRARY, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  Obj := Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Work
  ResetWork;

  // Load library
  SetWorkStatus('Loading library...');

  if not Obj.KeyExists('library') then
    Exit;
  ObjLibrary := Obj.Memory['library'].AsObject;

  // Tracks
  if (TLoad.Track in LoadSet) and ObjLibrary.KeyExists('tracks') then begin
    SetWorkStatus('Loading tracks...');
    ResetWork;
    ObjLibItem := ObjLibrary.Memory['tracks'].AsObject;
    TotalWorkCount := ObjLibItem.AsObject.Count;

    // Enumerate
    Tracks := [];
    for I := 0 to ObjLibItem.Count-1 do begin
      Inc(WorkCount);

      Key := ObjLibItem.GetItemKey(I);
      Item := ObjLibItem.GetMemory(I);

      // Skip
      if (Key = 'map') or not Item.IsArray then
        continue;

      // Add
      Index := Length(Tracks);
      SetLength( Tracks, Index + 1 );

      Tracks[Index].LoadFrom(Key, Item.AsArray);
    end;

    // Updated
    if Assigned(OnUpdateType) then
      OnUpdateType(TDataSource.Tracks);
  end;

  // Albums
  if TLoad.Album in LoadSet then begin
    SetWorkStatus('Loading albums...');
    ResetWork;
    ObjLibItem := ObjLibrary.Memory['albums'].AsObject;
    TotalWorkCount := ObjLibItem.AsObject.Count;

    // Enumerate
    Albums := [];
    for I := 0 to ObjLibItem.Count-1 do begin
      Inc(WorkCount);

      Key := ObjLibItem.GetItemKey(I);
      Item := ObjLibItem.GetMemory(I);

      // Skip
      if (Key = 'map') or not Item.IsArray then
        continue;

      // Add
      Index := Length(Albums);
      SetLength( Albums, Index + 1 );

      Albums[Index].LoadFrom(Key, Item.AsArray);

      // Invalid entry, delete from index
      if Length(Albums[Index].TracksID) = 0 then
        SetLength(Albums, Index);
    end;

    // Updated
    if Assigned(OnUpdateType) then
      OnUpdateType(TDataSource.Albums);
  end;

  // Artists
  if TLoad.Artist in LoadSet then begin
    SetWorkStatus('Loading artists...');
    ResetWork;
    ObjLibItem := ObjLibrary.Memory['artists'].AsObject;
    TotalWorkCount := ObjLibItem.AsObject.Count;

    // Enumerate
    Artists := [];
    for I := 0 to ObjLibItem.Count-1 do begin
      Inc(WorkCount);

      Key := ObjLibItem.GetItemKey(I);
      Item := ObjLibItem.GetMemory(I);

      // Skip
      if (Key = 'map') or not Item.IsArray then
        continue;

      // Add
      Index := Length(Artists);
      SetLength( Artists, Index + 1 );

      Artists[Index].LoadFrom(Key, Item.AsArray);

      // Invalid entry, delete from index
      if Length(Artists[Index].TracksID) = 0 then
        SetLength(Artists, Index);
    end;

    // Updated
    if Assigned(OnUpdateType) then
      OnUpdateType(TDataSource.Artists);
  end;

  // PlayLists
  if TLoad.PlayList in LoadSet then begin
    SetWorkStatus('Loading playlists...');
    ResetWork;
    ObjLibItem := ObjLibrary.Memory['playlists'].AsObject;
    TotalWorkCount := ObjLibItem.AsObject.Count;

    // Enumerate
    Playlists := [];
    for I := 0 to ObjLibItem.Count-1 do begin
      Inc(WorkCount);

      Key := ObjLibItem.GetItemKey(I);
      Item := ObjLibItem.GetMemory(I);

      // Skip
      if (Key = 'map') or not Item.IsArray then
        continue;

      // Add
      Index := Length(PlayLists);
      SetLength( PlayLists, Index + 1 );

      PlayLists[Index].LoadFrom(Key, Item.AsArray);
    end;

    // Updated
    if Assigned(OnUpdateType) then
      OnUpdateType(TDataSource.Playlists);
  end;

  // Genres
  {$IFDEF GENRES}
  if TLoad.Track in LoadSet then
     LoadLibraryGenres;
  {$ENDIF}

  //
  ResetWork;
end;

{$IFDEF GENRES}
procedure LoadLibraryGenres;
var
  Name: string;
  Index, I: integer;
begin
  // Parse from tracks
  Genres := [];

  for I := 0 to High(Tracks) do
    begin
      // Get name
      Name := Tracks[I].Genre;

      // Add to index
      Index := GetGenre(Name);
      if Index <> -1 then
        begin
          Genres[Index].TracksID := Genres[Index].TracksID + [Tracks[I].ID];
          continue;
        end;

      // Add new
      Index := Length(Genres);
      SetLength(Genres, Index+1);
      with Genres[Index] do
        begin
          ID := Name;
          TracksID := [Tracks[I].ID];
        end;
    end;
end;
{$ENDIF}

procedure EmptyLibrary;
begin
  SetLength(Tracks, 0);
  SetLength(Albums, 0);
  SetLength(Artists, 0);
  SetLength(Playlists, 0);
  {$IFDEF GENRES}
  SetLength(Genres, 0);
  {$ENDIF}
end;

function GetSongArtwork(ID: string; Size: TArtSize): TJpegImage;
var
  URL: string;
  ImageSize: integer;

  IdHTTP: TIdHTTP;
  ResponseStream: TMemoryStream;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  case Size of
    TArtSize.Small: ImageSize := 150;
    TArtSize.Medium: ImageSize := 300;
    else ImageSize := 1000;
  end;

  // Prepare URL
  URL := Format(ENDPOINT_ARTWORK, [ID, ImageSize]);

  // Fetch Image
  IdHTTP := TIdHTTP.Create;
  SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
  try
    SSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    IdHTTP.IOHandler := SSLIOHandler;

    // Create Stream
    ResponseStream := TMemoryStream.Create;
    try
      IdHTTP.Get(URL, ResponseStream);
      ResponseStream.Position := 0;

      // Load Picture
      Result := TJPEGImage.Create;
      Result.LoadFromStream(ResponseStream);
    finally
      // Free Steam
      ResponseStream.Free;
    end;
  finally
    // Free Net
    IdHTTP.Free;
  end;
end;

function SongArtCollage(ID1, ID2, ID3, ID4: string): TJpegImage;
var
  CollageMaker: TCollageMaker;
begin
  CollageMaker := TCollageMaker.Create;
  try
    // Get
    CollageMaker.Image1 := GetSongArtwork( Tracks[GetTrack( ID1 )].ArtworkID, TArtSize.Small );
    CollageMaker.Image2 := GetSongArtwork( Tracks[GetTrack( ID2 )].ArtworkID, TArtSize.Small );
    CollageMaker.Image3 := GetSongArtwork( Tracks[GetTrack( ID3 )].ArtworkID, TArtSize.Small );
    CollageMaker.Image4 := GetSongArtwork( Tracks[GetTrack( ID4 )].ArtworkID, TArtSize.Small );

    // Make
    Result := CollageMaker.Make;
  finally
    (* Free *)
    CollageMaker.Free;
  end;
end;

procedure SetWorkStatus(Status: string);
begin
  WORK_STATUS := Status;

  if Assigned(OnWorkStatusChange) then
    OnWorkStatusChange(Status);
end;

procedure SetDataWorkStatus(Status: string);
begin
  DATA_WORK_STATUS := Status;

  if Assigned(OnDataWorkStatusChange) then
    OnDataWorkStatusChange(Status);
end;

procedure ResetWork;
begin
  WorkCount := 0;
  TotalWorkCount := 0;
end;


function CalculateLength(Seconds: cardinal): string;
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

{ TGenreItem }

{$IFDEF GENRES}
function TGenreItem.ArtworkLoaded: boolean;
begin
  if TWorkItem.DownloadingImage in Status then
    Exit(false);
  Result := (CachedImage <> nil) and (not CachedImage.Empty);
end;

function TGenreItem.GetArtwork: TJPEGImage;
var
  AIndex: integer;
begin
  Status := Status + [TWorkItem.DownloadingImage];

  if (CachedImage = nil) or CachedImage.Empty then
    begin
      if Length(TracksID) > 0 then
        begin
          // Load from Artwork Store
          if ExistsInStore(ID, TDataSource.Albums)  then
            CachedImage := GetArtStoreCache(ID, TDataSource.Genres)
          else
            // Load from server, save to artowork store
            begin
              AIndex := GetTrack( TracksID[0] );
              if AIndex <> -1 then
                begin
                  CachedImage := Tracks[AIndex].GetArtwork();

                  // Save artstore
                  if ArtworkStore then
                    AddToArtworkStore(ID, CachedImage, TDataSource.Genres);
                end
                  else
                    CachedImage := DefaultPicture;
            end;
        end
      else
        CachedImage := DefaultPicture;
    end;

  Result := CachedImage;

  Status := Status - [TWorkItem.DownloadingImage];
end;
{$ENDIF}

{ TSaveArtClass }

procedure TSaveArtClass.SaveFile;
begin
  Image.SaveToFile( FilePath );
end;

procedure TSaveArtClass.Save;
begin
  TThread.Synchronize(TThread.CurrentThread, SaveFile);
end;

{ TCollageMaker }

procedure TCollageMaker.Build;
{$IFNDEF FPC}
var
  B: TBitMap;
{$ENDIF}
begin
  TempResult := TJPEGImage.Create;
  {$IFDEF FPC}
  TempResult.Width := 300;
  TempResult.Height := 300;
  {$ENDIF}

  {$IFNDEF FPC}
  B := TBitMap.Create(300, 300);
  try
  {$ENDIF}
    with {$IFNDEF FPC}B{$ELSE}TempResult{$ENDIF}.Canvas do
      begin
        try
          StretchDraw(Rect(0, 0, 150, 150), Image1);
          Application.ProcessMessages;
        except
        end;
        try
          StretchDraw(Rect(150, 0, 300, 150), Image2);
          Application.ProcessMessages;
        except
        end;
        try
          StretchDraw(Rect(0, 150, 150, 300), Image3);
          Application.ProcessMessages;
        except
        end;
        try
          StretchDraw(Rect(150, 150, 300, 300), Image4);
          Application.ProcessMessages;
        except
        end;
      end;
  {$IFNDEF FPC}
  finally
    TempResult.Assign(B);
    B.Free;
  end;
  {$ENDIF}
end;

function TCollageMaker.Make: TJPEGImage;
begin
  TThread.Synchronize(TThread.CurrentThread, Build);

  Result := TempResult;
end;

function GetTrack(ID: string): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(Tracks) do
    if Tracks[I].ID = ID then
      Exit( I );
end;

function GetAlbum(ID: string): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(Albums) do
    if Albums[I].ID = ID then
      Exit( I );
end;

function GetArtist(ID: string): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(Artists) do
    if Artists[I].ID = ID then
      Exit( I );
end;

function GetPlaylist(ID: string): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(Playlists) do
    if Playlists[I].ID = ID then
      Exit( I );
end;

{$IFDEF GENRES}
function GetGenre(ID: string): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(Genres) do
    if Genres[I].ID = ID then
      Exit( I );
end;
{$ENDIF}

function GetData(ID: string; Source: TDataSource): integer;
begin
  Result := -1;
  case Source of
    TDataSource.Tracks: Exit(GetTrack(ID));
    TDataSource.Albums: Exit(GetAlbum(ID));
    TDataSource.Artists: Exit(GetArtist(ID));
    TDataSource.Playlists: Exit(GetPlaylist(ID));
    {$IFDEF GENRES}TDataSource.Genres: Exit(GetGenre(ID));{$ENDIF}
  end;
end;

function GetItemID(Index: integer; Source: TDataSource): string;
begin
  Result := '';
  if Index <> -1 then
    case Source of
      TDataSource.Tracks: Exit(Tracks[Index].ID);
      TDataSource.Albums: Exit(Albums[Index].ID);
      TDataSource.Artists: Exit(Artists[Index].ID);
      TDataSource.Playlists: Exit(Playlists[Index].ID);
      {$IFDEF GENRES}TDataSource.Genres: Exit(Genres[Index].ID);{$ENDIF}
    end;
end;

function GetPlaylistOfType(AType: string): integer;
var
  I: Integer;
  ListType: string;
begin
  Result := -1;
  for I := 0 to High(Playlists) do
    begin
      ListType := Playlists[I].PlaylistType;
      if ListType = AType then
        Exit( I );
    end;
end;

function StringToDateTime(const ADateTimeStr: string; CovertUTC: boolean = true): TDateTime;
var
  DateTimeFormat: TFormatSettings;
begin                     
  DateTimeFormat := {$IFDEF FPC}DefaultFormatSettings{$ELSE}TFormatSettings.Create{$ENDIF};
  DateTimeFormat.ShortDateFormat := 'yyyy-mm-dd';
  DateTimeFormat.LongDateFormat := 'yyyy-mm-dd';
  DateTimeFormat.LongTimeFormat := 'hh:nn:ss.zzzzzz';
  DateTimeFormat.ShortTimeFormat := 'hh:nn:ss.zzzzzz';
  DateTimeFormat.DateSeparator := '-';
  DateTimeFormat.TimeSeparator := ':';
  Result := StrToDateTime(trim(ADateTimeStr), DateTimeFormat);

  // Unversal Coordinated Time
  if CovertUTC then
    {$IFDEF FPC}
    Result := UniversalTimeToLocal(Result);
    {$ELSE}
    Result := TTimeZone.Local.ToLocalTime(Result);
    {$ENDIF}
end;

function StringToTime(const ADateTimeStr: string; CovertUTC: boolean = true): TTime;
var
  DateTimeFormat: TFormatSettings;
begin                 
  DateTimeFormat := {$IFDEF FPC}DefaultFormatSettings{$ELSE}TFormatSettings.Create{$ENDIF};
  DateTimeFormat.ShortTimeFormat := 'hh:nn:ss';
  DateTimeFormat.LongTimeFormat := 'hh:nn:ss.zzzzzz';
  DateTimeFormat.DateSeparator := '-';
  DateTimeFormat.TimeSeparator:= ':';
  Result := StrToTime(trim(ADateTimeStr), DateTimeFormat);

  // Unversal Coordinated Time
  if CovertUTC then
    {$IFDEF FPC}
    Result := UniversalTimeToLocal(Result);
    {$ELSE}
    Result := TTimeZone.Local.ToLocalTime(Result);
    {$ENDIF}
end;

function DateTimeToString(ADateTime: TDateTime; CovertUTC: boolean = true): string;
var
  DateTimeFormat: TFormatSettings;
begin                 
  DateTimeFormat := {$IFDEF FPC}DefaultFormatSettings{$ELSE}TFormatSettings.Create{$ENDIF};
  DateTimeFormat.ShortDateFormat := 'yyyy-mm-dd';
  DateTimeFormat.LongTimeFormat := 'hh:nn:ss';
  DateTimeFormat.DateSeparator := '-';

  // Unversal Coordinated Time
  if CovertUTC then
    {$IFDEF FPC}
    ADateTime := UniversalTimeToLocal(ADateTime);
    {$ELSE}
    ADateTime := TTimeZone.Local.ToLocalTime(ADateTime);
    {$ENDIF}

  // Convert
  Result := DateTimeToStr(ADateTime, DateTimeFormat);
end;

function DateToString(ADateTime: TDate; CovertUTC: boolean = true): string;
var
  DateTimeFormat: TFormatSettings;
begin                 
  DateTimeFormat := {$IFDEF FPC}DefaultFormatSettings{$ELSE}TFormatSettings.Create{$ENDIF};
  DateTimeFormat.ShortDateFormat := 'yyyy-mm-dd';
  DateTimeFormat.LongTimeFormat := 'hh:nn:ss';
  DateTimeFormat.DateSeparator := '-';

  // Unversal Coordinated Time
  if CovertUTC then
    {$IFDEF FPC}
    ADateTime := UniversalTimeToLocal(ADateTime);
    {$ELSE}
    ADateTime := TTimeZone.Local.ToLocalTime(ADateTime);
    {$ENDIF}

  // Convert
  Result := DateToStr(ADateTime, DateTimeFormat);
end;

function Yearify(Year: cardinal): string;
begin
  if Year = 0 then
    Result := 'Unknown'
  else
    Result := IntToStrIncludePrefixZeros( Year, 4 );
end;

{ TLibraryStatus }

procedure TLibraryStatus.LoadFrom(AObj: IJObject);
begin
  TotalTracks := AObj.Memory['available'].AsInteger;
  TotalPlays := AObj.Memory['plays'].AsInteger;

  TokenExpireDate := StringToDateTime(AObj.Memory['expires'].AsString);
  LastLibraryModified := StringToDateTime(AObj.Memory['lastmodified'].AsString);
  UpdateTimestamp := StringToDateTime(AObj.Memory['timestamp'].AsString);
end;

{ TTrackItem }
function TTrackItem.GetStreamingURL: string;
begin
  Result := ENDPOINT_STREAMING+StreamLocations
    +Format('?Signature=%S&file_id=%S&user_id=%S&platform=%S&version=%S',
    [OAuth2_AccessToken, ID, Account.UserID, APP_IDENTIFIER, APP_VERSION.ToString]);
  (*
    Signature - user token - string
    file_id - song ID - integer
    user_id = user ID - integer
    platform - app name - string
    version - this app version - string
  *)

  // Encode result
  Result := TIdUrI.URLEncode(Result);
end;

function TTrackItem.ArtworkLoaded(Large: boolean): boolean;
begin
  if TWorkItem.DownloadingImage in Status then
    Exit(false);
  if not Large then
    Result := (CachedImage <> nil) and (not CachedImage.Empty)
  else
    Result := (CachedImageLarge <> nil) and (not CachedImageLarge.Empty);
end;

function TTrackItem.GetArtwork(Large: boolean): TJPEGImage;
begin
  Status := Status + [TWorkItem.DownloadingImage];

  if Large then
    begin
      if (CachedImageLarge = nil) or CachedImageLarge.Empty then
        CachedImageLarge := GetSongArtwork(ArtworkID, TArtSize.Large);

      Result := CachedImageLarge;
    end
  else
    begin
      if (CachedImage = nil) or ((CachedImage <> nil) and CachedImage.Empty) then
        begin
          // Load from Artwork Store
          if ExistsInStore(ID, TDataSource.Tracks) then
            CachedImage := GetArtStoreCache(ID, TDataSource.Tracks)
          else
            // Load from server, save to artowork store
            begin
              CachedImage := GetSongArtwork(ArtworkID, DefaultArtSize);

              // Save artstore
              if ArtworkStore then
                AddToArtworkStore(ID, CachedImage, TDataSource.Tracks);
            end;
        end;

      Result := CachedImage;
    end;

  Status := Status - [TWorkItem.DownloadingImage];
end;



procedure TTrackItem.LoadFrom(Key: string; AArr: IJArray);
begin
  ID := Key;
  SetDataWorkStatus(Format('Loading song with ID of %S', [ID]));
  //

  TrackNumber := AArr.Memory[0].AsInteger;
  Year := AArr.Memory[1].AsInteger;

  Title := AArr.Memory[2].AsString;
  Genre := AArr.Memory[3].AsString;

  LengthSeconds := AArr.Memory[4].AsInteger;
  // Typecast as number, then as string for legacy accounts
  AlbumID := AArr.Memory[5].AsString;
  ArtworkID := AArr.Memory[6].AsString;
  ArtistID := AArr.Memory[7].AsString;

  // ?
  DayUploaded := StringToDateTime( AArr.Memory[9].AsString );
  IsInTrash := AArr.Memory[10].AsBoolean;
  FileSize := AArr.Memory[11].AsInteger;

  UploadLocation := AArr.Memory[12].AsString;
  // ?

  Rating := AArr.Memory[14].AsInteger;
  Plays := AArr.Memory[15].AsInteger;

  StreamLocations := AArr.Memory[16].AsString;
  AudioType := AArr.Memory[17].AsString;

  ReplayGain := AArr.Memory[18].AsString;
  try
    UploadTime := StringToDateTime( AArr.Memory[19].AsString );
  except
    UploadTime := 0;
  end;
  // ?
end;

{ TAccount }

procedure TAccount.LoadFrom(AObj: IJObject);
const
  BACKUP_DATE = 44990.0833333333; // 2023-03-05
var
  Obj: IJObject;
begin
  SetDataWorkStatus('Loading account from post request');

  Username := 'User';

  UserID := AObj.Memory['user_id'].AsString;
  if AObj.KeyExists('username') then Username := AObj.Memory['username'].AsString;
  if AObj.KeyExists('email_address') then EmailAdress := AObj.Memory['email_address'].AsString;

  if AObj.KeyExists('preferences') then begin
    Obj := AObj.Memory['preferences'].AsObject;

    if Obj.KeyExists('onequeue') then OneQueue := stringtoboolean(Obj.Memory['onequeue'].AsString);
    if Obj.KeyExists('bitratepref') then BitRate := Obj.Memory['bitratepref'].AsString;
  end;

  if AObj.KeyExists('verified') then Verified := AObj.Memory['verified'].AsBoolean;
  if AObj.KeyExists('tester') then BetaTester := AObj.Memory['tester'].AsBoolean;
  if AObj.KeyExists('premium') then Premium := AObj.Memory['premium'].AsBoolean;

  CreationDate := BACKUP_DATE;
  VerificationDate := BACKUP_DATE;
  try
    if AObj.KeyExists('created_on') and AObj.Memory['created_on'].IsString then
      CreationDate := StringToDateTime(AObj.Memory['created_on'].AsString);
    if AObj.KeyExists('verified_on') and AObj.Memory['verified_on'].IsString then
      VerificationDate := StringToDateTime(AObj.Memory['verified_on'].AsString);
  except
  end;
end;

{ TAlbumItem }

function TAlbumItem.ArtworkLoaded: boolean;
begin
  if TWorkItem.DownloadingImage in Status then
    Exit(false);
  Result := (CachedImage <> nil) and (not CachedImage.Empty);
end;

function TAlbumItem.GetArtwork: TJPEGImage;
var
  AIndex: integer;
begin
  Status := Status + [TWorkItem.DownloadingImage];

  if (CachedImage = nil) or CachedImage.Empty then
    begin
      if Length(TracksID) > 0 then
        begin
          // Load from Artwork Store
          if ExistsInStore(ID, TDataSource.Albums)  then
            CachedImage := GetArtStoreCache(ID, TDataSource.Albums)
          else
            // Load from server, save to artowork store
            begin
              AIndex := GetTrack( TracksID[0] );
              if AIndex <> -1 then
                begin
                  CachedImage := Tracks[AIndex].GetArtwork();

                  // Save artstore
                  if ArtworkStore then
                    AddToArtworkStore(ID, CachedImage, TDataSource.Albums);
                end
                  else
                    CachedImage := DefaultPicture;
            end;
        end
      else
        CachedImage := DefaultPicture;
    end;

  Result := CachedImage;

  Status := Status - [TWorkItem.DownloadingImage];
end;

procedure TAlbumItem.LoadFrom(Key: string; AArr: IJArray);
var
  AID: string;
begin
  ID := Key;
  SetDataWorkStatus(Format('Loading album with ID of %S', [ID]));
  //

  AlbumName := AArr.Memory[0].AsString;

  // TRACKS
  TracksID := [];
  for AID in JArrayToStringArray(AArr.Memory[1]) do begin
    if GetTrack(AID) <> -1 then
      TracksID := TracksID + [AID];
  end;

  // Data 2
  ArtistID := AArr.Memory[2].AsString;

  IsInTrash := AArr.Memory[3].AsBoolean;

  Rating := AArr.Memory[4].AsInteger;
  Disk := AArr.Memory[5].AsInteger;
  Year := AArr.Memory[6].AsInteger;
end;

{ TArtistItem }

function TArtistItem.HasArtwork: boolean;
begin
  Result := ArtworkID <> '';
end;

function TArtistItem.ArtworkLoaded(Large: boolean): boolean;
begin
  if TWorkItem.DownloadingImage in Status then
    Exit(false);
  if not Large then
    Result := (CachedImage <> nil) and (not CachedImage.Empty)
  else
    Result := (CachedImageLarge <> nil) and (not CachedImageLarge.Empty);
end;

function TArtistItem.GetArtwork(Large: boolean): TJPEGImage;
var
  AIndex: integer;
begin
  Status := Status + [TWorkItem.DownloadingImage];

  if Large then
    begin
      if (CachedImageLarge = nil) or CachedImageLarge.Empty then
        CachedImageLarge := GetSongArtwork(ArtworkID, TArtSize.Large);

      Result := CachedImageLarge;
    end
  else
    begin
      if (CachedImage = nil) or CachedImage.Empty then
        begin
          // Load from Artwork Store
          if ExistsInStore(ID, TDataSource.Artists) then
            CachedImage := GetArtStoreCache(ID, TDataSource.Artists)
          else
          // Load from server, save to artowork store
            begin
              if HasArtwork then
                // Get premade
                CachedImage := GetSongArtwork(ArtworkID, DefaultArtSize)
              else
                begin
                  if (Length(TracksID) >= 4) and AllowArtCollage then
                    begin
                      CachedImage := SongArtCollage(TracksID[0], TracksID[1], TracksID[2], TracksID[3]);
                    end
                  else
                    if Length(TracksID) > 0 then
                      begin
                        AIndex := GetTrack( TracksID[0] );
                        if AIndex <> -1 then
                          CachedImage := Tracks[AIndex].GetArtwork()
                        else
                          CachedImage := DefaultPicture;
                      end
                        else
                          CachedImage := DefaultPicture;
                end;

              // Save artstore
              if ArtworkStore and (CachedImage <> DefaultPicture) then
                AddToArtworkStore(ID, CachedImage, TDataSource.Artists);
            end;
        end;

      Result := CachedImage;
  end;

  Status := Status - [TWorkItem.DownloadingImage];
end;

procedure TArtistItem.LoadFrom(Key: string; AArr: IJArray);
var
  AID: string;
begin
  ID := Key;
  SetDataWorkStatus(Format('Loading artist with ID of %S', [ID]));
  //

  ArtistName := AArr.Memory[0].AsString;

  // TRACKS
  TracksID := [];
  for AID in JArrayToStringArray(AArr.Memory[1]) do begin
    if GetTrack(AID) <> -1 then
      TracksID := TracksID + [AID];
  end;

  // Data 2
  IsInTrash := AArr.Memory[2].AsBoolean;
  Rating := AArr.Memory[3].AsInteger;

  ArtworkID := '';
  if (AArr.Count > 4) and AArr[4].IsString then
    ArtworkID := AArr[4].AsString;
end;

{ TPlaylistItem }

function TPlaylistItem.HasArtwork: boolean;
begin
  Result := ArtworkID <> '';
end;

function TPlaylistItem.ArtworkLoaded(Large: boolean): boolean;
begin
  if TWorkItem.DownloadingImage in Status then
    Exit(false);
  if not Large then
    Result := (CachedImage <> nil) and (not CachedImage.Empty)
  else
    Result := (CachedImageLarge <> nil) and (not CachedImageLarge.Empty);
end;

function TPlaylistItem.GetArtwork(Large: boolean): TJPEGImage;
begin
  Status := Status + [TWorkItem.DownloadingImage];

  if Large then begin
      if (CachedImageLarge = nil) or CachedImageLarge.Empty then
        CachedImageLarge := GetSongArtwork(ArtworkID, TArtSize.Large);

      Result := CachedImageLarge;
  end
  else begin
    if (CachedImage = nil) or CachedImage.Empty then
      begin
        if ExistsInStore(ID, TDataSource.Playlists) then
          CachedImage := GetArtStoreCache(ID, TDataSource.Playlists)
        else
          begin
            // Load from Artwork Store
            if HasArtwork then
              // Get premade
              CachedImage := GetSongArtwork(ArtworkID, DefaultArtSize)
            else
              // Load from server, save to artowork store
              begin
                if (Length(TracksID) >= 4) and AllowArtCollage then
                  begin
                    CachedImage := SongArtCollage(TracksID[0], TracksID[1], TracksID[2], TracksID[3]);
                  end
                else
                  if Length(TracksID) > 0 then
                    CachedImage := Tracks[GetTrack( TracksID[0] )].GetArtwork()
                  else
                    CachedImage := DefaultPicture;
              end;

            // Save artstore
            if ArtworkStore and (CachedImage <> DefaultPicture) then
              AddToArtworkStore(ID, CachedImage, TDataSource.Playlists);
          end;
      end;

      Result := CachedImage;
  end;

  Status := Status - [TWorkItem.DownloadingImage];
end;

procedure TPlaylistItem.LoadFrom(Key: string; AArr: IJArray);
var
  AID: string;
begin
  ID := Key;
  SetDataWorkStatus(Format('Loading playlist with ID of %S', [ID]));
  //

  Name := AArr.Memory[0].AsString;

  // TRACKS
  TracksID := [];
  for AID in JArrayToStringArray(AArr.Memory[1]) do begin
    if GetTrack(AID) <> -1 then
      TracksID := TracksID + [AID];
  end;

  // ?
  // ?
  // ?

  // Data 2
  if (AArr.Count > 5) and AArr[5].IsString then
    PlaylistType := AArr[5].AsString;
  if (AArr.Count > 6) and AArr[6].IsString then
    Description := AArr[6].AsString;

  ArtworkID := '';
  if (AArr.Count > 7) and AArr[7].IsString then
    ArtworkID := AArr[7].AsString;

  // ?
end;

initialization
  // Init HTTTP
  V2_HTTP := V2_CreateHTTP;

finalization
  // Free
  V2_HTTP.Free;

end.
