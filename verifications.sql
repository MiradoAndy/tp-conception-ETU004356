-- Verifications : une section par etape

-- ===== Etape 01 : plats du plus cher au moins cher =====
SELECT id_plat, nom, prix
FROM plat
ORDER BY prix DESC;
