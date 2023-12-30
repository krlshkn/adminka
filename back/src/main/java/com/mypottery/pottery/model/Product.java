package com.mypottery.pottery.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "product")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "type", nullable = false, length = 20)
    private String type;

    @Column(name = "name", nullable = false, length = 20)
    private String name;

    @Column(name = "length", nullable = false)
    private Integer length;

    @Column(name = "width", nullable = false)
    private Integer width;

    @Column(name = "height")
    private Integer height;

    @Column(name = "price", nullable = false)
    private Integer price;

    @Column(name = "picture", nullable = false, length = 50)
    private String picture;

    @Column(name = "status", length = 20)
    private String status;

    @Column(name = "note", length = Integer.MAX_VALUE)
    private String note;

    @Column(name = "add1", length = 50)
    private String add1;

    @Column(name = "add2", length = 50)
    private String add2;

    @Column(name = "add3", length = 50)
    private String add3;

    @Column(name = "color", length = 50)
    private String color;

    @Column(name = "design", length = 50)
    private String design;

}