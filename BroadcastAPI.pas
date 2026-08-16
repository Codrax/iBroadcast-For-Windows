unit BroadcastAPI;

{$SCOPEDENUMS ON}

interface
uses
  // Required Units
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, IOUtils, System.Generics.Collections, IdSSLOpenSSL, IdURI,
  IdHTTP, IdGlobal, JSON, Vcl.Clipbrd, DateUtils, Cod.Types, Imaging.jpeg,
  Cod.Helpers, Cod.Helpers.Vcl, Cod.Dialogs, Cod.SysUtils, Cod.Files,
  Cod.ArrayHelpers, Cod.JSON, Cod.JSON.Utils, Cod.Version, Vcl.Dialogs;

type
  // Cardinals
  TArtSize = (Small, Medium, Large);
  TWorkItem = (DownloadingImage);
  TWorkItems = set of TWorkItem;

  // Source
  TDataSource = (None, Tracks, Albums, Artists, Playlists);
  TDataSources = set of TDataSource;

  // Loading
  TLoad = (Track, Album, Artist, PlayList);
  TLoadSet = set of TLoad;

const
  LOAD_SET_ALL = [Low(TLoad)..High(TLoad)];
type
  // Procs
  TDataTypeUpdate = procedure(AUpdate: TDataSource) of object;

  // Records
  THistoryItem = record
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
    CachedImage: TJpegImage;
    Status: TWorkItems;

    (* Artwork *)
    function HasArtwork: boolean;
    function ArtworkLoaded: boolean;
    function GetArtwork: TJPEGImage;

    (* Loading *)
    procedure LoadFrom(Key: string; AArr: IJArray);
  end;

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
    CachedImage: TJpegImage;
    Status: TWorkItems;

    (* Artwork *)
    function HasArtwork: boolean;
    function ArtworkLoaded: boolean;
    function GetArtwork: TJPEGImage;

    (* Loading *)
    procedure LoadFrom(Key: string; AArr: IJArray);
  end;

  // Arrays
  TArtists = TArray<TArtistItem>;
  TAlbums = TArray<TAlbumItem>;
  TTracks = TArray<TTrackItem>;
  TPlaylists = TArray<TPlaylistItem>;

// Get Data
function GetTrack(ID: string): integer;
function GetAlbum(ID: string): integer;
function GetArtist(ID: string): integer;
function GetPlaylist(ID: string): integer;

function GetPlaylistOfType(AType: string): integer; (* thumbsup, recently-played, recently-uploaded *)

// Utils
function StringToDateTime(const ADateTimeStr: string; CovertUTC: boolean = true): TDateTime;
function DateTimeToString(ADateTime: TDateTime; CovertUTC: boolean = true): string;
function DateToString(ADateTime: TDate; CovertUTC: boolean = true): string;
function Yearify(Year: cardinal): string;

// Memory
procedure APIFreeMemory;

// Artwork Store
procedure AddToArtworkStore(ID: string; Cache: TJpegImage; AType: TDataSource);
function ExistsInStore(ID: string; AType: TDataSource): boolean;
function GetArtStoreCache(ID: string; AType: TDataSource): TJpegImage;
function GetArtworkStore(AType: TDataSource = TDataSource.None): string;
procedure ClearArtworkStore;
procedure InitiateArtworkStore;

// Tracks
function UpdateTrackRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;
function GetSongPlaylists(ID: string): TArray<string>;

