package co.learn.app.controllers;

import co.learn.app.entities.User;
import co.learn.app.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/leaderboard")
@CrossOrigin(origins = "*")
public class LeaderboardController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<Map<String, Object>> getLeaderboard() {
        return userRepository.findTop10ByOrderByXpDesc().stream().map(user -> {
            return Map.of(
                    "id", user.getId(),
                    "fullName", user.getFullName(),
                    "xp", user.getXp(),
                    "badges", user.getBadges(),
                    "avatarUrl", user.getAvatarUrl() != null ? user.getAvatarUrl() : "");
        }).collect(Collectors.toList());
    }
}
