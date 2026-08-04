package com.cityblockmap.cityblockmap.config;

import com.cityblockmap.cityblockmap.model.User;
import com.cityblockmap.cityblockmap.model.UserRole;
import com.cityblockmap.cityblockmap.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.ArrayList;

@Configuration
@Profile("prod")
public class AdminInitializer implements CommandLineRunner {

    private static final String OLD_DEFAULT_HASH =
            "$2a$10$4pcmh5..weHu4ELoD.Qe/.DpBXqTDZHaKJ2IZ3I6Ev7reFt40vwBu";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${ADMIN_DEFAULT_PASSWORD:}")
    private String adminDefaultPassword;

    public AdminInitializer(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        if (adminDefaultPassword == null || adminDefaultPassword.isBlank()) {
            return;
        }

        UserDetails userDetails = userRepository.findByLogin("admin");
        String encodedPassword = passwordEncoder.encode(adminDefaultPassword);

        if (userDetails == null) {
            User newAdmin = new User(null, "admin", encodedPassword, UserRole.ADMIN, new ArrayList<>());
            userRepository.save(newAdmin);
            return;
        }

        User admin = (User) userDetails;

        if (admin.getPassword().equals(OLD_DEFAULT_HASH)) {
            admin.setPassword(encodedPassword);
            userRepository.save(admin);
        }
    }
}
