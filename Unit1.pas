{Кислый Кирилл 42412
Реализация игры уголки}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Menus, ExtCtrls, jpeg;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    DrawGrid1: TDrawGrid;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Map: array [0..7, 0..7] of Boolean;
  Shashki: array [0..7, 0..7] of Integer;
  Flag, Player1, Player2: Boolean;
  iShas, jShas, TipShas, NotWin: Integer;

  procedure Rasstanovka;
  procedure DrawShashki;
  procedure CheckAsk(x,y: integer);
  procedure Jump(x, y: integer;var Top, Bot, Right, Left: Boolean);
  procedure DrawHod;
  procedure FreePole;
  function Proverka(ACol, ARow: integer):integer;
  function CheckAsk2(x,y: integer): Boolean;
  function CheckStep(PMap: Boolean):Boolean;
  function ProvWin1: Boolean;
  function ProvWin2: Boolean;

implementation

uses Unit2, Unit3, Unit4;

{$R *.dfm}

//1.Расстановка шашек
procedure Rasstanovka;
var i, j: Integer;
begin
  for i:=0 to 7 do                //сразу обнуление всех массивов
    begin
      for j:=0 to 7 do
        begin
          Map[i,j]:=false;
          Shashki[i,j]:=0;
        end;
    end;
  for i:=0 to 2 do                //верхние шашки
    begin
      for j:=0 to 2 do
        begin
          Shashki[i,j]:=1;
        end;
    end;
  for i:=5 to 7 do                //нижние шашки
    begin
      for j:=5 to 7 do
        begin
          Shashki[i,j]:=2;
        end;
    end;
end;

//2.Рисование шашек
procedure DrawShashki;
var i, j: Integer;
begin
  With Form1.DrawGrid1.canvas do
    begin
      Pen.Width:=2;
      Pen.Color:=clBlack;
      for i:=0 to 7 do
        begin
          for j:=0 to 7 do
            begin
              if Shashki[i,j]=1 then
                begin
                  Brush.Color:=clYellow;
                  Ellipse(Form1.DrawGrid1.CellRect(j,i));
                end;
              if Shashki[i,j]=2 then
                begin
                  Brush.Color:=clTeal;
                  Ellipse(Form1.DrawGrid1.CellRect(j,i));
                end;
            end;
        end;
    end;
end;

//3.Проверка куда можно ходить
procedure CheckAsk(x,y: integer);
var i, j: Integer;
begin
  for i:=0 to 7 do
    begin
      for j:=0 to 7 do
        begin
          if ((x-1=i) and (y=j)) then          //верх
            if(shashki[i,j]=0)then
              map[i,j]:=true
            else
              if((i<>0)and(shashki[i-1,j]=0))then
                map[i-1,j]:=true;

          if ((x+1=i) and (y=j)) then          //низ
            if(shashki[i,j]=0)then
              map[i,j]:=true
            else
              if((i<>7)and(shashki[i+1,j]=0))then
                map[i+1,j]:=true;

          if ((x=i) and (y-1=j)) then          //лево
            if(shashki[i,j]=0)then
              map[i,j]:=true
            else
              if((j<>0)and(shashki[i,j-1]=0))then
                map[i,j-1]:=true;

          if ((x=i) and (y+1=j)) then          //право
            if(shashki[i,j]=0)then
              map[i,j]:=true
            else
              if((j<>7)and(shashki[i,j+1]=0))then
                map[i,j+1]:=true;
        end;
    end;
end;

//4.Смотрим можем ли мы совершить прыжок через шашку
function CheckAsk2(x,y: integer): Boolean;
var i, j: Integer;
Top, Bot, Right, Left: Boolean;
begin
  CheckAsk2:=False;
  Jump(x,y,Top,Bot,Right,Left);
  for i:=0 to 7 do
    begin
      for j:=0 to 7 do
        begin
          if ((Top = False) and (Bot = False) and (Right = False) and (Left = False)) then
            CheckAsk2:=false;

          if ((x-1=i) and (y=j)) then          //верх
            if (Bot = False) then
              if ((Shashki[i,j]=1) or (Shashki[i,j]=2)) then
                if (i<>0) and (Shashki[i-1,j]=0) then
                  CheckAsk2:=True;

          if ((x+1=i) and (y=j)) then          //низ
            if (Top = False) then
              if ((Shashki[i,j]=1) or (Shashki[i,j]=2)) then
                if ((i<>7) and (Shashki[i+1,j]=0)) then
                  CheckAsk2:=True;

          if ((x=i) and (y-1=j)) then          //лево
            if (Right = False) then
              if ((Shashki[i,j]=1) or (Shashki[i,j]=2)) then
                if ((j<>0) and (Shashki[i,j-1]=0)) then
                  CheckAsk2:=True;

          if ((x=i) and (y+1=j)) then          //право
            if (Left = False) then
              if ((Shashki[i,j]=1) or (Shashki[i,j]=2)) then
                if ((j<>7) and (Shashki[i,j+1]=0))  then
                  CheckAsk2:=True;
        end;
    end;
