object Logging: TLogging
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'iBroadcast for Windows logging'
  ClientHeight = 464
  ClientWidth = 584
  Color = 2886678
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    584
    464)
  TextHeight = 21
  object Label2: TLabel
    Left = 19
    Top = 48
    Width = 134
    Height = 20
    AutoSize = False
    Caption = 'For Windows'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe UI Bold'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 19
    Top = 8
    Width = 134
    Height = 41
    AutoSize = False
    Caption = 'iBroadcast'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -24
    Font.Name = 'Segoe UI Bold'
    Font.Style = []
    ParentFont = False
    Layout = tlBottom
  end
  object Log: TMemo
    Left = 19
    Top = 74
    Width = 547
    Height = 382
    Anchors = [akLeft, akTop, akRight, akBottom]
    ParentColor = True
    TabOrder = 0
  end
end
