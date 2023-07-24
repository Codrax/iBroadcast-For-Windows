unit CreatePlaylistForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.TitleBarCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Cod.Visual.Button, Cod.SysUtils, Cod.Visual.CheckBox,
  BroadcastAPI, Offline, Vcl.Imaging.pngimage, Cod.Visual.Image,
  iBroadcastUtils;

type
  TCreatePlaylist = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label8: TLabel;
    Label16: TLabel;
    Download_Item: CButton;
    CButton1: CButton;
    Panel3: TPanel;
    Label1: TLabel;
    Type_List: CButton;
    Type_Mood: CButton;
    Panel5: TPanel;
    Panel7: TPanel;
    List_Name: TEdit;
    Panel6: TPanel;
    Label2: TLabel;
    List_Description: TMemo;
    Label3: TLabel;
    Make_Public: CCheckBox;
    Select_Mood: TPanel;
    Label4: TLabel;
    CButton3: CButton;
    CButton4: CButton;
    CButton5: CButton;
    CButton6: CButton;
    CButton7: CButton;
    CButton8: CButton;
    CImage1: CImage;
    procedure FormCreate(Sender: TObject);
    procedure List_DescriptionChange(Sender: TObject);
    procedure Download_ItemClick(Sender: TObject);
    procedure CButton3Click(Sender: TObject);
    procedure SelectType(Sender: TObject);
  private
    { Private declarations }
    FMoodBased: boolean;
    FMood: integer;
    procedure SetMoodBased(const Value: boolean);
    procedure SetMood(const Value: integer);
  public
    { Public declarations }
    Tracks: TArray<integer>;

    property Mood: integer read FMood write SetMood;
    property MoodBased: boolean read FMoodBased write SetMoodBased;
  end;

const
  MoodTypes: TArray<string> = ['happy', 'party', 'dance', 'relaxed', 'workout', 'chill'];

var
  CreatePlaylist: TCreatePlaylist;

implementation

{$R *.dfm}

procedure TCreatePlaylist.SelectType(Sender: TObject);
begin
  MoodBased := CButton(Sender).Tag = 1;

  Type_List.GradientOptions.Enabled := not MoodBased;
  Type_Mood.GradientOptions.Enabled := MoodBased;

  Type_List.Invalidate;
  Type_Mood.Invalidate;
end;

procedure TCreatePlaylist.CButton3Click(Sender: TObject);
begin
  Mood := CButton(Sender).Tag;
end;

procedure TCreatePlaylist.Download_ItemClick(Sender: TObject);
begin
  if List_Name.Text = '' then
    OpenDialog('Playlist need a name', 'The playlist requires a name')
  else
    try
      // Create Playlist
      if MoodBased then
        CreateNewPlayList(List_Name.Text, List_Description.Text, Make_Public.Checked, MoodTypes[Mood])
      else
        CreateNewPlayList(List_Name.Text, List_Description.Text, Make_Public.Checked, Tracks);
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
  Moodbased := false;
  Tracks := [];
  Mood := 0;
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

procedure TCreatePlaylist.SetMood(const Value: integer);
var
  I: integer;
begin
  FMood := Value;

  for I := 0 to Select_Mood.ControlCount-1 do
    if Select_Mood.Controls[I] is CButton then
      with CButton(Select_Mood.Controls[I]) do
        begin
          GradientOptions.Enabled := Tag = Value;

          Invalidate;
        end;
end;

procedure TCreatePlaylist.SetMoodBased(const Value: boolean);
begin
  FMoodBased := Value;

  Select_Mood.Visible := Value;
end;

end.
