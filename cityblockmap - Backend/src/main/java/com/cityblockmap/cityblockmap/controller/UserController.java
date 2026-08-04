package com.cityblockmap.cityblockmap.controller;

import com.cityblockmap.cityblockmap.dto.UserDTO;
import com.cityblockmap.cityblockmap.repository.UserRepository;
import com.cityblockmap.cityblockmap.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private final UserService userService;
    private final UserRepository userRepository;

    public UserController(UserService userService, UserRepository userRepository){
        this.userService = userService;
        this.userRepository = userRepository;
    }

    //GET
    // /users/get
    @GetMapping("/get")
    public ResponseEntity<List<UserDTO>> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }


    // /users/get/{id}
    @GetMapping("get/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable("id") Long id) {

        if (userRepository.existsById(id)) {
            return ResponseEntity.ok().body(userService.getUserById(id));
        }
        return ResponseEntity.notFound().build();
    }


    // POST
    // /users/create
    @PostMapping("/create")
    public ResponseEntity<UserDTO> createUser(@Valid @RequestBody UserDTO userDTO) {
        userDTO.setId(null);
        UserDTO createdUser = userService.createUser(userDTO);

        URI uri = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(createdUser.getId())
                .toUri();

        return ResponseEntity.created(uri).body(createdUser);
    }


    // PUT
    // /users/{id}
    @PutMapping("/update/{id}")
    public ResponseEntity<UserDTO> updateUser(@PathVariable("id") Long id, @Valid @RequestBody UserDTO userDTO) {

        if (userRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.OK).body(userService.updateUser(id, userDTO));
        }
        return ResponseEntity.notFound().build();
    }

    // DELETE
    // /users/{id}
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteUserById(@PathVariable("id") Long id){
        if (userRepository.existsById(id)){
            userService.deleteUserById(id);
            return ResponseEntity.status(HttpStatus.OK).body("User (" + id + ") deletado");
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User ("+id+") não encontrado!");
    }
}
