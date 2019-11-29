CREATE DATABASE projekt_sklep3
GO
use projekt_sklep3
GO
IF EXISTS	(SELECT 1 FROM sysobjects o
			WHERE (o.[name] = 'pr_rmv_table')
			AND	(OBJECTPROPERTY(o.[ID],'IsProcedure')=1)
			)
	BEGIN
		DROP PROCEDURE pr_rmv_table		
	END
GO
CREATE PROCEDURE [dbo].pr_rmv_table
	(@table_name nvarchar(100))
AS
/* Procedura sprawdza czy istnieje w bazie tabela @table_name
** Jak tak to usuwa j№
*/
	DECLARE @stmt nvarchar(1000)

	IF EXISTS ( SELECT 1 FROM sysobjects o
				WHERE (o.[name] = @table_name)
				AND	(OBJECTPROPERTY(o.[ID],'IsUserTable')=1)
			   )
	BEGIN
		SET @stmt = 'DROP TABLE ' + @table_name
		EXECUTE sp_executeSQL @stmt = @stmt
	END
GO
/* Usuniкcie tabel w kolejnosci odwrotnej do ich zaloїenia */

EXEC pr_rmv_table @table_name='ProduktLogs'
EXEC pr_rmv_table @table_name='KlientLogs'
EXEC pr_rmv_table @table_name='zamowienie'
EXEC pr_rmv_table @table_name='status_zamowienie'
EXEC pr_rmv_table @table_name='klient'
EXEC pr_rmv_table @table_name='produkt'
EXEC pr_rmv_table @table_name='osoba'
EXEC pr_rmv_table @table_name='kraj_pochodzenia'
EXEC pr_rmv_table @table_name='magazyn'
EXEC pr_rmv_table @table_name='kategoria'

/*Usuniecie wszystkich tablic
DROP TABLE ProduktLogs
DROP TABLE KlientLogs
DROP TABLE zamowienie
DROP TABLE status_zamowienie
DROP TABLE klient
DROP TABLE produkt
DROP TABLE kraj_pochodzenia
DROP TABLE magazyn
DROP TABLE kategoria*/
/*Usuniecie procedur
DROP PROCEDURE [dbo].insert_kategoria
DROP PROCEDURE [dbo].insert_magazyn
DROP PROCEDURE [dbo].insert_klient
DROP PROCEDURE [dbo].insert_produkt
DROP PROCEDURE [dbo].insert_zamowienie
DROP PROCEDURE [dbo].insert_status_zamowienieamowienia
DROP PROCEDURE [dbo].insetr_kraj_pochodzenia
DROP PROCEDURE [dbo].dodawanie_do_kategorii_i_magazynu
DROP PROCEDURE [dbo].dodawanie_do_kraju_i_produktu
DROP PROCEDURE [dbo].dodawanie_do_zamowienia_klienta_statusa
DROP PROCEDURE [dbo].update_kategoria
DROP PROCEDURE [dbo].update_klient
DROP PROCEDURE [dbo].update_kraj_pochodzenia
DROP PROCEDURE [dbo].update_magazyn
DROP PROCEDURE [dbo].update_produkt
DROP PROCEDURE [dbo].update_status
DROP PROCEDURE [dbo].update_zamowienie
*/
/*Usuniecie trigerow
DROP TRIGGER Trigger_zatwierdzenia_statusu_zamowienia_z_data
DROP TRIGGER Trigger_niedozwalone_znaki_produkt
DROP TRIGGER Trigger_haszowanie_hasla_klienta
DROP TRIGGER Trigger_info_o_wstawieniu_rekordu_klient
DROP TRIGGER Trigger_info_o_zmianie_danych_klienta
DROP TRIGGER Trigger_info_o_usunieciu_klienta
DROP TRIGGER Trigger_delete_NULL_dzialania
DROP TRIGGER Trigger_info_o_usunieciu_produktu
DROP TRIGGER Trigger_przepisania_pierwsza_litery_imienia_i_nazwiska_do_tabeli_IN
*/
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
CREATE PROCEDURE [dbo].insert_klient
	@imie VARCHAR(100),
	@nazwisko VARCHAR(100),
	@adres VARCHAR(100),
	@telefon VARCHAR(100),
	@email VARCHAR(100),
	@IpAdress VARCHAR(100),
	@haslo VARCHAR(100),
	@znizka VARCHAR(100)