function TrackRatingToLikedPlaylist(const HTTP: TIdHTTP; ID: string): boolean;

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
function DeleteTracks(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
function DeleteAlbum(const HTTP: TIdHTTP; ID: string): boolean;
function DeleteArtist(const HTTP: TIdHTTP; ID: string): boolean;
function RestoreTracks(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
function RestoreAlbum(const HTTP: TIdHTTP; ID: string): boolean;
function RestoreArtist(const HTTP: TIdHTTP; ID: string): boolean;
function EmptyTrash(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
function CompleteEmptyTrash(const HTTP: TIdHTTP): boolean;

// History
function PushHistory(const HTTP: TIdHTTP; Items: TArray<THistoryItem>): boolean;

// Library
function LoadStatus(const HTTP: TIdHTTP): boolean;
function LoadLibrary(const HTTP: TIdHTTP; LoadSet: TLoadSet=LOAD_SET_ALL): boolean;

// Additional Data
function GetSongArtwork(ID: string; Size: TArtSize = TArtSize.Small): TJpegImage;
function SongArtCollage(ID1, ID2, ID3, ID4: string): TJpegImage;

// Status
procedure SetWorkStatus(Status: string);
procedure SetDataWorkStatus(Status: string);

procedure ResetWork;

///  V2
// Builders
function V2_CreateHTTP: TIdHTTP;
function V2_GetBody: IJObject;

// Requests
//function V2_RequestGet(const HTTP: TIdHTTP; const Endpoint: string; const Authorization: string=''): IJValue;
function V2_RequestPost(const HTTP: TIdHTTP; const Body: IJValue; const Endpoint: string; const Authorization: string=''): IJValue; overload;
function V2_RequestPost(const HTTP: TIdHTTP; const Body: TStringList; const Endpoint: string; const Authorization: string=''): IJValue; overload;

///  Actions
// Login
function V2_Login_AuthorizeURL(const State: string; const ACodeChallange: string): string;
function V2_Login_Token_GetFromCode(const HTTP: TIdHTTP; const ACode: string; const ACodeVerifier: string): boolean;
function V2_Login_Token_Refresh(const HTTP: TIdHTTP): boolean;
function V2_Login_Token_Revoke(const HTTP: TIdHTTP): boolean;

// Login - processer & modifier
function V2_Login_LoggedIn(const HTTP: TIdHTTP; out Succeeded: boolean): boolean;

const
  // Formattable Strings
  DEVICE_NAME_CONST = '%S' + ' iBroadcast for Windows';

  WELCOME_STRING = 'Welcome, %S';
  WELCOME_STRING_SPECIAL = 'Happy holidays, %S';

  // App
  APP_NAME = 'Cod'#39's iBroadcast';
  APP_VERSION: TVersion = (Major:1; Minor:12; Maintenance: 0);

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

  // Notify Events
  OnUpdateType: TDataTypeUpdate;

  // Artwork Store
  ArtworkStore: boolean=true;
  MediaStoreLocation: string;

  // Library
  LibraryStatus: TLibraryStatus;
  Account: TAccount;

  Tracks: TTracks;
  Albums: TAlbums;
  Artists: TArtists;
  Playlists: TPlaylists;

  DefaultPicture: TJPEGImage;

  // Debug & logs
  EnableLogging: boolean = false;
  AllowDebug: boolean;

var
  V2_HTTP: TIdHTTP;

implementation

uses
  MainUI;

function V2_CreateHTTP: TIdHTTP;
begin
  Result := TIdHTTP.Create(nil);

  // Init SSL
  const V2_SSL = TIdSSLIOHandlerSocketOpenSSL.Create(Result);
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

//function V2_RequestGet(const HTTP: TIdHTTP; const Endpoint: string; const Authorization: string=''): IJValue;
//var
//  ResponseStream: TStringStream;
//begin
//  Result := nil;
//
//  // Set options
//  HTTP.HTTPOptions := HTTP.HTTPOptions + [hoNoProtocolErrorException, hoWantProtocolErrorContent, hoWaitForUnexpectedData];
//
//  // Set headers
//  HTTP.Request.CustomHeaders.Clear;
//
//  HTTP.Request.ContentType := 'application/x-www-form-urlencoded';
//
//  if Authorization <> '' then
//    HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Authorization);
//
//  // Send request and receive response
//  ResponseStream := TStringStream.Create('', TEncoding.UTF8);
//  try
//    try
//      if AllowDebug then AddToLog('GET: '+Endpoint);
//      HTTP.Get(Endpoint, ResponseStream);
//
//      // Parse response and extract numbers
//      if (ResponseStream.Size > 0) and (ResponseStream.DataString <> 'OK') then
//        Result := TJValue.ParseJson(ResponseStream.DataString);
//      if AllowDebug then AddToLog(ResponseStream.DataString);
//    except
//      on E: Exception do begin
//        AddToLog(E.ClassName+': '+E.Message);
//        Exit;
//      end;
//    end;
//  finally
//    ResponseStream.Free;
//  end;
//end;

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
      if AllowDebug then AddToLog('POST: '+Endpoint);
      HTTP.Post(Endpoint, RequestStream, ResponseStream);
      if AllowDebug then AddToLog('HEADERS:'+sLineBreak+string.Join(sLineBreak, HTTP.Request.RawHeaders.ToStringArray));
      if AllowDebug then AddToLog('BODY:'+sLineBreak+RequestStream.DataString);

      // Parse response and extract numbers
      if (ResponseStream.Size > 0) and (ResponseStream.DataString <> 'OK') then
        Result := TJValue.ParseJson(ResponseStream.DataString);
      if AllowDebug then AddToLog('RESPONSE:'+ResponseStream.DataString);
    except
      on E: Exception do begin
        AddToLog(E.ClassName+': '+E.Message);
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
      if AllowDebug then AddToLog('POST: '+Endpoint);
      HTTP.Post(Endpoint, Body, ResponseStream);
      if AllowDebug then AddToLog('HEADERS:'+sLineBreak+string.Join(sLineBreak, HTTP.Request.RawHeaders.ToStringArray));
      if AllowDebug then AddToLog('BODY:'+sLineBreak+Body.Text);

      // Parse response and extract numbers
      if (ResponseStream.Size > 0) then begin
        if ResponseStream.DataString = 'OK' then
          Exit( TJNull.CreateNew );
        Result := TJValue.ParseJson(ResponseStream.DataString);
      end;
      if AllowDebug then AddToLog('RESPONSE:'+ResponseStream.DataString);
    except
      on E: Exception do begin
        AddToLog(E.ClassName+': '+E.Message);
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
    '&scope=' + TIdURI.ParamsEncode(
      'user.account:read user.devices:read user.library:read user.library:write'
    );
end;

function V2_Login_Token_GetFromCode(const HTTP: TIdHTTP; const ACode: string; const ACodeVerifier: string): boolean;
var
  Params: TStringList;
  Response: IJValue;
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
  const Obj = Response.AsObject;
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
  const Obj = Response.AsObject;
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
    const Obj = Response.AsObject;
    Result := not Obj.KeyExists('error');
    if not Result then Exit;
  end;
  Result := true;

  OAuth2_RefreshToken := '';
  OAuth2_AccessToken := '';
  OAuth2_Expiry := 0;
end;

function V2_Login_LoggedIn(const HTTP: TIdHTTP; out Succeeded: boolean): boolean;
begin
  Result := false;

  const Body = V2_GetBody;
  Body.Put('mode', 'status');

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  Succeeded := Response <> nil;
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;

  // Logged in
  Result := Obj.KeyExists('authenticated') and Obj['authenticated'].AsBoolean;

  // Migrate refresh token
  if Succeeded and not Result and (OAuth2_RefreshToken <> '') then begin
    Result := V2_Login_Token_Refresh(HTTP);
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
  Path: string;
begin
  Path := GetArtworkStore(AType) + ID + ART_EXT;

  Cache.SaveToFile(Path);
end;

function ExistsInStore(ID: string; AType: TDataSource): boolean;
var
  Path: string;
begin
  if not ArtworkStore then
    Exit(false);

  Path := GetArtworkStore(AType) + ID + ART_EXT;

  Result := TFile.Exists( Path );
end;

function GetArtStoreCache(ID: string; AType: TDataSource): TJpegImage;
var
  Path: string;
begin
  Path := GetArtworkStore(AType) + ID + ART_EXT;

  Result := TJpegImage.Create;
  Result.LoadFromFile(Path);
end;

function GetArtworkStore(AType: TDataSource): string;
begin
  Result := IncludeTrailingPathDelimiter(MediaStoreLocation);
  case AType of
    TDataSource.Tracks: Result := Result + 'Tracks';
    TDataSource.Albums: Result := Result + 'Albums';
    TDataSource.Artists: Result := Result + 'Artists';
    TDataSource.Playlists: Result := Result + 'Playlists';
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
end;

function UpdateTrackRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;
begin
  Result := false;       
  SetWorkStatus('Setting track rating');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'ratetrack');
  Body.Put('track_id', ID);
  Body.Put('rating', Rating);

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
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
    if Playlists[I].TracksID.Find(ID) <> -1 then
      Result.AddValue(Playlists[I].ID);
end;

function TrackRatingToLikedPlaylist(const HTTP: TIdHTTP; ID: string): boolean;
var
  Index, SongIndex: integer;
begin
  Result := false;

  SongIndex := GetTrack(ID);
  Index := GetPlaylistOfType('thumbsup');

  if (Index <> -1) and (SongIndex <> -1) then
    begin
      const Fav = Playlists[Index].TracksID.Find(ID) <> -1;
      var IsFav: boolean;
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

function UpdateAlbumRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;
begin
  Result := false;       
  SetWorkStatus('Setting album rating');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'ratealbum');
  Body.Put('album_id', ID);
  Body.Put('rating', Rating);

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  if ReloadLibrary then
    LoadLibrary(HTTP, [TLoad.Album]);
end;

function UpdateArtistRating(const HTTP: TIdHTTP; ID: string; Rating: integer; ReloadLibrary: boolean): boolean;
begin
  Result := false;       
  SetWorkStatus('Setting artist rating');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'rateartist');
  Body.Put('name', ID);
  Body.Put('description', Rating);

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  if ReloadLibrary then
    LoadLibrary(HTTP, [TLoad.Artist]);
