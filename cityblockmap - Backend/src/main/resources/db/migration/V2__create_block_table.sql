CREATE TABLE IF NOT EXISTS tb_block (
    id BIGSERIAL PRIMARY KEY,
    number VARCHAR(255),
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    neighborhood_id BIGINT,
    CONSTRAINT fk_block_neighborhood
        FOREIGN KEY (neighborhood_id)
        REFERENCES tb_neighborhood(id)
        ON DELETE CASCADE
);