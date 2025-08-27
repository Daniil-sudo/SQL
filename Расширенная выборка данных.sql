-- ======================
-- 1. Создание таблиц
-- ======================
CREATE TABLE artist (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE genre (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE album (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INT NOT NULL
);

CREATE TABLE track (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    duration INT NOT NULL, -- в секундах
    album_id INT REFERENCES album(id)
);

CREATE TABLE collection (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INT NOT NULL
);

CREATE TABLE artist_genre (
    artist_id INT REFERENCES artist(id),
    genre_id INT REFERENCES genre(id),
    PRIMARY KEY (artist_id, genre_id)
);

CREATE TABLE artist_album (
    artist_id INT REFERENCES artist(id),
    album_id INT REFERENCES album(id),
    PRIMARY KEY (artist_id, album_id)
);

CREATE TABLE collection_track (
    collection_id INT REFERENCES collection(id),
    track_id INT REFERENCES track(id),
    PRIMARY KEY (collection_id, track_id)
);

-- ======================
-- 2. Заполнение таблиц
-- ======================

-- 2.1. Артисты
INSERT INTO artist (name) VALUES
('Queen'),
('Adele'),
('OkeanElzy'),
('Basta');

-- 2.2. Жанры
INSERT INTO genre (name) VALUES
('Rock'),
('Pop'),
('Rap');

-- 2.3. Альбомы
INSERT INTO album (title, year) VALUES
('Bohemian Rhapsody', 2018),
('25', 2019),
('Баста 40', 2020);

-- 2.4. Треки
INSERT INTO track (title, duration, album_id) VALUES
('Bohemian Rhapsody', 354, 1),   -- 5:54
('Don’t Stop Me Now', 210, 1),   -- 3:30
('Hello', 295, 2),               -- 4:55
('Send My Love', 223, 2),        -- 3:43
('Мой путь', 250, 3),            -- 4:10
('Sansara', 300, 3),             -- 5:00
-- тестовые треки для проверки условия "мой/my"
('my own', 200, 2),
('own my', 210, 2),
('my', 180, 2),
('oh my god', 240, 3),
('myself', 200, 3),
('by myself', 220, 3),
('bemy self', 210, 3),
('premyne', 190, 3);

-- 2.5. Сборники
INSERT INTO collection (title, year) VALUES
('Best of Rock', 2019),
('Pop Hits', 2020),
('Rap Classics', 2021),
('Mixed Vibes', 2018);

-- 2.6. Связь артистов и жанров
INSERT INTO artist_genre (artist_id, genre_id) VALUES
(1, 1), -- Queen -> Rock
(2, 2), -- Adele -> Pop
(3, 1), -- OkeanElzy -> Rock
(4, 3); -- Basta -> Rap

-- 2.7. Связь артистов и альбомов
INSERT INTO artist_album (artist_id, album_id) VALUES
(1, 1), -- Queen -> Bohemian Rhapsody
(2, 2), -- Adele -> 25
(4, 3); -- Basta -> Баста 40

-- 2.8. Связь сборников и треков
INSERT INTO collection_track (collection_id, track_id) VALUES
(1, 1), (1, 2),  -- Best of Rock
(2, 3), (2, 4),  -- Pop Hits
(3, 5), (3, 6),  -- Rap Classics
(4, 1), (4, 5);  -- Mixed Vibes

-- ======================
-- 3. Задание 2 (SELECT-запросы)
-- ======================

-- 3.1. Самый длинный трек
SELECT title, duration
FROM track
ORDER BY duration DESC
LIMIT 1;

-- 3.2. Треки не короче 3,5 минут
SELECT title
FROM track
WHERE duration >= 210;

-- 3.3. Сборники 2018–2020
SELECT title
FROM collection
WHERE year BETWEEN 2018 AND 2020;

-- 3.4. Исполнители с одним словом в имени
SELECT name
FROM artist
WHERE name NOT LIKE '% %';

-- 3.5. Треки со словом "мой" или "my"
SELECT title
FROM track
WHERE title ~* '\m(my|мой)\M';

-- ======================
-- 4. Задание 3 (SELECT-запросы)
-- ======================

-- 4.1. Кол-во исполнителей в каждом жанре
SELECT g.name, COUNT(ag.artist_id) AS artist_count
FROM genre g
JOIN artist_genre ag ON g.id = ag.genre_id
GROUP BY g.name;

-- 4.2. Кол-во треков из альбомов 2019–2020
SELECT COUNT(t.id) AS track_count
FROM track t
JOIN album a ON t.album_id = a.id
WHERE a.year BETWEEN 2019 AND 2020;

-- 4.3. Средняя продолжительность треков по альбомам
SELECT a.title, AVG(t.duration) AS avg_duration
FROM album a
JOIN track t ON a.id = t.album_id
GROUP BY a.title;

-- 4.4. Исполнители, не выпускавшие альбомы в 2020
SELECT ar.name
FROM artist ar
WHERE ar.id NOT IN (
    SELECT aa.artist_id
    FROM artist_album aa
    JOIN album a ON aa.album_id = a.id
    WHERE a.year = 2020
);

-- 4.5. Сборники, где есть Queen
SELECT DISTINCT c.title
FROM collection c
JOIN collection_track ct ON c.id = ct.collection_id
JOIN track t ON ct.track_id = t.id
JOIN album a ON t.album_id = a.id
JOIN artist_album aa ON a.id = aa.album_id
JOIN artist ar ON aa.artist_id = ar.id
WHERE ar.name = 'Queen';