end;

function CreateNewPlayList(const HTTP: TIdHTTP; Name, Description: string; MakePublic: boolean; Tracks: TArray<string>): boolean;
begin
  Result := false;       
  SetWorkStatus('Creating playlist');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'createplaylist');
  Body.Put('name', Name);
  Body.Put('description', Name);
  Body.Put('make_public', MakePublic);
  Body.Put('tracks', ArrayToJArray(Tracks));

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function AppentToPlaylist(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
begin
  SetWorkStatus('Appending tracks to playlist');
  
  Result := false;
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'appendplaylist');
  Body.Put('playlist', ID);
  Body.Put('tracks', ArrayToJArray(Tracks));

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function PrependToPlaylist(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
begin                                                    
  Result := ChangePlayList(HTTP, ID, TArrayUtils<string>.ConcatUnique(Tracks, Playlists[GetPlaylist(ID)].TracksID));
end;

function ChangePlayList(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
begin
  Result := false;
  SetWorkStatus('Modifying playlist');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'updateplaylist');
  Body.Put('playlist', ID);
  Body.Put('tracks', ArrayToJArray(Tracks));

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function DeleteFromPlaylist(const HTTP: TIdHTTP; ID: string; Tracks: TArray<string>): boolean;
begin
  Result := ChangePlaylist(HTTP, ID, TArrayUtils<string>.Subtract(Playlists[GetPlaylist(ID)].TracksID, Tracks));
end;

function TouchupPlaylist(const HTTP: TIdHTTP; ID: string): boolean;
begin
  SetWorkStatus('Repairing playlist');
  
  //
  var Tracks := Playlists[GetPlaylist(ID)].TracksID;
  for var I := High(Tracks) downto 0 do
    if GetTrack(Tracks[I]) = -1 then
      TArrayUtils<string>.Delete(I, Tracks);
  
  //
  Result := ChangePlayList(HTTP, ID, Tracks);
end;

function UpdatePlayList(const HTTP: TIdHTTP; ID: string; Name, Description: string; ReloadLibrary: boolean): boolean;
begin
  Result := false;       
  SetWorkStatus('Updating playlist');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'updateplaylist');
  Body.Put('playlist', ID);
  Body.Put('name', Name);
  Body.Put('description', Description);

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  if ReloadLibrary then
    LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function DeletePlayList(const HTTP: TIdHTTP; ID: string): boolean;
