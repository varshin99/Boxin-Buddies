if not exists(select * from sys.databases where name='Boxin_Buddies')
    create database Boxin_Buddies
GO

use Boxin_Buddies
GO

-- DOWN 
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_location_state_code')
    alter table locations drop constraint fk_location_state_code

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_location_address_type')
    alter table locations drop constraint fk_location_address_type

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_payments_payment_status')
    alter table payments drop constraint fk_payments_payment_status

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_payments_payment_method_lookup')
    alter table payments drop constraint fk_payments_payment_method_lookup

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_packages_package_sensitivity_lookup')
    alter table packages drop constraint fk_packages_package_sensitivity_lookup

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_packages_payment_status')
    alter table packages drop constraint fk_packages_payment_status

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_packages_package_delivery_status')
    alter table packages drop constraint fk_packages_package_delivery_status

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_users_user_type')
    alter table users drop constraint fk_users_user_type
go
drop table if exists history 
drop table if exists locations  
drop table if exists rating 
drop table if exists package_type
drop table if exists traveller_availability 
drop table if exists payments 
drop table if exists travellers
drop table  if exists packages 
drop table if exists users 
drop table if exists payment_method_lookup
drop table if exists delivery_status_lookup
drop table if exists package_sensitivity_lookup
drop table if exists user_type_lookup 
drop table if exists payment_status_lookup 
drop table if exists address_type_lookup
drop table if exists state_lookup

GO
-- UP Metadata
create table state_lookup (
    state_code char(2) not null,
    constraint pk_state_lookup_state_code primary key(state_code)
)

create table address_type_lookup (
    address_type VARCHAR(50) not null,
    constraint pk_address_type_lookup_address_type primary key(address_type)
)

create table payment_status_lookup (
    payment_status VARCHAR(50) NOT NULL,
    CONSTRAINT pk_payment_status_lookup_payment_status primary KEY(payment_status)
)

CREATE table user_type_lookup (
    user_type VARCHAR(30) not NULL,
    CONSTRAINT pk_user_type_lookup_user_type PRIMARY KEY (user_type)
)

CREATE table package_sensitivity_lookup (
    package_sensitivity VARCHAR(40) not NULL,
    CONSTRAINT pk_package_sensitivity_lookup_package_sensitivity PRIMARY KEY (package_sensitivity)
)

CREATE table delivery_status_lookup (
    delivery_status VARCHAR(40) not NULL,
    CONSTRAINT pk_delivery_status_lookup_delivery_status PRIMARY KEY (delivery_status)
)

CREATE table payment_method_lookup (
    payment_method VARCHAR(40) not NULL,
    CONSTRAINT pk_payment_method_lookup_payment_method PRIMARY KEY (payment_method)
)

create table users (
    user_id  VARCHAR(100) not null,
    user_type  varchar(30)  not null,
    user_email varchar(70) not null,
    user_password  VARCHAR(70) not null,
    user_full_name  varchar(50) not null,
    user_phone_number VARCHAR(10)  not NULL,
    traveller_avg_rating int ,  
    constraint pk_user_user_id primary key (user_id),
    constraint u_user_id unique (user_id),
    CONSTRAINT u_user_email UNIQUE (user_email),
)
alter table users 
    add constraint fk_users_user_type foreign key (user_type)
        references user_type_lookup(user_type)


create table packages (
    package_id int identity not null,
    user_id             varchar(100) not null,
    sender_full_name     varchar(50) not null,
    sender_phone_number  varchar(10) not null,
    sender_email         varchar(70) not null,
    recipient_full_name     VARCHAR(50) not null ,
    recipient_phone_number  VARCHAR(10) not null ,
    recipient_email         VARCHAR(50) not null ,
    package_type_id      int , 
    package_sensitivity   VARCHAR(40) not null, 
    package_ready_for_pickup_date   DATETIME  not null,
    package_pickup_address_id       int  , 
    package_delivery_address_id      int  , 
    package_delivery_status       VARCHAR (40) ,
    pacakge_delivery_fee          money  DEFAULT(0) null,
    package_payment_status        VARCHAR(50), 
    traveller_id  int   ,
    traveller_user_id VARCHAR(100) , 
    payment_id  int  ,

    constraint pk_packages_package_id primary key (package_id),


)
alter table packages
    add constraint fk_packages_package_delivery_status foreign key (package_delivery_status)
        references delivery_status_lookup(delivery_status)

alter table packages
    add constraint fk_packages_payment_status foreign key (package_payment_status)
        references payment_status_lookup(payment_status)

alter table packages
    add constraint fk_packages_package_sensitivity_lookup foreign key (package_sensitivity)
        references package_sensitivity_lookup(package_sensitivity)




create table travellers (
    traveller_id  int identity not null,
    user_id  varchar(100) not null,
    traveller_full_name  VARCHAR(60) not null,
    traveller_phone_number   VARCHAR(30) not null,
    traveller_email  varchar(40) null,
    traveller_starting_address_id   int,
    traveller_destination_address_id  int  ,
    traveller_vechile_detials    VARCHAR(40) not null,
    traveller_availability_id  int ,
    constraint pk_travellers_traveller_id primary key (traveller_id),
 
)

