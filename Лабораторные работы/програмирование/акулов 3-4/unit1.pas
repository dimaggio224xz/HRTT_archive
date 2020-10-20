unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;


implementation
uses unit2,unit3;

{$R *.lfm}

{ TForm1 }
{procedure vrychn(w: string);
 begin
  for i:= 1 to n do
               for j:= 1 to n do
               begin
               readln(a[i,j])
               end;
    for i:= 1 to n do
               for j:= 1 to n do
               begin
               Writeln(a[i,j],s1)
               end;
 end;
procedure avtom(ww:string);
begin
 randomize;
               for i:= 1 to n do
               for j:= 1 to n do
               begin
               a[i,j]:= random(99)-50;
               end;
                 for i:= 1 to n do
               for j:= 1 to n do
               begin
               Writeln(a[i,j],s1)
               end;
end;      }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
 Form2.ShowModal;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
a:array[1..25,1..25] of integer ;
b:array[1..25,1..25] of integer ;
s1,s,s4,s5:string;
k:shortint;
code,i,j,w,x:integer;
p :real;
 begin
   val(edit1.Text,w,code);


 {case   of
   begin
 '0':random;
 '1':begin

   while pos(' ',s)<>0 do
   begin
     k:= pos(' ',s);
     s1:=copy(s,1,k-1);
     val(s1,a[i],code);
     delete(s,1,k);

      inc(i);
   end;
   Label3.caption:=a;
 end;
                            items[

 end;  }
  { with sender as TRadioGroup do
 begin   }
 x:=RadioGroup1.itemindex;
 case x of
0 :  random ;
 1: begin
         s:=edit2.caption;
   while pos(' ',s)<>0 do
   begin
     j:=1;
     i:=1;
     p:=i/w;          //ошибка гдето здесь
   if p=1
     then
     begin
     inc(i);
     end;
     k:= pos(' ',s);
     s1:=copy(s,1,k-1);
     val(s1,a[i,j],code);
     delete(s,1,k);

      inc(j);

   end;

   for i:=1 to w do
       for j:=1 to w do
           b[i,j]:=a[i,j];
  for i:=1 to w do
    begin
      s4:='';
      for j:=1 to w do
        begin
          x:= b[i,j];
          str(x, s5);
          s4:=s4+s5+' ';
          end;



 label3.caption:=s4;
  end;


   end;
 end;

  end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
 Form3.ShowModal;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
Form1.close;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
{with sender as TRadioGroup do
 begin
 case Items[itemindex] of
' " Автомат "' :  avtom(edit2.text) ;
 '" В ручную "': vrychn(edit2.text) ;

 end;

 end;}

end;

end.

