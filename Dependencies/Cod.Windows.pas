unit Cod.Windows;

{$SCOPEDENUMS ON}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Win.Registry, Vcl.Dialogs, Vcl.Forms, UITypes, Types,
  Winapi.shlobj, Cod.Registry, IOUtils, Winapi.ActiveX, Win.ComObj,
  Winapi.ShellApi, Winapi.PsApi, Vcl.Imaging.pngimage,
  Cod.Graphics, Cod.Files, Cod.Types, Cod.MesssageConst, Winapi.TlHelp32,
  Cod.Windows.ThemeApi, Winapi.PropKey, Winapi.PropSys;

const
  LLKHF_ALTDOWN = KF_ALTDOWN shr 8;
  WH_KEYBOARD_LL = 13;

  EXTENDED_STARTUPINFO_PRESENT = $00080000;
  PROC_THREAD_ATTRIBUTE_PARENT_PROCESS = $00020000;

type
  // Proc
  TEnumerateWindowProc = reference to procedure(AWindow: HWND; var Continue: boolean);

  // Cardinals
  TWinPlatform = (Platform32, Platform64);
  TWinVersion = (Win2000, WinXp, WinXp64, Vista2008, Win72008R2, Win8, Win10);

  TWinUX = (ActionCenter, Notifications, Calculator, Store, Support, Maps,
    Network, Cast, Wifi, Project, Bluetooth, Clock, Xbox, MediaPlayer,
    Weather, TaskSwitch, Settings, ScreenClip, Photos, PrintQueue,
    WinDefender, StartMenu);

  TWinSettingsPage = (Home, FlightMode, Bluetooth, Cellular, Accounts,
    Language, Location, LockScreen, Hotspot, Notifications, Power, Privacy,
    Display, Wifi, Workplace);

  //
 TStartupInfoEx = record
    StartupInfo: TStartupInfo;
    lpAttributeList: PProcThreadAttributeList;
  end;

  // Keyboard stucts
  PKBDLLHOOKSTRUCT = ^TKBDLLHOOKSTRUCT;

  TKBDLLHOOKSTRUCT = packed record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;

  // TFileEx
  TFileEx = record
  private

  public
    class function Replace(ReplacedFile, ReplacedWithFile: string;
      IgnoreMetadataErrors: boolean=false): boolean; overload; static;
    class function Replace(ReplacedFile, ReplacedWithFile, BackupFile: string;
      IgnoreMetadataErrors: boolean=false): boolean; overload; static;

    class function FlushFileToDisk(FilePath: string): boolean; static;

    class function DeleteIfExists(FilePath: string): boolean; static;
  end;

  // Records
  TProcess = record
    Module,  // Exe name, eg. "explorer.exe"
    FileName, // Exe Location
    Command: string;
    PID, // App PID
    ParentPID, // Parent PID
    Modules, // Attatched DLLs
    Threads, // Thread Count
    Priority, // Process Priority
    Flags: integer;

    // Utils
    procedure CloseProcess;
    procedure KillProcess;
    function GetIcon: TIcon;
  end;

  TProcessList = TArray<TProcess>;

  TProcessListHelper = record helper for TProcessList
    function FindProcess(Executable: string): integer;
  end;

  // Process handle
  TProcessHandle = type THandle;
  TProcessHandleHelper = record helper for TProcessHandle
  public
    function GetModuleFilePath: string;
    function GetProcessName: string;
    function GetModuleName: string;
    function GetProcessID: DWORD;

    function IsValid: Boolean;
    function IsRunning: Boolean;

    // For applications
    function GetAppUserModelID: string;

    // Commands
    function Terminate(AExitCode: integer=1): boolean;

    // Main
    constructor Create(ProcessID: DWORD; Permissions: DWORD; InheritHandle: boolean);
    procedure CloseHandle; // must be called after tasks are done
  end;

  // Process ID
  TProcessID = type DWORD;
  TProcessIDHelper = record helper for TProcessID
  public
    // Information
    function Exists: Boolean;

    function GetParentPID: TProcessID;

    // Actions
    function Terminate(AExitCode: integer=1): boolean;

    // Get handle
      /// Possible permissions
      ///  PROCESS_CREATE_THREAD
      ///  PROCESS_VM_OPERATION
      ///  PROCESS_VM_READ
      ///  PROCESS_VM_WRITE
      ///  PROCESS_DUP_HANDLE
      ///  PROCESS_CREATE_PROCESS
      ///  PROCESS_SET_QUOTA
      ///  PROCESS_SET_INFORMATION
      ///  PROCESS_QUERY_INFORMATION
      ///  PROCESS_ALL_ACCESS
    function ProcessHandle(Permissions: DWORD): TProcessHandle;
    function ProcessHandleReadOnly: TProcessHandle;
    function ProcessHandleAllAcccess: TProcessHandle;
  end;

  // Handle helper
  THWNDHelper = record helper for HWND
  public
    // Information
    function GetTitle: string;
    function GetBoundsRect: TRect;
    function GetPosition: TPoint;
    function GetSize: TSize;
    function GetWindowProc: Pointer;

    function GetClientRect: TRect;
    function GetCanvas: TCanvas;
    function GetScreenToClient(P: TPoint): TPoint;
     function GetClientToScreen(P: TPoint): TPoint;
    function GetClassName: string;

    function GetAppUserModelID: string;

    // Set information
    procedure SetTitle(const S: string);
    procedure SetBoundsRect(const R: TRect);
    procedure SetPosition(P: TPoint);
    procedure SetSize(S: TSIze);
    function SetWindowProc(WndProc: Pointer): boolean;
    procedure SetTransparency(Level: Byte);

    // Z-Order
    procedure BringToFront;

    function GetNextWindow: HWND;
    function GetPreviousWindow: HWND;
    function GetOwnerWindow: HWND;

    // Styles
    function GetStyle: Nativeint;
    function GetExStyle: Nativeint;
    procedure SetStyle(Style: Nativeint);
    procedure SetExStyle(Style: Nativeint);
    function HasStyle(Style: Nativeint): Boolean;
    function HasExStyle(Style: Nativeint): Boolean;

    // Icons
    function GetSmallIcon: HICON;
    function GetLargeIcon: HICON;
    function GetSystemMenu(Reset: Boolean = False): HMENU;

    // Coordinates
    function ScreenPosInside(const P: TPoint): Boolean;

    // Messages
    function PostMessage(Message: UINT; wParam: WPARAM; lParam: LPARAM): longbool;
    function SendMessage(Message: UINT; wParam: WPARAM; lParam: LPARAM): int64;
    procedure PostCloseMessage;

    // Extras
    function GetModuleFilePathEx: string;

    // Process
    function GetProcessID: TProcessID;
    function GetThreadID: Cardinal;

    // Children
    function GetParentWindow: HWND;
    function GetChildWindows: TArray<HWND>;
    function GetChildWindowsEx: TArray<HWND>; // uses FindWindowEx

    //
    function ToString: string;
  end;


  // Shortcut manager
  TShellLinkFile = class
  private
    FShellLink: IShellLink;
    FMaxPath: integer;

    //
    function GetPathS: string;
    procedure SetPath(const Value: string);
    function GetArguments: string;
    function GetDescription: string;
    function GetHotkey: word;
    function GetIconLocation: string;
    function GetShowCmd: integer;
    function GetWorkingDirectory: string;
    procedure SetArguments(const Value: string);
    procedure SetDescription(const Value: string);
    procedure SetHotkey(const Value: word);
    procedure SetIconLocation(const Value: string);
    procedure SetRelativePath(const Value: string);
    procedure SetShowCmd(const Value: integer);
    procedure SetWorkingDirectory(const Value: string);
    function GetItemIDList: TItemIDList;
    procedure SetItemIDList(const Value: TItemIDList);

  public
    property Path: string read GetPathS write SetPath;
    property ItemIDList: TItemIDList read GetItemIDList write SetItemIDList;
    property Description: string read GetDescription write SetDescription;
    property WorkingDirectory: string read GetWorkingDirectory write SetWorkingDirectory;
    property Arguments: string read GetArguments write SetArguments;
    property Hotkey: word read GetHotkey write SetHotkey;
    property ShowCmd: integer read GetShowCmd write SetShowCmd;
    property IconLocation: string read GetIconLocation write SetIconLocation;
    property RelativePath: string write SetRelativePath;

    property MaxPath: integer read FMaxPath write FMaxPath default MAX_PATH;

    // Extended prop
    procedure GetIcon(out Path: string; out IconIndex: integer; MaxLength: integer = -1); // -1 to use the object's deafult
    procedure SetIcon(Path: string; IconIndex: integer);

    // Procs
    procedure SaveToFile(FilePath: string);
    procedure LoadFromFile(FilePath: string);

    // Constructors
    constructor Create;
    destructor Destroy; override;
  end;

const
  shlwapi = 'shlwapi.dll';


{ Forms }
/// <summary>
///  Remove the WS_CAPTION style flag from the form and make a border only form which supports Windows Aero.
///  </summary>
procedure MakeBorderForm(Form: TForm);

