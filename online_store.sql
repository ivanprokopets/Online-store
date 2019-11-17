CREATE DATABASE projekt_sklep3
GO
use projekt_sklep3
GO
CREATE TABLE kategoria (
ID INT NOT NULL IDENTITY PRIMARY KEY,
nazwa VARCHAR(100) NOT NULL,
zdjecie VARCHAR(100) NULL,
ilosc VARCHAR(100) NOT NULL,
 dostepnosc VARCHAR(100) NOT NULL
)
CREATE TABLE magazyn (
ID INT NOT NULL IDENTITY PRIMARY KEY,
nazwa VARCHAR(100) NOT NULL,
ilosc VARCHAR(100) NOT NULL,
data_przybycia DATETIME,
stan_produktu VARCHAR(100)
)
CREATE TABLE kraj_pochodzenia (
ID INT NOT NULL IDENTITY PRIMARY KEY,
nazwa VARCHAR(100) NOT NULL,
opis VARCHAR(100) NULL,
logotyp VARCHAR(100) NULL
)
CREATE TABLE produkt (
Produkt_ID INT NOT NULL IDENTITY PRIMARY KEY,
nazwa_produktu VARCHAR(100) NOT NULL,
opis VARCHAR(100) NULL,
model VARCHAR(100) NULL,
cena_produktu DECIMAL(8,2),
kat_ID INT FOREIGN KEY REFERENCES kategoria(ID),
magazyn_ID INT FOREIGN KEY REFERENCES magazyn(ID),
kraj_ID INT FOREIGN KEY REFERENCES kraj_pochodzenia(ID)
)
CREATE TABLE klient (
ID INT NOT NULL IDENTITY PRIMARY KEY,
imie VARCHAR(100) NOT NULL,
nazwisko VARCHAR(100) NOT NULL,
adres VARCHAR(100) NULL,
telefon VARCHAR(100) NULL,
e_mail VARCHAR(100) NULL,
IP_adress VARCHAR(100) NULL,
haslo VARCHAR(100) NULL,
zniszka VARCHAR(100) NULL
)
CREATE TABLE status_Z (
ID INT NOT NULL IDENTITY PRIMARY KEY,
nazwa VARCHAR(100) NOT NULL,
komentarz VARCHAR(100) NULL
)
CREATE TABLE zamowienie (
ID INT NOT NULL IDENTITY PRIMARY KEY,
nazwa_zamowienia VARCHAR(100) NOT NULL,
data_zamowienia DATETIME,
cena_produktu DECIMAL(8,2),
cena_zamowienia DECIMAL(8,2),
sposob_dostawy VARCHAR(100) NOT NULL,
sposob_oplaty VARCHAR(100) NOT NULL,
produkt_ID INT FOREIGN KEY REFERENCES produkt(Produkt_ID),
klient_ID INT FOREIGN KEY REFERENCES klient(ID),
status_ID INT FOREIGN KEY REFERENCES status_Z(ID)
);


/* zasilenie tabel */
INSERT INTO kategoria (nazwa, 			zdjecie,	dostepnosc) VALUES
				      ('Telewizory',	'-',		'dostepne'),
					  ('AGD', 			'-',		'dostepne'),
					  ('Komputery',		'+',		'dostepne'),
					  ('Rowery', 		'+',		'w tej chwili nie dostepne');
					  
INSERT INTO magazyn (nazwa, 				adres, 			liczba_pracownikow) VALUES
					('magazyn_Telewizory', 	'Worowska 30', 	30),
					('magazyn_AGD', 		'Kulkswa 10', 	20),
					('magazyn_Komputery', 	'Bojawna 19',	15),
					('magazyn_Rowery',		'Imbirska 99',	40);

INSERT INTO kraj_pochodzenia (nazwa, 		opis, 		logotyp) VALUES 
							 ('Polska', 	'jest', 	'jest'),
							 ('Niemcy', 	'jest', 	'jest'),
							 ('Ameryka', 	'jest', 	'jest'),
							 ('Bialorus', 	'niema', 	'niema'),
							 ('Czechy', 	'niema', 	'jest');

