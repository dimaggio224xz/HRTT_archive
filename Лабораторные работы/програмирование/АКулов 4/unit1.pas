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
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation
Uses Unit2, Unit3;
{$R *.lfm}

{ TForm1 }

procedure TForm1.N11Click(Sender: TObject);
begin
Form2.ShowModal;

end;

procedure TForm1.N21Click(Sender: TObject);
begin
Form3.ShowModal;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
Form1.Close;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  Form1.close;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
    Form2.showmodal;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
     Form3.showmodal;
end;

end.

