package com.cityblockmap.cityblockmap.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import com.cityblockmap.cityblockmap.dto.NeighborhoodDTO;
import com.cityblockmap.cityblockmap.mapper.NeighborhoodMapper;
import com.cityblockmap.cityblockmap.model.Neighborhood;
import com.cityblockmap.cityblockmap.repository.NeighborhoodRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class NeighborhoodService {

    @Autowired
    private final NeighborhoodRepository neighborhoodRepository;
    private final NeighborhoodMapper neighborhoodMapper;

    public NeighborhoodService(NeighborhoodRepository neighborhoodRepository, NeighborhoodMapper neighborhoodMapper) {
        this.neighborhoodRepository = neighborhoodRepository;
        this.neighborhoodMapper = neighborhoodMapper;
    }

    //GET
    public List<NeighborhoodDTO> getAllNeighborhoods() {
        List<Neighborhood> neighborhoods = neighborhoodRepository.findAll();
        return neighborhoods.stream()
                .map(neighborhoodMapper::map)
                .collect(Collectors.toList());
    }


    public NeighborhoodDTO getNeighborhoodById(Long id) {
        Optional<Neighborhood> neighborhood = neighborhoodRepository.findById(id);
        return neighborhood.map(neighborhoodMapper::map).orElse(null);
    }


    //CREATE
    public NeighborhoodDTO createNeighborhood(NeighborhoodDTO neighborhoodDTO) {
        Neighborhood neighborhood = neighborhoodMapper.map(neighborhoodDTO);
        neighborhood.setId(null); //Para forçar ID a ser null, garantindo a criação de novo registro
        neighborhood = neighborhoodRepository.save(neighborhood);
        return neighborhoodMapper.map(neighborhood);
    }


    //UPDATE
    public NeighborhoodDTO updateNeighborhood(Long id, NeighborhoodDTO neighborhoodDTO) {
        Optional<Neighborhood> neighborhood = neighborhoodRepository.findById(id);

        if(neighborhood.isPresent()){
            Neighborhood neighborhoods = neighborhoodMapper.map(neighborhoodDTO);
            neighborhoods.setId(id);

            Neighborhood savedNeighborhoods = neighborhoodRepository.save(neighborhoods);
            return neighborhoodMapper.map(savedNeighborhoods);
        }
        return null;
    }

    //DELETE
    public void deleteNeighborhoodById(Long id) {
        neighborhoodRepository.deleteById(id);
    }
}


