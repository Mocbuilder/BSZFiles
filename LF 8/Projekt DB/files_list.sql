create table files_list
(
    product_id  int not null comment 'id reference of the product',
    download_id int not null comment 'id reference of the downloadable file',
    constraint files_list_ibfk_1
        foreign key (download_id) references files (id),
    constraint files_list_ibfk_2
        foreign key (product_id) references product (id)
);

create index download_id
    on files_list (download_id);

create index product_id
    on files_list (product_id);

