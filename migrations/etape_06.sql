-- Etape 06 : les paiements
-- "On paie en especes, MVola, Orange Money ou Airtel Money. Parfois un client paie une partie
--  en especes et le reste par MVola. Pour le mobile money, je note la reference de la transaction."

CREATE TABLE mode_paiement (
    id_mode      SERIAL PRIMARY KEY,
    libelle      VARCHAR(30) NOT NULL UNIQUE,
    mobile_money BOOLEAN NOT NULL DEFAULT FALSE   -- vrai = on doit noter une reference
);

INSERT INTO mode_paiement (libelle, mobile_money) VALUES
    ('Espèces',      FALSE),
    ('MVola',        TRUE),
    ('Orange Money', TRUE),
    ('Airtel Money', TRUE);

-- une commande peut avoir plusieurs paiements, chacun avec son mode et son montant
CREATE TABLE paiement (
    id_paiement   SERIAL PRIMARY KEY,
    id_commande   INTEGER NOT NULL REFERENCES commande(id_commande),
    id_mode       INTEGER NOT NULL REFERENCES mode_paiement(id_mode),
    montant       INTEGER NOT NULL CHECK (montant > 0),
    date_paiement DATE NOT NULL DEFAULT CURRENT_DATE,
    reference     VARCHAR(50)    -- facultatif : seulement pour le mobile money
);

-- Ajustement des donnees de test : l'enonce dit que la commande 1 a ete payee 15 000 Ar
-- (10 000 + 5 000), alors qu'elle ne valait que 7 500 Ar. On remplace son Ranon'ampango
-- par un Ravitoto sy henakisoa : 7 000 + 8 000 = 15 000 Ar.
UPDATE ligne_commande
SET id_plat = (SELECT id_plat FROM plat WHERE nom = 'Ravitoto sy henakisoa')
WHERE id_commande = 1
  AND id_plat = (SELECT id_plat FROM plat WHERE nom = 'Ranon''ampango');

-- commande 1 : 10 000 en especes + 5 000 par MVola
INSERT INTO paiement (id_commande, id_mode, montant, date_paiement, reference) VALUES
    (1, (SELECT id_mode FROM mode_paiement WHERE libelle = 'Espèces'), 10000, '2026-10-12', NULL),
    (1, (SELECT id_mode FROM mode_paiement WHERE libelle = 'MVola'),    5000, '2026-10-12', 'MV261012A4F7');

-- commande 2 : 6 000 par Orange Money (la commande vaut 14 000, il reste donc 8 000 a payer)
INSERT INTO paiement (id_commande, id_mode, montant, date_paiement, reference) VALUES
    (2, (SELECT id_mode FROM mode_paiement WHERE libelle = 'Orange Money'), 6000, '2026-10-12', 'OM261012K9B2');
