-- Etape 04 : les habitues
-- "Certains clients sont des habitues, je veux les reconnaitre.
--  Mais la plupart sont de passage et je ne leur demande rien."

CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom       VARCHAR(100) NOT NULL,
    telephone VARCHAR(20)              -- facultatif
);

-- pas de NOT NULL : une commande d'un client de passage n'a pas de client
-- (et les 4 commandes deja saisies n'en ont pas non plus)
ALTER TABLE commande ADD COLUMN id_client INTEGER REFERENCES client(id_client);

INSERT INTO client (nom, telephone) VALUES
    ('Hery Andrianina', '034 12 345 67'),
    ('Voahangy Ravelo', NULL),
    ('Tiana Rakotomalala', '032 98 765 43');

-- on rattache quelques commandes existantes, les autres restent "de passage"
UPDATE commande SET id_client = (SELECT id_client FROM client WHERE nom = 'Hery Andrianina')
WHERE id_commande IN (1, 4);

UPDATE commande SET id_client = (SELECT id_client FROM client WHERE nom = 'Voahangy Ravelo')
WHERE id_commande = 3;
-- la commande 2 reste sans client