begin
  Result := false;       
  SetWorkStatus('Deleting playlist');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'deleteplaylist');
  Body.Put('playlist', ID);

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function DeleteTracks(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
begin
  Result := false;       
  SetWorkStatus('Deleting tracjs');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'trash');
  Body.Put('tracks', ArrayToJArray(Tracks));

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.Track, TLoad.Album, TLoad.Artist, TLoad.PlayList]);
end;

function RestoreTracks(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
begin
  Result := false;       
  SetWorkStatus('Restoring tracks');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'restore');
  Body.Put('tracks', ArrayToJArray(Tracks));

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load
  LoadLibrary(HTTP, [TLoad.Track, TLoad.Album, TLoad.Artist, TLoad.PlayList]);
end;

function EmptyTrash(const HTTP: TIdHTTP; Tracks: TArray<string>): boolean;
begin
  Result := false;       
  SetWorkStatus('Restoring tracks');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'empty_trash');
  Body.Put('tracks', ArrayToJArray(Tracks));

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
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
      ATracks.AddValue(Tracks[I].ID);

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

function PushHistory(const HTTP: TIdHTTP; Items: TArray<THistoryItem>): boolean;
var
  PlaysMap: TDictionary<string, int64>;
  Day: TDate;
begin
  Result := false;
  SetWorkStatus('Pushing history to server');
  //
  if Length(Items) = 0 then
    Exit;
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'status');

  // Calculate Count
  PlaysMap := TDictionary<string, int64>.Create;
  try
    Day := Items[0].Timestamp;
    for var I := 0 to High(Items) do
      begin
        var CurrentCount: int64;
        if not PlaysMap.TryGetValue(Items[I].TrackID, CurrentCount) then
          CurrentCount := 0;
        Inc(CurrentCount);

        PlaysMap.AddOrSetValue(Items[I].TrackID, CurrentCount);
      end;

    const ArrHistory = TJArray.CreateNew;
    begin
      const ObjHistory = TJObject.CreateNew;
      begin
        ObjHistory.Put('day', DateToString(Day));
        ObjHistory.Put('plays', DictionaryToJObject(PlaysMap));

        const ObjDetail = TJObject.CreateNew;
        begin
          for var I := 0 to High(Items) do begin
            const ObjTrackEvents = TJArray.CreateNew;
            begin
              const ObjTrackEvent = TJObject.CreateNew;
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
  
  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Re-load (load history playlist)
  LoadLibrary(HTTP, [TLoad.PlayList]);
