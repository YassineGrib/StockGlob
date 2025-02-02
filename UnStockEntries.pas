﻿unit UnStockEntries;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFmStockEntries = class(TForm)
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
    procedure FormShow(Sender: TObject);
    procedure spExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FDQFillDbGrid: TFDQuery;
    DsFillDbGrid: TDataSource;
    procedure FillDBGrid(const SQLFilter: string = '');
  end;

var
  FmStockEntries: TFmStockEntries;

implementation

{$R *.dfm}

uses DmData;


procedure TfmStockEntries.FillDBGrid(const SQLFilter: string = '');
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
'SELECT                                                                       '+
'    e.BonDentreeID,                                                          '+
'    e.DateEntree,                                                            '+
'    f.NomFournisseur AS FournisseurName,                                     '+
'    COUNT(e.ProduitID) AS ProduitCount,                                      '+
'    SUM(e.PrixAchat * e.Quantite) AS TotalPrixAchat                          '+
'FROM                                                                         '+
'    TStockEntries e                                                          '+
'JOIN                                                                         '+
'    TFournisseurs f ON e.FournisseurID = f.FournisseurID                     '+
'GROUP BY                                                                     '+
'    e.BonDentreeID,                                                          '+
'    e.DateEntree,                                                            '+
'    f.NomFournisseur                                                         '+
'ORDER BY                                                                     '+
'    e.BonDentreeID;                                                          '+  SQLFilter;

    // إذا تم توفير مرشح، يتم تعيين المعلمات
    if not SQLFilter.IsEmpty then
    begin
      FDQFillDbGrid.ParamByName('NomFournisseur').AsString := '%' + edFilter.Text + '%';
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



procedure TFmStockEntries.FormShow(Sender: TObject);
begin
  FillDBGrid;
end;

procedure TFmStockEntries.spExitClick(Sender: TObject);
begin
Close;
end;

end.
