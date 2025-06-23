create table files
(
    id   int auto_increment
        primary key,
    text text not null comment 'file name for website integration',
    link text not null comment 'link to the file path stored onto a data bucket'
);

