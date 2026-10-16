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
-- resultat attendu (apres etape 06) : 1 -> 15000, 2 -> 14000, 3 -> 13000, 4 -> 27000
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
-- resultat attendu (apres etape 06) : Njaka Rakoto -> 2 commandes, 29000 ; Lalao Rasoa -> 2 commandes, 40000
SELECT s.nom,
       COUNT(DISTINCT c.id_commande) AS nb_commandes,
       COALESCE(SUM(lc.quantite * p.prix), 0) AS chiffre_affaires
FROM serveur s
LEFT JOIN commande c ON c.id_serveur = s.id_serveur
LEFT JOIN ligne_commande lc ON lc.id_commande = c.id_commande
LEFT JOIN plat p ON p.id_plat = lc.id_plat
GROUP BY s.id_serveur, s.nom
ORDER BY s.nom;

-- ===== Etape 06 : commandes non soldees (montant du, montant paye, reste a payer) =====
-- resultat attendu : commande 2 -> du 14000, paye 6000, reste 8000 ; 3 -> 13000/0/13000 ; 4 -> 27000/0/27000
SELECT c.id_commande,
       du.montant_du,
       COALESCE(pa.montant_paye, 0) AS montant_paye,
       du.montant_du - COALESCE(pa.montant_paye, 0) AS reste_a_payer
FROM commande c
JOIN (SELECT lc.id_commande, SUM(lc.quantite * p.prix) AS montant_du
      FROM ligne_commande lc
      JOIN plat p ON p.id_plat = lc.id_plat
      GROUP BY lc.id_commande) du ON du.id_commande = c.id_commande
LEFT JOIN (SELECT id_commande, SUM(montant) AS montant_paye
           FROM paiement
           GROUP BY id_commande) pa ON pa.id_commande = c.id_commande
WHERE du.montant_du > COALESCE(pa.montant_paye, 0)
ORDER BY c.id_commande;
