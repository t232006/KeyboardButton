unit Key2;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls, windows,
  Graphics, messages, stdctrls, consts;

type
  TKeyType = (ktFunc, ktScroll, ktNum, ktLetters, ktSticked, ktOthers);

  TMyLabel = record
    Caption: string;
    Font: TFont;
    PosX: Integer;
  end;

  TKey = class(TGraphicControl)
  private
    FKeyType: TKeyType;
    hover: boolean;
    FRound: byte;
    FPicture: TBitmap;
    FUpLabel: TMyLabel;
    FDownLabel: TMyLabel;
    FMidLabel: TMyLabel;
    FSaveUpCol: Tcolor;
    FSaveDoCol: Tcolor;
    FSaveMiCol: Tcolor;
    FPressColor: Tcolor;
    FColor: TColor;
    FCurrentColor: TColor;
    procedure MakeBlack;
    procedure ReturnColors;
    procedure DrawPicture;
    procedure SetPicture(Value: TBitmap);
    procedure Paint; override;
    function GetText(const Index: Integer): string;
    procedure SetText(const Index: Integer; const Value: string);
    function GetFont(const Index: Integer): TFont;
    procedure SetFont(const Index: Integer; const Value: TFont);
    function GetPosX(const Index: Integer): Integer;
    procedure SetPosX(const Index: Integer; const Value: Integer);
    procedure SetColor(const Value: TColor);
    procedure MidFontChange(Sender: TObject);
  protected
    procedure MouseEnter(var Msg: TMessage); message CM_MOUSEENTER ;
    procedure MouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure MouseDown(var Msg: TMessage); message WM_LBUTTONDOWN;
    procedure MouseUp(var Msg: TMessage); message WM_LBUTTONUP;
  public
    constructor Create(AOwner: TComponent);  override;
    destructor Destroy; override;
    property OnClick;
    property OnMouseEnter;
    property OnMouseLeave;

  published
    property Picture: TBitmap read FPicture write SetPicture;
    property UpText: string index 0 read GetText write SetText;
    property DownText: string index 1 read GetText  write SetText;
    property MiddleText: string index 2 read GetText write SetText;
    property UpFont: TFont index 0 read GetFont write SetFont;
    property DownFont: TFont index 1 read GetFont write SetFont;
    property MiddleFont: TFont index 2 read GetFont write SetFont;
    property Color: TColor read FColor write FColor;
    property PressColor: TColor read FPressColor write FPressColor;
    property CurrentColor: TColor write SetColor;
    property Round: byte read FRound write FRound default 4;
    property KeyType: TKeyType read FKeyType write FKeyType default ktOthers;
    property UpPosX: Integer index 0 read GetPosX write SetPosX default 5;
    property DownPosX: Integer index 1 read GetPosX write SetPosX;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TKey]);
end;

{ TKey }

constructor TKey.Create(AOwner: TComponent);
begin
  inherited;
  hover:=false;
  FPicture:=TBitmap.Create;
  FUpLabel.Font:=TFont.Create;
  FDownLabel.Font:=TFont.Create;
  FMidLabel.Font:=TFont.Create;
  height:=42; width:=42;
  Fround:=4;
  FColor:= RGB(49,48,49);
  FPressColor:=RGB(214,186,140);
  CurrentColor:=FColor;
  FMidLabel.Caption:='Esc';
  with FUpLabel do
  begin
    Font.Size:=14; Font.Color:=clWhite; Font.Style:=[fsItalic];
    PosX:=5;
  end;
  with FDownLabel do
  begin
    Font.Size:=12; Font.Color:=clRed; Font.Style:=[];
    PosX:= self.Width-font.Size-5;
  end;
  FMidLabel.Font:=FUpLabel.Font;
  FKeyType:=ktLetters;
  FSaveDoCol:=FDownLabel.Font.Color;
  FSaveMiCol:=FMidLabel.Font.Color;
  FSaveUpCol:=FUpLabel.Font.Color;
  FUpLabel.Font.OnChange := Self.MidFontChange;
  FMidLabel.Font.OnChange := Self.MidFontChange;
  FDownLabel.Font.OnChange := Self.MidFontChange;
end;

destructor TKey.Destroy;
begin
  FPicture.Destroy;
  inherited;
end;

procedure TKey.DrawPicture;
begin
if FPicture<>nil then
  canvas.copyrect(canvas.ClipRect, FPicture.Canvas, FPicture.Canvas.ClipRect);
end;

