create table images
(
    id        int auto_increment
        primary key,
    name      text     not null comment 'name of the image',
    image_obj longtext not null comment 'image object as base64 string'
);

