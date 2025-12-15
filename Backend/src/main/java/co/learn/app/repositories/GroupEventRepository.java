package co.learn.app.repositories;

import co.learn.app.entities.GroupEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface GroupEventRepository extends JpaRepository<GroupEvent, Long> {
    List<GroupEvent> findByGroup_IdOrderByStartTimeAsc(Long groupId);
}