{ shlwapi }
function SHLoadIndirectString(pszSource: PWideChar; pszOutBuf: PWideChar; cchOutBuf: UINT; ppvReserved: Pointer): HRESULT; stdcall; external shlwapi;

{ Shell32 }
function HasAdministratorPrivileges: boolean;
function IsUserAnAdmin(): BOOL; external shell32;
function IsAdministrator32: boolean;
function SHDoDragDrop(Handle: hwnd; dataObj: IDataObject; dropSource: IDropSource;
  dwEffect: Longint; var pdwEffect: Longint): integer; stdcall; external shell32 name 'SHDoDragDrop';

{ AdvApi32 }
function CheckTokenMembership(TokenHandle: THANDLE; SidToCheck: Pointer;
  var IsMember: BOOL): BOOL; stdcall; external advapi32 name 'CheckTokenMembership'

{ Kernel32 }
function GetApplicationUserModelId(hProcess: THandle; var AppUserModelIdLength: DWORD; AppUserModelId: PWideChar): HRESULT; stdcall; external kernel32;

{ Resources }
function LoadIndirectString(const Source: string; var Output: string; BufferSize: cardinal=4096): boolean;

function LoadIndirectStringFromResourceID(const FilePath: string; const ResourceID: string; out Output: string): boolean; overload;
function LoadIndirectStringFromResourceID(const FilePath: string; const ResourceID: string; out Output: string; VersionModifier: string): boolean; overload;

{ Windows }
function GetWindowsPlatform: TWinVersion;
function IsWOW64Emulated: boolean;
function IsWow64Executable: Boolean;
function GetWindowsArhitecture: TWinPlatform;
function NTKernelVersion: single;

{ Personalisation }
procedure SetWallpaper(const FileName: string);
function DarkModeAppsActive: Boolean;
function DarkModeSystemActive: Boolean;
procedure DarkModeApplyToWindow(Handle: HWND); overload;
procedure DarkModeApplyToWindow(Handle: HWND; DarkTheme: boolean); overload;
function TransparencyEnabled: Boolean;
function GetAccentColor: TColor;

{ Shell }
function GetWinlogonShell: string;
function GetTaskbarHeight: integer;
procedure MinimiseAllWindows;
function IdleTime: DWord;
procedure FlashWindowInTaskbar;

{ User }
function GetUserCLSID: string;
function GetUserGUID: string; (* This currently seems to not work/ is unrelated to user picture tasks *)
/// <summary> Returns user name. The value used in the users folder and login. </summary>
function GetUserNameString: string;
/// <summary> Returns computer name. eg. "HOME-COMPUTER". </summary>
function GetComputerNameString: string;
/// <summary> Returns account name of computer name. eg. "COMPUTER-NAME\john-doe" </summary>
function GetComputerAccountName: string;
/// <summary> Returns account display name. eg. "John Doe" </summary>
function GetCompleteUserName: string;
/// <summary>
/// Get account profile picture based on the provided resolution.
///  These can by standard, be as follows: 1080, 448, 424, 208, 192, 96, 64, 48, 40, 32
/// </summary>
function GetUserProfilePicturePath(PrefferedResolution: string = '1080'): string;
/// <summary> [DEPRACATED] Returns user profile picture location based on old standard. </summary>
function GetUserProfilePictureEx: string;

{ Process }
/// <summary> Returns list of all running processes. </summary>
function GetProcessList: TProcessList;
/// <summary> Returns process ID (PID) of this application. </summary>
function ProcessID: TProcessID;
function GetCurrentAppName: string;
function GetOpenProgramFileName: string;
function GetOpenProgramFileNameEx: ansistring;
function GetActiveWindow: HWND;
function GetThreadWindows(ThreadId: DWORD): TArray<HWND>;
function GetActiveWindows: TArray<HWND>;
procedure EnumerateActiveWindows(Proc: TEnumerateWindowProc);

{ HWND }
function GetAppUserModelIDFromWindow(Window: HWND; out Output: string): boolean;
procedure BringToTopAndFocusWindow(Window: HWND);
procedure BringToTopAndFocusWindowAttachedThread(Window: HWND);
function GetHScrollPos(Handle: HWND): Integer;
function GetVScrollPos(Handle: HWND): Integer;
procedure OpenWindowSystemMenu(Handle: HWND);

{ Icons }
function GetIconStrIcon(IconString: string; Icon: TIcon): boolean; overload;
function GetIconStrIcon(IconString: string; PngImage: TPngImage): boolean; overload;
procedure GetFileIcon(FileName: string; PngImage: TPngImage; IconIndex: word = 0);
procedure GetFileIconEx(FileName: string; PngImage: TPngImage; IconIndex: word = 0; SmallIcon: boolean = false);
function GetFileIconCount(FileName: string): integer;
function GetAllFileIcons(FileName: string): TArray<TPngImage>;

{ Input }
procedure SimulateKeyPress32(key: Word; const shift: TShiftState; specialkey: Boolean);

{ Registry }
procedure RegisterApplicationPath(Name: string; Executable: string; Directory: string = '');
procedure UnregisterApplicationPath(Name: string);

{ Dialogs }
procedure OpenWindowsUI(WinInterface: TWinUX; SuppressAnimation: boolean = false);
procedure OpenWindowsSettings(Page: TWinSettingsPage);
procedure OpenWindowsUWPApp(AppURI: string);
procedure ShutDownWindows;

{ File and Folder Related Tasks }
procedure CreateShortcut(const Target, FilePath, Description, Parameters: string);
procedure ReadShortcut(const FilePath: string; var Target, Description, Parameters: string);
function GetFileTypeDescription(filetype: string): string;

{ Explorer }
function GetProcessIDFromExplorer: TProcessID;
procedure StartProcessAsUser(const AExeName: string);

{ Fonts }
function LoadFontFromResource(const ResName: string): Boolean;
function InstallFont(Path, DestFileName, RegistryKeyName: string; Global: Boolean): Boolean;
function InstallFontFromResourceName(ResourceName, DestFileName, RegistryKeyName: string;
  Global: Boolean): Boolean;
function UninstallFont(FontFileName, RegistryKeyName: string; Global: Boolean): Boolean;

{ COM }
function GetAvailableComPorts: TStringList;

{ Import for shell user run }
function GetShellWindow: HWND; stdcall; external user32;
function InitializeProcThreadAttributeList(lpAttributeList: PProcThreadAttributeList; dwAttributeCount, dwFlags: DWORD;
  var lpSize: Cardinal): ByteBool; stdcall; external kernel32;

function UpdateProcThreadAttribute(lpAttributeList: PProcThreadAttributeList; dwFlags: DWORD; Attribute: Cardinal;
  lpValue: Pointer; cbSize: Cardinal; lpPreviousValue: Pointer; lpReturnSize: PCardinal): ByteBool; stdcall;
  external kernel32;

procedure DeleteProcThreadAttributeList(lpAttributeList: PProcThreadAttributeList); stdcall; external kernel32;

const
  KEYEVENTF_KEYDOWN = 0; // declaration
  VK_ENTER = VK_RETURN;

implementation

uses
  Cod.SysUtils;

const
  USER_PROFILE_PICTURES_LOCATION = '%PUBLIC%\AccountPictures\';
  APP_PATH_REGISTER_LOCATION = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\';

procedure MakeBorderForm(Form: TForm);
var
  Style: Cardinal;
begin
  Style := GetWindowLong(Form.Handle, GWL_STYLE);

  // Remove caption bar
  Style := Style and not (WS_CAPTION) or WS_SIZEBOX;
  SetWindowLong(Form.Handle, GWL_STYLE, Style);

  // Crate
  Form.Perform(WM_NCCREATE, 0, 0);

  // Is minimised?
  if not IsIconic(Form.Handle) then
    // Re-calculate bounds
    SetWindowPos(Form.Handle, 0, Form.Left, Form.Top, Form.Width, Form.Height,
      SWP_NOZORDER or SWP_NOACTIVATE or SWP_FRAMECHANGED)
end;

function HasAdministratorPrivileges: boolean;
begin
  Result := IsUserAnAdmin;
end;

