unit unHome;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, ShellAPI, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfmHome = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    logoPanel: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton7: TSpeedButton;
    sbVente: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    sbUtilisateurs: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    ToolsPanel: TPanel;
    sbBDD: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    SbClient: TSpeedButton;
    procedure spExitClick(Sender: TObject);
    procedure SbClientClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ConnectIfNotIdentified;
    procedure SpeedButton4Click(Sender: TObject);
    procedure sbUtilisateursClick(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure CheckUserPermissions;
    procedure sbBDDClick(Sender: TObject);
   // procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  fmHome: TfmHome;

implementation

{$R *.dfm}

uses DmData, UnClients, UnSuppliers, UnProduits, UnAuthentification,
  UnCategories, UnClients_OP, UnJournale, UnMarques, UnUtilisateurs, UnDB;




procedure TfmHome.FormShow(Sender: TObject);
begin
ConnectIfNotIdentified ;
CheckUserPermissions;
end;

procedure TfmHome.sbBDDClick(Sender: TObject);
begin
fmDB.show;
end;

procedure Tfmhome.CheckUserPermissions;
begin
  // تحميل الصلاحيات من DataM إذا لم تكن قد تم تحميلها بالفعل
  if not DataM.CanAdd and not DataM.CanEdit and not DataM.CanDelete and not DataM.Cansell and not DataM.admin then
    DataM.LoadUserPermissions(DataM.UtilisateurID);

  // تحديث حالة الأزرار بناءً على الصلاحيات المخزنة
  sbUtilisateurs.Enabled := DataM.admin;
   sbvente.Enabled := DataM.Cansell;
   sbBDD.Enabled  := DataM.admin;
end;

procedure TfmHome.SbClientClick(Sender: TObject);
begin
fmClients.ShowModal;
end;

procedure TfmHome.sbUtilisateursClick(Sender: TObject);
begin
FmUtilisateurs.showmodal();
end;

procedure TfmHome.SpeedButton13Click(Sender: TObject);
begin
  // Use ShellExecute to open Notepad
  ShellExecute(0, 'open', 'notepad.exe', nil, nil, SW_SHOWNORMAL);
end;

procedure TfmHome.SpeedButton14Click(Sender: TObject);
begin
  // Use ShellExecute to open the Windows Calculator
  ShellExecute(0, 'open', 'calc.exe', nil, nil, SW_SHOWNORMAL);
end;

procedure TfmHome.SpeedButton2Click(Sender: TObject);
begin
FmProduits.ShowModal();
end;

procedure TfmHome.SpeedButton4Click(Sender: TObject);
begin
fmjournale.ShowModal();
end;

procedure TfmHome.SpeedButton5Click(Sender: TObject);
begin
FmSuppliers.ShowModal();
end;

procedure TfmHome.spExitClick(Sender: TObject);
begin
Close;
end;



procedure TfmHome.ConnectIfNotIdentified;
begin
  // التحقق من حالة التعريف، إذا لم يكن المستخدم معرفاً، يتم عرض نموذج المصادقة
  if not DataM.Identification then
  begin
    // إنشاء نموذج المصادقة
    fmAuthentification := tfmAuthentification.Create(Application);
    try
      // عرض نموذج المصادقة كنافذة حوارية
      fmAuthentification.ShowModal;

      // إذا لم يتم تعريف المستخدم بعد عرض نموذج المصادقة، يتم إنهاء التطبيق
      if not DataM.Identification then
        application.Terminate;
    finally
      // تحرير نموذج المصادقة بعد الانتهاء
      fmAuthentification.Free;
    end;
  end;
end;




end.
