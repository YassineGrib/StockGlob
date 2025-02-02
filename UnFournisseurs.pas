﻿unit UnFournisseurs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmFournisseurs = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    logoPanel: TPanel;
    Image1: TImage;
    Label3: TLabel;
    ToolsPanel: TPanel;
    Supprimer: TSpeedButton;
    Consulter: TSpeedButton;
    Ajouter: TSpeedButton;
    Modifier: TSpeedButton;
    Find: TSpeedButton;
    Exporter: TSpeedButton;
    edFilter: TEdit;
    dbgrid: TDBGrid;

    procedure ConsulterClick(Sender: TObject);
    procedure AjouterClick(Sender: TObject);
    procedure edFilterChange(Sender: TObject);
    procedure ExporterClick(Sender: TObject);
    procedure CheckUserPermissions;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ModifierClick(Sender: TObject);
    procedure spExitClick(Sender: TObject);
  private
    { Private declarations }

    DsFillDbGrid: TDataSource;
  public
    { Public declarations }
     FDQFillDbGrid: TFDQuery;
     procedure FillDBGrid(const SQLFilter: string = '');




  end;

var
  fmFournisseurs: TfmFournisseurs;

implementation

{$R *.dfm}

uses DmData, UnFournisseurs_OP;

procedure TfmFournisseurs.AjouterClick(Sender: TObject);
begin
DataM.Operation := 'Ajouter';
  fmFournisseurs_OP := TfmFournisseurs_OP.Create(Self);
  fmFournisseurs_OP.ShowModal;
  fmFournisseurs_OP.free;
end;

procedure TfmFournisseurs.ConsulterClick(Sender: TObject);
begin
 DataM.Operation := 'Consulter';
  fmFournisseurs_OP := TfmFournisseurs_OP.Create(Self);
  fmFournisseurs_OP.ShowModal;
  fmFournisseurs_OP.free;

end;

procedure TfmFournisseurs.edFilterChange(Sender: TObject);
begin
 // عند تغيير محتوى مربع النص الخاص بالبحث، يتم تحديث شبكة البيانات وفقًا لمرشح البحث
  FillDBGrid(' WHERE NomFournisseur LIKE :NomFournisseur OR NumTelephone LIKE :NumTelephone');
end;

procedure TfmFournisseurs.ExporterClick(Sender: TObject);
const
  Title = 'LISTE DES Fournisseurs'; // يمكنك تغيير العنوان بما يناسبك
begin
if fmFournisseurs.FDQFillDbGrid.IsEmpty
then begin
          ShowMessage('Impossible d''exporter à partir d''une liste vide !');
          Exit;
     end;

DataM.ExportToExcel(DBGrid, Title);
end;



procedure TfmFournisseurs.FillDBGrid(const SQLFilter: string = '');
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
      'SELECT * FROM TFournisseurs ' + SQLFilter;

    // إذا تم توفير مرشح، يتم تعيين المعلمات
    if not SQLFilter.IsEmpty then
    begin
      FDQFillDbGrid.ParamByName('NomFournisseur').AsString := '%' + edFilter.Text + '%';
      FDQFillDbGrid.ParamByName('NumTelephone').AsString := '%' + edFilter.Text + '%';
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

procedure TfmFournisseurs.CheckUserPermissions;
begin
  // تحميل الصلاحيات من DataM إذا لم تكن قد تم تحميلها بالفعل
  if not DataM.CanAdd and not DataM.CanEdit and not DataM.CanDelete then
    DataM.LoadUserPermissions(DataM.UtilisateurID);

  // تحديث حالة الأزرار بناءً على الصلاحيات المخزنة
  Ajouter.Enabled := DataM.CanAdd;
  Modifier.Enabled := DataM.CanEdit;
  Supprimer.Enabled := DataM.CanDelete;
end;



procedure TfmFournisseurs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Close;
end;

procedure TfmFournisseurs.FormShow(Sender: TObject);
begin
  // عند عرض نموذج الموظف، يتم ملء شبكة البيانات
  FillDBGrid;
  CheckUserPermissions;
end;

procedure TfmFournisseurs.ModifierClick(Sender: TObject);
begin
  DataM.Operation := 'Modifier';
  fmFournisseurs_OP := TfmFournisseurs_OP.Create(Self);
  fmFournisseurs_OP.ShowModal;
  fmFournisseurs_OP.free;
end;

procedure TfmFournisseurs.spExitClick(Sender: TObject);
begin
Close;
end;

end.