end;

function LoadStatus(const HTTP: TIdHTTP): boolean;
begin
  Result := false;
  SetWorkStatus('Contacting iBroadcast API servers...');
  //
  const Body = V2_GetBody;
  Body.Put('mode', 'status');

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
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
begin
  Result := false;
  SetWorkStatus('Downloading iBroadcast Library...');
  //
  const Body = V2_GetBody;

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API_LIBRARY, OAuth2_AccessToken);
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  Result := Obj.KeyExists('result') and Obj.Memory['result'].AsBoolean;

  // Work
  ResetWork;

  // Load library
  SetWorkStatus('Loading library...');

  if not Obj.KeyExists('library') then
    Exit;
  const ObjLibrary = Obj.Memory['library'].AsObject;

  var ObjLibItem: IJObject;

  // Tracks
  if (TLoad.Track in LoadSet) and ObjLibrary.KeyExists('tracks') then begin
    SetWorkStatus('Loading tracks...');
    ResetWork;
    ObjLibItem := ObjLibrary.Memory['tracks'].AsObject;
    TotalWorkCount := ObjLibItem.AsObject.Count;

    // Enumerate
    Tracks := [];
    ObjLibItem.MemoryForEach(procedure(Key: string; const Item: IJValue) begin
      Inc(WorkCount);

      // Skip
      if (Key = 'map') or not Item.IsArray then
        Exit;

      // Add
      const Index = Length(Tracks);
      SetLength( Tracks, Index + 1 );

      Tracks[Index].LoadFrom(Key, Item.AsArray);
    end);

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
    ObjLibItem.MemoryForEach(procedure(Key: string; const Item: IJValue) begin
      Inc(WorkCount);

      // Skip
      if (Key = 'map') or not Item.IsArray then
        Exit;

      // Add
      const Index = Length(Albums);
      SetLength( Albums, Index + 1 );

      Albums[Index].LoadFrom(Key, Item.AsArray);

      // Invalid entry, delete from index
      if Albums[Index].TracksID.Count = 0 then
        SetLength(Albums, Index);
    end);

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
    ObjLibItem.MemoryForEach(procedure(Key: string; const Item: IJValue) begin
      Inc(WorkCount);

      // Skip
      if (Key = 'map') or not Item.IsArray then
        Exit;

      // Add
      const Index = Length(Artists);
      SetLength( Artists, Index + 1 );

      Artists[Index].LoadFrom(Key, Item.AsArray);

      // Invalid entry, delete from index
      if Artists[Index].TracksID.Count = 0 then
        SetLength(Artists, Index);
    end);

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
    ObjLibItem.MemoryForEach(procedure(Key: string; const Item: IJValue) begin
      Inc(WorkCount);

      // Skip
      if (Key = 'map') or not Item.IsArray then
        Exit;

      // Add
      const Index = Length(PlayLists);
      SetLength( PlayLists, Index + 1 );

      PlayLists[Index].LoadFrom(Key, Item.AsArray);
    end);

    // Updated
    if Assigned(OnUpdateType) then
      OnUpdateType(TDataSource.Playlists);
  end;


  //
  ResetWork;
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
  Temp: TBitMap;
  IMG: TJpegImage;
