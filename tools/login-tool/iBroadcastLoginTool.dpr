program iBroadcastLoginTool;

uses
  Vcl.Forms,
  MainUI in 'MainUI.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
