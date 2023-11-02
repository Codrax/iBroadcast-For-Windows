unit CodeSources;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Cod.Visual.Button, Vcl.TitleBarCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Cod.SysUtils;

type
  TSourceUI = class(TForm)
    Label1: TLabel;
    DataText: TLabel;
    Label3: TLabel;
    TitleBarPanel: TTitleBarPanel;
    Download_Item: CButton;
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SourceUI: TSourceUI;

implementation

{$R *.dfm}

procedure TSourceUI.FormCreate(Sender: TObject);
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
