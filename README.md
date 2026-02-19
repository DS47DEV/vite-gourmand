# Vite & Gourmand — Déploiement local

Ce dépôt contient une démonstration front-end (fichier `index.html`) de la plateforme **Vite & Gourmand** : consultation des menus traiteur, panier, commande, espace client (tableau de bord), espace employé et espace administrateur. fileciteturn1file13

## 1) Prérequis

- Git
- Un navigateur moderne (Chrome / Firefox / Edge)
- **Optionnel** : un serveur HTTP local (recommandé) :
  - Python 3 (déjà présent sur beaucoup de machines) **ou**
  - Node.js (pour `npx serve`)

> Pourquoi un serveur local ? Certaines fonctionnalités (chargements, sécurité, APIs navigateur) peuvent être limitées en ouvrant simplement le fichier via `file://`.

## 2) Lancer l’application en local

### Méthode A — Python (simple et universelle)

```bash
# depuis la racine du projet (là où se trouve index.html)
python -m http.server 5173
```

Puis ouvrir : http://localhost:5173

### Méthode B — Node (serve)

```bash
npx serve -l 5173
```

Puis ouvrir : http://localhost:5173

### Méthode C — Sans serveur (à éviter)

Double-cliquer sur `index.html` et l’ouvrir dans le navigateur.
Certaines fonctionnalités peuvent se comporter différemment selon le navigateur.

## 3) Identifiants de démonstration

- **Administrateur**
  - Email : `admin@vitegourmand.fr`
  - Mot de passe : `Admin@VG2026!` fileciteturn2file15
- **Employé**
  - Email : `employe@vitegourmand.fr`
  - Mot de passe : `Employe@2026` fileciteturn2file9
- **Client**
  - Créez un compte via « S’inscrire » (la démo fonctionne sans back-end).
  - (Pour la base SQL fournie, un client seed est disponible : `client@demo.fr` / `Client@2026!`.)

## 4) Structure conseillée du dépôt

```
.
├── index.html
├── README.md
└── sql/
    ├── 01_create_schema.sql
    └── 02_seed_data.sql
```

## 5) Bonnes pratiques Git (GitFlow “léger”)

### Branches

- `main` : branche principale, toujours stable
- `develop` : branche d’intégration, base du travail quotidien
- `feature/<nom-feature>` : une fonctionnalité = une branche issue de `develop`

### Workflow

1. Créer/mettre à jour `develop` depuis `main` :
   ```bash
   git checkout main
   git pull
   git checkout -b develop
   # (ou git checkout develop && git pull si elle existe déjà)
   ```

2. Démarrer une fonctionnalité :
   ```bash
   git checkout develop
   git pull
   git checkout -b feature/commande
   ```

3. Travailler + commits fréquents :
   - Messages clairs, impératifs : `feat: ...`, `fix: ...`, `docs: ...`
   - Petits commits (une intention par commit)

4. Tester localement, puis fusionner vers `develop` :
   ```bash
   git checkout develop
   git merge --no-ff feature/commande
   git branch -d feature/commande
   ```

5. Quand `develop` est validée (tests/recette), fusionner vers `main` :
   ```bash
   git checkout main
   git merge --no-ff develop
   git tag -a v1.0.0 -m "Release v1.0.0"
   ```

## 6) Base de données (SQL)

Même si l’application fournie est une démo front-end (données simulées), le dossier `sql/` contient :

- `01_create_schema.sql` : création des tables (utilisateurs, employés, menus, commandes, avis, horaires)
- `02_seed_data.sql` : données d’exemple + identifiants de démonstration

Exemple (PostgreSQL) :

```bash
createdb vite_gourmand
psql -d vite_gourmand -f sql/01_create_schema.sql
psql -d vite_gourmand -f sql/02_seed_data.sql
```

> Ces scripts sont adaptés aussi à MySQL/MariaDB avec de légères modifications (types, auto-incréments).

## 7) Documentation utilisateur (PDF)

Le manuel utilisateur est fourni dans : `docs/Manuel_utilisation_Vite_Gourmand.pdf`
