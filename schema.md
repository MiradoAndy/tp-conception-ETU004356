# Schéma relationnel – la gargote de Rado

## Étape 1 – La carte

PLAT(**id_plat**, nom, prix) (nouveau)

### Piège

Le prix est un `INTEGER` : les montants sont en ariary sans centimes, donc pas besoin de `DECIMAL` ni de `FLOAT` (qui arrondit mal). Pour l'identifiant je prends un `id_plat` auto-incrémenté plutôt que le nom, parce qu'un nom peut changer ou être écrit de deux façons, alors qu'une clé primaire doit rester stable.

## Étape 2 – Les catégories

CATEGORIE(**id_categorie**, libelle) (nouveau)
PLAT(**id_plat**, nom, prix, #id_categorie) (modifié)

### Piège

Avec une colonne `categorie VARCHAR(50)` dans PLAT, on peut écrire « Soupe » pour un plat et « soupe » ou « Soupes » pour un autre : le même groupe est alors coupé en deux dans les statistiques. On ne peut pas non plus avoir une catégorie sans plat, ni la renommer sans modifier toutes les lignes. Avec une table CATEGORIE, le libellé est écrit une seule fois et la clé étrangère empêche les valeurs inventées.
