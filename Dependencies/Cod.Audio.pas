{***********************************************************}
{                    Codruts Audio Utils                    }
{                                                           }
{                        version 1.0                        }
{                      CROSS-PLATFORM                       }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                  Based on Bass for Delphi                 }
{              Copyright 2023 Petculescu Codrut             }
{***********************************************************}

{$IFDEF LINUX}
{$MODE DELPHI}
{$ENDIF}

unit Cod.Audio;

interface
  uses
  SysUtils, Classes, Types, Math,

  (* Bass Library *)
  Bass;

  type
    TPlayStatus = (psStopped, psPlaying, psStalled, psPaused);
    TStreamOpenType = (sotClosed, sotFile, sotURL);

    TLevel = record
      Left: integer;
      Right: integer;

      function Med: integer;
      procedure SetMed(Value: integer);
    end;
    TLevels = TArray<TLevel>;

    TAudioPlayer = class;
    TAudioDecoder = class;

    TAudioPlayer = class(TObject)
      private
        FStream: HSTREAM;

        FOpenedType: TStreamOpenType;

        FStreamDecoding: boolean;

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

        function GetSpeed: single;
        procedure SetSpeed(const Value: single);

        function GetSystemVolume: single;
        procedure SetSystemVolume(const Value: single);

        (* Set the output device for the music *)
        function GetOutputDevice: integer;
        procedure SetOutputDeviceEx(const Value: integer);

        function BytesToMilisecond(Bytes: int64): int64;
        function MilisecondToBytes(MiliSeconds: int64): int64;

        // Play Stauts
        procedure SetPlayStauts(AStatus: TPlayStatus);

      public
        function OpenFile(FilePath: string): boolean;
        function OpenURL(URL: string): boolean;
        procedure CloseFile;
        procedure ReopenFile;

        procedure Play;
        procedure Pause;
        procedure Stop;

        // Properties
        property PlayStatus: TPlayStatus read GetPlayStatus write SetPlayStauts;

        property OpenedType: TStreamOpenType read FOpenedType;
        property StreamDecoding: boolean read FStreamDecoding write FStreamDecoding;

        property Duration: int64 read GetDuration;
        property DurationSeconds: Double read GetDurationSeconds;

        property Position: int64 read GetPosition write SetPosition;
        property PositionSeconds: Double read GetPositionSeconds write SetPositionSeconds;

        property Speed: single read GetSpeed write SetSpeed;
        property Volume: single read GetVolume write SetVolume; // channel volume, from 0-1, but can be over 1 for earrape
        property SystemVolume: single read GetSystemVolume write SetSystemVolume; // windows volume

        property IsFileOpen: boolean read GetFileOpened;
        property Loop: boolean read GetAudioLooped write SetAudioLooped;

        property Stream: HSTREAM read FStream;

        // Output
        property OutputDevice: integer read GetOutputDevice write SetOutputDeviceEx;

        function GetOutputDevices: TArray<string>;
        function SetOutputDevice(const Value: integer): boolean;

        // Misc
        function GetCPUUsage: single;
        function GetSampleInfo: BASS_CHANNELINFO;

        function GetDecoder: TAudioDecoder;
        function GetByteLength: integer;

        function ChannelInfo: BASS_CHANNELINFO;

        procedure DecodeToPosition(Value: int64);

        // Constructors
        constructor Create;
        destructor Destroy; override;
    end;

    TAudioDecoder = class
    private
      FDecoder: HSTREAM;
      FOpenedType: TStreamOpenType;

    public
      property Decoder: HSTREAM read FDecoder;

      function GetFileOpened: boolean;

      function OpenFile(FilePath: string): boolean;
      function OpenURL(URL: string): boolean;
      procedure CloseFile;

      // Calculate audio levels. Provide the count of levels spanning the song, can be any number
      function GetLevels(LevelCount: integer): TLevels;

      function GetSampleInfo: BASS_CHANNELINFO;

      constructor Create;
      destructor Destroy; override;
    end;

  // Audio Utilities
  function GetSystemVolume: Cardinal;
  procedure SetSystemVolume(Value: Cardinal);

implementation

