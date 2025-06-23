unit Cod.IniSettings;

interface
  uses
    {$IFDEF MSWINDOWS}Windows, {$ENDIF}Types, Classes, SysUtils, TypInfo, IniFiles, IOUtils;

type
  ///  <summary>
  ///  The settings manager class allows the program to easily read/write
  ///  application settings without having to allocate memory to store all
  ///  of them in variabiles or a record. With this method, settings will only
  ///  be writter/read when needed.
  ///  <summary>
  TCustomSettingsManager = class
  strict private
    FMan: TIniFile;
    FPath: string;

    ///  <summary>
    ///  Get the type of a variabile.
    ///  <summary>
    function GetValueType<T>: TTypeKind;

  protected
    ///  <summary>
    ///  Has this setting been previously saved?
    ///  <summary>
    function Exists(Name, Section: string): boolean; virtual;

    function GetValues(Section: string): TArray<string>; virtual;
    function ValueExists(Name, Section: string): boolean; virtual;
    procedure DeleteValue(Name, Section: string); virtual;

    function GetSections: TArray<string>; virtual;
    function SectionExists(Section: string): boolean; virtual;
    procedure DeleteSection(Section: string); virtual;

  public
    property Ini: TIniFile read FMan write FMan;

    ///  <summary>
    ///  Get the path to the settings config file.
    ///  <summary>
    property FilePath: string read FPath;

    // MUST BE PUBLIC DEFINED (UNFORTUNATELY)
    ///  <summary>
    ///  Get the following setting into a variabile of type T. With a default in
    ///  case It has not been previously saved.
    ///  <summary>
    function Get<T>(Name, Section: string; Default: T): T;
    ///  <summary>
    ///  Write the following setting of a variabile of type T in the config file.
    ///  <summary>
    procedure Put<T>(Name, Section: string; Value: T);

    // Constructors
    constructor Create(SettingPath: string);
    destructor Destroy; override;
  end;

  TSettingsManager = class(TCustomSettingsManager)
  public
    // Make methods public
    function Exists(Name, Section: string): boolean; override;

    function GetValues(Section: string): TArray<string>; override;
    function ValueExists(Name, Section: string): boolean; override;
    procedure DeleteValue(Name, Section: string); override;

    function GetSections: TArray<string>; override;
    function SectionExists(Section: string): boolean; override;
    procedure DeleteSection(Section: string); override;
  end;

  TSectionSettingsManager = class(TCustomSettingsManager)
  private
    FSection: string;

  public
    // Properties
    property Section: string read FSection write FSection;

    // Make methods public
    function Exists(Name: string): boolean; reintroduce;

    function GetValues: TArray<string>; reintroduce;
    function ValueExists(Name: string): boolean; reintroduce;
    procedure DeleteValue(Name: string); reintroduce;

    function SelfExists: boolean;
    procedure DeleteSelf;

    function Get<T>(Name: string; Default: T): T;
    procedure Put<T>(Name: string; Value: T);

    // Constructors
    constructor Create(SettingPath, ASection: string); overload;
  end;

implementation

{ TCustomSettingsManager<T> }

constructor TCustomSettingsManager.Create(SettingPath: string);
begin
  FPath := SettingPath;

  FMan := TIniFile.Create( FPath ); // create, even if it does not exist
end;

procedure TCustomSettingsManager.DeleteSection(Section: string);
begin
  FMan.EraseSection( Section );
end;

procedure TCustomSettingsManager.DeleteValue(Name, Section: string);
begin
  FMan.DeleteKey(Section, Name);
end;

destructor TCustomSettingsManager.Destroy;
begin
  FMan.Free;
  inherited;
end;

function TCustomSettingsManager.Exists(Name, Section: string): boolean;
begin
  Result := FMan.ValueExists(Section, Name);
end;

