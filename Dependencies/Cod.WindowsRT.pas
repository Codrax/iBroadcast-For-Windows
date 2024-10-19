{***********************************************************}
{               Codruts Windows Runtime Utils               }
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

unit Cod.WindowsRT;

interface
  uses
  // System
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, 
  System.Types, Math, Vcl.Forms, IOUtils, System.Generics.Collections, 
  ActiveX, ComObj, Cod.ArrayHelpers, TypInfo, DateUtils, ShlObj, Rtti,

  // Windows RT (Runtime)
  Win.WinRT,
  Winapi.Winrt,
  Winapi.Winrt.Utils,
  Winapi.DataRT,
  Winapi.UI.Notifications,
  Winapi.Storage,
  Winapi.Storage.Streams,
  Winapi.Foundation.Collections,

  // Winapi
  Winapi.CommonTypes,
  Winapi.Foundation;

  type
    {$SCOPEDENUMS OFF}
    TWinBoolean = (WinDefault, WinFalse, WinTrue);
    TWinBool = TWinBoolean;
    {$SCOPEDENUMS ON}

    TWinBooleanHelper = record helper for TWinBoolean
      class function Create(Value: boolean): TWinBoolean; overload; static; inline;

      function Initiated: boolean;
      function ToBoolean(Default: boolean = false): boolean;
      function ToInteger(Default: integer = 0): integer;
      function ToString: string;
    end;

    // TAsyncAwait
    TAsyncAwait = class(TInspectableObject)
    private
      FTriggered: boolean;

    protected
      procedure Trigger; virtual;

    public
      const DEFAULT_TIME_STEP = 10;

      procedure Reset; virtual;

      procedure Await; overload;
      procedure AwaitCounted(Callback: TProc);
      procedure AwaitSleep(Amount: integer);

      // Class utils
      class procedure Await(const asyncInfo: IInterface; TimeStep: cardinal=DEFAULT_TIME_STEP); overload;
      class procedure Await(const asyncInfo: IInterface; TimeStep: cardinal; const AApplicationProcessMessage: TApplicationProcessMessagesProc); overload;

      // Constructors
      constructor Create;
    end;

    TAsyncAwaitResult<T> = class(TAsyncAwait)
    var
      FInternalResultValue: T;

    protected
      // Default
      procedure ClearValue; virtual;

    public
      /// <summary>
      /// Reset the await event for next use. This must be done manually and cannot
      /// be called in Reset() because in the timeframe that this event is
      /// assigned and when GetResults() is called, Trigger() could have
      /// allready been called. In which case Await() would be stuck in a loop.
      /// </summary>
      procedure Reset; override;

      // Get results
      function GetResults: T;
    end;

    // Subscription based event
    TSubscriptionEventHandlerBase = class(TInspectableObject)
    private
      FSubscribed: boolean;
      FToken: EventRegistrationToken;

    protected
      property Token: EventRegistrationToken read FToken write FToken;

      ///  <summary>
      ///  Re-subscribe to the notification event. Used when the notification is reset
      ///  </summary>
      procedure Resubscribe; virtual;
      ///  <summary>
      ///  Attempt to unsubscribe token if one is registered.
      ///  </summary>
      procedure TryUnsubscribe;

      // Override
      ///  <summary>
      ///  Subscribe to the notification event
      ///  </summary>
      procedure Subscribe; virtual;
      ///  <summary>
      ///  Unsubscribe from the notification event
      ///  </summary>
      procedure Unsubscribe; virtual; // inherited; must be called after the token is unregistered!!

    public
      // Use a FSubscribed variabile to avoid unsubscibe recursion caused by low ref count.
      property Subscribed: boolean read FSubscribed;

      class procedure TryMultiUnsubscribe(Items: TArray<TSubscriptionEventHandlerBase>);

      // Constructors
      constructor Create;
      destructor Destroy; override;
    end;

    TCurrentProcess = class
    public
      class procedure SetAppUserModelID(Value: string); static;
      class function GetAppUserModelID: string; static;

      class function GetAppExecutable: string; static;
    end;

    TSubscriptionEventHandler<ParentType; NotifyType> = class(TSubscriptionEventHandlerBase)
    private
      FParent: ParentType;
      FCalls: TArray<NotifyType>;

      // Utils
      procedure CallsListChanged;

      // Getters
      function GetCount: integer;
      function GetItem(Index: integer): NotifyType;

    protected
      property Parent: ParentType read FParent write FParent;
      
      // Declare a procedure to invoke the events here

    public
      // Subscription manager
      property Count: integer read GetCount;
      property Items[Index: integer]: NotifyType read GetItem;
      
      procedure Add(ACallback: NotifyType);
      procedure Remove(ACallback: NotifyType);
      function Exists(ACallback: NotifyType): boolean;

      procedure RemoveAll;

      // Constructors
      constructor Create(const AParent: ParentType); virtual;
      destructor Destroy; override;
    end;

    // Instance factory
    TInstanceFactory = class
    public
      class function CreateNamed(Name: string): IInspectable; overload;
      class function CreateNamed<T: IInspectable>(Name: string): T; overload;

      class function CreateFactory(IID: TGUID; Name: string): IInspectable; overload;
      class function CreateFactory<T: IInspectable>(IID: TGUID; Name: string): T; overload;

      // Query
      class function CreateNamedAndQuery<T: IInspectable>(Name: string; GUID: TGUID): T; overload;
      class function Query<T: IInspectable>(Instance: IInspectable; GUID: TGUID): T;

      // GUID
      class function GetGUID<T: IInspectable>: TGUID;

      // Info
      class function Supports(Instance: IInspectable; GUID: TGUID): boolean;
    end;

    // GUID Reader
    TGuidReader<T> = class
      class function GetGUID: TGUID;
      class function GetGUIDAsString: string;
    end;

    // Helper for TimeSpan
    TimeSpanHelper = record helper for TimeSpan
      constructor Create(ADuration: int64);
      constructor CreateMilliseconds(Milliseconds: int64);
      constructor CreateSeconds(Seconds: extended);
      constructor CreateTime(Time: TTime);

      function ToMilliseconds: int64;
      function ToSeconds: extended;
      function ToTime: TTime;
    end;

    // Re-names
    TXMLInterface = Xml_Dom_IXmlDocument;

    // WinXML custom document management
    TWinXMLNodes = class;
    TWinXMLAttributes = class;

    TWinXMLNode = class(TObject)
    private
      FTagName: string;
      FParent: TWinXMLNode;

      FContents: string; // content of the node, pre-other nodes
      FNodes: TWinXMLNodes;
      FAttributes: TWinXMLAttributes;
    procedure SetTagName(const Value: string);
    public
      property TagName: string read FTagName write SetTagName;
      property Parent: TWinXMLNode read FParent;

      property Contents: string read FContents write FContents;
      property Nodes: TWinXMLNodes read FNodes write FNodes;
      property Attributes: TWinXMLAttributes read FAttributes write FAttributes;

      // Utils
      procedure Delete;
      procedure Detach;

      // Convert
      function OuterXML: string;
      function InnerXML: string;
      function ToString: string; override;

      // Constructors
      constructor Create; virtual;
      destructor Destroy; override;
    end;

    TWinXMLAttribute = record
      Tag: string;
      Value: string;
    end;
    TWinXMLNodes = class
    private
      FNodes: TArray<TWinXMLNode>;
      FNodeManager: TWinXMLNode;

      function GetNode(Index: integer): TWinXMLNode;
    public
      function Count: integer;

      // Parent manage
      function DetachNode(Index: integer): boolean; overload;
      function DetachNode(Node: TWinXMLNode): boolean; overload;

      procedure AttachNode(Node: TWinXMLNode); // add existing node clas

      // Manage node
      function FindNode(TagName: string): integer; overload;
      function FindNode(Node: TWinXMLNode): integer; overload;
      function HasNode(TagName: string): boolean;
      function DeleteNode(Index: integer): boolean; overload;
      function DeleteNode(Node: TWinXMLNode): boolean; overload;

      // Create node
      function AddNode(TagName: string): TWinXMLNode; overload;

      procedure Clear;

      property Nodes[Index: integer]: TWinXMLNode read GetNode; default;

      constructor Create(ForNode: TWinXMLNode);
      destructor Destroy; override;
    end;
    TWinXMLAttributes = class
    private
      FAttributes: TArray<TWinXMLAttribute>;

    public
      function Count: integer;

      function FindAttribute(ATag: string): integer;
      function HasAttribute(ATag: string): boolean;
      function DeleteAttribute(Index: integer): boolean; overload;
      function DeleteAttribute(ATag: string): boolean; overload;

      function GetAttribute(Tag: string): string; overload;
      function GetAttribute(Index: integer): string; overload;
      function GetAttributeTag(Index: integer): string;
      procedure SetAttribute(Tag: string; const Value: string);

      property Attributes[Tag: string]: string read GetAttribute write SetAttribute; default;

      constructor Create;
    end;

    TWinXMLDocument = class(TWinXMLNode)
      constructor Create; override;
    end;

    // DomXMLDocument
    TDomXMLDocument = class(TObject)
    public
      DomXML: TXMLInterface;

      // Convert
      procedure Parse(XMLDocument: string);
      function Format: string;

      // Constructors
      constructor Create; overload;
      constructor Create(FromString: string); overload;
      constructor Create(FromInterface: TXMLInterface); overload;
      destructor Destroy; override;
    end;

    // Helpers
    HStringHelper = record helper for HSTRING
      constructor Create(S: string);

      function CompareTo(Value: HString): TValueRelationship;
      function Length: cardinal;
      function Empty: boolean;

      function ToString: string;
      procedure Free;

      function ToStringAndDestroy: string;
    end;

  // HString
  function StringToHString(Value: string): HSTRING; // Needs to be freed with WindowsDeleteString
  function HStringToString(AString: HSTRING): string;
  procedure FreeHString(AString: HSTRING);

