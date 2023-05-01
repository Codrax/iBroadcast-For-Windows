unit NewVersionForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.TitleBarCtrls, Vcl.Imaging.pngimage,
  Cod.Visual.Image, Vcl.StdCtrls, Cod.Visual.Button, Cod.SysUtils;

type
  TNewVersion = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    Label1: TLabel;
    CImage1: CImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Version_Old: TLabel;
    Version_New: TLabel;
    CButton1: CButton;
    CButton2: CButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewVersion: TNewVersion;

implementation

{$R *.dfm}

procedure TNewVersion.FormCreate(Sender: TObject);
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

      Self.Height := Self.Height - Height;

      InactiveBackgroundColor := BackgroundColor;
      ButtonInactiveBackgroundColor := BackgroundColor;
    end;
end;

end.
