-- Создание базы данных
CREATE DATABASE IF NOT EXISTS MusicDB;

-- Использование базы данных
USE MusicDB;

-- Создание таблицы genre
CREATE TABLE genre (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Создание таблицы artist
CREATE TABLE artist (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    nickname VARCHAR(255)
);

-- Создание промежуточной таблицы для связи "многие-ко-многим" между жанрами и исполнителями
CREATE TABLE artist_genre (
    artist_id INT,
    genre_id INT,
    PRIMARY KEY (artist_id, genre_id),
    FOREIGN KEY (artist_id) REFERENCES artist(ID),
    FOREIGN KEY (genre_id) REFERENCES genre(ID)
);

-- Создание таблицы album
CREATE TABLE album (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    year INT CHECK (year >= 1900), -- Ограничение: год не может быть меньше 1900
    -- album_cover BLOB -- Здесь можно хранить изображение обложки альбома
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES artist(ID)
);

-- Создание промежуточной таблицы для связи "многие-ко-многим" между исполнителями и альбомами
CREATE TABLE artist_album (
    artist_id INT,
    album_id INT,
    PRIMARY KEY (artist_id, album_id),
    FOREIGN KEY (artist_id) REFERENCES artist(ID),
    FOREIGN KEY (album_id) REFERENCES album(ID)
);

-- Создание таблицы Song (Трек)
CREATE TABLE Song (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    duration INT CHECK (duration > 0), -- Продолжительность в секундах, ограничение: должна быть больше 0
    album_id INT,
    FOREIGN KEY (album_id) REFERENCES album(ID)
);

-- Создание таблицы Collection (Сборник)
CREATE TABLE Collection (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    year INT CHECK (year >= 1900) -- Ограничение: год не может быть меньше 1900
);

-- Создание промежуточной таблицы для связи "многие-ко-многим" между треками и сборниками
CREATE TABLE collection_song (
    collection_id INT,
    song_id INT,
    PRIMARY KEY (collection_id, song_id),
    FOREIGN KEY (collection_id) REFERENCES Collection(ID),
    FOREIGN KEY (song_id) REFERENCES Song(ID)
);

-- Пример добавления данных
INSERT INTO genre (title) VALUES
('Pop'),
('Rock'),
('Electronic');

INSERT INTO artist (name, nickname) VALUES
('Artist 1', 'A1'),
('Artist 2', 'A2');

INSERT INTO artist_genre (artist_id, genre_id) VALUES
(1, 1), -- Artist 1 играет Pop
(1, 2), -- Artist 1 играет Rock
(2, 2), -- Artist 2 играет Rock
(2, 3); -- Artist 2 играет Electronic

INSERT INTO album (title, year, artist_id) VALUES
('Album 1', 2022, 1),
('Album 2', 2023, 2);

INSERT INTO artist_album (artist_id, album_id) VALUES
(1, 1), -- Artist 1 создал Album 1
(2, 2); -- Artist 2 создал Album 2

INSERT INTO Song (name, duration, album_id) VALUES
('Song 1', 180, 1), -- 3 минуты
('Song 2', 240, 1), -- 4 минуты
('Song 3', 300, 2); -- 5 минут

INSERT INTO Collection (title, year) VALUES
('Collection 1', 2024),
('Collection 2', 2023);

INSERT INTO collection_song (collection_id, song_id) VALUES
(1, 1), -- Song 1 входит в Collection 1
(1, 2), -- Song 2 входит в Collection 1
(2, 3); -- Song 3 входит в Collection 2