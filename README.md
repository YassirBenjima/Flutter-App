# CoLearn

**Plateforme d'E-Learning Collaboratif avec IA Générative pour Cours Adaptatifs Auto-Créés**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-green.svg)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-17+-orange.svg)](https://www.oracle.com/java/)

## 📋 Table des Matières

- [À Propos](#-à-propos)
- [Fonctionnalités](#-fonctionnalités)
- [Architecture](#-architecture)
- [Technologies](#-technologies)
- [Structure du Projet](#-structure-du-projet)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Utilisation](#-utilisation)
- [Équipe](#-équipe)
- [Licence](#-licence)

## 🎯 À Propos

CoLearn est une plateforme d'e-learning innovante qui combine l'apprentissage collaboratif avec l'intelligence artificielle générative pour créer des cours personnalisés et adaptatifs. La plateforme permet aux apprenants de bénéficier de contenus éducatifs dynamiques générés automatiquement en fonction de leurs besoins et de leur progression, tout en favorisant la collaboration en temps réel entre utilisateurs.

### Objectifs Principaux

- ✅ Fournir une expérience d'apprentissage personnalisée via des cours autogénérés et adaptatifs
- ✅ Promouvoir la collaboration en temps réel (discussions, édition partagée, groupes de travail)
- ✅ Assurer une scalabilité, une sécurité et une accessibilité pour un large public
- ✅ Intégrer des outils d'analyse pour suivre les progrès et ajuster les contenus

## ✨ Fonctionnalités

### 🔐 Gestion des Utilisateurs

- Inscription et authentification via email/mot de passe
- Authentification OAuth (Google)
- Profils utilisateurs avec niveau d'expertise et préférences d'apprentissage
- Rôles : Apprenant, Formateur, Admin
- Invitation d'amis et formation de groupes

### 🤖 Génération de Cours via IA Générative

- Création automatique de cours adaptatifs basés sur le niveau et les préférences
- Génération de contenu éducatif dynamique (leçons, exercices, quiz)
- Adaptation du contenu selon la progression de l'apprenant
- Support multilingue (français, anglais)

### 👥 Fonctionnalités Collaboratives

- Forums de discussion en temps réel
- Édition collaborative de documents
- Groupes de travail et projets partagés
- Partage de ressources et annotations collaboratives

### 📊 Suivi et Évaluation

- Tableaux de bord personnalisés avec suivi de progression
- Système de badges et certifications auto-générées
- Quizzes et tests adaptatifs générés par IA
- Rapports analytiques pour formateurs

### 🔧 Administration

- Gestion des utilisateurs et des rôles
- Modération de contenu
- Configuration de la plateforme
- Monitoring et analytics

## 🏗️ Architecture

### Architecture Globale

La plateforme suit une architecture **Client-Serveur** avec une approche **microservices** :

```
┌─────────────────┐
│  Flutter App    │  ← Niveau Présentation (UI/UX)
│  (Mobile/Web)   │
└────────┬────────┘
         │
         │ REST API / WebSocket
         │
┌────────▼─────────────────┐
│   Spring Boot Backend    │  ← Niveau Application
│   (Microservices)        │
│  - Auth Service          │
│  - Course Service        │
│  - Collaboration Service │
│  - AI Service            │
└────────┬─────────────────┘
         │
         │
┌────────▼─────────────────┐
│   Base de Données        │  ← Niveau Données
│  - MySQL (Relationnel)   │
│  - MongoDB (Logs/Docs)   │
│  - Firebase (Storage)    │
└──────────────────────────┘
         │
         │
┌────────▼─────────────────┐
│   Services Externes      │  ← Niveau Externe
│  - API IA (OpenAI/Gemini)│
│  - Firebase (Notifications)│
└──────────────────────────┘
```

### Flux de Données

1. **Génération de Cours** :

   - Apprenant demande un cours → Backend appelle l'API IA → Contenu généré stocké et servi via Flutter

2. **Collaboration** :
   - WebSocket pour la synchronisation en temps réel entre utilisateurs

## 🛠️ Technologies

### Frontend

- **Flutter 3.x** - Framework multiplateforme (Android, iOS, Web, Desktop)
- **Dart** - Langage de programmation
- **Provider/Riverpod** - Gestion d'état
- **GetX** - Navigation et gestion d'état
- **HTTP** - Communication avec l'API backend
- **Google Sign-In** - Authentification OAuth

### Backend

- **Spring Boot 3.x** - Framework Java
- **Java 17+** - Langage de programmation
- **Spring Security** - Authentification et autorisation
- **Spring Data JPA** - Accès aux données
- **Hibernate** - ORM
- **OAuth2** - Authentification OAuth
- **MySQL** - Base de données relationnelle
- **Lombok** - Réduction du code boilerplate

### IA et Services Externes

- **OpenAI API / Google Gemini** - Génération de contenu IA
- **Firebase** - Stockage de médias et notifications push
- **WebSocket** - Communication en temps réel

### Outils de Développement

- **Maven** - Gestion des dépendances (Backend)
- **Gradle** - Build système (Android)
- **JUnit** - Tests unitaires (Backend)
- **Flutter Test** - Tests (Frontend)

## 📁 Structure du Projet

```
CoLearn/
├── Backend/                 # Application Spring Boot
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/co/learn/
│   │   │   │   ├── controllers/    # Contrôleurs REST
│   │   │   │   ├── services/       # Services métier
│   │   │   │   ├── repositories/   # Accès aux données
│   │   │   │   ├── models/         # Entités JPA
│   │   │   │   ├── security/       # Configuration sécurité
│   │   │   │   └── config/         # Configuration
│   │   │   └── resources/
│   │   │       └── application.properties
│   │   └── test/
│   └── pom.xml
│
├── CoLearn/                 # Application Flutter
│   ├── lib/
│   │   ├── main.dart
│   │   ├── consts/          # Constantes
│   │   ├── services/        # Services API
│   │   ├── views/           # Écrans
│   │   │   ├── auth/        # Authentification
│   │   │   ├── home/        # Accueil
│   │   │   ├── splash/      # Splash screen
│   │   │   └── widgets_common/  # Widgets réutilisables
│   │   └── models/          # Modèles de données
│   ├── assets/              # Ressources (images, fonts, icons)
│   ├── android/             # Configuration Android
│   ├── ios/                 # Configuration iOS
│   ├── web/                 # Configuration Web
│   └── pubspec.yaml
│
└── README.md                # Ce fichier
```

## 🚀 Installation

### Prérequis

- **Java 17+** installé
- **Maven 3.6+** installé
- **Flutter 3.x** installé
- **MySQL 8.0+** installé et configuré
- **Node.js** (optionnel, pour certains outils)
- **Git** installé

### Installation du Backend

1. **Cloner le dépôt** :

   ```bash
   git clone https://github.com/YassirBenjima/Flutter-App
   cd CoLearn/Backend
   ```

2. **Configurer la base de données** :

   - Créer une base de données MySQL nommée `colearn_db`
   - Modifier `src/main/resources/application.properties` avec vos paramètres de connexion

3. **Installer les dépendances** :

   ```bash
   mvn clean install
   ```

4. **Lancer l'application** :

   ```bash
   mvn spring-boot:run
   ```

   Le backend sera accessible sur `http://localhost:8080`

### Installation du Frontend

1. **Naviguer vers le dossier Flutter** :

   ```bash
   cd CoLearn/CoLearn
   ```

2. **Installer les dépendances** :

   ```bash
   flutter pub get
   ```

3. **Lancer l'application** :

   ```bash
   # Pour Android/iOS
   flutter run

   # Pour Web
   flutter run -d chrome

   # Ou utiliser les scripts fournis
   ./run_web.sh    # Linux/Mac
   run_web.bat     # Windows
   ```

## ⚙️ Configuration

### Configuration Backend

Modifier `Backend/src/main/resources/application.properties` :

```properties
# Base de données
spring.datasource.url=jdbc:mysql://localhost:3306/colearn
spring.datasource.username=your_username
spring.datasource.password=your_password

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Serveur
server.port=8080

# OAuth2 Google
spring.security.oauth2.client.registration.google.client-id=your_client_id
spring.security.oauth2.client.registration.google.client-secret=your_client_secret

# API IA
ai.api.key=your_ai_api_key
ai.api.url=https://api.openai.com/v1
```

### Configuration Frontend

Modifier les constantes dans `CoLearn/lib/consts/consts.dart` ou créer un fichier de configuration pour l'URL de l'API backend.

### Configuration Firebase

1. Créer un projet Firebase
2. Télécharger les fichiers de configuration :
   - `google-services.json` pour Android → `CoLearn/android/app/`
   - `GoogleService-Info.plist` pour iOS → `CoLearn/ios/Runner/`
3. Configurer les notifications push dans Firebase Console

## 📱 Utilisation

### Pour les Apprenants

1. **Inscription/Connexion** : Créer un compte ou se connecter via Google
2. **Choisir un parcours** : Sélectionner un domaine d'apprentissage ou une carrière
3. **Apprendre** : Suivre les cours générés par IA, adaptés à votre niveau
4. **Collaborer** : Rejoindre des groupes, participer aux forums
5. **Suivre sa progression** : Consulter le tableau de bord et les badges obtenus

### Pour les Formateurs

1. **Créer du contenu** : Ajouter des ressources et modérer les cours
2. **Analyser** : Consulter les rapports d'utilisation et de progression
3. **Interagir** : Répondre aux questions dans les forums

### Pour les Administrateurs

1. **Gérer les utilisateurs** : Attribuer des rôles, modérer les comptes
2. **Configurer la plateforme** : Paramétrer les services IA, les notifications
3. **Monitorer** : Suivre les performances et l'utilisation de la plateforme

## 📊 Performance et Exigences

### Performance

- ⚡ Temps de réponse API : < 2 secondes
- 📈 Scalabilité : Support pour 10,000 utilisateurs simultanés
- 🤖 Génération IA : 5-10 secondes par module de cours

### Sécurité

- 🔒 Chiffrement HTTPS
- 🔑 Authentification JWT
- 🛡️ Protection contre injections SQL et XSS
- 👤 Gestion des droits RBAC (Role-Based Access Control)
- 📋 Conformité RGPD/GDPR

### Disponibilité

- ✅ Taux de disponibilité cible : 99.9%
- 🔄 Tests unitaires, intégration et end-to-end
- 📊 Monitoring avec Prometheus (prévu)

## 🧪 Tests

### Backend

```bash
cd Backend
mvn test
```

### Frontend

```bash
cd CoLearn
flutter test
```

## 📝 Documentation

Pour plus de détails sur les spécifications du projet, consultez le [Cahier des Charges](CahierDesCharges_CoLearn.pdf).

## 🗺️ Roadmap

### Phase 1 : Analyse et Design ✅

- Raffinage des spécifications
- Wireframes et maquettes

### Phase 2 : Développement (en cours)

- Implémentation frontend/backend
- Intégration IA
- Fonctionnalités collaboratives

### Phase 3 : Tests (à venir)

- Tests unitaires
- Tests d'intégration
- Tests utilisateurs (UAT)

## 🤝 Contribution

Ce projet est développé dans le cadre d'un projet académique. Pour toute contribution ou question, veuillez contacter l'équipe de développement.

## 📄 Licence

Ce projet est développé dans un contexte académique. Tous droits réservés.

---

**CoLearn** - _Apprendre ensemble, progresser ensemble_ 🚀
