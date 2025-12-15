package co.learn.app.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String fullName;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = true)
    private String password;

    // --- Requirements from README (Don't forget these!) ---
    @Column(nullable = true)
    private String role; // "APPRENANT", "FORMATEUR", "ADMIN"

    @Column(nullable = true)
    private String expertiseLevel; // "Débutant", "Intermédiaire", "Expert"

    @Column(nullable = true)
    private String learningStyle; // "Visuel", "Auditif", "Pratique"

    // --- OAuth Fields (Keep these if you want) ---
    @Column(nullable = true)
    private String provider;

    @Column(nullable = true)
    private String providerId;

    @Column(nullable = true)
    private String avatarUrl;

    // --- MANUAL GETTERS AND SETTERS ---

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getExpertiseLevel() {
        return expertiseLevel;
    }

    public void setExpertiseLevel(String expertiseLevel) {
        this.expertiseLevel = expertiseLevel;
    }

    public String getLearningStyle() {
        return learningStyle;
    }

    public void setLearningStyle(String learningStyle) {
        this.learningStyle = learningStyle;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    // --- GAMIFICATION ---
    private int xp = 0;

    @ElementCollection(fetch = FetchType.EAGER)
    private java.util.Set<String> badges = new java.util.HashSet<>();

    public int getXp() {
        return xp;
    }

    public void setXp(int xp) {
        this.xp = xp;
    }

    public java.util.Set<String> getBadges() {
        return badges;
    }

    public void setBadges(java.util.Set<String> badges) {
        this.badges = badges;
    }
}