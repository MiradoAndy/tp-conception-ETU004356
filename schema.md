# Schéma relationnel – la gargote de Rado

## Étape 1 – La carte

PLAT(**id_plat**, nom, prix) (nouveau)

### Piège

Le prix est un `INTEGER` : les montants sont en ariary sans centimes, donc pas besoin de `DECIMAL` ni de `FLOAT` (qui arrondit mal). Pour l'identifiant je prends un `id_plat` auto-incrémenté plutôt que le nom, parce qu'un nom peut changer ou être écrit de deux façons, alors qu'une clé primaire doit rester stable.
