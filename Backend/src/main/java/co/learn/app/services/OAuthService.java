package co.learn.app.services;

import co.learn.app.entities.User;
import co.learn.app.repositories.UserRepository;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
public class OAuthService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordService passwordService;
    
    @Value("${oauth.google.client-id:}")
    private String googleClientId;
    
    // Google OAuth - Verify token and get user info
    public Map<String, Object> verifyGoogleToken(String idTokenString) throws Exception {
        // If client ID is not configured, skip verification (for development)
        if (googleClientId == null || googleClientId.isEmpty() || googleClientId.equals("YOUR_GOOGLE_CLIENT_ID")) {
            // Decode token without verification (only for development)
            // In production, you should always verify the token
            throw new Exception("Google Client ID non configuré. Veuillez configurer oauth.google.client-id dans application.properties");
        }
        
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(), 
                new GsonFactory())
                .setAudience(Collections.singletonList(googleClientId))
                .build();
        
        GoogleIdToken idToken = verifier.verify(idTokenString);
        if (idToken != null) {
            GoogleIdToken.Payload payload = idToken.getPayload();
            
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            String picture = (String) payload.get("picture");
            String userId = payload.getSubject();
            
            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("email", email);
            userInfo.put("fullName", name);
            userInfo.put("avatarUrl", picture);
            userInfo.put("providerId", userId);
            userInfo.put("provider", "google");
            
            return userInfo;
        }
        throw new Exception("Token Google invalide");
    }
    
    // Register or login with OAuth
    public User authenticateOAuth(Map<String, Object> userInfo) {
        String email = (String) userInfo.get("email");
        String provider = (String) userInfo.get("provider");
        String providerId = (String) userInfo.get("providerId");
        
        // Check if user exists by email
        Optional<User> existingUser = userRepository.findByEmail(email);
        
        if (existingUser.isPresent()) {
            User user = existingUser.get();
            // Update provider info if not set
            if (user.getProvider() == null || !user.getProvider().equals(provider)) {
                user.setProvider(provider);
                user.setProviderId(providerId);
                if (userInfo.containsKey("avatarUrl")) {
                    user.setAvatarUrl((String) userInfo.get("avatarUrl"));
                }
                return userRepository.save(user);
            }
            return user;
        } else {
            // Create new user
            User newUser = new User();
            newUser.setEmail(email);
            newUser.setFullName((String) userInfo.get("fullName"));
            newUser.setProvider(provider);
            newUser.setProviderId(providerId);
            newUser.setPassword(passwordService.hashPassword(providerId)); // Dummy password for OAuth users
            if (userInfo.containsKey("avatarUrl")) {
                newUser.setAvatarUrl((String) userInfo.get("avatarUrl"));
            }
            return userRepository.save(newUser);
        }
    }
}