implementation

function StringToHString(Value: string): HSTRING;
begin            
  if Failed(
    WindowsCreateString(PWideChar(Value), Length(Value), Result)
  ) then 
    raise Exception.CreateFmt('Unable to create HString for %s', [ Value ] );
end;

function HStringToString(AString: HSTRING): string;
var
  buffer: PWideChar;
  length: UINT32;
begin
  buffer := WindowsGetStringRawBuffer(AString, @length);
  if buffer = nil then
    Result := ''
  else
    Result := Copy(buffer, 1, length);
end;

procedure FreeHString(AString: HSTRING);
begin
  if Failed(WindowsDeleteString(AString)) then
    RaiseLastOSError;
end;

{ HStringHelper }

function HStringHelper.CompareTo(Value: HString): TValueRelationship;
begin               
  var O: UINT32;
  if Failed(WindowsCompareStringOrdinal(Self, Value, O)) then
    raise Exception.Create('Comparison failed.');
  Result := O;
end;

constructor HStringHelper.Create(S: string);
begin
  Self := StringToHString(S);
end;

function HStringHelper.Empty: boolean;
begin
  Result := WindowsIsStringEmpty(Self);
end;

procedure HStringHelper.Free;
begin
  FreeHString(Self);
  Self := 0;
end;

function HStringHelper.Length: cardinal;
begin            
  Result := WindowsGetStringLen(Self);
