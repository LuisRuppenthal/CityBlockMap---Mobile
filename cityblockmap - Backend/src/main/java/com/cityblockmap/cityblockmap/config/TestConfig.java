package com.cityblockmap.cityblockmap.config;

import com.cityblockmap.cityblockmap.model.Block;
import com.cityblockmap.cityblockmap.model.User;
import com.cityblockmap.cityblockmap.model.UserRole;
import com.cityblockmap.cityblockmap.repository.BlockRepository;
import com.cityblockmap.cityblockmap.model.Neighborhood;
import com.cityblockmap.cityblockmap.repository.NeighborhoodRepository;
import com.cityblockmap.cityblockmap.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.ArrayList;
import java.util.Arrays;

@Configuration
@Profile("test")
public class TestConfig implements CommandLineRunner {

    private final UserRepository userRepository;
    private final NeighborhoodRepository neighborhoodRepository;
    private final BlockRepository blockRepository;
    private final PasswordEncoder passwordEncoder;

    public TestConfig (UserRepository userRepository, NeighborhoodRepository neighborhoodRepository, BlockRepository blockRepository, PasswordEncoder passwordEncoder){
        this.userRepository = userRepository;
        this.neighborhoodRepository = neighborhoodRepository;
        this.blockRepository = blockRepository;
        this.passwordEncoder = passwordEncoder;
    }


    @Override
    public void run(String... args) throws Exception {

        User u1 = new User(null, "admin", passwordEncoder.encode("12345678"), UserRole.ADMIN, new ArrayList<>());
        User u2 = new User(null, "user", passwordEncoder.encode("87654321"), UserRole.USER, new ArrayList<>());


        /// //////////////////////////////////////////////////////////////////////////////////////////////////
        Neighborhood n1 = new Neighborhood(null, "Centro", new ArrayList<>(), new ArrayList<>());
        Neighborhood n2 = new Neighborhood(null, "Parque", new ArrayList<>(), new ArrayList<>());

        neighborhoodRepository.saveAll(Arrays.asList(n1,n2));

        u1.getNeighborhoods().add(n1);
        u1.getNeighborhoods().add(n2);
        u2.getNeighborhoods().add(n1);

        //OPCIONAL//
        //n1.getUsers().add(u1);
        //n1.getUsers().add(u2);
        //n2.getUsers().add(u1);

        userRepository.saveAll(Arrays.asList(u1, u2));


        /// //////////////////////////////////////////////////////////////////////////////////////////////////
        Block b1 = new Block(null, "Quadra 1", -11.1234, -11.1234, n1);
        Block b2 = new Block(null, "Quadra 2", -22.1234, -22.1234, n1);
        Block b3 = new Block(null, "Quadra 3", -33.1234, -33.1234, n2);
        Block b4 = new Block(null, "Quadra 4", -44.1234, -44.1234, n2);

        blockRepository.saveAll(Arrays.asList(b1, b2, b3, b4));
    }
}
