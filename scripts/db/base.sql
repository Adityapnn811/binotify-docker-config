CREATE DATABASE IF NOT EXISTS binotifyrest;
CREATE DATABASE IF NOT EXISTS binotifydb;
CREATE DATABASE IF NOT EXISTS binotifysoap;

USE binotifyrest;

-- CreateTable
CREATE TABLE `User` (
    `user_id` INTEGER NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(256) NOT NULL,
    `password` VARCHAR(256) NOT NULL,
    `username` VARCHAR(256) NOT NULL,
    `name` VARCHAR(256) NOT NULL,
    `isAdmin` BOOLEAN NOT NULL DEFAULT false,

    UNIQUE INDEX `User_email_key`(`email`),
    UNIQUE INDEX `User_username_key`(`username`),
    PRIMARY KEY (`user_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Song` (
    `song_id` INTEGER NOT NULL AUTO_INCREMENT,
    `Judul` VARCHAR(64) NOT NULL,
    `penyanyi_id` INTEGER NOT NULL,
    `Audio_path` VARCHAR(256) NOT NULL,

    PRIMARY KEY (`song_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Song` ADD CONSTRAINT `Song_penyanyi_id_fkey` FOREIGN KEY (`penyanyi_id`) REFERENCES `User`(`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO User (email, password, username, name, isAdmin) VALUES ('admin@admin.com', '$2a$10$uQFiEZNCjWLkufGHPDIOW.ZTTomtPpYD4u4kPbDl1c4VlxqisQ/eO', 'admin', 'admin', true);
INSERT INTO User (email, password, username, name, isAdmin) VALUES ('rockstar@gmail.com', '$2a$10$uQFiEZNCjWLkufGHPDIOW.ZTTomtPpYD4u4kPbDl1c4VlxqisQ/eO', 'rockstar', 'Rockstar', false);
INSERT INTO User (email, password, username, name, isAdmin) VALUES ('popstar@gmail.com', '$2a$10$uQFiEZNCjWLkufGHPDIOW.ZTTomtPpYD4u4kPbDl1c4VlxqisQ/eO', 'popstar', 'Popstar', false);
INSERT INTO User (email, password, username, name, isAdmin) VALUES ('jazzstar@gmail.com', '$2a$10$uQFiEZNCjWLkufGHPDIOW.ZTTomtPpYD4u4kPbDl1c4VlxqisQ/eO', 'jazzstar', 'Jazzstar', false);
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock Keren', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock 2', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3');
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock 3', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock 4', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3');
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock 5', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock 6', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3');
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock 7', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock 8', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3');
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock 9', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
INSERT INTO Song (Judul, penyanyi_id, Audio_path) VALUES ('Lagu Rock 10', 2, 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3');


USE binotifysoap;

CREATE TABLE IF NOT EXISTS Logging (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description varchar(256) NOT NULL,
    IP varchar(16) NOT NULL,
    endpoint varchar(256) NOT NULL,
    requested_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Subscription (
    creator_id INT,
    subscriber_id INT,
    status ENUM('PENDING', 'ACCEPTED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    PRIMARY KEY(creator_id, subscriber_id)
);

CREATE TABLE IF NOT EXISTS ApiKeys (
    id INT AUTO_INCREMENT PRIMARY KEY,
    service_name varchar(256) NOT NULL,
    api_key varchar(256) NOT NULL UNIQUE
);

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

CREATE TABLE IF NOT EXISTS Subscription (
    creator_id INTEGER,
    subscriber_id INTEGER,
    status ENUM('PENDING', 'ACCEPTED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    FOREIGN KEY (subscriber_id) REFERENCES User (user_id) ON DELETE CASCADE,
    PRIMARY KEY(creator_id, subscriber_id)
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

INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (2, 3, 'PENDING');
INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (3, 3, 'PENDING');
INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (4, 3, 'PENDING');
INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (2, 4, 'PENDING');
INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (3, 4, 'PENDING');
INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (4, 4, 'PENDING');
INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (3, 5, 'PENDING');
INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (4, 5, 'PENDING');
INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (2, 2, 'PENDING');
INSERT INTO Subscription (creator_id, subscriber_id, status) VALUES (4, 2, 'PENDING');