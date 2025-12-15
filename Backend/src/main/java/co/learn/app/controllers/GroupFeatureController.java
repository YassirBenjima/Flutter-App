package co.learn.app.controllers;

import co.learn.app.entities.*;
import co.learn.app.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/groups")
public class GroupFeatureController {

    @Autowired
    private StudyGroupRepository groupRepository;
    @Autowired
    private GroupTaskRepository taskRepository;
    @Autowired
    private GroupEventRepository eventRepository;
    @Autowired
    private GroupResourceRepository resourceRepository;
    @Autowired
    private UserRepository userRepository;

    // --- TASKS ---
    @GetMapping("/{groupId}/tasks")
    public List<GroupTask> getTasks(@PathVariable Long groupId) {
        return taskRepository.findByGroup_Id(groupId);
    }

    @PostMapping("/{groupId}/tasks")
    public ResponseEntity<?> addTask(@PathVariable Long groupId, @RequestBody GroupTask task) {
        Optional<StudyGroup> group = groupRepository.findById(groupId);
        if (group.isPresent()) {
            task.setGroup(group.get());
            task.setStatus("TODO");
            return ResponseEntity.ok(taskRepository.save(task));
        }
        return ResponseEntity.notFound().build();
    }

    @PutMapping("/tasks/{taskId}")
    public ResponseEntity<?> updateTaskStatus(@PathVariable Long taskId, @RequestBody Map<String, String> payload) {
        Optional<GroupTask> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isPresent()) {
            GroupTask task = taskOpt.get();
            if (payload.containsKey("status")) {
                task.setStatus(payload.get("status"));
            }
            return ResponseEntity.ok(taskRepository.save(task));
        }
        return ResponseEntity.notFound().build();
    }

    // --- EVENTS ---
    @GetMapping("/{groupId}/events")
    public List<GroupEvent> getEvents(@PathVariable Long groupId) {
        return eventRepository.findByGroup_IdOrderByStartTimeAsc(groupId);
    }

    @PostMapping("/{groupId}/events")
    public ResponseEntity<?> addEvent(@PathVariable Long groupId, @RequestBody GroupEvent event) {
        Optional<StudyGroup> group = groupRepository.findById(groupId);
        if (group.isPresent()) {
            event.setGroup(group.get());
            return ResponseEntity.ok(eventRepository.save(event));
        }
        return ResponseEntity.notFound().build();
    }

    // --- RESOURCES ---
    @GetMapping("/{groupId}/resources")
    public List<GroupResource> getResources(@PathVariable Long groupId) {
        return resourceRepository.findByGroup_Id(groupId);
    }

    @PostMapping("/{groupId}/resources")
    public ResponseEntity<?> addResource(@PathVariable Long groupId, @RequestBody GroupResource resource) {
        Optional<StudyGroup> group = groupRepository.findById(groupId);
        if (group.isPresent()) {
            resource.setGroup(group.get());
            // Default type if missing
            if (resource.getType() == null)
                resource.setType("LINK");
            return ResponseEntity.ok(resourceRepository.save(resource));
        }
        return ResponseEntity.notFound().build();
    }
}
