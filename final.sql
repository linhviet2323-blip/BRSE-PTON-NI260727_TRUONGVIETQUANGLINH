-- Tao CSDL
CREATE DATABASE IF NOT EXISTS module02dbb;
USE module02;

-- Tao bang 

-- bang football_teams
CREATE TABLE IF NOT EXISTS football_teams(
	team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(100) NOT NULL,
    team_code VARCHAR(20) NOT NULL UNIQUE,
    home_area VARCHAR(100) NOT NULL,
    founded_date DATE NOT NULL
);

-- bang players
CREATE TABLE IF NOT EXISTS players(
	player_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    preferred_position VARCHAR(30),
    CHECK(preferred_position IN('Thủ môn','Hậu vệ','Tiền vệ','Tiền đạo')),
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    skill_rating DECIMAL(3,1) DEFAULT 5.0
    CHECK (skill_rating BETWEEN 0.0 AND 10.0)
);

-- bang matches
CREATE TABLE IF NOT EXISTS matches(
	match_id INT PRIMARY KEY AUTO_INCREMENT,
    team_id INT,
    opponent_name VARCHAR(100) NOT NULL,
    venue VARCHAR(150) NOT NULL,
    match_time DATETIME NOT NULL,
    pitch_fee DECIMAL(10,2) CHECK(pitch_fee >= 0),
    status VARCHAR(30),
    CHECK(status IN('Scheduled','Completed','Cancelled')),
    FOREIGN KEY (team_id) REFERENCES football_teams(team_id)
);

-- bang match_registrations

