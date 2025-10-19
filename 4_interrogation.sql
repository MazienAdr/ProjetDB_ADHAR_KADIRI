-- SCÉNARIO A — Responsable boutique --

-- Projections / Sélections 

-- 1) Produits triés par nom 
SELECT ID_prod, prod_nom, prod_categorie, prod_prix, prod_stock
FROM produits_boutique
ORDER BY prod_nom;

-- 2) Recherche produit: nom contenant “bouteille” 

SELECT ID_prod, prod_nom
FROM produits_boutique
WHERE prod_nom LIKE '%bouteille%'
ORDER BY prod_nom;

-- 3) Catégories ciblées via IN
SELECT ID_prod, prod_nom, prod_categorie
FROM produits_boutique
WHERE prod_categorie IN ('Accessoires','Textile','Nutrition')
ORDER BY prod_categorie, prod_nom;

-- Agrégations + GROUP BY/HAVING

-- 4) CA total et nombre de ventes
SELECT SUM(vente_prix_total) AS ca_total, COUNT(*) AS nb_ventes
FROM vente;

-- 5) CA par mode de paiement 
SELECT vente_modepaiement, SUM(vente_prix_total) AS ca, COUNT(*) AS nb_ventes
FROM vente
GROUP BY vente_modepaiement
ORDER BY ca DESC;

-- 6) Heures de vente
SELECT HOUR(vente_date) AS heure, COUNT(*) AS nb_ventes, SUM(vente_prix_total) AS ca
FROM vente
GROUP BY HOUR(vente_date)
ORDER BY ca DESC, heure ASC;

-- Jointures

-- 7) Détail de la dernière vente 
WITH last_sale AS (SELECT MAX(ID_vente) AS vid FROM vente)
SELECT v.ID_vente, v.vente_date, p.ID_prod, p.prod_nom
FROM last_sale ls
JOIN vente v ON v.ID_vente = ls.vid
JOIN concerner c ON c.ID_vente = v.ID_vente
JOIN produits_boutique p ON p.ID_prod = c.ID_prod
ORDER BY p.prod_nom;

-- 8) Ventes avec employé
SELECT v.ID_vente, v.vente_date, e.employe_nom, e.employe_prenom, v.vente_prix_total
FROM vente v
JOIN employe e ON e.ID_employe = v.ID_employe
ORDER BY v.ID_vente DESC;

-- 9) Top produits
SELECT p.ID_prod, p.prod_nom, COUNT(*) AS nb_lignes
FROM concerner c
JOIN produits_boutique p ON p.ID_prod = c.ID_prod
GROUP BY p.ID_prod, p.prod_nom
ORDER BY nb_lignes DESC, p.ID_prod
LIMIT 10;

-- Sous-requêtes
-- 10) Produits jamais vendus
SELECT p.ID_prod, p.prod_nom
FROM produits_boutique p
WHERE NOT EXISTS (SELECT 1 FROM concerner c WHERE c.ID_prod = p.ID_prod)
ORDER BY p.ID_prod;

-- 11) Produits vendus au moins une fois 
SELECT p.ID_prod, p.prod_nom
FROM produits_boutique p
WHERE EXISTS (SELECT 1 FROM concerner c WHERE c.ID_prod = p.ID_prod)
ORDER BY p.ID_prod;

-- Plus cher qu’au moins un “Nutrition” 
SELECT p.ID_prod, p.prod_nom, p.prod_prix
FROM produits_boutique p
WHERE p.prod_prix > ANY (
SELECT p2.prod_prix FROM produits_boutique p2 WHERE p2.prod_categorie = 'Nutrition'
)
ORDER BY p.prod_prix DESC, p.ID_prod;

-- SCÉNARIO B — Fournisseurs & stocks

-- Projections / Sélections

-- 12) Catégories uniques
SELECT DISTINCT prod_categorie
FROM produits_boutique
ORDER BY prod_categorie;

-- 13) Stock bas “Accessoires” 
SELECT ID_prod, prod_nom, prod_stock
FROM produits_boutique
WHERE prod_categorie = 'Accessoires' AND prod_stock BETWEEN 0 AND 40
ORDER BY prod_stock ASC, ID_prod ASC;

-- 14) Produits prix entre 5 et 30
SELECT ID_prod, prod_nom, prod_prix
FROM produits_boutique
WHERE prod_prix BETWEEN 5 AND 30
ORDER BY prod_prix, ID_prod;

-- Agrégations + GROUP BY/HAVING 

-- 15) CA et nb ventes par employé (inclut 0 grâce à LEFT JOIN)
SELECT e.ID_employe, e.employe_nom, e.employe_prenom,
  SUM(CASE WHEN v.vente_prix_total IS NULL THEN 0 ELSE v.vente_prix_total END) AS ca,
  SUM(CASE WHEN v.ID_vente IS NULL THEN 0 ELSE 1 END) AS nb_ventes
FROM employe e
LEFT JOIN vente v ON v.ID_employe = e.ID_employe
GROUP BY e.ID_employe, e.employe_nom, e.employe_prenom
ORDER BY ca DESC, nb_ventes DESC, e.ID_employe;


-- 16) Produits et nombre de ventes
SELECT p.ID_prod, p.prod_nom, COUNT(c.ID_vente) AS nb_ventes
FROM produits_boutique p
LEFT JOIN concerner c ON c.ID_prod = p.ID_prod
GROUP BY p.ID_prod, p.prod_nom
ORDER BY nb_ventes DESC, p.ID_prod ASC;

-- Jointures

-- 17) Produits avec fournisseur
SELECT p.ID_prod, p.prod_nom, f.ID_fournisseur, f.fournisseur_nom
FROM produits_boutique p
LEFT JOIN fournir fr ON fr.ID_prod = p.ID_prod
LEFT JOIN fournisseur f ON f.ID_fournisseur = fr.ID_fournisseur
ORDER BY p.ID_prod, f.ID_fournisseur;

-- 18) Participants par cours 
SELECT c.ID_cours, c.cours_date, c.cours_capacite, COUNT(p.ID_adherent) AS nb_participants
FROM cours_collectif c
LEFT JOIN participer p ON p.ID_cours = c.ID_cours
GROUP BY c.ID_cours, c.cours_date, c.cours_capacite
ORDER BY c.ID_cours;

-- Sous-requêtes

-- 19) Produits sans fournisseur
SELECT p.ID_prod, p.prod_nom
FROM produits_boutique p
WHERE p.ID_prod NOT IN (SELECT fr.ID_prod FROM fournir fr)
ORDER BY p.ID_prod;

-- 20) Fournisseurs sans aucun produit
SELECT f.ID_fournisseur, f.fournisseur_nom
FROM fournisseur f
WHERE NOT EXISTS (
SELECT 1
FROM fournir fr
WHERE fr.ID_fournisseur = f.ID_fournisseur
)
ORDER BY f.ID_fournisseur;

