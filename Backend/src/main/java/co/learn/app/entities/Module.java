package co.learn.app.entities;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Module {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    private String videoUrl; // Youtube Link

    @Column(length = 5000) // Allow long text
    private String content; // The lesson text

    private boolean isLocked; // For "Adaptive" learning
}