CREATE TABLE IF NOT EXISTS match_registrations(
	registration_id INT PRIMARY KEY AUTO_INCREMENT,
	match_id INT,
	player_id INT,
	attendance_status VARCHAR(30),
    CHECK(attendance_status IN ('Registered','Played','Absent')),
	goals INT DEFAULT 0 CHECK(goals >= 0),
	registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (match_id) REFERENCES matches(match_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- bang team logs

CREATE TABLE IF NOT EXISTS team_logs(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    registration_id INT,
    player_id INT,
    log_time DATETIME NOT NULL,
    note TEXT NOT NULL,
    FOREIGN KEY (registration_id) REFERENCES match_registrations(registration_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- INSERT ban ghi 

-- bang foolball_teams

INSERT INTO football_teams(team_name, team_code, home_area, founded_date)
VALUES ('Sài Gòn Strikers','SGS','Quận 1','2018-10-3'),
('Thuder FC','TFC','TP Thủ Đức','2021-6-15'),
('Brothers United','BRU','Bình Thạnh','2016-9-20'),
('Weekend Warrious','WKW','Quận 7','2022-1-8'),
('Office Eleven','011','Gò Vấp','2019-11-30');

-- bang players

INSERT INTO players(full_name, preferred_position, phone_number, skill_rating)
VALUES ('Nguyễn Minh Khang','Tiền Đạo','901112233','8.2'),
('Trần Hoàng Nam','Tiền Vệ','902223344','7.5'),
('Lê Quốc Huy','Hậu Vệ','903334455','7.8'),
('Phạm Gia Bảo','Thủ môn','904445566','8.2'),
('Võ Thành Công','Tiền vệ','905556677','7');

-- bang matches

INSERT INTO matches (match_id, team_id, opponent_name, venue, match_time, pitch_fee, status)
VALUES ('7001','1','Black Cats','Sân Tao Đàn','2026-5-20 18:00','1200000','Scheduled'),
('7002','3','Blue Sharks','Sân Gia Định','2026-5-21 19:30','1500000','Completed'),
('7003','2','Bình Minh FC','Sân Linh Trung','2026-5-22 18:30','1000000','Completed'),
('7004','5','Red Bulls','Sân Kỳ Hòa','2026-5-23 20:00','1300000','Cancelled'),
('7005','4','Young Boys','Sân Hoàng Văn Thụ','2026-5-24 17:30','1100000','Scheduled');

-- bang match_registrations

INSERT INTO match_registrations(registration_id, match_id, player_id, attendance_status, goals, registered_at)
VALUES ('8001','7002','1','Played','2','2026-5-19 9:00'),
('8002','7002','3','Played','0','2026-5-19 9:15'),
('8003','7001','2','Registered','0','2026-5-18 20:00'),
('8004','7003','5','Played','1','2026-5-20 8:30'),
('8005','7004','4','Absent','0','2026-5-21 10:00');

-- bang team_logs

INSERT INTO team_logs(registration_id, player_id, log_time, note)
VALUES('8003','2','2026-5-18 20:05','Xác nhận tham gia trận'),
('8001','1','2026-5-19 9:05','Đăng ký đá chính'),
('8002','3','2026-5-19 9:20','Xác nhận tham gia'),
('8004','5','2026-5-20 8:35','Đã có mặt tại sân'),
('8005','4','2026-5-23 20:05','Vắng mặt thông báo trước');

-- UPDATE và DELETE
-- 1 Tăng pitch_fee thêm 100000 cho trận có trạng thái là Completed

SET SQL_SAFE_UPDATES = 0;

UPDATE matches
SET pitch_fee = pitch_fee + 100000
WHERE status = 'Completed';

SET SQL_SAFE_UPDATES = 1;

-- 2. Xoa ban ghi trong team_logs cso log_time truoc ngay 2026-05-20

SET SQL_SAFE_UPDATES = 0;

DELETE FROM team_logs
WHERE log_time < '2026-05-20 0:00';

SET SQL_SAFE_UPDATES = 1;

-- Phan 3

-- Cau 1. liet ke full_name, preferred_position va skill_rating
-- cua cac cau thu diem ky nang > 7.8 or co vi tri 'Tien ve'

SELECT full_name, preferred_position, skill_rating
FROM players
WHERE skill_rating > '7.8' OR preferred_position = 'Tiền Vệ';

-- Cau 2. liet ke opponent_name, venue, match_time cac tran
-- Dien ra tu ngay 2026-05-20 den het ngay 2026-05-22
-- Ten doi doi thu bat dau bang chu '%B'

SELECT opponent_name, venue, match_time
FROM matches
WHERE match_time BETWEEN '2026-05-20 00:00' AND '2026-05-22 23:59' AND opponent_name LIKE 'B%';

-- Cau 3. liet ke registration_id, goals va registered_at:
-- Sap xep goals giam dan
-- Neu so ban thang bang nhau, sap xep registration_id tang dan
-- Moi trang co 2 ban ghi
-- Chi hien thi trang thu hai

SELECT registration_id, goals, registered_at
FROM match_registrations
ORDER BY goals DESC , registration_id ASC
LIMIT 2 OFFSET 2;

-- Phan 4
-- Cau 1: ket hop cac bang lien quan de liet ke:
-- Ten doi bong
-- Ten doi doi thu
-- Ho ten cau thu
-- Vi tri so truong
-- So ban thang
-- Thoi gian thi dau

SELECT f.team_name, m.opponent_name, p.full_name, p.preferred_position, mr.goals, m.match_time
FROM match_registrations mr
JOIN players p
ON mr.player_id = p.player_id
JOIN matches m
ON mr.match_id = m.match_id
JOIN football_teams f
ON m.team_id = f.team_id;

-- Cau 2: liet ke ho ten cau thu va tong so ban thang trong cac dang ky co attendance_status = 'Played'
-- Chi hien thi nhung cau thu co tong so ban thang > 1

SELECT p.full_name, SUM(mr.goals)
FROM match_registrations mr
JOIN players p
ON mr.player_id = p.player_id
WHERE attendance_status = 'Played'
GROUP BY p.player_id, p.full_name
HAVING SUM(mr.goals) > 1; 

-- Cau 3: liet ke player_id, full_name va skill_rating cua cau thu co diem ky nang cao nhat
-- Neu nhieu cau thu dong hang cao nhat hien thi tat ca 

SELECT player_id, full_name, skill_rating
FROM players
WHERE skill_rating = (
	SELECT MAX(skill_rating)
    FROM players
);

-- Phan 5
-- cau 1: tao chi muc ket hop tren bang match_registrations gom:
-- attendance_status
-- goals

CREATE INDEX idx_attendance_status_goals
ON match_registrations(attendance_status, goals);

-- Cau 2: tao view:
-- player_id, full_name, tong so tran da dang ky, tong so ban thang
-- khong tinh cac dang ky co attendance_status = 'Absent'
-- Cau thu chua co dang ky hop le van phai xuat hien
-- cac gia tri tong cua cau thu chua co dang ky bang 0

CREATE VIEW v_full_name_total_match_total_goals AS
SELECT p.player_id, p.full_name, COUNT(mr.match_id) AS total_match, SUM(mr.goals) AS total_goals
FROM match_registrations mr
JOIN players p
ON mr.player_id = p.player_id
WHERE attendance_status <> 'Absent'
GROUP BY p.player_id, p.full_name;

SELECT * FROM v_full_name_total_match_total_goals;


-- Phan 6 

-- Cau 1.Viet trigger chay sau cap nhap bang match_registrations
-- Khi attendance_status thuc su chuyen tu mot gia tri khac sang Played, he thong tu dong them mot ban ghi vao team_logs:
-- registration_id : ma dang ky vua cap nhap
-- player_id: cau thu cua dang ky
-- note: Player confirmed as played
-- log_time : thoi gian hien tai cua he thong
DELIMITER $$
CREATE TRIGGER tg_after_update_match_registrations
AFTER UPDATE ON match_registrations
FOR EACH ROW
	BEGIN
    
DELIMITER ;





