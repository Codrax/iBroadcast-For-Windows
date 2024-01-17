unit HelpForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.TitleBarCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Cod.Visual.Image, Cod.SysUtils,
  Cod.Visual.Button;

type
  THelpUI = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    HelpCat: TPanel;
    CButton25: CButton;
    CButton1: CButton;
    Panel2: TPanel;
    Label8: TLabel;
    Topics: TPanel;
    Topic_1: TScrollBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    CImage4: CImage;
    Label12: TLabel;
    CImage5: CImage;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Panel3: TPanel;
    Topic_2: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CImage1: CImage;
    Label4: TLabel;
    CImage2: CImage;
    Label6: TLabel;
    Label7: TLabel;
    CImage3: CImage;
    Label5: TLabel;
    Panel4: TPanel;
    Label16: TLabel;
    Topic_3: TScrollBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Panel1: TPanel;
    CButton2: CButton;
    Label24: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    CButton3: CButton;
    Topic_4: TScrollBox;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label46: TLabel;
    Panel5: TPanel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    CImage6: CImage;
    Label45: TLabel;
    Label47: TLabel;
    CImage7: CImage;
    procedure FormCreate(Sender: TObject);
    procedure Topic_2MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure HelpTopicSelect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HelpUI: THelpUI;

implementation

{$R *.dfm}

procedure THelpUI.HelpTopicSelect(Sender: TObject);
var
  I, ID: Integer;
begin
  ID := CButton(Sender).Tag;

  for I := 0 to Topics.ControlCount - 1 do
    if Topics.Controls[I] is TScrollBox then
      with TScrollBox(Topics.Controls[I]) do
        Visible := Tag = ID;
end;

procedure THelpUI.FormCreate(Sender: TObject);
begin
  // UX
  Font.Color := clWhite;
  with CustomTitleBar do
    begin
      Enabled := true;

      CaptionAlignment := taCenter;
      ShowIcon := false;

      SystemColors := false;
      SystemButtons := false;

      Control := TitleBarPanel;

      PrepareCustomTitleBar( TForm(Self), Color, clWhite);

      InactiveBackgroundColor := BackgroundColor;
      ButtonInactiveBackgroundColor := BackgroundColor;
    end;
end;

procedure THelpUI.Topic_2MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TScrollBox(Sender).VertScrollBar.Position := TScrollBox(Sender).VertScrollBar.Position - WheelDelta div 8;
end;

end.