INSERT INTO produkt (nazwa_produktu,		opis,		model,							cena_produktu, kategoria_ID, magazyn_ID, kraj_pochodzenia_ID) VALUES
					('SAMSUNG',				'FULL-HD',	'SAMSUNG LED UE51',				1950, 1, 1, 1),
					('LG',					'FULL-HD',	'LG LED 52',					2050, 1, 1, 2),
					('PHILIPS',				'HD Ready', 'PHILIPS LED 53',				3200, 1, 1, 3),
					('SONY',				'UHD/4K',	'SAMSUNG LED UE54',				4600, 1, 1, 4),
					('PANASONIK',			'UHD/4K',	'PANASONIC LED TX-55',			5500, 1, 1, 5),

					('Lodowka BEKO',		'Biala',	'Lodowka BEKO 56RCSA',			1000, 2, 2, 1),
					('Lodowka BOSCH',		'Szara',	'Lodowka BOSCH 57KGN',			3000, 2, 2, 2),
					('Lodowka ELECTROLUX',	'Biala',	'Lodówka ELECTROLUX 58EN',		2000, 2, 2, 3),
					('Lodowka TEKA',		'Szara',	'Lodowka TEKA 59NFE',			5000, 2, 2, 4),
					('Lodowka ATLANT',		'Biala',	'Lodowka ATLANT 60MFA',			200, 2, 2, 5),

					('HP',					'Czarny',	'Laptop HP 61 G6',				1200, 3, 3, 1),
					('LENOVO',				'Szary',	'Laptop LENOVO Yoga 62 BR',		1000, 3, 3, 2),
					('APPLE',				'Srebrny',	'Laptop APPLE MacBook Pro 63',	8000, 3, 3, 3),
					('ACER',				'Srebrny',	'Laptop ACER Spin 64',			2200, 3, 3, 4),
					('DELL',				'Srebrny',	'Laptop DELL Inspiron 65',		3000, 3, 3, 5),
					
					('AIST',				'Bialy',	'Rower AIST 66',				400, 4, 4, 1),
					('INDIANA',				'Czarny',	'Rower INDIANA 67SB',			600, 4, 4, 2),
					('DAWSTAR',				'Zielony',	'Rower DAWSTAR 68BW',			700, 4, 4, 3),
					('RM',					'Czerwony',	'Rower RM 69Retro',				900, 4, 4, 4),
					('KARBON',				'Rozowy',	'Rower KARBON 70Cap',			300, 4, 4, 5);


INSERT INTO klient (imie,	nazwisko,		adres,						telefon,		e_mail,				IP_adress,		haslo,	znizka) VALUES 
				   ('Ivan',	'Prakapets',	'Warszawa, Grojecka 39',	'48510512351',	'vania@gmail.com',	'192.213.124',	'123',	'20%'),
				   ('Jan',	'Nowak',		'Wroclaw, Ozerna 20',		'48124512243',	'jan@gmail.com',	'201.241.423',	'321',	'0%'),
				   ('Jace',	'Kowalski',		'Wroclaw, Hola 220',		'48124512243',	'jacekw@gmail.com',	'201.241.413',	'331',	'5%'),
				   ('Anna',	'Mazur',		'Krakow, Borna 10',			'48124512243',	'ann@gmail.com',	'191.241.423',	'311',	'30%');

INSERT INTO status_zamowienie (nazwa,				data_czas_zamowienia,				opis) VALUES
/* opis-opis*/
					 ('wyslano',			convert(datetime,'20180607',112),	'kurjer sie skontaktuje '),
					 ('w trakcie wyslania',	convert(datetime,'20180508',112),	'prosze czekac'),
					 ('oczekiwanie oplaty',	convert(datetime,'20180808',112),	'prosze oplacic'),
					 ('wyslano',			convert(datetime,'20180612',112),	'kurjer sie skontaktuje');

INSERT INTO zamowienie (nazwa_zamowienia,				data_zamowienia,					cena_produktu, cena_zamowienia, sposob_dostawy,	sposob_oplaty,	produkt_ID, klient_ID, status_ID) VALUES
					   ('Telewizor SAMSUNG LED UE51',	convert(datetime,'20180607',112),	1560,		   20,				'kurjer',		'przy odbiorze', 1, 1, 1),
					   ('Lodowka BOSCH 57KGN',			convert(datetime,'20180508',112),	2400,		   14,				'kurjer',		'przy odbiorze', 7, 2, 2),
					   ('Laptop APPLE MacBook Pro 63',	convert(datetime,'20180808',112),	7600,		   23,				'paczka',		'karta',		 13, 3, 3),
					   ('Rower RM 69Retro',				convert(datetime,'20180612',112),	630,		   40,				'kurjer',		'przy odbiorze', 1, 4, 4);
/*Tworzenie procedur*/
GO
CREATE PROCEDURE [dbo].insert_kategoria 
	@nazwa VARCHAR(100),
	@zdjecie VARCHAR(100),
	@dostepnosc VARCHAR(100)
AS
	BEGIN TRY
		INSERT INTO kategoria ([nazwa],
							   [zdjecie],		
							   [dostepnosc]) 
						VALUES
							  (@nazwa,
							   @zdjecie,		
							   @dostepnosc);
	END TRY
	BEGIN CATCH 
		PRINT 'nie wolno wstawiac takiej samej kategorii'
	END CATCH
/*
wywolanie 1 procedury [dbo].insert_kategoria

EXECUTE [dbo].insert_kategoria 'kamery', '+','dostepne'
GO
SELECT * FROM kategoria
*/
GO