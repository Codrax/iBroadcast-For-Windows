unit InfoForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cod.SysUtils, Vcl.TitleBarCtrls,
  Cod.Visual.Image, Vcl.StdCtrls, Vcl.ExtCtrls, Cod.Visual.Button, Cod.Dialogs,
  BroadcastAPI, MainUI, Vcl.Menus, Vcl.ExtDlgs, iBroadcastUtils,
  Cod.Visual.StarRate, Math, Offline;

type
  TInfoBox = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Song_Cover: CImage;
    Download_Item: CButton;
    Popup_Right: TPopupMenu;
    Information1: TMenuItem;
    SavePicture: TSavePictureDialog;
    Panel3: TPanel;
    Song_Name: TEdit;
    Save_Button: CButton;
    Panel4: TPanel;
    Song_Info: TMemo;
    Editor_View: TPanel;
    Edit_Desc: TMemo;
    Save_Button2: CButton;
    Song_Rating: CStarRate;
    Save_Button_Star: CButton;
    SaveLargeCover1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Download_ItemEnter(Sender: TObject);
    procedure Download_ItemClick(Sender: TObject);
    procedure Information1Click(Sender: TObject);
    procedure Song_NameChange(Sender: TObject);
    procedure Save_ButtonClick(Sender: TObject);
    procedure Song_NameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Song_InfoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit_DescKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Save_Button2Click(Sender: TObject);
    procedure Save_Button_StarClick(Sender: TObject);
    procedure Song_RatingSelect(Sender: TObject);
  private
    { Private declarations }
    procedure EditError;
  public
    { Public declarations }
    procedure Prepare;
    procedure FixUI;
  end;

var
  InfoBox: TInfoBox;

  InfoBoxIndex: integer;
  InfoBoxPointer: ^TDrawableItem;

implementation


{$R *.dfm}

procedure TInfoBox.Save_Button_StarClick(Sender: TObject);
begin
  // Change Name
  try
    case InfoBoxPointer.Source of
      TDataSource.Tracks: with Tracks[InfoBoxPointer.Index] do
        if UpdateTrackRating(ID, Song_Rating.Rating, false) then
          // Update
          Rating := Song_Rating.Rating
        else
          Song_Rating.Rating := Rating;

      TDataSource.Albums: with Albums[InfoBoxPointer.Index] do
        if UpdateAlbumRating(ID, Song_Rating.Rating, false) then
          // Update
          Rating := Song_Rating.Rating
        else
          Song_Rating.Rating := Rating;

      TDataSource.Artists: with Artists[InfoBoxPointer.Index] do
        if UpdateArtistRating(ID, Song_Rating.Rating, false) then
          // Update
          Rating := Song_Rating.Rating
        else
          Song_Rating.Rating := Rating;
    end;

    InfoBoxPointer.Rating := Song_Rating.Rating;

    // UI
    Save_Button_Star.Hide;
  except
    EditError;
  end;
end;

procedure TInfoBox.Download_ItemClick(Sender: TObject);
var
  Output: boolean;
begin
  Output := InfoBoxPointer.ToggleDownloaded;

  // Button Update
  CButton(Sender).Tag := Output.ToInteger;
  CButton(Sender).OnEnter(Sender);
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