function GetSystemVolume: Cardinal;
begin
  Result := Round(Power(BASS_GetVolume, 1 / 1.9) * 100);
end;

procedure SetSystemVolume(Value: Cardinal);
begin
  BASS_SetVolume(Value / 100);
end;

{ TAudioPlayer }

function TAudioPlayer.BytesToMilisecond(Bytes: int64): int64;
begin
  Result := Round(BASS_ChannelBytes2Seconds(FStream, Bytes) * 1000);
end;

function TAudioPlayer.ChannelInfo: BASS_CHANNELINFO;
begin
  BASS_ChannelGetInfo(stream, Result);
end;

procedure TAudioPlayer.CloseFile;
begin
  BASS_StreamFree(FStream);

  FOpenedType := TStreamOpenType.sotClosed;
end;

constructor TAudioPlayer.Create;
begin
  inherited;

  FStreamDecoding := true;
  FOpenedType := sotClosed;
end;

procedure TAudioPlayer.DecodeToPosition(Value: int64);
begin
  BASS_ChannelSetPosition( FStream, MilisecondToBytes(Value), BASS_POS_BYTE or BASS_POS_DECODETO );
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

function TAudioPlayer.GetByteLength: integer;
begin
  Result := BASS_ChannelGetLength(FStream, BASS_POS_BYTE)
end;

function TAudioPlayer.GetCPUUsage: single;
begin
  Result := BASS_GetCPU;
end;

function TAudioPlayer.GetDecoder: TAudioDecoder;
begin
  Result := TAudioDecoder.Create;
  case FOpenedType of
    sotFile: Result.OpenFile(ChannelInfo.filename);
    sotURL: Result.OpenURL(ChannelInfo.filename);
  end;
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

function TAudioPlayer.GetSampleInfo: BASS_CHANNELINFO;
begin
  BASS_ChannelGetInfo(FStream, Result);
end;

function TAudioPlayer.GetSpeed: single;
begin
  BASS_ChannelGetAttribute(FStream, BASS_ATTRIB_FREQ, Result);
  Result := Result / GetSampleInfo.freq;
end;

function TAudioPlayer.GetSystemVolume: single;
begin
  Result := BASS_GetVolume;
end;

function TAudioPlayer.GetVolume: single;
begin
  BASS_ChannelGetAttribute(FStream, BASS_ATTRIB_VOL, Result);
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
  FOpenedType := TStreamOpenType.sotFile;

  // Load
  if fileexists( FilePath ) then
    FStream := BASS_StreamCreateFile(FALSE, PWideChar(FilePath), 0, 0, {$IFDEF UNICODE}BASS_UNICODE{$ELSE}0{$ENDIF});

  // Result
  Result := GetFileOpened;
end;

function TAudioPlayer.OpenURL(URL: string): boolean;
begin
  // Close Item
  if GetFileOpened then
    CloseFile;

  // Save Data
  FOpenedType := TStreamOpenType.sotURL;

  // Load
  FStream := BASS_StreamCreateURL(PWideChar(url), 0, BASS_STREAM_BLOCK or BASS_STREAM_STATUS {$IFDEF UNICODE}or BASS_UNICODE{$ENDIF}, nil, nil);

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
      // Open<T> closes the file automatically
      case FOpenedType of
        sotFile: OpenFile(GetSampleInfo.filename);
        sotURL: OpenURL(GetSampleInfo.filename);
      end;
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
    psPlaying: BASS_ChannelPlay( FStream, false );
    psPaused: BASS_ChannelPause( FStream );
  end;
end;

procedure TAudioPlayer.SetPosition(const Value: int64);
begin
  if (FOpenedType = sotURL) and FStreamDecoding then
    begin
      if Value < GetPosition then
        begin
          ReopenFile;

          Play;
        end;

      // Slowly decode to
      DecodeToPosition( Value );
    end
      else
        BASS_ChannelSetPosition( FStream, MilisecondToBytes(Value), BASS_POS_BYTE );
end;

procedure TAudioPlayer.SetPositionSeconds(const Value: Double);
begin
  SetPosition( trunc(Value * 1000) );
end;

