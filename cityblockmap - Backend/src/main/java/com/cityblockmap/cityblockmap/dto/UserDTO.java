package com.cityblockmap.cityblockmap.dto;

import com.cityblockmap.cityblockmap.model.Neighborhood;
import com.cityblockmap.cityblockmap.model.UserRole;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {
    private Long id;

    @NotBlank(message = "login é obrigatório")
    private String login;

    @NotBlank(message = "password é obrigatório")
    private String password;

    @NotNull(message = "role é obrigatório")
    private UserRole role;

    private List<Neighborhood> neighborhood;
}
