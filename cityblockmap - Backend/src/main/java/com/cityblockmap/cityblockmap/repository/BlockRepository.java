package com.cityblockmap.cityblockmap.repository;

import com.cityblockmap.cityblockmap.model.Block;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BlockRepository extends JpaRepository<Block, Long> {
}
