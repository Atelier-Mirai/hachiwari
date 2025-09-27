# Hachiwari

Hachiwari tire son nom de l'objectif d'atteindre 80 % de victoires. C'est une gem Ruby qui indique le nombre de victoires supplémentaires nécessaires pour atteindre votre pourcentage cible (80 % par défaut).

Pour les autres langues, consultez [README.md](README.md) (japonais) / [README.en.md](README.en.md) (anglais) / [README.es.md](README.es.md) (espagnol) / [README.de.md](README.de.md) (allemand).

## Installation

Installez la gem avec :

```
% gem install hachiwari
```

## Utilisation

### Afficher le nombre de victoires nécessaires pour atteindre le taux cible (avec sauvegarde automatique)

```
% hachiwari [status] [wins] [losses] [target] [language]
```

- Vous pouvez omettre `status` et ne passer que les arguments.
- L'alias hérité `s` est obsolète : son utilisation affiche un avertissement puis exécute `status` en interne.
- Les quatre arguments sont : nombre de victoires, nombre de défaites, pourcentage cible et langue d'affichage. Ils sont tous facultatifs.
- Sans argument, le score actuel est affiché à partir des valeurs par défaut ou des données enregistrées. Par défaut : victoires : 0, défaites : 0, objectif : 80 %, langue : japonais (`ja`).
- Si vous fournissez le nombre de victoires en premier argument, Hachiwari indique combien de victoires supplémentaires sont nécessaires à partir de ce total. Les autres arguments reviennent aux valeurs par défaut ou enregistrées.
- Le nombre de victoires fourni est automatiquement enregistré dans `~/.hachiwari`.
- Pour mettre à jour le nombre de défaites, passez-le en second argument.
- Pour modifier le pourcentage cible, utilisez le troisième argument (par exemple `90` pour 90 %).
- Pour changer la langue, utilisez le quatrième argument. Valeurs prises en charge : `ja` (japonais, par défaut), `en` (anglais), `es` (espagnol), `fr` (français) et `de` (allemand).

Pour obtenir un résultat sans enregistrer, ajoutez l'option `--trial` (ou `-t`) :

```
% hachiwari [status] --trial [wins] [losses] [target] [language]
```

Les arguments se comportent comme pour `status`, mais l'état n'est pas sauvegardé. Les anciens commandes `info`, `i` et `calculate` sont obsolètes : elles affichent un avertissement et se comportent comme `status --trial`.

### Afficher la version de Hachiwari

```
% hachiwari version
```

Affiche la version installée de Hachiwari.

### Supprimer les données enregistrées

```
% hachiwari clear
```

Supprime le fichier `.hachiwari` enregistré. S'il n'existe pas, seul un avertissement est affiché.

### Afficher la liste des commandes ou une aide détaillée

```
% hachiwari --help
% hachiwari status --help
```

`hachiwari --help` affiche la liste des commandes disponibles, et `hachiwari <commande> --help` montre l'aide détaillée de chaque commande.

### Commandes obsolètes

Les commandes/alias suivants sont obsolètes ; ils affichent un avertissement et basculent vers un comportement compatible :

- **s** : ancien alias de `status`. Un avertissement est affiché, puis `status` s'exécute.
- **info / i** : réalisaient une simulation sans sauvegarde. Elles avertissent désormais et se comportent comme `status --trial`.
- **calculate** : permettait un calcul basé uniquement sur des options. Elle avertit désormais et se comporte comme `status --trial` (les options `--target`/`--language` restent disponibles).

## Développement

Clonez le dépôt et préparez l'environnement avec :

```
bundle install
bundle exec rake test
```

- **Installer les dépendances** : `bundle install`
- **Lancer les tests** : `bundle exec rake test`
- **Vérifier le CLI manuellement** : `bundle exec ruby -Ilib bin/hachiwari --help`

Pour installer la gem localement, exécutez `bundle exec rake install`.

### Publier une nouvelle version

1. Mettez à jour `VERSION` dans `lib/hachiwari/version.rb`.
2. Commitez et poussez les modifications.
3. Lancez `bundle exec rake release`.

Cette commande crée un tag git, pousse les commits et le tag, puis publie la gem sur [rubygems.org](https://rubygems.org) (MFA requis sur RubyGems).

## Contribuer

Les rapports de bugs et pull requests sont les bienvenus sur [GitHub](https://github.com/Atelier-Mirai/hachiwari).

## Licence

Cette gem est publiée sous [licence MIT](https://opensource.org/licenses/MIT). Consultez [LICENSE](./LICENSE) pour plus de détails.
