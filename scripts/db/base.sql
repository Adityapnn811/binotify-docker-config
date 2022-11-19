CREATE DATABASE binotifyrest;
CREATE DATABASE binotifydb;

USE binotifydb;

CREATE TABLE IF NOT EXISTS User (
    user_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    email varchar(255) NOT NULL UNIQUE,
    password varchar(256) NOT NULL,
    username varchar(256) NOT NULL UNIQUE,
    is_admin boolean NOT NULL
);

CREATE TABLE IF NOT EXISTS Album (
    album_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    Judul varchar(64) NOT NULL,
    Penyanyi varchar(64) NOT NULL,
    Total_duration int DEFAULT 0 NOT NULL,
    Image_path varchar(256) NOT NULL,
    Tanggal_terbit date NOT NULL,
    Genre varchar(64)
);

CREATE TABLE IF NOT EXISTS Song (
    song_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    Judul varchar(64) NOT NULL,
    Penyanyi varchar(64),
    Tanggal_terbit date NOT NULL,
    Genre varchar(64),
    Duration int NOT NULL,
    Audio_path varchar(256) NOT NULL,
    Image_path varchar(256) NOT NULL,
    album_id int DEFAULT NULL,
    FOREIGN KEY (album_id) REFERENCES Album (album_id) ON DELETE SET NULL
);

DROP TRIGGER IF EXISTS before_song_insert;
DROP TRIGGER IF EXISTS before_song_update;
DROP TRIGGER IF EXISTS before_song_delete;

DELIMITER //

CREATE TRIGGER before_song_insert BEFORE INSERT ON Song
FOR EACH ROW
BEGIN
    IF NEW.album_id is not NULL THEN
        UPDATE Album
        SET Total_duration = Total_duration + NEW.Duration
        WHERE album_id = NEW.album_id;
    END IF;
END;//

CREATE TRIGGER before_song_update BEFORE UPDATE ON Song
FOR EACH ROW
BEGIN
    IF NEW.album_id is not NULL and OLD.album_id is NULL THEN
        UPDATE Album
        SET Total_duration = Total_duration + NEW.Duration
        WHERE album_id = NEW.album_id;
    ELSEIF NEW.album_id is NULL and OLD.album_id is not NULL THEN
        UPDATE Album
        SET Total_duration = Total_duration - OLD.Duration
        WHERE album_id = OLD.album_id;
    ELSEIF NEW.album_id != OLD.album_id THEN
        UPDATE Album
        SET Total_duration = Total_duration + NEW.Duration
        WHERE album_id = NEW.album_id;
        UPDATE Album
        SET Total_duration = Total_duration - OLD.Duration
        WHERE album_id = OLD.album_id;
    END IF;
END;//

CREATE TRIGGER before_song_delete BEFORE DELETE ON Song
FOR EACH ROW
BEGIN
    IF OLD.album_id is not NULL THEN
        UPDATE Album
        SET Total_duration = Total_duration - OLD.Duration
        WHERE album_id = OLD.album_id;
    END IF;
END;//

DELIMITER ;

INSERT INTO Album (Judul, Penyanyi, Image_path, Tanggal_terbit, Genre)
VALUES ('Blurryface',	'Twenty One Pilots',	'./img/blurryface.png',	'2022-10-10',	'alt rock');

INSERT INTO Album (Judul, Penyanyi, Image_path, Tanggal_terbit, Genre)
VALUES ('Speak Now',	'Taylor Swift',	'./img/SpeakNow.png',	'2022-10-04',	'Pop music');

INSERT INTO Album (Judul, Penyanyi, Image_path, Tanggal_terbit, Genre)
VALUES ('1989',	'Taylor Swift',	'./img/1989.png',	'2014-11-11',	'Synth pop');

INSERT INTO Album (Judul, Penyanyi, Image_path, Tanggal_terbit, Genre)
VALUES ('Tulus',	'Tulus',	'./img/tulus.jpg',	'2011-11-11',	'Pop music');

INSERT INTO Album (Judul, Penyanyi, Image_path, Tanggal_terbit, Genre)
VALUES ('Positions',	'Ariana Grande',	'./img/positions.png',	'2021-10-10',	'R&B/Soul');

