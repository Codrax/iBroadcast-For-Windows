unit LoggingForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Cod.Visual.Image;

type
  TLogging = class(TForm)
    CImage1: CImage;
    Label2: TLabel;
    Label1: TLabel;
    Log: TMemo;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Logging: TLogging;

implementation

{$R *.dfm}

procedure TLogging.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FreeAndNil(Self);
end;

end.

