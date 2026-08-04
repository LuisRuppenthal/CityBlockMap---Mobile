package com.cityblockmap.cityblockmap.service;

import com.cityblockmap.cityblockmap.dto.UserDTO;
import com.cityblockmap.cityblockmap.mapper.UserMapper;
import com.cityblockmap.cityblockmap.model.User;
import com.cityblockmap.cityblockmap.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserService {

    @Autowired
    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, UserMapper userMapper, PasswordEncoder passwordEncoder){
        this.userRepository = userRepository;
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
    }

    //GET
    public List<UserDTO> getAllUsers(){
        List<User> users = userRepository.findAll();

        return users.stream()
                .map(userMapper::map)
                .collect(Collectors.toList());
    }


    public UserDTO getUserById(Long id) {
        Optional<User> user = userRepository.findById(id);
        return user.map(userMapper::map).orElse(null);
    }


    //CREATE
    public UserDTO createUser(UserDTO userDTO){
        User user = userMapper.map(userDTO);
        user.setId(null); //Para forçar ID a ser null
        user.setPassword(passwordEncoder.encode(userDTO.getPassword()));
        user = userRepository.save(user);
        return userMapper.map(user);
    }


    //UPDATE
    public UserDTO updateUser(Long id, UserDTO userDTO){
        Optional<User> user = userRepository.findById(id);

        if(user.isPresent()){
            User existingUser = user.get();

            if (userDTO.getLogin() != null){
                existingUser.setLogin(userDTO.getLogin());
            }
            if (userDTO.getPassword() != null){
                existingUser.setPassword(passwordEncoder.encode(userDTO.getPassword()));
            }
            if (userDTO.getRole() != null){
                existingUser.setRole(userDTO.getRole());
            }
            if (userDTO.getNeighborhood() != null){
                existingUser.setNeighborhoods(userDTO.getNeighborhood());
            }

            User savedUser = userRepository.save(existingUser);
            return userMapper.map(savedUser);
        }
        return null;
    }


    //DELETE
    public void deleteUserById(Long id){
        userRepository.deleteById(id);
    }
}
