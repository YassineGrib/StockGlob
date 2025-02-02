﻿unit UnMarques_OP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFmMarques_OP = class(TForm)
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
    MarqueID: TEdit;
    NomMarque: TEdit;
    procedure FormShow(Sender: TObject);
    procedure spExitClick(Sender: TObject);
    procedure ValiderClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmMarques_OP: TFmMarques_OP;

implementation

{$R *.dfm}

uses DmData, UnMarques;

Function GetMaxID: Integer;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := DataM.FDConnection;
    FDQuery.SQL.Text := 'SELECT MAX(MarqueID) AS MaxID FROM TMarques';
    FDQuery.Open;
    Result := FDQuery.FieldByName('MaxID').AsInteger ;
  finally
    FDQuery.Free;
  end;
end;


procedure TFmMarques_OP.FormShow(Sender: TObject);
begin

  if DataM.Operation = 'Ajouter' then
  begin
   MarqueID.Text := inttostr(GetMaxID + 1) ;
  end
  else if DataM.Operation = 'Modifier' then
  begin
  MarqueID.Text := fmMarques.FDQFillDbGrid.FieldByName('MarqueID').AsString;
  nomMarque.Text := fmMarques.FDQFillDbGrid.FieldByName('nomMarque').AsString;
  end
end;

procedure TFmMarques_OP.spExitClick(Sender: TObject);
begin
Close;
end;

procedure TFmMarques_OP.ValiderClick(Sender: TObject);
Var
  FDQueryInsertTMarque: TFDQuery;
  FDQueryCheckExistence: TFDQuery;
  UtilisateurID: integer;
begin
  // التحقق من ملء جميع الحقول المطلوبة
  if (NomMarque.Text = '') then
  begin
    ShowMessage('Veuillez remplir tous les champs obligatoires.');
    Exit;
  end;

  // التحقق من وجود الفئة مسبقاً
  FDQueryCheckExistence := TFDQuery.Create(Self);
  try
    FDQueryCheckExistence.Connection := DataM.FDConnection;
    FDQueryCheckExistence.SQL.Text := 'SELECT COUNT(*) FROM TMarques WHERE NomMarque = :NomMarque';
    FDQueryCheckExistence.ParamByName('NomMarque').AsString := NomMarque.Text;
    FDQueryCheckExistence.Open;

    if FDQueryCheckExistence.Fields[0].AsInteger > 0 then
    begin
      ShowMessage('Cette Marque existe déjà.');
      Exit;
    end;

  finally
    FDQueryCheckExistence.Free;
  end;

  // إنشاء استعلام جديد لإدخال أو تعديل بيانات الفئة
  FDQueryInsertTMarque := TFDQuery.Create(Self);
  try
    FDQueryInsertTMarque.Connection := DataM.FDConnection;

    if DataM.Operation = 'Ajouter' then
    begin
      FDQueryInsertTMarque.SQL.Text :=
        'INSERT INTO TMarques (NomMarque, UtilisateurID) ' +
        'VALUES (:NomMarque, :UtilisateurID)';
      FDQueryInsertTMarque.ParamByName('NomMarque').AsString := NomMarque.Text;
      FDQueryInsertTMarque.ParamByName('UtilisateurID').AsInteger := DataM.UtilisateurID;

      FDQueryInsertTMarque.ExecSQL;
      ShowMessage('Marque ajoutée avec succès.');
    end
    else if DataM.Operation = 'Modifier' then
    begin
      FDQueryInsertTMarque.SQL.Text :=
        'UPDATE TMarques SET NomMarque = :NomMarque ' +
        'WHERE MarqueID = :MarqueID';
      FDQueryInsertTMarque.ParamByName('NomMarque').AsString := NomMarque.Text;
      FDQueryInsertTMarque.ParamByName('MarqueID').AsInteger := strtoint(MarqueID.text); // تأكد من تعيين قيمة DataM.IDCategorie قبل استدعاء هذا الإجراء

      FDQueryInsertTMarque.ExecSQL;
      ShowMessage('Marque modifiée avec succès.');
    end;

  finally
    FDQueryInsertTMarque.Free;
  end;

  Close;
  FmMarques.FillDBGrid;
end;

end.