end;

function HStringHelper.ToString: string;
begin
  Result := HStringToString(Self);
end;

function HStringHelper.ToStringAndDestroy: string;
begin
  Result := ToString;
  Free;
end;

{ TDomXMLDocument }

constructor TDomXMLDocument.Create;
begin
  DomXML := TXml_Dom_XmlDocument.Create;
end;

constructor TDomXMLDocument.Create(FromString: string);
begin
  inherited Create;

  Parse( FromString );
end;

constructor TDomXMLDocument.Create(FromInterface: TXMLInterface);
begin
  DomXML := FromInterface;
end;

destructor TDomXMLDocument.Destroy;
begin
  DomXML := nil;

  inherited;
end;

function TDomXMLDocument.Format: string;
var
  HS: HSTRING;
begin
  HS := ( DomXML.DocumentElement as Xml_Dom_IXmlNodeSerializer ).GetXml;
  try
    Result := HS.ToString;
  finally
    HS.Free;
  end;
end;

procedure TDomXMLDocument.Parse(XMLDocument: string);
var
  hXML: HSTRING;
begin
  hXML := HSTRING.Create(XMLDocument);
  try
    (DomXML as Xml_Dom_IXmlDocumentIO).LoadXml( hXML );
  finally
    hXML.Free;
  end;
end;

{ TWinXMLBranch }

constructor TWinXMLNode.Create;
begin
  FTagName := 'node';

  FNodes := TWinXMLNodes.Create(Self);
  FAttributes := TWinXMLAttributes.Create;
end;

