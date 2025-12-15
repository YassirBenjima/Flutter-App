package co.learn.app.controllers;

import co.learn.app.entities.Message;
import co.learn.app.entities.User;
import co.learn.app.repositories.MessageRepository;
import co.learn.app.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/messages")
@CrossOrigin(origins = "*")
public class MessageController {

    @Autowired
    private MessageRepository messageRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/conversation")
    public List<Message> getConversation(@RequestParam Long user1, @RequestParam Long user2) {
        return messageRepository.findConversation(user1, user2);
    }

    @PostMapping
    public ResponseEntity<?> sendMessage(@RequestBody Map<String, Object> payload) {
        System.out.println("📨 SEND MESSAGE REQUEST: " + payload);
        String content = (String) payload.get("content");
        Long senderId = ((Number) payload.get("senderId")).longValue();
        Long receiverId = ((Number) payload.get("receiverId")).longValue();

        if (content == null || content.isEmpty()) {
            System.out.println("❌ Content empty");
            return ResponseEntity.badRequest().body("Content cannot be empty");
        }

        User sender = userRepository.findById(senderId).orElse(null);
        User receiver = userRepository.findById(receiverId).orElse(null);

        if (sender == null || receiver == null) {
            System.out.println("❌ Sender (" + senderId + ") or Receiver (" + receiverId + ") not found");
            return ResponseEntity.badRequest().body("Sender or Receiver not found");
        }

        Message message = new Message();
        message.setContent(content);
        message.setSender(sender);
        message.setReceiver(receiver);
        message.setSentAt(LocalDateTime.now());

        Message saved = messageRepository.save(message);
        System.out.println("✅ Message Saved! ID: " + saved.getId());
        return ResponseEntity.ok(saved);
    }

    @GetMapping("/inbox/{userId}")
    public List<Map<String, Object>> getInbox(@PathVariable Long userId) {
        System.out.println("📩 INBOX REQUEST for User ID: " + userId);
        List<Message> allMessages = messageRepository.findInboxMessages(userId);
        System.out.println("✅ Found " + allMessages.size() + " raw messages for inbox.");

        List<Map<String, Object>> inbox = new java.util.ArrayList<>();
        java.util.Set<Long> processedPartners = new java.util.HashSet<>();

        for (Message m : allMessages) {
            User partner = m.getSender().getId().equals(userId) ? m.getReceiver() : m.getSender();

            if (!processedPartners.contains(partner.getId())) {
                Map<String, Object> item = new java.util.HashMap<>();

                Map<String, Object> partnerMap = new java.util.HashMap<>();
                partnerMap.put("id", partner.getId());
                partnerMap.put("fullName", partner.getFullName());
                partnerMap.put("email", partner.getEmail());
                partnerMap.put("avatarUrl", partner.getAvatarUrl());

                item.put("partner", partnerMap);
                item.put("lastMessage", m.getContent());
                item.put("timestamp", m.getSentAt().toString());

                inbox.add(item);
                processedPartners.add(partner.getId());
            }
        }
        System.out.println("📤 Returning " + inbox.size() + " unique inbox items.");
        return inbox;
    }
}
