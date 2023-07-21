unit InfoForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cod.SysUtils, Vcl.TitleBarCtrls,
  Cod.Visual.Image, Vcl.StdCtrls, Vcl.ExtCtrls, Cod.Visual.Button, Cod.Dialogs,
  BroadcastAPI, MainUI, Vcl.Menus, Vcl.ExtDlgs, iBroadcastUtils;

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
  private
    { Private declarations }
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

procedure TInfoBox.Edit_DescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then
    Editor_View.Hide;
end;

procedure TInfoBox.FixUI;
begin
  // Fix Sizing
  Self.ClientHeight := Panel1.Top + Song_Name.Top + Song_Name.Height
    + Song_Info.Top + Song_Info.Height + Panel1.Margins.Bottom;
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

  if InfoBoxPointer.Source = TDataSource.Tracks then
    Tracks[InfoBoxPointer.Index].GetArtwork(True).SaveToFile(SavePicture.FileName + EXT)
  else
    InfoBoxPointer.GetPicture.SaveToFile(SavePicture.FileName + EXT);
end;

procedure TInfoBox.Prepare;
begin
  // Editable
  Song_Name.ReadOnly := (InfoBoxPointer.Source <> TDataSource.Playlists) or IsOffline;
  Save_Button.Visible := false;
  Editor_View.Hide;

  // UI
  FixUI;
end;

procedure TInfoBox.Save_Button2Click(Sender: TObject);
begin
  // Change Name
  case InfoBoxPointer.Source of
    TDataSource.Playlists: with Playlists[InfoBoxPointer.Index] do
      UpdatePlayList(InfoBoxPointer.ItemID, Name, Edit_Desc.Lines.Text);
  end;

  // UI
  Editor_View.Hide;

  // New text
  InfoBoxPointer.ReloadSource;
  Song_Info.Lines.Text := InfoBoxPointer.GetPremadeInfoList;
end;

procedure TInfoBox.Save_ButtonClick(Sender: TObject);
begin
  // Change Name
  case InfoBoxPointer.Source of
    TDataSource.Playlists: with Playlists[InfoBoxPointer.Index] do
      UpdatePlayList(InfoBoxPointer.ItemID, Song_Name.Text, Description);
  end;

  // UI
  Save_Button.Hide;
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

end.
