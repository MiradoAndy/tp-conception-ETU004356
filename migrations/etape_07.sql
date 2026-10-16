-- Etape 07 : les prix changent
-- "Au 15 octobre, le romazava passe de 7 000 a 7 500 Ar.
--  Mais mes anciennes factures doivent garder l'ancien prix !"

-- ATTENTION a l'ordre : il faut figer les anciens prix dans les lignes de commande
-- AVANT de changer le prix du romazava, sinon on copierait déjà le nouveau prix.

-- 1) prix payé par le client, copié sur la ligne au moment de la commande
ALTER TABLE ligne_commande ADD COLUMN prix_unitaire INTEGER;

UPDATE ligne_commande lc
SET prix_unitaire = p.prix
FROM plat p
WHERE p.id_plat = lc.id_plat;

ALTER TABLE ligne_commande ALTER COLUMN prix_unitaire SET NOT NULL;
ALTER TABLE ligne_commande ADD CONSTRAINT ck_ligne_prix_unitaire CHECK (prix_unitaire >= 0);

-- 2) bonus : historique des prix de chaque plat
CREATE TABLE prix_plat (
    id_plat    INTEGER NOT NULL REFERENCES plat(id_plat),
    date_debut DATE NOT NULL,       -- le prix est valable a partir de cette date
    prix       INTEGER NOT NULL CHECK (prix >= 0),
    PRIMARY KEY (id_plat, date_debut)
);

-- les prix actuels deviennent le premier prix connu de chaque plat
-- (on ne connait pas la vraie date de mise en carte, on prend le debut de l'annee)
INSERT INTO prix_plat (id_plat, date_debut, prix)
SELECT id_plat, DATE '2026-01-01', prix FROM plat;

-- 3) l'augmentation du romazava au 15 octobre
UPDATE plat SET prix = 7500 WHERE nom = 'Romazava';

INSERT INTO prix_plat (id_plat, date_debut, prix)
SELECT id_plat, DATE '2026-10-15', 7500 FROM plat WHERE nom = 'Romazava';

-- 4) une commande apres l'augmentation : 2 romazava au nouveau prix
INSERT INTO commande (date_commande, id_serveur, id_table)
VALUES ('2026-10-16',
        (SELECT id_serveur FROM serveur WHERE nom = 'Njaka Rakoto'),
        (SELECT id_table FROM table_salle WHERE numero = 2));

INSERT INTO ligne_commande (id_commande, id_plat, quantite, prix_unitaire)
SELECT (SELECT MAX(id_commande) FROM commande), id_plat, 2, prix
FROM plat WHERE nom = 'Romazava';
