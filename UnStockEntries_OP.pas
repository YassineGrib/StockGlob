unit UnStockEntries_OP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPickers, Vcl.ComCtrls,
  Vcl.NumberBox, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TFmStockEntries_OP = class(TForm)
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Marquelabel: TLabel;
    Label7: TLabel;
    TitelPanel: TPanel;
    spExit: TSpeedButton;
    spLogo: TSpeedButton;
    Titel: TLabel;
    ToolsPanel: TPanel;
    Valider: TSpeedButton;
    Initialiser: TSpeedButton;
    ProduitID: TEdit;
    NomProduit: TEdit;
    NomMarque: TComboBox;
    NomCategorie: TComboBox;
    QuantiteMin: TNumberBox;
    Label3: TLabel;
    NumberBox1: TNumberBox;
    DateTimePicker1: TDateTimePicker;
    Label4: TLabel;
    Label6: TLabel;
    NumberBox2: TNumberBox;
    dbgrid: TDBGrid;
    Panel1: TPanel;
    SpeedButton11: TSpeedButton;
    sbUtilisateurs: TSpeedButton;
    procedure spExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmStockEntries_OP: TFmStockEntries_OP;

implementation

{$R *.dfm}

procedure TFmStockEntries_OP.spExitClick(Sender: TObject);
begin
Close;
end;

end.