procedure TWinXMLNode.Delete;
begin
  if Parent <> nil then
    Parent.Nodes.DeleteNode( Self );
end;

destructor TWinXMLNode.Destroy;
begin
  // Free elements
  FNodes.Free;
  FAttributes.Free;

  inherited;
end;

procedure TWinXMLNode.Detach;
begin
  if Parent <> nil then
    Parent.Nodes.DetachNode( Self );
end;

function TWinXMLNode.InnerXML: string;
begin
  Result := Contents;
  for var I := 0 to Nodes.Count-1 do
    Result := Result + Nodes[I].ToString;
end;

function TWinXMLNode.OuterXML: string;
var
  Attrib, Interior: string;
begin
  // Inner XML
  Interior := InnerXML;

  // Attribute
  Attrib := '';
  for var I := 0 to Attributes.Count-1 do
    Attrib := Format('%S %S="%S"', [Attrib, Attributes.GetAttributeTag(I), Attributes.GetAttribute(I)]);

  // First tag
  if Interior = '' then
    Attrib := Attrib + '/';

  Result := Format('<%S%S>', [TagName, Attrib]);

  // Interior + Closing tag
  if Interior <> '' then
    Result := Result + Interior + Format('</%S>', [TagName]);
end;

procedure TWinXMLNode.SetTagName(const Value: string);
begin
  if Value = '' then
    raise Exception.Create('Tag name cannot be empty.');

  FTagName := Value;
end;

function TWinXMLNode.ToString: string;
begin
  Result := OuterXML;
end;

{ TWinXMLNodes }

function TWinXMLNodes.AddNode(TagName: string): TWinXMLNode;
begin
  Result := TWinXMLNode.Create;
  Result.TagName := TagName;
  AttachNode( Result );
end;

procedure TWinXMLNodes.AttachNode(Node: TWinXMLNode);
begin
  // Detach if attached
  Node.Detach;

  // Allocate space
  const Index = Count;
  SetLength(FNodes, Index+1);
  Node.FParent := FNodeManager;

  // Attach
  FNodes[Index] := Node;
end;

procedure TWinXMLNodes.Clear;
begin
  for var I := Count-1 downto 0 do
    FNodes[I].Free;
  SetLength(FNodes, 0);
end;

function TWinXMLNodes.Count: integer;
begin
  Result := Length(FNodes);
end;

constructor TWinXMLNodes.Create(ForNode: TWinXMLNode);
begin
  inherited Create;
  FNodeManager := ForNode;
  FNodes := [];
end;

function TWinXMLNodes.DeleteNode(Node: TWinXMLNode): boolean;
begin
  Result := DeleteNode(FindNode(Node));
end;

destructor TWinXMLNodes.Destroy;
begin
  // Delete contained items
  Clear;

  inherited;
end;

function TWinXMLNodes.DetachNode(Node: TWinXMLNode): boolean;
begin
  Result := DetachNode(FindNode(Node));
end;

function TWinXMLNodes.DetachNode(Index: integer): boolean;
begin
  Result := InRange(Index, 0, Count-1);
  if not Result then
    Exit;

  FNodes[Index].FParent := nil;
  for var I := Index to Count-2 do
    FNodes[I] := FNodes[I+1];
  SetLength(FNodes, Count-1);
end;

function TWinXMLNodes.FindNode(Node: TWinXMLNode): integer;
begin
  for var I := 0 to High(FNodes) do
    if FNodes[I] = Node then
      Exit(I);

  Exit(-1);
end;

function TWinXMLNodes.DeleteNode(Index: integer): boolean;
begin
  Result := InRange(Index, 0, Count-1);
  if not Result then
    Exit;

  FNodes[Index].Free;
  DetachNode(Index);
end;

function TWinXMLNodes.FindNode(TagName: string): integer;
begin
  for var I := 0 to High(FNodes) do
    if FNodes[I].TagName = TagName then
      Exit(I);

  Exit(-1);
end;

function TWinXMLNodes.GetNode(Index: integer): TWinXMLNode;
begin
  Result := FNodes[Index];
end;

function TWinXMLNodes.HasNode(TagName: string): boolean;
begin
  Result := FindNode(TagName) <> -1;
end;

{ TWinXMLAttributes }

function TWinXMLAttributes.Count: integer;
begin
  Result := Length(FAttributes);
end;

constructor TWinXMLAttributes.Create;
begin
  FAttributes := [];