AS
	BEGIN TRY
		INSERT INTO klient ([imie],
							[nazwisko],
							[adres],
							[telefon],
							[e_mail],
							[IP_adress],
							[haslo],
							[znizka])
					  VALUES
						   (@imie,
							@nazwisko,
							@adres,
							@telefon,
							@email,
							@IpAdress,
							@haslo,
							@znizka);
	END TRY
	BEGIN CATCH 
		PRINT 'nie wolno wstawiac takiego samego e-mail adresu'
	END CATCH
/*
wywolanie 2 procedury [dbo].insert_klient

EXECUTE [dbo].insert_klient 'Fred',	'Prap',	'Warszawa, Grojecka 32',	'48511512351',	'v1a@gmail.com',	'192.215.124',	'155',	'0%'
GO 
SELECT * FROM klient
*/
GO
CREATE PROCEDURE [dbo].insetr_kraj_pochodzenia
	@nazwa_kraju VARCHAR(100),
	@opis VARCHAR(100),
	@logotyp VARCHAR(100)
AS	
	BEGIN TRY
	INSERT INTO kraj_pochodzenia ([nazwa],
								  [opis],
								  [logotyp])
							VALUES
								 (@nazwa_kraju,
								  @opis,
								  @logotyp);
	END TRY
	BEGIN CATCH 
		PRINT 'nie wolno wstawiac takiego samego kraju_pochodzenia'
	END CATCH
/*
wywolanie 3 procedury [dbo].insert_kra_pochodzenia

EXECUTE [dbo].insetr_kraj_pochodzenia 'Rumynia', 	'jest', 	'niema'
GO
SELECT * FROM kraj_pochodzenia
*/
GO
CREATE PROCEDURE [dbo].insert_magazyn 
	@nazwa_magazynu VARCHAR(100),
	@adres VARCHAR(100),
	@liczba_pracownikow INT
AS
	BEGIN TRY
		INSERT INTO magazyn ([nazwa],
							 [adres],
							 [liczba_pracownikow])
					  VALUES
							(@nazwa_magazynu,
							 @adres,
							 @liczba_pracownikow);
	END TRY
	BEGIN CATCH 
		PRINT 'nie wolno wstawiac takiego samego magazynu i adresu, juz istnieje'
	END CATCH
/*
wywolanie 4 procedury [dbo].insert_magazyn

EXECUTE [dbo].insert_magazyn 'magazyn_Ogrod', 'Wawelska 53',41
GO
SELECT * FROM magazyn
*/
GO
CREATE PROCEDURE [dbo].insert_produkt
	@nazwa_produktu VARCHAR(100),
	@opis VARCHAR(100),
	@model VARCHAR(100),
	@cena_produktu DECIMAL,
	@kategora_ID INT,
	@magazyn_ID INT,
	@kraj_pochodzenia_ID INT
AS
	INSERT INTO produkt ([nazwa_produktu],
						 [opis],
						 [model],
						 [cena_produktu],
						 [kategoria_ID],
						 [magazyn_ID],
						 [kraj_pochodzenia_ID])
				  VALUES
						(@nazwa_produktu,
						 @opis,
						 @model,
						 @cena_produktu,
						 @kategora_ID,
						 @magazyn_ID,
						 @kraj_pochodzenia_ID);
/*
wywolanie 5 procedury [dbo].insert_produkt

EXECUTE [dbo].insert_produkt 'szczokta', 'dluga',	'Uniwirsalna', 20, 5, 5, 6
GO
SELECT * FROM produkt
*/
GO
CREATE PROCEDURE [dbo].insert_status_zamowienieamowienia
	@nazwa VARCHAR(100),
	@data_czas_zamowienia DATETIME,
	@opis VARCHAR(100)
