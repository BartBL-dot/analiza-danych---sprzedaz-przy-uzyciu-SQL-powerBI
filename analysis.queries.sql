/* =====================================================================
   PROJEKT: Analiza sprzedaży - Sample Superstore
   PLIK: 02_analysis_queries.sql
   ===================================================================== */


-- =====================================================================
-- 1. SPRZEDAŻ I ZYSK W PODZIALE NA KATEGORIE I PODKATEGORIE
-- PYTANIE: Które kategorie i podkategorie produktów generują
--          najwyższą sprzedaż i zysk?
-- CEL: Zidentyfikować, które linie produktowe są najbardziej wartościowe
--      dla firmy, a które wymagają uwagi.
-- =====================================================================
SELECT 
    Category,
    [Sub-Category],
    SUM(Sales) AS Laczna_Sprzedaz,
    SUM(Profit) AS Laczny_Zysk
FROM [dbo].[Sample - Superstore]
GROUP BY Category, [Sub-Category]
ORDER BY Category, Laczna_Sprzedaz DESC;


-- =====================================================================
-- 2. MARŻA ZYSKU (%) W PODZIALE NA SUB-CATEGORY
-- PYTANIE: Które podkategorie mają najniższą (lub ujemną) marżę zysku?
-- CEL: Wykryć podkategorie, które sprzedają się dobrze, ale są
--      nieopłacalne - kandydaci do przeglądu cen lub rabatów.
-- =====================================================================
SELECT 
    [Sub-Category],
    SUM(Sales) AS Laczna_Sprzedaz,
    SUM(Profit) AS Laczny_Zysk,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Marza_Procent
FROM [dbo].[Sample - Superstore]
GROUP BY [Sub-Category]
ORDER BY Marza_Procent ASC;
-- NULLIF zabezpiecza przed dzieleniem przez 0


-- =====================================================================
-- 3. TREND SPRZEDAŻY MIESIĄC PO MIESIĄCU / ROK PO ROKU
-- PYTANIE: Jak zmieniała się sprzedaż i zysk w czasie?
-- CEL: Zidentyfikować sezonowość oraz ogólny kierunek wzrostu/spadku
--      sprzedaży w kolejnych latach.
-- =====================================================================
SELECT 
    YEAR([Order Date])  AS Rok,
    MONTH([Order Date]) AS Miesiac,
    SUM(Sales)  AS Laczna_Sprzedaz,
    SUM(Profit) AS Laczny_Zysk
FROM [dbo].[Sample - Superstore]
GROUP BY YEAR([Order Date]), MONTH([Order Date])
ORDER BY Rok, Miesiac;


-- =====================================================================
-- 4. SPRZEDAŻ I ZYSK W PODZIALE NA REGION -> STATE -> CITY
-- PYTANIE: Które regiony, stany i miasta generują najwyższą sprzedaż
--          i zysk?
-- CEL: Zlokalizować geograficznie najmocniejsze i najsłabsze rynki.
-- =====================================================================
SELECT 
    Region,
    State,
    City,
    SUM(Sales)  AS Laczna_Sprzedaz,
    SUM(Profit) AS Laczny_Zysk
FROM [dbo].[Sample - Superstore]
GROUP BY Region, State, City
ORDER BY Region, Laczna_Sprzedaz DESC;


-- =====================================================================
-- 5. TOP 10 KLIENTÓW WG WARTOŚCI SPRZEDAŻY
-- PYTANIE: Którzy klienci generują dla firmy najwyższą wartość?
-- CEL: Zidentyfikować kluczowych klientów (np. pod kątem programów
--      lojalnościowych lub priorytetowej obsługi).
-- =====================================================================
SELECT TOP 10
    [Customer Name],
    Segment,
    SUM(Sales) AS Laczna_Sprzedaz,
    COUNT(DISTINCT [Order ID]) AS Liczba_Zamowien
FROM [dbo].[Sample - Superstore]
GROUP BY [Customer Name], Segment
ORDER BY Laczna_Sprzedaz DESC;


-- =====================================================================
-- 6. ŚREDNI CZAS DOSTAWY W PODZIALE NA SHIP MODE
-- PYTANIE: Jak długo trwa dostawa w zależności od wybranego trybu
--          wysyłki?
-- CEL: Ocenić efektywność logistyczną poszczególnych metod wysyłki.
-- =====================================================================
SELECT 
    [Ship Mode],
    AVG(DATEDIFF(DAY, [Order Date], [Ship Date])) AS Sredni_Czas_Dostawy_Dni,
    COUNT(*) AS Liczba_Zamowien
FROM [dbo].[Sample - Superstore]
GROUP BY [Ship Mode]
ORDER BY Sredni_Czas_Dostawy_Dni;


-- =====================================================================
-- 8. STRATA MIMO WYSOKIEJ SPRZEDAŻY (problem z rabatami)
-- PYTANIE: Które zamówienia mają sprzedaż wyższą niż średnia,
--          a mimo to generują stratę?
-- CEL: Wykryć powiązanie wysokich rabatów z ujemnym zyskiem -
--      argument do rewizji polityki rabatowej.
-- =====================================================================
SELECT 
    [Order ID],
    [Product Name],
    Sales,
    Discount,
    Profit
FROM [dbo].[Sample - Superstore]
WHERE Profit < 0
    AND Sales > (SELECT AVG(Sales) FROM [dbo].[Sample - Superstore])
ORDER BY Discount DESC, Sales DESC;


-- =====================================================================
-- DODATKOWE: DUPLIKATY (Order ID + Product ID)
-- PYTANIE: Czy w danych występują zduplikowane wiersze dla tej samej
--          kombinacji zamówienia i produktu?
-- =====================================================================
SELECT 
    [Order ID],
    [Product ID],
    COUNT(*) AS liczba_wystapien
FROM [dbo].[Sample - Superstore]
GROUP BY [Order ID], [Product ID]
HAVING COUNT(*) > 1
ORDER BY liczba_wystapien DESC;
