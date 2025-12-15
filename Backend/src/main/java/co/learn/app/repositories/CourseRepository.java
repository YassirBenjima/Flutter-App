package co.learn.app.repositories;

import co.learn.app.entities.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CourseRepository extends JpaRepository<Course, Long> {
    List<Course> findByCreator_Id(Long userId);

    List<Course> findByCreator_Role(String role);

    List<Course> findByTitleContainingIgnoreCaseAndOriginalCourseIdIsNull(String title); // Search ONLY original courses

    Course findByCreator_IdAndOriginalCourseId(Long userId, Long originalCourseId);
}