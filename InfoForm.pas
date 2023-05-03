unit InfoForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cod.SysUtils, Vcl.TitleBarCtrls,
  Cod.Visual.Image, Vcl.StdCtrls, Vcl.ExtCtrls, Cod.Visual.Button, Cod.Dialogs,
  BroadcastAPI, MainUI, Vcl.Menus, Vcl.ExtDlgs;

type
  TInfoBox = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    Panel1: TPanel;
    Song_Name: TLabel;
    Song_Info: TLabel;
    Panel2: TPanel;
    Song_Cover: CImage;
    Download_Item: CButton;
    Popup_Right: TPopupMenu;
    Information1: TMenuItem;
    SavePicture: TSavePictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure Download_ItemEnter(Sender: TObject);
    procedure Download_ItemClick(Sender: TObject);
    procedure Information1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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

end.