end;

function TWinXMLAttributes.DeleteAttribute(ATag: string): boolean;
begin
  Result := DeleteAttribute( FindAttribute(ATag) );
end;

function TWinXMLAttributes.DeleteAttribute(Index: integer): boolean;
begin
  Result := InRange(Index, 0, Count-1);
  if not Result then
    Exit;

  for var I := Index to Count-2 do
    FAttributes[I] := FAttributes[I+1];
  SetLength(FAttributes, Count-1);
end;

function TWinXMLAttributes.FindAttribute(ATag: string): integer;
begin
  for var I := 0 to Count-1 do
    if FAttributes[I].Tag = ATag then
      Exit(I);

  Exit(-1);
end;

function TWinXMLAttributes.GetAttribute(Index: integer): string;
begin
  Result := FAttributes[Index].Value;
end;

function TWinXMLAttributes.GetAttributeTag(Index: integer): string;
begin
  Result := FAttributes[Index].Tag;
end;

function TWinXMLAttributes.GetAttribute(Tag: string): string;
begin
  const Index = FindAttribute(Tag);
  Result := FAttributes[index].Value;
end;

function TWinXMLAttributes.HasAttribute(ATag: string): boolean;
begin
  Result := FindAttribute(ATag) <> -1;
end;

procedure TWinXMLAttributes.SetAttribute(Tag: string; const Value: string);
var
  Index: integer;
begin
  // Get Index
  Index := FindAttribute(Tag);
  if Index = -1 then begin
    Index := Count;
    SetLength(FAttributes, Index+1);

    FAttributes[Index].Tag := Tag;
  end;

  // Set
  FAttributes[Index].Value := Value;
end;

{ TWinXMLDocument }

constructor TWinXMLDocument.Create;
begin
  inherited Create;
  FTagName := 'xml';
end;

{ TWinBooleanHelper }

class function TWinBooleanHelper.Create(Value: boolean): TWinBoolean;
begin
  if Value then
    Result := WinTrue
  else
    Result := WinFalse;
end;

function TWinBooleanHelper.Initiated: boolean;
begin
  Result := Self <> WinDefault;
end;

function TWinBooleanHelper.ToBoolean(Default: boolean): boolean;
begin
  case Self of
    WinDefault: Result := Default;
    WinFalse: Result := false;
    WinTrue: Result := true;
    else Result := false;
  end;

end;

function TWinBooleanHelper.ToInteger(Default: integer): integer;
begin
  case Self of
    WinDefault: Result := Default;
    WinFalse: Result := 0;
    WinTrue: Result := 1;
    else Result := 0;
  end;
end;

function TWinBooleanHelper.ToString: string;
begin
  case Self of
    TWinBoolean.WinDefault: Result := 'default';
    TWinBoolean.WinFalse: Result := 'false';
    TWinBoolean.WinTrue: Result := 'true';
  end;
end;

{ TAsyncAwait }

procedure TAsyncAwait.Await;
begin
  while not FTriggered do
    Application.ProcessMessages;
end;

class procedure TAsyncAwait.Await(const asyncInfo: IInterface;
  TimeStep: cardinal;
  const AApplicationProcessMessage: TApplicationProcessMessagesProc);
const
  StrIAsyncInfoNotSupported = 'Interface not supports IAsyncInfo';
  StrApplicationProcessError = 'AApplicationProcessMessage must be assigned';
var
  lOut: IAsyncInfo;
  lErr: Cardinal;
begin
  Assert(Assigned(AApplicationProcessMessage), StrApplicationProcessError);

  if not Supports(asyncInfo, IAsyncInfo, lOut) then
    raise Exception.Create(StrIAsyncInfoNotSupported);

  while not(lOut.Status in [asyncStatus.Completed, asyncStatus.Canceled, asyncStatus.Error]) do
  begin
    if TimeStep > 0 then
      Sleep( TimeStep );
    AApplicationProcessMessage();
  end;
  lErr := HResultCode(lOut.ErrorCode);
  if lErr <> ERROR_SUCCESS then
    raise Exception.Create(SysErrorMessage(lErr));
end;

class procedure TAsyncAwait.Await(const asyncInfo: IInterface;
  TimeStep: cardinal);
begin
  Await(asyncInfo, TimeStep, Application.ProcessMessages);
end;

