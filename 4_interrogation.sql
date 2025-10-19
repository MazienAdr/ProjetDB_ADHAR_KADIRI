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

-- 4) CA total et nombre de ventes par année
SELECT YEAR(vente_date) AS annee, SUM(vente_prix_total) AS ca_total, COUNT(*) AS nb_ventes
FROM vente
GROUP BY YEAR(vente_date)
ORDER BY annee;

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

-- 9) Classement produits
SELECT p.ID_prod, p.prod_nom, COUNT(*) AS nb_ventes
FROM concerner c
JOIN produits_boutique p ON p.ID_prod = c.ID_prod
GROUP BY p.ID_prod, p.prod_nom
ORDER BY nb_ventes DESC, p.ID_prod
LIMIT 18;

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

-- 15) Produits et nombre de ventes
SELECT p.ID_prod, p.prod_nom, COUNT(c.ID_vente) AS nb_ventes
FROM produits_boutique p
LEFT JOIN concerner c ON c.ID_prod = p.ID_prod
GROUP BY p.ID_prod, p.prod_nom
ORDER BY nb_ventes DESC, p.ID_prod ASC;

-- Jointures

-- 16) Produits avec fournisseur
SELECT p.ID_prod, p.prod_nom, f.ID_fournisseur, f.fournisseur_nom
FROM produits_boutique p
LEFT JOIN fournir fr ON fr.ID_prod = p.ID_prod
LEFT JOIN fournisseur f ON f.ID_fournisseur = fr.ID_fournisseur
ORDER BY p.ID_prod, f.ID_fournisseur;


-- Sous-requêtes

-- 17) Produits sans fournisseur
SELECT p.ID_prod, p.prod_nom
FROM produits_boutique p
WHERE p.ID_prod NOT IN (SELECT fr.ID_prod FROM fournir fr)
ORDER BY p.ID_prod;

-- 18) Fournisseurs sans aucun produit
SELECT f.ID_fournisseur, f.fournisseur_nom
FROM fournisseur f
WHERE NOT EXISTS (
SELECT 1
FROM fournir fr
WHERE fr.ID_fournisseur = f.ID_fournisseur
)
ORDER BY f.ID_fournisseur;

-- SCÉNARIO C — Responsable coaching --

SET @date_debut='2024-01-01';
SET @date_fin='2025-12-31';

-- Projections / Sélections 

-- 19) Séances (période)
SELECT ID_seance, coaching_date, ID_adherent
FROM seance_coaching
WHERE coaching_date BETWEEN @date_debut AND @date_fin
ORDER BY coaching_date;


-- Agrégations + GROUP BY/HAVING 

-- 20) Séances par mois
SELECT DATE_FORMAT(coaching_date,'%Y-%m') AS mois, COUNT(*) AS nb
FROM seance_coaching
WHERE coaching_date BETWEEN @date_debut AND @date_fin
GROUP BY mois
ORDER BY mois DESC;

-- 21) Remplissage cours

SELECT c.ID_cours, COUNT(p.ID_adherent) AS nb_participant, c.cours_capacite
FROM cours_collectif c
LEFT JOIN participer p ON p.ID_cours=c.ID_cours
WHERE c.cours_date BETWEEN @date_debut AND @date_fin
GROUP BY c.ID_cours, c.cours_capacite;


-- Jointures

-- 22) Séances + adhérent
SELECT sc.ID_seance, sc.coaching_date, a.ad_nom, a.ad_prenom
FROM seance_coaching sc
JOIN adherent a ON a.ID_adherent=sc.ID_adherent
WHERE sc.coaching_date BETWEEN @date_debut AND @date_fin;

-- Sous-requêtes

-- 23) Avec ≥1 séance
SELECT a.ID_adherent, a.ad_nom, a.ad_prenom
FROM adherent a
WHERE EXISTS (
SELECT 1 FROM seance_coaching sc
WHERE sc.ID_adherent=a.ID_adherent
AND sc.coaching_date BETWEEN @date_debut AND @date_fin
);





