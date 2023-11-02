object SourceUI: TSourceUI
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = '3rd Party Acknowledgements'
  ClientHeight = 561
  ClientWidth = 584
  Color = 2886678
  CustomTitleBar.Control = TitleBarPanel
  CustomTitleBar.ShowIcon = False
  Constraints.MaxWidth = 600
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -19
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    584
    561)
  TextHeight = 25
  object Label1: TLabel
    Left = 96
    Top = 48
    Width = 359
    Height = 37
    Caption = '3rd Party Acknowledgements'
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
    Height = 61
    AutoSize = False
    Caption = 
      'These are 3rd party libraries and files used in iBroadcast for W' +
      'indows.'
    EllipsisPosition = epEndEllipsis
    WordWrap = True
  end
  object Label3: TLabel
    Left = 24
    Top = 48
    Width = 53
    Height = 53
    Caption = #59715
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
    Width = 584
    Height = 0
    CustomButtons = <>
  end
  object Download_Item: CButton
    AlignWithMargins = True
    Left = 428
    Top = 510
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
    UseAccentColor = None
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
  object RichEdit1: TRichEdit
    Left = 24
    Top = 158
    Width = 540
    Height = 341
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -17
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      
        'This document contains a list of all 3rd party software used by ' +
        'this '
      'application.'
      ''
      #8226' Bass Audio Library for Delphi (shareware license)'
      'Copyright (c) 1999-2020 Un4seen Developments Ltd.'
      'https://www.un4seen.com/'
      ''
      #8226' Delphi-Bass improved'
      'https://github.com/TDDung/Delphi-BASS'
      ''
      #8226' Codruts Visual Library'
      'https://github.com/Codrax/CodrutsVisualLibrary'
      'https://www.codrutsoft.com/'
      'Copyright (c) 2023 Petculescu Codrut'
      ''
      #8226' Indy Internet Direct'
      'https://www.indyproject.org/'
      
        'Copyright (c) 1993 - 2018 Kudzu (Chad Z. Hower) and the Indy Pit' +
        ' '
      'Crew'
      ''
      #8226' Spectrum Visualyzation'
      'http://digilander.iol.it/Kappe/audioobject'
      'Copyright (c) Alessandro Cappellozza')
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
