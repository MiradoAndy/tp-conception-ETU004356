-- Etape 05 : serveurs et tables
-- "Je veux savoir quel serveur a pris la commande et a quelle table.
--  Pour les plats a emporter, il n'y a pas de table."

CREATE TABLE serveur (
    id_serveur SERIAL PRIMARY KEY,
    nom        VARCHAR(100) NOT NULL
);

-- on ne l'appelle pas "table" : c'est un mot reserve en SQL
CREATE TABLE table_salle (
    id_table SERIAL PRIMARY KEY,
    numero   INTEGER NOT NULL UNIQUE
);

INSERT INTO serveur (nom) VALUES
    ('Njaka Rakoto'),
    ('Lalao Rasoa');

INSERT INTO table_salle (numero) VALUES (1), (2), (3), (4), (5), (6), (7), (8);

-- serveur : on l'ajoute d'abord en facultatif (des commandes existent deja),
-- on remplit, puis on le rend obligatoire
ALTER TABLE commande ADD COLUMN id_serveur INTEGER REFERENCES serveur(id_serveur);

-- table : facultative pour de bon, une commande a emporter n'a pas de table
ALTER TABLE commande ADD COLUMN id_table INTEGER REFERENCES table_salle(id_table);

UPDATE commande SET id_serveur = (SELECT id_serveur FROM serveur WHERE nom = 'Njaka Rakoto')
WHERE id_commande IN (1, 2);

UPDATE commande SET id_serveur = (SELECT id_serveur FROM serveur WHERE nom = 'Lalao Rasoa')
WHERE id_commande IN (3, 4);

UPDATE commande SET id_table = (SELECT id_table FROM table_salle WHERE numero = 3) WHERE id_commande = 1;
UPDATE commande SET id_table = (SELECT id_table FROM table_salle WHERE numero = 5) WHERE id_commande = 2;
UPDATE commande SET id_table = (SELECT id_table FROM table_salle WHERE numero = 1) WHERE id_commande = 4;
-- la commande 3 est a emporter : pas de table

ALTER TABLE commande ALTER COLUMN id_serveur SET NOT NULL;