function IsAdministrator32: boolean;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority =
    (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
var
  AdminGroup: PSID;
  Res: longbool;
begin
  // IsUserAdmin from Shell32 also works
  if AllocateAndInitializeSid(
    SECURITY_NT_AUTHORITY, 2,
    SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
    0, 0, 0, 0, 0, 0, AdminGroup) then
  begin
    try
      CheckTokenMembership(0, AdminGroup, Res);
      Result := Res;
    finally
      FreeSid(AdminGroup);
    end;
  end
  else
    Result := False;
end;

function LoadIndirectString(const Source: string; var Output: string; BufferSize: cardinal): boolean;
var
  OutputBuffer: WideString;
begin
  // Create
  SetLength(OutputBuffer, BufferSize);
  ZeroMemory(@OutputBuffer[1], BufferSize);

  // SHLoadIndirectString
  Result := Succeeded(SHLoadIndirectString(PWideChar(Source), @OutputBuffer[1], BufferSize, nil));

  // Result
  if Result then
    Output := WideCharToString(@OutputBuffer[1]);
end;

function LoadIndirectStringFromResourceID(const FilePath: string; const ResourceID: string; out Output: string): boolean;
begin
  Result := LoadIndirectString(
    Format('@%S,%S', [FilePath, ResourceID]), Output
  );
end;

function LoadIndirectStringFromResourceID(const FilePath: string; const ResourceID: string; out Output: string; VersionModifier: string): boolean;
begin
  Result := LoadIndirectString(
    Format('@%S,%S;%S', [FilePath, ResourceID, VersionModifier]), Output
  );
end;

function GetWindowsPlatform: TWinVersion;
var
  NTKernel: single;
begin
  NTKernel := NTKernelVersion;
  if NTKernel <= 5  then
    Result := TWinVersion.Win2000
      else
        if NTKernel <= 5.1 then
          Result := TWinVersion.WinXp
            else
              if NTKernel <= 5.2 then
                Result := TWinVersion.WinXp64
                  else
                    if NTKernel <= 6.0 then
                      Result := TWinVersion.Vista2008
                        else
                          if NTKernel <= 6.1 then
                            Result := TWinVersion.Win72008R2
                              else
                                if NTKernel <= 6.2 then
                                  Result := TWinVersion.Win8
                                    else
                                      Result := TWinVersion.Win10;
end;

function IsWOW64Emulated: Boolean;
var
  IsWow64: BOOL;
begin
  // Check if the current process is running under WOW64
  if IsWow64Process(GetCurrentProcess, IsWow64) then
    Result := IsWow64
  else
    Result := False;
end;

function IsWow64Executable: Boolean;
type
  TIsWow64Process = function(AHandle: DWORD; var AIsWow64: BOOL): BOOL; stdcall;

var
  hIsWow64Process: TIsWow64Process;
  hKernel32: DWORD;
  IsWow64: BOOL;

begin
  Result := True;

  hKernel32 := Winapi.Windows.LoadLibrary('kernel32.dll');
  if hKernel32 = 0 then Exit;

  try
    @hIsWow64Process := Winapi.Windows.GetProcAddress(hKernel32, 'IsWow64Process');
    if not System.Assigned(hIsWow64Process) then
      Exit;

    IsWow64 := False;
    if hIsWow64Process(Winapi.Windows.GetCurrentProcess, IsWow64) then
      Result := not IsWow64;

  finally
    Winapi.Windows.FreeLibrary(hKernel32);
  end;
end;

function GetWindowsArhitecture: TWinPlatform;
begin
  if IsWOW64Emulated or IsWow64Executable then
    Result := TWinPlatform.Platform64
  else
    Result := TWinPlatform.Platform32;
end;

function NTKernelVersion: single;
begin
  Result := Win32MajorVersion + Win32MinorVersion / 10;
end;

function IdleTime: DWord;
var
  LastInput: TLastInputInfo;
begin
  LastInput.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(LastInput);
  Result := (GetTickCount - LastInput.dwTime) DIV 1000;
end;

procedure FlashWindowInTaskbar;
var
  Flash: FLASHWINFO;
begin
  FillChar(Flash, SizeOf(Flash), 0);
  Flash.cbSize := SizeOf(Flash);
  Flash.hwnd := Application.Handle;
  Flash.uCount := 5;
  Flash.dwTimeOut := 2000;
  Flash.dwFlags := FLASHW_ALL;
  FlashWindowEx(Flash);
end;

function GetAccentColor: TColor;
var
  R: TRegistry;
  ARGB: Cardinal;
begin
  Result := $D77800;  //  Default value on error
  R := TRegistry.Create;
  try
    R.RootKey := HKEY_CURRENT_USER;
    if R.OpenKeyReadOnly('Software\Microsoft\Windows\DWM\') and R.ValueExists('AccentColor') then begin
      ARGB := R.ReadCardinal('AccentColor');
      Result := ARGB mod $FF000000; //  ARGB to RGB
    end;
  finally
    R.Free;
  end;
end;

function DarkModeAppsActive: Boolean;
begin
  Result := Cod.Windows.ThemeApi.ShouldAppsUseDarkMode;
end;

function DarkModeSystemActive: Boolean;
begin
  Result := Cod.Windows.ThemeApi.ShouldSystemUseDarkMode;
end;
procedure DarkModeApplyToWindow(Handle: HWND);
begin
  DarkModeApplyToWindow(Handle, DarkModeAppsActive);
end;

procedure DarkModeApplyToWindow(Handle: HWND; DarkTheme: boolean); overload;
var
  Value: longbool;
begin
  Value := DarkTheme; // must be longbool

  DwmSetWindowAttribute(Handle, ImmersiveDarkMode, Value, SizeOf(Value));
  AllowDarkModeForWindow(Handle, Value);
  AllowDarkModeForApp(Value);
end;

function TransparencyEnabled: Boolean;
begin
  Result := TQuickReg.GetBoolValue('Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\', 'EnableTransparency');
end;

function GetUserNameString: string;
var
  dwSize: DWORD;
begin
  // Get size
  dwSize := 0;
  GetUserName(nil, dwSize);

  // None
  if dwSize = 0 then
    Exit('');

  // Provide address
  SetLength(Result, dwSize-1); // exclude null-terminated
  if not GetUserName(PWideChar(Result), dwSize) then
    RaiseLastOSError;
end;

function GetComputerNameString: string;
const
  nameType = TComputerNameFormat.ComputerNameNetBIOS;
var
  dwSize: DWord;
begin
  // Get size
  dwSize := 0;
  GetComputerNameEx(nameType, nil, dwSize);

  // None
  if dwSize = 0 then
    Exit('');

  // Provide address
  SetLength(Result, dwSize-1); // exclude null-terminated
  if not {$IF CompilerVersion <= 35.0}longbool({$IFEND}
    GetComputerNameEx(nameType, PWideChar(Result), dwSize)
    {$IF CompilerVersion <= 35.0}){$IFEND} then
    RaiseLastOSError;
end;

function GetComputerAccountName: string;
const
  nameType = EXTENDED_NAME_FORMAT.NameSamCompatible;
var
  dwSize: DWORD;
begin
  // Get size
  dwSize := 0;
  GetUserNameEx(nameType, nil, dwSize);

  // None
  if dwSize = 0 then
    Exit('');

  // Provide address
  SetLength(Result, dwSize-1); // exclude null-terminated
  if not {$IF CompilerVersion <= 35.0}longbool({$IFEND}
    GetUserNameEx(nameType, PWideChar(Result), dwSize)
    {$IF CompilerVersion <= 35.0}){$IFEND} then
    RaiseLastOSError;
end;

function GetCompleteUserName: string;
const
  nameType = NameDisplay;
var
  dwSize: DWORD;
begin
  // Get size
  dwSize := 0;
  GetUserNameEx(nameType, nil, dwSize);

  // None
  if dwSize = 0 then
    Exit('');

  // Provide address
  SetLength(Result, dwSize-1); // exclude null-terminated
  if not {$IF CompilerVersion <= 35.0}longbool({$IFEND}
    GetUserNameEx(nameType, PWideChar(Result), dwSize)
    {$IF CompilerVersion <= 35.0}){$IFEND} then
    RaiseLastOSError;
end;

function GetFileTypeDescription(filetype: string): string;
begin
  if filetype = '' then
    Exit('File Folder');

  Result := STRING_UNKNOWN;
end;

function GetProcessIDFromExplorer: TProcessID;
var
  Handle: THandle;
  ProcEntry: TProcessEntry32;
begin
  Result := 0;

  Handle := CreateToolHelp32SnapShot(TH32CS_SNAPALL, 0);
  ProcEntry.dwSize := SizeOf(TProcessEntry32);
  Process32First(Handle, ProcEntry);

  repeat
    if SameText(ProcEntry.szExeFile, 'explorer.exe') then
      Exit(ProcEntry.th32ProcessID);
  until not Process32Next(Handle, ProcEntry);

  CloseHandle(Handle);
end;

procedure StartProcessAsUser(const AExeName: string);
var
  ProcessInformation: TProcessInformation;
  hProcess, Pid, Size: Cardinal;
  StartupInfoEx: TStartupInfoEx;
begin
  ZeroMemory(@StartupInfoEx, SizeOf(StartupInfoEx));
  // explorer.exe handle
  // according to @RbMm you can use the line below
  // GetWindowThreadProcessId(GetShellWindow, Pid);
  // but for some strange reason it's not working for me. So I used
  GetWindowThreadProcessId(GetShellWindow, Pid);

  hProcess := OpenProcess(PROCESS_CREATE_PROCESS, False, Pid);

  InitializeProcThreadAttributeList(nil, 1, 0, Size);
  GetMem(StartupInfoEx.lpAttributeList, Size);
  InitializeProcThreadAttributeList(StartupInfoEx.lpAttributeList, 1, 0, Size);
  UpdateProcThreadAttribute(StartupInfoEx.lpAttributeList, 0, PROC_THREAD_ATTRIBUTE_PARENT_PROCESS, @hProcess,
    SizeOf(THandle), nil, nil);

  with StartupInfoEx.StartupInfo do
  begin
    cb := SizeOf(TStartupInfoEx);
    wShowWindow := SW_SHOWNORMAL;
  end;

  try
    if not CreateProcess(PChar(AExeName), nil, nil, nil, False,
      EXTENDED_STARTUPINFO_PRESENT, nil, nil, StartupInfoEx.StartupInfo, ProcessInformation) then
      RaiseLastOSError;
  finally
    DeleteProcThreadAttributeList(StartupInfoEx.lpAttributeList);
    FreeMem(StartupInfoEx.lpAttributeList);
    CloseHandle(hProcess);
  end;
end;

function LoadFontFromResource(const ResName: string): Boolean;
var
  RS: TResourceStream;
  FontCount: DWORD;
begin
  RS := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
  try
    FontCount := 0;

    Result := AddFontMemResourceEx(
      RS.Memory,
      RS.Size,
      nil,
      @FontCount
    ) <> 0;
  finally
    RS.Free;
  end;

  if Result then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

function GetUserFontsDir: string;
begin
  Result := TPath.Combine(
    TPath.GetHomePath,
    'AppData\Local\Microsoft\Windows\Fonts'
  );
end;

function InstallFont(Path, DestFileName, RegistryKeyName: string; Global: Boolean): Boolean;
var
  DestPath: string;
  Reg: TRegistry;
  FontsKey: HKEY;
begin
  Result := False;

  if not FileExists(Path) then
    Exit;

  if Global then
  begin
    DestPath := IncludeTrailingPathDelimiter(ReplaceWinPath('%WINDIR%')) +
      'Fonts\' + DestFileName;

    FontsKey := HKEY_LOCAL_MACHINE;
  end
  else
  begin
    ForceDirectories(GetUserFontsDir);

    DestPath := TPath.Combine(
      GetUserFontsDir,
      DestFileName
    );

    FontsKey := HKEY_CURRENT_USER;
  end;

  // Add to registry
  Reg := TRegistry.Create;
  try
    Reg.RootKey := FontsKey;

    if Reg.OpenKey(
      'Software\Microsoft\Windows NT\CurrentVersion\Fonts',
      True
    ) then
    try
      // Exists?
      if TFile.Exists(DestPath) then
        Exit(false);
      if Reg.ValueExists(RegistryKeyName) then
        Exit(false);

      // Copy
      TFile.Copy(Path, DestPath, True);

      // Write to registry
      Reg.WriteString(
        RegistryKeyName,
        DestFileName
      );

    finally
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  // Update
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);

  Result := True;
end;

function InstallFontFromResourceName(ResourceName, DestFileName, RegistryKeyName: string;
  Global: Boolean): Boolean;
var
  RS: TResourceStream;
  TempFile: string;
begin
  TempFile := TPath.Combine(
    TPath.GetTempPath,
  ResourceName + '_install.ttf'
  );

  RS := TResourceStream.Create(
    HInstance,
    ResourceName,
    RT_RCDATA
  );
  try
    RS.SaveToFile(TempFile);
  finally
    RS.Free;
  end;

  Result := InstallFont(TempFile, DestFileName, RegistryKeyName, Global);

  DeleteFile(TempFile);
end;

function UninstallFont(FontFileName, RegistryKeyName: string;
  Global: Boolean): Boolean;
var
  FontPath: string;
  Reg: TRegistry;
  FontsKey: HKEY;
begin
  if Global then
  begin
    FontPath := IncludeTrailingPathDelimiter(ReplaceWinPath('%WINDIR%')) +
      'Fonts\' + FontFileName;

    FontsKey := HKEY_LOCAL_MACHINE;
  end
  else
  begin
    FontPath := TPath.Combine(
      GetUserFontsDir,
      FontFileName
    );

    FontsKey := HKEY_CURRENT_USER;
  end;

  // Remove from registry
  Reg := TRegistry.Create;
  try
    Reg.RootKey := FontsKey;

    if Reg.OpenKey(
      'Software\Microsoft\Windows NT\CurrentVersion\Fonts',
      False
    ) then
    begin
      if Reg.ValueExists(RegistryKeyName) then
        Reg.DeleteValue(RegistryKeyName);

      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  // Delete font
  DeleteFile(FontPath);

  // Update
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);

  Result := True;
end;

function GetAvailableComPorts: TStringList;
var
  Buffer: array[0..65535] of Char;
  P: PChar;
begin
  Result := TStringList.Create;
  FillChar(Buffer, SizeOf(Buffer), 0);
  if QueryDosDevice(nil, Buffer, SizeOf(Buffer)) <> 0 then
  begin
    P := Buffer;
    while P^ <> #0 do
    begin
      // COM ports are usually named like "COM1", "COM2", etc.
      if Pos('COM', UpperCase(P)) = 1 then
        Result.Add(P);
      Inc(P, StrLen(P) + 1);
    end;
  end;
end;

function GetWinlogonShell: string;
begin
  Result := TQuickReg.GetStringValue('Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', 'Shell');
end;

function GetTaskbarHeight: integer;
var
  R: TRect;
begin
  SystemParametersInfo (Spi_getworkarea,0,@r,0);
  Result:=screen.Height-r.Bottom;
end;

function GetCurrentAppName: string;
var
  h: hWnd;
begin
  h := GetForegroundWindow;
  SetLength(Result, GetWindowTextLength(h) + 1);
  GetWindowText(h, PChar(Result), GetWindowTextLength(h) + 1);
  Result := Result.TrimRight;
end;

function GetOpenProgramFileName: String;
var
  pid     : DWORD;
  hProcess: THandle;
  path    : array[0..4095] of Char;
begin
  GetWindowThreadProcessId(GetForegroundWindow, pid);

  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, pid);
  if hProcess <> 0 then
    try
      if GetModuleFileNameEx(hProcess, 0, @path[0], Length(path)) = 0 then
        RaiseLastOSError;

      result := path;
    finally
      CloseHandle(hProcess);
    end
  else
    RaiseLastOSError;
