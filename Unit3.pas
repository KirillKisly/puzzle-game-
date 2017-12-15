unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, XPMan;

type
  TForm3 = class(TForm)
    XPManifest1: TXPManifest;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1, Unit2, Unit4;

{$R *.dfm}


procedure TForm3.Button1Click(Sender: TObject);
begin
  Form1.Show;
  Rasstanovka;
  NotWin:=0;
  Form1.Label2.Caption:='Кол-во совершенных ходов: ' +IntToStr(NotWin);
  Form1.Label3.Caption:='Ходят: Желтые';
  Player1:=True;
  Player2:=False;
  Form1.DrawGrid1.Visible:=True;
  Form1.DrawGrid1.Invalidate;

end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Form1.Close;
  Form2.Close;
  Form3.Close;
  Form4.Close;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  Form4.Show;
end;

end.