AS
	INSERT INTO status_zamowienie ([nazwa],
								   [data_czas_zamowienia],
								   [opis])
						    VALUES
								  (@nazwa,
								   @data_czas_zamowienia,
								   @opis);
/*
wywolanie 6 procedury [dbo].insert_status_zamowienieamowienia

EXECUTE [dbo].insert_status_zamowienieamowienia 'wyslano', '2018-05-25T14:25:10', 'prosze czekac'
GO 
SELECT * FROM status_zamowienie
*/
GO
CREATE PROCEDURE [dbo].insert_zamowienie 
	@nazwa_zamowienia VARCHAR(100),
	@data_zamowienia datetime,
	@cena_produktu DECIMAL,
	@cena_zamowienia DECIMAL,
	@sposob_dostawy VARCHAR(100),
	@sposob_oplaty VARCHAR(100),
	@produkt_ID INT,
	@klient_ID INT,
	@status_ID INT
AS
	INSERT INTO zamowienie ([nazwa_zamowienia],
							[data_zamowienia],
							[cena_produktu],
							[cena_zamowienia],
							[sposob_dostawy],
							[sposob_oplaty],
							[produkt_ID],
							[klient_ID],
							[status_ID])
					 VALUES
						   (@nazwa_zamowienia,
							@data_zamowienia,
							@cena_produktu,
							@cena_zamowienia,
							@sposob_dostawy,
							@sposob_oplaty,
							@produkt_ID,
							@klient_ID,
							@status_ID);
/*
wywolanie 7 procedury [dbo].insert_zamowienie

EXECUTE [dbo].insert_zamowienie 'szczotka', '2018-05-25T14:25:10', 20, 5, 'kurjer', 'przy odbiorze', 1, 1, 1
GO
SELECT * FROM zamowienie
*/
GO
CREATE PROCEDURE [dbo].update_kategoria
	@ID INT,
	@dostepnosc VARCHAR(100)
AS
	UPDATE kategoria
	SET dostepnosc = @dostepnosc
	WHERE ID = @ID
/*
wywolanie 8 procedury [dbo].update_kategoria

EXECUTE [dbo].update_kategoria 4,'nie dostepne'
GO
SELECT * FROM kategoria 
*/
GO
CREATE PROCEDURE [dbo].update_klient
	@ID INT,
	@adres VARCHAR(100),
	@telefon VARCHAR(100),
	@email VARCHAR(100),
	@haslo VARCHAR(100),
	@znizka VARCHAR(100)
AS
	UPDATE klient
	SET adres = @adres,
		telefon = @telefon,
		e_mail = @email,
		haslo = @haslo,
		znizka = @znizka
	WHERE ID = @ID
/*
wywolanie 9 procedury [dbo].update_klient

EXECUTE [dbo].update_klient 4,'Lublin, Tosza 31', '48105523512', 'vankow@gmail.com', '412', '0%'
GO
SELECT * FROM klient
*/
GO
CREATE PROCEDURE [dbo].update_kraj_pochodzenia
	@ID INT,
	@logotyp VARCHAR(100)
AS
	UPDATE kraj_pochodzenia
	SET logotyp = @logotyp
	WHERE ID = @ID
/*
wywolanie 10 procedury [dbo].update_kraj_pochodzenia

EXECUTE [dbo].update_kraj_pochodzenia 5, 'jest'
GO
SELECT * FROM kraj_pochodzenia
*/
GO
CREATE PROCEDURE [dbo].update_magazyn
	@ID INT,
	@liczba_pracownikow INT
AS
	UPDATE magazyn
	SET liczba_pracownikow = @liczba_pracownikow
	WHERE ID = @ID
/*
wywolanie 11 procedury [dbo].update_magazyn

EXECUTE [dbo].update_magazyn 4, 5
GO
SELECT * FROM magazyn
*/
GO
CREATE PROCEDURE [dbo].update_produkt
	@ID INT,
	@opis VARCHAR(100),
	@cena_produktu VARCHAR(100)
