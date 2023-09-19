object PerfForm: TPerfForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'CPU Performance Form'
  ClientHeight = 341
  ClientWidth = 709
  Color = 2886678
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 25
    Width = 709
    Height = 316
    Align = alClient
    OnPaint = PaintBox1Paint
    ExplicitTop = 31
  end
  object TitleBarPanel: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 709
    Height = 25
    CustomButtons = <>
  end
  object AddNew: TTimer
    Enabled = False
    Interval = 250
    OnTimer = AddNewTimer
    Left = 32
    Top = 24
  end
end
