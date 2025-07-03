import qrcode
import socket
from PIL import Image

def get_local_ip():
    """Obtenir l'adresse IP locale"""
    try:
        # Se connecter à un serveur externe pour obtenir l'IP locale
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except:
        return "localhost"

def generate_qr_code():
    """Générer un QR code pour l'application Flutter web"""
    local_ip = get_local_ip()
    url = f"http://{local_ip}:8080"
    
    print(f"🌐 Votre application est accessible à l'adresse: {url}")
    print("📱 Scannez le QR code ci-dessous avec votre téléphone:")
    
    # Créer le QR code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)
    
    # Créer l'image
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Sauvegarder l'image
    img.save("flutter_app_qr.png")
    print("✅ QR code généré et sauvegardé dans 'flutter_app_qr.png'")
    
    # Afficher l'URL
    print(f"\n🔗 URL directe: {url}")
    print("💡 Assurez-vous que votre téléphone et votre ordinateur sont sur le même réseau WiFi")

if __name__ == "__main__":
    generate_qr_code() 