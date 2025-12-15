package co.learn.app.repositories;

import co.learn.app.entities.GroupResource;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface GroupResourceRepository extends JpaRepository<GroupResource, Long> {
    List<GroupResource> findByGroup_Id(Long groupId);
}
