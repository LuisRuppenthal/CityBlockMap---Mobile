package com.cityblockmap.cityblockmap.dto;

import com.cityblockmap.cityblockmap.model.UserRole;

public record RegisterDTO(String login, String password, UserRole role) {
}

