unit UnClients;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmClients = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    logoPanel: TPanel;
    Image1: TImage;
    ToolsPanel: TPanel;
    Supprimer: TSpeedButton;
    Consulter: TSpeedButton;
    Ajouter: TSpeedButton;
    Modifier: TSpeedButton;
    Find: TSpeedButton;
    Exporter: TSpeedButton;
    edFilter: TEdit;
    Label3: TLabel;
    dbgrid: TDBGrid;
    procedure spExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edFilterChange(Sender: TObject);
    procedure AjouterClick(Sender: TObject);
    procedure CheckUserPermissions;
    procedure ExporterClick(Sender: TObject);
    procedure SupprimerClick(Sender: TObject);
    procedure ConsulterClick(Sender: TObject);
    procedure ModifierClick(Sender: TObject);

  private
    { Private declarations }

  public
    FDQFillDbGrid: TFDQuery;
    DsFillDbGrid: TDataSource;
    { Public declarations }
    procedure FillDBGrid(const SQLFilter: string = '');


  end;

var
  fmClients: TfmClients;

implementation

{$R *.dfm}

uses DmData, UnClients_OP;

procedure TfmClients.FormShow(Sender: TObject);
begin
  // عند عرض نموذج الموظف، يتم ملء شبكة البيانات
  FillDBGrid;
  CheckUserPermissions;




end;

procedure TfmClients.ModifierClick(Sender: TObject);
begin
  DataM.Operation := 'Modifier';
  fmClients_OP := TfmClients_OP.Create(Self);
  fmClients_OP.ShowModal;
  fmClients_OP.free;
end;

procedure TfmClients.CheckUserPermissions;
begin
  // تحميل الصلاحيات من DataM إذا لم تكن قد تم تحميلها بالفعل
  if not DataM.CanAdd and not DataM.CanEdit and not DataM.CanDelete then
    DataM.LoadUserPermissions(DataM.UtilisateurID);

  // تحديث حالة الأزرار بناءً على الصلاحيات المخزنة
  Ajouter.Enabled := DataM.CanAdd;
  Modifier.Enabled := DataM.CanEdit;
  Supprimer.Enabled := DataM.CanDelete;
end;


procedure TfmClients.ConsulterClick(Sender: TObject);
begin
  DataM.Operation := 'Consulter';
  fmClients_OP := TfmClients_OP.Create(Self);
  fmClients_OP.ShowModal;
  fmClients_OP.free;

end;

procedure TfmClients.AjouterClick(Sender: TObject);
begin
DataM.Operation := 'Ajouter';
  fmClients_OP := TfmClients_OP.Create(Self);
  fmClients_OP.ShowModal;
  fmClients_OP.free;
end;

procedure TfmClients.edFilterChange(Sender: TObject);
begin
 // عند تغيير محتوى مربع النص الخاص بالبحث، يتم تحديث شبكة البيانات وفقًا لمرشح البحث
  FillDBGrid(' WHERE NomClient LIKE :NomClient OR NumTelephone LIKE :NumTelephone');
end;

procedure TfmClients.ExporterClick(Sender: TObject);
const
  Title = 'LISTE DES CLIENTS'; // يمكنك تغيير العنوان بما يناسبك
begin
if fmClients.FDQFillDbGrid.IsEmpty
then begin
          ShowMessage('Impossible d''exporter à partir d''une liste vide !');
          Exit;
     end;

DataM.ExportToExcel(DBGrid, Title);
end;

procedure TfmClients.FillDBGrid(const SQLFilter: string = '');
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
      'SELECT * FROM TClients ' + SQLFilter;

    // إذا تم توفير مرشح، يتم تعيين المعلمات
    if not SQLFilter.IsEmpty then
    begin
      FDQFillDbGrid.ParamByName('NomClient').AsString := '%' + edFilter.Text + '%';
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


procedure TfmClients.spExitClick(Sender: TObject);
begin
Close;
end;

procedure TfmClients.SupprimerClick(Sender: TObject);
var
  Confirmation: Integer;
  FDQueryDelete: TFDQuery;
begin
  // التحقق من وجود بيانات في الشبكة ومعرف الطبيب غير فارغ
  if Assigned(FDQFillDbGrid) and (FDQFillDbGrid.FieldByName('ClientID') <> nil) and
    not fmClients.FDQFillDbGrid.FieldByName('ClientID').IsNull then
  begin
    // حفظ معرف السجل قبل الحذف
    DataM.RecordID := FDQFillDbGrid.FieldByName('ClientID').AsString;
    // طلب تأكيد قبل الحذف
    Confirmation := MessageDlg('Êtes-vous sûr de vouloir supprimer cet enregistrement ?', mtConfirmation, [mbYes, mbNo], 0);
    if Confirmation = mrYes then
    begin
      // إنشاء استعلام للحذف
      FDQueryDelete := TFDQuery.Create(nil);
      try
        FDQueryDelete.Connection := DataM.FDConnection; // على افتراض أن DataM هو وحدة البيانات الخاصة بك
        FDQueryDelete.SQL.Text := 'DELETE FROM TClients WHERE ClientID = :ClientID';
        FDQueryDelete.ParamByName('ClientID').AsString := DataM.RecordID;
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