INSERT INTO Album (Judul, Penyanyi, Image_path, Tanggal_terbit, Genre)
VALUES ('In The Lonely Hour',	'Sam Smith',	'./img/inTheLonelyHour.png',	'2014-05-04',	'Neo-R&B');

INSERT INTO Album (Judul, Penyanyi, Image_path, Tanggal_terbit, Genre)
VALUES ('Shivers',	'Ed Sheeran',	'./img/shivers.png',	'2021-02-02',	'Alternative/Indie');


INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Stressed Out', 'Twenty One Pilots', '2022-10-10', 'alt rock', 10, '/img/', './img/blurryface.png', 1);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Mine', 'Taylor Swift', '2010-11-11', 'Pop music', 4, '/img/', './img/SpeakNow.png', 2);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Better Than Revenge', 'Taylor Swift', '2010-11-11', 'Pop music', 3, '/img/', './img/SpeakNow.png', 2);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Back To December', 'Taylor Swift', '2010-11-11', 'Pop music', 5, '/img/', './img/SpeakNow.png', 2);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Wildest Dreams', 'Taylor Swift', '2014-11-11', 'Synth pop', 4, '/img/', './img/1989.png', 3);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Style', 'Taylor Swift', '2014-11-11', 'Synth pop', 4, '/img/', './img/1989.png', 3);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Sewindu', 'Tulus', '2011-11-11', 'Pop music', 4, '/img/', './img/tulus.jpg', 4);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Shake It Off', 'Taylor Swift', '2014-11-11', 'Synth pop', 4, '/img/', './img/1989.png', 3);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Teman Hidup', 'Tulus', '2011-11-11', 'Pop music', 4, '/img/', './img/tulus.jpg', 4);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('34+35', 'Ariana Grande', '2021-10-10', 'Contemporary R&B', 3, './songs/34+35.mp3', './img/positions.png', 5);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('pov', 'Ariana Grande', '2021-10-10', 'Rhythm and blues', 3, '/img/', './img/positions.png', 5);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Stay With Me', 'Sam Smith', '2014-05-04', 'Soul music', 3, '/img/', './img/inTheLonelyHour.png', 6);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Shivers', 'Ed Sheeran', '2021-02-02', 'Alternative/Indie', 3, '/img/', './img/shivers.png', 7);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Bad Habits', 'Ed Sheeran', '2021-02-02', 'Alternative/Indie', 3, '/img/', './img/shivers.png', 7);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('Kisah Sebentar', 'Tulus', '2011-11-11', 'Pop music', 4, '/img/', './img/tulus.jpg', 4);

INSERT INTO Song (Judul, Penyanyi, Tanggal_terbit, Genre, Duration, Audio_path, Image_path, album_id)
VALUES ('New Romantics', 'Taylor Swift', '2014-11-11', 'Synth pop', 4, '/img/', './img/1989.png', 3);


INSERT INTO User (email, password, username, is_admin)
VALUES ('admin@gmail.com',	'$2y$10$iBVwrblN1uIUCM/jOTUWcupusFlk55goYl6aI3INGBnhkEYqXqtjC',	'admin', true);

INSERT INTO User (email, password, username, is_admin)
VALUES ('user@gmail.com',	'$2y$10$j86bYERe7.hu/Rb4UwAyCehglN5wKU0Q.qNyaNYtLwY.GuWOB4Iji',	'user', false);

INSERT INTO User (email, password, username, is_admin)
VALUES ('monic@gmail.com', '$2y$10$nWN8fKvmxPeSzvN277QcZuJ7NGE.c8gwb9P5ANzA746TXsXyHxuku', 'monic', false);

INSERT INTO User (email, password, username, is_admin)
VALUES ('adit@gmail.com', '$2y$10$v94G9lgm9kaNPK1B7DB5COjaPXaZdyvSurCIlWqav/vg3BCDur3sG', 'adit', false);

INSERT INTO User (email, password, username, is_admin)
VALUES ('nathan@gmail.com', '$2y$10$vSGgl/xA.ydPUfumzDNiROA1Gm3sW1jgOUzM90Hork0VKR9/7NFA6', 'nathan', false);