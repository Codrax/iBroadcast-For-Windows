{***********************************************************}
{                 Codruts Debugging Utilities               }
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

unit Cod.Debugging;

interface
  uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, IOUTils,
  Cod.Types, Cod.StringUtils, Cod.Files;

  procedure Debug(Value: string);
  procedure CounterOutput(Message: string);


implementation

var
  Count: integer = 0;
  OutputName: string;

procedure Debug(Value: string);
begin
  OutPutDebugString( PChar(Value) );
end;

procedure CounterOutput(Message: string);
var
  FLog: string;
  F: TextFile;
begin
  FLog := Count.ToString + ' - ' + Message;

  AssignFile(F, OutputName);
  if Count = 0 then
    Rewrite(F)
  else
    Append(F);

  Inc(Count);

  WriteLn(F, FLog);

  CloseFile(F);

  OutputDebugString( PChar(FLog) );
end;

initialization
  OutputName := ReplaceWinPath('%tmp%\debug_log.txt')

end.