{***********************************************************}
{                    Codruts Audio Utils                    }
{                                                           }
{                        version 0.1                        }
{                           ALPHA                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                   -- WORK IN PROGRESS --                  }
{***********************************************************}

unit Cod.Audio;

interface
  uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, IOUtils,

  (* Bass Library *)
  Bass;

  type
    TPlayStatus = (psStopped, psPlaying, psStalled, psPaused);
    TStreamOpenType = (sotClosed, sotFile, sotURL);

    TAudioPlayer = class(TObject)
      private
        FStream: HSTREAM;

        FOpenedData: string;
        FOpenedType: TStreamOpenType;

        FSteamDecoding: boolean;

        // Get Audio
        function GetPlayStatus: TPlayStatus;
        function GetFileOpened: boolean;

        // Duration & Position
        function GetDuration: int64;
        function GetDurationSeconds: Double;

        function GetPosition: int64;
        function GetPositionSeconds: Double;

        procedure SetPosition(const Value: int64);
        procedure SetPositionSeconds(const Value: Double);

        function GetAudioLooped: boolean;
        procedure SetAudioLooped(const Value: boolean);

        function GetVolume: single;
        procedure SetVolume(const Value: single);

        (* Set the output device for the music *)
        function GetOutputDevice: integer;
        procedure SetOutputDeviceEx(const Value: integer);

        function BytesToMilisecond(Bytes: int64): int64;
        function MilisecondToBytes(MiliSeconds: int64): int64;

        // Play Stauts
        procedure SetPlayStauts(AStatus: TPlayStatus);

      protected

      public
        function OpenFile(FilePath: string): boolean;
        function OpenURL(URL: string): boolean;
        procedure CloseFile;
        procedure ReopenFile;

        procedure Play;
        procedure Pause;
        procedure Stop;

        // Properties
        property PlayStatus: TPlayStatus read GetPlayStatus;

        property OpenedType: TStreamOpenType read FOpenedType;
        property StreamDecoding: boolean read FSteamDecoding write FSteamDecoding;

        property Duration: int64 read GetDuration;
        property DurationSeconds: Double read GetDurationSeconds;

        property Position: int64 read GetPosition write SetPosition;
        property PositionSeconds: Double read GetPositionSeconds write SetPositionSeconds;

        property Volume: single read GetVolume write SetVolume;

        property IsFileOpen: boolean read GetFileOpened;
        property Loop: boolean read GetAudioLooped write SetAudioLooped;

        property Stream: HSTREAM read FStream;

        // Output
        property OutputDevice: integer read GetOutputDevice write SetOutputDeviceEx;

        function GetOutputDevices: TArray<string>;
        function SetOutputDevice(const Value: integer): boolean;

        // Misc
        function GetCPUUsage: single;

        // Constructors
        constructor Create;
        destructor Destroy; override;
    end;

implementation



{ TAudioPlayer }

function TAudioPlayer.BytesToMilisecond(Bytes: int64): int64;
begin
  Result := Round(BASS_ChannelBytes2Seconds(FStream, Bytes) * 1000);
end;

procedure TAudioPlayer.CloseFile;
begin
  BASS_StreamFree(FStream);

  FOpenedType := TStreamOpenType.sotClosed;
end;

constructor TAudioPlayer.Create;
begin
  inherited;

  FSteamDecoding := true;
  FOpenedType := sotClosed;
end;

destructor TAudioPlayer.Destroy;
begin
  if GetFileOpened then
    CloseFile;

  inherited;
end;

function TAudioPlayer.GetAudioLooped: boolean;
var
  StreamFlags: DWORD;
begin
  // Get the flags of the audio stream
  StreamFlags := BASS_ChannelFlags(FStream, 0, 0);

  // Check if the loop flag is set
  Result := (StreamFlags and BASS_SAMPLE_LOOP) = BASS_SAMPLE_LOOP;
end;

function TAudioPlayer.GetCPUUsage: single;
begin
  Result := BASS_GetCPU;
end;

function TAudioPlayer.GetDuration: int64;
begin
  Result := BytesToMilisecond( BASS_ChannelGetLength(FStream, BASS_POS_BYTE) );
end;

function TAudioPlayer.GetDurationSeconds: Double;
begin
  Result := GetDuration / 1000;
end;

function TAudioPlayer.GetFileOpened: boolean;
begin
  Result := BASS_StreamGetFilePosition(FStream, BASS_FILEPOS_CURRENT) <> -1
end;

function TAudioPlayer.GetOutputDevice: integer;
begin
  Result := BASS_ChannelGetDevice( FStream );
