DROP DATABASE IF EXISTS SolarDB;
CREATE DATABASE IF NOT EXISTS SolarDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE SolarDB;

DROP TABLE IF EXISTS Energy_Sold;
DROP TABLE IF EXISTS Energy_Price;
DROP TABLE IF EXISTS Battery_Charge;
DROP TABLE IF EXISTS Batteries;
DROP TABLE IF EXISTS Battery_Types;
DROP TABLE IF EXISTS Panel_Tilt;
DROP TABLE IF EXISTS Panel_Production;
DROP TABLE IF EXISTS Panels;
DROP TABLE IF EXISTS Panel_Types;
DROP TABLE IF EXISTS Station_Owners;
DROP TABLE IF EXISTS Stations;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(150) NOT NULL,
    Email VARCHAR(150) UNIQUE,
    Phone VARCHAR(30),
    Created_At DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON Users(Email);
CREATE INDEX idx_users_name ON Users(Full_Name);

CREATE TABLE Stations (
    Station_ID INT AUTO_INCREMENT PRIMARY KEY,
    Station_Name VARCHAR(150),
    Address VARCHAR(255),
    City VARCHAR(100),
    Install_Date DATE,
    Timezone VARCHAR(50) DEFAULT 'Europe/Kyiv',
    Created_At DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_stations_city ON Stations(City);
CREATE INDEX idx_stations_name ON Stations(Station_Name);

CREATE TABLE Station_Owners (
    Station_ID INT NOT NULL,
    User_ID INT NOT NULL,
    Ownership_Since DATE,
    Ownership_Share DECIMAL(5,2) DEFAULT 100.00,
    PRIMARY KEY (Station_ID, User_ID),
    FOREIGN KEY (Station_ID) REFERENCES Stations(Station_ID) ON DELETE CASCADE,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE
);

CREATE INDEX idx_stationowners_user ON Station_Owners(User_ID);
CREATE INDEX idx_stationowners_since ON Station_Owners(Ownership_Since);

CREATE TABLE Panel_Types (
    Panel_Type_ID INT AUTO_INCREMENT PRIMARY KEY,
    Manufacturer VARCHAR(100),
    Model VARCHAR(100),
    Power_Watt INT NOT NULL,
    Efficiency DECIMAL(5,2),
    Created_At DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_paneltypes_manufacturer ON Panel_Types(Manufacturer);
CREATE INDEX idx_paneltypes_power ON Panel_Types(Power_Watt);

CREATE TABLE Panels (
    Panel_ID INT AUTO_INCREMENT PRIMARY KEY,
    Station_ID INT NOT NULL,
    Panel_Type_ID INT NOT NULL,
    Serial_Number VARCHAR(100),
    Install_Date DATE,
    Location_Notes VARCHAR(200),
    FOREIGN KEY (Station_ID) REFERENCES Stations(Station_ID) ON DELETE CASCADE,
    FOREIGN KEY (Panel_Type_ID) REFERENCES Panel_Types(Panel_Type_ID) ON DELETE RESTRICT
);

CREATE INDEX idx_panels_station ON Panels(Station_ID);
CREATE INDEX idx_panels_type ON Panels(Panel_Type_ID);

CREATE TABLE Panel_Production (
    Prod_ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Panel_ID INT NOT NULL,
    Measure_Time DATETIME NOT NULL,
    Energy_Wh INT NOT NULL,
    Sensor_Notes VARCHAR(200),
    FOREIGN KEY (Panel_ID) REFERENCES Panels(Panel_ID) ON DELETE CASCADE
);

CREATE INDEX idx_prod_panel_time ON Panel_Production(Panel_ID, Measure_Time);
CREATE INDEX idx_prod_time ON Panel_Production(Measure_Time);

CREATE TABLE Panel_Tilt (
    Tilt_ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Panel_ID INT NOT NULL,
    Measure_Time DATETIME NOT NULL,
    Tilt_Angle DECIMAL(6,2) NOT NULL,
    Motor_Active BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (Panel_ID) REFERENCES Panels(Panel_ID) ON DELETE CASCADE
);

CREATE INDEX idx_tilt_panel_time ON Panel_Tilt(Panel_ID, Measure_Time);
CREATE INDEX idx_tilt_time ON Panel_Tilt(Measure_Time);

CREATE TABLE Battery_Types (
    Battery_Type_ID INT AUTO_INCREMENT PRIMARY KEY,
    Manufacturer VARCHAR(100),
    Model VARCHAR(100),
    Capacity_kWh DECIMAL(8,3) NOT NULL,
    Nominal_Voltage DECIMAL(6,2),
    Created_At DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_battypes_manufacturer ON Battery_Types(Manufacturer);
CREATE INDEX idx_battypes_capacity ON Battery_Types(Capacity_kWh);

CREATE TABLE Batteries (
    Battery_ID INT AUTO_INCREMENT PRIMARY KEY,
    Station_ID INT NOT NULL,
    Battery_Type_ID INT NOT NULL,
    Serial_Number VARCHAR(100),
    Install_Date DATE,
    FOREIGN KEY (Station_ID) REFERENCES Stations(Station_ID) ON DELETE CASCADE,
    FOREIGN KEY (Battery_Type_ID) REFERENCES Battery_Types(Battery_Type_ID) ON DELETE RESTRICT
);

CREATE INDEX idx_batteries_station ON Batteries(Station_ID);
CREATE INDEX idx_batteries_type ON Batteries(Battery_Type_ID);

CREATE TABLE Battery_Charge (
    Charge_ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Battery_ID INT NOT NULL,
    Measure_Time DATETIME NOT NULL,
    Charge_Percent DECIMAL(5,2) NOT NULL,
    Charge_Wh DECIMAL(10,2),
    FOREIGN KEY (Battery_ID) REFERENCES Batteries(Battery_ID) ON DELETE CASCADE
);

CREATE INDEX idx_batt_charge_time ON Battery_Charge(Battery_ID, Measure_Time);
CREATE INDEX idx_batt_charge_percent ON Battery_Charge(Charge_Percent);

CREATE TABLE Energy_Price (
    Price_ID INT AUTO_INCREMENT PRIMARY KEY,
    Valid_From DATETIME NOT NULL,
    Valid_To DATETIME NULL,
    Price_UAH_per_kWh DECIMAL(8,4) NOT NULL,
    Source_Notes VARCHAR(200)
);

CREATE INDEX idx_price_valid_from ON Energy_Price(Valid_From);
CREATE INDEX idx_price_valid_to ON Energy_Price(Valid_To);

CREATE TABLE Energy_Sold (
    Sold_ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Station_ID INT NOT NULL,
    Price_ID INT NOT NULL,
    Measure_Time DATETIME NOT NULL,
    Energy_Wh INT NOT NULL,
    FOREIGN KEY (Station_ID) REFERENCES Stations(Station_ID) ON DELETE CASCADE,
    FOREIGN KEY (Price_ID) REFERENCES Energy_Price(Price_ID) ON DELETE RESTRICT
);

CREATE INDEX idx_energy_sold_station_time ON Energy_Sold(Station_ID, Measure_Time);
CREATE INDEX idx_energy_sold_time ON Energy_Sold(Measure_Time);

INSERT INTO Users (Full_Name, Email, Phone) VALUES
('Олена Іваненко', 'olena.ivanenko@example.com', '+380671112233'),
('Ігор Петренко', 'igor.petrenko@example.com', '+380501223344'),
('Марія Коваль', 'maria.koval@example.com', '+380631112233'),
('Андрій Шевченко', 'andriy.shevchenko@example.com', '+380671998877'),
('Світлана Мельник', 'svitlana.melnyk@example.com', '+380632223344'),
('Віктор Кравець', 'viktor.kravets@example.com', '+380501112233'),
('Олексій Руденко', 'oleksiy.rudenko@example.com', '+380672223344'),
('Катерина Гнатюк', 'kateryna.hnatyuk@example.com', '+380631234567'),
('Ірина Бойко', 'iryna.boyko@example.com', '+380672334455'),
('Петро Левченко', 'petro.levchenko@example.com', '+380504445566'),
('Надія Сидоренко', 'nadiya.sydorenko@example.com', '+380673336677'),
('Роман Жук', 'roman.zhuk@example.com', '+380632998877');

INSERT INTO Stations (Station_Name, Address, City, Install_Date) VALUES
('SolarHome-1', 'вул. Лесі Українки, 12', 'Lviv', '2024-05-20'),
('FarmPV-A', 'Сільська дорога 3', 'Kyiv', '2023-10-10'),
('RoofTop-Office', 'просп. Свободи, 45', 'Lviv', '2025-03-01'),
('Village-Array', 'с. Нове, вул. Центральна, 1', 'Kharkiv', '2022-08-15'),
('CommunityPark', 'парк Сонячний, 7', 'Odesa', '2025-01-12'),
('MultiOwner-Site', 'вул. Промислова, 10', 'Dnipro', '2024-11-30'),
('School-Roof', 'вул. Шкільна, 5', 'Lviv', '2023-09-01'),
('Factory-Roof', 'вул. Заводська, 20', 'Dnipro', '2024-02-15'),
('Greenhouse', 'трас. 8, ділянка 4', 'Kyiv', '2022-06-10'),
('Mall-Roof', 'просп. Центр, 1', 'Odesa', '2024-07-20'),
('Remote-Micro', 'с. Поле, вул. Нова, 18', 'Chernihiv', '2025-04-10'),
('Community-Hub', 'вул. Центральна, 2', 'Kharkiv', '2024-10-05');

INSERT INTO Station_Owners VALUES
(1,1,'2024-05-20',100.00),
(2,2,'2023-10-10',100.00),
(3,3,'2025-03-01',100.00),
(4,4,'2022-08-15',100.00),
(5,5,'2025-01-12',100.00),
(6,6,'2024-11-30',60.00),
(6,7,'2024-11-30',30.00),
(6,8,'2024-11-30',10.00),
(7,9,'2023-09-01',100.00),
(8,10,'2024-02-15',100.00),
(9,11,'2022-06-10',100.00),
(10,12,'2024-07-20',100.00);

INSERT INTO Panel_Types (Manufacturer, Model, Power_Watt, Efficiency) VALUES
('SunPower','SPR-X21-350',350,22.6),
('JA Solar','JAM72-330',330,20.1),
('Trina','TSM-295',295,18.9),
('LG','LG370Q1C',370,21.7),
('Canadian Solar','CS6K-300',300,18.5),
('Longi','LR5-480',480,21.2),
('REC','Alpha-400',400,20.8),
('QCells','Q.PEAK DUO',360,20.3),
('FirstSolar','FS-300',300,17.5),
('Panasonic','P-370',370,21.0),
('Sharp','SH-285',285,18.0),
('Suntech','ST-320',320,19.2);

INSERT INTO Panels (Station_ID, Panel_Type_ID, Serial_Number, Install_Date, Location_Notes) VALUES
(1,1,'SP-0001','2024-05-20','дах ліворуч'),
(1,2,'JA-0102','2024-05-20','дах праворуч'),
(2,3,'TR-2001','2023-10-11','поле ряд 1'),
(2,4,'LG-3002','2023-10-11','поле ряд 2'),
(3,5,'CS-5001','2025-03-02','дах офісу'),
(4,6,'LG-480-01','2022-08-16','масив захід'),
(5,7,'REC-7001','2025-01-13','парк — зона А'),
(6,8,'QC-8001','2024-12-01','індустріальна дах'),
(6,2,'JA-8002','2024-12-01','індустріальна дах'),
(6,1,'SP-8003','2024-12-01','індустріальна дах'),
(7,9,'FS-9001','2023-09-02','шкільний дах'),
(8,10,'PAN-1001','2024-02-16','фабричний дах');

INSERT INTO Panel_Production (Panel_ID, Measure_Time, Energy_Wh, Sensor_Notes) VALUES
(1,'2025-10-29 06:00:00',120,NULL),
(1,'2025-10-29 07:00:00',400,NULL),
(1,'2025-10-29 12:00:00',950,NULL),
(1,'2025-10-29 15:00:00',700,NULL),
(2,'2025-10-29 07:00:00',380,NULL),
(2,'2025-10-29 12:00:00',920,NULL),
(3,'2025-10-29 10:00:00',800,NULL),
(4,'2025-10-29 11:00:00',850,NULL),
(5,'2025-10-29 12:00:00',1000,NULL),
(6,'2025-10-29 14:00:00',620,NULL),
(7,'2025-10-29 13:00:00',980,NULL),
(8,'2025-10-29 12:00:00',900,NULL);

INSERT INTO Panel_Tilt (Panel_ID, Measure_Time, Tilt_Angle, Motor_Active) VALUES
(1,'2025-10-29 06:00:00',15.00,0),
(1,'2025-10-29 09:00:00',25.00,1),
(1,'2025-10-29 12:00:00',35.00,1),
(1,'2025-10-29 15:00:00',20.00,1),
(2,'2025-10-29 07:00:00',18.50,0),
(3,'2025-10-29 10:00:00',30.00,1),
(4,'2025-10-29 11:00:00',28.00,1),
(5,'2025-10-29 12:00:00',32.00,1),
(6,'2025-10-29 14:00:00',22.00,0),
(7,'2025-10-29 13:00:00',27.50,1),
(8,'2025-10-29 12:00:00',33.00,1),
(11,'2025-10-29 08:00:00',19.00,0);

INSERT INTO Battery_Types (Manufacturer, Model, Capacity_kWh, Nominal_Voltage) VALUES
('Tesla','Powerwall-2',13.50,350.0),
('LG Chem','RESU10H',9.80,400.0),
('Samsung SDI','ECO-12',12.00,380.0),
('BYD','Battery-10',10.00,360.0),
('Panasonic','EverVolt-14',14.00,370.0),
('Saft','Home-8',8.00,360.0),
('Pylontech','US5000',5.12,48.0),
('CATL','Home-12',12.50,380.0),
('Narada','N-6K',6.00,48.0),
('SunStorage','SS-11',11.00,360.0),
('ABB','AB-10',10.00,360.0),
('Enersys','EN-9',9.00,350.0);

INSERT INTO Batteries (Station_ID, Battery_Type_ID, Serial_Number, Install_Date) VALUES
(1,1,'TW-PW-0001','2024-05-20'),
(2,2,'LG-RESU-0002','2023-10-11'),
(3,3,'SDI-0003','2025-03-02'),
(4,4,'BYD-0004','2022-08-16'),
(5,5,'PAN-0005','2025-01-13'),
(6,6,'SAFT-0006','2024-12-01'),
(6,7,'PYL-0007','2024-12-01'),
(2,8,'CATL-0008','2023-10-11'),
(7,9,'NAR-0009','2023-09-05'),
(8,10,'SS-0010','2024-02-20'),
(9,11,'ABB-0011','2022-06-12'),
(10,12,'EN-0012','2024-07-22');

INSERT INTO Battery_Charge (Battery_ID, Measure_Time, Charge_Percent, Charge_Wh) VALUES
(1,'2025-10-29 06:00:00',45.00,6075.00),
(1,'2025-10-29 09:00:00',60.00,8100.00),
(1,'2025-10-29 12:00:00',85.00,11475.00),
(2,'2025-10-29 10:00:00',50.00,4900.00),
(3,'2025-10-29 13:00:00',70.00,8400.00),
(4,'2025-10-29 11:00:00',30.00,3000.00),
(5,'2025-10-29 12:00:00',95.00,13300.00),
(6,'2025-10-29 14:00:00',55.00,4400.00),
(7,'2025-10-29 15:00:00',65.00,3320.00),
(8,'2025-10-29 09:00:00',40.00,5000.00),
(9,'2025-10-29 08:00:00',20.00,1200.00),
(10,'2025-10-29 16:00:00',78.50,8635.00);

INSERT INTO Energy_Price (Valid_From, Valid_To, Price_UAH_per_kWh, Source_Notes) VALUES
('2025-10-29 00:00:00','2025-10-29 05:59:59',0.85,NULL),
('2025-10-29 06:00:00','2025-10-29 08:59:59',1.20,NULL),
('2025-10-29 09:00:00','2025-10-29 11:59:59',1.05,NULL),
('2025-10-29 12:00:00','2025-10-29 13:59:59',1.50,NULL),
('2025-10-29 14:00:00','2025-10-29 17:59:59',1.10,NULL),
('2025-10-29 18:00:00','2025-10-29 21:59:59',1.30,NULL),
('2025-10-29 22:00:00','2025-10-29 23:59:59',0.90,NULL),
('2025-10-30 00:00:00','2025-10-30 05:59:59',0.80,NULL),
('2025-10-30 06:00:00','2025-10-30 11:59:59',1.25,NULL),
('2025-10-30 12:00:00','2025-10-30 17:59:59',1.55,NULL),
('2025-10-30 18:00:00','2025-10-30 23:59:59',1.40,'weekend rate'),
('2025-10-31 00:00:00',NULL,1.10,'default');

INSERT INTO Energy_Sold (Station_ID, Price_ID, Measure_Time, Energy_Wh) VALUES
(1,2,'2025-10-29 06:00:00',5000),
(1,4,'2025-10-29 12:00:00',12000),
(2,3,'2025-10-29 10:00:00',8000),
(3,4,'2025-10-29 12:00:00',15000),
(4,5,'2025-10-29 15:00:00',7000),
(5,6,'2025-10-29 19:00:00',9000),
(6,2,'2025-10-29 07:00:00',4000),
(6,4,'2025-10-29 12:00:00',14000),
(2,1,'2025-10-29 03:00:00',1200),
(3,9,'2025-10-30 08:00:00',10000),
(7,11,'2025-10-30 19:00:00',6000),
(8,10,'2025-10-30 13:00:00',11000);

USE SolarDB;

SELECT * FROM Users;
SELECT * FROM Stations;
SELECT * FROM Station_Owners;
SELECT * FROM Panel_Types;
SELECT * FROM Panels;
SELECT * FROM Panel_Production;
SELECT * FROM Panel_Tilt;
SELECT * FROM Battery_Types;
SELECT * FROM Batteries;
SELECT * FROM Battery_Charge;
SELECT * FROM Energy_Price;
SELECT * FROM Energy_Sold;
