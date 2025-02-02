﻿unit UnClients_OP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.RegularExpressions;

type
  TfmClients_OP = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    ToolsPanel: TPanel;
    Valider: TSpeedButton;
    Initialiser: TSpeedButton;
    ClientID: TEdit;
    Label1: TLabel;
    Statut: TComboBox;
    NomClient: TEdit;
    Label2: TLabel;
    NumTelephone: TEdit;
    Label5: TLabel;
    Email: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Adresse: TEdit;
    Image2: TImage;
    procedure spExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ValiderClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Consulter;
    procedure InitialiserClick(Sender: TObject);


  private
    { Private declarations }
     Function GetMaxClientID: Integer;

  public
    { Public declarations }
  end;

var
  fmClients_OP: TfmClients_OP;

implementation

{$R *.dfm}

uses DmData, UnClients;






procedure TfmClients_OP.ValiderClick(Sender: TObject);
var
  FDQueryUpdate, FDQueryCheckExists, FDQueryInsert: TFDQuery;
begin
    // Vérifiez que tous les champs obligatoires sont remplis
    if (NomClient.Text = '') or (NumTelephone.Text = '') then
    begin
      ShowMessage('Le nom et le numéro de téléphone sont des champs obligatoires.');
      Exit;
    end;
    // Vérifiez la validité de l'adresse e-mail si elle est entrée
    if (Email.Text <> '') and not TRegEx.IsMatch(Email.Text, '^[\w\.-]+@[\w\.-]+\.\w+$') then
    begin
      ShowMessage('L''adresse e-mail n''est pas valide.');
      Email.SetFocus;
      Exit;
    end;
    // Vérifiez la validité du numéro de téléphone
    if not TRegEx.IsMatch(NumTelephone.Text, '^\d{10}$') then
    begin
      ShowMessage('Le numéro de téléphone doit contenir 10 chiffres.');
      NumTelephone.SetFocus;
      Exit;
    end;

    if DataM.Operation = 'Ajouter' then
    begin
       // تحقق من عدم وجود العميل بالفعل بناءً على رقم الهاتف
    FDQueryCheckExists := TFDQuery.Create(nil);
    try
      FDQueryCheckExists.Connection := DataM.FDConnection;
      FDQueryCheckExists.SQL.Text := 'SELECT COUNT(*) FROM TClients WHERE NumTelephone = :NumTelephone';
      FDQueryCheckExists.ParamByName('NumTelephone').AsString := NumTelephone.Text;
      FDQueryCheckExists.Open;
      if FDQueryCheckExists.Fields[0].AsInteger > 0 then
      begin
        ShowMessage('العميل موجود بالفعل.');
        Exit;
      end;
    finally
      FDQueryCheckExists.Free;
    end;
    // إذا كانت جميع التحققات ناجحة، أدخل البيانات في جدول العملاء
    FDQueryInsert := TFDQuery.Create(nil);
    try
      FDQueryInsert.Connection := DataM.FDConnection;
      FDQueryInsert.SQL.Text := 'INSERT INTO TClients (NomClient, Adresse, NumTelephone, Email, Statut, UtilisateurID) ' +
                                'VALUES (:NomClient, :Adresse, :NumTelephone, :Email, :Statut, :UtilisateurID)';
      FDQueryInsert.ParamByName('NomClient').AsString := NomClient.Text;
      FDQueryInsert.ParamByName('Adresse').AsString := Adresse.Text;
      FDQueryInsert.ParamByName('NumTelephone').AsString := NumTelephone.Text;
      FDQueryInsert.ParamByName('Email').AsString := Email.Text;
      FDQueryInsert.ParamByName('Statut').AsString := Statut.Text;
      FDQueryInsert.ParamByName('UtilisateurID').Asinteger := DataM.UtilisateurID;
      FDQueryInsert.ExecSQL;

      ShowMessage('تم إضافة العميل بنجاح.');
      InitialiserClick(Sender);

    finally
      FDQueryInsert.Free;
    end;
  end;

  IF datam.Operation = 'Modifier' then
    begin
      FDQueryUpdate := TFDQuery.Create(nil);
      try
        FDQueryUpdate.Connection := DataM.FDConnection;

        FDQueryUpdate.SQL.Text := 'UPDATE TClients SET NomClient = :NomClient, Adresse = :Adresse, NumTelephone = :NumTelephone, Email = :Email, Statut = :Statut ' +
                                  'WHERE ClientID = :ClientID';
        FDQueryUpdate.ParamByName('NomClient').AsString := NomClient.Text;
        FDQueryUpdate.ParamByName('Adresse').AsString := Adresse.Text;
        FDQueryUpdate.ParamByName('NumTelephone').AsString := NumTelephone.Text;
        FDQueryUpdate.ParamByName('Email').AsString := Email.Text;
        FDQueryUpdate.ParamByName('Statut').AsString := Statut.Text;
        FDQueryUpdate.ParamByName('ClientID').AsInteger := StrToInt(ClientID.Text);

        FDQueryUpdate.ExecSQL;
        ShowMessage('Les données ont été mises à jour avec succès.');

        fmClients.fillDBGrid;
        Self.Close;

      finally
        FDQueryUpdate.Free;
      end;

    end;
