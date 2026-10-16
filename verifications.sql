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