end;

Function GetOpenProgramFileNameEx : ansistring;
var
  S : array[0..max_path] of char; // somplace to put the answer
  H : longword; // the window to be trapped
begin
  H := getforegroundwindow;
  Getwindowmodulefilename(h,s,max_path);
  result := ansistring(S);
end;

function GetActiveWindow: HWND;
begin
  Result := GetForegroundWindow;
end;

  function GetActiveWindows_EnumWindowsCallback_Process(Wnd: HWND; lParam: LPARAM): BOOL; stdcall;
  type
    AType = TArray<HWND>;
    ATypeP = ^AType;
  var
    ArrayP: ATypeP;
  begin
    ArrayP := ATypeP(lParam);
    const Index = Length(ArrayP^);
    SetLength(ArrayP^, Index+1);
    ArrayP^[Index] := Wnd;

    Result := true;
  end;

function GetThreadWindows(ThreadId: DWORD): TArray<HWND>;
begin
  Result := [];
  EnumThreadWindows(ThreadId, @GetActiveWindows_EnumWindowsCallback_Process, LPARAM(@Result));
end;

function GetActiveWindows: TArray<HWND>;
begin
  Result := [];
  EnumWindows(@GetActiveWindows_EnumWindowsCallback_Process, LPARAM(@Result));
end;

  function EnumerateActiveWindows_EnumWindowsCallback_Process(Wnd: HWND; lParam: LPARAM): BOOL; stdcall;
  var
    Continue: boolean;
  begin
    Continue:= true;
    TEnumerateWindowProc(lParam)(Wnd, Continue);
    Result := Continue;
  end;
procedure EnumerateActiveWindows(Proc: TEnumerateWindowProc);
begin
  EnumWindows(@EnumerateActiveWindows_EnumWindowsCallback_Process, LPARAM( TEnumerateWindowProc(Proc) ));
end;

function GetAppUserModelIDFromWindow(Window: HWND; out Output: string): boolean;
var
  propStore: IPropertyStore;
  propVariant: TPropVariant;
begin
  Result := false;
  Output := '';

  // Get prop store
  if not Succeeded(SHGetPropertyStoreForWindow(Window, IID_IPropertyStore, Pointer(propStore))) then
    Exit;

  // Assert
  ZeroMemory(@propVariant, SizeOf(propVariant));
  try
    if not Succeeded(propStore.GetValue(PKEY_AppUserModel_ID, propVariant)) then
      Exit;

    // Variant type
    case propVariant.vt of
      VT_EMPTY: Output := ''; // result false
      VT_BSTR: begin
        Result := true;
        Output := string(propVariant.bstrVal);
      end;
      VT_LPWSTR: begin
        Result := true;
        Output := string(propVariant.pwszVal);
      end;

      //else ;
    end;
  finally
    PropVariantClear(propVariant);
  end;
end;

procedure BringToTopAndFocusWindow(Window: HWND);
begin
  SendMessage(Window, WM_SYSCOMMAND, SC_RESTORE, 0); // restore a minimize window
  SetForegroundWindow(Window);
  SetActiveWindow(Window);
  SetWindowPos(Window, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOMOVE or SWP_NOSIZE);

  //redraw to prevent the window blank.
  RedrawWindow(Window, nil, 0, RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN );
end;

