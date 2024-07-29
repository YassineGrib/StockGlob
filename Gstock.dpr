program Gstock;

uses
  Vcl.Forms,
  unHome in 'unHome.pas' {fmHome},
  DmData in 'DmData.pas' {DataM: TDataModule},
  UnAuthentification in 'UnAuthentification.pas' {fmAuthentification},
  UnClients in 'UnClients.pas' {fmClients},
  UnFournisseurs in 'UnFournisseurs.pas' {fmFournisseurs},
  UnProduits in 'UnProduits.pas' {FmProduits},
  UnCategories in 'UnCategories.pas' {FmCategories},
  UnMarques in 'UnMarques.pas' {FMmarques},
  UnClients_OP in 'UnClients_OP.pas' {fmClients_OP},
  UnJournale in 'UnJournale.pas' {FmJournale},
  UnUtilisateurs in 'UnUtilisateurs.pas' {FmUtilisateurs},
  UnUtilisateurs_OP in 'UnUtilisateurs_OP.pas' {fmUtilisateurs_OP},
  UnCategories_OP in 'UnCategories_OP.pas' {FmCategories_OP},
  UnDB in 'UnDB.pas' {fmDB},
  UnMarques_OP in 'UnMarques_OP.pas' {FmMarques_OP},
  UnFournisseurs_OP in 'UnFournisseurs_OP.pas' {fmFournisseurs_OP},
  UnProduits_OP in 'UnProduits_OP.pas' {fmProduits_OP},
  UnStockEntries in 'UnStockEntries.pas' {FmStockEntries},
  UnStockEntries_OP in 'UnStockEntries_OP.pas' {FmStockEntries_OP};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFmStockEntries_OP, FmStockEntries_OP);
  Application.CreateForm(TFmStockEntries, FmStockEntries);
  Application.CreateForm(TfmHome, fmHome);
  Application.CreateForm(TFmCategories, FmCategories);
  Application.CreateForm(TFmJournale, FmJournale);
  Application.CreateForm(TFmCategories_OP, FmCategories_OP);
  Application.CreateForm(TfmDB, fmDB);
  Application.CreateForm(TfmClients_OP, fmClients_OP);
  Application.CreateForm(TfmUtilisateurs_OP, fmUtilisateurs_OP);
  Application.CreateForm(TFmUtilisateurs, FmUtilisateurs);
  Application.CreateForm(TfmAuthentification, fmAuthentification);
  Application.CreateForm(TFmProduits, FmProduits);
  Application.CreateForm(TFMmarques, FMmarques);
  Application.CreateForm(TfmFournisseurs, fmFournisseurs);
  Application.CreateForm(TfmClients, fmClients);
  Application.CreateForm(TDataM, DataM);
  Application.CreateForm(TFmMarques_OP, FmMarques_OP);
  Application.CreateForm(TfmFournisseurs_OP, fmFournisseurs_OP);
  Application.CreateForm(TfmProduits_OP, fmProduits_OP);
  Application.Run;
end.
