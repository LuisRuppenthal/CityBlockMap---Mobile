package com.cityblockmap.cityblockmap.service;

import com.cityblockmap.cityblockmap.dto.BlockDTO;
import com.cityblockmap.cityblockmap.mapper.BlockMapper;
import com.cityblockmap.cityblockmap.model.Block;
import com.cityblockmap.cityblockmap.repository.BlockRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class BlockService {

    @Autowired
    private final BlockRepository blockRepository;
    private final BlockMapper blockMapper;

    public BlockService(BlockRepository blockRepository, BlockMapper blockMapper){
        this.blockRepository = blockRepository;
        this.blockMapper = blockMapper;
    }

    //GET
    public List<BlockDTO> getAllBlocks(){
        List<Block> blocks = blockRepository.findAll();

        return blocks.stream()
                .map(blockMapper::map)
                .collect(Collectors.toList());
    }


    public BlockDTO getBlockById(Long id) {
        Optional<Block> block = blockRepository.findById(id);
        return block.map(blockMapper::map).orElse(null);
    }


    //CREATE
    public BlockDTO createBlock(BlockDTO blockDTO){
        Block block = blockMapper.map(blockDTO);
        block.setId(null); //Para forçar ID a ser null, garantindo a criação de novo registro
        block = blockRepository.save(block);
        return blockMapper.map(block);
    }


    //UPDATE
    public BlockDTO updateBlock(Long id, BlockDTO blockDTO){
        Optional<Block> block = blockRepository.findById(id);

        if(block.isPresent()){
            Block existingBlock = block.get();

            if (blockDTO.getNumber() != null){
                existingBlock.setNumber(blockDTO.getNumber());
            }
            if (blockDTO.getLatitude() != null){
                existingBlock.setLatitude(blockDTO.getLatitude());
            }
            if (blockDTO.getLongitude() != null){
                existingBlock.setLongitude(blockDTO.getLongitude());
            }
            if (blockDTO.getNeighborhood() != null){
                existingBlock.setNeighborhood(blockDTO.getNeighborhood());
            }

            Block savedBlock = blockRepository.save(existingBlock);
            return blockMapper.map(savedBlock);
        }
        return null;
    }


    //DELETE
    public void deleteBlockById(Long id){
        blockRepository.deleteById(id);
    }
}