# 🐾 ChatonStore — Boutique de photos de chatons

![Ruby version](https://img.shields.io/badge/Ruby-3.2.2-red?logo=ruby)
![Rails version](https://img.shields.io/badge/Rails-8.0.2-red?logo=rubyonrails)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-en%20cours%20de%20dev-blue)

Une application e-commerce développée en **Rails 8**, permettant d’acheter et de télécharger des photos de chatons. 🐱💳  
Intégration complète de Stripe, Active Storage, Devise, et interface admin avec Bootstrap.

---

## 🚀 Lancer le projet en local

### 1. Cloner le repo

```bash
git clone git@github.com:istarengwa/chaton-project.git
cd chaton-project
````

### 2. Installer les dépendances

```bash
bundle install
```

### 3. Préparer les variables d'environnement

```bash
touch .env
```

Ajoute tes clés API dans ce fichier. Tu peux suivre les cours THP pour les récupérer :

* Stripe sous Rails
* L'Action Mailer

Exemple `.env` :

```
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxxxxxxx
STRIPE_SECRET_KEY=sk_test_xxxxxxxxxxxxxxxxx
GMAIL_USERNAME="xxxxxxxxxxxxxxxxxxxx"
GMAIL_PASSWORD="xxxxxxxxxxxxxxxxxxxx"
```

### 4. Initialiser la base de données

```bash
rails db:create db:migrate db:seed
```

---

## 👤 Compte administrateur

* **Email** : `admin@yopmail.com`
* **Mot de passe** : `123456`

Ce compte permet d'accéder aux fonctionnalités d'administration (ajout, modification et suppression d’items).

---

## 🧰 Stack technique

* **Ruby** 3.2.2
* **Rails** 8.0.2
* **SQlite**
* **Devise** — gestion des utilisateurs
* **Active Storage** — upload d’images
* **Bootstrap 5.3** — interface utilisateur
* **Stripe** — paiement en ligne sécurisé

---

## 🛒 Fonctionnalités

* Navigation dans la galerie de photos
* Ajout d’articles au panier
* Paiement avec Stripe
* Téléchargement des fichiers achetés
* Historique de commandes
* Interface admin sécurisée

---

## 📄 Licence

MIT — libre d’utilisation, modification et diffusion.
