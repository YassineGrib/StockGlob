-- Création de la base de données
CREATE DATABASE GestionStock;
GO

-- Utilisation de la base de données
USE GestionStock;
GO



-- Trigger 
-- Trigger clients
CREATE TRIGGER trgAprèsInsertionTClients
ON TClients
AFTER INSERT
AS
BEGIN
    INSERT INTO TJournalDeModifications (NomTable, TypeOperation, IDEnregistrement, UtilisateurID, DateHeureModification, NouvelleValeur)
    SELECT 
        'TClients', 
        'INSÉRER', 
        INSERTED.ClientID, 
        INSERTED.UtilisateurID, 
        GETDATE(), 
        CONCAT('NomClient: ', INSERTED.NomClient, ', Adresse: ', INSERTED.Adresse, ', NumTelephone: ', INSERTED.NumTelephone, ', Email: ', INSERTED.Email, ', Statut: ', INSERTED.Statut)
    FROM INSERTED
END;
CREATE TRIGGER trgAprèsMiseÀJourTClients
ON TClients
AFTER UPDATE
AS
BEGIN
    DECLARE @AncienneValeur NVARCHAR(MAX);
    DECLARE @NouvelleValeur NVARCHAR(MAX);

    -- Obtenez les valeurs anciennes et nouvelles
    SELECT @AncienneValeur = CONCAT('NomClient: ', DELETED.NomClient, ', Adresse: ', DELETED.Adresse, ', NumTelephone: ', DELETED.NumTelephone, ', Email: ', DELETED.Email, ', Statut: ', DELETED.Statut)
    FROM DELETED;

    SELECT @NouvelleValeur = CONCAT('NomClient: ', INSERTED.NomClient, ', Adresse: ', INSERTED.Adresse, ', NumTelephone: ', INSERTED.NumTelephone, ', Email: ', INSERTED.Email, ', Statut: ', INSERTED.Statut)
    FROM INSERTED;

    -- Insérez l'enregistrement dans le journal des modifications
    INSERT INTO TJournalDeModifications (NomTable, TypeOperation, IDEnregistrement, UtilisateurID, DateHeureModification, AncienneValeur, NouvelleValeur)
    SELECT 
        'TClients', 
        'MISE À JOUR', 
        INSERTED.ClientID, 
        INSERTED.UtilisateurID, 
        GETDATE(), 
        @AncienneValeur, 
        @NouvelleValeur
    FROM INSERTED
    INNER JOIN DELETED ON INSERTED.ClientID = DELETED.ClientID
END;
CREATE TRIGGER trgAprèsSuppressionTClients
ON TClients
AFTER DELETE
AS
BEGIN
    INSERT INTO TJournalDeModifications (NomTable, TypeOperation, IDEnregistrement, UtilisateurID, DateHeureModification, AncienneValeur)
    SELECT 
        'TClients', 
        'SUPPRIMER', 
        DELETED.ClientID, 
        DELETED.UtilisateurID, 
        GETDATE(), 
        CONCAT('NomClient: ', DELETED.NomClient, ', Adresse: ', DELETED.Adresse, ', NumTelephone: ', DELETED.NumTelephone, ', Email: ', DELETED.Email, ', Statut: ', DELETED.Statut)
    FROM DELETED
END;




-- Création de la table des utilisateurs
CREATE TABLE TUtilisateurs (
    UtilisateurID INT IDENTITY(1,1) PRIMARY KEY,
    NomUtilisateur NVARCHAR(50) NOT NULL,
    MotDePasse NVARCHAR(50) NOT NULL,
    Email NVARCHAR(50),
    Statut NVARCHAR(20)
);
GO

-- Création de la table des permissions
CREATE TABLE TPermissions (
    PermissionID INT IDENTITY(1,1) PRIMARY KEY,
    UtilisateurID INT,
    PeutAjouter BIT,
    PeutModifier BIT,
    PeutSupprimer BIT,
    PeutVendre BIT,
    EstAdmin BIT,
    FOREIGN KEY (UtilisateurID) REFERENCES TUtilisateurs(UtilisateurID)
);
GO

-- Création de la table des clients
CREATE TABLE TClients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    NomClient NVARCHAR(100) NOT NULL,
    Adresse NVARCHAR(255),
    NumTelephone NVARCHAR(20),
    Email NVARCHAR(50),
    Statut NVARCHAR(20),
    UtilisateurID INT,
    FOREIGN KEY (UtilisateurID) REFERENCES TUtilisateurs(UtilisateurID)
);
GO

-- Création de la table des fournisseurs
CREATE TABLE TFournisseurs (
    FournisseurID INT IDENTITY(1,1) PRIMARY KEY,
    NomFournisseur NVARCHAR(100) NOT NULL,
    Adresse NVARCHAR(255),
    NumTelephone NVARCHAR(20),
    Email NVARCHAR(50),
    Statut NVARCHAR(20),
    UtilisateurID INT,
    FOREIGN KEY (UtilisateurID) REFERENCES TUtilisateurs(UtilisateurID)
);
GO

-- Création de la table des catégories
CREATE TABLE TCategories (
    CategorieID INT IDENTITY(1,1) PRIMARY KEY,
    NomCategorie NVARCHAR(100) NOT NULL,
    UtilisateurID INT,
    FOREIGN KEY (UtilisateurID) REFERENCES TUtilisateurs(UtilisateurID)
);
GO

-- Création de la table des marques
CREATE TABLE TMarques (
    MarqueID INT IDENTITY(1,1) PRIMARY KEY,
    NomMarque NVARCHAR(100) NOT NULL,
    UtilisateurID INT,
    FOREIGN KEY (UtilisateurID) REFERENCES TUtilisateurs(UtilisateurID)
);
GO

-- Création de la table des produits
CREATE TABLE TProduits (
    ProduitID INT IDENTITY(1,1) PRIMARY KEY,
    CategorieID INT,
    MarqueID INT,
    NomProduit NVARCHAR(100) NOT NULL,
    QuantiteMin INT,
    UtilisateurID INT,
    FOREIGN KEY (CategorieID) REFERENCES TCategories(CategorieID),
    FOREIGN KEY (MarqueID) REFERENCES TMarques(MarqueID),
    FOREIGN KEY (UtilisateurID) REFERENCES TUtilisateurs(UtilisateurID)
);
GO
CREATE TABLE TJournalDeModifications (
    JournaleID INT IDENTITY(1,1) PRIMARY KEY,
    NomTable NVARCHAR(100),
    TypeOperation NVARCHAR(10),
    IDEnregistrement INT,
    UtilisateurID INT,
    DateHeureModification DATETIME,
    AncienneValeur NVARCHAR(MAX),
    NouvelleValeur NVARCHAR(MAX),
    FOREIGN KEY (UtilisateurID) REFERENCES TUtilisateurs(UtilisateurID)
);