end;

procedure TfmClients_OP.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // تحقق من الضغط على مفتاح Enter
    ValiderClick(Sender); // استدعاء الإجراء ValiderClick
end;

procedure TfmClients_OP.FormShow(Sender: TObject);
begin
  if Datam.Operation = 'Modifier' then
    begin
      // تعطيل حقل ID عند التعديل
      ClientID.Enabled := false;
      Consulter;
    end;

  if DataM.Operation = 'Consulter' then
    begin
      // تعطيل الأزرار عند الاستشارة فقط
      Valider.Enabled := False;
      Initialiser.Enabled := False;
      Consulter;
    end;


  if DataM.Operation = 'Ajouter' then
  begin
   ClientID.Text := Format('CLT%04d', [GetMaxClientID]);
  end;

  // تعيين عنوان النموذج بناءً على العملية الحالية
  Titel.caption := 'G-Stock | Gestion Des Clients | ' + DataM.Operation;

end;



procedure TfmClients_OP.Consulter;
begin
  // ملء الحقول ببيانات الموظف المحددة من قاعدة البيانات
  ClientID.Text     := fmClients.FDQFillDbGrid.FieldByName('ClientID').AsString;
  NomClient.Text    := fmClients.FDQFillDbGrid.FieldByName('NomClient').AsString;
  Adresse.Text      := fmClients.FDQFillDbGrid.FieldByName('Adresse').AsString;
  NumTelephone.Text := fmClients.FDQFillDbGrid.FieldByName('NumTelephone').AsString;
  Email.Text        := fmClients.FDQFillDbGrid.FieldByName('Email').AsString;
  Statut.Text       := fmClients.FDQFillDbGrid.FieldByName('Statut').AsString;

end;


Function TfmClients_OP.GetMaxClientID: Integer;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := DataM.FDConnection;
    FDQuery.SQL.Text := 'SELECT MAX(ClientID) AS MaxID FROM TClients';
    FDQuery.Open;
    Result := FDQuery.FieldByName('MaxID').AsInteger + 1;
  finally
    FDQuery.Free;
  end;
end;

procedure TfmClients_OP.InitialiserClick(Sender: TObject);
begin
  //ClientID.Text     := fmClients.FDQFillDbGrid.FieldByName('ClientID').AsString;
  NomClient.Clear ;
  Adresse.Clear   ;
  NumTelephone.Clear;
  Email.Clear       ;
  Statut.ItemIndex := 0 ;
end;

procedure TfmClients_OP.spExitClick(Sender: TObject);
begin
Close;
end;

end.
