program Gstock;

uses
  Vcl.Forms,
  unHome in 'unHome.pas' {fmHome},
  DmData in 'DmData.pas' {DataM: TDataModule},
  UnAuthentification in 'UnAuthentification.pas' {fmAuthentification},
  UnClients in 'UnClients.pas' {fmClients},
  UnSuppliers in 'UnSuppliers.pas' {fmSuppliers},
  UnProduits in 'UnProduits.pas' {FmProduits},
  UnCategories in 'UnCategories.pas' {FmCategories},
  UnMarques in 'UnMarques.pas' {FMmarques},
  UnClients_OP in 'UnClients_OP.pas' {fmClients_OP},
  UnJournale in 'UnJournale.pas' {FmJournale},
  UnUtilisateurs in 'UnUtilisateurs.pas' {FmUtilisateurs},
  UnUtilisateurs_OP in 'UnUtilisateurs_OP.pas' {fmUtilisateurs_OP},
  UnCategories_OP in 'UnCategories_OP.pas' {FmCategories_OP},
  UnDB in 'UnDB.pas' {fmDB};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmHome, fmHome);
  Application.CreateForm(TFmCategories_OP, FmCategories_OP);
  Application.CreateForm(TfmClients_OP, fmClients_OP);
  Application.CreateForm(TfmUtilisateurs_OP, fmUtilisateurs_OP);
  Application.CreateForm(TFmUtilisateurs, FmUtilisateurs);
  Application.CreateForm(TFmJournale, FmJournale);
  Application.CreateForm(TfmAuthentification, fmAuthentification);
  Application.CreateForm(TFmProduits, FmProduits);
  Application.CreateForm(TFMmarques, FMmarques);
  Application.CreateForm(TFmCategories, FmCategories);
  Application.CreateForm(TfmSuppliers, fmSuppliers);
  Application.CreateForm(TfmClients, fmClients);
  Application.CreateForm(TDataM, DataM);
  Application.CreateForm(TfmDB, fmDB);
  Application.Run;
end.