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
code,p,h,i,j,w,x:integer;

 begin
   val(edit1.Text,w,code);



 x:=RadioGroup1.itemindex;
 case x of
0 : begin

    for i:=1 to w do
      for j:=0 to w do
        a[i,j]:=random(100);

 b:=a;
     s4:='';
  for i:=1 to w do
    begin

      for j:=1 to w do
        begin
          x:= b[i,j];
          str(x, s5);
          s4:=s4+s5+' ';
          end;


      label3.caption:=s4;
    end;

 end ;
 1: begin
         s:=edit2.caption;
   j:=0;
     i:=1;
 while pos(' ',s)<>0 do
   begin
   inc(j);
     k:= pos(' ',s);
     s1:=copy(s,1,k-1);
     val(s1,a[i,j],code);
     delete(s,1,k);

    if  (j div w)=1
           then
             begin
               inc(i);
               j:=0;
             end;
  end;
    inc (j);
         val(s,a[i,j],code);


   for i:=1 to w do
       for j:=1 to w do
           b[i,j]:=a[i,j];
   s4:='';
  for i:=1 to w do
    begin

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


end;

end.

