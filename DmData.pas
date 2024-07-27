unit DmData;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.Forms, Vcl.ImgList, Vcl.Controls,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, ComObj, Winapi.Windows, Winapi.Messages,System.Variants,  Vcl.Graphics,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids ;
type
  TDataM = class(TDataModule)
    ilNavigation: TImageList;
    iLNavigation_48: TImageList;
    iLNavigation_100: TImageList;
    iLNavigation_84: TImageList;
    iLNavigation_64: TImageList;
    FDConnection: TFDConnection;

    procedure ExportToExcel(DBGrid: TDBGrid; const Title: string);
    procedure DataModuleCreate(Sender: TObject);


  private
    { Private declarations }
    FCanAdd: Boolean;
    FCanEdit: Boolean;
    FCanDelete: Boolean;
    FCanSell  : Boolean;
    FAdmin  : Boolean;

  public
    { Public declarations }

    Utilisateur : integer;
    Identification : boolean;
    UtilisateurID  : integer;
    RecordID : integer;
    Operation : String;

    procedure LoadUserPermissions(UserID: Integer);
    property CanAdd: Boolean read FCanAdd;
    property CanEdit: Boolean read FCanEdit;
    property CanDelete: Boolean read FCanDelete;
    property CanSell: Boolean read FCanSell;
    property Admin: Boolean read FAdmin;

  end;

var
  DataM: TDataM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UnDB;

{$R *.dfm}

procedure TDataM.LoadUserPermissions(UserID: Integer);
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection;
    FDQuery.SQL.Text := 'SELECT * FROM TPermissions WHERE UtilisateurID = :UtilisateurID';
    FDQuery.ParamByName('UtilisateurID').AsInteger := UserID;
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      FCanAdd := FDQuery.FieldByName('PeutAjouter').AsBoolean;
      FCanEdit := FDQuery.FieldByName('PeutModifier').AsBoolean;
      FCanDelete := FDQuery.FieldByName('PeutSupprimer').AsBoolean;
      FCanSell := FDQuery.FieldByName('PeutVendre').AsBoolean;
      FAdmin := FDQuery.FieldByName('EstAdmin').AsBoolean;

    end
    else
    begin
      FCanAdd := False;
      FCanEdit := False;
      FCanDelete := False;
      FCanSell  := False;
      FAdmin    := False;
    end;
  finally
    FDQuery.Free;
  end;
end;



procedure TDataM.DataModuleCreate(Sender: TObject);
var
  Query: TFDQuery;
  DatabaseExists: Boolean;
  BackupPath: string;
  DBname: string;
begin
  DBname := 'Stock';
  BackupPath := ExtractFilePath(ParamStr(0)) + 'Database\' + DBname + '.bak';
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDConnection;
    // التحقق من وجود قاعدة البيانات
    Query.SQL.Text := 'SELECT database_id FROM sys.databases WHERE name = :DBname';
    Query.ParamByName('DBname').AsString := DBname;
    Query.Open;
    DatabaseExists := not Query.FieldByName('database_id').IsNull;
    Query.Close;
    // إذا كانت قاعدة البيانات غير موجودة، يتم استعادتها
    if not DatabaseExists then
    begin
      FDConnection.ExecSQL('RESTORE DATABASE ' + DBname + ' FROM DISK = :BackupPath WITH REPLACE',
          [BackupPath]);
      ShowMessage('Database ' + DBname + ' has been restored from backup.');
      FDConnection.Params.Values['database'] := DBname;
    end
    else
    begin
      //ShowMessage('Database ' + DBname + ' already exists.');
      FDConnection.Params.Values['database'] := DBname;
    end;
  finally
    Query.Free;
  end;
end;

procedure TDataM.ExportToExcel(DBGrid: TDBGrid; const Title: string);
var
  ExcelApp: Variant;
  i, j: Integer;
  Sheet: Variant;
  LastRow: Integer;
  StartRow: Integer;
