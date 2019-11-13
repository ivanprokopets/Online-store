# Online-store
Database for online store (order)


## Opis biznesowy projektu
1. Moim tematem projektu jest „Internet-sklep(zamówienie)”.
2. Wybrałem go, bo na czas dzisiejszy istnieje dużo sklepów internetowych z
bardzo złą bazą danych i zdecydowałem zrobić fajniejszą niż ostatnie.
3. Jestem pewnym, że ludzie, firmy będą korzystać z mojej bazy danych.
4. Moja baza danych zawiera w sobie 7 tabel (proszę spojrzeć do diagramu baz).
5. Baza danych będzie bardzo wygodna i lakoniczna. Łatwo wprowadzić zmiany.

## Propozycje procedur i triggerów
1. Procedura będzie umożliwiać dodawanie nowego produktu do magazynu
2. Procedura będzie umożliwiać dodawanie nazwy kraju pochodzenia produktu w
tabeli kraj_zrobienia
3. Procedura będzie umożliwiać usuwać produkt z sklepu, jeżeli go nie ma w
sklepie.
4. Trigger będzie umożliwiać zabezpieczenia hasła w tabeli osoby w wierszu
haslo, zakodowano w md5 lub innym.
5. Trigger będzie umożliwiać update magazynu, w razie dodania nowego
produktu zamiast starego.
6. Trigger będzie umożliwiać update produktu w tabeli produkt.
7. Trigger będzie aktualizował status_zamówienia, jeżeli paczka dotarła.
8. Trigger będzie umożliwiać usuwanie starych produktów, które już nie istnieją.
