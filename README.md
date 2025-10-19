Mini Projet Base de Données – Salle de sport

Mise en place de la base de donnée:

1. Analyse des différents besoins:
Choix des entités, attributs, cardinalités et relations en nous basant
sur des scénarios réels d'utilisation (gestion de la boutique, des cours etc)

Utilisation de l'IA Générative pour obtenir le dictionnaire de données associé

2. Réalisation du MCD:
   
Réalisé avec Looping
Utilisation d’une association n-aire avec n=3: un coach (employé) et des adhérents participent simultanément à un cours

Utilisation d'une association récursive: un superviseur est un employé

Utilisation d'une entité faible (vente) et forte (employé)

4. Réalisation du MLD et du MPD:
   
Définition des clés primaires et étrangères
Contraintes d'intégrité respectées
Ecriture du script SQL de création des tables avec commentaires
Ajout de contraintes supplémentaire afin de garantir la cohérence des informations dans la base de donnée

5. Insertion:
Données générées avec l’aide de ChatGPT, grâce à un prompt rédigé au préalable

6. Requêtes et scenarios

3 scenarios choisis (responsable boutique, responsable de la gestion des stock et responsable cours et coaching)

Le responsable boutique cherche à s'informer au sujet des hiffres que fait la boutique (chiffre d'affaire, quel employé vend le plus, qu'est ce qui ne se vend pas etc)

Le responsable de la gestion des stocks doit être informé quant au stock de chaque produit, savoir quel fournisseur contacter en fonction de ce dont il a besoin,
les prix de vente des produits afin de s'assurer de faire du profit au moment de se réapprovisionner

Le responseble cours et coaching  doit quant à lui, connaître le planning des cours et savoir quels adhérents et coachs ont participé à quels cours 

Liste des différentes fonctionnalités:

-Gérer les membres: créer/mettre à jour leurs infos, leur statut, leurs abonnements.

-Gérer les abonnements: types d’offres, dates de début/fin, prix, lien avec les membres.

-Gérer les cours: créer des sessions avec une date et une capacité, inscrire plusieurs personnes, voir le taux de remplissage.

-Gérer le coaching: enregistrer les séances individuelles par personne, retrouver l’historique.

-Gérer la boutique: lister les produits (catégorie, prix, stock), chercher et filtrer.

-Gérer les fournisseurs: relier chaque produit à un ou plusieurs fournisseurs, repérer les produits sans fournisseur.

-Gérer les ventes: enregistrer la date, le mode de paiement, le total, l’employé qui encaisse.

-Analyser les ventes: voir le chiffre d’affaires par année, par heure, par mode de paiement, les produits qui se vendent le plus ou pas du tout.

-Assurer la qualité des données: règles pour éviter les prix/stock négatifs, les dates incohérentes, et garder des infos de contact valides.

Réalisé par
ADHAR Mazien
KADIRI Ghali
