package co.learn.app.repositories;

import co.learn.app.entities.StudyGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
import java.util.List;

public interface StudyGroupRepository extends JpaRepository<StudyGroup, Long> {
    Optional<StudyGroup> findByName(String name);

    List<StudyGroup> findByMembers_Id(Long userId);
}
