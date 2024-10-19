{***********************************************************}
{               Codruts Windows Runtime Storage             }
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

unit Cod.WindowsRT.Exceptions;

interface
uses
  // System
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Forms, RTTI;

type
  EWinRTException = class(Exception);

  EWinRTExceptionRegistrationNotDone = class(EWinRTException);


implementation


end.
