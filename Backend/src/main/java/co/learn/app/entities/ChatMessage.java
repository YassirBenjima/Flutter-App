package co.learn.app.entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "chat_messages")
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String senderName; // Store name snapshot or link to User

    @Column(columnDefinition = "TEXT")
    private String content;

    private LocalDateTime timestamp;

    // Use a simple string identifier for group mapping to simplify,
    // or link to StudyGroup entity. Linking is better.
    // For simplicity with the mocked frontend sending "groupName",
    // we will store the groupName or link to StudyGroup.
    // Let's link to StudyGroup for correctness.

    @ManyToOne
    @JoinColumn(name = "group_id")
    private StudyGroup group;

    public ChatMessage() {
    }

    public ChatMessage(String senderName, String content, StudyGroup group) {
        this.senderName = senderName;
        this.content = content;
        this.group = group;
        this.timestamp = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public StudyGroup getGroup() {
        return group;
    }

    public void setGroup(StudyGroup group) {
        this.group = group;
    }
}
