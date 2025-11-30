package co.learn.app.entities;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "users")
@Data
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String fullName;

    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(nullable = true)
    private String password; // Nullable for OAuth users
    
    @Column(nullable = true)
    private String provider; // "local", "google", "github"
    
    @Column(nullable = true)
    private String providerId; // ID from OAuth provider (Google/GitHub)
    
    @Column(nullable = true)
    private String avatarUrl; // Profile picture URL from OAuth
}
