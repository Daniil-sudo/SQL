CREATE DATABASE tourism; --база данных туризм
use tourism; --использование базы данных
CREATE TABLE countries (
    country_name VARCHAR(255) NOT NULL UNIQUE
); --таблица страны
ALTER TABLE countries --изменение таблицы
ADD COLUMN country_id INT PRIMARY KEY AUTO_INCREMENT FIRST; --добавление внешних ключей с нумерацией через инкремент

INSERT INTO countries (country_name) VALUES ('Russia'), ('Pakistan'); --добавление значений
select * from countries; --вывод таблицы
CREATE TABLE tours (
    tour_id INT PRIMARY KEY AUTO_INCREMENT, 
    tour_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL  
);--нумерация через инкремент, добавление типов данных, создание таблицы
select * from tours; --вывод таблицы
insert into tours(tour_id,tour_name,price)
values (1,'Moscow-tour',100.10);
insert into tours(tour_id,tour_name,price)
values (2,'Islamabad-tour',1000.20);
select * from tours;
ALTER TABLE tours
ADD COLUMN valute VARCHAR(3) NOT NULL DEFAULT 'RUB';
select * from tours;
CREATE TABLE hotels (
    hotels_id INT PRIMARY KEY AUTO_INCREMENT,
    hotels_addres  VARCHAR(255) NOT NULL,
    town VARCHAR(10) NOT NULL  
);
insert into hotels (hotels_id,hotels_addres,town)
values (123100,'one Krasnogvardeiskii proesd, 21, str. 1','Moscow');

insert into hotels (hotels_id,hotels_addres,town)
values (44000,'Khayaban-e-Suharwardy, G-5/1','Islamabad');

show tables;
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_name  VARCHAR(255) NOT NULL,
    client_mail VARCHAR(10) NOT NULL  
);
insert into clients (client_id,client_name,client_mail)
values (1,'ivanov ivan ivanovich','iv@mail.ru');

CREATE TABLE tour_bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    tour_id INT NOT NULL,
    client_id INT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
); --создания таблицы для бронирования





