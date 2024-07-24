unit UnUtilisateurs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFmUtilisateurs = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    logoPanel: TPanel;
    Image1: TImage;
    Label3: TLabel;
    dbgrid: TDBGrid;
    ToolsPanel: TPanel;
    Desactiver: TSpeedButton;
    Consulter: TSpeedButton;
    Ajouter: TSpeedButton;
    Modifier: TSpeedButton;
    Find: TSpeedButton;
    edFilter: TEdit;
    procedure spExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edFilterChange(Sender: TObject);
    procedure DesactiverClick(Sender: TObject);
    procedure AjouterClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    FDQFillDbGrid: TFDQuery;
    DsFillDbGrid: TDataSource;
    procedure FillDBGrid(const SQLFilter: string = '');
  end;

var
  FmUtilisateurs: TFmUtilisateurs;

implementation

{$R *.dfm}

uses DmData, UnUtilisateurs_OP;

procedure TFmUtilisateurs.AjouterClick(Sender: TObject);
begin
fmUtilisateurs_OP.showmodal;
end;

procedure TFmUtilisateurs.edFilterChange(Sender: TObject);
begin
 // عند تغيير محتوى مربع النص الخاص بالبحث، يتم تحديث شبكة البيانات وفقًا لمرشح البحث
  FillDBGrid(' WHERE NomUtilisateur LIKE :NomUtilisateur ');
end;

procedure TfmUtilisateurs.FillDBGrid(const SQLFilter: string = '');
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
      'SELECT                                            '+
'    U.UtilisateurID,                                    '+
'    U.NomUtilisateur,                                   '+
'    U.MotDePasse,                                       '+
'    U.Email,                                            '+
'    U.Statut,                                           '+
'    P.PeutAjouter,                                      '+
'    P.PeutModifier,                                     '+
'    P.PeutSupprimer,                                    '+
'    P.PeutVendre,                                       '+
'    CASE                                                '+
'        WHEN P.EstAdmin = 1 THEN ''Admin''              '+
'        ELSE ''Utilisateur''                            '+
'    END AS Type                                         '+
'FROM                                                    '+
'    TUtilisateurs U                                     '+
'LEFT JOIN                                               '+
'    TPermissions P ON U.UtilisateurID = P.UtilisateurID ' + SQLFilter;

    // إذا تم توفير مرشح، يتم تعيين المعلمات
    if not SQLFilter.IsEmpty then
    begin
      FDQFillDbGrid.ParamByName('NomUtilisateur').AsString := '%' + edFilter.Text + '%';
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

procedure TFmUtilisateurs.FormShow(Sender: TObject);
begin
  FillDBGrid;
end;

procedure TFmUtilisateurs.spExitClick(Sender: TObject);
begin
Close;
end;

procedure TFmUtilisateurs.DesactiverClick(Sender: TObject);
var
  Confirmation: Integer;
  FDQueryUpdate: TFDQuery;
begin
  // التحقق من وجود بيانات في الشبكة ومعرف غير فارغ
  if Assigned(FDQFillDbGrid) and (FDQFillDbGrid.FieldByName('UtilisateurID') <> nil) and
    not fmUtilisateurs.FDQFillDbGrid.FieldByName('UtilisateurID').IsNull then
  begin
    // حفظ معرف السجل قبل التحديث
    DataM.RecordID := FDQFillDbGrid.FieldByName('UtilisateurID').AsInteger;

    if DataM.RecordID = DataM.UtilisateurID then
    begin
      ShowMessage('You can''t deactivate yourself!');
      Exit;
    end;

    // طلب تأكيد قبل التحديث
    Confirmation := MessageDlg('Êtes-vous sûr de vouloir désactiver cet enregistrement ?', mtConfirmation, [mbYes, mbNo], 0);
    if Confirmation = mrYes then
    begin
      // إنشاء استعلام للتحديث
      FDQueryUpdate := TFDQuery.Create(nil);
      try
        FDQueryUpdate.Connection := DataM.FDConnection; // على افتراض أن DataM هو وحدة البيانات الخاصة بك
        FDQueryUpdate.SQL.Text := 'UPDATE TUtilisateurs SET Statut = ''Inactif'' WHERE UtilisateurID = :UtilisateurID';
        FDQueryUpdate.ParamByName('UtilisateurID').AsInteger := DataM.RecordID;
        FDQueryUpdate.ExecSQL;
        // عرض رسالة بعد التحديث بنجاح
        ShowMessage('Enregistrement désactivé avec succès.');
        // تحديث الشبكة أو تنفيذ أي إجراءات ضرورية أخرى
        FillDBGrid;
      finally
        FDQueryUpdate.Free;
      end;
    end;
  end;
end;


end.
