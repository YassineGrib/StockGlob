﻿unit UnDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.FileCtrl;

type
  TfmDB = class(TForm)
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    logoPanel: TPanel;
    Image1: TImage;
    Label3: TLabel;
    ToolsPanel: TPanel;
    Backup: TSpeedButton;
    Restore: TSpeedButton;
    Supprimer: TSpeedButton;
    FileListBox: TFileListBox;
    procedure spExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SupprimerClick(Sender: TObject);
    procedure BackupClick(Sender: TObject);
    procedure RestoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  fmDB: TfmDB;

implementation

{$R *.dfm}

uses DmData;


procedure TfmDB.BackupClick(Sender: TObject);
var
  BackupPath, DBname, DateTimeStr, BackupDir: string;
begin
  // اسم قاعدة البيانات
  DBname := DataM.DBname    ;

  // الحصول على التاريخ والوقت الحاليين
  DateTimeStr := FormatDateTime('dd-mm-yyyy_hh-nn-ss', Now);

  // تكوين مسار النسخ الاحتياطي
  BackupDir := ExtractFilePath(ParamStr(0)) + 'Database\';
  BackupPath := BackupDir + DBname + '_' + DateTimeStr + '.bak';

  // إنشاء المجلد إذا لم يكن موجودًا
  if not DirectoryExists(BackupDir) then
    ForceDirectories(BackupDir);

  try
    // تنفيذ أمر النسخ الاحتياطي
    DataM.FDConnection.ExecSQL('BACKUP DATABASE ' + DBname + ' TO DISK = :BackupPath',
      [BackupPath]);
    ShowMessage('Database ' + DBname + ' has been backed up to ' + BackupPath);
          // تحديث القائمة بعد الاضافة
        FileListBox.Update;
  except
    on E: Exception do
      ShowMessage('Error creating backup: ' + E.Message);
  end;
end;


procedure TfmDB.FormShow(Sender: TObject);
var
 BackupPath : string;
begin
BackupPath := ExtractFilePath(ParamStr(0)) + 'Database\';
FileListBox.Directory :=    BackupPath ;
end;

procedure TfmDB.RestoreClick(Sender: TObject);
var
  SelectedFile: string;
  DBname: string;
begin

  // التحقق من تحديد ملف
  if FileListBox.ItemIndex <> -1 then
  begin
    // الحصول على الملف المحدد
    SelectedFile := FileListBox.FileName;

    // اسم قاعدة البيانات
    DBname := DataM.DBname;

    try
      // تنفيذ أمر الاستعادة
      DataM.FDConnection.ExecSQL('use Master RESTORE DATABASE ' + DBname + ' FROM DISK = :SelectedFile WITH REPLACE',
        [SelectedFile]);
      ShowMessage('Database ' + DBname + ' has been restored from ' + SelectedFile);
    except
      on E: Exception do
        ShowMessage('Error restoring database: ' + E.Message);
    end;
  end
  else
    ShowMessage('No file selected.');
end;

procedure TfmDB.spExitClick(Sender: TObject);
begin
Close;
end;

procedure TfmDB.SupprimerClick(Sender: TObject);
var
  SelectedFile: string;
begin
  // التحقق من تحديد ملف
  if FileListBox.ItemIndex <> -1 then
  begin
    // الحصول على الملف المحدد
    SelectedFile := FileListBox.FileName;

    // تأكيد الحذف من المستخدم
    if MessageDlg('Are you sure you want to delete ' + SelectedFile + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      // محاولة حذف الملف
      try
        DeleteFile(SelectedFile);
        // تحديث القائمة بعد الحذف
        FileListBox.Update;
      except
        on E: Exception do
          ShowMessage('Error deleting file: ' + E.Message);
      end;
    end;
  end
  else
    ShowMessage('No file selected.');
end;

end.
