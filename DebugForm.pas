unit DebugForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Cod.Visual.Image, Cod.Visual.Button, BroadcastAPI, Vcl.Clipbrd, JSON,
  Vcl.ExtCtrls, Cod.Types, Bass, Vcl.WinXCtrls;

type
  TDebugUI = class(TForm)
    CImage1: CImage;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    CButton1: CButton;
    CButton2: CButton;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    CButton3: CButton;
    CButton4: CButton;
    Memo3: TMemo;
    CButton5: CButton;
    DataSync: TTimer;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    CButton6: CButton;
    Label9: TLabel;
    Label10: TLabel;
    SearchBox1: TSearchBox;
    Label11: TLabel;
    Label12: TLabel;
    procedure CButton1Click(Sender: TObject);
    procedure CButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CButton3Click(Sender: TObject);
    procedure CButton4Click(Sender: TObject);
    procedure CButton5Click(Sender: TObject);
    procedure DataSyncTimer(Sender: TObject);
    procedure CButton6Click(Sender: TObject);
    procedure SearchBox1InvokeSearch(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DebugUI: TDebugUI;

implementation

uses
  MainUI;

{$R *.dfm}

procedure TDebugUI.CButton1Click(Sender: TObject);
begin
  Clipboard.AsText := TOKEN;
end;

procedure TDebugUI.CButton2Click(Sender: TObject);
begin
  Clipboard.AsText := USER_ID.ToString;
end;

procedure TDebugUI.CButton3Click(Sender: TObject);
begin
  Memo2.Text := SendClientRequest( StringReplace(Memo1.Text, #13, '', [rfReplaceAll]) ).ToJSON;
end;

procedure TDebugUI.CButton4Click(Sender: TObject);
begin
  Clipboard.AsText := STREAMING_ENDPOINT + Tracks[PlayIndex].StreamLocations
end;

procedure TDebugUI.CButton5Click(Sender: TObject);
var
  I: Integer;
begin
  Memo3.Clear;

  for I := 0 to PlayQueue.Count - 1 do
    Memo3.Lines.Add( PlayQueue[I].ToString )
end;

procedure TDebugUI.CButton6Click(Sender: TObject);
begin
  UIForm.ReloadArtwork;
end;

procedure TDebugUI.DataSyncTimer(Sender: TObject);
begin
  // Sync
  Label6.Caption := 'Hover: ' + MainUI.IndexHover.ToString;
  Label7.Caption := 'Hover SH: ' + MainUI.IndexHoverID.ToString;
  Label9.Caption := '10s Shrink:' + MainUI.Press10Stat.ToString;
  Label10.Caption := 'Ch Active: ' + BooleanToString( BASS_ChannelIsActive(Player.Stream) = BASS_ACTIVE_PLAYING );
  Label11.Caption := 'Img-Thread: ' + TotalThreads.ToString;
  Label12.Caption := 'Img-Thread: ' + DownloadThreadsE.ToString;
end;

procedure TDebugUI.FormCreate(Sender: TObject);
begin
  Top := Screen.Height - height;
  Left := Screen.Width - Width;
end;

procedure TDebugUI.SearchBox1InvokeSearch(Sender: TObject);
begin
  UIForm.FiltrateSearch( SearchBox1.Text );
end;

end.
