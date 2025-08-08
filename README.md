# BeeSure
App de déclaration d'incident

## Technologies utilisées

Le projet BeeSure s'appuie sur une stack technologique moderne pour assurer performance, évolutivité et robustesse :

### Frontend
- **Flutter** – Framework UI de Google pour le développement d'applications mobiles multiplateformes (Android/iOS) - [Guide d'installation Flutter](apps/mobile_app/README.md)
- **Angular** – Framework front-end web open-source pour l'application web
- **TypeScript** – Langage de programmation avec typage statique

### Backend
- **NestJS** – Framework backend Node.js progressif, écrit en TypeScript
- **Node.js** – Runtime JavaScript (v16+)

### Bases de données
- **PostgreSQL + PostGIS** – Base de données relationnelle avec extension géospatiale
- **MongoDB** – Base de données NoSQL pour les données non relationnelles

### Infrastructure
- **Docker** – Conteneurisation de l'ensemble du projet
- **NGINX** – Serveur web et proxy inverse
- **Git** – Contrôle de version

## 🚀 Installation et démarrage

### Prérequis
- Docker & Docker Compose
- Node.js 18+ (pour le développement local)
- npm ou yarn
- Angular CLI
- NestJS CLI
- Chrome (instaler dans votre environement de travail)

### Récupération du code
```bash
git clone https://github.com/your-repo/beesure.git
cd beesure
```

## 🛠️ Développement

### Démarrage rapide
```bash
# 1. Démarrer les bases de données
./scripts/dev.sh
```

### URLs de développement
- PostgreSQL: localhost:5432
- MongoDB: localhost:27017

### Commandes utiles en développement
```bash
# Arrêter les services
docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

# Voir les logs des services
docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f

# Nettoyer les volumes
docker-compose -f docker-compose.yml -f docker-compose.dev.yml down -v

# Relancer les migrations
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up liquibase
```

## 🏭 Production

### Démarrage
```bash
./scripts/prod.sh
```

### Commandes utiles en production
```bash
# Voir le statut des services
docker-compose --profile production ps

# Voir les logs
docker-compose --profile production logs -f

# Redémarrer tous les services
docker-compose --profile production restart

# Arrêter tous les services
docker-compose --profile production down

# Nettoyer complètement
docker-compose --profile production down -v --rmi all
```