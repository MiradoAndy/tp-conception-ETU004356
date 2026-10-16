-- Etape 03 : les commandes
-- "J'enregistre les commandes : la date, quels plats, et combien de chaque."

CREATE TABLE commande (
    id_commande   SERIAL PRIMARY KEY,
    date_commande DATE NOT NULL DEFAULT CURRENT_DATE
);

-- table d'association : une commande a plusieurs plats, un plat est dans plusieurs commandes
CREATE TABLE ligne_commande (
    id_commande INTEGER NOT NULL REFERENCES commande(id_commande),
    id_plat     INTEGER NOT NULL REFERENCES plat(id_plat),
    quantite    INTEGER NOT NULL CHECK (quantite > 0),
    PRIMARY KEY (id_commande, id_plat)
);

INSERT INTO commande (date_commande) VALUES
    ('2026-10-12'),
    ('2026-10-12'),
    ('2026-10-13'),
    ('2026-10-14');

-- commande 1 : 1 Romazava + 1 Ranon'ampango
INSERT INTO ligne_commande (id_commande, id_plat, quantite) VALUES
    (1, (SELECT id_plat FROM plat WHERE nom = 'Romazava'), 1),
    (1, (SELECT id_plat FROM plat WHERE nom = 'Ranon''ampango'), 1);

-- commande 2 : 2 Mi sao + 2 Ranon'ampango + 1 Mofo gasy
INSERT INTO ligne_commande (id_commande, id_plat, quantite) VALUES
    (2, (SELECT id_plat FROM plat WHERE nom = 'Mi sao'), 2),
    (2, (SELECT id_plat FROM plat WHERE nom = 'Ranon''ampango'), 2),
    (2, (SELECT id_plat FROM plat WHERE nom = 'Mofo gasy (les 4)'), 1);

-- commande 3 : 1 Ravitoto + 1 Soupe chinoise
INSERT INTO ligne_commande (id_commande, id_plat, quantite) VALUES
    (3, (SELECT id_plat FROM plat WHERE nom = 'Ravitoto sy henakisoa'), 1),
    (3, (SELECT id_plat FROM plat WHERE nom = 'Soupe chinoise'), 1);

-- commande 4 : 3 Akoho sy voanio + 3 Ranon'ampango
INSERT INTO ligne_commande (id_commande, id_plat, quantite) VALUES
    (4, (SELECT id_plat FROM plat WHERE nom = 'Akoho sy voanio'), 3),
    (4, (SELECT id_plat FROM plat WHERE nom = 'Ranon''ampango'), 3);
