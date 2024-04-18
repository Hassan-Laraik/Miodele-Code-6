unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  DBExtCtrls, DBGrids, ZConnection, ZDataset;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnNouveau: TButton;
    BtnModifier: TButton;
    BtnSuprimer: TButton;
    BtnAnnuler: TButton;
    BtValider: TButton;
    DBGrid1: TDBGrid;
    DBComboBox1: TDBComboBox;
    DBDateEdit1: TDBDateEdit;
    DBEtCIN: TDBEdit;
    DBEdtNom: TDBEdit;
    DBEdtPhone: TDBEdit;
    DBEdit4: TDBEdit;
    DBImage1: TDBImage;
    DBMemo1: TDBMemo;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure BtnAnnulerClick(Sender: TObject);
    procedure BtnModifierClick(Sender: TObject);
    procedure BtnNouveauClick(Sender: TObject);
    procedure BtValiderClick(Sender: TObject);
    procedure DBEdtPhoneKeyPress(Sender: TObject; var Key: char);
  private

  public
    Function ValiderSaisieFormateur():Boolean;
    function FormateurExiste(cin: String): Boolean;
    function PhoneExiste(gsm : String) : Boolean;
  end;

var
  Form1: TForm1;

implementation
uses uDM;
{$R *.lfm}

{ TForm1 }

procedure TForm1.BtnNouveauClick(Sender: TObject);
begin
  if DM.ZtblFormateur.State in [dsInsert,dsEdit] then exit;
  DM.ZtblFormateur.Append;
  DBEtCIN.SetFocus;
end;

procedure TForm1.BtValiderClick(Sender: TObject);
begin
  if  NOT (DM.ZtblFormateur.State in [dsInsert,dsEdit]) then exit;
  //fonction valiser les donnees saisies avant poster
   if NOT self.ValiderSaisieFormateur() then exit ;
  //verifier si formateur deja enregistre
  if FormateurExiste(trim(DBEtCIN.Text)) then
  begin
    ShowMessage('Ce Code Formateur Existe deja');
    DBEtCIN.SetFocus;
    exit;
  end;
  //Verifer si Phone Unique
  if self.PhoneExiste(trim(DBEdtPhone.Text)) then
  begin
   ShowMessage('Ce Numero Existe deja');
    DBEdtPhone.SetFocus;
    exit;
  end;
   DM.ZtblFormateur.Post;;
end;

procedure TForm1.DBEdtPhoneKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in ['0'..'9',#8] ) then key := #0;
end;

function TForm1.ValiderSaisieFormateur: Boolean;
begin
  result := False;
  if Length(Trim(DBEtCIN.Text)) = 0  then
  begin
     ShowMessage('CIN Vide');
     DBEtCIN.SetFocus;
     exit;
  end;
  if Length(Trim(DBEdtNom.Text))  < 5 then
  begin
     ShowMessage('Donner un Nom Complet Correcte');
     DBEdtNom.SetFocus;
     exit;
  end;
  if Length(Trim(DBEdtPhone.Text))  < 10 then
  begin
     ShowMessage('Donner un Numero de Telephone Correcte');
     DBEdtPhone.SetFocus;
     exit;
  end;
  Result := True;
end;

function TForm1.FormateurExiste(cin : String): Boolean;
begin
  Result:=False;
  Dm.ZQryHelp.Close;
  Dm.ZQryHelp.sql.Clear;
  Dm.ZQryHelp.sql.add('Select Cin_Formateur from Formateurs ');
  Dm.ZQryHelp.sql.add(' where Cin_Formateur =:cin ');
  Dm.ZQryHelp.ParamByName('cin').AsString:=cin;
  Dm.ZQryHelp.Open;
 //if  Dm.ZQryHelp.RecordCount <> 0 then  Result:=True;
 Result :=  (Dm.ZQryHelp.RecordCount <> 0 );
end;

function TForm1.PhoneExiste(gsm:string): Boolean;
var
  AsString: String;
begin
 Result:=False;
  Dm.ZQryHelp.Close;
  Dm.ZQryHelp.sql.Clear;
  Dm.ZQryHelp.sql.add('Select Gsm from Formateurs ');
  Dm.ZQryHelp.sql.add(' where Gsm  =:gsm ');
  Dm.ZQryHelp.ParamByName('gsm').AsString:=gsm;
  Dm.ZQryHelp.Open;
 //if  Dm.ZQryHelp.RecordCount <> 0 then  Result:=True;
 Result :=  (Dm.ZQryHelp.RecordCount <> 0 );
end;

procedure TForm1.BtnModifierClick(Sender: TObject);
begin
  if DM.ZtblFormateur.State in [dsInsert,dsEdit] then exit;
  DM.ZtblFormateur.Edit;
  DBEtCIN.SetFocus;
end;

procedure TForm1.BtnAnnulerClick(Sender: TObject);
begin
  if DM.ZtblFormateur.State in [dsBrowse] then exit;
  DM.ZtblFormateur.Cancel;
  DBEtCIN.SetFocus;
end;

end.