AS
	UPDATE produkt
	SET opis = @opis,
		cena_produktu = @cena_produktu
	WHERE ID = @ID
/*
wywolanie 12 procedury [dbo].update_produkt

EXECUTE [dbo].update_produkt 20, 'zielony', '500'
GO
SELECT * FROM produkt
*/
GO
CREATE PROCEDURE [dbo].update_status
	@ID INT,
	@opis VARCHAR(100)
AS
	UPDATE status_zamowienie
	SET opis = @opis
	WHERE ID = @ID
/*
wywolanie 13 procedury [dbo].update_status

EXECUTE [dbo].update_status 3, 'kurjer sie skontaktuje'
GO
SELECT * FROM status_zamowienie
*/
GO
CREATE PROCEDURE [dbo].update_zamowienie
	@ID INT,
	@cena_produktu VARCHAR(100),
	@cena_zamowienia VARCHAR(100),
	@sposob_dostawy VARCHAR(100),
	@sposob_oplaty VARCHAR(100)
AS
	UPDATE zamowienie
	SET cena_produktu = @cena_produktu,
		cena_zamowienia = @cena_zamowienia,
		sposob_dostawy = @sposob_dostawy,
		sposob_oplaty = @sposob_oplaty
	WHERE ID = @ID
/*
wywolanie 14 procedury [dbo].update_zamowienie

EXECUTE [dbo].update_zamowienie 4, '640', '50', 'kurjer dostawczy', 'karta'
GO
SELECT * FROM zamowienie
*/
GO
CREATE PROCEDURE [dbo].dodawanie_do_kategorii_i_magazynu
	/*kategoria*/
	@nazwa VARCHAR(100),
	@zdjecie VARCHAR(100),
	@dostepnosc VARCHAR(100),
	/*magazyn*/
	@nazwa_magazynu VARCHAR(100),
	@adres VARCHAR(100),
	@liczba_pracownikow INT
AS
	/*kategoria*/
	INSERT INTO kategoria ([nazwa],
						   [zdjecie],	
						   [dostepnosc]) 
					VALUES
						  (@nazwa,
						   @zdjecie,	
						   @dostepnosc);
	/*magazyn*/
	INSERT INTO magazyn ([nazwa],
						 [adres],
						 [liczba_pracownikow])
				  VALUES
						(@nazwa_magazynu,
						 @adres,
						 @liczba_pracownikow);
/*
wywolanie 15 procedury [dbo].dodawanie_do_kategorii_i_magazynu

EXECUTE [dbo].dodawanie_do_kategorii_i_magazynu /*kategoria*/'komorki', '+','dostepne',
												/*magazyn*/  'komorki', 'Wilianowska 81',150;
SELECT * FROM kategoria,magazyn;
*/
GO
CREATE PROCEDURE [dbo].dodawanie_do_kraju_i_produktu
	/*kraj_pochodzenia*/
	@nazwa_kraju VARCHAR(100),
	@opis VARCHAR(100),
	@logotyp VARCHAR(100),
	/*produkt*/
	@nazwa_produktu VARCHAR(100),
	@opis_produktu VARCHAR(100),
	@model VARCHAR(100),
	@cena_produktu DECIMAL,
	@kategora_ID INT,
	@magazyn_ID INT,
	@kraj_pochodzenia_ID INT
AS
	/*kraj_pochodzenia*/
	BEGIN TRY
		INSERT INTO kraj_pochodzenia ([nazwa],
									  [opis],
									  [logotyp])
								VALUES
									 (@nazwa_kraju,
									  @opis,
									  @logotyp);
	END TRY
	BEGIN CATCH 
		PRINT 'nie wolno wstawiac takiego samego kraju_pochodzenia'
	END CATCH

	/*produkt*/
	INSERT INTO produkt ([nazwa_produktu],
						 [opis],
						 [model],
						 [cena_produktu],
						 [kategoria_ID],
						 [magazyn_ID],
						 [kraj_pochodzenia_ID])
				  VALUES
						(@nazwa_produktu,
						 @opis_produktu,
						 @model,
						 @cena_produktu,
						 @kategora_ID,
						 @magazyn_ID,
						 @kraj_pochodzenia_ID);
