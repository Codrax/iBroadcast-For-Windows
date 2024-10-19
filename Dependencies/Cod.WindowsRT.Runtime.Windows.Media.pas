{***********************************************************}
{             Codruts Windows Runtime for Delphi            }
{                                                           }
{              Copyright 2024 Codrut Software               }
{***********************************************************}

{$SCOPEDENUMS ON}

unit Cod.WindowsRT.Runtime.Windows.Media;

interface

uses
  // System
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Forms, IOUtils, System.Generics.Collections, Dialogs, ActiveX, ComObj,
  DateUtils,

  // Graphics
  Vcl.Graphics,
  Vcl.Imaging.pngimage,

  // Windows RT (Runtime)
  Win.WinRT,
  Winapi.Winrt,
  Winapi.Winrt.Utils,
  Winapi.DataRT,

  // Winapi
  Winapi.CommonNames,
  Winapi.CommonTypes,
  Winapi.Foundation,
  Winapi.Storage.Streams,

  // Media
  Winapi.Media,

  // Required
  Cod.WindowsRT.CommonNames;

type
  // ISystemMediaTransportControlsTimelineProperties
  [WinRTClassNameAttribute(SWindows_Media_SystemMediaTransportControlsTimelineProperties)]
  ISystemMediaTransportControlsTimelineProperties = interface(IInspectable)
  ['{5125316A-C3A2-475B-8507-93534DC88F15}']
    function get_StartTime: TimeSpan; safecall;
    procedure put_StartTime(value: TimeSpan); safecall;
    function get_EndTime: TimeSpan; safecall;
    procedure put_EndTime(value: TimeSpan); safecall;
    function get_MinSeekTime: TimeSpan; safecall;
    procedure put_MinSeekTime(value: TimeSpan); safecall;
    function get_MaxSeekTime: TimeSpan; safecall;
    procedure put_MaxSeekTime(value: TimeSpan); safecall;
    function get_Position: TimeSpan; safecall;
    procedure put_Position(value: TimeSpan); safecall;

    property StartTime: TimeSpan read get_StartTime write put_StartTime;
    property EndTime: TimeSpan read get_EndTime write put_EndTime;
    property MinSeekTime: TimeSpan read get_MinSeekTime write put_MinSeekTime;
    property MaxSeekTime: TimeSpan read get_MaxSeekTime write put_MaxSeekTime;
    property Position: TimeSpan read get_Position write put_Position;
  end;

  TSystemMediaTransportControlsTimelineProperties = class(TWinRTGenericImportI<ISystemMediaTransportControlsTimelineProperties>) end;

  // Windows.Media.ISystemMediaTransportControlsButtonPressedEventArgs
  IPlaybackPositionChangeRequestedEventArgs = interface(IInspectable)
  ['{B4493F88-EB28-4961-9C14-335E44F3E125}']
    function get_RequestedPlaybackPosition: TimeSpan; safecall;
    property RequestedPlaybackPosition: TimeSpan read get_RequestedPlaybackPosition;
  end;
  // Delegate for
  // Windows.Foundation.ITypedEventHandler<ABI.Windows.Media.SystemMediaTransportControls*, ABI.Windows.Media.PlaybackPositionChangeRequestedEventArgs*>
  TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsPlaybackPositionChangeRequestedEventArgs = interface(IUnknown)
  ['{44E34F15-BDC0-50A7-ACE4-39E91FB753F1}']
    procedure Invoke(sender: ISystemMediaTransportControls; args: IPlaybackPositionChangeRequestedEventArgs); safecall;
  end;

  // Windows.Media.IPlaybackRateChangeRequestedEventArgs
  IPlaybackRateChangeRequestedEventArgs = interface(IInspectable)
  ['{2CE2C41F-3CD6-4F77-9BA7-EB27C26A2140}']
    function get_RequestedPlaybackRate: double; safecall;
    property RequestedPlaybackRate: double read get_RequestedPlaybackRate;
  end;
  // Delegate for
  // Windows.Foundation.ITypedEventHandler<Windows.Media.SystemMediaTransportControls*, ABI.Windows.Media.PlaybackRateChangeRequestedEventArgs*>
  TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsPlaybackRateChangeRequestedEventArgs = interface(IUnknown)
  ['{15EB0182-6366-5B9F-BD8C-8AB4FA9D7CD9}']
    procedure Invoke(sender: ISystemMediaTransportControls; args: IPlaybackRateChangeRequestedEventArgs); safecall;
  end;

  // Windows.Media.IShuffleEnabledChangeRequestedEventArgs
  IShuffleEnabledChangeRequestedEventArgs = interface(IInspectable)
  ['{49B593FE-4FD0-4666-A314-C0E01940D302}']
    function get_RequestedShuffleEnabled: boolean; safecall;
    property RequestedShuffleEnabled: boolean read get_RequestedShuffleEnabled;
  end;
  // Delegate for
  // Windows.Foundation.ITypedEventHandler<ABI.Windows.Media.SystemMediaTransportControls*, ABI.Windows.Media.ShuffleEnabledChangeRequestedEventArgs*>
  TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsShuffleEnabledChangeRequestedEventArgs = interface(IUnknown)
  ['{17ECEA80-27E4-5DAE-ABB4-C858AD1C5307}']
    procedure Invoke(sender: ISystemMediaTransportControls; args: IShuffleEnabledChangeRequestedEventArgs); safecall;
  end;

  // Windows.Media.IAutoRepeatModeChangeRequestedEventArgs
  IAutoRepeatModeChangeRequestedEventArgs = interface(IInspectable)
  ['{EA137EFA-D852-438E-882B-C990109A78F4}']
    function get_RequestedAutoRepeatMode: MediaPlaybackAutoRepeatMode; safecall;
    property RequestedAutoRepeatMode: MediaPlaybackAutoRepeatMode read get_RequestedAutoRepeatMode;
  end;
  // Delegate for
  // Windows.Foundation.ITypedEventHandler<ABI.Windows.Media.SystemMediaTransportControls*, ABI.Windows.Media.AutoRepeatModeChangeRequestedEventArgs*>
  TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsAutoRepeatModeChangeRequestedEventArgs = interface(IUnknown)
  ['{A6214BDE-02D5-55B3-AB0D-C6031BE70DA1}']
    procedure Invoke(sender: ISystemMediaTransportControls; args: IAutoRepeatModeChangeRequestedEventArgs); safecall;
  end;

  // ISystemMediaTransportControls2
  // Windows.Media.SystemMediaTransportControls2
  ISystemMediaTransportControls2 = interface(IInspectable)
  ['{EA98D2F6-7F3C-4AF2-A586-72889808EFB1}']
    function get_AutoRepeatMode: MediaPlaybackAutoRepeatMode; safecall;
    procedure put_AutoRepeatMode(value: MediaPlaybackAutoRepeatMode); safecall;
    function get_ShuffleEnabled: boolean; safecall;
    procedure put_ShuffleEnabled(value: boolean); safecall;
    function get_PlaybackRate: double; safecall;
    procedure put_PlaybackRate(value: double); safecall;

    procedure UpdateTimelineProperties(timelineProperties: ISystemMediaTransportControlsTimelineProperties); safecall;

    function add_PlaybackPositionChangeRequested(handler: TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsPlaybackPositionChangeRequestedEventArgs): EventRegistrationToken; safecall;
    procedure remove_PlaybackPositionChangeRequested(token: EventRegistrationToken); safecall;
    function add_PlaybackRateChangeRequested(handler: TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsPlaybackRateChangeRequestedEventArgs): EventRegistrationToken; safecall;
    procedure remove_PlaybackRateChangeRequested(token: EventRegistrationToken); safecall;
    function add_ShuffleEnabledChangeRequested(handler: TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsShuffleEnabledChangeRequestedEventArgs): EventRegistrationToken; safecall;
    procedure remove_ShuffleEnabledChangeRequested(token: EventRegistrationToken); safecall;
    function add_AutoRepeatModeChangeRequested(handler: TypedEventHandler_2__ISystemMediaTransportControls__ISystemMediaTransportControlsAutoRepeatModeChangeRequestedEventArgs): EventRegistrationToken; safecall;
    procedure remove_AutoRepeatModeChangeRequested(token: EventRegistrationToken); safecall;

    property AutoRepeatMode: MediaPlaybackAutoRepeatMode read get_AutoRepeatMode write put_AutoRepeatMode;
    property ShuffleEnabled: boolean read get_ShuffleEnabled write put_ShuffleEnabled;
    property PlaybackRate: double read get_PlaybackRate write put_PlaybackRate;
  end;

  // Interop for MediaTransportControls
  [WinRTClassNameAttribute(SFactory_SystemMediaTransportControlsInterop)]
  ISystemMediaTransportControlsInterop = interface(IInspectable)
    ['{DDB0472D-C911-4A1F-86D9-DC3D71A95F5A}']
    function GetForWindow(appWindow: HWND; const riid: TGUID; out mediaTransportControl: ISystemMediaTransportControls): HRESULT; stdcall;
  end;

  TSystemMediaTransportControlsInterop = class(TWinRTGenericImportF<ISystemMediaTransportControlsInterop>) end;

implementation

end.