begin
  Temp := TBitMap.Create;
  with Temp.Canvas do
  try
    (* Set image size, 300 - iBroadcast Default *)
    Temp.SetSize(300, 300);

    (* TThread.Syncronise is required as drawing to a canvas requires GUI access! *)

    (* Get each image individually *)
    Img := GetSongArtwork( Tracks[GetTrack( ID1 )].ArtworkID, TArtSize.Small );
    try
      TThread.Synchronize(nil, procedure begin
        StretchDraw(Rect(0,0,150,150), Img, 255);
      end);
    finally
      Img.Free;
    end;

    Img := GetSongArtwork( Tracks[GetTrack( ID2 )].ArtworkID, TArtSize.Small );
    try
      TThread.Synchronize(nil, procedure begin
        StretchDraw(Rect(150,0,300,150), Img, 255);
      end);
    finally
      Img.Free;
    end;

    Img := GetSongArtwork( Tracks[GetTrack( ID3 )].ArtworkID, TArtSize.Small );
    try
      TThread.Synchronize(nil, procedure begin
        StretchDraw(Rect(0,150,150,300), Img, 255);
      end);
    finally
      Img.Free;
    end;

    Img := GetSongArtwork( Tracks[GetTrack( ID4 )].ArtworkID, TArtSize.Small );
    try
      TThread.Synchronize(nil, procedure begin
        StretchDraw(Rect(150,150,300,300), Img, 255);
      end);
    finally
      Img.Free;
    end;

    (* Assigne *)
    Result := TJpegImage.Create;
    Result.Assign(Temp);
  finally
    (* Free *)
    Temp.Free;
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

  TimeZone: TTimeZone;
begin                     
  DateTimeFormat := TFormatSettings.Create('en-us');
  DateTimeFormat.ShortDateFormat := 'yyyy-mm-dd';
  DateTimeFormat.LongDateFormat := 'yyyy-mm-dd';
  DateTimeFormat.LongTimeFormat := 'hh:nn:ss.zzzzzz';
  DateTimeFormat.ShortTimeFormat := 'hh:nn:ss.zzzzzz';
  DateTimeFormat.DateSeparator := '-';
  Result := StrToDateTime(trim(ADateTimeStr), DateTimeFormat);

  // Unversal Coordinated Time
  if CovertUTC then
    begin
      TimeZone := TTimeZone.Local;

      Result := TimeZone.ToLocalTime(Result);
    end;
end;

function DateTimeToString(ADateTime: TDateTime; CovertUTC: boolean = true): string;
var
  DateTimeFormat: TFormatSettings;

  TimeZone: TTimeZone;
begin
  DateTimeFormat := TFormatSettings.Create;
  DateTimeFormat.ShortDateFormat := 'yyyy-mm-dd';
  DateTimeFormat.LongTimeFormat := 'hh:nn:ss';
  DateTimeFormat.DateSeparator := '-';

  // Unversal Coordinated Time
  if CovertUTC then
    begin
      TimeZone := TTimeZone.Local;

      ADateTime := TimeZone.ToUniversalTime(ADateTime);
    end;

  // Convert
  Result := DateTimeToStr(ADateTime, DateTimeFormat);
