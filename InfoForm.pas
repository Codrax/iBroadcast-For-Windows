unit InfoForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cod.SysUtils, Vcl.TitleBarCtrls,
  Cod.Visual.Image, Vcl.StdCtrls, Vcl.ExtCtrls, Cod.Visual.Button, Cod.Dialogs,
  BroadcastAPI;

type
  TInfoBox = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    Panel1: TPanel;
    Song_Name: TLabel;
    Song_Info: TLabel;
    Panel2: TPanel;
    Song_Cover: CImage;
    Download_Item: CButton;
    procedure FormCreate(Sender: TObject);
    procedure Download_ItemEnter(Sender: TObject);
    procedure Download_ItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FixUI;
  end;

var
  InfoBox: TInfoBox;

  InfoBoxIndex: integer;
  InfoBoxID: integer;
  InfoBoxType: TDataSource;

implementation

uses
  MainUI;

{$R *.dfm}

procedure TInfoBox.Download_ItemClick(Sender: TObject);
var
  ListIndex: integer;
  LastValue: string;

  List: ^TStringList;
  PageSource: TDataSource;
begin
  LastValue := InfoBoxID.ToString;

  // Source
  PageSource := InfoBoxType;

  // Index
  case PageSource of
    TDataSource.Tracks: List := @DownloadedTracks;
    TDataSource.Albums: List := @DownloadedAlbums;
    TDataSource.Artists: List := @DownloadedArtists;
    TDataSource.Playlists: List := @DownloadedPlaylists;
    else Exit;
  end;

  ListIndex := List.IndexOf(LastValue);

  // Download / Delete
  if ListIndex = -1 then
    List.Add( LastValue )
      else
        if OpenDialog('Are you sure?', 'Are you sure you wish to delete this from your downloads?', ctQuestion, [mbNo, mbYes]) = mrYes then
          List.Delete( ListIndex )
            else
              Exit;

  // Button Update
  CButton(Sender).Tag := (ListIndex = -1).ToInteger;
  CButton(Sender).OnEnter(Sender);

  // Update
  UIForm.UpdateDownloads;
end;

procedure TInfoBox.Download_ItemEnter(Sender: TObject);
begin
  with CButton(Sender) do
    if Tag <> 0 then
      begin
        Text := CAPTION_DOWNLOADED;
        BSegoeIcon := ICON_DOWNLOADED;
      end
    else
      begin
        Text := CAPTION_DOWNLOAD;
        BSegoeIcon := ICON_DOWNLOAD;
      end;
end;

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
