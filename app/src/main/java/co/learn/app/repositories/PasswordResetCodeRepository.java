package co.learn.app.repositories;

import co.learn.app.entities.PasswordResetCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PasswordResetCodeRepository extends JpaRepository<PasswordResetCode, Long> {
    Optional<PasswordResetCode> findTopByEmailAndCodeAndUsedFalseOrderByExpiresAtDesc(String email, String code);
    void deleteByEmail(String email);
}


