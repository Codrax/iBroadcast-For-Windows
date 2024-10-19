{***********************************************************}
{               Codruts Windows Media Controls              }
{                                                           }
{                        version 1.0                        }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{              Copyright 2024 Codrut Software               }
{***********************************************************}

{$SCOPEDENUMS ON}

unit Cod.WindowsRT.AsyncEvents;

interface
  uses
  // System
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Forms, IOUtils, System.Generics.Collections, Dialogs, ActiveX, ComObj,
  DateUtils,

  // Graphics
  Vcl.Graphics,

  // Windows RT (Runtime)
  Win.WinRT,
  Winapi.Winrt,
  Winapi.Winrt.Utils,
  Winapi.DataRT,

  // Winapi
  Winapi.CommonTypes,
  Winapi.Foundation,
  Winapi.Storage.Streams,

  // Required
  Winapi.Media,

  // Cod Utils
  Cod.WindowsRT;

type
  // Windows.Foundation
  TAsyncBoolean = class(TAsyncAwaitResult<boolean>,
    Winapi.Media.AsyncOperationCompletedHandler_1__Boolean)
  protected
    procedure Invoke(asyncInfo: IAsyncOperation_1__Boolean; asyncStatus: AsyncStatus); safecall;
  end;


implementation

{ TAsyncBoolean }

procedure TAsyncBoolean.Invoke(asyncInfo: IAsyncOperation_1__Boolean;
  asyncStatus: AsyncStatus);
begin
  FInternalResultValue := asyncInfo.GetResults;

  Trigger;
end;

end.