procedure TAsyncAwait.AwaitCounted(Callback: TProc);
begin
  Reset;

  repeat
    Application.ProcessMessages;
    Callback();
  until FTriggered;
end;

procedure TAsyncAwait.AwaitSleep(Amount: integer);
begin
  Reset;

  repeat
    Application.ProcessMessages;
    Sleep(Amount);
  until FTriggered;
end;

constructor TAsyncAwait.Create;
begin
  inherited;
  FTriggered := false;
end;

procedure TAsyncAwait.Reset;
begin
  FTriggered := false;
end;

procedure TAsyncAwait.Trigger;
begin
  FTriggered := true;
end;

procedure TAsyncAwaitResult<T>.ClearValue;
begin
  //
end;

{ TAsyncAwaitResult }

function TAsyncAwaitResult<T>.GetResults: T;
begin
  // Wait
  Await;

  //
  Result := FInternalResultValue;

  // Clear
  ClearValue;
end;

procedure TAsyncAwaitResult<T>.Reset;
begin
  inherited;
  ClearValue;
end;

{ TSubscriptionEventHandler<ParentType, NotifyType> }

procedure TSubscriptionEventHandler<ParentType, NotifyType>.Add(
  ACallback: NotifyType);
begin
  if Exists(ACallback) then
    Exit;

  TArrayUtils<NotifyType>.AddValue( ACallback, FCalls );

  // Changed
  CallsListChanged;
end;

procedure TSubscriptionEventHandler<ParentType, NotifyType>.CallsListChanged;
begin
  const SubscriptionNeeded = Length(FCalls) > 0;
  if SubscriptionNeeded = Subscribed then
    Exit;

  // Change
  if SubscriptionNeeded then
    Subscribe
  else
    Unsubscribe;
end;

constructor TSubscriptionEventHandler<ParentType, NotifyType>.Create(
  const AParent: ParentType);
begin
  inherited Create;

  FParent := AParent;
end;

destructor TSubscriptionEventHandler<ParentType, NotifyType>.Destroy;
begin
  inherited;
end;

function TSubscriptionEventHandler<ParentType, NotifyType>.Exists(
  ACallback: NotifyType): boolean;
begin
  Result := TArrayUtils<NotifyType>.Contains( ACallback, FCalls );
end;

function TSubscriptionEventHandler<ParentType, NotifyType>.GetCount: integer;
begin
  Result := Length( FCalls );
end;

function TSubscriptionEventHandler<ParentType, NotifyType>.GetItem(
  Index: integer): NotifyType;
begin
  Result := FCalls[Index];
end;

procedure TSubscriptionEventHandler<ParentType, NotifyType>.Remove(
  ACallback: NotifyType);
begin
  if not Exists(ACallback) then
    Exit;

  TArrayUtils<NotifyType>.DeleteValue( ACallback, FCalls );

  // Changed
  CallsListChanged;
end;

procedure TSubscriptionEventHandler<ParentType, NotifyType>.RemoveAll;
begin
  if Length(FCalls) = 0 then
    Exit;

  // Clear
  FCalls := [];

  // Changed
  CallsListChanged;
end;

{ TSubscriptionEventHandlerBase }

constructor TSubscriptionEventHandlerBase.Create;
begin
  FSubscribed := false;
end;

destructor TSubscriptionEventHandlerBase.Destroy;
begin
  // Unsubscribe
  if Subscribed then
    Unsubscribe;

  inherited;
end;

procedure TSubscriptionEventHandlerBase.Resubscribe;
begin
  if Subscribed then
    Unsubscribe;
  Subscribe;
end;

procedure TSubscriptionEventHandlerBase.Subscribe;
begin
  FSubscribed := true;
end;

class procedure TSubscriptionEventHandlerBase.TryMultiUnsubscribe(
  Items: TArray<TSubscriptionEventHandlerBase>);
begin
  for var I := 0 to High(Items) do
    Items[I].TryUnsubscribe;
end;

procedure TSubscriptionEventHandlerBase.TryUnsubscribe;
begin
  if Subscribed then
    Unsubscribe;
end;

procedure TSubscriptionEventHandlerBase.Unsubscribe;
begin
  // Clear token
  FSubscribed := false;
end;

{ TInstanceFactory }

class function TInstanceFactory.CreateFactory(IID: TGUID;
  Name: string): IInspectable;
var
  className: HSTRING;
  HRes: HRESULT;
