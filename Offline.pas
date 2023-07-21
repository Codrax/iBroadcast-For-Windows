unit Offline;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.TitleBarCtrls,
  Cod.Visual.Button, Cod.SysUtils;

type
  TOfflineForm = class(TForm)
    Label1: TLabel;
    DataText: TLabel;
    Label3: TLabel;
    TitleBarPanel: TTitleBarPanel;
    Download_Item: CButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure OfflineDialog(Data: string);

var
  OfflineForm: TOfflineForm;

implementation

procedure OfflineDialog(Data: string);
begin
  OfflineForm := TOfflineForm.Create(Application);
  try
    OfflineForm.DataText.Caption := Data;

    OfflineForm.ShowModal;
  finally
    OfflineForm.Free;
  end;
end;

{$R *.dfm}

procedure TOfflineForm.FormCreate(Sender: TObject);
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
