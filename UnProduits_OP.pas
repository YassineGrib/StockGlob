﻿unit UnProduits_OP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.NumberBox;

type
  TfmProduits_OP = class(TForm)
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Marquelabel: TLabel;
    Label7: TLabel;
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    ToolsPanel: TPanel;
    Valider: TSpeedButton;
    Initialiser: TSpeedButton;
    ProduitID: TEdit;
    NomProduit: TEdit;
    NomMarque: TComboBox;
    NomCategorie: TComboBox;
    QuantiteMin: TNumberBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure InitialiserClick(Sender: TObject);
    procedure spExitClick(Sender: TObject);
    procedure ValiderClick(Sender: TObject);
  private
    { Private declarations }
     Function GetMaxID: Integer;
     procedure Consulter;
  public
    { Public declarations }
    procedure FillCategoriesAndMarques;
  end;

var
  fmProduits_OP: TfmProduits_OP;

implementation

{$R *.dfm}

uses DmData, UnProduits;






procedure TfmProduits_OP.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // تحقق من الضغط على مفتاح Enter
    //ValiderClick(Sender); // استدعاء الإجراء ValiderClick
end;

procedure TfmProduits_OP.FormShow(Sender: TObject);
begin
  if Datam.Operation = 'Modifier' then
    begin
      // تعطيل حقل ID عند التعديل
      ProduitID.Enabled := false;
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
   ProduitID.Text := inttostr(GetMaxID);
   ProduitID.Text:= inttostr(Getmaxid);
  end;

  // تعيين عنوان النموذج بناءً على العملية الحالية
  Titel.caption := 'G-Stock | Gestion Des Fournisseurs | ' + DataM.Operation;
  FillCategoriesAndMarques;


end;



procedure TfmProduits_OP.Consulter;
begin
  // ملء الحقول ببيانات الموظف المحددة من قاعدة البيانات
  ProduitID.Text          := fmProduits.FDQFillDbGrid.FieldByName('ProduitID').AsString;
  NomProduit.Text         := fmProduits.FDQFillDbGrid.FieldByName('NomProduit').AsString;
  nomCategorie.Text       := fmProduits.FDQFillDbGrid.FieldByName('nomCategorie').AsString;
  nomMarque.Text          := fmProduits.FDQFillDbGrid.FieldByName('nomMarque').AsString;
  QuantiteMin.Text        := fmProduits.FDQFillDbGrid.FieldByName('QuantiteMin').AsString;

end;

Function TfmProduits_OP.GetMaxID: Integer;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := DataM.FDConnection;
    FDQuery.SQL.Text := 'SELECT MAX(ProduitID) AS MaxID FROM TProduits';
    FDQuery.Open;
    Result := FDQuery.FieldByName('MaxID').AsInteger + 1;
  finally
    FDQuery.Free;
  end;
end;



procedure TfmProduits_OP.InitialiserClick(Sender: TObject);
begin
  NomProduit.Clear;
  nomCategorie.Clear;
  nomMarque.Clear;
  NomProduit.Clear;
  QuantiteMin.Clear;
  FillCategoriesAndMarques;
end;

procedure TfmProduits_OP.spExitClick(Sender: TObject);
begin
Close;
end;
procedure TfmProduits_OP.ValiderClick(Sender: TObject);
var
  FDQueryUpdate, FDQueryCheckExists, FDQueryInsert: TFDQuery;
