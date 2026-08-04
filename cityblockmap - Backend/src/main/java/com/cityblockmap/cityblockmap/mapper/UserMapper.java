package com.cityblockmap.cityblockmap.mapper;

import com.cityblockmap.cityblockmap.dto.UserDTO;
import com.cityblockmap.cityblockmap.model.User;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {
    public User map(UserDTO userDTO){
        User user = new User();

        user.setId(userDTO.getId());
        user.setLogin(userDTO.getLogin());
        user.setPassword(userDTO.getPassword());
        user.setRole(userDTO.getRole());
        user.setNeighborhoods(userDTO.getNeighborhood());

        return user;
    }

    public UserDTO map(User user) {
        UserDTO userDTO = new UserDTO();

        userDTO.setId(user.getId());
        userDTO.setLogin(user.getLogin());
        userDTO.setPassword(user.getPassword());
        userDTO.setRole(user.getRole());
        userDTO.setNeighborhood(user.getNeighborhoods());

        return userDTO;
    }
}
