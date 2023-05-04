unit MiniPlay;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Cod.SysUtils, Vcl.TitleBarCtrls, Cod.Visual.Image, Vcl.StdCtrls,
  Cod.Visual.Button, Vcl.ExtCtrls, Cod.Math, Math, Cod.Visual.Slider;

type
  TMiniPlayer = class(TForm)
    MainContain: TPanel;
    TitleBarPanel: TTitleBarPanel;
    Mini_Song: TLabel;
    Mini_Cover: CImage;
    Mini_Artist: TLabel;
    Mini_Close: CButton;
    Button_Prev: CButton;
    MiniButton_Play: CButton;
    Button_Next: CButton;
    Mini_Expand: CButton;
    AnimTo: TTimer;
    AdditionalOptions: TPanel;
    Label3: TLabel;
    Mini_Seek: CSlider;
    Label4: TLabel;
    Mini_NextSong: TLabel;
    Mini_Shuffle: CButton;
    Mini_Repeat: CButton;
    Mini_Transparent: CButton;
    procedure FormCreate(Sender: TObject);
    procedure MoveMoveDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Mini_ExpandClick(Sender: TObject);
    procedure AnimToTimer(Sender: TObject);
    procedure Mini_TransparentClick(Sender: TObject);
    procedure Mini_RepeatClick(Sender: TObject);
    procedure Mini_ShuffleClick(Sender: TObject);
    procedure MiniButton_PlayClick(Sender: TObject);
    procedure Button_NextClick(Sender: TObject);
    procedure Button_PrevClick(Sender: TObject);
    procedure Mini_CloseClick(Sender: TObject);
    procedure Mini_SeekMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Mini_SeekMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Mini_SeekChange(Sender: CSlider; Position, Max, Min: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PreparePosition;

    procedure MiniSetSeek;
  end;

const
  TransparentOptions: TArray<integer> = [255, 230, 200, 150, 100, 75];

var
  MiniPlayer: TMiniPlayer;

  Destination: integer;

  HeightNormal,
  HeightExtended: integer;

  AddonDest: integer;
  AnDirection: integer;
  AnPosition: integer;

  TransparentIndex: integer;

  NoUpdateSeek: boolean;

  // Experiment
  ExperimentalTop: boolean;

implementation

uses
  MainUI;

{$R *.dfm}

procedure TMiniPlayer.AnimToTimer(Sender: TObject);
begin
  // Pos
  Inc(AnPosition, 5);

  Height := AddonDest + AnDirection * trunc(Power(Destination, AnPosition / 100));

  // Disble
  if AnPosition >= 100 then
    begin
      Height := AddonDest + AnDirection * Destination;

      AnimTo.Enabled := false;
    end;
end;

procedure TMiniPlayer.Button_NextClick(Sender: TObject);
begin
  UIForm.Action_Next.Execute;
end;

procedure TMiniPlayer.MiniButton_PlayClick(Sender: TObject);
begin
  UIForm.Action_Play.Execute;
end;

procedure TMiniPlayer.MiniSetSeek;
begin
  if NoUpdateSeek then
    Exit;

  Mini_Seek.Position := UIForm.Player_Position.Position;
end;

procedure TMiniPlayer.Button_PrevClick(Sender: TObject);
begin
  UIForm.Action_Previous.Execute;
end;

procedure TMiniPlayer.Mini_CloseClick(Sender: TObject);
begin
  Self.Hide;

  if ExperimentalTop then
    begin
      Self.FormStyle := fsNormal;
      ChangeMainForm(UIForm);
    end;
  Application.MainForm.Show;
end;

procedure TMiniPlayer.Mini_ExpandClick(Sender: TObject);
begin
  if EqualApprox(Height, HeightExtended, 50) then
    begin
      Destination := HeightExtended - HeightNormal;
      AddonDest := HeightExtended;
      AnDirection := -1;
    end
  else
    begin
      Destination := HeightExtended - HeightNormal;
      AddonDest := HeightNormal;
      AnDirection := 1;
    end;

  AnPosition := 1;
  AnimTo.Enabled := true;
end;

procedure TMiniPlayer.Mini_SeekChange(Sender: CSlider; Position, Max,
  Min: Integer);
begin
  if NoUpdateSeek then
    begin
      UIForm.Player_Position.Position := Position;
      UIForm.Player_PositionChange(Sender, Position, Max, Min);
    end;
end;

procedure TMiniPlayer.Mini_SeekMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NoUpdateSeek := true;
end;

procedure TMiniPlayer.Mini_SeekMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if NoUpdateSeek then
    UIForm.Player_PositionMouseUp(Sender, Button, Shift, X, Y);

  NoUpdateSeek := false;
end;

procedure TMiniPlayer.Mini_ShuffleClick(Sender: TObject);
begin
  UIForm.ToggleShuffle( not Shuffled );
end;

procedure TMiniPlayer.Mini_RepeatClick(Sender: TObject);
begin
  UIForm.ToggleRepeat;
end;

procedure TMiniPlayer.Mini_TransparentClick(Sender: TObject);
begin
  Inc(TransparentIndex);

  if TransparentIndex > High(TransparentOptions) then
    TransparentIndex := 0;

  AlphaBlendValue := TransparentOptions[TransparentIndex];
end;

procedure TMiniPlayer.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TMiniPlayer.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Visible then
    begin
      CanClose := false;
      Mini_CloseClick(Mini_Close);
    end;
end;

procedure TMiniPlayer.FormCreate(Sender: TObject);
begin
  // UX
  Font.Color := clWhite;
  with CustomTitleBar do
    begin
      Enabled := true;

      CaptionAlignment := taCenter;
      ShowIcon := false;
      ShowCaption := false;

      SystemColors := false;
      SystemButtons := false;
      SystemHeight := false;

      Self.Height := Self.Height - Height;

      Height := 5;

      Control := TitleBarPanel;

      PrepareCustomTitleBar( TForm(Self), Color, clWhite);

      InactiveBackgroundColor := BackgroundColor;
      ButtonInactiveBackgroundColor := BackgroundColor;
    end;

  // UI
  MainContain.Top := CustomTitlebar.Height;
  AdditionalOptions.Top := MainContain.Top + MainContain.Height;

  HeightNormal := MainContain.Top + MainContain.Height;
  HeightExtended := AdditionalOptions.Top + AdditionalOptions.Height;

  ClientHeight := HeightNormal;

  // Apply Size
  Height := HeightNormal;
end;

procedure TMiniPlayer.FormShow(Sender: TObject);
begin
  // Fix Titlebar
  CustomTitleBar.Height := 1;
  CustomTitleBar.Height := 0;
end;

procedure TMiniPlayer.MoveMoveDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Self.Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TMiniPlayer.PreparePosition;
begin
  Top := 20 + Screen.DesktopTop;
  Left := 20 + Screen.DesktopLeft;

  AlphaBlendValue := TransparentOptions[TransparentIndex];

  Show;
end;

end.
