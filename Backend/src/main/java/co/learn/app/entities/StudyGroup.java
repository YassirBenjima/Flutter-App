package co.learn.app.entities;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "study_groups")
public class StudyGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String nextSession; // e.g., "Demain, 10:00"
    private String icon; // Icon name as string, e.g., "code"
    private String color; // Hex code or valid string

    // Derived from name usually, but can be explicit
    @Column(unique = true)
    private String inviteLink;

    @ManyToOne
    @JoinColumn(name = "admin_id")
    private User admin;

    @ManyToMany
    @JoinTable(name = "group_members", joinColumns = @JoinColumn(name = "group_id"), inverseJoinColumns = @JoinColumn(name = "user_id"))
    private Set<User> members = new HashSet<>();

    public StudyGroup() {
    }

    public StudyGroup(String name, String nextSession, String icon, String color, String inviteLink) {
        this.name = name;
        this.nextSession = nextSession;
        this.icon = icon;
        this.color = color;
        this.inviteLink = inviteLink;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNextSession() {
        return nextSession;
    }

    public void setNextSession(String nextSession) {
        this.nextSession = nextSession;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getInviteLink() {
        return inviteLink;
    }

    public void setInviteLink(String inviteLink) {
        this.inviteLink = inviteLink;
    }

    public Set<User> getMembers() {
        return members;
    }

    public void setMembers(Set<User> members) {
        this.members = members;
    }

    public void addMember(User user) {
        this.members.add(user);
    }

    public User getAdmin() {
        return admin;
    }

    public void setAdmin(User admin) {
        this.admin = admin;
    }
}
