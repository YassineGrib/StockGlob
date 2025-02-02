﻿unit UnCategories;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFmCategories = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    logoPanel: TPanel;
    Image1: TImage;
    Label3: TLabel;
    DBGrid: TDBGrid;
    ToolsPanel: TPanel;
    Supprimer: TSpeedButton;
    Ajouter: TSpeedButton;
    Modifier: TSpeedButton;
    Find: TSpeedButton;
    edFilter: TEdit;
    procedure spExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edFilterChange(Sender: TObject);
    procedure AjouterClick(Sender: TObject);
    procedure SupprimerClick(Sender: TObject);
    procedure ModifierClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FDQFillDbGrid: TFDQuery;
    DsFillDbGrid: TDataSource;
    procedure FillDBGrid(const SQLFilter: string = '');
  end;

var
  FmCategories: TFmCategories;

implementation

{$R *.dfm}

uses DmData, UnCategories_OP;

procedure TFmCategories.AjouterClick(Sender: TObject);
begin
DataM.Operation := 'Ajouter';
fmCategories_op.showmodal;
end;

procedure TFmCategories.edFilterChange(Sender: TObject);
begin
 // عند تغيير محتوى مربع النص الخاص بالبحث، يتم تحديث شبكة البيانات وفقًا لمرشح البحث
  FillDBGrid(' WHERE NomCategorie LIKE :NomCategorie');
end;

procedure TFmCategories.FormShow(Sender: TObject);
begin
FillDBGrid;
end;

procedure TFmCategories.ModifierClick(Sender: TObject);
begin
DataM.Operation := 'Modifier';
fmCategories_op.showmodal;
end;

procedure TfmCategories.FillDBGrid(const SQLFilter: string = '');
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
    'Select * From TCategories' + SQLFilter;

    // إذا تم توفير مرشح، يتم تعيين المعلمات
    if not SQLFilter.IsEmpty then
    begin
      FDQFillDbGrid.ParamByName('NomCategorie').AsString := '%' + edFilter.Text + '%';
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


procedure TFmCategories.spExitClick(Sender: TObject);
begin
Close;
end;

procedure TFmCategories.SupprimerClick(Sender: TObject);
var
  Confirmation: Integer;
  FDQueryDelete: TFDQuery;
begin
  // التحقق من وجود بيانات في الشبكة ومعرف الطبيب غير فارغ
  if Assigned(FDQFillDbGrid) and (FDQFillDbGrid.FieldByName('CategorieID') <> nil) and
    not fmCategories.FDQFillDbGrid.FieldByName('CategorieID').IsNull then
  begin
    // حفظ معرف السجل قبل الحذف
    DataM.RecordID := FDQFillDbGrid.FieldByName('CategorieID').AsInteger;
    // طلب تأكيد قبل الحذف
    Confirmation := MessageDlg('Êtes-vous sûr de vouloir supprimer cet enregistrement ?', mtConfirmation, [mbYes, mbNo], 0);
    if Confirmation = mrYes then
    begin
      // إنشاء استعلام للحذف
      FDQueryDelete := TFDQuery.Create(nil);
      try
        FDQueryDelete.Connection := DataM.FDConnection; // على افتراض أن DataM هو وحدة البيانات الخاصة بك
        FDQueryDelete.SQL.Text := 'DELETE FROM TCategories WHERE CategorieID = :CategorieID';
        FDQueryDelete.ParamByName('CategorieID').AsInteger := DataM.RecordID;
        FDQueryDelete.ExecSQL;
        // عرض رسالة بعد الحذف بنجاح
        ShowMessage('Enregistrement supprimé avec succès.');
        // تحديث الشبكة أو تنفيذ أي إجراءات ضرورية أخرى
        FillDBGrid;
      finally
        FDQueryDelete.Free;
      end;
    end;
  end;
end;
end.
