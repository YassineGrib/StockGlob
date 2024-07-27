unit UnCategories_OP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TFmCategories_OP = class(TForm)
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    ToolsPanel: TPanel;
    Valider: TSpeedButton;
    Initialiser: TSpeedButton;
    CategorieID: TEdit;
    NomCategorie: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmCategories_OP: TFmCategories_OP;

implementation

{$R *.dfm}

procedure TFmCategories_OP.FormShow(Sender: TObject);
begin
 if DataM.Operation = 'Ajouter' then
  begin
   UtilisateurID.Text := Format('CAT%04d', [GetMaxID]);
  end;
end;

end.
