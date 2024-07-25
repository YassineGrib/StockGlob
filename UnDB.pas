unit UnDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmDB = class(TForm)
    OpenDialog: TFileOpenDialog;
    restore: TSpeedButton;
    FDQuery1: TFDQuery;
    procedure restoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure Restordb();
  end;

var
  fmDB: TfmDB;

implementation

{$R *.dfm}

uses DmData;


Procedure Tfmdb.Restordb();
var
  RestoreFileName: string;
  SQLQuery: TFDQuery;
begin
  if OpenDialog.Execute then
  begin
    RestoreFileName := OpenDialog.FileName;
    // تنفيذ عملية الاستعادة
    SQLQuery := TFDQuery.Create(nil);
    try
      SQLQuery.Connection := DataM.FDConnection;
      SQLQuery.SQL.Text :=
        'RESTORE DATABASE Stock FROM DISK = :FileName WITH REPLACE';
      SQLQuery.Params.ParamByName('FileName').AsString := RestoreFileName;
      SQLQuery.ExecSQL;
    finally
      SQLQuery.Free;
    end;

    ShowMessage('Database restored successfully.');
  end
  else
  begin
    ShowMessage('No backup file selected.');
  end;
end;


procedure TfmDB.restoreClick(Sender: TObject);
begin
Restordb
end;

end.
