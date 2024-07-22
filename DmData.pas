unit DmData;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client;

type
  TDataM = class(TDataModule)
    ilNavigation: TImageList;
    iLNavigation_48: TImageList;
    iLNavigation_100: TImageList;
    iLNavigation_84: TImageList;
    iLNavigation_64: TImageList;
    FDConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FCanAdd: Boolean;
    FCanEdit: Boolean;
    FCanDelete: Boolean;
  public
    { Public declarations }
    OP    : string;
    Utilisateur : integer;
    Identification : boolean;
    UtilisateurID  : integer;

    procedure LoadUserPermissions(UserID: Integer);
    property CanAdd: Boolean read FCanAdd;
    property CanEdit: Boolean read FCanEdit;
    property CanDelete: Boolean read FCanDelete;

  end;

var
  DataM: TDataM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataM.DataModuleCreate(Sender: TObject);
begin
OP := 'OP';
Utilisateur := 1 ;
end;


procedure TDataM.LoadUserPermissions(UserID: Integer);
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection;
    FDQuery.SQL.Text := 'SELECT PeutAjouter, PeutModifier, PeutSupprimer FROM TPermissions WHERE UtilisateurID = :UtilisateurID';
    FDQuery.ParamByName('UtilisateurID').AsInteger := UserID;
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      FCanAdd := FDQuery.FieldByName('PeutAjouter').AsBoolean;
      FCanEdit := FDQuery.FieldByName('PeutModifier').AsBoolean;
      FCanDelete := FDQuery.FieldByName('PeutSupprimer').AsBoolean;
    end
    else
    begin
      FCanAdd := False;
      FCanEdit := False;
      FCanDelete := False;
    end;
  finally
    FDQuery.Free;
  end;
end;
end.