/*
wywolanie 16 procedury [dbo].dodawanie_do_kraju_i_produktu

EXECUTE [dbo].dodawanie_do_kraju_i_produktu /*kraj*/   'Litwa', 'niema', 'niema',
											/*produkt*/'FISCHER', 'niebieski',	'Rower Fischer 71GB', 900, 4, 4, 1;
SELECT * FROM kraj_pochodzenia,produkt;
*/
GO
CREATE PROCEDURE [dbo].dodawanie_do_zamowienia_klienta_statusa
	/*zamowienie*/
	@nazwa_zamowienia VARCHAR(100),
	@data_zamowienia datetime,
	@cena_produktu DECIMAL,
	@cena_zamowienia DECIMAL,
	@sposob_dostawy VARCHAR(100),
	@sposob_oplaty VARCHAR(100),
	@produkt_ID INT,
	@klient_ID INT,
	@status_ID INT,
	/*klient*/
	@imie VARCHAR(100),
	@nazwisko VARCHAR(100),
	@adres VARCHAR(100),
	@telefon VARCHAR(100),
	@email VARCHAR(100),
	@IpAdress VARCHAR(100),
	@haslo VARCHAR(100),
	@znizka VARCHAR(100),
	/*status*/
	@nazwa VARCHAR(100),
	@opis VARCHAR(100)
AS
	/*zamowienie*/
	INSERT INTO zamowienie ([nazwa_zamowienia],
							[data_zamowienia],
							[cena_produktu],
							[cena_zamowienia],
							[sposob_dostawy],
							[sposob_oplaty],
							[produkt_ID],
							[klient_ID],
							[status_ID])
					 VALUES
						   (@nazwa_zamowienia,
							@data_zamowienia,
							@cena_produktu,
							@cena_zamowienia,
							@sposob_dostawy,
							@sposob_oplaty,
							@produkt_ID,
							@klient_ID,
							@status_ID);
	/*klient*/
	BEGIN TRY
		INSERT INTO klient ([imie],
							[nazwisko],
							[adres],
							[telefon],
							[e_mail],
							[IP_adress],
							[haslo],
							[znizka])
					  VALUES
						   (@imie,
							@nazwisko,
							@adres,
							@telefon,
							@email,
							@IpAdress,
							@haslo,
							@znizka);
	END TRY
	BEGIN CATCH 
		PRINT 'nie wolno wstawiac takiego samego e-mail adresu'
	END CATCH
	/*status*/
	INSERT INTO status_zamowienie ([nazwa],
						  [opis])
				   VALUES
						 (@nazwa,
						  @opis);
/*
wywolanie 17 procedury [dbo].dodawanie_do_zamowienia_klienta_statusa

EXECUTE [dbo].dodawanie_do_zamowienia_klienta_statusa /*zamowienie*/'szczotka', '2018/05/04', 20, 5, 'kurjer', 'przy odbiorze', 15, 2, 1,
													  /*klient*/	'Bartek',	'Pietrowski',	'Gdansk, Morska 12', '48512432345', 'bartek@gmail.com',	'193.215.124',	'512',	'0%',
													  /*status*/	'w trakcie wyslania', 'prosze czekac'
SELECT * FROM zamowienie,klient,status_zamowienie
*/


/*Tworzenie Triggerow*/
GO
CREATE TRIGGER Trigger_zatwierdzenia_statusu_zamowienia_z_data
			ON status_zamowienie
	AFTER UPDATE 
AS
	BEGIN 
		UPDATE status_zamowienie
		SET data_czas_zamowienia = GETDATE()
		FROM status_zamowienie s
		INNER JOIN inserted i ON s.ID = i.ID
		AND i.opis = 'zatwierdzony'
	END 