end;

function TAudioPlayer.GetOutputDevices: TArray<string>;
var
  info: BASS_DEVICEINFO;
  i: Integer;
begin
  SetLength(Result, 0);

  i := 0;
  while BASS_GetDeviceInfo(i, info) do
  begin
    SetLength(Result, i + 1);

    Result[i] := String(info.name);

    Inc(i);
  end;
end;

function TAudioPlayer.GetPlayStatus: TPlayStatus;
begin
  Result := TPlayStatus( BASS_ChannelIsActive(FStream) );
end;

function TAudioPlayer.GetPosition: int64;
begin
  Result := BytesToMilisecond( BASS_ChannelGetPosition( FStream, BASS_POS_BYTE ) );
end;

function TAudioPlayer.GetPositionSeconds: Double;
begin
  Result := GetPosition / 1000;
end;

function TAudioPlayer.GetVolume: single;
begin
  Result := BASS_GetVolume;
end;

function TAudioPlayer.MilisecondToBytes(MiliSeconds: int64): int64;
begin
  Result := BASS_ChannelSeconds2Bytes(stream, MiliSeconds / 1000);
end;

function TAudioPlayer.OpenFile(FilePath: string): boolean;
begin
  // Close Item
  if GetFileOpened then
    CloseFile;

  // Save Data
  FOpenedData := FilePath;
  FOpenedType := TStreamOpenType.sotFile;

  // Load
  if TFile.Exists( FilePath ) then
    FStream := BASS_StreamCreateFile(FALSE, PWideChar(FilePath), 0, 0, BASS_UNICODE);

  // Result
  Result := GetFileOpened;
end;

function TAudioPlayer.OpenURL(URL: string): boolean;
begin
  // Close Item
  if GetFileOpened then
    CloseFile;

  // Save Data
  FOpenedData := URL;
  FOpenedType := TStreamOpenType.sotURL;

  // Load
  FStream := BASS_StreamCreateURL(PWideChar(url), 0, BASS_STREAM_BLOCK or BASS_STREAM_STATUS or BASS_UNICODE, nil, nil);

  // Result
  Result := GetFileOpened;
end;

procedure TAudioPlayer.Pause;
begin
  SetPlayStauts( psPaused );
end;

procedure TAudioPlayer.Play;
begin
  SetPlayStauts( psPlaying );
end;

procedure TAudioPlayer.ReopenFile;
begin
  if GetFileOpened then
    begin
      CloseFile;
      if FOpenedType = sotFile then
        OpenFile(FOpenedData)
      else
        OpenURL(FOpenedData);
    end;
end;

procedure TAudioPlayer.SetAudioLooped(const Value: boolean);
begin
  if GetAudioLooped = Value then
    Exit;

  if Value then
    BASS_ChannelFlags(FStream, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP)
  else
  BASS_ChannelFlags(FStream, 0, BASS_SAMPLE_LOOP);
end;

function TAudioPlayer.SetOutputDevice(const Value: integer): boolean;
begin
  Result := BASS_ChannelSetDevice( FStream, Value );
end;

procedure TAudioPlayer.SetOutputDeviceEx(const Value: integer);
begin
  SetOutputDevice( Value );
end;

procedure TAudioPlayer.SetPlayStauts(AStatus: TPlayStatus);
begin
  case AStatus of
    psStopped: BASS_ChannelStop( FStream );
    psPlaying: BASS_ChannelPlay( FStream, true );
    psPaused: BASS_ChannelPause( FStream );
  end;
end;

procedure TAudioPlayer.SetPosition(const Value: int64);
begin
  if (FOpenedType = sotURL) and FSteamDecoding then
    begin
      if Value < GetPosition then
        begin
          ReopenFile;

          Play;
        end;

      BASS_ChannelSetPosition( FStream, MilisecondToBytes(Value), BASS_POS_BYTE or BASS_POS_DECODETO );
    end
      else
        BASS_ChannelSetPosition( FStream, MilisecondToBytes(Value), BASS_POS_BYTE );
end;

procedure TAudioPlayer.SetPositionSeconds(const Value: Double);
begin
  SetPosition( trunc(Value * 1000) );
end;

procedure TAudioPlayer.SetVolume(const Value: single);
begin
  BASS_SetVolume( Value );
end;

procedure TAudioPlayer.Stop;
begin
  // Reset Position
  SetPosition(0);

  SetPlayStauts( psStopped );
end;

{ Initialize unit }
initialization
  BASS_Init(-1, 44100, 0, 0, nil);

finalization
  BASS_Free;

end.
