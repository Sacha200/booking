import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Charger les variables d'environnement
await dotenv.load(fileName: ".env");



  runApp(MaterialApp(
    home: WelcomePage(),
    theme: ThemeData(
      primaryColor: Color(0xFF1D6EFD),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color(0xFF1D6EFD),
        secondary: Color(0xFF1D6EFD),
      ),
      checkboxTheme: CheckboxThemeData(
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: Color(0xFF1D6EFD)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1D6EFD)),
        ),
      ),
    ),
  ));
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Image arrondie et centrée
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Bordure décalée
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      width: 180,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(90),
                        border: Border.all(
                          color: Color(0xFF1D6EFD),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  // Image ovale
                  Container(
                    width: 180,
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.asset(
                        'assets/hotel.jpg',
                        fit: BoxFit.cover,
                        width: 180,
                        height: 250,
                      ),
                    ),
                  ),
                  // Bouton rond avec flèche
                  Positioned(
                    bottom: 16, // Décalage depuis le bas de l'image
                    right: 16,  // Décalage depuis la droite de l'image
                    child: Material(
                      color: Color(0xFF1D6EFD),
                      shape: const CircleBorder(),
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          // Action du bouton
                        },
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
              const SizedBox(height: 48),
            // Titre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(text: "Find Your "),
                    TextSpan(
                      text: "Perfect Stay",
                      style: TextStyle(
                        color: Color(0xFF1D6EFD), // Couleur personnalisée
                      ),
                    ),
                    TextSpan(text: " with\nOur Curated Selection"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Explore a variety hotels tailored to your preferences and needs, ensuring a perfect match for every trip.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Indicateur de page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(isActive: true),
                const SizedBox(width: 8),
                _buildDot(isActive: false),
                const SizedBox(width: 8),
                _buildDot(isActive: false),
              ],
            ),
            const Spacer(),
            // Bouton principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D6EFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black26,
                  ),
                  child: const Text(
                    "Start Your Journey",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lien de connexion
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour les points de l'indicateur
  static Widget _buildDot({required bool isActive}) {
    return Container(
      width: isActive ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