/*sprawdzanie Trigger_zatwierdzenia_statusu_zamowienia_z_data №1

UPDATE status_zamowienie SET opis = 'zatwierdzony' WHERE ID=4
GO 
SELECT * FROM status_zamowienie
GO
*/
GO

CREATE TRIGGER Trigger_niedozwalone_znaki_produkt 
			ON produkt FOR UPDATE, INSERT 
AS
	BEGIN
	UPDATE produkt 
	SET nazwa_produktu = REPLACE(nazwa_produktu, '/','') 
	WHERE nazwa_produktu IN (SELECT i.nazwa_produktu FROM inserted i) 
	AND nazwa_produktu LIKE '%/%' 
	END
/*sprawdzanie Trigger_niedozwalone_znaki_produkt  №2

UPDATE produkt
SET nazwa_produktu ='/Test1'
WHERE id =1
SELECT * FROM produkt
*/
/*
INSERT produkt(nazwa_produktu) VALUES
		('/Test2');
GO 
SELECT * FROM produkt
GO
*/

GO
CREATE TRIGGER Trigger_haszowanie_hasla_klienta
			ON klient
	AFTER INSERT, UPDATE 
AS
	DECLARE @klient_haslo VARCHAR(100)
	DECLARE @ID_klient VARCHAR(100)
	BEGIN TRY
		SELECT @klient_haslo = i.haslo, @ID_klient = i.ID FROM inserted i;
		UPDATE klient 
		SET haslo = HASHBYTES('md5',@klient_haslo) WHERE ID=@ID_klient 
	END TRY
	BEGIN CATCH 
		PRINT 'nie wolno wstawiac takiego samego e-mail adresu'
	END CATCH

/*sprawdzanie Trigger_haszowanie_hasla_klienta №1,3

INSERT INTO klient (imie,		nazwisko,		adres,					telefon,		e_mail,			IP_adress,		haslo,		znizka) VALUES 
				   ('Vasia',	'Ivanov',	'Brest, Brestka 39',	'48510512151',	'vasia@gmail.com',	'196.213.124',	'112423',	'0%');
GO
SELECT * FROM klient
GO
*/

GO
CREATE TABLE KlientLogs (
	ID_log INT NOT NULL IDENTITY PRIMARY KEY,
	ID_klient INT NOT NULL,
	dzialanie VARCHAR(100) NULL,
	data_dzialania DATETIME
)

GO
CREATE TRIGGER Trigger_info_o_wstawieniu_rekordu_klient
			ON klient
	AFTER INSERT
AS
	BEGIN TRY
		DECLARE @ID_klient INT

		SELECT @ID_klient = inserted.ID FROM inserted

		INSERT INTO KlientLogs (ID_klient,	 dzialanie,	 data_dzialania) VALUES
							   (@ID_klient, 'Wstawiono', GETDATE());
	END TRY
	BEGIN CATCH 
		PRINT 'nie wolno wstawiac takiego samego e-mail adresu'
	END CATCH

/*sprawdzanie Trigger_info_o_wstawieniu_rekordu_klient №2

INSERT INTO klient (imie,		nazwisko,		adres,					telefon,		e_mail,			IP_adress,		haslo,		znizka) VALUES 
				   ('Vasia',	'Ivanov',	'Brest, Brestka 39',	'48510512151',	'vasiatest@gmail.com',	'196.213.124',	'112423',	'0%');
GO
SELECT * FROM KlientLogs
GO
*/
GO
CREATE TRIGGER Trigger_info_o_zmianie_danych_klienta
			ON klient
	AFTER UPDATE
