create table ratings
(
    id          int auto_increment
        primary key,
    product_id  int      not null comment 'id as a reference to the product itself',
    rating      int(1)   not null comment 'rating in form of 0-9 (1-10)',
    customer_id int      not null comment 'id reference to the customer that has sent the rating',
    comment     tinytext not null comment 'small description of the rating',
    constraint ratings_unique
        unique (product_id, customer_id),
    constraint ratings_product_id_fk
        foreign key (product_id) references product (id)
);