procedure BringToTopAndFocusWindowAttachedThread(Window: HWND);
var
  ForeThread, ThisThread: DWORD;
begin
  ForeThread := GetWindowThreadProcessId(GetForegroundWindow(), nil);
  ThisThread := GetCurrentThreadId();

  if AttachThreadInput(ThisThread, ForeThread, True) then begin
    SetForegroundWindow(Window);
    SetActiveWindow(Window);
    BringWindowToTop(Window);
    //
    AttachThreadInput(ThisThread, ForeThread, False);
  end;
end;

function GetHScrollPos(Handle: HWND): Integer;
var
  SI: TScrollInfo;
begin
  SI.cbSize := SizeOf(SI);
  SI.fMask  := SIF_POS;
  if GetScrollInfo(Handle, SB_HORZ, SI) then
    Result := SI.nPos
  else
    Result := 0;
end;

function GetVScrollPos(Handle: HWND): Integer;
var
  SI: TScrollInfo;
begin
  SI.cbSize := SizeOf(SI);
  SI.fMask  := SIF_POS;
  if GetScrollInfo(Handle, SB_VERT, SI) then
    Result := SI.nPos
  else
    Result := 0;
end;

procedure OpenWindowSystemMenu(Handle: HWND);
begin
  SendMessage(Handle, WM_SYSCOMMAND, SC_KEYMENU, VK_SPACE);
end;

function GetIconStrIcon(IconString: string; Icon: TIcon): boolean; overload;
var
  IconIndex: integer;
  lpIcon: word;
  FilePath: string;
begin
  Result := false;

  // Load
  ExtractIconDataEx(IconString, FilePath, IconIndex);
  if not TFile.Exists(FilePath) then
    Exit;
  if IconIndex < 0 then
    lpIcon := 0 // resource index -- not supported atm.
  else
    lpIcon := IconIndex;

  // Get TIcon
  Icon.Handle := ExtractAssociatedIcon(HInstance, PChar(FilePath), lpIcon);
  Icon.Transparent := true;

  // Success
  Result := true;
end;

function GetIconStrIcon(IconString: string; PngImage: TPngImage): boolean;
var
  Icon: TIcon;
begin
  // Get TIcon
  Icon := TIcon.Create;
  try
    Result := GetIconStrIcon(IconString, Icon);

    // Convert to PNG
    ConvertToPNG(Icon, PngImage);
  finally
    Icon.Free;
  end;
end;

procedure GetFileIcon(FileName: string; PngImage: TPngImage; IconIndex: word);
var
  ic: TIcon;
begin
  // Get TIcon
  ic := TIcon.Create;
  try
    ic.Handle := ExtractAssociatedIcon(HInstance, PChar(FileName), IconIndex);
    ic.Transparent := true;

    // Convert to PNG
    ConvertToPNG(ic, PngImage);
  finally
    ic.Free;
  end;
end;

procedure GetFileIconEx(FileName: string; PngImage: TPngImage; IconIndex: word;
  SmallIcon: boolean);
var
  ic: TIcon;
  SHFileInfo: TSHFileInfo;
  Flags: Cardinal;
begin
  Flags := SHGFI_ICON or SHGFI_USEFILEATTRIBUTES;
  if SmallIcon then
    Flags := Flags or SHGFI_SMALLICON
  else
    Flags := Flags or SHGFI_LARGEICON;

  SHGetFileInfo(PChar(FileName), 0, SHFileInfo, SizeOf(TSHFileInfo),
    Flags);

  // Get TIcon
  ic := TIcon.Create;
  try
    ic.Handle := SHFileInfo.hIcon;;
    ic.Transparent := true;

    // Convert to PNG
    PngImage := TPngImage.Create;

    ConvertToPNG(ic, PngImage);
  finally
    ic.Free;
  end;
end;

function GetFileIconCount(FileName: string): integer;
begin
  Result := ExtractIcon(0, PChar(FileName), Cardinal(-1));
end;

function GetAllFileIcons(FileName: string): TArray<TPngImage>;
var
  cnt: integer;
  I: Integer;
begin
  // Get Count
  cnt := GetFileIconCount(FileName);

  SetLength(Result, cnt);

  for I := 0 to cnt - 1 do
    begin
      Result[I] := TPngImage.Create;

      try
        GetFileIcon(FileName, Result[I], I);
      except
        // Invalid icon handle
      end;
    end;
end;

function GetUserCLSID: string;
var
  UserName, DomainName: string;
  UserSID: PSID;
  SIDSize: DWORD;
  SIDString: PChar;
  DomainSize: DWORD;
  SIDUse: SID_NAME_USE;
begin
  // Get the name of the currently logged-in user
  Username := GetUserNameString;

  // Lookup the account SID associated with the user name
  SIDSize := 0;
  DomainSize := 0;
  LookupAccountName(nil, PChar(UserName), nil, SIDSize, nil, DomainSize, SIDUse);
  UserSID := AllocMem(SIDSize);
  try
    SetLength(DomainName, DomainSize);
    if not LookupAccountName(nil, PChar(UserName), UserSID, SIDSize, PChar(DomainName),
        DomainSize, SIDUse) then
      RaiseLastOSError;

    // Convert the binary SID to a string format
    if not ConvertSidToStringSid(UserSID, SIDString) then
      RaiseLastOSError;
    try
      Result := SIDString;
    finally
      LocalFree(HLOCAL(SIDString));
    end;
  finally
    FreeMem(UserSID);
  end;
end;

function GetUserGUID: string;
var
  guid: TGUID;
begin
  if CoCreateGuid(guid) <> S_OK then
    RaiseLastOSError;
  Result := GUIDToString(guid);
end;

function GetUserProfilePicturePath(PrefferedResolution: string): string;
var
  L: TArray<string>;
  Path: string;
  Index: integer;
  I: Integer;
begin
  Path := IncludeTrailingPathDelimiter( ReplaceWinPath(USER_PROFILE_PICTURES_LOCATION) ) +
           GetUserCLSID + '\';

  L := TDirectory.GetFiles( Path );

  Index := 0;
  if Length( L ) > 0 then
    begin
      for I := 0 to High(L) do
        if Pos( 'Image' + PrefferedResolution, L[I]) <> 0 then
          begin
            Index := I;

            Break;
          end;

      Result := L[Index];
    end
      else
        Result := '';
end;

function GetUserProfilePictureEx: string;
begin
  Result :=
    IncludeTrailingPathDelimiter( GetUserShellLocation(TUserShellLocation.LocalAppData) )
      + 'Microsoft\Windows\AccountPicture\UserImage.jpg';
end;

procedure SetWallpaper(const FileName: string);
begin
  if not SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, PChar(FileName), SPIF_UPDATEINIFILE) then
    raise Exception.Create(ERROR_SET_WALLPAPER);
end;

procedure MinimiseAllWindows;
var
  hTaskBar: HWND;
begin
  hTaskBar := FindWindow('Shell_TrayWnd', nil);
  if hTaskBar <> 0 then
    SendMessage(hTaskBar, WM_COMMAND, MAKEWPARAM(419, 0), 0);
end;

function ProcessID: TProcessID;
begin
  Result := GetCurrentProcessId;
end;

function GetProcessList: TArray<TProcess>;
var
  hSnapshot: THandle;
  pe: TProcessEntry32;
  hProcess: THandle;
  bMore: BOOL;
  szProcessName: array[0..MAX_PATH] of Char;
  lpAddress, lpCommandLine: Pointer;
  dwRead: NativeUInt;
  szCommandLine: array[0..4096] of Char;

  Index: integer;
begin
  SetLength(Result, 0);

  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  pe.dwSize := SizeOf(TProcessEntry32);
  bMore := Process32First(hSnapshot, pe);
  while bMore do
  begin
    // Size
    Index := Length(Result);
    SetLength(Result, Index+1);

    // Module
    Result[Index].Module := pe.szExeFile;
    Result[Index].PID := pe.th32ProcessID;
    Result[Index].Modules := pe.th32ModuleID;
    Result[Index].Threads := pe.cntThreads;
    Result[Index].ParentPID := pe.th32ParentProcessID;
    Result[Index].Priority := pe.pcPriClassBase;
    Result[Index].Flags := pe.dwFlags;

    hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or
      PROCESS_VM_READ, False, pe.th32ProcessID);
    if hProcess <> 0 then
    begin
      // Path
      GetModuleFileNameEx(hProcess, 0, szProcessName, SizeOf(szProcessName));
      Result[Index].FileName := szProcessName;

      // Command
      lpAddress := GetProcAddress(GetModuleHandle('kernel32.dll'), 'GetCommandLineA');
      if lpAddress <> nil then
      begin
        // Read the process memory at the address of GetCommandLineA to get the command line
        lpCommandLine := nil; // Initialize the pointer
        if ReadProcessMemory(hProcess, lpAddress, @lpCommandLine, SizeOf(lpCommandLine), dwRead) then
        begin
          // Read the actual command line from the memory pointed to by lpCommandLine
          dwRead := 0;
          if ReadProcessMemory(hProcess, lpCommandLine, @szCommandLine, SizeOf(szCommandLine), dwRead) then
            Result[Index].Command := szCommandLine;
        end;
      end;

      // Close
      CloseHandle(hProcess);
    end;

    // Next
    bMore := Process32Next(hSnapshot, pe);
  end;
  CloseHandle(hSnapshot);
