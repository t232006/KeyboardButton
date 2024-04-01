unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Key, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Key1: TKey;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var x, y: integer;
begin
  //key1.Width:=42; key1.Height:=42;
  {canvas.CopyRect(Rect(10,10,key1.FPicLoaded.Width+10,key1.FPicLoaded.Height+10),
                  key1.FPicLoaded.Canvas,
                  Rect(0,0,key1.FPicLoaded.Width, key1.FPicLoaded.Height));
  canvas.CopyRect(Rect(110,10,key1.Width+110, key1.Height+10),
                  key1.picture.Bitmap.Canvas,
                  Rect(0,0,key1.Width, key1.Height));   }
  x:=50; y:=10;
  for var i := Low(key1.fpicloaded) to High(key1.fpicloaded) do
   with key1.Fpicloaded[i] do
   begin
     if x>self.Width then
     begin
       x:=0; y:=y+50;
     end;
     form1.canvas.CopyRect(rect(x,y,Width+x,Height+y),
                    canvas,
                    rect(0,0,width,height));
     x:=x+50;
   end;

end;


procedure TForm1.Button2Click(Sender: TObject);
begin
    //button2.Caption:=inttostr(key1.Picture.Bitmap.Height)+'  '+inttostr(key1.Picture.Bitmap.Width);
end;

end.