procedure TKey.SetText(const Index: Integer; const Value: string);
begin
   case index of
      0:   //up
      begin
        if Value<>'' then
        SetText(2, '');
        FUpLabel.Caption:=Value;
      end;
      1:    //down
      begin
         if Value<>'' then
        SetText(2, '');
         FDownLabel.Caption:=Value;
      end;
      2:
      begin
         FMidLabel.Caption:=Value;
          if Value<>'' then
            begin
              SetText(0, '');
              SetText(1, '');
            end;
      end;
    end;
    Paint;//(Color);
end;

function TKey.GetFont(const Index: Integer): TFont;
begin
   case Index of
  0: result:=FUpLabel.Font;
  1: result:= FDownLabel.Font;
  2: result:=FMidLabel.Font;
  end;
end;

function TKey.GetPosX(const Index: Integer): Integer;
begin
   case Index of
  0: result:=FupLabel.PosX;
  1: result:=FDownLabel.PosX;
  end;
end;

function TKey.GetText(const Index: Integer): string;
begin
   case index of
   0: result:=FUpLabel.Caption;
   1: result:= FDownLabel.Caption;
   2: result:=FMidLabel.Caption;
   end;
end;

procedure TKey.MouseDown(var Msg: TMessage);
begin
   inherited;
  CurrentColor:=FPressColor;
  Paint;
end;

procedure TKey.MouseEnter(var Msg: TMessage);
begin
   inherited;
   hover:=true;
   MakeBlack;
end;

procedure TKey.MouseLeave(var Msg: TMessage);
begin
  inherited;
   hover:=false;
   ReturnColors;
   CurrentColor:=FColor;
   Paint;
end;

procedure TKey.MouseUp(var Msg: TMessage);
begin
   inherited;
   if hover then MakeBlack else
   CurrentColor:=Color;
   Paint;
end;

procedure TKey.Paint;
var midpos:ShortInt; TextSize: TSize;
    s, s1: string; p:integer;
begin
    DrawPicture;
    with Canvas do
    begin
      RoundRect(0,0,width,height,FRound,FRound);
      font:=FupLabel.Font;
      TextOut(FUpLabel.PosX, 1, FUpLabel.Caption);

      font:=FDownLabel.Font;
      TextOut(FDownLabel.PosX, Height-font.Size-13, FDownLabel.Caption);

      font:=FMidLabel.Font;
      TextSize:=TextExtent(FMidLabel.Caption);
      if TextSize.cx<Width then
          begin
            midPos:=(height div 2) - (font.Size);
            TextOut(5, midPos, FMidLabel.Caption);
          end
      else
          begin
            midPos:=((height div 2) + (2 * font.Height));
            if midPos<0 then midPos:=0;

            s:=FMidLabel.Caption;
            p:= pos(' ',s);
            s1:=copy(s,1,p-1);
            delete(s,1,p);
            TextOut(5, midPos, s1);
            midPos:=(height div 2);
            TextOut(5, midPos, s);
          end;
    end;
end;

procedure TKey.ReturnColors;
begin
   FUpLabel.Font.Color := FSaveUpCol;
   FDownLabel.Font.Color := FSaveDoCol;
   FMidLabel.Font.Color := FSaveMiCol;
end;

procedure TKey.SetColor(const Value: TColor);
begin
   FCurrentColor := Value;
    canvas.Brush.Color:=value;
end;

procedure TKey.SetFont(const Index: Integer; const Value: TFont);
begin
  case Index of
     0:
     begin
        FUpLabel.Font:=Value;
        FSaveUpCol:=Value.Color;
     end;
     1:
     begin
        FDownLabel.Font:=Value;
        FSaveDoCol:=Value.Color;
     end;
     2:
     begin
       FMidLabel.Font:=Value;
       FSaveMiCol:=Value.Color;
     end;
   end;
   Paint;//(Color);
end;

procedure TKey.SetPicture(Value: TBitmap);
begin
   FPicture.Assign(Value);
   invalidate;
end;

procedure TKey.SetPosX(const Index, Value: Integer);
begin
    case Index of
      0: FUpLabel.PosX:=Value;
      1: FDownLabel.PosX:=Value;
    end;
    Paint;
end;

procedure TKey.MakeBlack;
begin
   FUpLabel.Font.Color:=clBlack;
   FDownLabel.Font.Color:=clBlack;
   FMidLabel.Font.Color:=clBlack;
   CurrentColor:=ClWhite;
   Paint;//(ClWhite);
end;


procedure TKey.MidFontChange(Sender: TObject);
begin
   SetFont(2, FMidLabel.Font);
end;

end.
