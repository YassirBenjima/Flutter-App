import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080';
  
  // Méthode pour enregistrer un utilisateur
  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fullName': fullName,
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur lors de l\'enregistrement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
  
  // Méthode pour connecter un utilisateur
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur lors de la connexion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Demande de réinitialisation du mot de passe
  static Future<void> requestPasswordReset({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Erreur lors de la demande: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Vérifier le code OTP
  static Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-reset-code'),
        headers: { 'Content-Type': 'application/json' },
        body: json.encode({ 'email': email, 'code': code }),
      );
      if (response.statusCode != 200) {
        throw Exception('Code invalide ou expiré');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Confirmer la réinitialisation avec code
  static Future<void> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/confirm-reset-password'),
        headers: { 'Content-Type': 'application/json' },
        body: json.encode({ 'email': email, 'code': code, 'newPassword': newPassword }),
      );
      if (response.statusCode != 200) {
        throw Exception('Échec de la réinitialisation');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Connexion avec Google
  static Future<Map<String, dynamic>> loginWithGoogle({
    required String idToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/oauth/google'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'idToken': idToken,
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur lors de la connexion Google: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
