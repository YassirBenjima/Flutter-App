package co.learn.app.entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "group_events")
public class GroupEvent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String link; // Zoom/Meet link
    private LocalDateTime startTime;

    @ManyToOne
    @JoinColumn(name = "group_id")
    private StudyGroup group;

    public GroupEvent() {
    }

    public GroupEvent(String title, String link, LocalDateTime startTime, StudyGroup group) {
        this.title = title;
        this.link = link;
        this.startTime = startTime;
        this.group = group;
    }

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public StudyGroup getGroup() {
        return group;
    }

    public void setGroup(StudyGroup group) {
        this.group = group;
    }
}
