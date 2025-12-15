package co.learn.app.controllers;

import co.learn.app.entities.User;
import co.learn.app.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/auth")
// CRITICAL: This allows your Flutter app (running on a different port) to talk
// to Spring Boot
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        // 1. Check if email exists
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            return ResponseEntity.badRequest().body("Email already exists");
        }

        // 2. Set default Avatar if none provided
        if (user.getAvatarUrl() == null || user.getAvatarUrl().isEmpty()) {
            user.setAvatarUrl("https://ui-avatars.com/api/?name=" + user.getFullName());
        }

        // 3. Save User
        User savedUser = userRepository.save(user);
        return ResponseEntity.ok(savedUser);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User loginRequest) {
        User user = userRepository.findByEmail(loginRequest.getEmail()).orElse(null);

        if (user == null || !user.getPassword().equals(loginRequest.getPassword())) {
            return ResponseEntity.status(401).body("Invalid email or password");
        }

        return ResponseEntity.ok(user);
    }

    // 1. Get All Users (For Admin Dashboard)
    @GetMapping("/users")
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // 2. Delete User (Admin action)
    @DeleteMapping("/users/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        if (!userRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        userRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/users/lookup")
    public ResponseEntity<?> searchUserByEmail(@RequestBody java.util.Map<String, String> payload) {
        String email = payload.get("email");
        if (email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().body(java.util.Map.of("message", "Email is required"));
        }

        return userRepository.findByEmail(email).map(user -> {
            // Return only public info
            return ResponseEntity.ok(java.util.Map.of(
                    "id", user.getId(),
                    "fullName", user.getFullName(),
                    "avatarUrl", user.getAvatarUrl() != null ? user.getAvatarUrl() : ""));
        }).orElseGet(() -> ResponseEntity.status(org.springframework.http.HttpStatus.NOT_FOUND)
                .body(java.util.Map.of("message", "User not found")));
    }
}