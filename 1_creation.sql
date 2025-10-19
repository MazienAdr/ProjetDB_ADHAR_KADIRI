create schema salledesport;
use salledesport;

CREATE TABLE employe(
   ID_employe INT,
   employe_nom VARCHAR(50) NOT NULL,
   employe_poste VARCHAR(30) NOT NULL,
   employe_prenom VARCHAR(50) NOT NULL,
   PRIMARY KEY(ID_employe)
);

CREATE TABLE adherent(
   ID_adherent INT,
   ad_nom VARCHAR(50) NOT NULL,
   ad_prenom VARCHAR(50) NOT NULL,
   ad_Email VARCHAR(100) NOT NULL,
   ad_date_naissance DATE NOT NULL,
   ad_tel VARCHAR(20),
   ad_historique VARCHAR(255),
   ad_statut VARCHAR(20) NOT NULL,
   PRIMARY KEY(ID_adherent)
);

CREATE TABLE abonnement(
   ID_abo INT,
   abo_type VARCHAR(30) NOT NULL,
   abo_DateDeb DATE NOT NULL,
   abo_DateFin DATE NOT NULL,
   abo_Prix DECIMAL(5,2) NOT NULL,
   PRIMARY KEY(ID_abo)
);

CREATE TABLE seance_coaching(
   ID_seance INT,
   coaching_date DATETIME NOT NULL,
   ID_adherent INT,
   PRIMARY KEY(ID_seance),
   FOREIGN KEY(ID_adherent) REFERENCES adherent(ID_adherent)
);

CREATE TABLE cours_collectif(
   ID_cours INT,
   cours_date DATETIME NOT NULL,
   cours_capacite INT NOT NULL,
   PRIMARY KEY(ID_cours)
);

CREATE TABLE produits_boutique(
   ID_prod INT,
   prod_nom VARCHAR(100) NOT NULL,
   prod_prix DECIMAL(5,2) NOT NULL,
   prod_stock INT NOT NULL,
   prod_categorie VARCHAR(30) NOT NULL,
   PRIMARY KEY(ID_prod)
);

CREATE TABLE fournisseur(
   ID_fournisseur INT,
   fournisseur_nom VARCHAR(100) NOT NULL,
   fournisseur_contact VARCHAR(100),
   PRIMARY KEY(ID_fournisseur)
);

CREATE TABLE vente(
   ID_vente INT,
   vente_date DATETIME NOT NULL,
   vente_modepaiement VARCHAR(20) NOT NULL,
   vente_panier VARCHAR(20),
   vente_prix_total DECIMAL(8,2) NOT NULL,
   ID_employe INT NOT NULL,
   PRIMARY KEY(ID_vente),
   FOREIGN KEY(ID_employe) REFERENCES employe(ID_employe)
);

CREATE TABLE superviser(
   ID_employe INT,
   ID_employe_1 INT,
   ID_superviseur INT NOT NULL,
   PRIMARY KEY(ID_employe, ID_employe_1),
   FOREIGN KEY(ID_employe) REFERENCES employe(ID_employe),
   FOREIGN KEY(ID_employe_1) REFERENCES employe(ID_employe)
);

CREATE TABLE adherer(
   ID_adherent INT,
   ID_abo INT,
   PRIMARY KEY(ID_adherent, ID_abo),
   FOREIGN KEY(ID_adherent) REFERENCES adherent(ID_adherent),
   FOREIGN KEY(ID_abo) REFERENCES abonnement(ID_abo)
);

CREATE TABLE participer(
   ID_employe INT,
   ID_adherent INT,
   ID_cours INT,
   PRIMARY KEY(ID_employe, ID_adherent, ID_cours),
   FOREIGN KEY(ID_employe) REFERENCES employe(ID_employe),
   FOREIGN KEY(ID_adherent) REFERENCES adherent(ID_adherent),
   FOREIGN KEY(ID_cours) REFERENCES cours_collectif(ID_cours)
);

CREATE TABLE fournir(
   ID_prod INT,
   ID_fournisseur INT,
   PRIMARY KEY(ID_prod, ID_fournisseur),
   FOREIGN KEY(ID_prod) REFERENCES produits_boutique(ID_prod),
   FOREIGN KEY(ID_fournisseur) REFERENCES fournisseur(ID_fournisseur)
);

CREATE TABLE acheter(
   ID_adherent INT,
   ID_prod INT,
   PRIMARY KEY(ID_adherent, ID_prod),
   FOREIGN KEY(ID_adherent) REFERENCES adherent(ID_adherent),
   FOREIGN KEY(ID_prod) REFERENCES produits_boutique(ID_prod)
);

CREATE TABLE concerner(
   ID_prod INT,
   ID_vente INT,
   PRIMARY KEY(ID_prod, ID_vente),
   FOREIGN KEY(ID_prod) REFERENCES produits_boutique(ID_prod),
   FOREIGN KEY(ID_vente) REFERENCES vente(ID_vente)
);
