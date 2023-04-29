unit VolumePopup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cod.Visual.Slider, Vcl.StdCtrls, BASS;

type
  TVolumePop = class(TForm)
    CSlider1: CSlider;
    Label1: TLabel;
    procedure CSlider1Change(Sender: CSlider; Position, Max, Min: Integer);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VolumePop: TVolumePop;

implementation

uses
  MainUI;

{$R *.dfm}

procedure TVolumePop.CSlider1Change(Sender: CSlider; Position, Max, Min: Integer);
begin
  BASS_SetVolume( Position / 1000 );

  UIForm.StatusChanged;
end;

procedure TVolumePop.FormDeactivate(Sender: TObject);
begin
  Hide;
end;

end.
