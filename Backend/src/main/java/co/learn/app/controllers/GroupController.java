package co.learn.app.controllers;

import co.learn.app.entities.StudyGroup;
import co.learn.app.entities.User;
import co.learn.app.repositories.StudyGroupRepository;
import co.learn.app.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/groups")
public class GroupController {

    @Autowired
    private StudyGroupRepository groupRepository;

    @Autowired
    private UserRepository userRepository;

    // Get groups for a specific user
    @GetMapping
    public List<StudyGroup> getUserGroups(@RequestParam Long userId) {
        return groupRepository.findByMembers_Id(userId);
    }

    @PostMapping("/create")
    public ResponseEntity<?> createGroup(@RequestBody Map<String, Object> payload) {
        String name = (String) payload.get("name");
        String nextSession = (String) payload.get("nextSession");
        Long userId = ((Number) payload.get("userId")).longValue();

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return ResponseEntity.status(404).body("User not found");
        }

        StudyGroup group = new StudyGroup();
        group.setName(name);
        group.setNextSession(nextSession);
        group.setColor("0xFF2196F3");
        group.setIcon("code");

        String slug = name.toLowerCase().replaceAll("\\s+", "-");
        // Add random suffix to ensure uniqueness
        String suffix = java.util.UUID.randomUUID().toString().substring(0, 4);
        group.setInviteLink("colearn.app/join/" + slug + "-" + suffix);

        // Add creator as member AND admin
        group.addMember(userOpt.get());
        group.setAdmin(userOpt.get());

        return ResponseEntity.ok(groupRepository.save(group));
    }

    @PostMapping("/join")
    public ResponseEntity<?> joinGroup(@RequestBody Map<String, Object> payload) {
        String inviteLink = (String) payload.get("inviteLink");
        Long userId = ((Number) payload.get("userId")).longValue();

        String query = inviteLink;
        if (inviteLink.contains("join/")) {
            query = inviteLink.split("join/")[1];
        }

        final String search = query.toLowerCase();
        List<StudyGroup> allGroups = groupRepository.findAll();

        Optional<StudyGroup> match = allGroups.stream()
                .filter(g -> g.getInviteLink().contains(search) || g.getName().toLowerCase().contains(search))
                .findFirst();

        if (match.isPresent()) {
            StudyGroup group = match.get();
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isPresent()) {
                group.addMember(userOpt.get());
                groupRepository.save(group);
                return ResponseEntity.ok(group);
            }
            return ResponseEntity.status(404).body(Map.of("message", "User introuvable."));
        } else {
            return ResponseEntity.status(404).body(Map.of("message", "Groupe introuvable."));
        }
    }

    // --- ADMIN ACTIONS ---

    @GetMapping("/{groupId}/details")
    public ResponseEntity<?> getGroupDetails(@PathVariable Long groupId) {
        return groupRepository.findById(groupId).map(group -> {
            Map<String, Object> response = new java.util.HashMap<>();
            response.put("id", group.getId());
            response.put("name", group.getName());
            response.put("inviteLink", group.getInviteLink());
            response.put("adminId", group.getAdmin() != null ? group.getAdmin().getId() : null);
            response.put("members", group.getMembers());
            return ResponseEntity.ok(response);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("/{groupId}/kick")
    public ResponseEntity<?> kickMember(@PathVariable Long groupId, @RequestBody Map<String, Long> payload) {
        Long adminId = payload.get("adminId");
        Long userIdToKick = payload.get("userId");

        Optional<StudyGroup> groupOpt = groupRepository.findById(groupId);
        if (groupOpt.isPresent()) {
            StudyGroup group = groupOpt.get();
            // Verify Admin
            if (group.getAdmin() != null && group.getAdmin().getId().equals(adminId)) {
                // Remove Member
                group.getMembers().removeIf(u -> u.getId().equals(userIdToKick));
                groupRepository.save(group);
                return ResponseEntity.ok(Map.of("message", "User kicked"));
            }
            return ResponseEntity.status(403).body("Not authorized");
        }
        return ResponseEntity.notFound().build();
    }
}