procedure TAudioPlayer.SetSpeed(const Value: single);
begin
  BASS_ChannelSetAttribute(FStream, BASS_ATTRIB_FREQ, Value * GetSampleInfo.freq);
end;

procedure TAudioPlayer.SetSystemVolume(const Value: single);
begin
  BASS_SetVolume( Value );
end;

procedure TAudioPlayer.SetVolume(const Value: single);
begin
  BASS_ChannelSetAttribute(FStream, BASS_ATTRIB_VOL, Value);
end;

procedure TAudioPlayer.Stop;
begin
  // Reset Position
  SetPosition(0);

  SetPlayStauts( psStopped );
end;

{ Initialize unit }
{ TAudioDecoder }

procedure TAudioDecoder.CloseFile;
begin
  BASS_StreamFree(FDecoder);

  FOpenedType := TStreamOpenType.sotClosed;
end;

constructor TAudioDecoder.Create;
begin
  inherited;
end;

destructor TAudioDecoder.Destroy;
begin
  if GetFileOpened then
    CloseFile;
  inherited;
end;

function TAudioDecoder.GetFileOpened: boolean;
begin
  Result := BASS_StreamGetFilePosition(FDecoder, BASS_FILEPOS_CURRENT) <> -1;
end;

function HiWord(x:longword):word;
begin
  HiWord := (x and $FFFF0000) shr 16;
end;

function LoWord(x:longword):word;
begin
  LoWord := (x and $0000FFFF);
end;

function TAudioDecoder.GetLevels(LevelCount: integer): TLevels;
var
  cpos,level : DWord;
  peak : array[0..1] of DWORD;
  position : DWORD;
  counter : integer;
  BytesPerPixel: dword;
begin
  cpos := 0;
  peak[0] := 0;
  peak[1] := 0;
  counter := 0;

  BytesPerPixel := BASS_ChannelGetLength(FDecoder, BASS_POS_BYTE) div LevelCount;

  SetLength(Result, LevelCount);

  while true do
  begin
    level := BASS_ChannelGetLevel(FDecoder); // scan peaks
    if (peak[0]<LOWORD(level)) then
      peak[0]:=LOWORD(level); // set left peak
		if (peak[1]<HIWORD(level)) then
      peak[1]:=HIWORD(level); // set right peak
    if BASS_ChannelIsActive(FDecoder) <> BASS_ACTIVE_PLAYING then
    begin
      position := cardinal(-1); // reached the end
		end else
      position := BASS_ChannelGetPosition(FDecoder, BASS_POS_BYTE) div BytesPerPixel;

    if position > cpos then
    begin
      inc(counter);
      if counter <= length(Result)-1 then
      begin
        Result[counter].Left := peak[0];
        Result[counter].Right := peak[1];
      end;

      if (position >= dword(LevelCount)) then
        break;
      cpos := position;
    end;

    peak[0] := 0;
    peak[1] := 0;
  end;
end;

function TAudioDecoder.GetSampleInfo: BASS_CHANNELINFO;
begin
  BASS_ChannelGetInfo(FDecoder, Result);
end;

function TAudioDecoder.OpenFile(FilePath: string): boolean;
begin
  // Close
  if GetFileOpened then
    CloseFile;

  // Type
  FOpenedType := sotFile;

  // Open
  FDecoder := BASS_StreamCreateFile(FALSE, pchar(FilePath), 0, 0,BASS_STREAM_DECODE {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});

  // Result
  Result := GetFileOpened;
end;

function TAudioDecoder.OpenURL(URL: string): boolean;
begin
  // Close
  if GetFileOpened then
    CloseFile;

  // Type
  FOpenedType := sotFile;

  // Open
  FDecoder := BASS_StreamCreateURL(PCHAR(URL), 0, BASS_STREAM_DECODE or BASS_UNICODE, nil, nil);

  // Result
  Result := GetFileOpened;
end;

{ TLevel }

function TLevel.Med: integer;
begin
  Result := (Left + Right) div 2;
end;

procedure TLevel.SetMed(Value: integer);
begin
  Left := Value div 2;
  Right := Left;
end;

initialization
  BASS_Init(-1, 44100, 0, 0, nil);

finalization
  BASS_Free;

end.

