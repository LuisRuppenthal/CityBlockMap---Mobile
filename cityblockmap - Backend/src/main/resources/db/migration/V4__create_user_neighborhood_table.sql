CREATE TABLE IF NOT EXISTS tb_user_neighborhood (
    user_id BIGINT NOT NULL,
    neighborhood_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, neighborhood_id),
    CONSTRAINT fk_user_neighborhood_user
        FOREIGN KEY (user_id)
        REFERENCES tb_users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_user_neighborhood_neighborhood
        FOREIGN KEY (neighborhood_id)
        REFERENCES tb_neighborhood(id)
        ON DELETE CASCADE
);