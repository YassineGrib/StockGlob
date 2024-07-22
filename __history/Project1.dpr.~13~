program Project1;

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
  UnClients_OP in 'UnClients_OP.pas' {fmClients_OP};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmHome, fmHome);
  Application.CreateForm(TfmClients_OP, fmClients_OP);
  Application.CreateForm(TfmAuthentification, fmAuthentification);
  Application.CreateForm(TFmProduits, FmProduits);
  Application.CreateForm(TFMmarques, FMmarques);
  Application.CreateForm(TFmCategories, FmCategories);
  Application.CreateForm(TfmSuppliers, fmSuppliers);
  Application.CreateForm(TfmClients, fmClients);
  Application.CreateForm(TDataM, DataM);
  Application.Run;
end.
