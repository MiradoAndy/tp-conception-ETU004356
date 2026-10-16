-- Verifications : une section par etape

-- ===== Etape 01 : plats du plus cher au moins cher =====
SELECT id_plat, nom, prix
FROM plat
ORDER BY prix DESC;

-- ===== Etape 02 : nombre de plats par categorie (y compris les categories vides) =====
SELECT c.libelle, COUNT(p.id_plat) AS nb_plats
FROM categorie c
LEFT JOIN plat p ON p.id_categorie = c.id_categorie
GROUP BY c.id_categorie, c.libelle
ORDER BY c.id_categorie;

-- ===== Etape 03 : montant total de chaque commande =====
-- resultat attendu : 1 -> 7500, 2 -> 14000, 3 -> 13000, 4 -> 27000
SELECT c.id_commande, c.date_commande, SUM(lc.quantite * p.prix) AS montant_total
FROM commande c
JOIN ligne_commande lc ON lc.id_commande = c.id_commande
JOIN plat p ON p.id_plat = lc.id_plat
GROUP BY c.id_commande, c.date_commande
ORDER BY c.id_commande;

-- ===== Etape 04 : commandes avec le nom du client ("client de passage" si aucun) =====
SELECT c.id_commande, c.date_commande, COALESCE(cl.nom, 'client de passage') AS client
FROM commande c
LEFT JOIN client cl ON cl.id_client = c.id_client
ORDER BY c.id_commande;

-- ===== Etape 05 : nombre de commandes et chiffre d'affaires par serveur =====
-- resultat attendu : Njaka Rakoto -> 2 commandes, 21500 ; Lalao Rasoa -> 2 commandes, 40000
SELECT s.nom,
       COUNT(DISTINCT c.id_commande) AS nb_commandes,
       COALESCE(SUM(lc.quantite * p.prix), 0) AS chiffre_affaires
FROM serveur s
LEFT JOIN commande c ON c.id_serveur = s.id_serveur
LEFT JOIN ligne_commande lc ON lc.id_commande = c.id_commande
LEFT JOIN plat p ON p.id_plat = lc.id_plat
GROUP BY s.id_serveur, s.nom
ORDER BY s.nom;
