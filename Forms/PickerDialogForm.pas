unit PickerDialogForm;

{$SCOPEDENUMS ON}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.Forms, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Dialogs, Vcl.TitleBarCtrls, Cod.SysUtils,
  Vcl.StdCtrls, Vcl.ExtCtrls, BroadcastAPI, Cod.Visual.Button, Cod.VarHelpers,
  Cod.Types, Cod.ColorUtils, Math, Imaging.jpeg, Vcl.WinXCtrls, Types,
  iBroadcastUtils, Cod.ArrayHelpers;

type
  TPickType = (Song, Album, Artist, Playlist);

  TDrawItem = record
    Index: integer;
    ID: string;

    Name: string;
    ImagePointer: TJpegImage; // pointer to image

    Checked: boolean;
    Hidden: boolean;

    ARect: TRect;

    function Image: TJpegImage;
  end;

  TPickerDialog = class(TForm)
    TitleBarPanel: TTitleBarPanel;
    Panel1: TPanel;
    TItle_Name: TLabel;
    Panel2: TPanel;
    CButton1: CButton;
    Download_Item: CButton;
    Panel3: TPanel;
    DrawBox: TPaintBox;
    ScrollBar1: TScrollBar;
    Panel4: TPanel;
    SearchBox1: TSearchBox;
    procedure FormCreate(Sender: TObject);
    procedure DrawBoxPaint(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DrawBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DrawBoxClick(Sender: TObject);
    procedure SearchBox1InvokeSearch(Sender: TObject);
  private
    const
      ITEM_HEIGHT = 50;
      ITEM_MARGIN = 3;
      ITEM_ROUND = 20;

    var
    { Private declarations }
    FKind: TPickType;
    FMultiSelect: boolean;
    FAlwaysHidden: TArray<string>;

    ScrollPosition: integer;
    PageFit: integer;

    Items: TArray<TDrawItem>;
    HoveredItem: integer;

    procedure UpdateRects;
    procedure UpdateScroll;
    procedure UpdateList;
    function GetTotalItems: integer;

    procedure ApplyFilter(Value: string);

    // Setters
    procedure SetKind(const Value: TPickType);
  public
    { Public declarations }
    // List
    procedure RedrawList;

    function Selected: TArray<string>;
    procedure SetSelected(IDs: TArray<string>);
    procedure SetHidden(IDs: TArray<string>);

    // Properties
    property Kind: TPickType read FKind write SetKind;
    property MultiSelect: boolean read FMultiSelect write FMultiSelect;
  end;

  function PickItems(var AItems: TArray<string>; ItemsKind: TPickType;
    AMultiSelect: boolean = true; AlreadySelected: TArray<string> = [];
    Hidden: TArray<string> = []): boolean;

var
  PickerDialog: TPickerDialog;

implementation

function PickItems(var AItems: TArray<string>; ItemsKind: TPickType;
  AMultiSelect: boolean; AlreadySelected, Hidden: TArray<string>): boolean;
begin
  // Create
  PickerDialog := TPickerDialog.Create(Application);
  with PickerDialog do
    try
      // Settings
      Kind := ItemsKind;
      MultiSelect := AMultiSelect;

      // Selection
      SetHidden(Hidden);
      SetSelected(AlreadySelected);

      // Result
      Result := ShowModal = mrOk;
      if Result then
        AItems := Selected;
    finally
      // Free
      Free;
    end;
end;

{$R *.dfm}

procedure TPickerDialog.ApplyFilter(Value: string);
var
  I: Integer;
begin
  Value := MashString(Value);

  // Filter
  if Value = '' then
    for I := 0 to High(Items) do
      Items[I].Hidden := FAlwaysHidden.Find(Items[I].ID) <> -1
    else
      for I := 0 to High(Items) do
        Items[I].Hidden := (Pos(Value, MashString(Items[I].Name)) = 0) or (FAlwaysHidden.Find(Items[I].ID) <> -1);

  // Rects
  UpdateRects;
  UpdateScroll;
end;

procedure TPickerDialog.DrawBoxClick(Sender: TObject);
begin
  // Select
  if HoveredItem <> -1 then
    Items[HoveredItem].Checked := not Items[HoveredItem].Checked;

  RedrawList;
end;

procedure TPickerDialog.DrawBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  I: Integer;
  PrevItem: integer;
  APoint: TPoint;
begin
  // Hover
  PrevItem := HoveredItem;
  HoveredItem := -1;
  APoint := Point(X, Y+ScrollPosition);
  for I := 0 to High(Items) do
    if not Items[I].Hidden then
      if Items[I].ARect.Contains(APoint) then
        begin
          HoveredItem := I;
          Break;
        end;

  // Changed
  if PrevItem <> HoveredItem then
    RedrawList;
end;

procedure TPickerDialog.DrawBoxPaint(Sender: TObject);
var
  I: integer;
  ARect, BRect: TRect;
  AColor: TColor;
  IsSelected: boolean;
  AText: string;
begin
  with DrawBox.Canvas do
    begin
      for I := 0 to High(Items) do
        begin
          ARect := Items[I].ARect;
          ARect.Offset(0, -ScrollPosition);

          if not Items[I].Hidden and ClipRect.IntersectsWith(ARect) then
            begin
              // Color
              if I = HoveredItem then
                AColor := ChangeColorSat(Color, 40)
              else
                AColor := ChangeColorSat(Color, 20);

              // Rect
              GDIRoundRect(MakeRoundRect(ARect, ITEM_ROUND),
                GetRGB(AColor).MakeGDIBrush, nil);

              // Selection
              IsSelected := Items[I].Checked;

              BRect := ARect;
              BRect.Width := ARect.Height;
              BRect.Inflate(-(ARect.Height div 4 + ITEM_MARGIN), -(ARect.Height div 4 + ITEM_MARGIN));

              if IsSelected then
                AColor := clHighlight
              else
                AColor := clGray;

              GDIRoundRect(MakeRoundRect(BRect, 5),
                GetRGB(AColor).MakeGDIBrush, nil);

              if IsSelected then
                begin
                  BRect.Inflate(-5, -5);

                  GDIRoundRect(MakeRoundRect(BRect, 2),
                    GetRGB(clWhite).MakeGDIBrush, nil);
                end;

              // Image
              BRect := ARect;
              BRect.Left := BRect.Left + ARect.Height;
              BRect.Width := ARect.Height;
              BRect.Inflate(-ITEM_MARGIN, -ITEM_MARGIN);
              GDIGraphicRound(Items[I].Image, BRect, ITEM_ROUND);

              // Text
              BRect := ARect;
              BRect.Left := BRect.Left + ARect.Height * 2;
              BRect.Left := BRect.Left + ITEM_MARGIN;

              Font.Assign(Self.Font);
              Font.Size := 14;
              Brush.Style := bsClear;
              AText := Items[I].Name;

              TextRect(BRect, AText, [tfSingleLine, tfVerticalCenter, tfEndEllipsis]);
            end;
        end;
    end;
end;

procedure TPickerDialog.FormCreate(Sender: TObject);
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

  CustomTitleBar.ShowCaption := false;

  // Values
  HoveredItem := -1;
end;

procedure TPickerDialog.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
const
  ScrollFactor = -6;
begin
  WheelDelta := WheelDelta div ScrollFactor;

  ScrollBar1.Position := ScrollBar1.Position + WheelDelta;
end;

procedure TPickerDialog.RedrawList;
begin
  // Repaint
  DrawBox.Repaint;
end;

procedure TPickerDialog.ScrollBar1Change(Sender: TObject);
begin
  ScrollPosition := ScrollBar1.Position;
  RedrawList;
end;

procedure TPickerDialog.SearchBox1InvokeSearch(Sender: TObject);
begin
  ApplyFilter(SearchBox1.Text);
  RedrawList;
end;

function TPickerDialog.Selected: TArray<string>;
var
  I: Integer;
begin
  Result := [];
  for I := 0 to High(Items) do
    if Items[I].Checked then
      Result.AddValue(Items[I].ID);
end;

procedure TPickerDialog.SetHidden(IDs: TArray<string>);
begin
  FAlwaysHidden := IDs;

  UpdateList;
end;

procedure TPickerDialog.SetKind(const Value: TPickType);
begin
  FKind := Value;

  UpdateList;
end;

procedure TPickerDialog.SetSelected(IDs: TArray<string>);
var
  I: Integer;
begin
  for I := 0 to High(Items) do
    Items[I].Checked := IDs.Find(Items[I].ID) <> -1;
end;

procedure TPickerDialog.UpdateList;
var
  TotalItems: integer;
  I: Integer;
begin
  // Items
  TotalItems := GetTotalItems;

  SetLength(Items, TotalItems);
  for I := 0 to High(Items) do
    with Items[I] do
      begin
        case Kind of
          TPickType.Song: begin
            ID := Tracks[I].ID;
            Name := Tracks[I].Title;
          end;

          TPickType.Album: begin
            ID := Albums[I].ID;
            Name := Albums[I].AlbumName;
          end;

          TPickType.Artist: begin
            ID := Artists[I].ID;
            Name := Artists[I].ArtistName;
          end;

          TPickType.Playlist: begin
            ID := Playlists[I].ID;
            Name := Playlists[I].Name;
          end;
        end;

        Index := I;
        Checked := false;
        Hidden := false;
      end;

  // Values
  PageFit := DrawBox.Height div (ITEM_HEIGHT + ITEM_MARGIN);

  // Update
  SearchBox1.Text := '';
  ApplyFilter('');
  UpdateScroll;
  RedrawList;
end;

procedure TPickerDialog.UpdateRects;
var
  I, Y: Integer;
begin
  Y := 0;
  for I := 0 to High(Items) do
    begin
      if not Items[I].Hidden then
        begin
          with Items[I].ARect do
            begin
              Top := Y;
              Height := ITEM_HEIGHT;

              Left := 0;
              Right := DrawBox.Width;
            end;

          Y := Y + ITEM_HEIGHT + ITEM_MARGIN;
        end
      else
        Items[I].ARect := TRect.Empty;
    end;
end;

procedure TPickerDialog.UpdateScroll;
var
  I: Integer;
  MaxScroll: integer;
begin
  MaxScroll := 0;
  for I := 0 to High(Items) do
    if not Items[I].Hidden then
      if Items[I].ARect.Bottom > MaxScroll then
        MaxScroll := Items[I].ARect.Bottom;


  MaxScroll := MaxScroll - (ITEM_HEIGHT+ITEM_MARGIN * PageFit);
  if MaxScroll < 0 then
    MaxScroll := 0;

  if ScrollPosition > MaxScroll then
    ScrollPosition := MaxScroll;

  ScrollBar1.Max := MaxScroll;
end;

function TPickerDialog.GetTotalItems: integer;
begin
  case Kind of
    TPickType.Song: Result := Length(Tracks);
    TPickType.Album: Result := Length(Albums);
    TPickType.Artist: Result := Length(Artists);
    TPickType.Playlist: Result := Length(Playlists);
    else Result := 0;
  end;
end;

{ TDrawItem }

function TDrawItem.Image: TJpegImage;
begin
  if ImagePointer = nil then
    case PickerDialog.Kind of
      TPickType.Song: ImagePointer := Tracks[Index].GetArtwork();
      TPickType.Album: ImagePointer := Albums[Index].GetArtwork;
      TPickType.Artist: ImagePointer := Artists[Index].GetArtwork;
      TPickType.Playlist: ImagePointer := Playlists[Index].GetArtwork;
      else
        ImagePointer := DefaultPicture;
    end;

  Result := ImagePointer;
end;

end.
