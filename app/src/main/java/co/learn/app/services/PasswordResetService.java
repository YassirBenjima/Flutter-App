package co.learn.app.services;

import co.learn.app.entities.PasswordResetCode;
import co.learn.app.entities.User;
import co.learn.app.repositories.PasswordResetCodeRepository;
import co.learn.app.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;
import java.util.UUID;

@Service
public class PasswordResetService {

    private final UserRepository userRepository;
    private final PasswordResetCodeRepository codeRepository;
    private final JavaMailSender mailSender;
    private final PasswordService passwordService;
    private static final Logger log = LoggerFactory.getLogger(PasswordResetService.class);

    @Value("${app.mail.from:${spring.mail.username}}")
    private String mailFrom;

    public PasswordResetService(UserRepository userRepository,
                                PasswordResetCodeRepository codeRepository,
                                JavaMailSender mailSender,
                                PasswordService passwordService) {
        this.userRepository = userRepository;
        this.codeRepository = codeRepository;
        this.mailSender = mailSender;
        this.passwordService = passwordService;
    }

    // ===== New OTP flow =====
    @Transactional
    public void createAndSendCode(String email) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        // For security, behave the same even if user not found
        // But if exists, create code and email
        if (userOpt.isPresent()) {
            codeRepository.deleteByEmail(email);
            PasswordResetCode code = new PasswordResetCode();
            code.setEmail(email);
            code.setCode(generateSixDigitCode());
            code.setExpiresAt(Instant.now().plus(15, ChronoUnit.MINUTES));
            codeRepository.save(code);

            log.info("Password reset code for email={} code={}", email, code.getCode());
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(email);
            if (mailFrom != null && !mailFrom.isBlank()) {
                message.setFrom(mailFrom);
            }
            message.setSubject("Code de réinitialisation");
            message.setText("Bonjour,\n\nVoici votre code de réinitialisation (valable 15 min) : " + code.getCode() + "\n\nSi vous n'êtes pas à l'origine de cette demande, ignorez cet e-mail.");
            try {
                mailSender.send(message);
            } catch (Exception e) {
                // Do not fail the request if mail server is unreachable in dev
                log.warn("Email sending failed for {}. Link printed above. Configure SMTP to enable emails. Error: {}", email, e.getMessage(), e);
            }
        }
    }

    @Transactional(readOnly = true)
    public boolean verifyCode(String email, String code) {
        Optional<PasswordResetCode> codeOpt = codeRepository.findTopByEmailAndCodeAndUsedFalseOrderByExpiresAtDesc(email, code);
        if (codeOpt.isEmpty()) return false;
        return codeOpt.get().getExpiresAt().isAfter(Instant.now());
    }

    @Transactional
    public boolean confirmResetWithCode(String email, String codeValue, String newPassword) {
        Optional<PasswordResetCode> codeOpt = codeRepository.findTopByEmailAndCodeAndUsedFalseOrderByExpiresAtDesc(email, codeValue);
        if (codeOpt.isEmpty()) return false;
        PasswordResetCode c = codeOpt.get();
        if (c.getExpiresAt().isBefore(Instant.now())) return false;
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) return false;
        User user = userOpt.get();
        user.setPassword(passwordService.hashPassword(newPassword));
        userRepository.save(user);
        c.setUsed(true);
        codeRepository.save(c);
        return true;
    }

    private String generateSixDigitCode() {
        int n = (int)(Math.random() * 900000) + 100000; // 100000-999999
        return String.valueOf(n);
    }

    // Legacy token path removed
}