function TCustomSettingsManager.Get<T>(Name, Section: string; Default: T): T;
begin
  if not Exists(Name, Section) then
    Exit( Default );

  case GetValueType<T> of
    tkInteger: PInteger(@Result)^ := FMan.ReadInteger(Section, Name, 0);
    tkFloat: PDouble(@Result)^ := FMan.ReadFloat(Section, Name, 0);
    tkEnumeration: PByte(@Result)^ := FMan.ReadInteger(Section, Name, 0);
    tkString,
    tkLString,
    tkWString,
    tkUString: PString(@Result)^ := FMan.ReadString(Section, Name, '');

    // Invalid T
    else raise Exception.Create('Type not supported.');
  end;
end;

function TCustomSettingsManager.GetSections: TArray<string>;
var
  S: TStringList;
  I: Integer;
begin
  S := TStringList.Create;
  try
    FMan.ReadSections(S);

    SetLength(Result, S.Count);
    for I := 0 to S.Count-1 do
      Result[I] := S[I];
  finally
    S.Free;
  end;
end;

function TCustomSettingsManager.GetValues(Section: string): TArray<string>;
var
  S: TStringList;
  I: Integer;
begin
  S := TStringList.Create;
  try
    FMan.ReadSectionValues(Section, S);

    SetLength(Result, S.Count);
    for I := 0 to S.Count-1 do
      Result[I] := S[I];
  finally
    S.Free;
  end;
end;

function TCustomSettingsManager.GetValueType<T>: TTypeKind;
var
  AType: PTypeInfo;
begin
  AType := TypeInfo( T );
  Exit( AType.Kind );
end;

procedure TCustomSettingsManager.Put<T>(Name, Section: string; Value: T);
begin
  case GetValueType<T> of
    tkInteger: FMan.WriteInteger(Section, Name, PInteger(@Value)^);
    tkEnumeration: FMan.WriteInteger(Section, Name, PByte(@Value)^);
    tkFloat: FMan.WriteFloat(Section, Name, PDouble(@Value)^);
    tkString,
    tkLString,
    tkWString,
    tkUString: FMan.WriteString(Section, Name, PString(@Value)^);

    // Invalid T
    else raise Exception.Create('Type not supported.');
  end;
end;

function TCustomSettingsManager.SectionExists(Section: string): boolean;
begin
  Result := FMan.SectionExists(Section);
end;

function TCustomSettingsManager.ValueExists(Name, Section: string): boolean;
begin
  Result := FMan.ValueExists(Section, Name);
end;

{ TSettingsManager }

procedure TSettingsManager.DeleteSection(Section: string);
begin
  inherited;
end;

procedure TSettingsManager.DeleteValue(Name, Section: string);
begin
  inherited;
end;

function TSettingsManager.Exists(Name, Section: string): boolean;
begin
  Result := inherited;
end;

function TSettingsManager.GetSections: TArray<string>;
begin
  Result := inherited;
end;

function TSettingsManager.GetValues(Section: string): TArray<string>;
begin
  Result := inherited;
end;

function TSettingsManager.SectionExists(Section: string): boolean;
begin
  Result := inherited;
end;

function TSettingsManager.ValueExists(Name, Section: string): boolean;
begin
  Result := inherited;
end;

{ TSectionSettingsManager }

constructor TSectionSettingsManager.Create(SettingPath, ASection: string);
begin
  inherited Create(SettingPath);

  FSection := ASection;
end;

procedure TSectionSettingsManager.DeleteSelf;
begin
  inherited DeleteSection(FSection);
end;

procedure TSectionSettingsManager.DeleteValue(Name: string);
begin
  inherited DeleteValue(Name, FSection);
end;

function TSectionSettingsManager.Exists(Name: string): boolean;
begin
  Result := inherited Exists(Name, FSection);
end;

function TSectionSettingsManager.Get<T>(Name: string; Default: T): T;
begin
  Result := inherited Get<T>(Name, FSection, Default);
end;

function TSectionSettingsManager.GetValues: TArray<string>;
begin
  Result := inherited GetValues(FSection);
end;

procedure TSectionSettingsManager.Put<T>(Name: string; Value: T);
begin
  inherited Put<T>(Name, FSection, Value);
end;

function TSectionSettingsManager.SelfExists: boolean;
begin
  Result := inherited SectionExists(FSection);
end;

function TSectionSettingsManager.ValueExists(Name: string): boolean;
begin
  Result := inherited ValueExists(Name, FSection);
end;

end.