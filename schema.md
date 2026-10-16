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

## Étape 3 – Les commandes

CATEGORIE(**id_categorie**, libelle)
PLAT(**id_plat**, nom, prix, #id_categorie)
COMMANDE(**id_commande**, date_commande) (nouveau)
LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite) (nouveau)

### Piège

La quantité va dans LIGNE_COMMANDE, parce qu'elle dépend à la fois de la commande et du plat : « 2 Mi sao dans la commande 2 ». Dans PLAT elle serait la même pour toutes les commandes, et dans COMMANDE elle n'aurait pas de sens puisqu'une commande contient plusieurs plats.

## Étape 4 – Les habitués

CATEGORIE(**id_categorie**, libelle)
PLAT(**id_plat**, nom, prix, #id_categorie)
CLIENT(**id_client**, nom, telephone?) (nouveau)
COMMANDE(**id_commande**, date_commande, #id_client?) (modifié)
LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite)

### Piège

Non, la clé étrangère `id_client` n'est pas `NOT NULL`, sinon on serait obligé de créer un client pour chaque personne de passage. Pour ne perdre aucune commande il faut un `LEFT JOIN` de COMMANDE vers CLIENT : avec un `JOIN` simple, les commandes sans client disparaîtraient du résultat.
