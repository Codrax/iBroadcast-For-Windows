unit BroadcastAPI;

{$SCOPEDENUMS ON}

interface
  uses
    // Required Units
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
    Vcl.Graphics, IOUtils, System.Generics.Collections, IdSSLOpenSSL,
    IdHTTP, JSON, Vcl.Clipbrd, DateUtils, Cod.Types, Imaging.jpeg,
    Cod.VarHelpers, Cod.Dialogs;

  type
    // Cardinals
    TArtSize = (Small, Medium, Large);
    TWorkItem = (DownloadingImage);
    TWorkItems = set of TWorkItem;

    // Source
    TDataSource = (None, Tracks, Albums, Artists, Playlists);
    TDataSources = set of TDataSource;

    // Recors
    ResultType = record
      Error: boolean;
      LoggedIn: boolean;
      ServerMessage: string;

      function Success: boolean;

      procedure TerminateSession;
      procedure AnaliseFrom(JSON: TJSONValue);
    end;

    TLibraryStatus = record
      TotalTracks: integer;
      TotalPlays: integer;

      TokenExpireDate: TDateTime;
      LastLibraryModified: TDateTime;
      UpdateTimestamp: TDateTime;

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

      function ArtworkLoaded(Large: boolean = false): boolean;
      function GetArtwork(Large: boolean = false): TJPEGImage;

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

      function ArtworkLoaded: boolean;
      function GetArtwork: TJPEGImage;

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

      function ArtworkLoaded: boolean;
      function GetArtwork: TJPEGImage;

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

      function ArtworkLoaded: boolean;
      function GetArtwork: TJPEGImage;

      procedure LoadFrom(JSONPair: TJSONPair);
    end;

    TSession = record
      DeviceName: string;

      Joinable: boolean;
      Connected: boolean;

      Client: string;
      LastLogin: TDateTime;
      Location: string;

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

  function GetPlaylistType(AType: string): integer;

  // Utils
  function StringToDateTime(const ADateTimeStr: string; CovertUTC: boolean = true): TDateTime;
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

  // Library
  procedure LoadStatus;
  procedure LoadLibrary;

  // Additional Data
  function GetSongArtwork(ID: string; Size: TArtSize = TArtSize.Small): TJpegImage;
  function SongArtCollage(ID1, ID2, ID3, ID4: integer): TJpegImage;


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

  REQUEST_LOGOFF = '{'
    + '"user_id": %U,'
    + '"token": "%S",'
    + '"version": "' + API_VERSION + '",'
    + '"mode": "logout"'
    + '}';

  REQUEST_EMPTY = '{'
    + '"user_id": %U,'
    + '"token": "%S",'
    + '"version": "' + API_VERSION + '"'
    + '}';

  REQUEST_DATA = '{'
    + '"user_id": %U,'
    + '"token": "%S",'
    + '"version": "' + API_VERSION + '",'
    + '"mode": "%S"'
    + '}';

  REQUEST_LIBRARY = '{'
    + '"user_id": %U,'
    + '"token": "%S",'
    + '"version": "' + API_VERSION + '"'
    + '}';


