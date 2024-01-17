unit Performance;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Cod.Types, Vcl.TitleBarCtrls, Vcl.ExtCtrls, Cod.SysUtils, Bass,
  Cod.Math, Cod.StringUtils;

type
  TPerfForm = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    PaintBox1: TPaintBox;
    AddNew: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure AddNewTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddValue;

    function Peak: single;
  end;

var
  PerfForm: TPerfForm;

  MaxValues: integer = 40;

  ValuesList: TArray<single>;

implementation

{$R *.dfm}

procedure TPerfForm.AddNewTimer(Sender: TObject);
begin
  AddValue;

  if Self.Visible then
    PaintBox1.Repaint;
end;

procedure TPerfForm.AddValue;
var
  Index: integer;
  I: Integer;
begin
  Index := Length(ValuesList);
  SetLength(ValuesList, Index + 1);

  ValuesList[Index] := BASS_GetCPU;

  if Length(ValuesList) > 30 then
    begin
      for I := 0 to High(ValuesList) -1 do
        ValuesList[i] := ValuesList[i + 1];

      SetLength(ValuesList, 30 );
    end;
end;

procedure TPerfForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(PerfForm);
end;

procedure TPerfForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  AddNew.Enabled := false;
  SetLength(ValuesList, 0);
end;

procedure TPerfForm.FormCreate(Sender: TObject);
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

procedure TPerfForm.PaintBox1Paint(Sender: TObject);
var
  Max, Amplify: single;
  I, X, Y, TextH, UsgSize: integer;
  DrawRect: TRect;
  S: string;
begin
  with PaintBox1.Canvas do
    begin
      // High
      if High(ValuesList) <= 0 then
        Exit;

      // Style
      Font.Assign(Self.Font);
      Brush.Style := bsClear;
      Font.Size := 12;

      // Data
      Max := Peak;

      TextH := TextHeight('12345');
      DrawRect := Rect(0, TextH * 2, PaintBox1.Width, PaintBox1.Height - TextH * 2);

      if Max <> 0 then
        Amplify := DrawRect.Height / Max
      else
        Amplify := 1;

      // Info
      S := Format('Peak: %G%%', [trunc(Max * 100) / 100]);
      TextOut( TextH, 0, S );

      S := Format('Current: %G%%', [trunc(ValuesList[High(ValuesList)] * 100) / 100]);
      TextOut( PaintBox1.Width - TextWidth(S) - TextH, 0, S );

      // Lines Separate
      Pen.Color := clWhite;
      Pen.Width := 1;

      MoveTo(0, trunc(TextH * 1.5));
      LineTo(PaintBox1.Width, trunc(TextH * 1.5));

      // Line Style
      Pen.Color := clRed;
      Pen.Width := 2;

      // Draw
      UsgSize := round(ValuesList[0] * Amplify);
      MoveTo(0, TextH + DrawRect.Height + DrawRect.Top - UsgSize);
      for I := 1 to High(ValuesList) do
        begin
          UsgSize := round(ValuesList[I] * Amplify);

          X := round(I / High(ValuesList) * PaintBox1.Width);
          Y := TextH + DrawRect.Height + DrawRect.Top - UsgSize;

          LineTo( X, Y );

          Font.Size := 8;
          S := (trunc(ValuesList[I] * 1000)/1000).ToString;

          if I mod 2 = 1 then
            TextOut( X - TextWidth(S) div 2, DrawRect.Bottom + TextH, S)
          else
            TextOut( X - TextWidth(S) div 2, Y - TextHeight(S), S);

          MoveTo( X, Y );
        end;
    end;
end;

function TPerfForm.Peak: single;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(ValuesList) do
    if ValuesList[I] > Result then
      Result := ValuesList[I];
end;

end.
