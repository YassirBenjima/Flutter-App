package co.learn.app.controllers;

import co.learn.app.entities.ChatMessage;
import co.learn.app.entities.StudyGroup;
import co.learn.app.repositories.ChatMessageRepository;
import co.learn.app.repositories.StudyGroupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/chat")
public class ChatController {

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    @Autowired
    private StudyGroupRepository groupRepository;

    @GetMapping("/{groupName}")
    public ResponseEntity<?> getMessages(@PathVariable String groupName) {
        Optional<StudyGroup> groupOpt = groupRepository.findByName(groupName);
        if (groupOpt.isEmpty()) {
            return ResponseEntity.ok(List.of()); // No messages if group invalid
        }

        List<ChatMessage> messages = chatMessageRepository.findByGroupIdOrderByTimestampAsc(groupOpt.get().getId());

        // Transform to format frontend expects: { "text": "...", "sender": "...",
        // "isMe": bool }
        // Check if message is from current user
        // For this fix without full Auth context on frontend calls (using 'Moi'
        // locally),
        // we'll return raw data and let frontend decide "isMe" based on sender name?
        // Actually frontend sends 'sender' name.

        var dtos = messages.stream().map(msg -> Map.of(
                "text", msg.getContent(),
                "sender", msg.getSenderName(),
                "timestamp", msg.getTimestamp().toString())).toList();

        return ResponseEntity.ok(dtos);
    }

    @PostMapping
    public ResponseEntity<?> sendMessage(@RequestBody Map<String, String> payload) {
        String groupName = payload.get("groupName");
        String content = payload.get("content");
        String sender = payload.get("sender"); // "Moi" or Name

        Optional<StudyGroup> groupOpt = groupRepository.findByName(groupName);
        if (groupOpt.isPresent()) {
            ChatMessage msg = new ChatMessage(sender, content, groupOpt.get());
            chatMessageRepository.save(msg);
            return ResponseEntity.ok(Map.of("status", "saved"));
        } else {
            return ResponseEntity.status(404).body("Group not found");
        }
    }
}
