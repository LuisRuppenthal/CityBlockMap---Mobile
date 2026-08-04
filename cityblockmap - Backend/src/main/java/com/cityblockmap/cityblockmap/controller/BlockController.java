package com.cityblockmap.cityblockmap.controller;

import com.cityblockmap.cityblockmap.dto.BlockDTO;
import com.cityblockmap.cityblockmap.model.Block;
import com.cityblockmap.cityblockmap.repository.BlockRepository;
import com.cityblockmap.cityblockmap.service.BlockService;
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
@RequestMapping("/blocks")
public class BlockController {

    @Autowired
    private final BlockService blockService;
    private final BlockRepository blockRepository;

    public BlockController(BlockService blockService, BlockRepository blockRepository) {
        this.blockService = blockService;
        this.blockRepository = blockRepository;
    }

    //GET
    // /blocks
    @GetMapping
    public ResponseEntity<List<BlockDTO>> getAllBlocksRoot() {
        return ResponseEntity.ok(blockService.getAllBlocks());
    }

    // /blocks/get
    @GetMapping("/get")
    public ResponseEntity<List<BlockDTO>> getAllBlocks() {
        return ResponseEntity.ok(blockService.getAllBlocks());
    }

    // /blocks/{id}
    @GetMapping("/{id}")
    public ResponseEntity<BlockDTO> getBlockByIdRoot(@PathVariable("id") Long id) {
        if (blockRepository.existsById(id)) {
            return ResponseEntity.ok().body(blockService.getBlockById(id));
        }
        return ResponseEntity.notFound().build();
    }

    // /blocks/get/{id}
    @GetMapping("get/{id}")
    public ResponseEntity<BlockDTO> getBlockById(@PathVariable("id") Long id) {
        if (blockRepository.existsById(id)) {
            return ResponseEntity.ok().body(blockService.getBlockById(id));
        }
        return ResponseEntity.notFound().build();
    }


    // POST
    // /blocks/create
    @PostMapping("/create")
    public ResponseEntity<BlockDTO> createBlock(@Valid @RequestBody BlockDTO blockDTO) {
        blockDTO.setId(null); //Para ignorar qualquer ID enviado
        BlockDTO createdBlock = blockService.createBlock(blockDTO);

        URI uri = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(createdBlock.getId())
                .toUri();

        return ResponseEntity.created(uri).body(createdBlock);
    }


    // PUT
    // /blocks/{id}
    @PutMapping("/update/{id}")
    public ResponseEntity<BlockDTO> updateBlock(@PathVariable("id") Long id, @Valid @RequestBody BlockDTO blockDTO) {

        if (blockRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.OK).body(blockService.updateBlock(id, blockDTO));
        }
        return ResponseEntity.notFound().build();
    }

    // DELETE
    // /blocks/{id}
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteBlockById(@PathVariable("id") Long id){
        if (blockRepository.existsById(id)){
            blockService.deleteBlockById(id);
            return ResponseEntity.status(HttpStatus.OK).body("Block (" + id + ") deletado");
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Block ("+id+") não encontrado!");
    }
}