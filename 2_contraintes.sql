ALTER TABLE abonnement
ADD CONSTRAINT chk_abo_prix CHECK (abo_Prix > 0);


ALTER TABLE abonnement
ADD CONSTRAINT chk_abo_dates CHECK (abo_DateFin > abo_DateDeb);


ALTER TABLE produits_boutique
ADD CONSTRAINT chk_prod_prix CHECK (prod_prix >= 0);

ALTER TABLE produits_boutique
ADD CONSTRAINT chk_prod_stock CHECK (prod_stock >= 0);


ALTER TABLE adherent
ADD CONSTRAINT chk_tel_length CHECK (LENGTH(ad_tel) = 10);


ALTER TABLE adherent
ADD CONSTRAINT chk_email CHECK (ad_Email LIKE '%@%');


ALTER TABLE vente
ADD CONSTRAINT chk_vente_total CHECK (vente_prix_total >= 0);


ALTER TABLE cours_collectif
ADD CONSTRAINT chk_cours_capacite CHECK (cours_capacite > 0);


ALTER TABLE adherent
ADD CONSTRAINT chk_statut CHECK (ad_statut IN ('Actif', 'Inactif', 'Suspendu'));


ALTER TABLE vente
ADD CONSTRAINT chk_vente_modepaiement CHECK (
    vente_modepaiement IN ('Espèces', 'Carte', 'Virement', 'Chèque')
);

