-- Etape 02 : les categories
-- "Je range mes plats par categorie : plats malagasy, plats chinois, soupes, desserts, boissons."

CREATE TABLE categorie (
    id_categorie SERIAL PRIMARY KEY,
    libelle      VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO categorie (libelle) VALUES
    ('Plat malagasy'),
    ('Plat chinois'),
    ('Soupe'),
    ('Dessert et goûter'),
    ('Boisson'),
    ('Entrée');   -- pas encore de plat, sert à tester le cas "catégorie vide"

-- 1) on ajoute la colonne en facultatif, sinon les 7 plats existants feraient échouer l'ALTER
ALTER TABLE plat ADD COLUMN id_categorie INTEGER REFERENCES categorie(id_categorie);

-- 2) on remplit la colonne pour les plats déjà saisis
UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE libelle = 'Plat malagasy')
WHERE nom IN ('Romazava', 'Ravitoto sy henakisoa', 'Akoho sy voanio');

UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE libelle = 'Plat chinois')
WHERE nom = 'Mi sao';

UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE libelle = 'Soupe')
WHERE nom = 'Soupe chinoise';

UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE libelle = 'Dessert et goûter')
WHERE nom = 'Mofo gasy (les 4)';

UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE libelle = 'Boisson')
WHERE nom = 'Ranon''ampango';

-- 3) maintenant que tout est rempli, on la rend obligatoire
ALTER TABLE plat ALTER COLUMN id_categorie SET NOT NULL;
