package co.learn.app.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "group_resources")
public class GroupResource {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String url;
    private String type; // LINK, PDF, VIDEO

    @ManyToOne
    @JoinColumn(name = "group_id")
    private StudyGroup group;

    public GroupResource() {
    }

    public GroupResource(String title, String url, String type, StudyGroup group) {
        this.title = title;
        this.url = url;
        this.type = type;
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

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public StudyGroup getGroup() {
        return group;
    }

    public void setGroup(StudyGroup group) {
        this.group = group;
    }
}