var
  // App Device token
  LOGIN_TOKEN: string;

  // Cover Settings
  DefaultArtSize: TArtSize = TArtSize.Medium;

  // Login Information
  VERSION: string;
  DEVICE_NAME: string;

  // Verbose Loggins
  WORK_STATUS: string;

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
  Response: string;
  HTTP: TIdHTTP;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  RequestStream: TStringStream;
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
  WORK_STATUS := 'Contacting iBroadcast API servers...';
  JSONValue := SendClientRequest(Request);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    if JResult.Error then
      if not JResult.LoggedIn then
        JResult.TerminateSession;

    // Load status
    WORK_STATUS := 'Loading library status...';
    JSONItem := JSONValue.GetValue<TJSONObject>('status');
    LibraryStatus.LoadFrom(JSONItem);

    // Account
    WORK_STATUS := 'Loading your account...';
    JSONAccount := JSONValue.GetValue<TJSONObject>('user');

    Account.LoadFrom( JSONAccount );

    // Sessions
    WORK_STATUS := 'Loading sessions...';
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

  // Parse response and extract numbers
  WORK_STATUS := 'Downloading iBroadcast Library...';
  JSONValue := SendClientRequest(Request, LIBRARY_ENDPOINT);
  try
    // Error
    JResult.AnaliseFrom(JSONVALUE);

    if JResult.Error then
      if not JResult.LoggedIn then
        JResult.TerminateSession;

    // Load library
    WORK_STATUS := 'Loading library...';
    JSONLibrary := JSONValue.GetValue<TJSONObject>('library');

    // Tracks
    WORK_STATUS := 'Loading tracks...';
    JSONItem := JSONLibrary.GetValue<TJSONObject>('tracks');
    SetLength( Tracks, 0 );

    for I := 0 to JSONItem.Count - 1 do
      begin
        JSONPair := JSONItem.Pairs[I];

        if JSONPair.JsonString.Value = 'map' then
          Continue;

        Index := Length(Tracks);
        SetLength( Tracks, Index + 1 );

        Tracks[Index].LoadFrom( JSONPair );
      end;

    // Albums
    WORK_STATUS := 'Loading albums...';
    JSONItem := JSONLibrary.GetValue<TJSONObject>('albums');
    SetLength( Albums, 0 );

    for I := 0 to JSONItem.Count - 1 do
      begin
        JSONPair := JSONItem.Pairs[I];

        if JSONPair.JsonString.Value = 'map' then
          Continue;

        Index := Length(Albums);
        SetLength( Albums, Index + 1 );

        Albums[Index].LoadFrom( JSONPair );
      end;

    // Artists
    WORK_STATUS := 'Loading artists...';
    JSONItem := JSONLibrary.GetValue<TJSONObject>('artists');
    SetLength( Artists, 0 );

    for I := 0 to JSONItem.Count - 1 do
      begin
        JSONPair := JSONItem.Pairs[I];

        if JSONPair.JsonString.Value = 'map' then
          Continue;

        Index := Length(Artists);
        SetLength( Artists, Index + 1 );

        Artists[Index].LoadFrom( JSONPair );
      end;

    // PlayLists
    WORK_STATUS := 'Loading playlists...';
    JSONItem := JSONLibrary.GetValue<TJSONObject>('playlists');
    SetLength( PlayLists, 0 );

    for I := 0 to JSONItem.Count - 1 do
      begin
        JSONPair := JSONItem.Pairs[I];

        if JSONPair.JsonString.Value = 'map' then
          Continue;

        Index := Length(PlayLists);
        SetLength( PlayLists, Index + 1 );

        PlayLists[Index].LoadFrom( JSONPair );
      end;
  finally
    JSONValue.Free;
  end;
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

function GetPlaylistType(AType: string): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(Playlists) do
    if Playlists[I].PlaylistType = AType then
      Exit( I );
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

  TrackNumber := (JSON.Items[0].AsType<TJSONNumber>).AsInt;
  Year := (JSON.Items[1].AsType<TJSONNumber>).AsInt;

  Title := (JSON.Items[2].AsType<TJSONString>).Value;
  Genre := (JSON.Items[3].AsType<TJSONString>).Value;

  LengthSeconds := (JSON.Items[4].AsType<TJSONNumber>).AsInt;
  AlbumID := (JSON.Items[5].AsType<TJSONNumber>).AsInt;
  ArtworkID := (JSON.Items[6].AsType<TJSONNumber>).AsInt.ToString;
  ArtistID := (JSON.Items[7].AsType<TJSONNumber>).AsInt;

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
  UploadTime := StringToDateTime( (JSON.Items[19].AsType<TJSONString>).Value );
  // ?
end;

{ TAccount }

procedure TAccount.LoadFrom(JSON: TJSONValue);
const
  BACKUP_DATE = '2023-03-05';
var
  S: string;
begin
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

  AlbumName := (JSON.Items[0].AsType<TJSONString>).Value;

  // TRACKS
  SONGS := TJSONArray(JSONPair.JsonValue.A[1]);
  SetLength(TracksID, SONGS.Count);

  for I := 0 to High(TracksID) do
    TracksID[I] := SONGS.Items[I].AsType<TJSONNumber>.AsInt;

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

  ArtistName := (JSON.Items[0].AsType<TJSONString>).Value;

  // TRACKS
  SONGS := TJSONArray(JSONPair.JsonValue.A[1]);
  SetLength(TracksID, SONGS.Count);

  for I := 0 to High(TracksID) do
    TracksID[I] := SONGS.Items[I].AsType<TJSONNumber>.AsInt;

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

  Name := (JSON.Items[0].AsType<TJSONString>).Value;

  // TRACKS
  SONGS := TJSONArray(JSONPair.JsonValue.A[1]);
  SetLength(TracksID, SONGS.Count);

  for I := 0 to High(TracksID) do
    TracksID[I] := SONGS.Items[I].AsType<TJSONNumber>.AsInt;

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
  DeviceName := JSON.GetValue<TJSONString>('device_name').Value;

  Joinable := JSON.GetValue<TJSONBool>('joinable').Value.ToBoolean;
  Connected := JSON.GetValue<TJSONBool>('connected').Value.ToBoolean;

  Client := JSON.GetValue<TJSONString>('client').Value;

  LastLogin := StringToDateTime(JSON.GetValue<TJSONString>('last_login').Value);

  JSON.TryGetValue<string>('location', Location);
end;

end.