begin
  // Vérifiez que tous les champs obligatoires sont remplis
  if (NomProduit.Text = '') or (nomCategorie.Text = '') or (nomMarque.Text = '') then
  begin
    ShowMessage('Veuillez remplir tous les champs obligatoires.');
    Exit;
  end;

  if DataM.Operation = 'Ajouter' then
  begin

    // تحقق من عدم وجود المنتج بالفعل بناءً على اسم المنتج
    FDQueryCheckExists := TFDQuery.Create(nil);
    try
      FDQueryCheckExists.Connection := DataM.FDConnection;
      FDQueryCheckExists.SQL.Text := 'SELECT COUNT(*) FROM TProduits WHERE NomProduit = :NomProduit';
      FDQueryCheckExists.ParamByName('NomProduit').AsString := NomProduit.Text;
      FDQueryCheckExists.Open;
      if FDQueryCheckExists.Fields[0].AsInteger > 0 then
      begin
        ShowMessage('المنتج موجود مسبقًا.');
        Exit;
      end;
    finally
      FDQueryCheckExists.Free;
    end;

    // إذا كانت جميع التحققات ناجحة، أدخل البيانات في جدول المنتجات
    FDQueryInsert := TFDQuery.Create(nil);
    try
      FDQueryInsert.Connection := DataM.FDConnection;
      FDQueryInsert.SQL.Text := 'INSERT INTO TProduits (NomProduit, CategorieID, MarqueID, QuantiteMin, UtilisateurID) ' +
                                'VALUES (:NomProduit, :CategorieID, :MarqueID, :QuantiteMin, :UtilisateurID)';

      FDQueryInsert.ParamByName('NomProduit').AsString := NomProduit.Text;
      FDQueryInsert.ParamByName('CategorieID').AsInteger := Integer(nomCategorie.Items.Objects[nomCategorie.ItemIndex]);
      FDQueryInsert.ParamByName('MarqueID').AsInteger := Integer(nomMarque.Items.Objects[nomMarque.ItemIndex]);
      FDQueryInsert.ParamByName('QuantiteMin').AsInteger := StrToInt(QuantiteMin.Text);
      FDQueryInsert.ParamByName('UtilisateurID').AsInteger := DataM.UtilisateurID;
      FDQueryInsert.ExecSQL;

      ShowMessage('تم إضافة المنتج بنجاح.');
      InitialiserClick(Sender);
      fmProduits.FillDBGrid();
      Close;

    finally
      FDQueryInsert.Free;
    end;
  end
  else if DataM.Operation = 'Modifier' then
  begin
{
    // تحقق من عدم وجود المنتج بالفعل بناءً على اسم المنتج (تجاهل المنتج الحالي)
    FDQueryCheckExists := TFDQuery.Create(nil);
    try
      FDQueryCheckExists.Connection := DataM.FDConnection;
      FDQueryCheckExists.SQL.Text := 'SELECT COUNT(*) FROM TProduits WHERE NomProduit = :NomProduit ';
      FDQueryCheckExists.ParamByName('NomProduit').AsString := NomProduit.Text;
      FDQueryCheckExists.Open;
      if FDQueryCheckExists.Fields[0].AsInteger > 0 then
      begin
        ShowMessage('المنتج موجود مسبقًا.');
        Exit;
      end;
    finally
      FDQueryCheckExists.Free;
    end;
}
    // إذا كانت جميع التحققات ناجحة، عدّل البيانات في جدول المنتجات
    FDQueryUpdate := TFDQuery.Create(nil);
    try
      FDQueryUpdate.Connection := DataM.FDConnection;
      FDQueryUpdate.SQL.Text := 'UPDATE TProduits SET NomProduit = :NomProduit, CategorieID = :CategorieID, ' +
                                'MarqueID = :MarqueID, QuantiteMin = :QuantiteMin, UtilisateurID = :UtilisateurID ' +
                                'WHERE ProduitID = :ProduitID';

      FDQueryUpdate.ParamByName('NomProduit').AsString := NomProduit.Text;
      FDQueryUpdate.ParamByName('CategorieID').AsInteger := Integer(nomCategorie.Items.Objects[nomCategorie.ItemIndex]);
      FDQueryUpdate.ParamByName('MarqueID').AsInteger := Integer(nomMarque.Items.Objects[nomMarque.ItemIndex]);
      FDQueryUpdate.ParamByName('QuantiteMin').AsInteger := StrToInt(QuantiteMin.Text);
      FDQueryUpdate.ParamByName('UtilisateurID').AsInteger := DataM.UtilisateurID;
      FDQueryUpdate.ParamByName('ProduitID').AsInteger := StrtoInt(ProduitID.text); // يجب تعيين هذا المعرف للمنتج الذي يتم تعديله
      FDQueryUpdate.ExecSQL;

      ShowMessage('تم تعديل المنتج بنجاح.');
      InitialiserClick(Sender);
      fmProduits.FillDBGrid();
      Close;

    finally
      FDQueryUpdate.Free;
    end;
  end;
end;

procedure TfmProduits_OP.FillCategoriesAndMarques;
var
  FDQueryCategories, FDQueryMarques: TFDQuery;
begin
  // إنشاء استعلام جديد لملء الفئات
  FDQueryCategories := TFDQuery.Create(Self);
  try
    FDQueryCategories.Connection := DataM.FDConnection;
    FDQueryCategories.SQL.Text := 'SELECT CategorieID, NomCategorie FROM TCategories';
    FDQueryCategories.Open;

    // ملء القائمة المنسدلة للفئات
    nomCategorie.Items.Clear;
    while not FDQueryCategories.Eof do
    begin
      nomCategorie.Items.AddObject(
        FDQueryCategories.FieldByName('NomCategorie').AsString,
        TObject(FDQueryCategories.FieldByName('CategorieID').AsInteger)
      );
      FDQueryCategories.Next;
    end;
  finally
    FDQueryCategories.Free;
  end;

  // إنشاء استعلام جديد لملء العلامات التجارية
  FDQueryMarques := TFDQuery.Create(Self);
  try
    FDQueryMarques.Connection := DataM.FDConnection;
    FDQueryMarques.SQL.Text := 'SELECT MarqueID, NomMarque FROM TMarques';
    FDQueryMarques.Open;

    // ملء القائمة المنسدلة للعلامات التجارية
    nomMarque.Items.Clear;
    while not FDQueryMarques.Eof do
    begin
      nomMarque.Items.AddObject(
        FDQueryMarques.FieldByName('NomMarque').AsString,
        TObject(FDQueryMarques.FieldByName('MarqueID').AsInteger)
      );
      FDQueryMarques.Next;
    end;
  finally
    FDQueryMarques.Free;
  end;
end;







end.
