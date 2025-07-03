@echo off
echo ========================================
echo   Lancement de l'application Flutter Web
echo ========================================
echo.

echo 1. Installation des dependances Python...
pip install -r requirements.txt

echo.
echo 2. Lancement de l'application Flutter Web...
echo L'application sera accessible sur http://localhost:8080
echo.

start "Flutter Web" cmd /k "flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0"

echo 3. Attente du demarrage du serveur...
timeout /t 10 /nobreak > nul

echo.
echo 4. Generation du QR code...
python generate_qr.py

echo.
echo ========================================
echo   Instructions d'utilisation:
echo ========================================
echo 1. Ouvrez le fichier 'flutter_app_qr.png'
echo 2. Scannez le QR code avec votre telephone
echo 3. Assurez-vous que votre telephone et PC sont sur le meme WiFi
echo.
echo Appuyez sur une touche pour fermer...
pause > nul 