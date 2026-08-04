package com.cityblockmap.cityblockmap.mapper;

import com.cityblockmap.cityblockmap.dto.NeighborhoodDTO;
import com.cityblockmap.cityblockmap.model.Neighborhood;
import org.springframework.stereotype.Component;

@Component
public class NeighborhoodMapper {
    public Neighborhood map(NeighborhoodDTO neighborhoodDTO){
        Neighborhood neighborhood = new Neighborhood();

        neighborhood.setId(neighborhoodDTO.getId());
        neighborhood.setName(neighborhoodDTO.getName());
        neighborhood.setBlocks(neighborhoodDTO.getBlocks());

        return neighborhood;
    }

    public NeighborhoodDTO map(Neighborhood neighborhood){
        NeighborhoodDTO neighborhoodDTO = new NeighborhoodDTO();

        neighborhoodDTO.setId(neighborhood.getId());
        neighborhoodDTO.setName(neighborhood.getName());
        neighborhoodDTO.setBlocks(neighborhood.getBlocks());

        return neighborhoodDTO;
    }
}