# Flutter Application 1

## Configuration des variables d'environnement

Ce projet utilise des variables d'environnement pour stocker les clés API sensibles.

### Installation

1. Copiez le fichier `.env.example` vers `.env` :
   ```bash
   cp .env.example .env
   ```

2. Modifiez le fichier `.env` avec vos vraies clés API :
   ```
   AMADEUS_CLIENT_ID=votre_vrai_client_id
   AMADEUS_CLIENT_SECRET=votre_vrai_client_secret
   ```

### Sécurité

- Le fichier `.env` est ajouté au `.gitignore` pour éviter qu'il soit commité
- Ne partagez jamais vos vraies clés API dans le code source
- Utilisez toujours le fichier `.env.example` comme modèle

### Utilisation dans le code

Les variables d'environnement sont chargées au démarrage de l'application dans `main.dart` et peuvent être utilisées avec :

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

String clientId = dotenv.env['AMADEUS_CLIENT_ID'] ?? '';
String clientSecret = dotenv.env['AMADEUS_CLIENT_SECRET'] ?? '';
```

Ce projet est une application mobile de réservation d'hôtels développée avec Flutter. Elle permet aux utilisateurs de rechercher, consulter et réserver des hôtels facilement, à la manière de Booking.com. 

L'objectif est de proposer une expérience fluide et moderne pour la gestion de réservations hôtelières.

