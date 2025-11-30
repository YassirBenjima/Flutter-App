import 'package:google_sign_in/google_sign_in.dart';

class OAuthFlutterService {
  // Google Sign In
  // Client ID: 649765104219-kp3f49l63csvdcaraijqvqjcpm5oemc0.apps.googleusercontent.com
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Client ID pour le web - doit correspondre au Web Client ID dans Google Cloud Console
    // IMPORTANT: Configurez les Authorized redirect URIs dans Google Cloud Console
    // Exemple: http://localhost:60673, http://127.0.0.1:60673, etc.
    clientId: '649765104219-kp3f49l63csvdcaraijqvqjcpm5oemc0.apps.googleusercontent.com',
  );

  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return null; // User cancelled
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      
      return {
        'idToken': auth.idToken,
        'accessToken': auth.accessToken,
        'email': account.email,
        'displayName': account.displayName,
        'photoUrl': account.photoUrl,
      };
    } catch (e) {
      throw Exception('Erreur lors de la connexion Google: $e');
    }
  }

  static Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}

