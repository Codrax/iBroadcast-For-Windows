{***********************************************************}
{                    Codruts Time Utilities                 }
{                                                           }
{                        version 0.2                        }
{                           ALPHA                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                   -- WORK IN PROGRESS --                  }
{***********************************************************}

unit Cod.TimeUtils;

{$SCOPEDENUMS ON}

interface
  uses
  {$IFDEF MSWINDOWS}Winapi.Windows, Winapi.Messages, Registry, {$ENDIF}System.SysUtils, System.Classes, IdSNTP,
  DateUtils, Cod.Types;

  const
    DEFAULT_SERVER = 'time.windows.com';

    TIMESERVER_LOCATION = 'SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers';

  type
    TDateValueType = (Year, Month, Week, Day, Hour, Minute, Second, Millisecond);

  (* Time-Date Utilities *)
  procedure DateTimePassed(Time1, Time2: TDateTime; var Years, Months, Days, Hours, Minutes, Seconds, Milliseconds: cardinal);

  (* String *)
  function TimePassedToString(Seconds: cardinal): string;
  function DateTimePassedString(Time1, Time2: TDateTime; IncludeMilliseconds: boolean = false; Acronym: boolean = false): string;
  // Converts a value type to a formatted string. Such as 4 = "4 Minutes"
  function DateValueToString(Value: integer; AType: TDateValueType; Acronym: boolean = false): string;

  (* DateUtils supplement *)
  function RecodeWeek(const AValue: TDateTime; const AWeek: Word): TDateTime;

  (* Networking *)
  function SyncInternetTime(timeserver: string = DEFAULT_SERVER): boolean;
  function GetInternetTime(timeserver: string = DEFAULT_SERVER): TDateTime;

  function PingTimeServer(timeserver: string = DEFAULT_SERVER): boolean;

  {$IFDEF MSWINDOWS}
  function GetWindowsTimeServer(Secondary: boolean = false): string;
  {$ENDIF}

var
  STR_YEAR: string = 'Year';
  STR_YEAR_P: string = 'Years';
  STR_YEAR_A: string = 'y';

  STR_MONTH: string = 'Month';
  STR_MONTH_P: string = 'Months';
  STR_MONTH_A: string = 'm';

  STR_WEEK: string = 'Week';
  STR_WEEK_P: string = 'Weeks';
  STR_WEEK_A: string = 'w';

  STR_DAY: string = 'Day';
  STR_DAY_P: string = 'Days';
  STR_DAY_A: string = 'd';

  STR_HOUR: string = 'Hour';
  STR_HOUR_P: string = 'Hours';
  STR_HOUR_A: string = 'h';

  STR_MINUTE: string = 'Minute';
  STR_MINUTE_P: string = 'Minutes';
  STR_MINUTE_A: string = 'm';

  STR_SECOND: string = 'Second';
  STR_SECOND_P: string = 'Seconds';
  STR_SECOND_A: string = 's';

  STR_MILLISECOND: string = 'Millisecond';
  STR_MILLISECOND_P: string = 'Milliseconds';
  STR_MILLISECOND_A: string = 'ms';

implementation

procedure DateTimePassed(Time1, Time2: TDateTime; var Years, Months, Days, Hours, Minutes, Seconds, Milliseconds: cardinal);
var
  ATemp: TDateTime;
begin
  // Reverse
  if Time1 > Time2 then
    begin
      ATemp := Time1;
      Time1 := Time2;
      Time2 := ATemp;
    end;

  // Get Data
  Years := YearsBetween(Time1, Time2);
  Time1 := IncYear(Time1, Years);

  Months := MonthsBetween(Time1, Time2);
  Time1 := IncMonth(Time1, Months);

  Days := DaysBetween(Time1, Time2);
  Time1 := IncDay(Time1, Days);

  Hours := HoursBetween(Time1, Time2);
  Time1 := IncHour(Time1, Hours);

  Minutes := MinutesBetween(Time1, Time2);
  Time1 := IncMinute(Time1, Minutes);

  Seconds := SecondsBetween(Time1, Time2);
  Time1 := IncSecond(Time1, Seconds);

  Milliseconds := MillisecondsBetween(Time1, Time2);
end;

function TimePassedToString(Seconds: cardinal): string;
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

function DateTimePassedString(Time1, Time2: TDateTime; IncludeMilliseconds: boolean; Acronym: boolean): string;
var
  Years, Months, Days, Hours, Minutes, Seconds, Milliseconds: cardinal;
  Began: boolean;
function CheckBegan(Value: integer): boolean;
begin
  if not Began then
    Began := Value > 0;

  Result := Began;
