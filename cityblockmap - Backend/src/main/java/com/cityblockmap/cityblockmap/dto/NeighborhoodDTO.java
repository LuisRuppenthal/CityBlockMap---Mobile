package com.cityblockmap.cityblockmap.dto;

import com.cityblockmap.cityblockmap.model.Block;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.OneToMany;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NeighborhoodDTO {
    private Long id;

    @NotBlank(message = "neighborhood é obrigatório")
    private String name;

    
    private List<Block> blocks;
}
