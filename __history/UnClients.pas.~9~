unit UnClients;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Data.DB, Vcl.Grids, Vcl.DBGrids;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmClients: TfmClients;

implementation

{$R *.dfm}

uses DmData;

procedure TfmClients.spExitClick(Sender: TObject);
begin
Close;
end;

end.
