unit CreatePlaylistForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.TitleBarCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Cod.Visual.Button, Cod.SysUtils, Cod.Visual.CheckBox,
  BroadcastAPI, Offline, Vcl.Imaging.pngimage, Cod.Visual.Image,
  iBroadcastUtils, Cod.Forms;

type
  TCreatePlaylist = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label8: TLabel;
    Label16: TLabel;
    Download_Item: CButton;
    CButton1: CButton;
    Panel5: TPanel;
    Panel7: TPanel;
    List_Name: TEdit;
    Panel6: TPanel;
    Label2: TLabel;
    List_Description: TMemo;
    Label3: TLabel;
    Make_Public: CCheckBox;
    CImage1: CImage;
    procedure FormCreate(Sender: TObject);
    procedure List_DescriptionChange(Sender: TObject);
    procedure Download_ItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Tracks: TArray<string>;
  end;

const
  MoodTypes: TArray<string> = ['happy', 'party', 'dance', 'relaxed', 'workout', 'chill'];

var
  CreatePlaylist: TCreatePlaylist;

implementation

{$R *.dfm}

procedure TCreatePlaylist.Download_ItemClick(Sender: TObject);
begin
  if List_Name.Text = '' then
    OpenDialog('Playlist need a name', 'The playlist requires a name')
  else
    try
      // Create Playlist
      CreateNewPlayList(V2_HTTP, List_Name.Text, List_Description.Text, Make_Public.Checked, Tracks);
    except
      // Offline
      OfflineDialog('The playlist could not be created.');
    end;
end;

procedure TCreatePlaylist.FormCreate(Sender: TObject);
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

  // Data
  Tracks := [];
end;

procedure TCreatePlaylist.List_DescriptionChange(Sender: TObject);
var
  P: integer;
begin
  with TMemo(Sender) do
    begin
      P := SelStart;
      Text := string(Text).Replace(#13, '');
      if P > 0 then
        SelStart := P;
    end;
end;


end.
