﻿unit UnMarques;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFMmarques = class(TForm)
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
  FMmarques: TFMmarques;

implementation

{$R *.dfm}

uses DmData, UnMarques_OP;

procedure TFMmarques.AjouterClick(Sender: TObject);
begin
DataM.Operation := 'Ajouter';
fmMarques_op.showmodal;
end;

procedure TFMmarques.edFilterChange(Sender: TObject);
begin
 // عند تغيير محتوى مربع النص الخاص بالبحث، يتم تحديث شبكة البيانات وفقًا لمرشح البحث
  FillDBGrid(' WHERE NomMarque LIKE :NomMarque');
end;

procedure TfmMarques.FillDBGrid(const SQLFilter: string = '');
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
    'Select * From TMarques' + SQLFilter;

    // إذا تم توفير مرشح، يتم تعيين المعلمات
    if not SQLFilter.IsEmpty then
    begin
      FDQFillDbGrid.ParamByName('NomMarque').AsString := '%' + edFilter.Text + '%';
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


procedure TFMmarques.FormShow(Sender: TObject);
begin
FillDBGrid;
end;

procedure TFMmarques.ModifierClick(Sender: TObject);
begin
DataM.Operation := 'Modifier';
fmMarques_op.showmodal;
end;

procedure TFMmarques.spExitClick(Sender: TObject);
begin
Close;
end;

end.
