unit RatingPopup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Cod.Visual.Button;

type
  TRatingPopupForm = class(TForm)
    Rate_Like: CButton;
    Rate_Close: CButton;
    Rate_Dislike: CButton;
    Rate_1: CButton;
    Rate_2: CButton;
    Rate_3: CButton;
    Rate_4: CButton;
    Rate_5: CButton;
    Rate_6: CButton;
    Rate_7: CButton;
    Rate_8: CButton;
    Rate_9: CButton;
    Rate_10: CButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure Rate_CloseClick(Sender: TObject);
    procedure SetRate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PrepButtons(RatingMode: boolean);
  end;

var
  RatingPopupForm: TRatingPopupForm;

implementation

uses
  MainUI;

{$R *.dfm}

procedure TRatingPopupForm.Rate_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TRatingPopupForm.SetRate(Sender: TObject);
begin
  UIForm.SetCurrentSongRating( CButton(Sender).Tag );

  Close;
end;

procedure TRatingPopupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TRatingPopupForm.FormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TRatingPopupForm.FormPaint(Sender: TObject);
begin
  with Canvas do
    begin
      Pen.Style := psClear;
      Brush.Color := $004A1047;

      RoundRect(ClipRect, 20, 20);
    end;
end;

procedure TRatingPopupForm.PrepButtons(RatingMode: boolean);
var
  I: Integer;
begin
  Rate_Like.Visible := not RatingMode;
  Rate_Dislike.Visible := not RatingMode;

  Rate_10.Visible := RatingMode;
  Rate_9.Visible := RatingMode;
  Rate_8.Visible := RatingMode;
  Rate_7.Visible := RatingMode;
  Rate_6.Visible := RatingMode;
  Rate_5.Visible := RatingMode;
  Rate_4.Visible := RatingMode;
  Rate_3.Visible := RatingMode;
  Rate_2.Visible := RatingMode;
  Rate_1.Visible := RatingMode;

  // Order
  for I := 0 to ControlCount-1 do
    if Controls[I] is CButton then
      Controls[I].Left := 1+ Controls[I].Tag * (Width + Controls[I].Margins.Left + Controls[I].Margins.Right);

  // UI
  if RatingMode then
    Rate_Close.Left := 9999
  else
    Rate_Close.Left := Rate_Dislike.Left;
end;

end.
