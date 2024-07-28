unit UnUtilisateurs_OP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.WinXCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmUtilisateurs_OP = class(TForm)
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    ToolsPanel: TPanel;
    Valider: TSpeedButton;
    Initialiser: TSpeedButton;
    UtilisateurID: TEdit;
    Email: TEdit;
    NomUtilisateur: TEdit;
    MotDePasse: TEdit;
    Statut: TComboBox;
    Ajouter: TToggleSwitch;
    Modifier: TToggleSwitch;
    Supprimier: TToggleSwitch;
    Venter: TToggleSwitch;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    admin: TToggleSwitch;
    Label11: TLabel;
    procedure spExitClick(Sender: TObject);
    procedure ValiderClick(Sender: TObject);
    Function GetMaxID: Integer;

    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmUtilisateurs_OP: TfmUtilisateurs_OP;

implementation

{$R *.dfm}

uses DmData, UnUtilisateurs;

procedure TfmUtilisateurs_OP.spExitClick(Sender: TObject);
begin
Close;
end;

procedure TfmUtilisateurs_OP.FormShow(Sender: TObject);
begin


 if DataM.Operation = 'Ajouter' then
  begin
   UtilisateurID.Text := Format('UTL%04d', [GetMaxID]);
  end;
end;

function TfmUtilisateurs_OP.GetMaxID: Integer;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := DataM.FDConnection;
    FDQuery.SQL.Text := 'SELECT MAX(UtilisateurID) AS MaxID FROM TUtilisateurs';
    FDQuery.Open;
    Result := FDQuery.FieldByName('MaxID').AsInteger + 1;
  finally
    FDQuery.Free;
  end;
end;

procedure TfmUtilisateurs_OP.ValiderClick(Sender: TObject);
var
  FDQueryInsertTUtilisateurs: TFDQuery;
  FDQueryInsertTPermissions: TFDQuery;
  UtilisateurID : integer;
begin

UtilisateurID  :=  GetMaxID  ;
  // التحقق من ملء جميع الحقول المطلوبة
  if (NomUtilisateur.Text = '') or (MotDePasse.Text = '') or (Statut.Text = '') then
  begin
    ShowMessage('Veuillez remplir tous les champs obligatoires.');
    Exit;
  end;

  // إنشاء استعلام جديد لإدخال بيانات المستخدم
  FDQueryInsertTUtilisateurs := TFDQuery.Create(Self);
  try
    // تعيين اتصال قاعدة البيانات للاستعلام
    FDQueryInsertTUtilisateurs.Connection := DataM.FDConnection;

    // إعداد نص الاستعلام لإدخال بيانات المستخدم
    FDQueryInsertTUtilisateurs.SQL.Text :=
      'INSERT INTO TUtilisateurs (UtilisateurID, NomUtilisateur, MotDePasse, Email, Statut) ' +
      'VALUES (:UtilisateurID,:NomUtilisateur, :MotDePasse, :Email, :Statut)';

    // تعيين القيم للمعلمات في الاستعلام
    FDQueryInsertTUtilisateurs.ParamByName('UtilisateurID').AsInteger := UtilisateurID;
    FDQueryInsertTUtilisateurs.ParamByName('NomUtilisateur').AsString := NomUtilisateur.Text;
    FDQueryInsertTUtilisateurs.ParamByName('MotDePasse').AsString := MotDePasse.Text;
    FDQueryInsertTUtilisateurs.ParamByName('Email').AsString := Email.Text;
    FDQueryInsertTUtilisateurs.ParamByName('Statut').AsString := Statut.Text;

    // تنفيذ الاستعلام
    FDQueryInsertTUtilisateurs.ExecSQL;
  finally;
  FDQueryInsertTUtilisateurs.free
  end;


   FDQueryInsertTPermissions := TFDQuery.Create(Self);
  try
    // تعيين اتصال قاعدة البيانات للاستعلام
    FDQueryInsertTPermissions.Connection := DataM.FDConnection;

    // إدخال صلاحيات المستخدم الجديد في جدول TPermissions
    FDQueryInsertTPermissions.SQL.Text :=
      'INSERT INTO TPermissions (UtilisateurID, PeutAjouter, PeutModifier, PeutSupprimer, PeutVendre, EstAdmin) ' +
      'VALUES (:UtilisateurID, :PeutAjouter, :PeutModifier, :PeutSupprimer, :PeutVendre, :EstAdmin)';

    // تعيين القيم للمعلمات في الاستعلام
    FDQueryInsertTPermissions.ParamByName('UtilisateurID').AsInteger := UtilisateurID ;
    FDQueryInsertTPermissions.ParamByName('PeutAjouter').AsBoolean := (Ajouter.State = tsson);
    FDQueryInsertTPermissions.ParamByName('PeutModifier').AsBoolean := (Modifier.State = tsson);
    FDQueryInsertTPermissions.ParamByName('PeutSupprimer').AsBoolean := (Supprimier.State = tsson);
    FDQueryInsertTPermissions.ParamByName('PeutVendre').AsBoolean := (Venter.State = tsson);
    FDQueryInsertTPermissions.ParamByName('EstAdmin').AsBoolean := (admin.State = tsson);

    // تنفيذ الاستعلام
    FDQueryInsertTPermissions.ExecSQL;

  finally;
  FDQueryInsertTPermissions.free
  end;

     // إظهار رسالة نجاح
    ShowMessage('Utilisateur ajouté avec succès.');
    Close;
    fmUtilisateurs.FillDBGrid ;
   end;
end.
