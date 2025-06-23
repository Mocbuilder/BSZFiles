create table product
(
    id                     int auto_increment
        primary key,
    product_group_id       int                          not null comment 'Id from the product group',
    manufacturer_id        int                          not null comment 'Id of the manufacturer',
    name                   varchar(50)                  not null comment 'Name of the Product',
    article_number         int                          not null comment 'Responsible article number',
    description            text                         null comment 'Prouct description',
    price                  decimal(10, 2)               not null comment 'price of the product',
    additional_information longtext collate utf8mb4_bin null comment 'additional information for the product formatted as json'
        check (json_valid(`additional_information`)),
    constraint product_unique
        unique (name, article_number),
    constraint product_ibfk_1
        foreign key (manufacturer_id) references manufacturer (id),
    constraint product_ibfk_2
        foreign key (product_group_id) references product_group (id)
);

create index manufacturer_id
    on product (manufacturer_id);

create index product_group_id
    on product (product_group_id);

