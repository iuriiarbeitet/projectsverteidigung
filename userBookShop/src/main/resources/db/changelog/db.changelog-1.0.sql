--liquibase formatted sql

--changeset irotari:1
create table if not exists users
(
    id         bigint generated by default as identity
        primary key,
    email      varchar(255) not null,
    enabled    boolean      not null,
    first_name varchar(255),
    last_name  varchar(255),
    password   varchar(255),
    phone      varchar(255),
    username   varchar(255)
);

alter table users
    owner to postgres;


--changeset irotari:2
create table if not exists user_shipping
(
    id                    bigint generated by default as identity
        primary key,
    user_shipping_city    varchar(255),
    user_shipping_country varchar(255),
    user_shipping_default boolean not null,
    user_shipping_name    varchar(255),
    user_shipping_state   varchar(255),
    user_shipping_street1 varchar(255),
    user_shipping_street2 varchar(255),
    user_shipping_zipcode varchar(255),
    user_id               bigint
        constraint fkpdei61alari7vjq0ff8pj83jk
            references users
);

alter table user_shipping
    owner to postgres;

--changeset irotari:3
create table if not exists role
(
    role_id integer not null
        primary key,
    name    varchar(255)
);

alter table role
    owner to postgres;

--changeset irotari:4
create table if not exists user_role
(
    user_role_id bigint generated by default as identity
        primary key,
    role_id      integer
        constraint fka68196081fvovjhkek5m97n3y
            references role,
    user_id      bigint
        constraint fkj345gk1bovqvfame88rcx7yyx
            references users
);

alter table user_role
    owner to postgres;

--changeset irotari:5
create table if not exists user_payment
(
    id              bigint generated by default as identity
        primary key,
    card_name       varchar(255),
    card_number     varchar(255),
    cvc             integer not null,
    default_payment boolean not null,
    expiry_month    integer not null,
    expiry_year     integer not null,
    holder_name     varchar(255),
    type            varchar(255),
    user_id         bigint
);

alter table user_payment
    owner to postgres;

--changeset irotari:6
create table if not exists user_billing
(
    id                   bigint generated by default as identity
        primary key,
    user_billing_city    varchar(255),
    user_billing_country varchar(255),
    user_billing_name    varchar(255),
    user_billing_state   varchar(255),
    user_billing_street1 varchar(255),
    user_billing_street2 varchar(255),
    user_billing_zipcode varchar(255),
    user_payment_id      bigint
        constraint fk3v6hd7snyc3g9s72u41k1fydu
            references user_payment
);

alter table user_billing
    owner to postgres;

--changeset irotari:7
create table if not exists shopping_cart
(
    id          bigint generated by default as identity
        primary key,
    grand_total numeric(19, 2),
    user_id     bigint
);

alter table shopping_cart
    owner to postgres;

--changeset irotari:8
create table if not exists password_reset_token
(
    id          bigint generated by default as identity
        primary key,
    expiry_date timestamp,
    token       varchar(255),
    user_id     bigint
);

alter table password_reset_token
    owner to postgres;

--changeset irotari:9
create table if not exists billing_address
(
    id                      bigint generated by default as identity
        primary key,
    billing_address_city    varchar(255),
    billing_address_country varchar(255),
    billing_address_name    varchar(255),
    billing_address_state   varchar(255),
    billing_address_street1 varchar(255),
    billing_address_street2 varchar(255),
    billing_address_zipcode varchar(255),
    order_id                bigint
);

alter table billing_address
    owner to postgres;

--changeset irotari:10
create table if not exists book
(
    id               bigint generated by default as identity
        primary key,
    active           boolean          not null,
    author           varchar(255),
    category         varchar(255),
    description      text,
    format           varchar(255),
    in_stock_number  integer          not null,
    isbn             integer          not null,
    language         varchar(255),
    list_price       double precision not null,
    number_of_pages  integer          not null,
    our_price        double precision not null,
    publication_date varchar(255),
    publisher        varchar(255),
    shipping_weight  double precision not null,
    title            varchar(255)
);

alter table book
    owner to postgres;

--changeset irotari:11
create table if not exists payment
(
    id           bigint generated by default as identity
        primary key,
    card_name    varchar(255),
    card_number  varchar(255),
    cvc          integer not null,
    expiry_month integer not null,
    expiry_year  integer not null,
    holder_name  varchar(255),
    type         varchar(255),
    order_id     bigint

);

alter table payment
    owner to postgres;

--changeset irotari:12
create table if not exists shipping_address
(
    id                       bigint generated by default as identity
        primary key,
    shipping_address_city    varchar(255),
    shipping_address_country varchar(255),
    shipping_address_name    varchar(255),
    shipping_address_state   varchar(255),
    shipping_address_street1 varchar(255),
    shipping_address_street2 varchar(255),
    shipping_address_zipcode varchar(255),
    order_id                 bigint

);

alter table shipping_address
    owner to postgres;

--changeset irotari:13
create table if not exists user_order
(
    id                  bigint generated by default as identity
        primary key,
    order_date          timestamp,
    order_status        varchar(255),
    order_total         numeric(19, 2),
    shipping_date       timestamp,
    shipping_method     varchar(255),
    billing_address_id  bigint
        constraint fkbaytj4l2p74kc5dp2dcrhucjo
            references billing_address,
    payment_id          bigint
        constraint fkqjg5jrh5qwnhl2f9lk7n77454
            references payment,
    shipping_address_id bigint
        constraint fko2lj94xaujs1se8whlhc37nj7
            references shipping_address,
    user_id             bigint
);

alter table user_order
    owner to postgres;

--changeset irotari:14
create table if not exists cart_item
(
    id               bigint generated by default as identity
        primary key,
    qty              integer not null,
    subtotal         numeric(19, 2),
    book_id          bigint
        constraint fkis5hg85qbs5d91etr4mvd4tx6
            references book,
    order_id         bigint
        constraint fken9v41ihsnhcr0i7ivsd7i84c
            references user_order,
    shopping_cart_id bigint
        constraint fke89gjdx91fxnmkkssyoim8xfu
            references shopping_cart
);

alter table cart_item
    owner to postgres;

--changeset irotari:15
create table if not exists book_to_cart_item
(
    id           bigint generated by default as identity
        primary key,
    book_id      bigint
        constraint fk254kg9aacrs8uqa93ijc3garu
            references book,
    cart_item_id bigint
        constraint fkbdyqr108hc7c06xtem0dhv9mk
            references cart_item
);

alter table book_to_cart_item
    owner to postgres;





