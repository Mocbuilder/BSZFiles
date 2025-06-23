create table product_group
(
    id   int auto_increment
        primary key,
    name varchar(50) not null comment 'name of the product group',
    constraint product_group_unique
        unique (name)
);

