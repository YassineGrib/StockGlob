﻿unit UnCategories_OP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFmCategories_OP = class(TForm)
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    ToolsPanel: TPanel;
    Valider: TSpeedButton;
    Initialiser: TSpeedButton;
    CategorieID: TEdit;
    NomCategorie: TEdit;
    procedure FormShow(Sender: TObject);
    procedure spExitClick(Sender: TObject);
    procedure ValiderClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmCategories_OP: TFmCategories_OP;

implementation

{$R *.dfm}

uses DmData, UnCategories;

Function GetMaxID: Integer;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := DataM.FDConnection;
    FDQuery.SQL.Text := 'SELECT MAX(CategorieID) AS MaxID FROM TCategories';
    FDQuery.Open;
    Result := FDQuery.FieldByName('MaxID').AsInteger ;
  finally
    FDQuery.Free;
  end;
end;


procedure TFmCategories_OP.FormShow(Sender: TObject);
begin

  if DataM.Operation = 'Ajouter' then
  begin
   CategorieID.Text := inttostr(GetMaxID + 1) ;
  end
  else if DataM.Operation = 'Modifier' then
  begin
  CategorieID.Text := fmCategories.FDQFillDbGrid.FieldByName('CategorieID').AsString;
  nomCategorie.Text := fmCategories.FDQFillDbGrid.FieldByName('nomCategorie').AsString;
  end
end;

procedure TFmCategories_OP.spExitClick(Sender: TObject);
begin
Close;
end;

procedure TFmCategories_OP.ValiderClick(Sender: TObject);
Var
  FDQueryInsertTCatagories: TFDQuery;
  FDQueryCheckExistence: TFDQuery;
  UtilisateurID: integer;
begin
  // التحقق من ملء جميع الحقول المطلوبة
  if (NomCategorie.Text = '') then
  begin
    ShowMessage('Veuillez remplir tous les champs obligatoires.');
    Exit;
  end;

  // التحقق من وجود الفئة مسبقاً
  FDQueryCheckExistence := TFDQuery.Create(Self);
  try
    FDQueryCheckExistence.Connection := DataM.FDConnection;
    FDQueryCheckExistence.SQL.Text := 'SELECT COUNT(*) FROM TCategories WHERE NomCategorie = :NomCategorie';
    FDQueryCheckExistence.ParamByName('NomCategorie').AsString := NomCategorie.Text;
    FDQueryCheckExistence.Open;

    if FDQueryCheckExistence.Fields[0].AsInteger > 0 then
    begin
      ShowMessage('Cette catégorie existe déjà.');
      Exit;
    end;

  finally
    FDQueryCheckExistence.Free;
  end;

  // إنشاء استعلام جديد لإدخال أو تعديل بيانات الفئة
  FDQueryInsertTCatagories := TFDQuery.Create(Self);
  try
    FDQueryInsertTCatagories.Connection := DataM.FDConnection;

    if DataM.Operation = 'Ajouter' then
    begin
      FDQueryInsertTCatagories.SQL.Text :=
        'INSERT INTO TCategories (NomCategorie, UtilisateurID) ' +
        'VALUES (:NomCategorie, :UtilisateurID)';
      FDQueryInsertTCatagories.ParamByName('NomCategorie').AsString := NomCategorie.Text;
      FDQueryInsertTCatagories.ParamByName('UtilisateurID').AsInteger := DataM.UtilisateurID;

      FDQueryInsertTCatagories.ExecSQL;
      ShowMessage('Catégorie ajoutée avec succès.');
    end
    else if DataM.Operation = 'Modifier' then
    begin
      FDQueryInsertTCatagories.SQL.Text :=
        'UPDATE TCategories SET NomCategorie = :NomCategorie ' +
        'WHERE CategorieID = :CategorieID';
      FDQueryInsertTCatagories.ParamByName('NomCategorie').AsString := NomCategorie.Text;
      FDQueryInsertTCatagories.ParamByName('CategorieID').AsInteger := strtoint(CategorieID.text); // تأكد من تعيين قيمة DataM.IDCategorie قبل استدعاء هذا الإجراء

      FDQueryInsertTCatagories.ExecSQL;
      ShowMessage('Catégorie modifiée avec succès.');
    end;

  finally
    FDQueryInsertTCatagories.Free;
  end;

  Close;
  FmCategories.FillDBGrid;
end;

end.
