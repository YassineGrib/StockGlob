﻿unit UnJournale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFmJournale = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    logoPanel: TPanel;
    Image1: TImage;
    Label3: TLabel;
    dbgrid: TDBGrid;
    ToolsPanel: TPanel;
    Find: TSpeedButton;
    Exporter: TSpeedButton;
    edFilter: TEdit;
    procedure spExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FillDBGrid(const SQLFilter: string = '');
    procedure ExporterClick(Sender: TObject);
    procedure edFilterChange(Sender: TObject);
  private
    { Private declarations }
    FDQFillDbGrid: TFDQuery;
    DsFillDbGrid: TDataSource;
  public
    { Public declarations }
  end;

var
  FmJournale: TFmJournale;

implementation

{$R *.dfm}

uses DmData;

procedure TFmJournale.FormShow(Sender: TObject);
begin
  // عند عرض نموذج الموظف، يتم ملء شبكة البيانات
  FillDBGrid;
end;

procedure TFmJournale.edFilterChange(Sender: TObject);
begin
  FillDBGrid(' WHERE NomTable LIKE :NomTable OR TypeOperation LIKE :TypeOperation');
end;

procedure TFmJournale.ExporterClick(Sender: TObject);

const
  Title = 'Journal De Modifications'; // يمكنك تغيير العنوان بما يناسبك
begin
if fmJournale.FDQFillDbGrid.IsEmpty
then begin
          ShowMessage('Impossible d''exporter à partir d''une liste vide !');
          Exit;
     end;

DataM.ExportToExcel(DBGrid, Title);
end;

procedure TfmJournale.FillDBGrid(const SQLFilter: string = '');
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
   // 'SELECT JournaleID, NomTable, TypeOperation, IDEnregistrement, UtilisateurID, DateHeureModification, AncienneValeur, NouvelleValeur FROM TJournalDeModifications ' + SQLFilter;

      'SELECT J.JournaleID, J.NomTable, J.TypeOperation, ' +
      'CASE WHEN J.NomTable = ''TClients'' THEN C.NomClient ELSE CAST(J.IDEnregistrement AS NVARCHAR) END AS RecordName, ' +
      'U.NomUtilisateur AS UserName, J.DateHeureModification, ' +
      'SUBSTRING(J.AncienneValeur, 1, 50) + ''...'' AS AncienneValeur, ' +
      'SUBSTRING(J.NouvelleValeur, 1, 50) + ''...'' AS NouvelleValeur ' +
      'FROM TJournalDeModifications J ' +
      'LEFT JOIN TUtilisateurs U ON J.UtilisateurID = U.UtilisateurID ' +
      'LEFT JOIN TClients C ON J.IDEnregistrement = C.ClientID AND J.NomTable = ''TClients'' '
       + SQLFilter;


    // إذا تم توفير مرشح، يتم تعيين المعلمات
    if not SQLFilter.IsEmpty then
    begin
      FDQFillDbGrid.ParamByName('TypeOperation').AsString := '%' + edFilter.Text + '%';
      FDQFillDbGrid.ParamByName('NomTable').AsString := '%' + edFilter.Text + '%';
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


procedure TFmJournale.spExitClick(Sender: TObject);
begin
Close;
end;

end.
