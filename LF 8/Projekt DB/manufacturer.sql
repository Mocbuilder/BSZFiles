create table manufacturer
(
    id      int auto_increment
        primary key,
    name    varchar(50) not null comment 'name of the manufacturer',
    email   varchar(50) not null comment 'email of the manufacturer',
    address int         not null comment 'id reference to the manufacturer address',
    constraint manufacturer_unique
        unique (name, email),
    constraint manufacturer_address_id_fk
        foreign key (address) references address (id)
);

