package com.cityblockmap.cityblockmap.mapper;

import com.cityblockmap.cityblockmap.dto.BlockDTO;
import com.cityblockmap.cityblockmap.model.Block;
import org.hibernate.engine.jdbc.batch.spi.BatchKey;
import org.springframework.stereotype.Component;

@Component
public class BlockMapper {
    public Block map(BlockDTO blockDTO){
        Block block = new Block();

        block.setId(blockDTO.getId());
        block.setNumber(blockDTO.getNumber());
        block.setLatitude(blockDTO.getLatitude());
        block.setLongitude(blockDTO.getLongitude());
        block.setNeighborhood(blockDTO.getNeighborhood());

        return block;
    }

    public BlockDTO map(Block block){
        BlockDTO blockDTO = new BlockDTO();

        blockDTO.setId(block.getId());
        blockDTO.setNumber(block.getNumber());
        blockDTO.setLatitude(block.getLatitude());
        blockDTO.setLongitude(block.getLongitude());
        blockDTO.setNeighborhood(block.getNeighborhood());

        return blockDTO;
    }
}
