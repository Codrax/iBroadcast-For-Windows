object InfoBox: TInfoBox
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Song title here'
  ClientHeight = 374
  ClientWidth = 784
  Color = 2886678
  Constraints.MinHeight = 360
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
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 325
    Top = 50
    Width = 434
    Height = 299
    Margins.Left = 25
    Margins.Top = 25
    Margins.Right = 25
    Margins.Bottom = 25
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object Song_Name: TLabel
      AlignWithMargins = True
      Left = 25
      Top = 5
      Width = 384
      Height = 37
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
      ExplicitWidth = 199
    end
    object Song_Info: TLabel
      AlignWithMargins = True
      Left = 25
      Top = 52
      Width = 384
      Height = 21
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
      ExplicitWidth = 195
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 25
    Top = 50
    Width = 250
    Height = 299
    Margins.Left = 25
    Margins.Top = 25
    Margins.Right = 25
    Margins.Bottom = 25
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel1'
    ParentColor = True
    ShowCaption = False
    TabOrder = 2
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
      PopupMenu = Popup_Right
      ExplicitWidth = 372
    end
    object Download_Item: CButton
      AlignWithMargins = True
      Left = 15
      Top = 235
      Width = 220
      Height = 38
      Margins.Left = 15
      Margins.Top = 5
      Margins.Right = 15
      Margins.Bottom = 0
      OnEnter = Download_ItemEnter
      OnClick = Download_ItemClick
      TabOrder = 0
      Align = alTop
      BSegoeIcon = #59542
      ButtonIcon = cicSegoeFluent
      UseAccentColor = acNone
      GradientOptions.Enabled = False
      GradientOptions.Enter = clFuchsia
      GradientOptions.Leave = clRed
      GradientOptions.Down = clMaroon
      ControlStyle = []
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 14123546
      Font.Height = -16
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      SubTextFont.Charset = DEFAULT_CHARSET
      SubTextFont.Color = 14123546
      SubTextFont.Height = -13
      SubTextFont.Name = 'Segoe UI'
      SubTextFont.Style = []
      FontAutoSize.Enabled = False
      FontAutoSize.Max = -1
      FontAutoSize.Min = -1
      Text = 'Download'
      SubText = 'Hello World!'
      State = mbsLeave
      Colors.Enter = 5771359
      Colors.Leave = 4853328
      Colors.Down = 3539258
      Colors.BLine = 3539258
      Preset.Color = clBlue
      Preset.Kind = cbprCustom
      Preset.PenColorAuto = True
      Preset.ApplyOnce = False
      Preset.IgnoreGlobalSync = False
      UnderLine.Enable = True
      UnderLine.UnderLineRound = True
      UnderLine.UnderLineThicknes = 6
      TextColors.Enter = clWhite
      TextColors.Leave = clWhite
      TextColors.Down = clWhite
      TextColors.BLine = clBlack
      Pen.Color = 2886678
      Pen.Width = 0
      Pen.EnableAlternativeColors = False
      Pen.FormSyncedColor = False
      Pen.AltHoverColor = clBlack
      Pen.AltPressColor = clBlack
      Pen.GlobalPresetExcept = False
      Animations.PressAnimation = True
      Animations.PADelay = 2
      Animations.PAShrinkAmount = 4
      Animations.PAAnimateEngine = cbneAtDraw
      Animations.FadeAnimation = True
      Animations.FASpeed = 10
    end
  end
  object Popup_Right: TPopupMenu
    OwnerDraw = True
    Left = 645
    Top = 222
    object Information1: TMenuItem
      Caption = 'Save Cover'
      Hint = #59675
      OnClick = Information1Click
    end
  end
  object SavePicture: TSavePictureDialog
    Filter = 'JPEG Image File (*.jpeg)|*.jpeg'
    Left = 661
    Top = 58
  end
end
