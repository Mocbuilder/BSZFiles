create table images_list
(
    image_id   int not null comment 'id reference of the image',
    product_id int not null comment 'id reference of the corresponding product id',
    constraint images_list_ibfk_1
        foreign key (image_id) references images (id),
    constraint images_list_ibfk_2
        foreign key (product_id) references product (id)
);

create index image_id
    on images_list (image_id);

create index product_id
    on images_list (product_id);

