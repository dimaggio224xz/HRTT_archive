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
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
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

{$R *.lfm}

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
var
  a:array[1..100,1..100] of integer;
  b:array[1..100,1..100] of integer;
  i,j,n,m,code:integer;
  s1,s,s2:string[30];
begin
 n:=stringgrid1.colcount;
 m:=stringgrid1.rowcount;

 for i:=1 to n do
  for j:=1 to m do

    a[i,j]:=strtoint(stringGrid1.cells[i-1,j-1])  ;

 b:=a;

 for i:=1 to n do
  begin

  for j:=1 to m do
      begin
      s:='';
         str(b[i,j],s1);
         s2:=s+s1;

      stringGrid2.cells[i-1,j-1]:=s2;
        end;
end;




end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  form3.Close;
end;

end.

