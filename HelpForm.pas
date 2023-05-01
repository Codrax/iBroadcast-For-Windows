unit HelpForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.TitleBarCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Cod.Visual.Image, Cod.SysUtils;

type
  THelpUI = class(TForm)
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CImage1: CImage;
    Label4: TLabel;
    CImage2: CImage;
    Panel1: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    CImage3: CImage;
    Label5: TLabel;
    TitleBarPanel: TTitleBarPanel;
    procedure FormCreate(Sender: TObject);
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HelpUI: THelpUI;

implementation

{$R *.dfm}

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

procedure THelpUI.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TScrollBox(Sender).VertScrollBar.Position := TScrollBox(Sender).VertScrollBar.Position - WheelDelta div 8;
end;

end.
