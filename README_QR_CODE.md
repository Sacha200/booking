# 🚀 Lancement de l'application Flutter via QR Code

## 📋 Prérequis

- Flutter SDK installé
- Python 3.7+ installé
- Votre téléphone et votre ordinateur sur le même réseau WiFi

## 🎯 Méthodes de lancement

### Option 1: Script automatique (Recommandé)
```bash
# Double-cliquez sur le fichier
launch_flutter_web.bat
```

### Option 2: Commandes manuelles
```bash
# 1. Installer les dépendances Python
pip install -r requirements.txt

# 2. Lancer l'application Flutter Web
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0

# 3. Dans un autre terminal, générer le QR code
python generate_qr.py
```

## 📱 Utilisation

1. **Lancez l'application** avec l'une des méthodes ci-dessus
2. **Ouvrez le fichier** `flutter_app_qr.png` généré
3. **Scannez le QR code** avec votre téléphone
4. **Votre application s'ouvrira** dans le navigateur de votre téléphone

## 🔧 Dépannage

### L'application ne se charge pas sur le téléphone ?
- Vérifiez que votre téléphone et PC sont sur le même WiFi
- Vérifiez que le pare-feu Windows autorise les connexions sur le port 8080
- Essayez d'accéder directement à l'URL affichée dans le terminal

### Erreur de dépendances Python ?
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### L'application ne se lance pas ?
```bash
flutter doctor
flutter clean
flutter pub get
```

## 🌐 URL d'accès

L'application sera accessible à :
- **Local** : http://localhost:8080
- **Réseau** : http://[VOTRE_IP]:8080

## 📝 Notes importantes

- ⚠️ **Expo Go ne fonctionne pas avec Flutter** - Expo Go est pour React Native
- ✅ **Cette solution utilise Flutter Web** qui fonctionne sur tous les navigateurs
- 🔄 **L'application se recharge automatiquement** quand vous modifiez le code
- 📱 **Compatible avec tous les appareils** ayant un navigateur web

## 🎨 Personnalisation

Pour changer le port ou l'adresse :
1. Modifiez le fichier `generate_qr.py`
2. Changez la ligne `url = f"http://{local_ip}:8080"`
3. Relancez l'application avec le nouveau port 