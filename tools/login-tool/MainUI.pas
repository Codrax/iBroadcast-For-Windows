unit MainUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Math,
  Vcl.NumberBox, IdBaseComponent, IdComponent, IdCustomTCPServer, IdSSLOpenSSL,
  IdCustomHTTPServer, IdHTTPServer, IdGlobal, IdContext, IdHTTP, IdURI,
  Cod.JSON, Cod.JSON.Utils, Hash, NetEncoding, Cod.SysUtils, DateUtils,
  Cod.IniSettings, Cod.Types;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit5: TEdit;
    Label9: TLabel;
    Edit6: TEdit;
    Label10: TLabel;
    Edit7: TEdit;
    Label11: TLabel;
    Bevel1: TBevel;
    Label12: TLabel;
    Label13: TLabel;
    Edit8: TEdit;
    Label14: TLabel;
    Edit9: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    NumberBox1: TNumberBox;
    Label17: TLabel;
    CheckBox1: TCheckBox;
    IdHTTPServer1: TIdHTTPServer;
    Memo1: TMemo;
    Label18: TLabel;
    NumberBox2: TNumberBox;
    Label19: TLabel;
    Button1: TButton;
    Label21: TLabel;
    CheckBox2: TCheckBox;
    Label20: TLabel;
    Edit11: TEdit;
    Label23: TLabel;
    Bevel2: TBevel;
    Memo2: TMemo;
    Button3: TButton;
    Label24: TLabel;
    Label22: TLabel;
    Button2: TButton;
    Label25: TLabel;
    Label26: TLabel;
    Edit12: TEdit;
    Edit13: TEdit;
    Button4: TButton;
    Label27: TLabel;
    Edit14: TEdit;
    NumberBox3: TNumberBox;
    Label28: TLabel;
    UpdateUI: TTimer;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label29: TLabel;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    CheckBox3: TCheckBox;
    Button12: TButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdHTTPServer1AfterBind(Sender: TObject);
    procedure IdHTTPServer1Exception(AContext: TIdContext;
      AException: Exception);
    procedure IdHTTPServer1Connect(AContext: TIdContext);
    procedure IdHTTPServer1Disconnect(AContext: TIdContext);
    procedure Button1Click(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpdateUITimer(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit14Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
    procedure NumberBox3ChangeValue(Sender: TObject);
    procedure NumberBox2ChangeValue(Sender: TObject);
    procedure Edit11Change(Sender: TObject);
    procedure NumberBox1ChangeValue(Sender: TObject);
    procedure Edit12Change(Sender: TObject);
    procedure Edit13Change(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
  private
    function Get_OAuth2_AccessToken: string;
    function Get_OAUTH2_CLIENT_ID: string;
    function Get_OAuth2_Expiry: TDateTime;
    function Get_OAuth2_RefreshToken: string;
    function Get_OAUTH2_SCOPE: string;
    function Get_REDIRECT_URI: string;
    procedure Set_OAuth2_AccessToken(const AValue: string);
    procedure Set_OAuth2_Expiry(const AValue: TDateTime);
    procedure Set_OAuth2_RefreshToken(const AValue: string);
    { Private declarations }

  private
    V2_HTTP: TIdHTTP;
    FExpiryRelativeTo: TDateTime;
    procedure SetExpiryRelativeTo(const Value: TDateTime);
    function GetAllowDebug: boolean;

  public
    { Public declarations }

    // Comp
    procedure AddToLog(S: string);
    property AllowDebug: boolean read GetAllowDebug;

    property OAUTH2_CLIENT_ID: string read Get_OAUTH2_CLIENT_ID;
    property OAUTH2_SCOPE: string read Get_OAUTH2_SCOPE;
    property OAUTH2_REDIRECT_URI: string read Get_REDIRECT_URI;

    property OAuth2_RefreshToken: string read Get_OAuth2_RefreshToken write Set_OAuth2_RefreshToken;
    property OAuth2_AccessToken: string read Get_OAuth2_AccessToken write Set_OAuth2_AccessToken;
    property OAuth2_Expiry: TDateTime read Get_OAuth2_Expiry write Set_OAuth2_Expiry;
      property ExpiryRelativeTo: TDateTime read FExpiryRelativeTo write SetExpiryRelativeTo;

    ///  V2
    // Builders
    function V2_CreateHTTP: TIdHTTP;
    function V2_GetBody: IJObject;

    // Requests
    function V2_RequestPost(const HTTP: TIdHTTP; const Body: IJValue; const Endpoint: string; const Authorization: string=''): IJValue; overload;
    function V2_RequestPost(const HTTP: TIdHTTP; const Body: TStringList; const Endpoint: string; const Authorization: string=''): IJValue; overload;

    ///  Actions
    // Login
    function V2_Login_AuthorizeURL(const State: string; const ACodeChallange: string): string;
    function V2_Login_Token_GetFromCode(const HTTP: TIdHTTP; const ACode: string; const ACodeVerifier: string): boolean;
    function V2_Login_Token_Refresh(const HTTP: TIdHTTP): boolean;
    function V2_Login_Token_Revoke(const HTTP: TIdHTTP): boolean;

    // Login - processer & modifier
    function V2_Login_LoggedIn(const HTTP: TIdHTTP; out Succeeded: boolean): boolean;
  end;

const
  ENDPOINT_API = 'https://api.ibroadcast.com/';

var
  Form1: TForm1;

  // Settings
  //Settings: TSettingsManager;
  SettingsSession: TSectionSettingsManager;

implementation

function TForm1.V2_CreateHTTP: TIdHTTP;
begin
  Result := TIdHTTP.Create(nil);

  // Init SSL
  const V2_SSL = TIdSSLIOHandlerSocketOpenSSL.Create(Result);
  V2_SSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
  Result.IOHandler := V2_SSL;
end;

function TForm1.V2_GetBody: IJObject;
begin
  Result := TJObject.CreateNew;
  Result.Put('client', Edit2.Text);
  Result.Put('version', Edit3.ToString);
  Result.Put('device_name', Edit1.Text);
  Result.Put('user_agent', Edit4.Text);
end;

function TForm1.V2_RequestPost(const HTTP: TIdHTTP; const Body: IJValue; const Endpoint: string; const Authorization: string): IJValue;
var
  ResponseStream, RequestStream: TStringStream;
begin
  Result := nil;

  // Set options
  HTTP.HTTPOptions := HTTP.HTTPOptions + [hoNoProtocolErrorException, hoWantProtocolErrorContent, hoWaitForUnexpectedData];

  // Set headers
  HTTP.Request.CustomHeaders.Clear;

  if Body <> nil then
    HTTP.Request.ContentType := 'application/json; charset=utf-8';

  if Authorization <> '' then
    HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Authorization);

  // Send request and receive response
  RequestStream := TStringStream.Create('', TEncoding.UTF8);
  ResponseStream := TStringStream.Create('', TEncoding.UTF8);
  if Body <> nil then
    RequestStream.WriteString(Body.ToJSON);
  try
    try
      if AllowDebug then AddToLog('POST: '+Endpoint);
      HTTP.Post(Endpoint, RequestStream, ResponseStream);
      if AllowDebug then AddToLog('HEADERS:'+sLineBreak+string.Join(sLineBreak, HTTP.Request.RawHeaders.ToStringArray));
      if AllowDebug then AddToLog('BODY:'+sLineBreak+RequestStream.DataString);

      // Parse response and extract numbers
      if (ResponseStream.Size > 0) and (ResponseStream.DataString <> 'OK') then
        Result := TJValue.ParseJson(ResponseStream.DataString);
      if AllowDebug then AddToLog('RESPONSE:'+ResponseStream.DataString+sLineBreak+sLineBreak);
    except
      on E: Exception do begin
        AddToLog(E.ClassName+': '+E.Message);
        Exit;
      end;
    end;
  finally
    RequestStream.Free;
    ResponseStream.Free;
  end;
end;

function TForm1.V2_RequestPost(const HTTP: TIdHTTP; const Body: TStringList; const Endpoint: string; const Authorization: string=''): IJValue;
var
  ResponseStream: TStringStream;
begin
  Result := nil;

  // Set options
  HTTP.HTTPOptions := HTTP.HTTPOptions + [hoNoProtocolErrorException, hoWantProtocolErrorContent, hoWaitForUnexpectedData];

  // Set headers
  HTTP.Request.CustomHeaders.Clear;

  if Body <> nil then
    HTTP.Request.ContentType := 'application/x-www-form-urlencoded; charset=utf-8';

  if Authorization <> '' then
    HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Authorization);

  // Send request and receive response
  ResponseStream := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      if AllowDebug then AddToLog('POST: '+Endpoint);
      HTTP.Post(Endpoint, Body, ResponseStream);
      if AllowDebug then AddToLog('HEADERS:'+sLineBreak+string.Join(sLineBreak, HTTP.Request.RawHeaders.ToStringArray));
      if AllowDebug then AddToLog('BODY:'+sLineBreak+Body.Text);

      // Parse response and extract numbers
      if (ResponseStream.Size > 0) then begin
        if ResponseStream.DataString = 'OK' then
          Exit( TJNull.CreateNew );
        Result := TJValue.ParseJson(ResponseStream.DataString);
      end;
      if AllowDebug then AddToLog('RESPONSE:'+ResponseStream.DataString+sLineBreak+sLineBreak);
    except
      on E: Exception do begin
        AddToLog(E.ClassName+': '+E.Message);
        Exit;
      end;
    end;
  finally
    ResponseStream.Free;
  end;
end;

function TForm1.V2_Login_AuthorizeURL(const State: string; const ACodeChallange: string): string;
begin
  Result :=
    'https://oauth.ibroadcast.com/authorize?' +
    'client_id=' + TIdURI.ParamsEncode(OAUTH2_CLIENT_ID) +
    '&state=' + TIdURI.ParamsEncode(State) +
    '&response_type=' + TIdURI.ParamsEncode('code') +
    '&code_challenge=' + TIdURI.ParamsEncode(ACodeChallange) +
    '&code_challenge_method=S256' +
    '&scope=' + TIdURI.ParamsEncode(OAUTH2_SCOPE);
end;

function TForm1.V2_Login_LoggedIn(const HTTP: TIdHTTP;
  out Succeeded: boolean): boolean;
begin
 Result := false;

  const Body = V2_GetBody;
  Body.Put('mode', 'status');

  const Response = V2_RequestPost(HTTP, Body, ENDPOINT_API, OAuth2_AccessToken);
  Succeeded := Response <> nil;
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;

  // Logged in
  Result := Obj.KeyExists('authenticated') and Obj['authenticated'].AsBoolean;

  // Migrate refresh token (if access token failed, or it expired/expires in the next 30 minutes)
  if OAuth2_RefreshToken <> '' then
    if (Succeeded and not Result)
      or (IncMinute(Now, 30) >= OAuth2_Expiry) then begin
      Result := V2_Login_Token_Refresh(HTTP);
    end;

  // Clear login on server confirmation
  if Succeeded and not Result then begin
    OAuth2_RefreshToken := '';
    OAuth2_AccessToken := '';
    OAuth2_Expiry := 0;
  end;
end;

function TForm1.V2_Login_Token_GetFromCode(const HTTP: TIdHTTP; const ACode: string; const ACodeVerifier: string): boolean;
var
  Params: TStringList;
  Response: IJValue;
begin
  Result := false;
  //
  Params := TStringList.Create;
  try
    Params.Add('grant_type=authorization_code');
    Params.Add('code=' + ACode);
    Params.Add('client_id=' + OAUTH2_CLIENT_ID);
    Params.Add('redirect_uri=' + OAUTH2_REDIRECT_URI);
    Params.Add('code_verifier=' + ACodeVerifier);

    // Send
    Response := V2_RequestPost(HTTP, Params,'https://oauth.ibroadcast.com/token');
  finally
    Params.Free;
  end;

  //
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  if not (Obj.KeyExists('access_token') and Obj.KeyExists('expires_in') and Obj.KeyExists('refresh_token')) then
    Exit;

  //
  OAuth2_RefreshToken := Obj['refresh_token'].AsString;
  OAuth2_AccessToken := Obj['access_token'].AsString;
  OAuth2_Expiry := IncSecond(Now, Obj['expires_in'].AsInteger);

  //
  Result := true;
end;

function TForm1.V2_Login_Token_Refresh(const HTTP: TIdHTTP): boolean;
var
  Params: TStringList;
  Response: IJValue;
begin
  Result := false;
  //
  Params := TStringList.Create;
  try
    Params.Add('grant_type=refresh_token');
    Params.Add('refresh_token=' + OAuth2_RefreshToken);
    Params.Add('client_id=' + OAUTH2_CLIENT_ID);
    Params.Add('redirect_uri=' + OAUTH2_REDIRECT_URI);

    // Send
    Response := V2_RequestPost(HTTP, Params,'https://oauth.ibroadcast.com/token');
  finally
    Params.Free;
  end;

  //
  if (Response = nil) or not Response.IsObject then
    Exit;
  const Obj = Response.AsObject;
  if not (Obj.KeyExists('access_token') and Obj.KeyExists('expires_in') and Obj.KeyExists('refresh_token')) then
    Exit;

  //
  OAuth2_RefreshToken := Obj['refresh_token'].AsString;
  OAuth2_AccessToken := Obj['access_token'].AsString;
  OAuth2_Expiry := IncSecond(Now, Obj['expires_in'].AsInteger);

  //
  Result := true;
end;

function TForm1.V2_Login_Token_Revoke(const HTTP: TIdHTTP): boolean;
var
  Params: TStringList;
  Response: IJValue;
begin
  Result := false;
  //
  Params := TStringList.Create;
  try
    Params.Add('refresh_token=' + OAuth2_RefreshToken);
    Params.Add('client_id=' + OAUTH2_CLIENT_ID);

    // Send
    Response := V2_RequestPost(HTTP, Params,'https://oauth.ibroadcast.com/revoke');
  finally
    Params.Free;
  end;

  //
  if Response = nil then
    Exit;
  if Response.IsObject then begin
    const Obj = Response.AsObject;
    Result := not Obj.KeyExists('error');
    if not Result then Exit;
  end;
  Result := true;

  OAuth2_RefreshToken := '';
  OAuth2_AccessToken := '';
  OAuth2_Expiry := 0;
end;


{$R *.dfm}

procedure TForm1.AddToLog(S: string);
begin
  Memo2.Lines.Add(TimeToStr(Now)+sLineBreak+S);
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  Res: boolean;
begin
  Res := V2_Login_Token_Refresh(V2_HTTP);

  AddToLog('OPERATION: V2_Login_Token_Refresh'
    +'Result: '+booleantostring(Res)+sLineBreak
  );
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  Memo2.Clear;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  Edit13.Text := TNetEncoding.Base64URL.EncodeBytesToString(
    THashSHA2.GetHashBytes(Edit12.Text, THashSHA2.TSHA2Version.SHA256)
  );
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  NumberBox2.ValueInt := Random(100000);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Res: boolean;
begin
  Res := V2_Login_Token_GetFromCode(V2_HTTP, Edit11.Text, Edit12.Text);

  AddToLog('OPERATION: V2_Login_Token_GetFromCode'
    +'Result: '+booleantostring(Res)+sLineBreak
  );
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ShellRun(V2_Login_AuthorizeURL(NumberBox2.Text, Edit13.Text), true);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  // Verifier
  Edit12.Text := TNetEncoding.Base64URL.EncodeBytesToString(TEncoding.UTF8.GetBytes(TGUID.NewGuid.ToString));

  // Challange
  Button12.OnClick(Button12);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  with Edit8 do begin
    Text := Hint;
    Hint := '';
  end;
  TButton(Sender).Enabled := false;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  with Edit9 do begin
    Text := Hint;
    Hint := '';
  end;
  TButton(Sender).Enabled := false;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  with NumberBox3 do begin
    Text := Hint;
    Hint := '';
  end;
  TButton(Sender).Enabled := false;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  Success,
  Res: boolean;
begin
  Res := V2_Login_LoggedIn(V2_HTTP, Success);

  AddToLog('OPERATION: V2_Login_LoggedIn'
    +'Success: '+booleantostring(Success)+sLineBreak
    +'Result: '+booleantostring(Res)+sLineBreak
  );
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  Res: boolean;
begin
  Res := V2_Login_Token_Revoke(V2_HTTP);

  AddToLog('OPERATION: V2_Login_Token_Revoke'
    +'Result: '+booleantostring(Res)+sLineBreak
  );
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  // Try
  try
    if TCheckbox(Sender).Checked then begin
      IdHTTPServer1.Bindings.Clear;

      with IdHTTPServer1.Bindings.Add do begin
        IP := '127.0.0.1';
        Port := NumberBox1.ValueInt;
      end;
    end;

    IdHTTPServer1.Active := TCheckbox(Sender).Checked;
  except
    TCheckbox(Sender).Checked := false;
  end;

  // UI
  NumberBox1.Enabled := not TCheckbox(Sender).Checked;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<boolean>('validate_state', TCheckbox(Sender).Checked);
end;

procedure TForm1.Edit11Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused or (TControl(Sender).Tag = 1) then begin
    SettingsSession.Put<string>('response_code', TEdit(Sender).Text);
    TControl(Sender).Tag := 0;
  end;
end;

procedure TForm1.Edit12Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('login_verifier', TEdit(Sender).Text);
end;

procedure TForm1.Edit13Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('login_challange', TEdit(Sender).Text);
end;

procedure TForm1.Edit14Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('client_scope', TEdit(Sender).Text);
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('name', TEdit(Sender).Text);
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('id', TEdit(Sender).Text);
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('version', TEdit(Sender).Text);
end;

procedure TForm1.Edit4Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('user_agent', TEdit(Sender).Text);
end;

procedure TForm1.Edit5Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('client_id', TEdit(Sender).Text);
end;

procedure TForm1.Edit6Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('client_secret', TEdit(Sender).Text);
end;

procedure TForm1.Edit7Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<string>('redirect_uri', TEdit(Sender).Text);
end;

procedure TForm1.Edit8Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused or (TControl(Sender).Tag = 1) then begin
    SettingsSession.Put<string>('refresh_token', TEdit(Sender).Text);
    TControl(Sender).Tag := 0;
  end;
end;

procedure TForm1.Edit9Change(Sender: TObject);
begin
  if TWinControl(Sender).Focused or (TControl(Sender).Tag = 1) then begin
    SettingsSession.Put<string>('access_token', TEdit(Sender).Text);
    TControl(Sender).Tag := 0;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  V2_HTTP := V2_CreateHTTP;

  FExpiryRelativeTo := Now;
  //

  Button1.OnClick(Button1);
  Button4.OnClick(Button4);





  // Load settings
  Edit1.Text := SettingsSession.Get<string>('name', Edit1.Text);
  Edit2.Text := SettingsSession.Get<string>('id', Edit2.Text);
  Edit3.Text := SettingsSession.Get<string>('version', Edit3.Text);
  Edit4.Text := SettingsSession.Get<string>('user_agent', Edit4.Text);
  Edit5.Text := SettingsSession.Get<string>('client_id', Edit5.Text);
  Edit6.Text := SettingsSession.Get<string>('client_secret', Edit6.Text);
  Edit7.Text := SettingsSession.Get<string>('redirect_uri', Edit7.Text);
  Edit8.Text := SettingsSession.Get<string>('refresh_token', Edit8.Text);
  Edit9.Text := SettingsSession.Get<string>('access_token', Edit9.Text);
  NumberBox3.ValueInt := SettingsSession.Get<integer>('expiry', NumberBox3.ValueInt);
    FExpiryRelativeTo := SettingsSession.Get<double>('expiry_relative_to', FExpiryRelativeTo);
  NumberBox2.ValueInt := SettingsSession.Get<integer>('login_state', NumberBox2.ValueInt);
  Checkbox1.Checked := SettingsSession.Get<boolean>('validate_state', Checkbox1.Checked);
  Edit11.Text := SettingsSession.Get<string>('response_code', Edit11.Text);
  NumberBox1.ValueInt := SettingsSession.Get<integer>('port', NumberBox1.ValueInt);
  Edit12.Text := SettingsSession.Get<string>('login_verifier', Edit12.Text);
  Edit13.Text := SettingsSession.Get<string>('login_challange', Edit13.Text);

  // Start server
  CheckBox1.Checked := true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  V2_HTTP.Free;
end;

function TForm1.GetAllowDebug: boolean;
begin
  Result := CheckBox3.Checked;
end;

function TForm1.Get_OAuth2_AccessToken: string;
begin Exit(Edit9.Text); end;

function TForm1.Get_OAUTH2_CLIENT_ID: string;
begin Exit(Edit5.Text); end;

function TForm1.Get_OAuth2_Expiry: TDateTime;
begin Exit(IncSecond(ExpiryRelativeTo, NumberBox3.ValueInt)); end;

function TForm1.Get_OAuth2_RefreshToken: string;
begin Exit(Edit8.Text); end;

function TForm1.Get_OAUTH2_SCOPE: string;
begin Exit(Edit14.Text); end;

function TForm1.Get_REDIRECT_URI: string;
begin Exit(Edit7.Text); end;

procedure TForm1.IdHTTPServer1AfterBind(Sender: TObject);
begin
  Memo1.Lines.Add('Bound successfully!');
end;

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  Memo1.Lines.Add('Server got command!');
  if ARequestInfo.CommandType <> hcGET then begin
    Memo1.Lines.Add('Not-GET!');
    Exit;
  end;

  AResponseInfo.ResponseNo := 200;
  AResponseInfo.ContentType := 'text/plain';

  // Get
  const OAuth2State_Fetched = ARequestInfo.Params.Values['state'];
  const OAuth2State_ErrorDesc = ARequestInfo.Params.Values['error_description'];

  if OAuth2State_ErrorDesc <> '' then begin
    Memo1.Lines.Add('Server error: '+OAuth2State_ErrorDesc);

    AResponseInfo.ContentText := 'Server error: '+OAuth2State_ErrorDesc;
    Exit;
  end;
  if OAuth2State_Fetched <> NumberBox2.ValueInt.ToString then begin
    Memo1.Lines.Add('Secure state check failed');

    if CheckBox2.Checked then begin
      AResponseInfo.ContentText := 'Secure code validation failed.';
      Exit;
    end else
      Memo1.Lines.Add('Ignoring failure!');
  end;

  // Set
  TThread.Synchronize(nil, procedure begin
    Edit11.Tag := 1;
    Edit11.Text := ARequestInfo.Params.Values['code'];
  end);

  // Success
  AResponseInfo.ContentText := 'Authorization successful. You can close this window.';
end;

procedure TForm1.IdHTTPServer1Connect(AContext: TIdContext);
begin
  Memo1.Lines.Add('Connected on port '+AContext.Connection.Socket.Port.ToString);
end;

procedure TForm1.IdHTTPServer1Disconnect(AContext: TIdContext);
begin
  Memo1.Lines.Add('Discnnected on port '+AContext.Connection.Socket.Port.ToString);
end;

procedure TForm1.IdHTTPServer1Exception(AContext: TIdContext;
  AException: Exception);
begin
  Memo1.Lines.Add(AException.ClassName+': '+AException.Message);
end;

procedure TForm1.NumberBox1ChangeValue(Sender: TObject);
begin
  if TWinControl(Sender).Focused then
    SettingsSession.Put<integer>('login_port', TNumberBox(Sender).ValueInt);
end;

procedure TForm1.NumberBox2ChangeValue(Sender: TObject);
begin
  if TWinControl(Sender).Focused or Button1.Focused then
    SettingsSession.Put<integer>('login_state', TNumberBox(Sender).ValueInt);
end;

procedure TForm1.NumberBox3ChangeValue(Sender: TObject);
begin
  if TWinControl(Sender).Focused or (TControl(Sender).Tag = 1) then begin
    SettingsSession.Put<integer>('expiry', TNumberBox(Sender).ValueInt);
    TControl(Sender).Tag := 0;
  end;
end;

procedure TForm1.SetExpiryRelativeTo(const Value: TDateTime);
begin
  FExpiryRelativeTo := Value;

  SettingsSession.Put<double>('expiry_relative_to', FExpiryRelativeTo);
end;

procedure TForm1.Set_OAuth2_AccessToken(const AValue: string);
begin
  with Edit9 do begin
    Hint := Text;
    Button6.Enabled := true;
    Button6.Hint := Hint;

    Tag := 1;
    Text := AValue;
  end;
end;

procedure TForm1.Set_OAuth2_Expiry(const AValue: TDateTime);
begin
  with Numberbox3 do begin
    Hint := Text;
    Button7.Enabled := true;
    Button7.Hint := Hint;

    Tag := 1;
    Text := SecondsBetween(ExpiryRelativeTo, AValue).ToString;
  end;
end;

procedure TForm1.Set_OAuth2_RefreshToken(const AValue: string);
begin
  with Edit8 do begin
    Hint := Text;
    Button5.Enabled := true;
    Button5.Hint := Hint;

    Tag := 1;
    Text := AValue;
  end;
end;

procedure TForm1.UpdateUITimer(Sender: TObject);
begin
  const NewDate = IncSecond(ExpiryRelativeTo, NumberBox3.ValueInt);
  Label28.Caption := DateTimeToStr(NewDate);

  if NewDate <= Now then
    Label28.Caption := Label28.Caption + ' (expired)';
end;


initialization
  SettingsSession := TSectionSettingsManager.Create(
    IncludeTrailingPathDelimiteR(ExtractFileDir(ParamStr(0)))+'settings.ini',
    'Last session'
  );
finalization
  SettingsSession.Free;
end.
