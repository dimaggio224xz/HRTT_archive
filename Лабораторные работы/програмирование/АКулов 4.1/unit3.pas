unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
    Form3: TForm3;

implementation
   uses
    unit1;
{$R *.lfm}

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.Button2Click(Sender: TObject);
Var

   a:array[1..5] of integer;
   summ:integer;
   sr:real;
   i:integer;
begin
    for i:=1 to 5 do
    if length(StringGrid1.cells[i-1,0]) <>0
    then a[i] := StrToInt(StringGrid1.Cells[i-1,0])
    else a[i] :=0;
    summ:=0;
    Begin
    for i:=1 to 5 do
    summ := summ + a[i];
    sr:= summ/5;
    Label1.caption:= 'Сумма елементов : ' + IntToStr(summ)
    +#13+ 'Среднее арифметическое :' + FloatToStr(sr);
    end;

end;

end.