end;
begin
  DateTimePassed(Time1, Time2, Years, Months, Days, Hours, Minutes, Seconds, Milliseconds);

  Result := '';
  Began := false;

  if CheckBegan(Years) then
    Result := Concat(Result, DateValueToString(Years, TDateValueType.Year, Acronym), ', ');

  if CheckBegan(Months) then
    Result := Concat(Result, DateValueToString(Months, TDateValueType.Month, Acronym), ', ');

  if CheckBegan(Days) then
    Result := Concat(Result, DateValueToString(Days, TDateValueType.Day, Acronym), ', ');

  if CheckBegan(Hours) then
    Result := Concat(Result, DateValueToString(Hours, TDateValueType.Hour, Acronym), ', ');

  if CheckBegan(Minutes) then
    Result := Concat(Result, DateValueToString(Minutes, TDateValueType.Minute, Acronym), ', ');

  // Seconds alwayss active
  Result := Concat(Result, DateValueToString(Seconds, TDateValueType.Second, Acronym));
  if IncludeMilliseconds then
    begin
      Result := Concat(Result, ', ', DateValueToString(Milliseconds, TDateValueType.Millisecond, Acronym));
    end;
end;

function DateValueToString(Value: integer; AType: TDateValueType; Acronym: boolean): string;
var
  PostFix: string;
  IsOne: boolean;
begin
  IsOne := Value = 1;

  case AType of
    TDateValueType.Year: if Acronym then
      PostFix := STR_YEAR_A
    else
      if IsOne then
        PostFix := STR_YEAR
      else
        PostFix := STR_YEAR_P;

    TDateValueType.Month: if Acronym then
      PostFix := STR_MONTH_A
    else
      if IsOne then
        PostFix := STR_MONTH
      else
        PostFix := STR_MONTH_P;

    TDateValueType.Week: if Acronym then
      PostFix := STR_WEEK_A
    else
      if IsOne then
        PostFix := STR_WEEK
      else
        PostFix := STR_WEEK_P;

    TDateValueType.Day: if Acronym then
      PostFix := STR_DAY_A
    else
      if IsOne then
        PostFix := STR_DAY
      else
        PostFix := STR_DAY_P;

    TDateValueType.Hour: if Acronym then
      PostFix := STR_HOUR_A
    else
      if IsOne then
        PostFix := STR_HOUR
      else
        PostFix := STR_HOUR_P;

    TDateValueType.Minute: if Acronym then
      PostFix := STR_MINUTE_A
    else
      if IsOne then
        PostFix := STR_MINUTE
      else
        PostFix := STR_MINUTE_P;

    TDateValueType.Second: if Acronym then
      PostFix := STR_SECOND_A
    else
      if IsOne then
        PostFix := STR_SECOND
      else
        PostFix := STR_SECOND_P;

    TDateValueType.Millisecond: if Acronym then
      PostFix := STR_MILLISECOND_A
    else
      if IsOne then
        PostFix := STR_MILLISECOND
      else
        PostFix := STR_MILLISECOND_P;
  end;

  if not Acronym then
    PostFix := ' ' + PostFix;

  Result := Format('%D%S', [Value, Postfix]);
end;

function RecodeWeek(const AValue: TDateTime; const AWeek: Word): TDateTime;
begin
  Result := IncWeek(AValue,
    AWeek-WeekOf(AValue)
    );
end;

function SyncInternetTime(timeserver: string = DEFAULT_SERVER): boolean;
var
  SNTPClient: TIdSNTP;
begin
  SNTPClient := TIdSNTP.Create(nil);
  try
    SNTPClient.Host := timeserver;
    Result := SNTPClient.SyncTime;
  finally
    SNTPClient.Free;
  end;
end;

function GetInternetTime(timeserver: string = 'time.windows.com'): TDateTime;
var
  SNTPClient: TIdSNTP;
begin
  SNTPClient := TIdSNTP.Create(nil);
  try
    SNTPClient.Host := 'time.windows.com';
    Result := SNTPClient.DateTime;
  finally
    SNTPClient.Free;
  end;
end;

function PingTimeServer(timeserver: string = 'time.windows.com'): boolean;
var
  SNTPClient: TIdSNTP;
begin
  SNTPClient := TIdSNTP.Create(nil);
  try
    SNTPClient.Host := timeserver;
    try
      SNTPClient.Connect;
      Result := SNTPClient.Connected;

      SNTPClient.Disconnect;
    except
      Result := false;
    end;
  finally
    SNTPClient.Free;
  end;
end;

{$IFDEF MSWINDOWS}
function GetWindowsTimeServer(Secondary: boolean): string;
var
  R: TRegistry;
  Value: string;
begin
  Result := DEFAULT_SERVER;
  R := TRegistry.Create(KEY_READ);
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    R.OpenKeyReadOnly(TIMESERVER_LOCATION);

    if Secondary then
      Value := '2'
    else
      Value := '1';

    if R.ValueExists(Value) then
      Result := R.ReadString(Value);
  finally
    R.Free;
  end;
end;
{$ENDIF}

end.