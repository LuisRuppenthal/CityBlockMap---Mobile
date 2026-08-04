package com.cityblockmap.cityblockmap.controller;

import com.cityblockmap.cityblockmap.dto.NeighborhoodDTO;
import com.cityblockmap.cityblockmap.model.Neighborhood;
import com.cityblockmap.cityblockmap.repository.NeighborhoodRepository;
import com.cityblockmap.cityblockmap.service.NeighborhoodService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/neighborhoods")
public class NeighborhoodController {

    @Autowired
    private final NeighborhoodService neighborhoodService;
    private final NeighborhoodRepository neighborhoodRepository;

    public NeighborhoodController(NeighborhoodService neighborhoodService, NeighborhoodRepository neighborhoodRepository) {
        this.neighborhoodService = neighborhoodService;
        this.neighborhoodRepository = neighborhoodRepository;
    }

    // GET
    // /neighborhoods
    @GetMapping
    public ResponseEntity<List<NeighborhoodDTO>> getAllNeighborhoodsRoot() {
        return ResponseEntity.ok(neighborhoodService.getAllNeighborhoods());
    }

    // /neighborhoods/get
    @GetMapping("/get")
    public ResponseEntity<List<NeighborhoodDTO>> getAllNeighborhoods() {
        return ResponseEntity.ok(neighborhoodService.getAllNeighborhoods());
    }


    // /neighborhoods/get/{id}
    @GetMapping("/get/{id}")
    public ResponseEntity<NeighborhoodDTO> getNeighborhoodById(@PathVariable("id") Long id){

        if ( neighborhoodRepository.existsById(id)){
            return ResponseEntity.ok().body(neighborhoodService.getNeighborhoodById(id));
        }
        return ResponseEntity.notFound().build();
    }


    // POST
    // /neighborhoods/create
    @PostMapping("/create")
    public ResponseEntity<NeighborhoodDTO> createNeighborhood(@Valid @RequestBody NeighborhoodDTO neighborhoodDTO) {
        neighborhoodDTO.setId(null); //Para ignorar qualquer ID enviado
        NeighborhoodDTO createdNeighborhood = neighborhoodService.createNeighborhood(neighborhoodDTO);

        URI uri = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(createdNeighborhood.getId())
                .toUri();

        return ResponseEntity.created(uri).body(createdNeighborhood);
    }


    // PUT
    // /neighborhoods/{id}
    @PutMapping("/update/{id}")
    public ResponseEntity<NeighborhoodDTO> updateNeighborhood(@Valid @PathVariable("id") Long id, @RequestBody NeighborhoodDTO neighborhoodDTO) {

        if (neighborhoodRepository.existsById(id)){
            return ResponseEntity.status(HttpStatus.OK).body(neighborhoodService.updateNeighborhood(id, neighborhoodDTO));
        }
        return ResponseEntity.notFound().build();
    }


    // DELETE
    // /neighborhoods/delete/{id}
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteNeighborhoodById(@PathVariable("id") Long id){
        if (neighborhoodRepository.existsById(id)){
            neighborhoodService.deleteNeighborhoodById(id);
            return ResponseEntity.status(HttpStatus.OK).body("Neighborhood (" + id + ") deletada");
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Neighborhood ("+id+") Não encontrada!");
    }

}