package co.learn.app.controllers;

import co.learn.app.entities.User;
import co.learn.app.repositories.UserRepository;
import co.learn.app.services.PasswordService;
import co.learn.app.services.OAuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import co.learn.app.services.PasswordResetService;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordService passwordService;
    @Autowired
    private PasswordResetService passwordResetService;
    @Autowired
    private OAuthService oAuthService;

    @PostMapping("/register")
    public User Register(@RequestBody User user) {
        // Hasher le mot de passe avant de le sauvegarder (si présent)
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            String hashedPassword = passwordService.hashPassword(user.getPassword());
            user.setPassword(hashedPassword);
            user.setProvider("local");
        }
        return userRepository.save(user);
    }

    @PostMapping("/login")
    public User Login(@RequestBody User user) {
        // Chercher l'utilisateur par email
        var optionalUser = userRepository.findByEmail(user.getEmail());

        if (optionalUser.isPresent()) {
            User foundUser = optionalUser.get();
            // Vérifier le mot de passe avec le hash stocké
            if (passwordService.verifyPassword(user.getPassword(), foundUser.getPassword())) {
                return foundUser;
            }
        }

        // Retourner null si l'utilisateur n'existe pas ou si le mot de passe est
        // incorrect
        return null;
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody java.util.Map<String, String> payload) {
        String email = payload.get("email");
        passwordResetService.createAndSendCode(email);
        return ResponseEntity.ok(java.util.Map.of(
                "message", "Si un compte existe, un code a été envoyé."));
    }

    // legacy /reset-password removed (token-based)

    @PostMapping("/verify-reset-code")
    public ResponseEntity<?> verifyResetCode(@RequestBody java.util.Map<String, String> payload) {
        String email = payload.get("email");
        String code = payload.get("code");
        boolean ok = passwordResetService.verifyCode(email, code);
        if (ok)
            return ResponseEntity.ok(java.util.Map.of("message", "Code valide"));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(java.util.Map.of("message", "Code invalide ou expiré"));
    }

    @PostMapping("/confirm-reset-password")
    public ResponseEntity<?> confirmResetPassword(@RequestBody java.util.Map<String, String> payload) {
        String email = payload.get("email");
        String code = payload.get("code");
        String newPassword = payload.get("newPassword");
        boolean ok = passwordResetService.confirmResetWithCode(email, code, newPassword);
        if (ok)
            return ResponseEntity.ok(java.util.Map.of("message", "Mot de passe mis à jour"));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(java.util.Map.of("message", "Code invalide ou expiré"));
    }

    @PostMapping("/oauth/google")
    public ResponseEntity<?> loginWithGoogle(@RequestBody Map<String, String> payload) {
        try {
            String idToken = payload.get("idToken");
            Map<String, Object> userInfo = oAuthService.verifyGoogleToken(idToken);
            User user = oAuthService.authenticateOAuth(userInfo);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(java.util.Map.of("message", "Erreur OAuth Google: " + e.getMessage()));
        }
    }

    @PutMapping("/users/{id}")
    public ResponseEntity<?> updateUser(@PathVariable Long id, @RequestBody User userDetails) {
        return userRepository.findById(id).map(user -> {
            boolean updated = false;

            // Update Full Name
            if (userDetails.getFullName() != null && !userDetails.getFullName().isEmpty()) {
                user.setFullName(userDetails.getFullName());
                updated = true;
            }

            // Update Password (Hash it!)
            if (userDetails.getPassword() != null && !userDetails.getPassword().isEmpty()) {
                String hashedPassword = passwordService.hashPassword(userDetails.getPassword());
                user.setPassword(hashedPassword);
                updated = true;
            }

            if (updated) {
                userRepository.save(user);
                return ResponseEntity.ok(user);
            } else {
                return ResponseEntity.ok(user); // No changes
            }
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

}