end;

procedure SimulateKeyPress32(key: Word; const shift: TShiftState;
  specialkey: Boolean);
type
  TShiftKeyInfo = record
    shift: Byte;
    vkey: Byte;
  end;
  ByteSet = set of 0..7;
const
  shiftkeys: array [1..3] of TShiftKeyInfo = (
    (shift: Ord(ssCtrl) ; vkey: VK_CONTROL),
    (shift: Ord(ssShift) ; vkey: VK_SHIFT),
    (shift: Ord(ssAlt) ; vkey: VK_MENU)
  );
var
  flag: DWORD;
  bShift: ByteSet absolute shift;
  j: Integer;
begin
  for j := 1 to 3 do
  begin
    if shiftkeys[j].shift in bShift then
      keybd_event(
        shiftkeys[j].vkey, MapVirtualKey(shiftkeys[j].vkey, 0), 0, 0
    );
  end;
  if specialkey then
    flag := KEYEVENTF_EXTENDEDKEY
  else
    flag := 0;

  keybd_event(key, MapvirtualKey(key, 0), flag, 0);
  flag := flag or KEYEVENTF_KEYUP;
  keybd_event(key, MapvirtualKey(key, 0), flag, 0);

  for j := 3 downto 1 do
  begin
    if shiftkeys[j].shift in bShift then
      keybd_event(
        shiftkeys[j].vkey,
        MapVirtualKey(shiftkeys[j].vkey, 0),
        KEYEVENTF_KEYUP,
        0
      );
  end;
end;

procedure RegisterApplicationPath(Name: string; Executable: string; Directory: string);
const
  N_PATH = 'Path';
var
  R: TWinRegistry;
begin
  const RegPath = APP_PATH_REGISTER_LOCATION + Name + '\';

  R := TWinRegistry.Create;
  try
    if not R.KeyExists(RegPath) then
      R.CreateKey(RegPath);

    R.WriteValue(RegPath, '', Executable);

    if Directory <> '' then
      R.WriteValue(RegPath, N_PATH, Directory)
    else
      if R.GetValueExists(RegPath, N_PATH) then
        R.DeleteValue(Regpath, N_PATH);
  finally
    R.Free;
  end;
end;

procedure UnregisterApplicationPath(Name: string);
begin
  const RegPath = APP_PATH_REGISTER_LOCATION + Name + '\';
  if TQuickReg.KeyExists(RegPath) then
    TQuickReg.DeleteKey(RegPath);
end;

procedure OpenWindowsUI(WinInterface: TWinUX; SuppressAnimation: boolean);
var
  URI, PARAM: string;
begin
  URI := '';
  PARAM := '';

  case WinInterface of
    TWinUX.ActionCenter: URI := 'ms-actioncenter:controlcenter/&suppressAnimations=' + BooleanToString(SuppressAnimation);
    TWinUX.Notifications: URI := 'ms-actioncenter://';
    TWinUX.Calculator: URI := 'ms-calculator://';
    TWinUX.Store: URI := 'ms-windows-store://';
    TWinUX.Support: URI := 'ms-contact-support://';
    TWinUX.Maps: URI := 'ms-drive-to://';
    TWinUX.Network: URI := 'ms-availablenetworks://';
    TWinUX.Cast: URI := 'ms-actioncenter:controlcenter/cast&suppressAnimations=' + BooleanToString(SuppressAnimation);
    TWinUX.Wifi: URI := 'ms-actioncenter:controlcenter/wifi&suppressAnimations=' + BooleanToString(SuppressAnimation);
    TWinUX.Project: URI := 'ms-actioncenter:controlcenter/project&suppressAnimations=' + BooleanToString(SuppressAnimation);
    TWinUX.Bluetooth: URI := 'ms-actioncenter:controlcenter/bluetooth&suppressAnimations=' + BooleanToString(SuppressAnimation);
    TWinUX.Clock: URI := 'ms-clock://';
    TWinUX.Xbox: URI := 'msxbox://';
    TWinUX.MediaPlayer: URI := 'ms-playto-audio://';
    TWinUX.Weather: URI := 'msnweather://';
    TWinUX.TaskSwitch: URI := 'ms-taskswitcher://';
    TWinUX.Settings: URI := 'ms-settings://';
    TWinUX.ScreenClip: URI := 'ms-screenclip://';
    TWinUX.Photos: URI := 'ms-photos://';
    TWinUX.PrintQueue: URI := 'ms-print-queue://';
    TWinUX.WinDefender: URI := 'windowsdefender://';
    TWinUX.StartMenu: SimulateKeyPress32( VK_LWIN, [], true);
  end;

  // Run
  if URI <> '' then
    ShellExecute(0, 'open', PChar(URI), PCHAR(PARAM), nil, 0);
end;

procedure OpenWindowsSettings(Page: TWinSettingsPage);
var
  URI: string;
begin
  case Page of
    TWinSettingsPage.Home: URI := 'ms-settings://';
    TWinSettingsPage.FlightMode: URI := 'ms-settings-airplanemode://';
    TWinSettingsPage.Bluetooth: URI := 'ms-settings-bluetooth://';
    TWinSettingsPage.Cellular: URI := 'ms-settings-cellular://';
    TWinSettingsPage.Accounts: URI := 'ms-settings-emailandaccounts://';
    TWinSettingsPage.Language: URI := 'ms-settings-language://';
    TWinSettingsPage.Location: URI := 'ms-settings-location://';
    TWinSettingsPage.LockScreen: URI := 'ms-settings-lock://';
    TWinSettingsPage.Hotspot: URI := 'ms-settings-mobilehotspot://';
    TWinSettingsPage.Notifications: URI := 'ms-settings-notifications://';
    TWinSettingsPage.Power: URI := 'ms-settings-power://';
    TWinSettingsPage.Privacy: URI := 'ms-settings-privacy://';
    TWinSettingsPage.Display: URI := 'ms-settings-screenrotation://';
    TWinSettingsPage.Wifi: URI := 'ms-settings-wifi://';
    TWinSettingsPage.Workplace: URI := 'ms-settings-workplace://';
  end;

  // Run
  ShellExecute(0, 'open', PChar(URI), '', nil, 0);
end;

procedure OpenWindowsUWPApp(AppURI: string);
var
  URI: string;
begin
  URI := AppURI + '://';

  ShellExecute(0, 'open', PChar(URI), PCHAR(URI), nil, 0);
end;

procedure ShutDownWindows;
begin
  ShellExecute(0, 'open', 'powershell', '-c "(New-Object -Com Shell.Application).ShutdownWindows()"', nil, 0);
end;

procedure CreateShortcut(const Target, FilePath, Description, Parameters: string);
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
begin
  IObject:=CreateComObject(CLSID_ShellLink);
  SLink:=IObject as IShellLink;
  PFile:=IObject as IPersistFile;
  with SLink do
  begin
    SetPath(PChar(Target));
    SetDescription(PChar(Description));
    SetArguments(PChar(Parameters));

    SetWorkingDirectory(PChar(ExtractFileDir(Target)));
  end;
  PFile.Save(PWChar(WideString(FilePath)), FALSE);
end;

procedure ReadShortcut(const FilePath: string; var Target, Description, Parameters: string);
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;

  S: WideString;
  T: string;
