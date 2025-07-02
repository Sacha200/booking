import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// ici on définit le state de la page de signup
class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
  bool _agree = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              const Text(
                "Fill your information below or register\nwith your social account.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Champ de texte pour le nom
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "John Doe",
                  filled: true,
                  fillColor: Color.fromARGB(255, 237, 237, 237),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),              
              ),
              const SizedBox(height: 16),
              // Champ de texte pour l'email
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "john.doe@gmail.com",
                  filled: true,
                  fillColor: Color.fromARGB(255, 237, 237, 237),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Champ de texte pour le mot de passe
              TextField(
               obscureText: _obscurePassword,
               decoration: InputDecoration(
                labelText: "Password",
                hintText: "********",
                filled: true,
                fillColor: Color.fromARGB(255, 237, 237, 237),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
               ),
              ),
              const SizedBox(height: 16),
              // Case à cocher
              Row(
                children: [
                  Checkbox(
                    value: _agree,
                    onChanged: (value) {
                      setState(() {
                        _agree = value ?? false;
                      });
                    }
                  ),
                  const Text("I agree to the terms and conditions"),
                  GestureDetector(
                    onTap: () {

                    },
                    child: const Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        color: Color(0xFF1D6EFD),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
                ),
                const SizedBox(height: 24),
                // Bouton de création de compte
                ElevatedButton(
                  onPressed: _agree ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D6EFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Or continue with"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                // Boutons sociaux
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(Icons.apple, () {}),
                    const SizedBox(width: 16),
                    _buildSocialButton(Icons.g_mobiledata, () {}),
                    const SizedBox(width: 16),
                    _buildSocialButton(Icons.facebook, () {}),
                  ],
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        // Naviguer vers la page de connexion
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xFF1D6EFD),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
          ),
        ),
      ),
    );
  }
  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }
}