object OfflineForm: TOfflineForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Network Error'
  ClientHeight = 241
  ClientWidth = 484
  Color = 2886678
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -19
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    484
    241)
  TextHeight = 25
  object Label1: TLabel
    Left = 96
    Top = 48
    Width = 305
    Height = 37
    Caption = 'It seems you are offline...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -27
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object DataText: TLabel
    Left = 96
    Top = 91
    Width = 368
    Height = 78
    AutoSize = False
    Caption = 'Are you connected to the internet?'
    EllipsisPosition = epEndEllipsis
    WordWrap = True
  end
  object Label3: TLabel
    Left = 24
    Top = 48
    Width = 53
    Height = 53
    Caption = #62340
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -53
    Font.Name = 'Segoe Fluent Icons'
    Font.Style = []
    ParentFont = False
  end
  object TitleBarPanel: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 484
    Height = 31
    CustomButtons = <>
  end
  object Download_Item: CButton
    AlignWithMargins = True
    Left = 328
    Top = 190
    Width = 136
    Height = 38
    Margins.Left = 5
    Margins.Top = 8
    Margins.Right = 15
    Margins.Bottom = 8
    ModalResult = 1
    TabOrder = 1
    Anchors = [akRight, akBottom]
    BSegoeIcon = #57345
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
    Text = 'Okay'
    SubText = 'Hello World!'
    AutoExtendImage = False
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
