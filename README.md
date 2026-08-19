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
