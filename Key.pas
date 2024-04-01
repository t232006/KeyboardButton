unit Key;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls, windows,
  Graphics, messages, stdctrls;

type
  TKeyType = (ktFunc, ktScroll, ktNum, ktLetters, ktSticked, ktOthers);

  TMyLabel = record
    Caption: string;
    Font: TFont;
    PosX: Integer;
  end;

  TKey = class(TImage)
  private
    FRound: byte;
    FPicChangedCount: byte;
    //FPicture: TPicture;
    FUpLabel: TMyLabel;
    FDownLabel: TMyLabel;
    FMidLabel: TMyLabel;
    FPressColor: Tcolor;
    FSaveUpCol: Tcolor;
    FSaveDoCol: Tcolor;
    FSaveMiCol: Tcolor;
    FKeyType: TKeyType;
    FHeight: Integer;
    FWidth: Integer;

    hover: boolean;
    procedure Paint(AColor: TColor);
    procedure CopyKey;
    //procedure UpFontChange(Sender: TObject);
    //procedure DownFontChange(Sender: TObject);
    procedure MidFontChange(Sender: TObject);
    procedure PictureChanged(Sender: TObject);
    //procedure PaintLabel(const Index:Integer); overload;
    //procedure PaintLabel(const Index: Integer; AColor: Tcolor);
    procedure MakeBlack;
    //procedure SetPicture(Value: TPicture);
    //procedure SaveColors;
    procedure ReturnColors;
    //procedure SetUpLabel(AValue: TLabel);
    function GetText(const Index: Integer): string;
    procedure SetText(const Index: Integer; const Value: string);
    function GetFont(const Index: Integer): TFont;
    procedure SetFont(const Index: Integer; const Value: TFont);
    function GetPosX(const Index: Integer): Integer;
    procedure SetPosX(const Index: Integer; const Value: Integer);
    //procedure MouseDown; override;
  protected
    procedure SetWidth(AValue: Integer);
    procedure SetHeight(AValue: Integer);

    procedure MouseEnter(var Msg: TMessage); message CM_MOUSEENTER ;
    procedure MouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure MouseDown(var Msg: TMessage); message WM_LBUTTONDOWN;
    procedure MouseUp(var Msg: TMessage); message WM_LBUTTONUP;
  public
    FPicLoaded: array of TBitmap;//!!!!!!!!!!!!!!!!!!!!!
    constructor Create(AOwner: TComponent);  override;
    destructor Destroy; override;
    property OnClick;
    property OnMouseEnter;
    property OnMouseLeave;

  published
    //property Font;
    property Color;
    //property Picture: TPicture read FPicture write SetPicture;
    property Height read FHeight write Setheight default 42;
    property Width read FWidth write SetWidth default 42;
    property Round: byte read FRound write FRound default 4;
    property UpText: string index 0 read GetText write SetText;
    property DownText: string index 1 read GetText  write SetText;
    property MiddleText: string index 2 read GetText write SetText;
    property UpFont: TFont index 0 read GetFont write SetFont;
    property DownFont: TFont index 1 read GetFont write SetFont;
    property MiddleFont: TFont index 2 read GetFont write SetFont;
    property UpPosX: Integer index 0 read GetPosX write SetPosX default 5;
    property DownPosX: Integer index 1 read GetPosX write SetPosX;
    //property MiddlePosX: Integer index 2 read GetPosX write SetPosX;
    property PressColor: TColor read FPressColor write FPressColor;
    property KeyType: TKeyType read FKeyType write FKeyType default ktOthers;


  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TKey]);
end;

{ TKey }

procedure TKey.CopyKey;
begin
   setlength(FPicLoaded, length(FPicLoaded)+1);
   FPicLoaded[FPicChangedcount]:=TBitmap.Create;
   with FPicLoaded[FPicChangedcount].Canvas do
   begin
    Width:=Self.Width; height:=self.Height;
    CopyRect(Rect(0,0,width, height),
            self.Canvas,
            Rect(0,0,self.Width,self.Height))
   end;
   inc(FPicChangedcount);
end;

constructor TKey.Create(AOwner: TComponent);
begin
  //FPicLoaded:=TBitmap.Create;
  inherited;
  hover:=false;
  FPicChangedCount:=0;
  Fheight:=42; Fwidth:=42;
  SetBounds(0,0,Fwidth,fheight);
  round:=4;
  Color:= RGB(49,48,49);
  FUpLabel.Font:=TFont.Create;
  FDownLabel.Font:=TFont.Create;
  FMidLabel.Font:=TFont.Create;

  //FUpLabel.Font.OnChange := Self.UpFontChange;
  FUpLabel.Font.OnChange := Self.MidFontChange;
  FMidLabel.Font.OnChange := Self.MidFontChange;
  FDownLabel.Font.OnChange := Self.MidFontChange;
  Picture.OnChange := self.PictureChanged;
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
  FPressColor:=RGB(214,186,140);
  FMidLabel.Caption:='Esc';
  AutoSize:=true;
  Stretch:=true;
  //FUpLabel.Caption:='Q';
  //FDownLabel.Caption:='�';
  Paint(Color);
  FKeyType:=ktLetters;
  FSaveDoCol:=FDownLabel.Font.Color;
  FSaveMiCol:=FMidLabel.Font.Color;
  FSaveUpCol:=FUpLabel.Font.Color;
end;

destructor TKey.Destroy;
begin
  {FUpLabel.Font.Free;
  FDownLabel.Font.Free;
  FMidLabel.Font.Free;}
  //FPicLoaded.Free;
  inherited;
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

procedure TKey.MouseDown;
begin
  inherited;
  Paint(FPressColor);
end;

procedure TKey.MouseUp(var Msg: TMessage);
begin
   inherited;
   if hover then MakeBlack else
   Paint(Color);
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
   Paint(Color);
end;

procedure TKey.Paint(AColor: TColor);
var midpos:ShortInt; TextSize: TSize;
    s, s1: string; p:integer;
begin
with Canvas do
begin
  Brush.Color:=AColor;
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

procedure TKey.PictureChanged(Sender: TObject);
begin
  //if FPicChangedCount<3 then inc(FPicChangedCount);
  //if FPicChangedCount=3 then
  begin
    CopyKey;
    inc(FPicChangedCount);
  end;
end;

procedure TKey.ReturnColors;
begin
   FUpLabel.Font.Color := FSaveUpCol;
   FDownLabel.Font.Color := FSaveDoCol;
   FMidLabel.Font.Color := FSaveMiCol;
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
   Paint(Color);
end;

procedure TKey.SetHeight(AValue: Integer);
begin
    SetBounds(Left, Top, FWidth, AValue);
    FHeight:=Avalue;
    Paint(Color);
end;

procedure TKey.SetPosX(const Index, Value: Integer);
begin
    case Index of
      0: FUpLabel.PosX:=Value;
      1: FDownLabel.PosX:=Value;
    end;
    Paint(Color);
end;

procedure TKey.SetWidth(AValue: Integer);
begin
    SetBounds(Left, Top, AValue, FHeight);
    FWidth:=AValue;
    Paint(Color);
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
    Paint(Color);
end;

procedure TKey.MakeBlack;
begin
   FUpLabel.Font.Color:=clBlack;
   FDownLabel.Font.Color:=clBlack;
   FMidLabel.Font.Color:=clBlack;
   Paint(ClWhite);
end;

procedure TKey.MidFontChange(Sender: TObject);
begin
  SetFont(2, FMidLabel.Font);
end;

end.
