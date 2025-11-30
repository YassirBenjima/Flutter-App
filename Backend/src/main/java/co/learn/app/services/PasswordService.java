package co.learn.app.services;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class PasswordService {
    
    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    /**
     * Hache un mot de passe en utilisant BCrypt
     * @param rawPassword Le mot de passe en clair
     * @return Le mot de passe hashé
     */
    public String hashPassword(String rawPassword) {
        return passwordEncoder.encode(rawPassword);
    }
    
    /**
     * Vérifie si un mot de passe correspond au hash stocké
     * @param rawPassword Le mot de passe en clair
     * @param encodedPassword Le mot de passe hashé stocké
     * @return true si les mots de passe correspondent, false sinon
     */
    public boolean verifyPassword(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }
}