end;

//5.Был ли прыжок через шашку
procedure Jump(x, y: integer;var Top, Bot, Right, Left: Boolean);
var i,j: integer;
begin
  Top:=false;
  Bot:=false;
  Right:=false;
  Left:=false;
  for i:=0 to 7 do
    begin
      for j:=7 to 7 do
        begin
          if ((iShas-2=x) and (jShas=y)) then  //верх
            Top:=true;
          if ((iShas+2=x) and (jShas=y)) then  //низ
            Bot:=true;
          if ((iShas=x) and (jShas+2=y)) then  //право
            Right:=true;
          if ((iShas=x) and (jShas-2=y)) then  //лево
            Left:=true;
        end;
    end;
end;

//6.Проверка на шашку
function Proverka(ACol, ARow: integer):integer;
begin
  Proverka:=Shashki[ARow,ACol];
end;

//7.Рисование куда можно походить
procedure DrawHod;
var i,j: Byte;
R: TRect;
begin
  with Form1.DrawGrid1 do
    begin
      for i:=0 to 7 do
        for j:=0 to 7 do
          begin
            if (Map[i,j] = True) then
              begin
                R:=CellRect(j,i);
                with Canvas do
                  begin
                    Pen.Color :=clWhite;
                    Brush.Color:=clWhite;
                    with R do
                      Ellipse(Left+(Right-Left) div 2-5,Top+(Bottom-Top) div 2-5,
                      Left+(Right-Left) div 2+5,Top+(Bottom-Top) div 2+5);
                  end;
              end;
          end;
    end;
end;

//8.Очистка поля, пока не выбрана шашка ходить нельзя
procedure FreePole;
var i, j: Integer;
begin
  for i:=0 to 7 do
    for j:=0 to 7 do
      Map[i,j]:=False;
end;

//9.Проверка можно ли туда походить
function CheckStep(PMap: Boolean):Boolean;
begin
  CheckStep:=PMap;
end;

//10.Проверка на победу(серые шашки win)
function ProvWin1: Boolean;
var i, j, k: Integer;
begin
  ProvWin1:=False;
  for i:=0 to 2 do
    begin
      for j:=0 to 2 do
        begin
          if (Shashki[i,j] = 2) then
            begin
              Inc(k);
              if (k = 9) then
                ProvWin1:=True;
            end
          else
            begin
              k:=0;
            end;
        end;
    end;
end;

//11.Проверка на победу(желтые шашки win)
function ProvWin2: Boolean;
var i, j, k: Integer;
begin
  ProvWin2:=false;
  for i:=5 to 7 do
    begin
      for j:=5 to 7 do
        begin
          if (Shashki[i,j] = 1) then
            begin
              Inc(k);
              if (k = 9) then
                ProvWin2:=True;
            end
          else
            begin
              k:=0;
            end;
        end;
    end;
end;

//По созданию формы
procedure TForm1.FormCreate(Sender: TObject);
var i: integer;
begin
  Rasstanovka;
  Flag:=False;
  player1:=True;
  player2:=False;
  Label2.Caption:='Кол-во совершенных ходов: ' +IntToStr(NotWin);
  Label3.Caption:='Ходят: Желтые';
end;

//Прорисовка поля и позиций шашек
procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  With  DrawGrid1.canvas do
    begin
      if odd(ARow*7+ACol) then   //рисование поля
        Brush.Color:=clBlack
      else
        Brush.Color:=clSilver;
      FillRect(Rect);
    end;
   DrawShashki;                  //прорисовка шашек
end;

