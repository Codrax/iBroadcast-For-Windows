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

interface
  uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, IdSNTP;

  function SyncInternetTime(timeserver: string = 'time.windows.com'): boolean;
  function GetInternetTime(timeserver: string = 'time.windows.com'): TDateTime;

  function PingTimeServer(timeserver: string = 'time.windows.com'): boolean;

implementation

function SyncInternetTime(timeserver: string = 'time.windows.com'): boolean;
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

end.