procedure TInfoBox.EditError;
begin
  OfflineDialog('We can'#39't edit this item. Are you connected to the internet?');
end;

procedure TInfoBox.Edit_DescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then
    Editor_View.Hide;
end;

procedure TInfoBox.FixUI;
var
  NewSize, Default, Val1, Val2: integer;
begin
  // Fix order
  Save_Button_Star.Top := Song_Rating.BoundsRect.Bottom + 1;

  // Min Size
  Default := Panel2.Top + Panel2.Margins.Bottom
    + (Height-ClientHeight) + TitleBarPanel.Height + Song_Cover.Top + Song_Cover.Height + Song_Cover.Margins.Bottom;
  Val1 := 0;
  Val2 := 0;

  if Song_Rating.Visible then
    Val1 := Save_Button_Star.BoundsRect.Bottom;

  if Download_Item.Visible then
    Val2 := Download_Item.BoundsRect.Bottom;

  NewSize := Max(Val1, Val2) + Panel2.Margins.Top + TitleBarPanel.Height + Panel2.Margins.Bottom + (Height-ClientHeight);
  NewSize := Max(Default, NewSize);

  // Set
  Height := NewSize;
end;

procedure TInfoBox.FormCreate(Sender: TObject);
var
  I, J: integer;
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

  // Popup Menus
  for I := 0 to ComponentCount-1 do
    if Components[I] is TPopupMenu then
      with TPopupMenu(Components[I]) do
        for J := 0 to Items.Count-1 do
          begin
            Items[J].OnDrawItem := UIForm.PopupDraw;
            Items[J].OnMeasureItem := UIForm.PopupMesure;
          end;
end;

procedure TInfoBox.Information1Click(Sender: TObject);
const
  EXT = '.jpeg';
begin
  // Save
  if not SavePicture.Execute then
    Exit;

  const LargeImage = TMenuItem(Sender).Tag = 1;

  try
    if (InfoBoxPointer.Source = TDataSource.Tracks) and LargeImage then
      Tracks[InfoBoxPointer.Index].GetArtwork(True).SaveToFile(SavePicture.FileName + EXT)
    else
      InfoBoxPointer.GetPicture.SaveToFile(SavePicture.FileName + EXT);
  except
    OfflineDialog('Unfortunately the download has failed. Are you connected to the internet?');
  end;
end;

procedure TInfoBox.Prepare;
begin
  // Starable
  Song_Rating.Visible := InfoBoxPointer.Source in [TDataSource.Tracks, TDataSource.Albums, TDataSource.Artists];

  // Editable
  Song_Name.ReadOnly := (InfoBoxPointer.Source <> TDataSource.Playlists) or IsOffline;
  Song_Rating.ViewOnly := IsOffline or not Song_Rating.Visible;

  // Exclusive
  SaveLargeCover1.Visible := InfoBoxPointer.Source = TDataSource.Tracks;

  // Edit UI
  Save_Button.Visible := false;
  Save_Button_Star.Visible := false;
  Editor_View.Hide;

  // UI
  FixUI;
end;

procedure TInfoBox.Save_Button2Click(Sender: TObject);
begin
  // Change Name
  try
    case InfoBoxPointer.Source of
      TDataSource.Playlists: with Playlists[InfoBoxPointer.Index] do
        if UpdatePlayList(InfoBoxPointer.ItemID, Name, Edit_Desc.Lines.Text, false) then
          // Update playlist
          Description := Edit_Desc.Lines.Text;
    end;

    // UI
    Editor_View.Hide;

    // New text
    InfoBoxPointer.ReloadSource;
    Song_Info.Lines.Text := InfoBoxPointer.GetPremadeInfoList;
  except
    EditError;
  end;
end;

procedure TInfoBox.Save_ButtonClick(Sender: TObject);
begin
  // Change Name
  try
    case InfoBoxPointer.Source of
      TDataSource.Playlists: with Playlists[InfoBoxPointer.Index] do

        if UpdatePlayList(InfoBoxPointer.ItemID, Song_Name.Text, Description, false) then
          begin
            // Update Playlist
            Name := Song_Name.Text;

            // Draw
            InfoBoxPointer.Title := Name;
          end
        else
          Song_Name.Text := Name;
    end;

    // UI
    Save_Button.Hide;
  except
    EditError;
  end;
end;

procedure TInfoBox.Song_InfoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (InfoBoxPointer.Source = TDataSource.Playlists) and not IsOffline then
    begin
      Editor_View.Show;
      Edit_Desc.Lines.Text := Playlists[InfoBoxPointer.Index].Description;

      Edit_Desc.SetFocus;
    end;
end;

procedure TInfoBox.Song_NameChange(Sender: TObject);
begin
  Save_Button.Show;
end;

procedure TInfoBox.Song_NameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    27: if not Song_Name.ReadOnly then
      begin
        Song_Name.Text := InfoBoxPointer.Title;
        Save_Button.Hide;
      end;
  end;
end;

procedure TInfoBox.Song_RatingSelect(Sender: TObject);
begin
  Save_Button_Star.Show;
end;

end.