//По нажатию на кнопку мыши
procedure TForm1.DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var  ACol, ARow, i, j: Integer;
Top, Bot, Right, Left: Boolean;
begin
  DrawGrid1.MouseToCell(X, Y, ACol, ARow);  //процедура считывания номера ячейки
  if (Proverka(ACol,ARow)=1) or (Proverka(ACol,ARow)=2) then  //проверяем нажали ли мы по шашке
    begin
      if ((Player1) and (Shashki[ARow,ACol]=1)) then  //если ход 1 игрока и выбрана его шашка
        begin
          iShas:=ARow;  //запись координат
          jShas:=ACol;
          TipShas:=Shashki[iShas,jShas];  //тип шашки 1 или 2 (желтые/серые)
        end
      else
        begin
          if ((Player2) and (Shashki[ARow,ACol]=2)) then  //если ход 2 игрока и выбрана его шашка
            begin
              iShas:=ARow;
              jShas:=ACol;
              TipShas:=Shashki[iShas,jShas];  //тип шашки 1 или 2 (красные/синие)
            end
          else
            begin
              iShas:=999;  //если не выбрана шашка
            end;
        end;

      if ((iShas=ARow) and (jShas=ACol)) then  //только выбраной шашке разрешаем ходить
        begin
          FreePole;
          if Flag = true then  //если можем ещё раз походить(перепрыгнуть шашку)
            CheckAsk(ARow,ACol)
          else
            CheckAsk(ARow,ACol);  //если нет просто смотрим куда можно походить
          DrawHod;  //показываем куда может походить шашка
        end;
    end
  else
    begin
      if CheckStep(Map[ARow,Acol]) then
        begin
          if ((Player2) and (iShas<>999)) then  //какой игрок ходит
            begin
              Shashki[ARow,ACol]:=TipShas;  //ход шашки
              Shashki[iShas,jShas]:=0;      //очищение шашки(шашка больше не стоит)
              if CheckAsk2(ARow,ACol) then  //проверяем можно ли перепрыгнуть через шашку
                Flag:=True
              else
                begin
                  Player2:=False;
                  Inc(NotWin);  //счётчик на ничью
                  Player1:=True;
                end;
              TipShas:=0;
            end
          else
            begin
              if ((Player1) and (iShas<>999))then
                begin
                  Shashki[ARow,ACol]:=TipShas;  //ход шашки
                  Shashki[iShas,jShas]:=0;      //очищение шашки(шашка больше не стоит)
                  if CheckAsk2(ARow,ACol) then  //проверяем можно ли перепрыгнуть через шашку
                    Flag:=True
                  else
                    begin
                      player2:=true;
                      player1:=false;
                    end;
                  TipShas:=0;
                end
              else
                begin
                  exit;
                end;
            end;
          FreePole;    //очищаем поле
        end
      else
        begin
          exit;
        end;
      Form1.DrawGrid1.Invalidate;  //перерисовывает DrawGrid
      if Player1 then
        Label3.Caption:='Ходят: Желтые'
      else
        Label3.Caption:='Ходят: Серые';

      //проверка на ничью
      if (NotWin = 81) then
        begin
          ShowMessage('                          НИЧЬЯ!!!' +#13 +'(Было произведено больше 80 ходов)');
          Form1.Close;
        end;

      //проверки кто выйграл
      if ProvWin1 then
        begin
          ShowMessage('Победили Серые шашки');
          Exit;
        end;
      if ProvWin2 then
        begin
          ShowMessage('Победили Желтые шашки');
          Exit;
        end;
      Label2.Caption:='Кол-во совершенных ходов: ' +IntToStr(NotWin);
    end;
end;

//если надо закончить ход
procedure TForm1.Button1Click(Sender: TObject);
begin
  if Player1 then
    begin
      Player2:=true;
      Player1:=false;
    end
  else
    begin
      Player2:=false;
      Inc(NotWin);  //счётчик на ничью
      Player1:=true;
    end;
  if Player1 then
    Label3.Caption:='Ходят: Желтые'
  else
    Label3.Caption:='Ходят: Серые';
  if (NotWin = 81) then                                  //проверка на ничью
    begin
      ShowMessage('                          НИЧЬЯ!!!' +#13 +'(Было произведено больше 80 ходов)');
      Form1.Close;
    end;
  Label2.Caption:='Кол-во совершенных ходов: ' +IntToStr(NotWin);
  Form1.DrawGrid1.Invalidate;  //перерисовывает DrawGrid
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  Form1.DrawGrid1.Visible:=True;
  Rasstanovka;
  NotWin:=0;
  Label2.Caption:='Кол-во совершенных ходов: ' +IntToStr(NotWin);
  Label3.Caption:='Ходят: Желтые';
  Player1:=True;
  Player2:=False;
  Form1.DrawGrid1.Invalidate;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  Form4.Show;
end;

end.
