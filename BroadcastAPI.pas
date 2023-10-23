unit BroadcastAPI;

{$SCOPEDENUMS ON}

interface
  uses
    // Required Units
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
    Vcl.Graphics, IOUtils, System.Generics.Collections, IdSSLOpenSSL,
    IdHTTP, JSON, Vcl.Clipbrd, DateUtils, Cod.Types, Imaging.jpeg,
    Cod.VarHelpers, Cod.Dialogs, Cod.SysUtils, Cod.Files, Cod.ArrayHelpers;

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

    // Procs
    TDataTypeUpdate = procedure(AUpdate: TDataSource) of object;

    // Records
    ResultType = record
      Error: boolean;
      LoggedIn: boolean;
      ServerMessage: string;

      function Success: boolean;

      procedure TerminateSession;
      procedure AnaliseFrom(JSON: TJSONValue);
    end;

    THistoryItem = record
      TrackID: integer;
      TimeStamp: TDateTime;
    end;

    TLibraryStatus = record
      TotalTracks: integer;
      TotalPlays: integer;

      TokenExpireDate: TDateTime;
      LastLibraryModified: TDateTime;
      UpdateTimestamp: TDateTime;

      (* Loading *)
      procedure LoadFrom(JSON: TJSONValue);
    end;

    TAccount = record
      Username: string;
      OneQueue: boolean;
      BitRate: string;

      UserID: integer;
      CreationDate: TDateTime;

      Verified: boolean;
      BetaTester: boolean;

      EmailAdress: string;
      Premium: boolean;
      VerificationDate: TDateTime;

      (* Loading *)
      procedure LoadFrom(JSON: TJSONValue);
    end;

    TTrackItem = record
      (* Song properties in their JSON order, "?" is a unknown property *)
      ID: integer;

      TrackNumber: cardinal;

      Year: cardinal;
      Title: string;

      Genre: string;

      LengthSeconds: cardinal;
      AlbumID: cardinal;
      ArtworkID: string;
      ArtistID: cardinal;

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

      (* Artwork *)
      function ArtworkLoaded(Large: boolean = false): boolean;
      function GetArtwork(Large: boolean = false): TJPEGImage;

      (* Loading *)
      procedure LoadFrom(JSONPair: TJSONPair);
    end;

    TAlbumItem = record
      (* Album properties in their JSON order, "?" is a unknown property *)
      ID: integer;

      AlbumName: string;

      TracksID: TArray<integer>;
      ArtistID: integer;

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
      procedure LoadFrom(JSONPair: TJSONPair);
    end;

    TArtistItem = record
      (* Album properties in their JSON order, "?" is a unknown property *)
      ID: integer;

      ArtistName: string;

      TracksID: TArray<integer>;
      IsInTrash: boolean;

      Rating: cardinal;
      ArtworkID: string;

      // ??? - ICatID

      // Extra Data
      HasArtwork: boolean;

      CachedImage: TJpegImage;
      Status: TWorkItems;

      (* Artwork *)
      function ArtworkLoaded: boolean;
      function GetArtwork: TJPEGImage;

      (* Loading *)
      procedure LoadFrom(JSONPair: TJSONPair);
    end;

    TPlaylistItem = record
      (* Album properties in their JSON order, "?" is a unknown property *)
      ID: integer;

      Name: string;

      TracksID: TArray<integer>;
      // ??? UID
      // ??? system_created
      // ??? public_id

      PlaylistType: string;

      Description: string;
      ArtworkID: string;
      // ??? SortType

      // Extra Data
      HasArtwork: boolean;

      CachedImage: TJpegImage;
      Status: TWorkItems;

      (* Artwork *)
      function ArtworkLoaded: boolean;
      function GetArtwork: TJPEGImage;

      (* Loading *)
      procedure LoadFrom(JSONPair: TJSONPair);
    end;

    TSession = record
      DeviceName: string;

      Joinable: boolean;
      Connected: boolean;

      Client: string;
      LastLogin: TDateTime;
      Location: string;

      (* Loading *)
      procedure LoadFrom(JSON: TJSONValue);
    end;

    // Arrays
    TArtists = TArray<TArtistItem>;
    TAlbums = TArray<TAlbumItem>;
    TTracks = TArray<TTrackItem>;
    TPlaylists = TArray<TPlaylistItem>;
    TSessions = TArray<TSession>;

  // Get Data
  function GetTrack(ID: integer): integer;
  function GetAlbum(ID: integer): integer;
  function GetArtist(ID: integer): integer;
  function GetPlaylist(ID: integer): integer;

  function GetPlaylistOfType(AType: string): integer; (* thumbsup, recently-played, recently-uploaded *)

  // Utils
  function StringToDateTime(const ADateTimeStr: string; CovertUTC: boolean = true): TDateTime;
  function DateTimeToString(ADateTime: TDateTime; CovertUTC: boolean = true): string;
  function DateToString(ADateTime: TDate; CovertUTC: boolean = true): string;
  function Yearify(Year: cardinal): string;

  // Main Request
  function SendClientRequest(RequestJSON: string; Endpoint: string = ''): TJSONValue;

  // User
  function LoginUser: boolean;
  procedure LogOff;

  function IsAuthenthicated: boolean;

  procedure ReturnToLogin;

  // Memory
  procedure APIFreeMemory;

  // Artwork Store
  procedure AddToArtworkStore(ID: integer; Cache: TJpegImage; AType: TDataSource);
  function ExistsInStore(ID: integer; AType: TDataSource): boolean;
  function GetArtStoreCache(ID: integer; AType: TDataSource): TJpegImage;
  function GetArtworkStore(AType: TDataSource = TDataSource.None): string;
  procedure ClearArtworkStore;
  procedure InitiateArtworkStore;

  // Tracks
  function UpdateTrackRating(ID: integer; Rating: integer; ReloadLibrary: boolean): boolean;
  function GetSongPlaylists(ID: integer): TArray<integer>;

  function TrackRatingToLikedPlaylist(ID: integer): boolean;

  // Albums
  function UpdateAlbumRating(ID: integer; Rating: integer; ReloadLibrary: boolean): boolean;

  // Artists
  function UpdateArtistRating(ID: integer; Rating: integer; ReloadLibrary: boolean): boolean;

  // Playlist
  function CreateNewPlayList(Name, Description: string; MakePublic: boolean; Tracks: TArray<integer>): boolean; overload;
  function CreateNewPlayList(Name, Description: string; MakePublic: boolean; Mood: string): boolean; overload;
  function AppentToPlaylist(ID: integer; Tracks: TArray<integer>): boolean;
  function PreappendToPlaylist(ID: integer; Tracks: TArray<integer>): boolean;
  function ChangePlayList(ID: integer; Tracks: TArray<integer>): boolean;
  function DeleteFromPlaylist(ID: integer; Tracks: TArray<integer>): boolean;
  function TouchupPlaylist(ID: integer): boolean;
  function UpdatePlayList(ID: integer; Name, Description: string; ReloadLibrary: boolean): boolean;
  function DeletePlayList(ID: integer): boolean;

  // History
  function PushHistory(Items: TArray<THistoryItem>): boolean;

  // Library
  procedure LoadStatus;
  procedure LoadLibrary;
  procedure LoadLibraryAdvanced(LoadSet: TLoadSet);

  // Additional Data
  function GetSongArtwork(ID: string; Size: TArtSize = TArtSize.Small): TJpegImage;
  function SongArtCollage(ID1, ID2, ID3, ID4: integer): TJpegImage;

  // Status
  procedure SetWorkStatus(Status: string);
  procedure SetDataWorkStatus(Status: string);

  procedure ResetWork;