begin
  // Runtime class
  className := hstring.Create(Name);

  // Activate the instance
  try
    HRes := RoGetActivationFactory(className, IID, Result);
    if Failed(HRes) then
      Result := nil;
  finally
    className.Free;
  end;
end;

class function TInstanceFactory.CreateFactory<T>(IID: TGUID; Name: string): T;
begin
  Result := T(CreateFactory(IID, Name));
end;

class function TInstanceFactory.CreateNamed(Name: string): IInspectable;
var
  className: HSTRING;
  HRes: HRESULT;
begin
  // Runtime class
  className := hstring.Create(Name);

  // Activate the instance
  try
    HRes := RoActivateInstance(className, Result);
    if Failed(HRes) then
      Result := nil;
  finally
    className.Free;
  end;
end;

class function TInstanceFactory.CreateNamed<T>(Name: string): T;
begin
  Result := T(CreateNamed(Name));
end;

class function TInstanceFactory.CreateNamedAndQuery<T>(Name: string;
  GUID: TGUID): T;
var
  Item: IInspectable;
begin
  Item := CreateNamed(Name);
  if Item = nil then
    Exit(nil);

  if not System.SysUtils.Supports(Item, GUID) then
    Item := nil
  else
    // Query
    if Failed( Item.QueryInterface(GUID, Item) ) then
      Item := nil;

  Result := Item;
end;

class function TInstanceFactory.GetGUID<T>: TGUID;
var
  Info: PTypeInfo;
  LTypeData: PTypeData;
begin
  Info := TypeInfo(T);

  // Ensure we are working with an interface
  if Info.Kind <> tkInterface then
    raise Exception.Create('T is not an interface.');

  // Get the TypeData which contains the GUID for interfaces
  LTypeData := GetTypeData(Info);

  // Return the GUID stored in TypeData
  Result := LTypeData.Guid;
end;

class function TInstanceFactory.Query<T>(Instance: IInspectable;
  GUID: TGUID): T;
var
  Item: IInspectable;
begin
  // Attempt to query
  if Failed( Instance.QueryInterface(GUID, Item) ) then
    Item := nil;

  // Return value
  Result := T(Item);
end;

class function TInstanceFactory.Supports(Instance: IInspectable;
  GUID: TGUID): boolean;
begin
  Result := System.SysUtils.Supports(Instance, GUID);
end;

{ TGuidReader<T> }

class function TGuidReader<T>.GetGUID: TGUID;
begin
  Result := GetTypeData(System.TypeInfo(T))^.Guid;
end;

class function TGuidReader<T>.GetGUIDAsString: string;
begin
  Result := GUIDToString( GetGUID );
end;

{ TCurrentProcess }

class function TCurrentProcess.GetAppExecutable: string;
begin
  Result := Application.ExeName;
end;

class function TCurrentProcess.GetAppUserModelID: string;
var
  Value: PChar;
begin
  try
    GetCurrentProcessExplicitAppUserModelID( Value );
    Result := Value;
  except
    Result := '';
  end;

  // Default
  if Result = '' then
    Result := ExtractFileName(Application.ExeName);
end;

class procedure TCurrentProcess.SetAppUserModelID(Value: string);
begin
  SetCurrentProcessExplicitAppUserModelID( PChar(Value) );
end;

{ TimeSpanHelper }

constructor TimeSpanHelper.Create(ADuration: int64);
begin
  Duration := ADuration;
end;

constructor TimeSpanHelper.CreateMilliseconds(Milliseconds: int64);
begin
  Duration := Milliseconds * 10000;
end;

constructor TimeSpanHelper.CreateSeconds(Seconds: extended);
begin
  Duration := trunc(Seconds * 10000000);
end;

constructor TimeSpanHelper.CreateTime(Time: TTime);
begin
                                     // Frac to only get the time info
  Duration := MillisecondsBetween(0, Frac(Time)) * 10000;
end;

function TimeSpanHelper.ToMilliseconds: int64;
begin
  Result := Self.Duration div 10000;
end;

function TimeSpanHelper.ToSeconds: extended;
begin
  Result := Self.Duration div 10000000;
end;

function TimeSpanHelper.ToTime: TTime;
const
  MillisecondsPerDay = 86400000; // 24 * 60 * 60 * 1000
begin
  Result := ToMilliseconds / MillisecondsPerDay;
end;

end.
