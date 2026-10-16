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
