import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static String? _currentEmail;
  static String? _currentName;
  static String? _currentPassword;
  static bool _isAuthenticated = false;

  // Stockage local simulé (en mémoire)
  static final Map<String, Map<String, String>> _users = {};

  static String? get currentUser => _currentEmail;
  static bool get isAuthenticated => _isAuthenticated;

  // Inscription locale
  static Future<void> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    if (_users.containsKey(email)) {
      throw Exception('Cet email est déjà utilisé.');
    }
    _users[email] = {
      'password': password,
      'name': userData?['name'] ?? '',
    };
  }

  // Connexion locale
  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (!_users.containsKey(email) || _users[email]!['password'] != password) {
      throw Exception('Email ou mot de passe incorrect.');
    }
    _currentEmail = email;
    _currentName = _users[email]!['name'];
    _currentPassword = password;
    _isAuthenticated = true;
  }

  // Déconnexion
  static Future<void> signOut() async {
    _currentEmail = null;
    _currentName = null;
    _currentPassword = null;
    _isAuthenticated = false;
  }
} 