const
  // Formattable Strings
  DEVICE_NAME_CONST = '%S' + ' iBroadcast for Windows';
  WELCOME_STRING = 'Welcome, %S';

  // Login Constants
  CLIENT_NAME = 'Cods iBroadcast';
  API_ENDPOINT = 'https://api.ibroadcast.com/';
  LIBRARY_ENDPOINT = 'https://library.ibroadcast.com/';
  ARTWORK_ENDPOINT = 'https://artwork.ibroadcast.com/artwork/%S-%U';
  STREAMING_ENDPOINT = 'https://streaming.ibroadcast.com';

  API_VERSION = '1.0.0';

  // Artwork Store
  ART_EXT = '.jpeg';

  // Templates
  REQUEST_HEADER = '{'
    + '"user_id": %U,'
    + '"token": "%S",'
    + '"version": "' + API_VERSION + '"';

  // Request Formats
  REQUEST_LOGIN = '{'
    + '"login_token": "%S",'
    + '"device_name": "%S",'
    + '"client": "%S",'
    + '"version": "' + API_VERSION + '",'
    + '"app_id": "%S",'
    + '"type": "account",'
    + '"mode": "login_token"'
    + '}';

  REQUEST_LOGOFF = REQUEST_HEADER + ','
    + '"mode": "logout"'
    + '}';

  // Data
  REQUEST_EMPTY = REQUEST_HEADER + ','
    + '}';

  REQUEST_DATA = REQUEST_HEADER + ','
    + '"mode": "%S"'
    + '}';

  // Playlist
  REQUEST_LIST_TEMPLATE = REQUEST_HEADER + ','
    + '"mode": "createplaylist",'
    + '"name": "%S",'
    + '"description": "%S",'
    + '"make_public": %S';

  REQUEST_LIST_CREATETRACKS = REQUEST_LIST_TEMPLATE + ','
    + '"tracks": [%S]'
    + '}';

  REQUEST_LIST_CREATEMOOD = REQUEST_LIST_TEMPLATE + ','
    + '"mood": "%S"'
    + '}';

  REQUEST_LIST_DELETE = REQUEST_HEADER + ','
    + '"mode": "deleteplaylist",'
    + '"playlist": %D'
    + '}';

  REQUEST_LIST_ADD = REQUEST_HEADER + ','
    + '"mode": "appendplaylist",'
    + '"playlist": %D,'
    + '"tracks": [%S]'
    + '}';

  REQUEST_LIST_SET = REQUEST_HEADER + ','
    + '"mode": "updateplaylist",'
    + '"playlist": %D,'
    + '"tracks": [%S]'
    + '}';

  REQUEST_LIST_UPDATE = REQUEST_HEADER + ','
    + '"mode": "updateplaylist",'
    + '"playlist": %D,'
    + '"name": "%S",'
    + 'supported_types: false,'
    + '"description": "%S"'
    + '}';

  // Rating
  REQUEST_RATE_TRACK = REQUEST_HEADER + ','
    + '"mode": "ratetrack",'
    + '"track_id": %D,'
    + '"rating": %D'
    + '}';

  REQUEST_RATE_ALBUM = REQUEST_HEADER + ','
    + '"mode": "ratealbum",'
    + '"album_id": %D,'
    + '"rating": %D'
    + '}';

  REQUEST_RATE_ARTIST = REQUEST_HEADER + ','
    + '"mode": "rateartist",'
    + '"artist_id": %D,'
    + '"rating": %D'
    + '}';

  // History
  (* Will be build on runtime *)

  // Library
  REQUEST_LIBRARY = REQUEST_HEADER
    + '}';


