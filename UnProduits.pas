﻿unit UnProduits;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFmProduits = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    logoPanel: TPanel;
    Image1: TImage;
    DBGrid: TDBGrid;
    ToolsPanel: TPanel;
    Supprimer: TSpeedButton;
    Consulter: TSpeedButton;
    Ajouter: TSpeedButton;
    Modifier: TSpeedButton;
    Find: TSpeedButton;
    Exporter: TSpeedButton;
    edFilter: TEdit;
    panel1: TPanel;
    Image2: TImage;
    Label2: TLabel;
    Panel2: TPanel;
    Image3: TImage;
    Label1: TLabel;


    procedure FormShow(Sender: TObject);
    procedure spExitClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure edFilterChange(Sender: TObject);
    procedure ExporterClick(Sender: TObject);
    procedure AjouterClick(Sender: TObject);
    procedure ModifierClick(Sender: TObject);
  private
    { Private declarations }
    procedure CheckUserPermissions;
  public
    { Public declarations }
    FDQFillDbGrid: TFDQuery;
    DsFillDbGrid: TDataSource;
    { Public declarations }
    procedure FillDBGrid(const SQLFilter: string = '');
  end;

var
  FmProduits: TFmProduits;

implementation

{$R *.dfm}

uses DmData, UnCategories, UnMarques, UnProduits_OP;

procedure TFmProduits.edFilterChange(Sender: TObject);
begin
 // عند تغيير محتوى مربع النص الخاص بالبحث، يتم تحديث شبكة البيانات وفقًا لمرشح البحث
  FillDBGrid(' WHERE NomCategorie LIKE :NomCategorie OR NomMarques LIKE :NomMarques OR NomProduit LIKE :NomProduit');

end;

procedure TFmProduits.ExporterClick(Sender: TObject);
const
  Title = 'LISTE DES PRODUITS'; // يمكنك تغيير العنوان بما يناسبك
begin
if fmProduits.FDQFillDbGrid.IsEmpty
then begin
          ShowMessage('Impossible d''exporter à partir d''une liste vide !');
          Exit;
     end;

DataM.ExportToExcel(DBGrid, Title);

end;

procedure TfmProduits.FillDBGrid(const SQLFilter: string = '');
begin
  try
    // التحقق مما إذا كان FDQFillDbGrid معينا بالفعل، وإذا كان كذلك، يتم تحريره
    if Assigned(FDQFillDbGrid) then
      FreeAndNil(FDQFillDbGrid);

    // إنشاء وضبط TFDQuery
    FDQFillDbGrid := TFDQuery.Create(nil);
    FDQFillDbGrid.Connection := DataM.FDConnection;

    // بناء استعلام SQL مع مرشح البحث المقدم
    FDQFillDbGrid.SQL.Text :=
'SELECT                                                                         '+
'    P.ProduitID,                                                               '+
'    P.NomProduit,                                                              '+
'    P.QuantiteMin,                                                             '+
'    C.NomCategorie,                                                            '+
'    M.NomMarque                                                               '+
'FROM                                                                           '+
'    TProduits P                                                                '+
'    INNER JOIN TCategories C ON P.CategorieID = C.CategorieID                  '+
'    INNER JOIN TMarques M ON P.MarqueID = M.MarqueID                           '+  SQLFilter;

    // إذا تم توفير مرشح، يتم تعيين المعلمات
    if not SQLFilter.IsEmpty then
    begin
      FDQFillDbGrid.ParamByName('NomCategorie').AsString := '%' + edFilter.Text + '%';
      FDQFillDbGrid.ParamByName('NomMarque').AsString := '%' + edFilter.Text + '%';
       FDQFillDbGrid.ParamByName('NomProduit').AsString := '%' + edFilter.Text + '%';
    end;

    // فتح الاستعلام
    FDQFillDbGrid.Open;

    // التحقق مما إذا كان DsFillDbGrid معينا بالفعل، وإذا كان كذلك، يتم تحريره
    if Assigned(DsFillDbGrid) then
      FreeAndNil(DsFillDbGrid);

    // إنشاء وضبط TDataSource
    DsFillDbGrid := TDataSource.Create(nil);
    DsFillDbGrid.DataSet := FDQFillDbGrid;

    // تعيين TDataSource إلى شبكة البيانات
    DBGrid.DataSource := DsFillDbGrid;
  except
    // معالجة الاستثناءات إذا لزم الأمر
    on E: Exception do
    begin
      ShowMessage('Erreur : ' + E.Message);
      // اختياريا، يمكن إعادة إثارة الاستثناء إذا كنت ترغب في متابعته
      // raise;
    end;
  end;
end;


procedure TFmProduits.FormShow(Sender: TObject);
begin
  // عند عرض نموذج الموظف، يتم ملء شبكة البيانات
  FillDBGrid;
  CheckUserPermissions;
end;

procedure TFmProduits.AjouterClick(Sender: TObject);
begin
DataM.Operation := 'Ajouter'  ;
fmProduits_OP.ShowModal;
end;

procedure TfmProduits.CheckUserPermissions;
begin
  // تحميل الصلاحيات من DataM إذا لم تكن قد تم تحميلها بالفعل
  if not DataM.CanAdd and not DataM.CanEdit and not DataM.CanDelete then
    DataM.LoadUserPermissions(DataM.UtilisateurID);

  // تحديث حالة الأزرار بناءً على الصلاحيات المخزنة
  Ajouter.Enabled := DataM.CanAdd;
  Modifier.Enabled := DataM.CanEdit;
  Supprimer.Enabled := DataM.CanDelete;
end;


procedure TFmProduits.Image2Click(Sender: TObject);
begin
fmmarques.ShowModal
end;

procedure TFmProduits.Image3Click(Sender: TObject);
begin
fmCategories.ShowModal
end;

procedure TFmProduits.ModifierClick(Sender: TObject);
begin
DataM.Operation := 'Modifier';
fmProduits_OP.ShowModal;
end;

procedure TFmProduits.spExitClick(Sender: TObject);
begin
Close;
end;

end.
