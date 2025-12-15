package co.learn.app.repositories;

import co.learn.app.entities.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByCourse_IdOrderByCreatedAtDesc(Long courseId);
}