var
  // App Device token
  LOGIN_TOKEN: string;

  // Notify
  OnWorkStatusChange: procedure(Status: string);
  OnDataWorkStatusChange: procedure(Status: string);

  // Post export
  ExportPost: boolean = false;

  // Cover Settings
  DefaultArtSize: TArtSize = TArtSize.Medium;

  // Login Information
  VERSION: string;
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
  ArtworkStore: boolean = true;
  MediaStoreLocation: string;

  // Server Login Output
  TOKEN: string;
  USER_ID: integer;
  APPLICATION_ID: string = '1078';

  // Library
  LibraryStatus: TLibraryStatus;
  Account: TAccount;
  Sessions: TSessions;

  Tracks: TTracks;
  Albums: TAlbums;
  Artists: TArtists;
  Playlists: TPlaylists;

  DefaultPicture: TJPEGImage;

implementation

uses
  MainUI;

function SendClientRequest(RequestJSON, Endpoint: string): TJSONValue;
var
  Response, AFolder, APath: string;
  HTTP: TIdHTTP;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  RequestStream: TStringStream;
  I: integer;
begin
  // Endpoint
  if Endpoint = '' then
    Endpoint := API_ENDPOINT;

  // Create HTTP and SSLIOHandler components
  HTTP := TIdHTTP.Create(nil);
  SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  RequestStream := TStringStream.Create(RequestJSON, TEncoding.UTF8);
  try
    // Set SSL/TLS options
    SSLIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    HTTP.IOHandler := SSLIOHandler;

    // Set headers
    HTTP.Request.ContentType := 'application/json';

    // Send request and receive response
    Response := HTTP.Post(Endpoint, RequestStream);

    // POST Exporter
    if ExportPost then
      begin
        AFolder := ReplaceWinPath('shell:desktop\POST Export\');
        if not TDirectory.Exists(AFolder) then
          TDirectory.CreateDirectory(AFolder);

        I := 0;
        repeat
          APath := AFolder + 'apirequest' + i.ToString + '.json';
          Inc(I);
        until not TFile.Exists(APath);

        TFile.WriteAllText(APath, Response);
      end;

    // Parse response and extract numbers
    Result := TJSONObject.ParseJSONValue(Response);
  finally
    // Free
    HTTP.Free;
    RequestStream.Free;
  end;
end;

function LoginUser: boolean;
var
  Request: string;
  SResult: ResultType;

  JSONValue: TJSONValue;
  JSONUser: TJSONObject;
begin
  // Prepare request string
  Request := Format(REQUEST_LOGIN, [LOGIN_TOKEN, DEVICE_NAME, CLIENT_NAME, APPLICATION_ID]);

  // Parse response and extract numbers
  JSONValue := SendClientRequest(Request);
  try
    SResult.AnaliseFrom(JSONValue);

    Result := SResult.Success;

    // Success
    if SResult.Success then
        begin
          // Get "user" category
          JSONUser := JSONValue.GetValue<TJSONObject>('user');

          // Get User ID
          USER_ID := JSONUser.GetValue<TJSONString>('id').Value.ToInteger;
          TOKEN := JSONUser.GetValue<TJSONString>('token').Value;;
        end
      else
        begin
          //raise Exception.Create(SResult.ServerMessage);
        end;

  finally
    JSONValue.Free;
  end;
end;

procedure LogOff;
var
  Request: string;
  SResult: ResultType;

  JSONValue: TJSONValue;
begin
  // Prepare request string
  Request := Format(REQUEST_LOGOFF, [USER_ID, TOKEN]);

  // Parse response and extract numbers
  JSONValue := SendClientRequest(Request);
  try
    SResult.AnaliseFrom(JSONValue);

    ReturnToLogin;
  finally
    JSONValue.Free;
  end;
end;

function IsAuthenthicated: boolean;
var
  Request: string;
  SResult: ResultType;

  JSONValue: TJSONValue;
begin
  if (USER_ID = 0) or (TOKEN = '') then
    Exit(false);

  // Prepare request string
  Request := Format(REQUEST_EMPTY, [USER_ID, TOKEN]);

  // Parse response and extract numbers
  JSONValue := SendClientRequest(Request);
  try
    SResult.AnaliseFrom(JSONValue);

    Result := SResult.LoggedIn;
  finally
    JSONValue.Free;
  end;
end;

procedure ReturnToLogin;
begin
  UIForm.PrepareForLogin;
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

procedure AddToArtworkStore(ID: integer; Cache: TJpegImage; AType: TDataSource);
var
  Path: string;
begin
  Path := GetArtworkStore(AType) + ID.ToString + ART_EXT;

  Cache.SaveToFile(Path);
end;

function ExistsInStore(ID: integer; AType: TDataSource): boolean;
var
  Path: string;
begin
  if not ArtworkStore then
    Exit(false);

  Path := GetArtworkStore(AType) + ID.ToString + ART_EXT;

  Result := TFile.Exists( Path );
end;

function GetArtStoreCache(ID: integer; AType: TDataSource): TJpegImage;
var
  Path: string;
begin
  Path := GetArtworkStore(AType) + ID.ToString + ART_EXT;

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

function UpdateTrackRating(ID: integer; Rating: integer; ReloadLibrary: boolean): boolean;
var
  Request: string;
  JResult: ResultType;

  JSONValue: TJSONValue;
begin
  // Prepare request string
  Request := Format(REQUEST_RATE_TRACK, [USER_ID, TOKEN, ID, Rating]);

  // Parse response and extract numbers
  SetWorkStatus('Updating track rating');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  if ReloadLibrary then
    LoadLibraryAdvanced([TLoad.Track]);
end;

function GetSongPlaylists(ID: integer): TArray<integer>;
var
  I: Integer;
begin
  // Search
  Result := [];
  for I := 0 to High(Playlists) do
    if Playlists[I].TracksID.Find(ID) <> -1 then
      Result.AddValue(Playlists[I].ID);
end;

function TrackRatingToLikedPlaylist(ID: integer): boolean;
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
            Result := PreappendToPlaylist(Playlists[Index].ID, [ID])
          else
            Result := DeleteFromPlaylist(Playlists[Index].ID, [ID]);
        end;
    end;
end;

function UpdateAlbumRating(ID: integer; Rating: integer; ReloadLibrary: boolean): boolean;
var
  Request: string;
  JResult: ResultType;

  JSONValue: TJSONValue;
begin
  // Prepare request string
  Request := Format(REQUEST_RATE_ALBUM, [USER_ID, TOKEN, ID, Rating]);

  // Parse response and extract numbers
  SetWorkStatus('Updating album rating');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  if ReloadLibrary then
    LoadLibraryAdvanced([TLoad.Album]);
end;

function UpdateArtistRating(ID: integer; Rating: integer; ReloadLibrary: boolean): boolean;
var
  Request: string;
  JResult: ResultType;

  JSONValue: TJSONValue;
begin
  // Prepare request string
  Request := Format(REQUEST_RATE_ARTIST, [USER_ID, TOKEN, ID, Rating]);

  // Parse response and extract numbers
  SetWorkStatus('Updating artist rating');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  if ReloadLibrary then
    LoadLibraryAdvanced([TLoad.Artist]);
end;

function CreateNewPlayList(Name, Description: string; MakePublic: boolean; Tracks: TArray<integer>): boolean;
var
  Request: string;
  JResult: ResultType;

  ATracks: string;
  ATotal: integer;

  JSONValue: TJSONValue;
  I: Integer;
begin
  // Get Tracks
  ATracks := '';
  ATotal := High(Tracks);
  for I := 0 to ATotal do
    begin
      ATracks := ATracks + Tracks[I].ToString;

      if I < ATotal then
        ATracks := Concat(ATracks, ',');
    end;

  // Prepare request string
  Request := Format(REQUEST_LIST_CREATETRACKS, [USER_ID, TOKEN,
    Name, Description, booleantostring(MakePublic), ATracks]);

  // Parse response and extract numbers
  SetWorkStatus('Creating Playlist by Songs');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  LoadLibraryAdvanced([TLoad.PlayList]);
end;

function CreateNewPlayList(Name, Description: string; MakePublic: boolean; Mood: string): boolean;
var
  Request: string;
  JResult: ResultType;

  JSONValue: TJSONValue;
begin
  // Prepare request string
  Request := Format(REQUEST_LIST_CREATEMOOD, [USER_ID, TOKEN,
    Name, Description, booleantostring(MakePublic), Mood]);

  // Parse response and extract numbers
  SetWorkStatus('Creating Playlist by Mood');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  LoadLibraryAdvanced([TLoad.PlayList]);
end;

function AppentToPlaylist(ID: integer; Tracks: TArray<integer>): boolean;
var
  Request: string;
  JResult: ResultType;

  ATracks: string;
  ATotal: integer;

  JSONValue: TJSONValue;
  I: Integer;
begin
  // Get Tracks
  ATracks := '';
  ATotal := High(Tracks);
  for I := 0 to ATotal do
    begin
      ATracks := ATracks + Tracks[I].ToString;

      if I < ATotal then
        ATracks := Concat(ATracks, ',');
    end;

  // Prepare request string
  Request := Format(REQUEST_LIST_ADD, [USER_ID, TOKEN,
    ID, ATracks]);

  // Parse response and extract numbers
  SetWorkStatus('Adding songs to playlist');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  LoadLibraryAdvanced([TLoad.PlayList]);
end;

function PreappendToPlaylist(ID: integer; Tracks: TArray<integer>): boolean;
var
  AllTracks: TArray<integer>;
  I: Integer;
begin
  // Get Tracks
  AllTracks := Playlists[GetPlaylist(ID)].TracksID;

  // Insert
  for I := 0 to High(Tracks) do
    AllTracks.Insert(0, Tracks[I]);

  // Change ex
  Result := ChangePlayList(ID, AllTracks);
end;

function ChangePlayList(ID: integer; Tracks: TArray<integer>): boolean;
var
  Request: string;
  JResult: ResultType;

  AllTracks: TArray<integer>;
  ATracks: string;
  ATotal: integer;

  JSONValue: TJSONValue;
  I: Integer;
begin
  // Delete Tracks
  AllTracks := Tracks;

  // Get Tracks
  ATracks := '';
  ATotal := High(AllTracks);
  for I := 0 to ATotal do
    begin
      ATracks := ATracks + AllTracks[I].ToString;

      if I < ATotal then
        ATracks := Concat(ATracks, ',');
    end;

  // Prepare request string
  Request := Format(REQUEST_LIST_SET, [USER_ID, TOKEN,
    ID, ATracks]);

  // Parse response and extract numbers
  SetWorkStatus('Changing songs of playlist');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  LoadLibraryAdvanced([TLoad.PlayList]);
end;

function DeleteFromPlaylist(ID: integer; Tracks: TArray<integer>): boolean;
var
  Request: string;
  JResult: ResultType;

  AllTracks: TArray<integer>;
  ATracks: string;
  ATotal: integer;

  JSONValue: TJSONValue;
  I: Integer;
begin
  // Delete Tracks
  AllTracks := Playlists[GetPlaylist(ID)].TracksID;
  for I := 0 to High(Tracks) do
    AllTracks.Delete(AllTracks.Find(Tracks[I]));

  // Get Tracks
  ATracks := '';
  ATotal := High(AllTracks);
  for I := 0 to ATotal do
    begin
      ATracks := ATracks + AllTracks[I].ToString;

      if I < ATotal then
        ATracks := Concat(ATracks, ',');
    end;

  // Prepare request string
  Request := Format(REQUEST_LIST_SET, [USER_ID, TOKEN,
    ID, ATracks]);

  // Parse response and extract numbers
  SetWorkStatus('Changing songs of playlist');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  LoadLibraryAdvanced([TLoad.PlayList]);
end;

function TouchupPlaylist(ID: integer): boolean;
var
  Request: string;
  JResult: ResultType;

  AllTracks: TArray<integer>;
  ATracks: string;
  ATotal: integer;

  JSONValue: TJSONValue;
  I: Integer;
begin
  // Delete Tracks
  AllTracks := Playlists[GetPlaylist(ID)].TracksID;

  // Delete invalid enteries
  for I := High(AllTracks) downto 0 do
    if GetTrack(AllTracks[I]) = -1 then
      AllTracks.Delete(I);

  // Get Tracks
  ATracks := '';
  ATotal := High(AllTracks);
  for I := 0 to ATotal do
    begin
      ATracks := ATracks + AllTracks[I].ToString;

      if I < ATotal then
        ATracks := Concat(ATracks, ',');
    end;

  // Prepare request string
  Request := Format(REQUEST_LIST_SET, [USER_ID, TOKEN,
    ID, ATracks]);

  // Parse response and extract numbers
  SetWorkStatus('Repairing playlist');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  LoadLibraryAdvanced([TLoad.PlayList]);
end;

function UpdatePlayList(ID: integer; Name, Description: string; ReloadLibrary: boolean): boolean;
var
  Request: string;
  JResult: ResultType;

  JSONValue: TJSONValue;
begin
  // Prepare request string
  Request := Format(REQUEST_LIST_UPDATE, [USER_ID, TOKEN,
    ID, Name, Description]);

  // Parse response and extract numbers
  SetWorkStatus('Updating playlist');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  if ReloadLibrary then
    LoadLibraryAdvanced([TLoad.PlayList]);
end;

function DeletePlayList(ID: integer): boolean;
var
  Request: string;
  JResult: ResultType;

  JSONValue: TJSONValue;
begin
  // Prepare request string
  Request := Format(REQUEST_LIST_DELETE, [USER_ID, TOKEN, ID]);

  // Parse response and extract numbers
  SetWorkStatus('Deleting playlist');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load playlists
  LoadLibraryAdvanced([TLoad.PlayList]);
end;

function PushHistory(Items: TArray<THistoryItem>): boolean;
var
  Request: string;
  JResult: ResultType;

  JSONRequest,
  JSONHist,
  JSONEvents,
  JSONItem: TJSONObject;
  JSONArray,
  JSONHistory: TJSONArray;

  JSONValue: TJSONValue;

  PlayMap,
  PlayCount: TArray<integer>;

  Day: TDate;

  Index, I: Integer;
begin
  if Length(Items) = 0 then
    Exit(false);

  Day := Items[0].Timestamp;

  // Calculate Count
  PlayMap := [];
  PlayCount := [];

  for I := 0 to High(Items) do
    begin
      Index := PlayMap.Find(Items[I].TrackID);

      if Index = -1 then
        begin
          PlayMap.AddValue(Items[I].TrackID);
          PlayCount.AddValue(1);
        end
      else
        begin
          Inc(PlayCount[Index]);
        end;
    end;

  // Create JSON
  JSONRequest := TJSONObject.Create;
  JSONHistory := TJSONArray.Create;
  JSONHist := TJSONObject.Create;
  try
    // Data
    JSONRequest.AddPair('user_id', USER_ID);
    JSONRequest.AddPair('token', TOKEN);
    JSONRequest.AddPair('version', API_VERSION);
    JSONRequest.AddPair('mode', 'status');

    // Overview
    JSONHist.AddPair('day', DateToString(Day));

    JSONItem := TJSONObject.Create;
    for I := 0 to High(PlayMap) do
      JSONItem.AddPair(PlayMap[I].ToString, PlayCount[I]);

    JSONHist.AddPair('plays', JSONItem);

    // Detail & Events
    JSONEvents := TJSONObject.Create;

    for I := 0 to High(Items) do
      begin
        JSONArray := TJsonArray.Create;
        JSONItem := TJSONObject.Create;

        JSONItem.AddPair('event', 'play');
        JSONItem.AddPair('ts', DateTimeToString(Items[I].TimeStamp));

        JSONArray.Add(JSONItem);
        JSONEvents.AddPair(Items[I].TrackID.ToString, JSONArray);
      end;

    JSONHist.AddPair('detail', JSONEvents);

    // Add
    JSONHistory.Add(JSONHist);
    JSONRequest.AddPair('history', JSONHistory);

    // Prepare request string
    Request := JSONRequest.ToJSON;
  finally
    JSONRequest.Free;
  end;

  // Parse response and extract numbers
  SetWorkStatus('Pushing history update to server');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    Result := JResult.Success;
  finally
    JSONValue.Free;
  end;

  // Re-load history, nah
  LoadLibraryAdvanced([TLoad.PlayList]);
end;

procedure LoadStatus;
var
  Request: string;
  JResult: ResultType;

  JSONValue: TJSONValue;
  JSONAccount,
  JSONItem: TJSONObject;
  JSONSessions: TJSONArray;
  I: Integer;
begin
  // Prepare request string
  Request := Format(REQUEST_DATA, [USER_ID, TOKEN, 'status']);

  // Parse response and extract numbers
  SetWorkStatus('Contacting iBroadcast API servers...');
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    if JResult.Error then
      if not JResult.LoggedIn then
        JResult.TerminateSession;

    // Load status
    SetWorkStatus('Loading library status...');
    JSONItem := JSONValue.GetValue<TJSONObject>('status');
    LibraryStatus.LoadFrom(JSONItem);

    // Account
    SetWorkStatus('Loading your account...');
    JSONAccount := JSONValue.GetValue<TJSONObject>('user');

    Account.LoadFrom( JSONAccount );

    // Sessions
    SetWorkStatus('Loading sessions...');
    JSONSessions := JSONAccount.GetValue<TJSONObject>('session').GetValue<TJSONArray>('sessions');

    SetLength( Sessions, JSONSessions.Count );

    for I := 0 to JSONSessions.Count - 1 do
      begin
        Sessions[I].LoadFrom( JSONSessions.Items[I] );
      end;
  finally
    JSONValue.Free;
  end;
end;

procedure LoadLibrary;
begin
  LoadLibraryAdvanced( [TLoad.Track, TLoad.Album, TLoad.Artist, TLoad.PlayList]);
end;

procedure LoadLibraryAdvanced(LoadSet: TLoadSet);
var
  Request: string;
  JResult: ResultType;

  JSONValue: TJSONValue;
  JSONLibrary,
  JSONItem: TJSONObject;
  JSONPair: TJSONPair;
  I, Index: Integer;
begin
  // Prepare request string
  Request := Format(REQUEST_LIBRARY, [USER_ID, TOKEN]);

  // Work
  ResetWork;

  // Parse response and extract numbers
  SetWorkStatus('Downloading iBroadcast Library...');
  JSONValue := SendClientRequest(Request, LIBRARY_ENDPOINT);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    if JResult.Error then
      if not JResult.LoggedIn then
        JResult.TerminateSession;

    // Load library
    SetWorkStatus('Loading library...');
    JSONLibrary := JSONValue.GetValue<TJSONObject>('library');

    // Tracks
    if TLoad.Track in LoadSet then
      begin
        SetWorkStatus('Loading tracks...');
        JSONItem := JSONLibrary.GetValue<TJSONObject>('tracks');
        SetLength( Tracks, 0 );

        // Work
        ResetWork;
        TotalWorkCount := JSONItem.Count;

        for I := 0 to JSONItem.Count - 1 do
          begin
            try
              JSONPair := JSONItem.Pairs[I];
            except
              if I >= JSONItem.Count - 1 then
                Break;
              Continue;
            end;

            WorkCount := I;

            if JSONPair.JsonString.Value = 'map' then
              Continue;

            Index := Length(Tracks);
            SetLength( Tracks, Index + 1 );

            Tracks[Index].LoadFrom( JSONPair );
          end;

        // Updated
        if Assigned(OnUpdateType) then
          OnUpdateType(TDataSource.Tracks);
      end;

    // Albums
    if TLoad.Album in LoadSet then
      begin
        SetWorkStatus('Loading albums...');
        JSONItem := JSONLibrary.GetValue<TJSONObject>('albums');
        SetLength( Albums, 0 );

        // Work
        ResetWork;
        TotalWorkCount := JSONItem.Count;

        for I := 0 to JSONItem.Count - 1 do
          begin
            JSONPair := JSONItem.Pairs[I];

            WorkCount := I;

            if JSONPair.JsonString.Value = 'map' then
              Continue;

            Index := Length(Albums);
            SetLength( Albums, Index + 1 );

            Albums[Index].LoadFrom( JSONPair );
          end;

        // Updated
        if Assigned(OnUpdateType) then
          OnUpdateType(TDataSource.Albums);
      end;

    // Artists
    if TLoad.Artist in LoadSet then
      begin
        SetWorkStatus('Loading artists...');
        JSONItem := JSONLibrary.GetValue<TJSONObject>('artists');
        SetLength( Artists, 0 );

        // Work
        ResetWork;
        TotalWorkCount := JSONItem.Count;

        for I := 0 to JSONItem.Count - 1 do
          begin
            JSONPair := JSONItem.Pairs[I];

            WorkCount := I;

            if JSONPair.JsonString.Value = 'map' then
              Continue;

            Index := Length(Artists);
            SetLength( Artists, Index + 1 );

            Artists[Index].LoadFrom( JSONPair );
          end;

        // Updated
        if Assigned(OnUpdateType) then
          OnUpdateType(TDataSource.Artists);
      end;

    // PlayLists
    if TLoad.PlayList in LoadSet then
      begin
        SetWorkStatus('Loading playlists...');
        JSONItem := JSONLibrary.GetValue<TJSONObject>('playlists');
        SetLength( PlayLists, 0 );

        // Work
        ResetWork;
        TotalWorkCount := JSONItem.Count;

        for I := 0 to JSONItem.Count - 1 do
          begin
            JSONPair := JSONItem.Pairs[I];

            WorkCount := I;

            if JSONPair.JsonString.Value = 'map' then
              Continue;

            Index := Length(PlayLists);
            SetLength( PlayLists, Index + 1 );

            PlayLists[Index].LoadFrom( JSONPair );
          end;

        // Updated
        if Assigned(OnUpdateType) then
          OnUpdateType(TDataSource.Playlists);
      end;
  finally
    JSONValue.Free;
  end;

  // Work
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
  URL := Format(ARTWORK_ENDPOINT, [ID, ImageSize]);

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

function SongArtCollage(ID1, ID2, ID3, ID4: integer): TJpegImage;
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

{ ResultType }

procedure ResultType.AnaliseFrom(JSON: TJSONValue);
begin
  Error := not JSON.GetValue<TJSONBool>('result').AsBoolean;

  if not JSON.TryGetValue<boolean>('authenticated', LoggedIn) then
    LoggedIn := true;

  if JSON.FindValue('message') <> nil then
    ServerMessage := JSON.GetValue<TJSONString>('message').Value;
end;

function ResultType.Success: boolean;
begin
  Result := not Error;
end;

procedure ResultType.TerminateSession;
begin
  LogOff;
  ReturnToLogin;

  // Terminate Parent Function
  Abort;
end;

function GetTrack(ID: integer): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(Tracks) do
    if Tracks[I].ID = ID then
      Exit( I );
end;

function GetAlbum(ID: integer): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(Albums) do
    if Albums[I].ID = ID then
      Exit( I );
end;

function GetArtist(ID: integer): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(Artists) do
    if Artists[I].ID = ID then
      Exit( I );
end;

function GetPlaylist(ID: integer): integer;
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
  DateTimeFormat := TFormatSettings.Create;
  DateTimeFormat.ShortDateFormat := 'yyyy-mm-dd';
  DateTimeFormat.LongTimeFormat := 'hh:nn:ss.zzzzzz';
  DateTimeFormat.DateSeparator := '-';
  Result := StrToDateTime(ADateTimeStr, DateTimeFormat);

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

procedure TLibraryStatus.LoadFrom(JSON: TJSONValue);
begin
  TotalTracks := JSON.GetValue<TJSONNumber>('available').AsInt;
  TotalPlays := JSON.GetValue<TJSONNumber>('plays').AsInt;

  TokenExpireDate := StringToDateTime( JSON.GetValue<TJSONString>('expires').Value );
  LastLibraryModified := StringToDateTime( JSON.GetValue<TJSONString>('lastmodified').Value );
  UpdateTimestamp := StringToDateTime( JSON.GetValue<TJSONString>('timestamp').Value );
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

procedure TTrackItem.LoadFrom(JSONPair: TJSONPair);
var
  JSON: TJSONArray;
begin
  JSON := TJSONArray(JSONPair.JsonValue);

  // Data
  ID := JSONPair.JsonString.Value.ToInteger;

  SetDataWorkStatus(Format('Loading song with ID of %D', [ID]));

  TrackNumber := (JSON.Items[0].AsType<TJSONNumber>).AsInt;
  Year := (JSON.Items[1].AsType<TJSONNumber>).AsInt;

  Title := (JSON.Items[2].AsType<TJSONString>).Value;
  Genre := (JSON.Items[3].AsType<TJSONString>).Value;

  LengthSeconds := (JSON.Items[4].AsType<TJSONNumber>).AsInt;
  // Typecast as number, then as string for legacy accounts
  try
    AlbumID := (JSON.Items[5].AsType<TJSONNumber>).AsInt;
  except
    AlbumID := (JSON.Items[5].AsType<TJSONString>).Value.ToInteger;
  end;
  try
    ArtworkID := (JSON.Items[6].AsType<TJSONNumber>).AsInt.ToString;
  except
    ArtworkID := (JSON.Items[6].AsType<TJSONString>).Value;
  end;
  try
    ArtistID := (JSON.Items[7].AsType<TJSONNumber>).AsInt;
  except
    ArtistID := (JSON.Items[7].AsType<TJSONString>).Value.ToInteger;
  end;

  // ?
  DayUploaded := StringToDateTime( (JSON.Items[9].AsType<TJSONString>).Value );
  IsInTrash := (JSON.Items[10].AsType<TJSONBool>).AsBoolean;
  FileSize := (JSON.Items[11].AsType<TJSONNumber>).AsInt;

  UploadLocation := (JSON.Items[12].AsType<TJSONString>).Value;
  // ?

  Rating := (JSON.Items[14].AsType<TJSONNumber>).AsInt;
  Plays := (JSON.Items[15].AsType<TJSONNumber>).AsInt;

  StreamLocations := (JSON.Items[16].AsType<TJSONString>).Value;
  AudioType := (JSON.Items[17].AsType<TJSONString>).Value;

  ReplayGain := (JSON.Items[18].AsType<TJSONString>).Value;
  try
    UploadTime := StringToDateTime( (JSON.Items[19].AsType<TJSONString>).Value );
  except
    UploadTime := 0;
  end;
  // ?
end;

{ TAccount }

procedure TAccount.LoadFrom(JSON: TJSONValue);
const
  BACKUP_DATE = '2023-03-05';
var
  S: string;
begin
  SetDataWorkStatus('Loading account from post request');

  if not JSON.TryGetValue<string>('username', Username) then
    Username := 'User';
  //ShowMessage(JSOn.ToString);

  JSON.GetValue<TJSONValue>('preferences').TryGetValue<string>('onequeue', S);
  OneQueue := stringtoboolean(S);
  JSON.GetValue<TJSONValue>('preferences').TryGetValue<string>('bitratepref', BitRate);

  UserID := JSON.GetValue<TJSONString>('user_id').Value.ToInteger;
  if not JSON.TryGetValue<string>('created_on', S) then
    S := BACKUP_DATE;
  CreationDate := StringToDateTime(S);

  JSON.TryGetValue<boolean>('verified', Verified);
  JSON.TryGetValue<boolean>('tester', BetaTester);

  EmailAdress := JSON.GetValue<TJSONString>('email_address').Value;
  JSON.TryGetValue<boolean>('premium', Premium);
  if not JSON.TryGetValue<string>('verified_on', S) then
    S := BACKUP_DATE;
  VerificationDate := StringToDateTime(S);
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

procedure TAlbumItem.LoadFrom(JSONPair: TJSONPair);
var
  JSON, SONGS: TJSONArray;
  I: Integer;
begin
  JSON := TJSONArray(JSONPair.JsonValue);

  // Data
  ID := JSONPair.JsonString.Value.ToInteger;

  SetDataWorkStatus(Format('Loading album with ID of %D', [ID]));

  AlbumName := (JSON.Items[0].AsType<TJSONString>).Value;

  // TRACKS
  SONGS := TJSONArray(JSONPair.JsonValue.A[1]);
  SetLength(TracksID, 0);

  var ID: integer;
  for I := 0 to SONGS.Count-1 do
    begin
      ID := SONGS.Items[I].AsType<TJSONNumber>.AsInt;
      // Validate
      if GetTrack(ID) <> -1 then
        TracksID.AddValue( ID );
    end;

  // Data 2
  ArtistID := (JSON.Items[2].AsType<TJSONNumber>).AsInt;

  IsInTrash := (JSON.Items[3].AsType<TJSONBool>).AsBoolean;

  Rating := (JSON.Items[4].AsType<TJSONNumber>).AsInt;
  Disk := (JSON.Items[5].AsType<TJSONNumber>).AsInt;
  Year := (JSON.Items[6].AsType<TJSONNumber>).AsInt;
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

procedure TArtistItem.LoadFrom(JSONPair: TJSONPair);
var
  JSON, SONGS: TJSONArray;
  I: Integer;
begin
  JSON := TJSONArray(JSONPair.JsonValue);

  // Data
  ID := JSONPair.JsonString.Value.ToInteger;

  SetDataWorkStatus(Format('Loading artist with ID of %D', [ID]));

  ArtistName := (JSON.Items[0].AsType<TJSONString>).Value;

  // TRACKS
  SONGS := TJSONArray(JSONPair.JsonValue.A[1]);
  SetLength(TracksID, 0);

  var ID: integer;
  for I := 0 to SONGS.Count-1 do
    begin
      ID := SONGS.Items[I].AsType<TJSONNumber>.AsInt;
      // Validate
      if GetTrack(ID) <> -1 then
        TracksID.AddValue( ID );
    end;

  // Data 2
  IsInTrash := (JSON.Items[2].AsType<TJSONBool>).AsBoolean;
  Rating := (JSON.Items[3].AsType<TJSONNumber>).AsInt;

  HasArtwork := JSON.Count > 4;
  if HasArtwork then
    begin
      HasArtwork := JSON.Items[4].TryGetValue<string>(ArtworkID);

      if ArtworkID = '' then
        HasArtwork := false;
    end;
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

procedure TPlaylistItem.LoadFrom(JSONPair: TJSONPair);
var
  JSON, SONGS: TJSONArray;
  I: Integer;
begin
  JSON := TJSONArray(JSONPair.JsonValue);

  // Data
  ID := JSONPair.JsonString.Value.ToInteger;

  SetDataWorkStatus(Format('Loading playlist with ID of %D', [ID]));

  Name := (JSON.Items[0].AsType<TJSONString>).Value;

  // TRACKS
  SONGS := TJSONArray(JSONPair.JsonValue.A[1]);
  SetLength(TracksID, 0);

  var ID: integer;
  for I := 0 to SONGS.Count-1 do
    begin
      ID := SONGS.Items[I].AsType<TJSONNumber>.AsInt;
      // Validate
      if GetTrack(ID) <> -1 then
        TracksID.AddValue( ID );
    end;

  // ?
  // ?
  // ?

  // Data 2
  JSON.Items[5].TryGetValue<string>(PlaylistType);
  JSON.Items[6].TryGetValue<string>(Description);

  HasArtwork := JSON.Count > 4;
  if HasArtwork then
    begin
      HasArtwork := JSON.Items[7].TryGetValue<string>(ArtworkID);

      if ArtworkID = '' then
        HasArtwork := false;
    end;

  // ?
end;

{ TSession }

procedure TSession.LoadFrom(JSON: TJSONValue);
begin
  SetDataWorkStatus('Loading session');

  DeviceName := JSON.GetValue<TJSONString>('device_name').Value;

  Joinable := JSON.GetValue<TJSONBool>('joinable').Value.ToBoolean;
  Connected := JSON.GetValue<TJSONBool>('connected').Value.ToBoolean;

  Client := JSON.GetValue<TJSONString>('client').Value;

  LastLogin := StringToDateTime(JSON.GetValue<TJSONString>('last_login').Value);

  JSON.TryGetValue<string>('location', Location);
end;

end.