begin
  ExcelApp := CreateOleObject('Excel.Application');
  try
    ExcelApp.Visible := True;
    ExcelApp.Workbooks.Add;
    Sheet := ExcelApp.Workbooks[1].Sheets[1];

    // إضافة العنوان الكبير في المنتصف
    StartRow := 1;
    Sheet.Cells[StartRow, 1].Value := Title;
    Sheet.Cells[StartRow, 1].Font.Size := 24;
    Sheet.Cells[StartRow, 1].Font.Bold := True;
    Sheet.Cells[StartRow, 1].HorizontalAlignment := -4108; // xlCenter
    Sheet.Range[Sheet.Cells[StartRow, 1], Sheet.Cells[StartRow, DBGrid.Columns.Count]].Merge;

    // إضافة فراغ بين العنوان والجدول
    Inc(StartRow, 2);

    // إضافة العناوين مع التنسيق في الصف الثاني
    for i := 0 to DBGrid.Columns.Count - 1 do
    begin
      Sheet.Cells[StartRow, i + 1].Value := DBGrid.Columns[i].Title.Caption;
      Sheet.Cells[StartRow, i + 1].Font.Bold := True;
      Sheet.Cells[StartRow, i + 1].Interior.Color := $00C0C0C0; // لون خلفية رمادي
      Sheet.Cells[StartRow, i + 1].Borders.Weight := 2; // تعيين حدود
      Sheet.Cells[StartRow, i + 1].HorizontalAlignment := -4108; // xlCenter
      Sheet.Cells[StartRow, i + 1].VerticalAlignment := -4108; // xlCenter
    end;

    // إضافة البيانات بدءًا من الصف الثالث
    for i := 0 to DBGrid.DataSource.DataSet.RecordCount - 1 do
    begin
      DBGrid.DataSource.DataSet.RecNo := i + 1;
      for j := 0 to DBGrid.Columns.Count - 1 do
      begin
        Sheet.Cells[i + StartRow + 1, j + 1].Value := DBGrid.Fields[j].AsString;
        Sheet.Cells[i + StartRow + 1, j + 1].Borders.Weight := 2; // تعيين حدود
        Sheet.Cells[i + StartRow + 1, j + 1].HorizontalAlignment := -4108; // xlCenter
        Sheet.Cells[i + StartRow + 1, j + 1].VerticalAlignment := -4108; // xlCenter
      end;
    end;

    // ضبط عرض الأعمدة تلقائيًا
    Sheet.Columns.AutoFit;

    // إضافة حدود للجدول بالكامل
    LastRow := DBGrid.DataSource.DataSet.RecordCount + StartRow;
    Sheet.Range[Sheet.Cells[StartRow, 1], Sheet.Cells[LastRow, DBGrid.Columns.Count]].Borders.Weight := 2;

    // تعيين نمط الخط
    Sheet.Range[Sheet.Cells[1, 1], Sheet.Cells[LastRow, DBGrid.Columns.Count]].Font.Name := 'Arial';
    Sheet.Range[Sheet.Cells[1, 1], Sheet.Cells[LastRow, DBGrid.Columns.Count]].Font.Size := 10;

    // إضافة تاريخ الصدور في الصف الأخير
    Sheet.Cells[LastRow + 1, 1].Value := 'Date de sortie: ' + DateToStr(Date);
    Sheet.Cells[LastRow + 1, 1].Font.Italic := True;
    Sheet.Range[Sheet.Cells[LastRow + 1, 1], Sheet.Cells[LastRow + 1, DBGrid.Columns.Count]].Merge;

    // تنسيق تاريخ الصدور
    Sheet.Cells[LastRow + 1, 1].HorizontalAlignment := -4131; // xlLeft
    Sheet.Cells[LastRow + 1, 1].Font.Size := 12;
    Sheet.Cells[LastRow + 1, 1].Font.Color := $000000FF; // لون أزرق

    // إضافة خطوط بينية
    for i := StartRow + 1 to LastRow do
    begin
      for j := 1 to DBGrid.Columns.Count do
      begin
        Sheet.Cells[i, j].Borders.Item[9].LineStyle := 1; // xlEdgeBottom (9) and xlContinuous (1)
      end;
    end;

  finally
    ExcelApp := Unassigned;
  end;
end;




end.
