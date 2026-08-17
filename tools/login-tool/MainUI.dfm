object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 761
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    884
    761)
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 32
    Width = 254
    Height = 37
    Caption = 'iBroadcast Login Tool'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 69
    Width = 86
    Height = 15
    Caption = 'Codrut Software'
  end
  object Label3: TLabel
    Left = 24
    Top = 100
    Width = 64
    Height = 21
    Caption = 'App info'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 24
    Top = 127
    Width = 32
    Height = 15
    Caption = 'Name'
  end
  object Label5: TLabel
    Left = 24
    Top = 187
    Width = 11
    Height = 15
    Caption = 'ID'
  end
  object Label6: TLabel
    Left = 24
    Top = 223
    Width = 38
    Height = 15
    Caption = 'Version'
  end
  object Label7: TLabel
    Left = 24
    Top = 269
    Width = 56
    Height = 15
    Caption = 'User agent'
  end
  object Label8: TLabel
    Left = 24
    Top = 322
    Width = 56
    Height = 21
    Caption = 'OAuth2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 24
    Top = 349
    Width = 45
    Height = 15
    Caption = 'Client ID'
  end
  object Label10: TLabel
    Left = 24
    Top = 397
    Width = 116
    Height = 15
    Caption = 'Client Secret (unused)'
  end
  object Label11: TLabel
    Left = 24
    Top = 445
    Width = 64
    Height = 15
    Caption = 'Redirect URI'
  end
  object Bevel1: TBevel
    Left = 240
    Top = 100
    Width = 1
    Height = 650
    Style = bsRaised
  end
  object Label12: TLabel
    Left = 263
    Top = 100
    Width = 105
    Height = 21
    Caption = '1. Login server'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 24
    Top = 554
    Width = 72
    Height = 21
    Caption = '0. Session'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object Label14: TLabel
    Left = 24
    Top = 581
    Width = 72
    Height = 15
    Caption = 'Refresh token'
  end
  object Label15: TLabel
    Left = 24
    Top = 625
    Width = 69
    Height = 15
    Caption = 'Access token'
  end
  object Label16: TLabel
    Left = 24
    Top = 669
    Width = 85
    Height = 15
    Caption = 'Expiry (seconds)'
  end
  object Label17: TLabel
    Left = 263
    Top = 246
    Width = 22
    Height = 15
    Caption = 'Port'
  end
  object Label18: TLabel
    Left = 263
    Top = 313
    Width = 25
    Height = 15
    Caption = 'Logs'
  end
  object Label19: TLabel
    Left = 264
    Top = 127
    Width = 26
    Height = 15
    Caption = 'State'
  end
  object Label21: TLabel
    Left = 24
    Top = 175
    Width = 11
    Height = 15
    Caption = 'ID'
  end
  object Label20: TLabel
    Left = 263
    Top = 198
    Width = 79
    Height = 15
    Caption = 'Response code'
  end
  object Label23: TLabel
    Left = 447
    Top = 292
    Width = 95
    Height = 21
    Caption = 'Request logs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 432
    Top = 100
    Width = 1
    Height = 650
    Style = bsRaised
  end
  object Label24: TLabel
    Left = 263
    Top = 542
    Width = 58
    Height = 21
    Caption = '2. Login'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object Label22: TLabel
    Left = 447
    Top = 100
    Width = 60
    Height = 21
    Caption = '3. Token'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object Label25: TLabel
    Left = 263
    Top = 569
    Width = 36
    Height = 15
    Caption = 'Verifier'
  end
  object Label26: TLabel
    Left = 263
    Top = 615
    Width = 53
    Height = 15
    Caption = 'Challange'
  end
  object Label27: TLabel
    Left = 24
    Top = 496
    Width = 32
    Height = 15
    Caption = 'Scope'
  end
  object Label28: TLabel
    Left = 24
    Top = 719
    Width = 49
    Height = 15
    Caption = 'unknown'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object Label29: TLabel
    Left = 447
    Top = 173
    Width = 72
    Height = 21
    Caption = '4. Actions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 24
    Top = 142
    Width = 200
    Height = 23
    TabOrder = 0
    Text = 'iBroadcast for Windows'
    OnChange = Edit1Change
  end
  object Edit2: TEdit
    Left = 24
    Top = 190
    Width = 200
    Height = 23
    TabOrder = 1
    Text = 'com.codrutsoft.ibroadcast'
    OnChange = Edit2Change
  end
  object Edit3: TEdit
    Left = 24
    Top = 238
    Width = 200
    Height = 23
    TabOrder = 2
    Text = '1.0.0.0'
    OnChange = Edit3Change
  end
  object Edit4: TEdit
    Left = 24
    Top = 284
    Width = 200
    Height = 23
    TabOrder = 3
    Text = 'Cod'#39'siBroadcast/1.0.0.0'
    OnChange = Edit4Change
  end
  object Edit5: TEdit
    Left = 24
    Top = 368
    Width = 200
    Height = 23
    TabOrder = 4
    Text = '9ad81c4a98db11f1b50eb49691aa2236'
    OnChange = Edit5Change
  end
  object Edit6: TEdit
    Left = 24
    Top = 412
    Width = 200
    Height = 23
    TabOrder = 5
    OnChange = Edit6Change
  end
  object Edit7: TEdit
    Left = 24
    Top = 460
    Width = 200
    Height = 23
    TabOrder = 6
    Text = 'http://127.0.0.1:49321/'
    OnChange = Edit7Change
  end
  object Edit8: TEdit
    Left = 24
    Top = 596
    Width = 161
    Height = 23
    ParentShowHint = False
    ShowHint = False
    TabOrder = 7
    OnChange = Edit8Change
  end
  object Edit9: TEdit
    Left = 24
    Top = 640
    Width = 161
    Height = 23
    ParentShowHint = False
    ShowHint = False
    TabOrder = 8
    OnChange = Edit9Change
  end
  object NumberBox1: TNumberBox
    Left = 263
    Top = 261
    Width = 150
    Height = 23
    MaxValue = 65535.000000000000000000
    TabOrder = 9
    Value = 49321.000000000000000000
    OnChangeValue = NumberBox1ChangeValue
  end
  object CheckBox1: TCheckBox
    Left = 263
    Top = 290
    Width = 97
    Height = 17
    Caption = 'Enabled'
    TabOrder = 10
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 263
    Top = 334
    Width = 150
    Height = 200
    ScrollBars = ssVertical
    TabOrder = 11
  end
  object NumberBox2: TNumberBox
    Left = 263
    Top = 142
    Width = 91
    Height = 23
    MaxValue = 2147483647.000000000000000000
    TabOrder = 12
    OnChangeValue = NumberBox2ChangeValue
  end
  object Button1: TButton
    Left = 360
    Top = 142
    Width = 53
    Height = 23
    Caption = 'Regen'
    TabOrder = 13
    OnClick = Button1Click
  end
  object CheckBox2: TCheckBox
    Left = 264
    Top = 171
    Width = 149
    Height = 17
    Caption = 'Validate state'
    TabOrder = 14
    OnClick = CheckBox2Click
  end
  object Edit11: TEdit
    Left = 263
    Top = 213
    Width = 149
    Height = 23
    TabOrder = 15
    OnChange = Edit11Change
  end
  object Memo2: TMemo
    Left = 447
    Top = 322
    Width = 415
    Height = 428
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 16
    ExplicitWidth = 315
  end
  object Button3: TButton
    Left = 322
    Top = 659
    Width = 89
    Height = 40
    Caption = 'Open URL'
    TabOrder = 17
    OnClick = Button3Click
  end
  object Button2: TButton
    Left = 446
    Top = 127
    Width = 149
    Height = 40
    Caption = 'Fetch token'
    TabOrder = 18
    OnClick = Button2Click
  end
  object Edit12: TEdit
    Left = 263
    Top = 584
    Width = 150
    Height = 23
    TabOrder = 19
    OnChange = Edit12Change
  end
  object Edit13: TEdit
    Left = 263
    Top = 630
    Width = 150
    Height = 23
    TabOrder = 20
    OnChange = Edit13Change
  end
  object Button4: TButton
    Left = 263
    Top = 659
    Width = 53
    Height = 40
    Caption = 'Regen'
    TabOrder = 21
    OnClick = Button4Click
  end
  object Edit14: TEdit
    Left = 24
    Top = 511
    Width = 200
    Height = 23
    TabOrder = 22
    Text = 
      'user.account:read user.devices:read user.library:read user.libra' +
      'ry:write'
    OnChange = Edit14Change
  end
  object NumberBox3: TNumberBox
    Left = 24
    Top = 690
    Width = 161
    Height = 23
    MaxValue = 2147483647.000000000000000000
    ParentShowHint = False
    ShowHint = False
    TabOrder = 23
    OnChangeValue = NumberBox3ChangeValue
  end
  object Button5: TButton
    Left = 191
    Top = 595
    Width = 33
    Height = 24
    Caption = #55357#56579
    Enabled = False
    TabOrder = 24
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 191
    Top = 640
    Width = 33
    Height = 24
    Caption = #55357#56579
    Enabled = False
    TabOrder = 25
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 191
    Top = 690
    Width = 33
    Height = 24
    Caption = #55357#56579
    Enabled = False
    TabOrder = 26
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 447
    Top = 200
    Width = 149
    Height = 40
    Caption = 'Test login'
    TabOrder = 27
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 613
    Top = 200
    Width = 149
    Height = 40
    Caption = 'Revoke'
    TabOrder = 28
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 447
    Top = 246
    Width = 149
    Height = 40
    Caption = 'Refresh token'
    TabOrder = 29
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 764
    Top = 284
    Width = 98
    Height = 32
    Anchors = [akTop, akRight]
    Caption = 'Clear'
    TabOrder = 30
    OnClick = Button11Click
    ExplicitLeft = 664
  end
  object CheckBox3: TCheckBox
    Left = 556
    Top = 295
    Width = 97
    Height = 17
    Caption = 'Requests'
    Checked = True
    State = cbChecked
    TabOrder = 31
  end
  object IdHTTPServer1: TIdHTTPServer
    Bindings = <>
    OnAfterBind = IdHTTPServer1AfterBind
    OnConnect = IdHTTPServer1Connect
    OnDisconnect = IdHTTPServer1Disconnect
    OnException = IdHTTPServer1Exception
    OnCommandGet = IdHTTPServer1CommandGet
    Left = 368
    Top = 52
  end
  object UpdateUI: TTimer
    OnTimer = UpdateUITimer
    Left = 672
    Top = 32
  end
end
