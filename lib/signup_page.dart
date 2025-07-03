import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class SignUpPage extends StatefulWidget {

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// ici on définit le state de la page de signup
class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agree = false;
  bool _isLoading = false;
  
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
                controller: nameController,
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
                controller: emailController,
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
               controller: passwordController,
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
                  onPressed: _agree && !_isLoading ? _handleSignUp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D6EFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
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
                    _buildSocialButton("assets/apple.png", _handleAppleSignIn, size: 32),
                    const SizedBox(width: 16),
                    _buildSocialButton("assets/google.png", _handleGoogleSignIn),
                    const SizedBox(width: 16),
                    _buildSocialButton("assets/facebook.png", _handleFacebookSignIn),
                  ],
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                          Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
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
  Widget _buildSocialButton(String assetPath, VoidCallback onTap, {double size = 28 }) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(30),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Color(0xFFCDCDCD)),
      ),
      child: Image.asset(
        assetPath,
       width: size,
        height: size,
      ),
    ),
  );
}

  // Méthode pour gérer l'inscription avec email/mot de passe
  Future<void> _handleSignUp() async {
    if (nameController.text.isEmpty || 
        emailController.text.isEmpty || 
        passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez remplir tous les champs')),
        );
      }
      return;
    }

    if (passwordController.text.length < 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Le mot de passe doit contenir au moins 6 caractères')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        userData: {
          'name': nameController.text.trim(),
        },
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compte créé avec succès ! Vérifiez votre email.')),
        );
        
        // Retourner à la page de connexion
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'inscription: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Méthode pour gérer l'inscription avec Google
  Future<void> _handleGoogleSignIn() async {
    try {
      await AuthService.signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion Google: ${e.toString()}')),
        );
      }
    }
  }

  // Méthode pour gérer l'inscription avec Facebook
  Future<void> _handleFacebookSignIn() async {
    try {
      await AuthService.signInWithFacebook();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion Facebook: ${e.toString()}')),
        );
      }
    }
  }

  // Méthode pour gérer l'inscription avec Apple
  Future<void> _handleAppleSignIn() async {
    try {
      await AuthService.signInWithApple();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion Apple: ${e.toString()}')),
        );
      }
    }
  }
}