create table payments (
    payment_id  int identity not null,
    package_id  int  ,
    traveller_id  int ,
    user_id VARCHAR(100)  ,
    delivery_fee   money  ,
    payment_method    VARCHAR(40) NOT null,
    payment_amount   money  not  null,
    payment_date     DATE not null,
    payment_status   VARCHAR(50) DEFAULT('Pending') ,  
    constraint pk_payments_payment_id primary key (payment_id),

)

alter table payments 
    add constraint fk_payments_payment_method_lookup foreign key (payment_method)
        references payment_method_lookup(payment_method)

alter table payments
    add constraint fk_payments_payment_status foreign key (payment_status)
        references payment_status_lookup(payment_status)

create table traveller_availability (
    traveller_availability_id  int identity not null,
    traveller_id  int  not null,
    traveller_start_date DATE  not null,
    traveller_end_date Date  not null,
    traveller_pickup_location   VARCHAR(100)  not null,
    traveller_delivery_location    VARCHAR(100) NOT null, 
    constraint pk_traveller_availability_id primary key (traveller_availability_id),
)

create table package_type (
    package_type_id  int identity not null,
    package_id int , 
    package_type_name  VARCHAR(50)  not null,
    package_weight int  not null,
    package_length int  not null,
    package_width    INT  not null,
    package_height int NOT null, 
    constraint pk_package_type_id primary key (package_type_id),

)

create table rating (
    rating_id  int identity not null,
    user_id  VARCHAR(100)   not null,
    raitng  int  not null,
    rating_for_traveller_id int not null,
    traveller_user_id VARCHAR(100) DEFAULT('NA') ,
    feedback   VARCHAR(100)  not null,
    constraint pk_rating_id primary key (rating_id),

)

create table locations  (
    address_id  int identity not null,
    user_id VARCHAR(100)  not null,
    package_id INT ,
    traveller_id int ,
    traveller_user_id varchar(100) ,
    address_type VARCHAR(50)   not null,
    street  VARCHAR(50)  not null,
    apartment  VARCHAR(50)  not null,
    landmarks  VARCHAR(50)  not null,
    city  VARCHAR(50)  not null,
    zipcode  VARCHAR(50)  not null,
    state_code char(2)  not null,
    country  VARCHAR(10) DEFAULT('USA'),
    constraint pk_address_id primary key (address_id),

)
alter table locations 
    add constraint fk_location_address_type foreign key (address_type)
        references address_type_lookup(address_type)

alter table locations 
    add constraint fk_location_state_code foreign key (state_code)
        references state_lookup(state_code)


create table History  (
    history_id  int identity not null,
    user_id VARCHAR(100)  null, 
    package_id    int    null,
    delivery_status   varchar(40)   not null,
    traveller_id   INT   null,
    traveller_user_id int ,
    status_date    date DEFAULT GETDATE() ,
    constraint pk_history_id primary key (history_id),
)



GO
-- UP Data
insert into user_type_lookup (user_type) values
    ('Sender'),('Traveller')

insert into state_lookup (state_code) values
    ('NY'),('CT')

Insert into package_sensitivity_lookup(package_sensitivity)
 VALUES('Fragile'), ('Regular')

INSERT INTO delivery_status_lookup(delivery_status) VALUES
 ('Pending'),('Traveller Assigned'),('In Transit'),('Delivered'),('Cancelled')

INSERT INTO  payment_status_lookup(payment_status) VALUES
('Pending'),('Paid'),('Cancelled')

insert into address_type_lookup(address_type) VALUES
 ('Package Pick-up address'),('Package Delivery address'), 
 ('Traveller starting address'),('Traveller destion address')

insert into payment_method_lookup(payment_method) VALUES
('Credit Card'),('Paypal'),('Apple Pay'),('Bank Transfer')

insert into users
    (user_id,user_type,user_email,user_password,user_full_name,user_phone_number)  
    values
    ('saikiran11','Sender','saikiran11#gmail.com','sikiran11', 'sai kiran','3157849596'),
    ('varshin11','Sender','varshin113#gmail.com','varshin11', 'Varshin kumar','3157847896'),
    ('akhil44','Sender','akhil44#gmail.com','akhil44', 'Akhil kumar','3157843456'),
    ('saikalyan3','Sender','saikalyan3#gmail.com','saikalyan3', 'sai kiran','3157869845'),
    ('saikumar66','Sender','saikumar66#gmail.com','saikumar66', 'sai Kumar','3157849896'),
    ('chrisevans33','Traveller','chrisevans33#gmail.com','chrisevans33', 'Chris Evans','3157844590'),
    ('mukesh66','Traveller','Mukesh66#gmail.com','Mukesh66', 'Mukesh','3157849679')

insert into locations 
    (package_id,address_type,street,apartment,city,zipcode,landmarks,state_code)  
    values
    ('4', 'Package Pick-up address' ,'yxxfh','yrx', 'Syracuse','fx','uv', 'NY')


insert into packages 
    ( user_id,sender_full_name,sender_email,sender_phone_number,recipient_full_name,recipient_email,recipient_phone_number,package_sensitivity,package_ready_for_pickup_date)
values
    ('saikiran11','utcg','utcg','tcghvjkj ','xfgchjh','xycgvhjbj','xfcgvjh','Fragile','2020-05-01')

DELETE from locations where package_id= 4
GO
-- Verify
select * from user_type_lookup 
select * from users 
select * from address_type_lookup
select * from packages
SELECT * from locations
SELECT * from history 
SELECT * from dbo.total_history_of_users_view
SELECT * from travellers
