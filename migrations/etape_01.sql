-- Etape 01 : la carte
-- "Je veux la liste de mes plats avec leur prix."

CREATE TABLE plat (
    id_plat SERIAL PRIMARY KEY,
    nom     VARCHAR(100) NOT NULL,
    prix    INTEGER NOT NULL CHECK (prix >= 0)   -- en ariary, pas de centimes
);

INSERT INTO plat (nom, prix) VALUES
    ('Romazava',              7000),
    ('Ravitoto sy henakisoa', 8000),
    ('Akoho sy voanio',       8500),
    ('Mi sao',                6000),
    ('Soupe chinoise',        5000),
    ('Mofo gasy (les 4)',     1000),
    ('Ranon''ampango',         500);
