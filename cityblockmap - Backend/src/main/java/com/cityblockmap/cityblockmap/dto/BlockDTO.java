package com.cityblockmap.cityblockmap.dto;

import com.cityblockmap.cityblockmap.model.Neighborhood;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class BlockDTO {
    private Long id;

    @NotBlank(message = "Number é obrigatório")
    private String number;

    @NotNull(message = "Latitude é obrigatório")
    private Double latitude;

    @NotNull(message = "Longitude é obrigatório")
    private Double longitude;

    @NotNull(message = "Neighborhood é obrigatório")
    private Neighborhood neighborhood;
}
