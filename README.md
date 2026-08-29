baza danych: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final


# analiza-danych---sprzedaz-przy-uzyciu-SQL-powerquery-powerBI
Analiza danych przy użyciu SQL:
  1. SPRZEDAŻ I ZYSK W PODZIALE NA KATEGORIE I PODKATEGORIE
```sql
SELECT 
    Category,
    [Sub-Category],
    SUM(Sales) AS Laczna_Sprzedaz,
    SUM(Profit) AS Laczny_Zysk
FROM [dbo].[Sample - Superstore]
GROUP BY Category, [Sub-Category]
ORDER BY Category, Laczna_Sprzedaz DESC;
```
  2. MARŻA ZYSKU (%) W PODZIALE NA SUB-CATEGORY
```sql
SELECT 
    [Sub-Category],
    SUM(Sales) AS Laczna_Sprzedaz,
    SUM(Profit) AS Laczny_Zysk,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Marza_Procent
FROM [dbo].[Sample - Superstore]
GROUP BY [Sub-Category]
ORDER BY Marza_Procent ASC;
```
  3. TREND SPRZEDAŻY MIESIĄC PO MIESIĄCU / ROK PO ROKU
```sql
SELECT 
    YEAR([Order Date])  AS Rok,
    MONTH([Order Date]) AS Miesiac,
    SUM(Sales)  AS Laczna_Sprzedaz,
    SUM(Profit) AS Laczny_Zysk
FROM [dbo].[Sample - Superstore]
GROUP BY YEAR([Order Date]), MONTH([Order Date])
ORDER BY Rok, Miesiac;
```
  4. TOP 10 KLIENTÓW WG WARTOŚCI SPRZEDAŻY
```sql
SELECT TOP 10
    [Customer Name],
    Segment,
    SUM(Sales) AS Laczna_Sprzedaz,
    COUNT(DISTINCT [Order ID]) AS Liczba_Zamowien
FROM [dbo].[Sample - Superstore]
GROUP BY [Customer Name], Segment
ORDER BY Laczna_Sprzedaz DESC;
```
  5. ŚREDNI CZAS DOSTAWY W PODZIALE NA SHIP MODE
```sql
SELECT 
    [Ship Mode],
    AVG(DATEDIFF(DAY, [Order Date], [Ship Date])) AS Sredni_Czas_Dostawy_Dni,
    COUNT(*) AS Liczba_Zamowien
FROM [dbo].[Sample - Superstore]
GROUP BY [Ship Mode]
ORDER BY Sredni_Czas_Dostawy_Dni;
```
  6. SPRZEDAŻ WEDŁUG SEGMENTU
```sql
SELECT
	segment,
	sum(sales) AS laczna_sprzedaz
FROM [dbo].[Sample - Superstore]
GROUP BY Segment;
```
 DODATKOWE: SZUKANIE DUPLIKATÓW
 ```sql
SELECT 
    [Order ID],
    [Product ID],
    COUNT(*) AS liczba_wystapien
FROM [dbo].[Sample - Superstore]
GROUP BY [Order ID], [Product ID]
HAVING COUNT(*) > 1
ORDER BY liczba_wystapien DESC;
```


**tworzenie dashboardu z zdobytych danych(zobacz dasboard1.png oraz dashboarrd2.png)**


**krótka analiza:**
-Trend sprzedaży jest wyraźnie wzrostowy — od ok. 15 tys. w styczniu 2014 do ponad 120 tys. w grudniu 2017, z powtarzającą się sezonowością: sprzedaż systematycznie rośnie pod koniec każdego roku (listopad–grudzień) i spada w styczniu,

-Segment Consumer generuje ponad połowę przychodów firmy (50,56%), Corporate odpowiada za 30,74%, a Home Office to najmniejszy, choć wciąż istotny segment (18,7%),

-Nie wszystkie kategorie są jednakowo opłacalne mimo wysokiej sprzedaży — podkategoria "Tables" mimo sprzedaży rzędu 207 tys. generuje ujemny zysk (ok. -18 tys.),

-"Phones" i "Chairs" to najsilniejsze linie produktowe pod względem sprzedaży (330 tys. i 328 tys.), a mimo to ich marże pozostają umiarkowane względem wolumenu,

-10 kluczowych klientów (z pośród 793) odpowiada za nieproporcjonalnie dużą część przychodów — 6,68%.

