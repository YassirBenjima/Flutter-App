package co.learn.app.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "group_tasks")
public class GroupTask {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String status; // TODO, DOING, DONE

    @ManyToOne
    @JoinColumn(name = "group_id")
    private StudyGroup group;

    public GroupTask() {
    }

    public GroupTask(String title, String status, StudyGroup group) {
        this.title = title;
        this.status = status;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public StudyGroup getGroup() {
        return group;
    }

    public void setGroup(StudyGroup group) {
        this.group = group;
    }
}
