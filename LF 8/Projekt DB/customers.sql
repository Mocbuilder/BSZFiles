create table customers
(
    id       int auto_increment
        primary key,
    forename varchar(50) not null comment 'Forename of the customer',
    surname  varchar(50) not null comment 'Surname of the customer',
    address  int         not null comment 'id reference of the address from the customer',
    email    varchar(60) not null comment 'email of the customer',
    constraint customers_unique
        unique (email, address),
    constraint customers_address_id_fk
        foreign key (address) references address (id)
);

