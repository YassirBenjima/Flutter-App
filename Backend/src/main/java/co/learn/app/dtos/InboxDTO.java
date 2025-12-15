package co.learn.app.dtos;

import co.learn.app.entities.User;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class InboxDTO {
    private User partner;
    private String lastMessage;
    private LocalDateTime timestamp;

    public InboxDTO(User partner, String lastMessage, LocalDateTime timestamp) {
        this.partner = partner;
        this.lastMessage = lastMessage;
        this.timestamp = timestamp;
    }
}
