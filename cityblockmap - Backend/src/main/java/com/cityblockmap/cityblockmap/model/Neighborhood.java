package com.cityblockmap.cityblockmap.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.GenerationType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;


@Entity
@Table(name = "tb_neighborhood")
@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Neighborhood {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false)
    private String name;

    @OneToMany(mappedBy = "neighborhood", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Block> blocks;

    @ManyToMany(mappedBy = "neighborhoods")
    @JsonIgnore
    private List<User> users;
}