begin
  IObject:=CreateComObject(CLSID_ShellLink);
  SLink:=IObject as IShellLink;
  PFile:=IObject as IPersistFile;
  PFile.Load(PWChar(WideString(FilePath)), STGM_READ);

  with SLink do begin
    SetLength(S, MAX_PATH);

    var X: TWin32FindDataW;
    SLink.GetPath(@S[1], MAX_PATH, X, 0);
    T := Trim(S);
    T := T.Substring(0, T.IndexOf(#0));
    Target := T;

    SLink.GetDescription(@S[1], MAX_PATH);
    T := Trim(S);
    T := T.Substring(0, T.IndexOf(#0));
    Description := T;
    
    SLink.GetArguments(@S[1], MAX_PATH);
    T := Trim(S);
    T := T.Substring(0, T.IndexOf(#0));
    Parameters := T;
  end;
end;

{ TProcessListHelper }

function TProcessListHelper.FindProcess(Executable: string): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(Self) to High(Self) do
    if Self[I].Module = Executable then
      Exit(I);
end;

{ TProcess }

procedure TProcess.CloseProcess;
begin
  ShellExecute( 0, 'open', 'taskkill', PChar(Format('/PID "%D"', [PID])), nil, 0);
end;

function TProcess.GetIcon: TIcon;
var
  AICON: word;
begin
  if TFile.Exists(FileName) then
    begin
      AICON := 0;

      // Initiate
      Result := TIcon.Create;

      Result.Handle := ExtractAssociatedIcon(HInstance, PChar(FileName), AICON);
      Result.Transparent := true;
    end
      else
        Result := nil;
end;

procedure TProcess.KillProcess;
begin
  ShellExecute( 0, 'open', 'taskkill', PChar(Format('/PID "%D" /F', [PID])), nil, 0);
end;

{ THWNDHelper }

procedure THWNDHelper.BringToFront;
begin
  SetForegroundWindow(Self);
  SetActiveWindow(Self);
end;

function THWNDHelper.GetAppUserModelID: string;
begin
  if not GetAppUserModelIDFromWindow(Self, Result) then
    Result := '';
end;

function THWNDHelper.GetBoundsRect: TRect;
begin
  GetWindowRect(Self, Result);
end;

function THWNDHelper.GetCanvas: TCanvas;
begin
  Result := TCanvas.Create;
  Result.Handle := GetWindowDC(Self);
end;

  function THWNDHelperGetChildWindows_EnumWindowsCallback_Process(Wnd: HWND; lParam: LPARAM): BOOL; stdcall;
  type
    AType = TArray<HWND>;
    ATypeP = ^AType;
  var
    ArrayP: ATypeP;
  begin
    ArrayP := ATypeP(lParam);
    const Index = Length(ArrayP^);
    SetLength(ArrayP^, Index+1);
    ArrayP^[Index] := Wnd;

    Result := true;
  end;
function THWNDHelper.GetChildWindows: TArray<HWND>;
begin
  EnumChildWindows(Self, @THWNDHelperGetChildWindows_EnumWindowsCallback_Process, LPARAM(@Result));
end;

function THWNDHelper.GetChildWindowsEx: TArray<HWND>;
var
  Child: HWND;
begin
  Result := [];
  Child := FindWindowEx(Self, 0, nil, nil);

  while Child <> 0 do
  begin
    Result := Result + [Child];

    // Process Child
    Child := FindWindowEx(Self, Child, nil, nil);
  end;
end;

function THWNDHelper.GetClassName: string;
var
  Title: array[0..255] of Char;
begin
  Winapi.Windows.GetClassName(Self, Title, Length(Title));

  Result := Title;
end;

function THWNDHelper.GetClientRect: TRect;
begin
  Winapi.Windows.GetClientRect(Self, Result);
end;

function THWNDHelper.GetClientToScreen(P: TPoint): TPoint;
begin
  Result := P;
  Winapi.Windows.ClientToScreen(Self, Result);
end;

function THWNDHelper.GetExStyle: Nativeint;
begin
  Result := GetWindowLong(Self, GWL_EXSTYLE);
end;

function THWNDHelper.GetLargeIcon: HICON;
begin
  Result := SendMessage(Self, WM_GETICON, ICON_BIG);
end;

function THWNDHelper.GetParentWindow: HWND;
begin
  Result := GetWindowLong(Self, GWL_HWNDPARENT);
end;

function THWNDHelper.GetPosition: TPoint;
begin
  Result := Self.GetBoundsRect.TopLeft;
end;

function THWNDHelper.GetPreviousWindow: HWND;
begin
  // GW_HWNDPREV: previous window in Z-order
  Result := GetWindow(Self, GW_HWNDPREV);
end;

function THWNDHelper.GetProcessID: TProcessID;
begin
  GetWindowThreadProcessId(Self, DWORD(Result));
end;

function THWNDHelper.GetScreenToClient(P: TPoint): TPoint;
begin
  Result := P;
  Winapi.Windows.ScreenToClient(Self, Result);
end;

function THWNDHelper.GetSize: TSize;
begin
  Result := GetBoundsRect.Size;
end;

function THWNDHelper.GetSmallIcon: HICON;
begin
  Result := SendMessage(Self, WM_GETICON, ICON_SMALL);
  if Result = 0 then
    Result := SendMessage(Self, WM_GETICON, ICON_SMALL2);
end;

function THWNDHelper.GetStyle: Nativeint;
begin
  Result := GetWindowLong(Self, GWL_STYLE);
end;

function THWNDHelper.GetSystemMenu(Reset: Boolean): HMENU;
begin
  Result := Winapi.Windows.GetSystemMenu(Self, Reset);
end;

function THWNDHelper.GetThreadID: Cardinal;
begin
  Result := GetWindowThreadProcessId(Self, nil);
end;

function THWNDHelper.GetTitle: string;
var
  Title: array[0..255] of Char;
begin
  GetWindowText(Self, Title, Length(Title));

  Result := Title;
end;

function THWNDHelper.GetWindowProc: Pointer;
begin
  Result := Pointer(GetWindowLongPtr(Self, GWLP_WNDPROC));
end;

function THWNDHelper.HasExStyle(Style: Nativeint): Boolean;
begin
  Result := (GetWindowLong(Self, GWL_EXSTYLE) and Style) <> 0;
end;

function THWNDHelper.HasStyle(Style: Nativeint): Boolean;
begin
  Result := (GetWindowLong(Self, GWL_STYLE) and Style) <> 0;
end;

function THWNDHelper.GetModuleFilePathEx: string;
var
  OutValue: array[0..MAX_PATH] of Char;
begin
  GetWindowModuleFileName(Self, OutValue, Length(OutValue));

  Result := OutValue;
end;

function THWNDHelper.GetNextWindow: HWND;
begin
  // GW_HWNDNEXT: next window in Z-order
  Result := GetWindow(Self, GW_HWNDNEXT);
end;

function THWNDHelper.GetOwnerWindow: HWND;
begin
  // Owner can be a dialog owner or real owner (not the parent)
  Result := GetWindow(Self, GW_OWNER);
end;

function THWNDHelper.PostMessage(Message: UINT; wParam: WPARAM;
  lParam: LPARAM): longbool;
begin
  Result := Winapi.Windows.PostMessage(Self, Message, wParam, lParam);
end;

function THWNDHelper.ScreenPosInside(const P: TPoint): Boolean;
var
  R: TRect;
begin
  if not GetWindowRect(Self, R) then
    Exit(False);
  Result := PtInRect(R, P);
end;

function THWNDHelper.SendMessage(Message: UINT; wParam: WPARAM;
  lParam: LPARAM): int64;
begin
  Result := Winapi.Windows.SendMessage(Self, Message, wParam, lParam);
end;

procedure THWNDHelper.SetBoundsRect(const R: TRect);
begin
  MoveWindow(Self, R.Left, R.Top, R.Width, R.Height, True);
end;

procedure THWNDHelper.SetExStyle(Style: Nativeint);
begin
  SetWindowLong(Self, GWL_EXSTYLE, Style);
  SetWindowPos(Self, 0, 0,0,0,0,
    SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE or SWP_FRAMECHANGED);
end;

procedure THWNDHelper.SetPosition(P: TPoint);
begin
  SetWindowPos(Self, 0, P.X, P.Y, 0, 0,
    SWP_NOZORDER or SWP_NOSIZE);
end;

procedure THWNDHelper.SetSize(S: TSize);
begin
  SetWindowPos(Self, 0, 0, 0, S.Width, S.Height,
    SWP_NOZORDER or SWP_NOMOVE);
end;

procedure THWNDHelper.SetStyle(Style: Nativeint);
begin
  SetWindowLong(Self, GWL_STYLE, Style);
  SetWindowPos(Self, 0, 0,0,0,0,
    SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE or SWP_FRAMECHANGED);
end;

procedure THWNDHelper.SetTitle(const S: string);
begin
  SetWindowText(Self, PChar(S));
end;

procedure THWNDHelper.SetTransparency(Level: Byte);
var
  Ex: Nativeint;
begin
  Ex := GetWindowLong(Self, GWL_EXSTYLE) or WS_EX_LAYERED;
  SetWindowLong(Self, GWL_EXSTYLE, Ex);

  SetLayeredWindowAttributes(Self, 0, Level, LWA_ALPHA);
end;

function THWNDHelper.SetWindowProc(WndProc: Pointer): boolean;
begin
  Result := SetWindowLongPtr(Self, GWLP_WNDPROC, LONG_PTR(WndProc)) <> 0;
end;

function THWNDHelper.ToString: string;
begin
  Result := inttostr(Self);
end;

procedure THWNDHelper.PostCloseMessage;
begin
  PostMessage(WM_CLOSE, 0, 0);
end;

{ TProcessIDHelper }

function TProcessIDHelper.Exists: Boolean;
var
  H: THandle;
  Code: DWORD;
begin
  H := OpenProcess(PROCESS_QUERY_INFORMATION, False, Self);
  if H = 0 then
    Exit(False);
  try
    if GetExitCodeProcess(H, Code) then
      Result := Code = STILL_ACTIVE
    else
      Result := False;
  finally
    CloseHandle(H);
  end;
end;

function TProcessIDHelper.GetParentPID: TProcessID;
var
  Snap: THandle;
  PE: PROCESSENTRY32;
begin
  Result := 0;

  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap = INVALID_HANDLE_VALUE then Exit;

  try
    PE.dwSize := SizeOf(PE);
    if Process32First(Snap, PE) then
    begin
      repeat
        if PE.th32ProcessID = Self then
        begin
          Result := PE.th32ParentProcessID;
          Exit;
        end;
      until not Process32Next(Snap, PE);
    end;
  finally
    CloseHandle(Snap);
  end;
end;

function TProcessIDHelper.ProcessHandle(Permissions: DWORD): TProcessHandle;
begin
  Result := TProcessHandle.Create(Self, Permissions, false);
end;

function TProcessIDHelper.ProcessHandleAllAcccess: TProcessHandle;
begin
  Result := ProcessHandle(PROCESS_ALL_ACCESS);
end;

function TProcessIDHelper.ProcessHandleReadOnly: TProcessHandle;
begin
  Result := ProcessHandle(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ);
end;

function TProcessIDHelper.Terminate(AExitCode: integer): boolean;
begin
  const Handle = ProcessHandle(PROCESS_TERMINATE);
  if Handle = 0 then
    Exit(False);
  try
    Result := Handle.Terminate(AExitCode);
  finally
    Handle.CloseHandle;
  end;
end;

{ TProcessHandleHelper }

procedure TProcessHandleHelper.CloseHandle;
begin
  Winapi.Windows.CloseHandle(Self);
end;

constructor TProcessHandleHelper.Create(ProcessID, Permissions: DWORD;
  InheritHandle: boolean);
begin
  Self := OpenProcess(DWORD(Permissions), InheritHandle, DWORD(ProcessID));
end;

function TProcessHandleHelper.GetAppUserModelID: string;
var
  dwSize: DWORD;
begin
  // Get size
  dwSize := 0;
  GetApplicationUserModelId(Self, dwSize, nil);

  // None
  if dwSize = 0 then
    Exit('');

  // Provide address
  SetLength(Result, dwSize-1); // exclude null-terminated
  if not Succeeded(GetApplicationUserModelId(Self, dwSize, PWideChar(Result))) then
    RaiseLastOSError;
end;

function TProcessHandleHelper.GetModuleFilePath: string;
var
  path: array[0..4095] of Char;
begin
  if GetModuleFileNameEx(Self, 0, @path[0], Length(path)) = 0 then
    RaiseLastOSError;

  Result := path;
end;

function TProcessHandleHelper.GetModuleName: string;
var
  path: array[0..4095] of Char;
begin
  if GetModuleBaseName(Self, 0, @path[0], Length(path)) = 0 then
    RaiseLastOSError;

  Result := path;
end;

function TProcessHandleHelper.GetProcessID: DWORD;
begin
  if not IsValid then
    Exit(0);

  Result := Winapi.Windows.GetProcessId(Self);
end;

function TProcessHandleHelper.GetProcessName: string;
begin
  Result := ChangeFileExt(GetModuleName, '');
end;

function TProcessHandleHelper.IsRunning: Boolean;
var
  Code: DWORD;
begin
  Result := False;
  if not IsValid then Exit;

  if GetExitCodeProcess(Self, Code) then
    Result := Code = STILL_ACTIVE;
end;

function TProcessHandleHelper.IsValid: Boolean;
begin
  Result := (Self <> 0) and (Self <> INVALID_HANDLE_VALUE);
end;

function TProcessHandleHelper.Terminate(AExitCode: integer): boolean;
begin
  Result := Winapi.Windows.TerminateProcess( Self, AExitCode );
end;

{ TShellLinkFile }

constructor TShellLinkFile.Create;
begin
  FShellLink := CreateComObject(CLSID_ShellLink) as IShellLink;
  FMaxPath := MAX_PATH;
end;

destructor TShellLinkFile.Destroy;
begin
  // interfaces, not needed to be freed
  inherited;
end;

function TShellLinkFile.GetPathS: string;
var
  X: TWin32FindDataW;
begin
  SetLength(Result, FMaxPath);
  FShellLink.GetPath(@Result[1], FMaxPath, X, 0);
  Result := WideCharToString(@Result[1]);
end;

procedure TShellLinkFile.LoadFromFile(FilePath: string);
begin
  (FShellLink as IPersistFile).Load(PWChar(WideString(FilePath)), STGM_READ);
end;

procedure TShellLinkFile.SaveToFile(FilePath: string);
begin
  (FShellLink as IPersistFile).Save(PWChar(WideString(FilePath)), FALSE);
end;

procedure TShellLinkFile.SetArguments(const Value: string);
begin
  FShellLink.SetArguments(PChar(Value));
end;

procedure TShellLinkFile.SetDescription(const Value: string);
begin
  FShellLink.SetDescription(PChar(Value));
end;

procedure TShellLinkFile.SetHotkey(const Value: word);
begin
  FShellLink.SetHotkey(Value);
end;

procedure TShellLinkFile.SetIcon(Path: string; IconIndex: integer);
begin
  FShellLink.SetIconLocation(PChar(Path), IconIndex);
end;

procedure TShellLinkFile.SetIconLocation(const Value: string);
var
  Path: string;
  IconIndex: integer;
begin
  ExtractIconData(Value, Path, IconIndex);
  FShellLink.SetIconLocation(PChar(Path), IconIndex);
end;

procedure TShellLinkFile.SetItemIDList(const Value: TItemIDList);
begin
  FShellLink.SetIDList(@Value);
end;

procedure TShellLinkFile.SetPath(const Value: string);
begin
  FShellLink.SetPath(PChar(Value));
end;

function TShellLinkFile.GetArguments: string;
begin
  SetLength(Result, FMaxPath);
  FShellLink.GetArguments(@Result[1], FMaxPath);
  Result := WideCharToString(@Result[1]);
end;

function TShellLinkFile.GetDescription: string;
begin
  SetLength(Result, FMaxPath);
  FShellLink.GetDescription(@Result[1], FMaxPath);
  Result := WideCharToString(@Result[1]);
end;

function TShellLinkFile.GetHotkey: word;
begin
  Result := 0;
  FShellLink.GetHotkey(Result);
end;

procedure TShellLinkFile.GetIcon(out Path: string; out IconIndex: integer; MaxLength: integer);
begin
  if MaxLength = -1 then
    MaxLength := FMaxPath;

  SetLength(Path, MaxLength);
  FShellLink.GetIconLocation(@Path[1], MaxLength, IconIndex);
  Path := WideCharToString(@Path[1]);
end;

function TShellLinkFile.GetIconLocation: string;
var
  IconIndex: integer;
begin
  SetLength(Result, FMaxPath);
  FShellLink.GetIconLocation(@Result[1], FMaxPath, IconIndex);
  Result := WideCharToString(@Result[1]);
  if Result <> '' then
    Result := Format('%S, %D', [Result, IconIndex]);
end;

function TShellLinkFile.GetItemIDList: TItemIDList;
var
  W: PItemIDList;
begin
  FShellLink.GetIDList(W);
  Result := W^;
end;

function TShellLinkFile.GetShowCmd: integer;
begin
  Result := 0;
  FShellLink.GetShowCmd(Result);
end;

function TShellLinkFile.GetWorkingDirectory: string;
begin
  SetLength(Result, FMaxPath);
  FShellLink.GetWorkingDirectory(@Result[1], FMaxPath);
  Result := WideCharToString(@Result[1]);
end;

procedure TShellLinkFile.SetRelativePath(const Value: string);
begin
  FShellLink.SetRelativePath(PChar(Value), 0);
end;

procedure TShellLinkFile.SetShowCmd(const Value: integer);
begin
  FShellLink.SetShowCmd(Value);
end;

procedure TShellLinkFile.SetWorkingDirectory(const Value: string);
begin
  FShellLink.SetWorkingDirectory(PChar(Value));
end;

{ TFileEx }

class function TFileEx.Replace(ReplacedFile, ReplacedWithFile: string; IgnoreMetadataErrors: boolean): boolean;
var
  Flags: Cardinal;
begin
  Flags := REPLACEFILE_WRITE_THROUGH;
  if IgnoreMetadataErrors then
    Flags := Flags or REPLACEFILE_IGNORE_MERGE_ERRORS;

  SetLastError(ERROR_SUCCESS);
  Result := ReplaceFile(PChar(ReplacedFile), PChar(ReplacedWithFile),
    nil, Flags, nil, nil);
end;

class function TFileEx.Replace(ReplacedFile, ReplacedWithFile, BackupFile: string;
  IgnoreMetadataErrors: boolean): boolean;
var
  Flags: Cardinal;
begin
  Flags := REPLACEFILE_WRITE_THROUGH;
  if IgnoreMetadataErrors then
    Flags := Flags or REPLACEFILE_IGNORE_MERGE_ERRORS;

  SetLastError(ERROR_SUCCESS);
  Result := ReplaceFile(PChar(ReplacedFile), PChar(ReplacedWithFile),
    PChar(BackupFile), Flags, nil, nil);
end;

class function TFileEx.DeleteIfExists(FilePath: string): boolean;
begin
  Result := TFile.Exists(FilePath);
  if Result then
    TFile.Delete(FilePath);
end;

class function TFileEx.FlushFileToDisk(FilePath: string): boolean;
var
  Handle: THandle;
begin
  Handle := CreateFile(
    PChar(FilePath),
    GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE,
    nil,
    OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL,
    0
  );

  if Handle = INVALID_HANDLE_VALUE then
    Exit(false);

  try
    Result := FlushFileBuffers(Handle);
  finally
    CloseHandle(Handle);
  end;
end;

end.