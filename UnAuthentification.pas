unit UnAuthentification;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmAuthentification = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    Image1: TImage;
    cbutilisateur: TComboBox;
    edPassword: TEdit;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    procedure spExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FillcbUtilisateur;
    procedure SpeedButton1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAuthentification: TfmAuthentification;

implementation

{$R *.dfm}

uses DmData, unHome;

procedure TfmAuthentification.FormShow(Sender: TObject);
begin
// تعبئة قائمة المستخدمين عند عرض النموذج
FillcbUtilisateur;
cbutilisateur.ItemIndex := 0;
end;

procedure TfmAuthentification.Label5Click(Sender: TObject);
begin
// رسالة تفيد بأنه يجب الاتصال بمدير قاعدة البيانات
showmessage('Veuillez contacter votre administrateur de base de données !');
end;


procedure TfmAuthentification.SpeedButton1Click(Sender: TObject);
var
  qr_Authontification: TFDQuery;
begin
  // إنشاء استعلام جديد للتحقق من بيانات المستخدم
  qr_Authontification := TFDQuery.Create(Self);
  try
    // تعيين اتصال قاعدة البيانات للاستعلام
    qr_Authontification.Connection := DataM.FDConnection;
    // إعداد نص الاستعلام للتحقق من اسم المستخدم وكلمة المرور
    qr_Authontification.SQL.Text :=
      'SELECT * FROM Tutilisateurs WHERE NomUtilisateur=:NomUtilisateur AND MotDePasse=:MotDePasse';

    // إضافة بعض التحقق للمكونات المدخلة
    if (cbUtilisateur.Text <> '') and (edPassword.Text <> '') then
    begin
      // تعيين القيم للمعلمات في الاستعلام
      qr_Authontification.ParamByName('NomUtilisateur').AsString := cbUtilisateur.Text;
      qr_Authontification.ParamByName('MotDePasse').AsString := edPassword.Text;

      // تنفيذ الاستعلام
      qr_Authontification.Open;

      // التحقق مما إذا كان الاستعلام قد أرجع نتائج
      if not qr_Authontification.IsEmpty then
      begin
        // التحقق من حالة المستخدم
        if qr_Authontification.FieldByName('Statut').AsString = 'Actif' then
        begin
          DataM.Identification := True;

          // تعيين بيانات المستخدم في الوحدة العامة
          DataM.UtilisateurID := qr_Authontification.FieldByName('UtilisateurID').AsInteger;

          // إغلاق النموذج الحالي بعد التحقق الناجح
          FmHome.Label1.Caption := 'Bienvenue, ' + qr_Authontification.FieldByName('NomUtilisateur').AsString;
          Close;
        end
        else
        begin
          // عرض رسالة خطأ إذا كان المستخدم غير مفعل
          ShowMessage('Votre compte est désactivé. Veuillez contacter l''administrateur.');
        end;
      end
      else
      begin
        // عرض رسالة خطأ في حالة فشل التحقق
        ShowMessage('Échec d''authentification. Veuillez vérifier vos identifiants.');
      end;
    end
    else
    begin
      // معالجة الحالة التي تكون فيها خانة اسم المستخدم أو كلمة المرور فارغة
      ShowMessage('Veuillez entrer votre nom d''utilisateur et votre mot de passe.');
    end;
  finally
    // تحرير الاستعلام بعد الانتهاء
    qr_Authontification.Free;
  end;
end;



procedure TfmAuthentification.spExitClick(Sender: TObject);
begin
close;
end;



procedure TfmAuthentification.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked = True then
  edpassword.PasswordChar := #0
  else
  edpassword.PasswordChar := '*'

end;

procedure TfmAuthentification.FillcbUtilisateur;
var
  qrFill_cbUtilisateur: TFDQuery;
begin
  // إنشاء استعلام جديد لملء قائمة المستخدمين
  qrFill_cbUtilisateur := TFDQuery.Create(Self);
  try
    // تعيين اتصال قاعدة البيانات للاستعلام
    qrFill_cbUtilisateur.Connection := DataM.FDConnection;
    // إعداد نص الاستعلام لجلب أسماء المستخدمين
    qrFill_cbUtilisateur.SQL.Text := 'SELECT NomUtilisateur FROM TUtilisateurs';
    // تنفيذ الاستعلام
    qrFill_cbUtilisateur.Open;
    // مسح العناصر الحالية في قائمة المستخدمين
    cbUtilisateur.Items.Clear;
    // إضافة أسماء المستخدمين إلى قائمة العناصر
    while not qrFill_cbUtilisateur.Eof do
    begin
      cbUtilisateur.Items.Add(qrFill_cbUtilisateur.FieldByName('NomUtilisateur').AsString);
      qrFill_cbUtilisateur.Next;
    end;
  finally
    // تحرير الاستعلام بعد الانتهاء
    qrFill_cbUtilisateur.Free;
  end;
end;





end.
