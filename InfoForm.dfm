object InfoBox: TInfoBox
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Song title here'
  ClientHeight = 328
  ClientWidth = 784
  Color = 2886678
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 21
  object TitleBarPanel: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 25
    CustomButtons = <>
    ExplicitLeft = -425
    ExplicitWidth = 709
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 325
    Top = 50
    Width = 434
    Height = 253
    Margins.Left = 25
    Margins.Top = 25
    Margins.Right = 25
    Margins.Bottom = 25
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = 25
    ExplicitWidth = 448
    ExplicitHeight = 402
    object Song_Name: TLabel
      AlignWithMargins = True
      Left = 25
      Top = 5
      Width = 384
      Height = 74
      Margins.Left = 25
      Margins.Top = 5
      Margins.Right = 25
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Song name here'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -27
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 145
    end
    object Song_Info: TLabel
      AlignWithMargins = True
      Left = 25
      Top = 89
      Width = 384
      Height = 63
      Margins.Left = 25
      Margins.Top = 5
      Margins.Right = 25
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Description and information'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitTop = 274
      ExplicitWidth = 82
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 25
    Top = 50
    Width = 250
    Height = 253
    Margins.Left = 25
    Margins.Top = 25
    Margins.Right = 25
    Margins.Bottom = 25
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 2
    ExplicitHeight = 402
    object Song_Cover: CImage
      AlignWithMargins = True
      Left = 25
      Top = 25
      Width = 200
      Height = 200
      Margins.Left = 25
      Margins.Top = 25
      Margins.Right = 25
      Margins.Bottom = 5
      Align = alTop
      Smooth = True
      Opacity = 255
      GifSettings.Enable = False
      GifSettings.AnimationSpeed = 100
      DrawMode = dmCenterFit
      ExplicitWidth = 372
    end
  end
end