AS
	BEGIN
		DECLARE @ID_klient INT
		DECLARE @Dzialanie VARCHAR(100)
		 
			IF UPDATE(imie)
				BEGIN
					SET @Dzialanie = 'Zaktualizowane imie'
				END
 
			IF UPDATE(nazwisko)
				BEGIN	
					SET @Dzialanie = 'Zaktualizowane nazwisko'
				END
			IF UPDATE(adres)
				BEGIN	
					SET @Dzialanie = 'Zaktualizowany adres'
				END
			IF UPDATE(telefon)
				BEGIN	
					SET @Dzialanie = 'Zaktualizowany telefon'
				END
			IF UPDATE(e_mail)
				BEGIN	
					SET @Dzialanie = 'Zaktualizowany mail'
				END
			IF UPDATE(haslo)
				BEGIN	
					SET @Dzialanie = 'Zaktualizowane haslo'
				END
			IF UPDATE(znizka)
				BEGIN	
					SET @Dzialanie = 'Zmieniona znizka'
				END
 
		INSERT INTO KlientLogs (		ID_klient,					dzialanie,	 data_dzialania) VALUES
							   ((SELECT inserted.ID FROM inserted), @Dzialanie,  GETDATE());
	END
/*sprawdzanie Trigger_info_o_zmianie_danych_klienta №4

	UPDATE klient 
	SET znizka = '29%'
	WHERE ID=4;
GO
SELECT * FROM KlientLogs
GO
*/

GO
CREATE TRIGGER Trigger_info_o_usunieciu_klienta
			ON klient 
	AFTER DELETE
AS
	BEGIN TRY
		DECLARE @ID_klient INT
		
		DELETE Z From deleted d 
		JOIN dbo.zamowienie Z ON d.ID IN (Z.klient_ID);
		DELETE klient
		FROM deleted
		WHERE deleted.ID = klient.ID;
		SELECT @ID_klient = deleted.ID FROM deleted
		
		
		
		INSERT INTO KlientLogs (			ID_klient,			  dzialanie,  data_dzialania) VALUES
							   ((SELECT deleted.ID FROM deleted), 'Usunieto', GETDATE());
	
	END TRY
	BEGIN CATCH
		PRINT 'Wprowadzony klient już jest usuniety'
	END CATCH
/*sprawdzanie Trigger_info_o_usunieciu_klienta №1
	DELETE FROM klient
	WHERE ID = 7;
GO
SELECT * FROM KlientLogs
GO
 */
GO
CREATE TRIGGER Trigger_delete_NULL_dzialania	
			 ON KlientLogs 
	FOR UPDATE,INSERT
AS
	BEGIN
		DELETE FROM KlientLogs
		WHERE dzialanie IS NULL
	END
/*Trigger_nie_da_sie_sprawdzic*/
GO
CREATE TABLE ProduktLogs (
	ID_log INT NOT NULL IDENTITY PRIMARY KEY,
	ID_Produkt INT NOT NULL,
	dzialanie VARCHAR(100) NOT NULL,
	data_dzialania DATETIME
)

GO
CREATE TRIGGER Trigger_info_o_usunieciu_produktu
			 ON produkt
	AFTER DELETE
AS
	BEGIN TRY
		INSERT INTO ProduktLogs (		ID_Produkt,						dzialanie,	  data_dzialania) VALUES
							   ((SELECT deleted.ID FROM deleted), 'Usunieto', GETDATE());
	END TRY 
	BEGIN CATCH
		PRINT 'Wprowadzony produkt już jest usuniety'
	END CATCH
/*sprawdzanie Trigger_info_o_usunieciu_produktu №2
	DELETE FROM produkt
	WHERE ID = 6;
GO
SELECT * FROM ProduktLogs
*/

GO
CREATE TRIGGER Trigger_przepisania_pierwsza_litery_imienia_i_nazwiska_do_tabeli_IN
			ON klient 
	FOR UPDATE
AS
	IF UPDATE(nazwisko) OR UPDATE(imie)
	UPDATE klient SET I_N = LEFT(imie,1) + nazwisko
	WHERE ID IN (SELECT i.ID FROM inserted i)
	GO
	
/*sprawdzanie Trigger_przepisania_pierwsza_litery_imienia_i_nazwiska_do_tabeli_IN №2
	UPDATE klient
	SET imie = 'Petia', nazwisko ='Wiatrokowski'
	WHERE ID =4;
GO
SELECT * FROM klient
*/
