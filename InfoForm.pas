unit InfoForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cod.SysUtils, Vcl.TitleBarCtrls,
  Cod.Visual.Image, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TInfoBox = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    Panel1: TPanel;
    Song_Name: TLabel;
    Song_Info: TLabel;
    Panel2: TPanel;
    Song_Cover: CImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FixUI;
  end;

var
  InfoBox: TInfoBox;

  InfoBoxIndex: integer;

implementation

{$R *.dfm}

procedure TInfoBox.FixUI;
begin
  // Fix Sizing
  Self.ClientHeight := Panel1.Top + Song_Name.Top + Song_Name.Height
    + Song_Info.Top + Song_Info.Height + Panel1.Margins.Bottom;
end;

procedure TInfoBox.FormCreate(Sender: TObject);
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

end.
