# Configuration de l'Authentification Supabase

## Vue d'ensemble

Cette application utilise Supabase pour gérer l'authentification des utilisateurs. L'authentification inclut :
- Inscription et connexion avec email/mot de passe
- Connexion avec Google, Facebook et Apple (OAuth)
- Gestion automatique des sessions
- Redirection automatique selon l'état d'authentification

## Configuration

### 1. Variables d'environnement

Les variables d'environnement Supabase sont configurées dans le service `AuthService` :

```dart
// lib/services/auth_service.dart
static Future<void> initialize() async {
  await Supabase.initialize(
    url: 'https://fjtrlacpwhcijcfqnnlv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  );
}
```

### 2. Configuration Android

Le fichier `android/app/src/main/AndroidManifest.xml` contient la configuration pour les redirections OAuth :

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="io.supabase.flutter" />
</intent-filter>
```

### 3. Configuration Supabase Dashboard

Pour que l'authentification OAuth fonctionne, vous devez configurer les providers dans votre dashboard Supabase :

1. Allez dans votre dashboard Supabase
2. Naviguez vers Authentication > Settings > URL Configuration
3. Ajoutez les URLs de redirection :
   - `io.supabase.flutter://login-callback/`
   - `io.supabase.flutter://reset-callback/`

4. Configurez les providers OAuth (Google, Facebook, Apple) dans Authentication > Providers

## Fonctionnalités

### Service d'Authentification (`AuthService`)

Le service `AuthService` fournit les méthodes suivantes :

- `signUp()` : Inscription avec email/mot de passe
- `signIn()` : Connexion avec email/mot de passe
- `signInWithGoogle()` : Connexion avec Google
- `signInWithFacebook()` : Connexion avec Facebook
- `signInWithApple()` : Connexion avec Apple
- `signOut()` : Déconnexion
- `resetPassword()` : Réinitialisation de mot de passe

### Gestion des Sessions

L'application utilise un `AuthWrapper` qui :
- Écoute les changements d'état d'authentification
- Redirige automatiquement vers la page de connexion si l'utilisateur n'est pas connecté
- Redirige automatiquement vers la page d'accueil si l'utilisateur est connecté

### Pages d'Authentification

#### Page de Connexion (`LoginPage`)
- Formulaire de connexion avec email/mot de passe
- Boutons de connexion sociale (Google, Facebook, Apple)
- Lien vers la page d'inscription
- Gestion des erreurs avec SnackBar

#### Page d'Inscription (`SignUpPage`)
- Formulaire d'inscription avec nom, email et mot de passe
- Validation des champs
- Boutons d'inscription sociale
- Lien vers la page de connexion

#### Page d'Accueil (`HomePage`)
- Bouton de déconnexion dans le menu utilisateur
- Affichage des informations utilisateur

## Utilisation

### Connexion
1. L'utilisateur ouvre l'application
2. Si non connecté, il est redirigé vers la page de connexion
3. Il peut se connecter avec email/mot de passe ou via un provider social
4. Après connexion réussie, il est automatiquement redirigé vers la page d'accueil

### Inscription
1. L'utilisateur clique sur "Sign Up" depuis la page de connexion
2. Il remplit le formulaire d'inscription
3. Après inscription réussie, il reçoit un message de confirmation
4. Il est redirigé vers la page de connexion pour se connecter

### Déconnexion
1. L'utilisateur clique sur l'icône de profil dans la page d'accueil
2. Il sélectionne "Déconnexion"
3. Il est automatiquement redirigé vers la page de connexion

## Gestion des Erreurs

Toutes les opérations d'authentification incluent une gestion d'erreur :
- Validation des champs avant envoi
- Affichage des erreurs via SnackBar
- Messages d'erreur en français
- Gestion des états de chargement

## Sécurité

- Les mots de passe sont validés côté client (minimum 6 caractères)
- Les sessions sont gérées automatiquement par Supabase
- Les tokens d'authentification sont sécurisés
- Les redirections OAuth utilisent des schémas personnalisés

## Dépendances

Les dépendances nécessaires sont déjà configurées dans `pubspec.yaml` :
- `supabase_flutter: ^2.0.0`
- `flutter_dotenv: ^5.1.0` 