end;

function DateToString(ADateTime: TDate; CovertUTC: boolean = true): string;
var
  DateTimeFormat: TFormatSettings;

  TimeZone: TTimeZone;
begin
  DateTimeFormat := TFormatSettings.Create;
  DateTimeFormat.ShortDateFormat := 'yyyy-mm-dd';
  DateTimeFormat.LongTimeFormat := 'hh:nn:ss';
  DateTimeFormat.DateSeparator := '-';

  // Unversal Coordinated Time
  if CovertUTC then
    begin
      TimeZone := TTimeZone.Local;

      ADateTime := TimeZone.ToUniversalTime(ADateTime);
    end;

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

function TTrackItem.ArtworkLoaded(Large: boolean): boolean;
begin
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

procedure TTrackItem.LoadFrom(Key: string; AArr: IJArray);
begin
  SetDataWorkStatus(Format('Loading song with ID of %S', [ID]));

  // Data
  ID := Key;

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
begin
  SetDataWorkStatus(Format('Loading album with ID of %S', [ID]));

  ID := Key;
  //

  AlbumName := AArr.Memory[0].AsString;

  // TRACKS
  TracksID := [];
  for var ID in JArrayToStringArray(AArr.Memory[1]) do begin
    if GetTrack(ID) <> -1 then
      TracksID := TracksID + [ID];
  end;

  // Data 2
  ArtistID := AArr.Memory[2].AsString;

  IsInTrash := AArr.Memory[3].AsBoolean;

  Rating := AArr.Memory[4].AsInteger;
  Disk := AArr.Memory[5].AsInteger;
  Year := AArr.Memory[6].AsInteger;
end;

{ TArtistItem }

function TArtistItem.ArtworkLoaded: boolean;
begin
  Result := (CachedImage <> nil) and (not CachedImage.Empty);
end;

function TArtistItem.GetArtwork: TJPEGImage;
var
  AIndex: integer;
begin
  Status := Status + [TWorkItem.DownloadingImage];

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
              if Length(TracksID) >= 4 then
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

  Status := Status - [TWorkItem.DownloadingImage];
end;

function TArtistItem.HasArtwork: boolean;
begin
  Result := ArtworkID <> '';
end;

procedure TArtistItem.LoadFrom(Key: string; AArr: IJArray);
begin
  SetDataWorkStatus(Format('Loading artist with ID of %S', [ID]));

  ID := Key;
  //

  ArtistName := AArr.Memory[0].AsString;

  // TRACKS
  TracksID := [];
  for var ID in JArrayToStringArray(AArr.Memory[1]) do begin
    if GetTrack(ID) <> -1 then
      TracksID := TracksID + [ID];
  end;

  // Data 2
  IsInTrash := AArr.Memory[2].AsBoolean;
  Rating := AArr.Memory[3].AsInteger;

  ArtworkID := '';
  if (AArr.Count > 4) and AArr[4].IsString then
    ArtworkID := AArr[4].AsString;
end;

{ TPlaylistItem }

function TPlaylistItem.ArtworkLoaded: boolean;
begin
  Result := (CachedImage <> nil) and (not CachedImage.Empty);
end;

function TPlaylistItem.GetArtwork: TJPEGImage;
begin
  Status := Status + [TWorkItem.DownloadingImage];

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
              if Length(TracksID) >= 4 then
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

  Status := Status - [TWorkItem.DownloadingImage];
end;

function TPlaylistItem.HasArtwork: boolean;
begin
  Result := ArtworkID <> '';
end;

procedure TPlaylistItem.LoadFrom(Key: string; AArr: IJArray);
begin
  SetDataWorkStatus(Format('Loading playlist with ID of %S', [ID]));

  ID := Key;
  //

  Name := AArr.Memory[0].AsString;

  // TRACKS
  TracksID := [];
  for var ID in JArrayToStringArray(AArr.Memory[1]) do begin
    if GetTrack(ID) <> -1 then
      TracksID := TracksID + [ID];
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
