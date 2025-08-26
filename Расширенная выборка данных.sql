-- ======================
-- ������� 1: �������� ������
-- ======================

DROP TABLE IF EXISTS collection_track;
DROP TABLE IF EXISTS artist_album;
DROP TABLE IF EXISTS artist_genre;
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS album;
DROP TABLE IF EXISTS collection;
DROP TABLE IF EXISTS artist;
DROP TABLE IF EXISTS genre;

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
    duration INT NOT NULL, -- � ��������
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
-- ���������� �������
-- ======================

-- �����������
INSERT INTO artist (id, name) VALUES
(1, 'Queen'),
(2, 'Adele'),
(3, 'OkeanElzy'),
(4, 'Basta');

-- �����
INSERT INTO genre (id, name) VALUES
(1, 'Rock'),
(2, 'Pop'),
(3, 'Rap');

-- �������
INSERT INTO album (id, title, year) VALUES
(1, 'Bohemian Rhapsody', 2018),
(2, '25', 2019),
(3, '����� 40', 2020);

-- ����� (? 6)
INSERT INTO track (id, title, duration, album_id) VALUES
(1, 'Bohemian Rhapsody', 354, 1),   -- 5:54
(2, 'Don�t Stop Me Now', 210, 1),   -- 3:30
(3, 'Hello', 295, 2),               -- 4:55
(4, 'Send My Love', 223, 2),        -- 3:43
(5, '��� ����', 250, 3),            -- 4:10
(6, 'Sansara', 300, 3);             -- 5:00

-- �������� (? 4)
INSERT INTO collection (id, title, year) VALUES
(1, 'Best of Rock', 2019),
(2, 'Pop Hits', 2020),
(3, 'Rap Classics', 2021),
(4, 'Mixed Vibes', 2018);

-- �����: ����������� � �����
INSERT INTO artist_genre (artist_id, genre_id) VALUES
(1, 1), -- Queen > Rock
(2, 2), -- Adele > Pop
(3, 1), -- OkeanElzy > Rock
(4, 3); -- Basta > Rap

-- �����: ����������� � �������
INSERT INTO artist_album (artist_id, album_id) VALUES
(1, 1), -- Queen > Bohemian Rhapsody
(2, 2), -- Adele > 25
(4, 3); -- Basta > ����� 40

-- �����: �������� � �����
INSERT INTO collection_track (collection_id, track_id) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6),
(4, 1), (4, 5);

-- ======================
-- ������� 2: SELECT-�������
-- ======================

-- 1. ����� ������� ����
SELECT title, duration
FROM track
ORDER BY duration DESC
LIMIT 1;

-- 2. ����� ? 3,5 ����� (210 ������)
SELECT title
FROM track
WHERE duration >= 210;

-- 3. �������� 2018�2020
SELECT title
FROM collection
WHERE year BETWEEN 2018 AND 2020;

-- 4. ����������� � ����� ������ � �����
SELECT name
FROM artist
WHERE name NOT LIKE '% %';

-- 5. ����� �� ������� "���" ��� "my"
SELECT title
FROM track
WHERE title ILIKE '%my%' OR title ILIKE '%���%';

-- ======================
-- ������� 3: SELECT-�������
-- ======================

-- 1. ���������� ������������ � ������ �����
SELECT g.name, COUNT(ag.artist_id) AS artist_count
FROM genre g
JOIN artist_genre ag ON g.id = ag.genre_id
GROUP BY g.name;

-- 2. ���������� ������ � �������� 2019�2020
SELECT COUNT(t.id) AS track_count
FROM track t
JOIN album a ON t.album_id = a.id
WHERE a.year BETWEEN 2019 AND 2020;

-- 3. ������� ����������������� ������ �� ��������
SELECT a.title, AVG(t.duration) AS avg_duration
FROM album a
JOIN track t ON a.id = t.album_id
GROUP BY a.title;

-- 4. ����������� ��� �������� 2020 ����
SELECT ar.name
FROM artist ar
WHERE ar.id NOT IN (
    SELECT aa.artist_id
    FROM artist_album aa
    JOIN album a ON aa.album_id = a.id
    WHERE a.year = 2020
);

-- 5. ��������, ��� ���� ����������� Queen
SELECT DISTINCT c.title
FROM collection c
JOIN collection_track ct ON c.id = ct.collection_id
JOIN track t ON ct.track_id = t.id
JOIN album a ON t.album_id = a.id
JOIN artist_album aa ON a.id = aa.album_id
JOIN artist ar ON aa.artist_id = ar.id
WHERE ar.name = 'Queen';
