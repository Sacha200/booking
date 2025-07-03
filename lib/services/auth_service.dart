import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Initialiser Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://fjtrlacpwhcijcfqnnlv.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqdHJsYWNwd2hjaWpjZnFubmx2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE0NDgxMTQsImV4cCI6MjA2NzAyNDExNH0.66bkCwJV4sSwhu5Q4g0LkJIoYvUoRdVKG-bsxj9khP0',
    );
  }

  // Obtenir l'utilisateur actuel
  static User? get currentUser => _supabase.auth.currentUser;

  // Stream pour écouter les changements d'authentification
  static Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Inscription avec email et mot de passe
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Connexion avec email et mot de passe
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Connexion avec Google
  static Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback/',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Connexion avec Facebook
  static Future<void> signInWithFacebook() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.flutter://login-callback/',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Connexion avec Apple
  static Future<void> signInWithApple() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.flutter://login-callback/',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Réinitialiser le mot de passe
  static Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback/',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Vérifier si l'utilisateur est connecté
  static bool get isAuthenticated => currentUser != null;
} 