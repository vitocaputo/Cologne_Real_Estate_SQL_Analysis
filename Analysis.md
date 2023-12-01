# Immobilien Köln Analysis
---
## 1. How many ads are there per category?

```sql
SELECT "houses in sale" AS category,  COUNT(*) AS num_ads
FROM haus_kaufen AS category
UNION
SELECT "apartments in sale" AS wk, COUNT(*) AS num_ads
FROM wohnung_kaufen AS wk
UNION
SELECT "houses to rent" as hm,  COUNT(*) AS num_ads
FROM haus_mieten AS hm
UNION
SELECT "apartments to rent" as wm, COUNT(*) AS num_ads
FROM wohnung_mieten AS wm
ORDER BY num_ads DESC
```
| category           | num_ads |
|--------------------|---------|
| apartments in sale | 722     |
| houses in sale     | 427     |
| apartments to rent | 216     |
| houses to rent     | 7       |
---

## 2. What is the price per square meter by ad type?

- Houses in sale
```sql
-- SM average price by houses in sale

SELECT concat("€ ", format(avg(sm_price), 2, "de_DE")) as "houses in sale (avgsmprice)"
FROM (
SELECT 
    ref_num,
    kaufpreis / wohnfläche as sm_price
FROM haus_kaufen
) sm_price
```
| houses in sale (avgsmprice) |
|-----------------------------|
| € 4.782,22                  |

```sql
-- SM average price only for the land plot

SELECT concat("€ ", format(avg(sm_price), 2, "de_DE")) as "plot of land (avgsmprice)"
FROM (
SELECT 
    ref_num,
    kaufpreis / grundstück as sm_price
FROM haus_kaufen
) sm_price
```
| plot of land (avgsmprice) |
|---------------------------|
| € 2.905,02                |

```sql
-- SM average price by houses in sale considering the land plot

SELECT concat("€ ", format(avg(sm_price), 2, "de_DE")) as "houses in sale with land plot (avgsmprice)"
FROM (
SELECT 
    ref_num,
    kaufpreis / (wohnfläche+grundstück) as sm_price
FROM haus_kaufen
) sm_price
```
| houses in sale with land plot (avgsmprice) |
|--------------------------------------------|
| € 1.834,17                                 |

- Apartments in sale
```sql
-- SM average price by apartments in sale

SELECT concat("€ ", format(avg(sm_price), 2, "de_DE")) as "apartment in sale (avgsmprice)"
FROM (
SELECT 
    ref_num,
    kaufpreis / wohnfläche as sm_price
FROM wohnung_kaufen
) sm_price
```
| apartment in sale (avgsmprice) |
|--------------------------------|
| € 4.692,78                     |

- Apartments for rent
```sql
-- Average monthly rent and SM average price for rent apartments 

SELECT concat("€ ", format(avg(warmmiete), 2, "de_DE")) as "avg total monthly rent",
       concat("€ ", format(avg(sm_price), 2, "de_DE")) as "apartment for rent (avgsmprice)"
FROM (
    SELECT kaltmiete + nebenkosten + heizkosten as warmmiete,
           (kaltmiete + nebenkosten + heizkosten) / wohnfläche as sm_price
           FROM wohnung_mieten
) apt_rent
```
| avg total monthly rent | apartment for rent (avgsmprice) |
|------------------------|---------------------------------|
| € 1.327,70             | € 18,09                         |

- Houses for rent
```sql
-- Average monthly rent and SM average price for rent houses 

SELECT concat("€ ", format(avg(warmmiete), 2, "de_DE")) as "avg total monthly rent",
       concat("€ ", format(avg(sm_price), 2, "de_DE")) as "houses for rent (avgsmprice)"
FROM (
    SELECT kaltmiete + nebenkosten + heizkosten as warmmiete,
           (kaltmiete + nebenkosten + heizkosten) / wohnfläche as sm_price
           FROM haus_mieten
) house_rent
```
| avg total monthly rent | houses for rent (avgsmprice) |
|------------------------|------------------------------|
| € 2.921,43             | € 20,31                      |
---

## 3. How are houses and apartments divided into price ranges?

- Houses vs. Apartments in sale
```sql
SELECT
    "houses in sale" AS category,
    SUM(CASE WHEN kaufpreis BETWEEN 0 AND 50000 THEN 1 ELSE 0 END) AS "< 50.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 50001 AND 100000 THEN 1 ELSE 0 END) AS "50.000 - 100.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 100001 AND 150000 THEN 1 ELSE 0 END) AS "100.000 - 150.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 150001 AND 200000 THEN 1 ELSE 0 END) AS "150.000 - 200.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 200001 AND 300000 THEN 1 ELSE 0 END) AS "200.000 - 300.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 300001 AND 500000 THEN 1 ELSE 0 END) AS "300.000 - 500.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 500001 AND 1000000 THEN 1 ELSE 0 END) AS "500.000 - 1.000.000 €",
    SUM(CASE WHEN kaufpreis > 1000000 THEN 1 ELSE 0 END) AS " > 1.000.000 €"
FROM
    haus_kaufen as category
UNION
SELECT
    "apartments in sale" AS wk,
    SUM(CASE WHEN kaufpreis BETWEEN 0 AND 50000 THEN 1 ELSE 0 END) AS "< 50.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 50001 AND 100000 THEN 1 ELSE 0 END) AS "50.000 - 100.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 100001 AND 150000 THEN 1 ELSE 0 END) AS "100.000 - 150.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 150001 AND 200000 THEN 1 ELSE 0 END) AS "150.000 - 200.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 200001 AND 300000 THEN 1 ELSE 0 END) AS "200.000 - 300.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 300001 AND 500000 THEN 1 ELSE 0 END) AS "300.000 - 500.000 €",
    SUM(CASE WHEN kaufpreis BETWEEN 500001 AND 1000000 THEN 1 ELSE 0 END) AS "500.000 - 1.000.000 €",
    SUM(CASE WHEN kaufpreis > 1000000 THEN 1 ELSE 0 END) AS " > 1.000.000 €"
FROM
    wohnung_kaufen as wk;
```
| category           | < 50.000 € | 50.000 - 100.000 € | 100.000 - 150.000 € | 150.000 - 200.000 € | 200.000 - 300.000 € | 300.000 - 500.000 € | 500.000 - 1.000.000 € | > 1.000.000 € |
|--------------------|------------|--------------------|---------------------|---------------------|---------------------|---------------------|-----------------------|---------------|
| houses in sale     | 0          | 0                  | 1                   | 2                   | 11                  | 75                  | 213                   | 125           |
| apartments in sale | 1          | 7                  | 39                  | 119                 | 225                 | 208                 | 93                    | 30            |


- Houses vs. Apartments for rent
```sql
SELECT "houses for rent" as category,
        SUM(CASE WHEN warmmiete BETWEEN 0 AND 1000 THEN 1 ELSE 0 END) AS "< 1.000 €",
        SUM(CASE WHEN warmmiete BETWEEN 1001 AND 2000 THEN 1 ELSE 0 END) AS "1.000 - 2.000 €",
        SUM(CASE WHEN warmmiete BETWEEN 2001 AND 3000 THEN 1 ELSE 0 END) AS "2.000 - 3.000 €",
        SUM(CASE WHEN warmmiete BETWEEN 3001 AND 5000 THEN 1 ELSE 0 END) AS "3.000 - 5.000 €",
        SUM(CASE WHEN warmmiete BETWEEN 5001 AND 10000 THEN 1 ELSE 0 END) AS "5.000 - 10.000 €",
        SUM(CASE WHEN warmmiete > 10001 THEN 1 ELSE 0 END) AS "> 10.000 €"
FROM (
    SELECT kaltmiete + nebenkosten + heizkosten as warmmiete
    FROM haus_mieten
    ) category
UNION
SELECT "apartments for rent" as apt_rent,
        SUM(CASE WHEN warmmiete BETWEEN 0 AND 1000 THEN 1 ELSE 0 END) AS "< 1.000 €",
        SUM(CASE WHEN warmmiete BETWEEN 1001 AND 2000 THEN 1 ELSE 0 END) AS "1.000 - 2.000 €",
        SUM(CASE WHEN warmmiete BETWEEN 2001 AND 3000 THEN 1 ELSE 0 END) AS "2.000 - 3.000 €",
        SUM(CASE WHEN warmmiete BETWEEN 3001 AND 5000 THEN 1 ELSE 0 END) AS "3.000 - 5.000 €",
        SUM(CASE WHEN warmmiete BETWEEN 5001 AND 10000 THEN 1 ELSE 0 END) AS "5.000 - 10.000 €",
        SUM(CASE WHEN warmmiete > 10001 THEN 1 ELSE 0 END) AS "> 10.000 €"
FROM (
    SELECT kaltmiete + nebenkosten + heizkosten as warmmiete
    FROM wohnung_mieten
    ) apt_rent
```
| category            | < 1.000 € | 1.000 - 2.000 € | 2.000 - 3.000 € | 3.000 - 5.000 € | 5.000 - 10.000 € | > 10.000 € |
|---------------------|-----------|-----------------|-----------------|-----------------|------------------|------------|
| houses for rent     | 0         | 1               | 3               | 3               | 0                | 0          |
| apartments for rent | 96        | 100             | 14              | 3               | 3                | 0          |

---

## 4. How do houses and apartments differ by living area?

- Houses vs. Apartments in sale
```sql
SELECT
    "houses in sale" AS category,
    SUM(CASE WHEN wohnfläche BETWEEN 0 AND 60 THEN 1 ELSE 0 END) AS "< 60 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 61 AND 100 THEN 1 ELSE 0 END) AS "60 - 100 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 101 AND 150 THEN 1 ELSE 0 END) AS "100 - 150 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 150 AND 200 THEN 1 ELSE 0 END) AS "150 - 200 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 201 AND 500 THEN 1 ELSE 0 END) AS "200 - 500 m²",
    SUM(CASE WHEN wohnfläche > 500 THEN 1 ELSE 0 END) AS "> 500 m²"
FROM
    haus_kaufen as category
UNION
SELECT
    "apartments in sale" AS wk,
    SUM(CASE WHEN wohnfläche BETWEEN 0 AND 60 THEN 1 ELSE 0 END) AS "< 60 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 61 AND 100 THEN 1 ELSE 0 END) AS "60 - 100 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 101 AND 150 THEN 1 ELSE 0 END) AS "100 - 150 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 150 AND 200 THEN 1 ELSE 0 END) AS "150 - 200 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 201 AND 500 THEN 1 ELSE 0 END) AS "200 - 500 m²",
    SUM(CASE WHEN wohnfläche > 500 THEN 1 ELSE 0 END) AS "> 500 m²"
FROM
    wohnung_kaufen as wk;
```
| category           | < 60 m² | 60 - 100 m² | 100 - 150 m² | 150 - 200 m² | 200 - 500 m² | > 500 m² |
|--------------------|---------|-------------|--------------|--------------|--------------|----------|
| houses in sale     | 5       | 34          | 155          | 100          | 113          | 29       |
| apartments in sale | 195     | 415         | 89           | 19           | 5            | 0        |


- Houses vs. Apartments for rent
```sql
SELECT
    "houses for rent" AS category,
    SUM(CASE WHEN wohnfläche BETWEEN 0 AND 60 THEN 1 ELSE 0 END) AS "< 60 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 61 AND 100 THEN 1 ELSE 0 END) AS "60 - 100 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 101 AND 150 THEN 1 ELSE 0 END) AS "100 - 150 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 150 AND 200 THEN 1 ELSE 0 END) AS "150 - 200 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 201 AND 500 THEN 1 ELSE 0 END) AS "200 - 500 m²",
    SUM(CASE WHEN wohnfläche > 500 THEN 1 ELSE 0 END) AS "> 500 m²"
FROM
    haus_mieten as category
UNION
SELECT
    "apartments for rent" AS wm,
    SUM(CASE WHEN wohnfläche BETWEEN 0 AND 60 THEN 1 ELSE 0 END) AS "< 60 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 61 AND 100 THEN 1 ELSE 0 END) AS "60 - 100 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 101 AND 150 THEN 1 ELSE 0 END) AS "100 - 150 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 150 AND 200 THEN 1 ELSE 0 END) AS "150 - 200 m²",
    SUM(CASE WHEN wohnfläche BETWEEN 201 AND 500 THEN 1 ELSE 0 END) AS "200 - 500 m²",
    SUM(CASE WHEN wohnfläche > 500 THEN 1 ELSE 0 END) AS "> 500 m²"
FROM
    wohnung_mieten as wm
```
| category            | < 60 m² | 60 - 100 m² | 100 - 150 m² | 150 - 200 m² | 200 - 500 m² | > 500 m² |
|---------------------|---------|-------------|--------------|--------------|--------------|----------|
| houses for rent     | 0       | 1           | 4            | 1            | 1            | 0        |
| apartments for rent | 88      | 104         | 18           | 4            | 1            | 1        |
---

## 5. How many houses are there per category or apartments per floor?
##    What price differences are there between categories or floors?

- Houses in sale by category
```sql
SELECT 
    kategorie as "house in sale type",
    count(ref_num) as "number of ads",
    concat("€ ", format(avg(kaufpreis), 0, "de_DE")) as "average price"
FROM haus_kaufen as ad_type
GROUP BY kategorie
ORDER BY count(ref_num) DESC 
```
| house in sale type      | number of ads | average price |
|-------------------------|---------------|---------------|
| Mehrfamilienhaus        | 122           | € 1.262.360   |
| Einfamilienhaus         | 114           | € 946.972     |
| Doppelhaushälfte        | 53            | € 726.447     |
| Reihenmittelhaus        | 47            | € 618.874     |
| Reihenendhaus           | 36            | € 617.366     |
| Wohn- und Geschäftshaus | 19            | € 2.380.789   |
| Wohnanlage              | 14            | € 843.964     |
| Bungalow                | 10            | € 997.729     |
| Villa                   | 5             | € 3.233.000   |
| Stadthaus               | 3             | € 1.133.333   |
| Reiheneckhaus           | 2             | € 455.000     |
| Herrenhaus              | 1             | € 4.500.000   |
| Grundstück              | 1             | € 2.700.000   |

- Apartments in sale by floor
```sql
SELECT 
    wohnungslage as "floor apartments in sale",
    count(*) as "number of ads",
    concat("€ ", format(avg(kaufpreis), 0, "de_DE")) as "average price"
FROM wohnung_kaufen AS ad_type
WHERE wohnungslage <> ""
GROUP BY wohnungslage
ORDER BY count(ref_num) DESC 
```
| floor apartments in sale      | number of ads | average price |
|-------------------------------|---------------|---------------|
| 1. Geschoss                   | 123           | € 329.865     |
| Erdgeschoss                   | 117           | € 337.187     |
| 2. Geschoss                   | 89            | € 322.635     |
| 3. Geschoss                   | 62            | € 382.791     |
| 4. Geschoss                   | 27            | € 331.633     |
| 5. Geschoss                   | 20            | € 299.750     |
| Dachgeschoss                  | 12            | € 386.667     |
| 6. Geschoss                   | 9             | € 303.007     |
| 3. Geschoss (Dachgeschoss)    | 9             | € 188.822     |
| 7. Geschoss                   | 7             | € 227.360     |
| 4. Geschoss (Dachgeschoss)    | 7             | € 270.271     |
| 2. Geschoss (Dachgeschoss)    | 6             | € 334.750     |
| 1. Geschoss (Erdgeschoss)     | 3             | € 350.333     |
| 5. Geschoss (Dachgeschoss)    | 2             | € 1.074.500   |
| 12. Geschoss                  | 2             | € 186.500     |
| 10. Geschoss                  | 2             | € 172.450     |
| 13. Geschoss                  | 1             | € 99.000      |
| 30. Geschoss                  | 1             | € 140.000     |
| 1. Untergeschoss (Souterrain) | 1             | € 199.000     |
| 36. Geschoss                  | 1             | € 298.000     |
| 26. Geschoss                  | 1             | € 119.000     |
| Souterrain                    | 1             | € 298.000     |
| 31. Geschoss                  | 1             | € 199.000     |
| 8. Geschoss                   | 1             | € 232.000     |

- Houses for rent by category
```sql
SELECT 
    kategorie as "house to rent type",
    count(ref_num) as "number of ads",
    concat("€ ", format(avg(warmmiete), 0, "de_DE")) as "average rent price"
FROM (
    SELECT kaltmiete + nebenkosten + heizkosten as warmmiete, kategorie, ref_num
    FROM haus_mieten
    ) house_rent
GROUP BY kategorie
ORDER BY count(ref_num) DESC 
```
| house to rent type | number of ads | average rent price |
|--------------------|---------------|--------------------|
| Einfamilienhaus    | 4             | € 2.719            |
| Doppelhaushälfte   | 1             | € 2.530            |
| Stadthaus          | 1             | € 4.750            |
| Reihenmittelhaus   | 1             | € 2.295            |

- Apartments for rent by floor
```sql
SELECT 
    wohnungslage as "floor apartment for rent",
    count(ref_num) as "number of ads",
    concat("€ ", format(avg(warmmiete), 0, "de_DE")) as "average rent price"
FROM (
    SELECT kaltmiete + nebenkosten + heizkosten as warmmiete, wohnungslage, ref_num
    FROM wohnung_mieten
    ) apt_rent
WHERE wohnungslage <> ""
GROUP BY wohnungslage
ORDER BY count(ref_num) DESC
```
| floor apartment for rent      | number of ads | average rent price |
|-------------------------------|---------------|--------------------|
| 1. Geschoss                   | 50            | € 1.241            |
| 2. Geschoss                   | 29            | € 1.000            |
| 3. Geschoss                   | 23            | € 1.116            |
| 4. Geschoss                   | 20            | € 1.288            |
| Erdgeschoss                   | 18            | € 1.249            |
| 5. Geschoss                   | 12            | € 1.252            |
| 4. Geschoss (Dachgeschoss)    | 6             | € 1.733            |
| Dachgeschoss                  | 6             | € 1.443            |
| 2. Geschoss (Dachgeschoss)    | 4             | € 905              |
| 6. Geschoss                   | 4             | € 872              |
| 3. Geschoss (Dachgeschoss)    | 3             | € 1.003            |
| 7. Geschoss                   | 2             | € 999              |
| Souterrain                    | 1             | € 1.870            |
| 18. Geschoss                  | 1             | € 1.819            |
| 17. Geschoss                  | 1             | € 9.750            |
| 1. Geschoss (Dachgeschoss)    | 1             | € 1.140            |
| 10. Geschoss                  | 1             | € 1.250            |
| 1. Geschoss (Erdgeschoss)     | 1             | € 1.020            |
| 3. Untergeschoss              | 1             | € 1.300            |
| 5. Geschoss (Dachgeschoss)    | 1             | € 625              |
| 1. Untergeschoss (Souterrain) | 1             | € 1.125            |
---

## 6. How many houses are there in each neighborhood and what kind of houses are offered?

```sql
CREATE VIEW haus_kaufen_plz AS
SELECT ref_num, 
	anzeige, 
    hk.plz, 
    pl.stadtteil, 
    wohnfläche, 
    zimmer,
    grundstück,
    kaufpreis,
    kategorie,
    makler
FROM haus_kaufen AS hk
LEFT JOIN plz_koeln as pl
ON hk.plz = pl.plz
```
```sql
CREATE VIEW wohnung_kaufen_plz AS 
SELECT 
    ref_num,
    anzeige,
	wk.plz,
    pl.stadtteil,
    wohnfläche,
    zimmer,
    kaufpreis,
    hausgeld,
    wohnungslage,
    makler
FROM wohnung_kaufen as wk
LEFT JOIN plz_koeln as pl
ON wk.plz = pl.plz
GROUP BY ref_num,
    anzeige,
	wk.plz,
    pl.stadtteil,
    wohnfläche,
    zimmer,
    kaufpreis,
    hausgeld,
    wohnungslage,
    makler
```

- Houses in sale by neighborhood
```sql
SELECT 
    stadtteil as neighborhood,
    count(*) as "houses in sale"
FROM haus_kaufen_plz
GROUP BY stadtteil
ORDER BY count(*) DESC
```
| neighborhood         | houses in sale |
|----------------------|----------------|
| Urbach               | 37             |
| Wahn                 | 31             |
| Merkenich            | 31             |
| Dünnwald             | 24             |
| Innenstadt           | 23             |
| Lövenich             | 21             |
| Holweide             | 20             |
| Rath/Heumar          | 19             |
| Godorf               | 17             |
| Chorweiler           | 17             |
| Porz                 | 16             |
| Lindweiler           | 15             |
| Brück                | 13             |
| Sürth                | 13             |
| Hahnwald             | 11             |
| Westhoven            | 10             |
| Stammheim            | 9              |
| Bilderstöckchen      | 9              |
| Riehl                | 7              |
| Weidenpesch          | 7              |
| Müngersdorf          | 6              |
| Bayenthal            | 6              |
| Neustadt/Süd         | 5              |
| Buchforst            | 5              |
| Weiden               | 5              |
| Kalk                 | 5              |
| Altstadt/Süd         | 5              |
| Poll                 | 5              |
| Bickendorf           | 4              |
| Ehrenfeld            | 4              |
| Sülz                 | 4              |
| Zollstock            | 4              |
| Nippes               | 4              |
| Klettenberg          | 3              |
| Bocklemünd/Mengenich | 3              |
| Neustadt/Nord        | 3              |
| Mülheim              | 3              |
| Marienburg           | 1              |
| Altstadt/Nord        | 1              |
| Deutz                | 1              |

- Houses in sale by category in different neighborhoods
```sql
SELECT 
    stadtteil as neighborhood,
    kategorie as housetype,
    count(*) as "houses in sale"
FROM haus_kaufen_plz
GROUP BY stadtteil, kategorie
ORDER BY count(*) DESC
```
| neighborhood         | housetype               | houses in sale |
|----------------------|-------------------------|----------------|
| Wahn                 | Einfamilienhaus         | 13             |
| Innenstadt           | Mehrfamilienhaus        | 12             |
| Merkenich            | Einfamilienhaus         | 12             |
| Wahn                 | Mehrfamilienhaus        | 10             |
| Merkenich            | Doppelhaushälfte        | 9              |
| Urbach               | Reihenendhaus           | 8              |
| Holweide             | Mehrfamilienhaus        | 8              |
| Lövenich             | Einfamilienhaus         | 8              |
| Rath/Heumar          | Mehrfamilienhaus        | 8              |
| Merkenich            | Mehrfamilienhaus        | 7              |
| Brück                | Einfamilienhaus         | 7              |
| Dünnwald             | Mehrfamilienhaus        | 7              |
| Urbach               | Einfamilienhaus         | 7              |
| Dünnwald             | Doppelhaushälfte        | 6              |
| Hahnwald             | Einfamilienhaus         | 6              |
| Chorweiler           | Doppelhaushälfte        | 6              |
| Urbach               | Mehrfamilienhaus        | 6              |
| Dünnwald             | Einfamilienhaus         | 6              |
| Urbach               | Reihenmittelhaus        | 6              |
| Holweide             | Einfamilienhaus         | 6              |
| Urbach               | Doppelhaushälfte        | 6              |
| Godorf               | Einfamilienhaus         | 5              |
| Poll                 | Mehrfamilienhaus        | 5              |
| Rath/Heumar          | Einfamilienhaus         | 5              |
| Innenstadt           | Wohn- und Geschäftshaus | 5              |
| Sürth                | Einfamilienhaus         | 5              |
| Porz                 | Einfamilienhaus         | 5              |
| Lindweiler           | Einfamilienhaus         | 4              |
| Westhoven            | Mehrfamilienhaus        | 4              |
| Chorweiler           | Einfamilienhaus         | 4              |
| Lövenich             | Mehrfamilienhaus        | 4              |
| Chorweiler           | Reihenmittelhaus        | 4              |
| Rath/Heumar          | Reihenmittelhaus        | 4              |
| Neustadt/Süd         | Mehrfamilienhaus        | 4              |
| Godorf               | Reihenmittelhaus        | 4              |
| Porz                 | Doppelhaushälfte        | 4              |
| Neustadt/Nord        | Mehrfamilienhaus        | 3              |
| Zollstock            | Mehrfamilienhaus        | 3              |
| Bilderstöckchen      | Mehrfamilienhaus        | 3              |
| Lindweiler           | Reihenendhaus           | 3              |
| Sürth                | Doppelhaushälfte        | 3              |
| Wahn                 | Reihenendhaus           | 3              |
| Stammheim            | Mehrfamilienhaus        | 3              |
| Dünnwald             | Reihenendhaus           | 3              |
| Lövenich             | Reihenmittelhaus        | 3              |
| Porz                 | Mehrfamilienhaus        | 3              |
| Godorf               | Mehrfamilienhaus        | 3              |
| Bilderstöckchen      | Reihenmittelhaus        | 3              |
| Riehl                | Mehrfamilienhaus        | 3              |
| Altstadt/Süd         | Wohn- und Geschäftshaus | 3              |
| Weidenpesch          | Mehrfamilienhaus        | 3              |
| Nippes               | Mehrfamilienhaus        | 3              |
| Hahnwald             | Mehrfamilienhaus        | 3              |
| Mülheim              | Mehrfamilienhaus        | 3              |
| Weiden               | Einfamilienhaus         | 2              |
| Lindweiler           | Doppelhaushälfte        | 2              |
| Lindweiler           | Mehrfamilienhaus        | 2              |
| Klettenberg          | Stadthaus               | 2              |
| Rath/Heumar          | Reihenendhaus           | 2              |
| Lövenich             | Doppelhaushälfte        | 2              |
| Innenstadt           | Reihenendhaus           | 2              |
| Kalk                 | Einfamilienhaus         | 2              |
| Godorf               | Bungalow                | 2              |
| Riehl                | Reihenmittelhaus        | 2              |
| Godorf               | Doppelhaushälfte        | 2              |
| Holweide             | Doppelhaushälfte        | 2              |
| Porz                 | Wohn- und Geschäftshaus | 2              |
| Kalk                 | Wohn- und Geschäftshaus | 2              |
| Buchforst            | Wohnanlage              | 2              |
| Lövenich             | Reihenendhaus           | 2              |
| Merkenich            | Reihenendhaus           | 2              |
| Westhoven            | Einfamilienhaus         | 2              |
| Ehrenfeld            | Mehrfamilienhaus        | 2              |
| Brück                | Reihenendhaus           | 2              |
| Müngersdorf          | Einfamilienhaus         | 2              |
| Sürth                | Reihenendhaus           | 2              |
| Wahn                 | Doppelhaushälfte        | 2              |
| Sülz                 | Einfamilienhaus         | 2              |
| Wahn                 | Reihenmittelhaus        | 2              |
| Innenstadt           | Wohnanlage              | 2              |
| Urbach               | Reiheneckhaus           | 2              |
| Brück                | Reihenmittelhaus        | 2              |
| Stammheim            | Einfamilienhaus         | 2              |
| Lindweiler           | Wohnanlage              | 2              |
| Bayenthal            | Mehrfamilienhaus        | 2              |
| Westhoven            | Doppelhaushälfte        | 2              |
| Stammheim            | Doppelhaushälfte        | 2              |
| Innenstadt           | Reihenmittelhaus        | 2              |
| Weidenpesch          | Einfamilienhaus         | 2              |
| Holweide             | Villa                   | 2              |
| Bayenthal            | Einfamilienhaus         | 2              |
| Bilderstöckchen      | Reihenendhaus           | 2              |
| Chorweiler           | Reihenendhaus           | 2              |
| Dünnwald             | Reihenmittelhaus        | 2              |
| Godorf               | Reihenendhaus           | 1              |
| Holweide             | Reihenmittelhaus        | 1              |
| Riehl                | Wohnanlage              | 1              |
| Riehl                | Einfamilienhaus         | 1              |
| Sürth                | Reihenmittelhaus        | 1              |
| Bocklemünd/Mengenich | Mehrfamilienhaus        | 1              |
| Chorweiler           | Bungalow                | 1              |
| Merkenich            | Reihenmittelhaus        | 1              |
| Zollstock            | Wohnanlage              | 1              |
| Müngersdorf          | Villa                   | 1              |
| Urbach               | Wohn- und Geschäftshaus | 1              |
| Hahnwald             | Villa                   | 1              |
| Bickendorf           | Doppelhaushälfte        | 1              |
| Buchforst            | Reihenmittelhaus        | 1              |
| Sürth                | Mehrfamilienhaus        | 1              |
| Buchforst            | Mehrfamilienhaus        | 1              |
| Kalk                 | Wohnanlage              | 1              |
| Klettenberg          | Reihenmittelhaus        | 1              |
| Bickendorf           | Wohn- und Geschäftshaus | 1              |
| Westhoven            | Reihenmittelhaus        | 1              |
| Müngersdorf          | Reihenendhaus           | 1              |
| Westhoven            | Bungalow                | 1              |
| Urbach               | Stadthaus               | 1              |
| Marienburg           | Reihenmittelhaus        | 1              |
| Wahn                 | Wohnanlage              | 1              |
| Weiden               | Reihenmittelhaus        | 1              |
| Sülz                 | Villa                   | 1              |
| Ehrenfeld            | Wohnanlage              | 1              |
| Bocklemünd/Mengenich | Einfamilienhaus         | 1              |
| Bayenthal            | Herrenhaus              | 1              |
| Sülz                 | Grundstück              | 1              |
| Stammheim            | Reihenmittelhaus        | 1              |
| Lindweiler           | Wohn- und Geschäftshaus | 1              |
| Lindweiler           | Bungalow                | 1              |
| Porz                 | Wohnanlage              | 1              |
| Neustadt/Süd         | Wohn- und Geschäftshaus | 1              |
| Müngersdorf          | Reihenmittelhaus        | 1              |
| Bickendorf           | Mehrfamilienhaus        | 1              |
| Stammheim            | Bungalow                | 1              |
| Weiden               | Mehrfamilienhaus        | 1              |
| Bayenthal            | Doppelhaushälfte        | 1              |
| Porz                 | Reihenendhaus           | 1              |
| Weidenpesch          | Reihenmittelhaus        | 1              |
| Altstadt/Süd         | Mehrfamilienhaus        | 1              |
| Buchforst            | Einfamilienhaus         | 1              |
| Altstadt/Nord        | Wohn- und Geschäftshaus | 1              |
| Brück                | Bungalow                | 1              |
| Bickendorf           | Einfamilienhaus         | 1              |
| Ehrenfeld            | Reihenmittelhaus        | 1              |
| Weiden               | Doppelhaushälfte        | 1              |
| Bocklemünd/Mengenich | Bungalow                | 1              |
| Deutz                | Wohnanlage              | 1              |
| Nippes               | Reihenmittelhaus        | 1              |
| Lövenich             | Bungalow                | 1              |
| Holweide             | Wohn- und Geschäftshaus | 1              |
| Weidenpesch          | Doppelhaushälfte        | 1              |
| Lövenich             | Wohnanlage              | 1              |
| Müngersdorf          | Mehrfamilienhaus        | 1              |
| Bilderstöckchen      | Einfamilienhaus         | 1              |
| Hahnwald             | Bungalow                | 1              |
| Brück                | Mehrfamilienhaus        | 1              |
| Sürth                | Wohn- und Geschäftshaus | 1              |
| Altstadt/Süd         | Doppelhaushälfte        | 1              |

- Apartments in sale by neighborhood
```sql
SELECT 
    stadtteil as neighborhood,
    count(*) as "apartments in sale"
FROM wohnung_kaufen_plz
GROUP BY stadtteil
ORDER BY count(*) DESC
```
| neighborhood         | apartments in sale |
|----------------------|--------------------|
| Innenstadt           | 124                |
| Westhoven            | 43                 |
| Weidenpesch          | 38                 |
| Riehl                | 36                 |
| Porz                 | 30                 |
| Kalk                 | 26                 |
| Weiden               | 24                 |
| Sürth                | 23                 |
| Stammheim            | 23                 |
| Rath/Heumar          | 21                 |
| Poll                 | 20                 |
| Nippes               | 20                 |
| Bayenthal            | 20                 |
| Lövenich             | 19                 |
| Altstadt/Süd         | 17                 |
| Zollstock            | 17                 |
| Wahn                 | 17                 |
| Brück                | 16                 |
| Buchforst            | 15                 |
| Mülheim              | 15                 |
| Urbach               | 15                 |
| Ehrenfeld            | 13                 |
| Neustadt/Nord        | 13                 |
| Dünnwald             | 12                 |
| Holweide             | 11                 |
| Bilderstöckchen      | 11                 |
| Godorf               | 11                 |
| Bocklemünd/Mengenich | 11                 |
| Müngersdorf          | 11                 |
| Neustadt/Süd         | 8                  |
| Merkenich            | 7                  |
| Lindweiler           | 7                  |
| Bickendorf           | 6                  |
| Sülz                 | 5                  |
| Chorweiler           | 4                  |
| Klettenberg          | 4                  |
| Gremberghoven        | 4                  |
| Hahnwald             | 2                  |
| Altstadt/Nord        | 1                  |
| Deutz                | 1                  |
| Neuehrenfeld         | 1                  |

- Houses vs. Apartments in sale by neighborhood - price differences
```sql
SELECT
    stadtteil as neighborhood,
    SUM(CASE WHEN imm_typ = "houses in sale" THEN 1 ELSE 0 END) 
        AS "number of houses in sale",
    IFNULL(CONCAT("€ ", FORMAT(AVG(CASE WHEN imm_typ = "houses in sale" THEN kaufpreis END),2, "de_DE")),0) 
        AS "house in sale avg price",
	IFNULL(ROUND(AVG(CASE WHEN imm_typ = "houses in sale" THEN wohnfläche END)),0) 
        AS "house in sale avg square meters",
    IFNULL(CONCAT("€ ", FORMAT(AVG(CASE WHEN imm_typ = "houses in sale" THEN (kaufpreis/wohnfläche) END),2, "de_DE")),0) 
        AS "house in sale avg sm price",
    SUM(CASE WHEN imm_typ = "apartments in sale" THEN 1 ELSE 0 END) 
        AS "number of apartments in sale",
    IFNULL(CONCAT("€ ", FORMAT(AVG(CASE WHEN imm_typ = "apartments in sale" THEN kaufpreis END),2, "de_DE")),0) 
        AS "apartments in sale avg price",
    IFNULL(ROUND(AVG(CASE WHEN imm_typ = "apartments in sale" THEN wohnfläche END)),0) 
        AS "house in sale avg square meters",
    IFNULL(CONCAT("€ ", FORMAT(AVG(CASE WHEN imm_typ = "apartments in sale" THEN (kaufpreis/wohnfläche) END),2, "de_DE")),0) 
        AS "apartments in sale avg sm price"
FROM
    (
        SELECT stadtteil, kaufpreis, wohnfläche, 'houses in sale' AS imm_typ FROM haus_kaufen_plz
        UNION ALL
        SELECT stadtteil, kaufpreis, wohnfläche, 'apartments in sale' AS imm_typ FROM wohnung_kaufen_plz
    ) AS combined_data
GROUP BY stadtteil;
```
| neighborhood         | number of houses in sale | house in sale avg price | house in sale avg square meters | house in sale avg sm price | number of apartments in sale | apartments in sale avg price | house in sale avg square meters | apartments in sale avg sm price |
|----------------------|--------------------------|-------------------------|---------------------------------|----------------------------|------------------------------|------------------------------|---------------------------------|---------------------------------|
| Urbach               | 37                       | € 838.555,95            | 214                             | € 4.132,11                 | 15                           | € 261.256,67                 | 84                              | € 3.185,76                      |
| Godorf               | 17                       | € 629.821,76            | 155                             | € 4.189,47                 | 11                           | € 289.545,45                 | 81                              | € 3.493,89                      |
| Holweide             | 20                       | € 960.879,90            | 226                             | € 4.520,80                 | 11                           | € 301.304,64                 | 76                              | € 3.948,65                      |
| Neustadt/Nord        | 3                        | € 2.704.666,67          | 521                             | € 5.181,93                 | 13                           | € 422.076,92                 | 65                              | € 6.597,14                      |
| Dünnwald             | 24                       | € 785.125,00            | 177                             | € 4.588,95                 | 12                           | € 373.875,00                 | 96                              | € 3.839,46                      |
| Weiden               | 5                        | € 1.486.500,00          | 214                             | € 7.611,12                 | 24                           | € 452.612,50                 | 94                              | € 4.515,71                      |
| Innenstadt           | 23                       | € 1.846.956,52          | 383                             | € 5.758,29                 | 124                          | € 541.874,64                 | 78                              | € 6.395,33                      |
| Wahn                 | 31                       | € 1.119.985,32          | 288                             | € 4.186,39                 | 17                           | € 235.534,53                 | 74                              | € 3.113,50                      |
| Merkenich            | 31                       | € 731.670,55            | 190                             | € 4.167,23                 | 7                            | € 296.628,57                 | 83                              | € 3.542,22                      |
| Lindweiler           | 15                       | € 701.719,13            | 182                             | € 4.048,98                 | 7                            | € 319.071,43                 | 89                              | € 3.623,08                      |
| Brück                | 13                       | € 700.000,00            | 154                             | € 4.717,28                 | 16                           | € 231.075,00                 | 73                              | € 3.149,57                      |
| Hahnwald             | 11                       | € 2.292.544,55          | 298                             | € 7.101,99                 | 2                            | € 409.450,00                 | 88                              | € 4.675,47                      |
| Klettenberg          | 3                        | € 1.113.333,33          | 135                             | € 8.100,38                 | 4                            | € 851.750,00                 | 108                             | € 7.378,82                      |
| Westhoven            | 10                       | € 755.100,00            | 189                             | € 4.119,70                 | 43                           | € 244.127,23                 | 78                              | € 3.039,56                      |
| Rath/Heumar          | 19                       | € 708.105,26            | 188                             | € 3.962,41                 | 21                           | € 250.238,10                 | 76                              | € 3.257,73                      |
| Zollstock            | 4                        | € 954.750,00            | 358                             | € 3.583,17                 | 17                           | € 357.929,41                 | 68                              | € 5.274,23                      |
| Chorweiler           | 17                       | € 632.305,88            | 138                             | € 4.678,91                 | 4                            | € 263.750,00                 | 77                              | € 3.409,56                      |
| Lövenich             | 21                       | € 897.228,57            | 164                             | € 5.842,69                 | 19                           | € 474.941,95                 | 100                             | € 4.548,51                      |
| Riehl                | 7                        | € 936.685,71            | 173                             | € 5.567,77                 | 36                           | € 296.088,89                 | 77                              | € 3.850,37                      |
| Bilderstöckchen      | 9                        | € 968.555,56            | 255                             | € 4.217,23                 | 11                           | € 347.389,73                 | 80                              | € 4.176,31                      |
| Kalk                 | 5                        | € 905.000,00            | 319                             | € 4.155,14                 | 26                           | € 201.153,85                 | 64                              | € 3.186,54                      |
| Poll                 | 5                        | € 992.600,00            | 258                             | € 3.892,61                 | 20                           | € 309.100,00                 | 77                              | € 3.871,51                      |
| Sürth                | 13                       | € 896.138,46            | 161                             | € 5.570,33                 | 23                           | € 464.773,91                 | 84                              | € 5.203,89                      |
| Bocklemünd/Mengenich | 3                        | € 756.000,00            | 166                             | € 4.605,73                 | 11                           | € 270.138,18                 | 77                              | € 3.558,84                      |
| Porz                 | 16                       | € 726.125,00            | 186                             | € 4.413,19                 | 30                           | € 303.336,67                 | 84                              | € 3.600,82                      |
| Neustadt/Süd         | 5                        | € 1.505.800,00          | 439                             | € 3.428,59                 | 8                            | € 378.000,00                 | 60                              | € 6.300,83                      |
| Buchforst            | 5                        | € 1.118.220,00          | 223                             | € 4.498,44                 | 15                           | € 306.820,00                 | 76                              | € 4.010,82                      |
| Stammheim            | 9                        | € 592.998,89            | 152                             | € 4.118,77                 | 23                           | € 363.493,48                 | 69                              | € 5.280,06                      |
| Müngersdorf          | 6                        | € 1.408.333,33          | 208                             | € 6.686,61                 | 11                           | € 598.090,91                 | 101                             | € 5.535,72                      |
| Bickendorf           | 4                        | € 1.021.500,00          | 254                             | € 4.734,86                 | 6                            | € 392.218,33                 | 77                              | € 5.114,77                      |
| Ehrenfeld            | 4                        | € 1.207.000,00          | 332                             | € 4.694,87                 | 13                           | € 285.900,00                 | 64                              | € 4.521,49                      |
| Sülz                 | 4                        | € 2.567.500,00          | 249                             | € 10.302,57                | 5                            | € 984.000,00                 | 134                             | € 7.056,64                      |
| Marienburg           | 1                        | € 1.750.000,00          | 207                             | € 8.454,11                 | 0                            | 0                            | 0                               | 0                               |
| Bayenthal            | 6                        | € 2.407.500,00          | 402                             | € 7.679,45                 | 20                           | € 722.106,45                 | 101                             | € 6.901,37                      |
| Altstadt/Süd         | 5                        | € 3.689.800,00          | 956                             | € 3.771,23                 | 17                           | € 444.127,06                 | 66                              | € 6.611,09                      |
| Weidenpesch          | 7                        | € 600.857,14            | 121                             | € 5.194,43                 | 38                           | € 388.676,32                 | 76                              | € 5.140,44                      |
| Nippes               | 4                        | € 1.491.000,00          | 392                             | € 4.395,45                 | 20                           | € 244.802,10                 | 57                              | € 4.280,05                      |
| Mülheim              | 3                        | € 918.666,67            | 325                             | € 2.925,02                 | 15                           | € 277.552,67                 | 70                              | € 3.787,08                      |
| Altstadt/Nord        | 1                        | € 2.950.000,00          | 749                             | € 3.938,58                 | 1                            | € 428.000,00                 | 75                              | € 5.706,67                      |
| Deutz                | 1                        | € 1.750.000,00          | 350                             | € 5.000,00                 | 1                            | € 799.000,00                 | 116                             | € 6.887,93                      |
| Neuehrenfeld         | 0                        | 0                       | 0                               | 0                          | 1                            | € 99.000,00                  | 29                              | € 3.413,79                      |
| Gremberghoven        | 0                        | 0                       | 0                               | 0                          | 4                            | € 204.000,00                 | 77                              | € 2.649,35                      |

- Houses vs. Apartments for rent by neighborhood - price differences
```sql
SELECT
    stadtteil as neighborhood,
    SUM(CASE WHEN imm_typ = "houses in sale" THEN 1 ELSE 0 END) 
        AS "number of houses in sale",
    IFNULL(CONCAT("€ ", FORMAT(AVG(CASE WHEN imm_typ = "houses in sale" THEN kaufpreis END),0, "de_DE")),0) 
        AS "house in sale avg price",
	IFNULL(concat(ROUND(AVG(CASE WHEN imm_typ = "houses in sale" THEN wohnfläche END))," m²"),0) 
        AS "house in sale avg square meters",
    IFNULL(CONCAT("€ ", FORMAT(AVG(CASE WHEN imm_typ = "houses in sale" THEN (kaufpreis/wohnfläche) END),0, "de_DE")),0) 
        AS "house in sale avg sm price",
    SUM(CASE WHEN imm_typ = "apartments in sale" THEN 1 ELSE 0 END) 
        AS "number of apartments in sale",
    IFNULL(CONCAT("€ ", FORMAT(AVG(CASE WHEN imm_typ = "apartments in sale" THEN kaufpreis END),0, "de_DE")),0) 
        AS "apartments in sale avg price",
    IFNULL(concat(ROUND(AVG(CASE WHEN imm_typ = "apartments in sale" THEN wohnfläche END))," m²"),0) 
        AS "house in sale avg square meters",
    IFNULL(CONCAT("€ ", FORMAT(AVG(CASE WHEN imm_typ = "apartments in sale" THEN (kaufpreis/wohnfläche) END),0, "de_DE")),0) 
        AS "apartments in sale avg sm price"
FROM
    (
        SELECT stadtteil, kaufpreis, wohnfläche, 'houses in sale' AS imm_typ FROM haus_kaufen_plz
        UNION ALL
        SELECT stadtteil, kaufpreis, wohnfläche, 'apartments in sale' AS imm_typ FROM wohnung_kaufen_plz
    ) AS combined_data
GROUP BY stadtteil;
```

| neighborhood         | number of houses in sale | house in sale avg price | house in sale avg square meters | house in sale avg sm price | number of apartments in sale | apartments in sale avg price | house in sale avg square meters | apartments in sale avg sm price |
|----------------------|--------------------------|-------------------------|---------------------------------|----------------------------|------------------------------|------------------------------|---------------------------------|---------------------------------|
| Urbach               | 37                       | € 838.556               | 214 m²                          | € 4.132                    | 15                           | € 261.257                    | 84 m²                           | € 3.186                         |
| Godorf               | 17                       | € 629.822               | 155 m²                          | € 4.189                    | 11                           | € 289.545                    | 81 m²                           | € 3.494                         |
| Holweide             | 20                       | € 960.880               | 226 m²                          | € 4.521                    | 11                           | € 301.305                    | 76 m²                           | € 3.949                         |
| Neustadt/Nord        | 3                        | € 2.704.667             | 521 m²                          | € 5.182                    | 13                           | € 422.077                    | 65 m²                           | € 6.597                         |
| Dünnwald             | 24                       | € 785.125               | 177 m²                          | € 4.589                    | 12                           | € 373.875                    | 96 m²                           | € 3.839                         |
| Weiden               | 5                        | € 1.486.500             | 214 m²                          | € 7.611                    | 24                           | € 452.612                    | 94 m²                           | € 4.516                         |
| Innenstadt           | 23                       | € 1.846.957             | 383 m²                          | € 5.758                    | 124                          | € 541.875                    | 78 m²                           | € 6.395                         |
| Wahn                 | 31                       | € 1.119.985             | 288 m²                          | € 4.186                    | 17                           | € 235.535                    | 74 m²                           | € 3.114                         |
| Merkenich            | 31                       | € 731.671               | 190 m²                          | € 4.167                    | 7                            | € 296.629                    | 83 m²                           | € 3.542                         |
| Lindweiler           | 15                       | € 701.719               | 182 m²                          | € 4.049                    | 7                            | € 319.071                    | 89 m²                           | € 3.623                         |
| Brück                | 13                       | € 700.000               | 154 m²                          | € 4.717                    | 16                           | € 231.075                    | 73 m²                           | € 3.150                         |
| Hahnwald             | 11                       | € 2.292.545             | 298 m²                          | € 7.102                    | 2                            | € 409.450                    | 88 m²                           | € 4.675                         |
| Klettenberg          | 3                        | € 1.113.333             | 135 m²                          | € 8.100                    | 4                            | € 851.750                    | 108 m²                          | € 7.379                         |
| Westhoven            | 10                       | € 755.100               | 189 m²                          | € 4.120                    | 43                           | € 244.127                    | 78 m²                           | € 3.040                         |
| Rath/Heumar          | 19                       | € 708.105               | 188 m²                          | € 3.962                    | 21                           | € 250.238                    | 76 m²                           | € 3.258                         |
| Zollstock            | 4                        | € 954.750               | 358 m²                          | € 3.583                    | 17                           | € 357.929                    | 68 m²                           | € 5.274                         |
| Chorweiler           | 17                       | € 632.306               | 138 m²                          | € 4.679                    | 4                            | € 263.750                    | 77 m²                           | € 3.410                         |
| Lövenich             | 21                       | € 897.229               | 164 m²                          | € 5.843                    | 19                           | € 474.942                    | 100 m²                          | € 4.549                         |
| Riehl                | 7                        | € 936.686               | 173 m²                          | € 5.568                    | 36                           | € 296.089                    | 77 m²                           | € 3.850                         |
| Bilderstöckchen      | 9                        | € 968.556               | 255 m²                          | € 4.217                    | 11                           | € 347.390                    | 80 m²                           | € 4.176                         |
| Kalk                 | 5                        | € 905.000               | 319 m²                          | € 4.155                    | 26                           | € 201.154                    | 64 m²                           | € 3.187                         |
| Poll                 | 5                        | € 992.600               | 258 m²                          | € 3.893                    | 20                           | € 309.100                    | 77 m²                           | € 3.872                         |
| Sürth                | 13                       | € 896.138               | 161 m²                          | € 5.570                    | 23                           | € 464.774                    | 84 m²                           | € 5.204                         |
| Bocklemünd/Mengenich | 3                        | € 756.000               | 166 m²                          | € 4.606                    | 11                           | € 270.138                    | 77 m²                           | € 3.559                         |
| Porz                 | 16                       | € 726.125               | 186 m²                          | € 4.413                    | 30                           | € 303.337                    | 84 m²                           | € 3.601                         |
| Neustadt/Süd         | 5                        | € 1.505.800             | 439 m²                          | € 3.429                    | 8                            | € 378.000                    | 60 m²                           | € 6.301                         |
| Buchforst            | 5                        | € 1.118.220             | 223 m²                          | € 4.498                    | 15                           | € 306.820                    | 76 m²                           | € 4.011                         |
| Stammheim            | 9                        | € 592.999               | 152 m²                          | € 4.119                    | 23                           | € 363.493                    | 69 m²                           | € 5.280                         |
| Müngersdorf          | 6                        | € 1.408.333             | 208 m²                          | € 6.687                    | 11                           | € 598.091                    | 101 m²                          | € 5.536                         |
| Bickendorf           | 4                        | € 1.021.500             | 254 m²                          | € 4.735                    | 6                            | € 392.218                    | 77 m²                           | € 5.115                         |
| Ehrenfeld            | 4                        | € 1.207.000             | 332 m²                          | € 4.695                    | 13                           | € 285.900                    | 64 m²                           | € 4.521                         |
| Sülz                 | 4                        | € 2.567.500             | 249 m²                          | € 10.303                   | 5                            | € 984.000                    | 134 m²                          | € 7.057                         |
| Marienburg           | 1                        | € 1.750.000             | 207 m²                          | € 8.454                    | 0                            | 0                            | 0                               | 0                               |
| Bayenthal            | 6                        | € 2.407.500             | 402 m²                          | € 7.679                    | 20                           | € 722.106                    | 101 m²                          | € 6.901                         |
| Altstadt/Süd         | 5                        | € 3.689.800             | 956 m²                          | € 3.771                    | 17                           | € 444.127                    | 66 m²                           | € 6.611                         |
| Weidenpesch          | 7                        | € 600.857               | 121 m²                          | € 5.194                    | 38                           | € 388.676                    | 76 m²                           | € 5.140                         |
| Nippes               | 4                        | € 1.491.000             | 392 m²                          | € 4.395                    | 20                           | € 244.802                    | 57 m²                           | € 4.280                         |
| Mülheim              | 3                        | € 918.667               | 325 m²                          | € 2.925                    | 15                           | € 277.553                    | 70 m²                           | € 3.787                         |
| Altstadt/Nord        | 1                        | € 2.950.000             | 749 m²                          | € 3.939                    | 1                            | € 428.000                    | 75 m²                           | € 5.707                         |
| Deutz                | 1                        | € 1.750.000             | 350 m²                          | € 5.000                    | 1                            | € 799.000                    | 116 m²                          | € 6.888                         |
| Neuehrenfeld         | 0                        | 0                       | 0                               | 0                          | 1                            | € 99.000                     | 29 m²                           | € 3.414                         |
| Gremberghoven        | 0                        | 0                       | 0                               | 0                          | 4                            | € 204.000                    | 77 m²                           | € 2.649                         |
---

## 7. Are there any price differences between houses or apartments if negotiations are handled privately or by a real estate agency?


- House in sale
```sql
SELECT  
    CASE WHEN makler = "Privatanbieter" or makler = "ohne-makler.net - Immobilien selbst vermarkten" 
        THEN "house private sale" ELSE "house agent sale" END as sale_type,
    COUNT(*) as n_ads,
    CONCAT("€ ", FORMAT(AVG(kaufpreis),2, "de_DE")) as avg_price
FROM haus_kaufen
GROUP BY sale_type
```
| sale_type          | n_ads | avg_price   |
|--------------------|-------|-------------|
| house agent sale   | 376   | € 1.012.269 |
| house private sale | 51    | € 1.291.498 |

- Apartment in sale
```sql
SELECT  
    CASE WHEN makler = "Privatanbieter" or makler = "ohne-makler.net - Immobilien selbst vermarkten" 
        THEN "apartment private sale" ELSE "apartment agent sale" END as sale_type,
    COUNT(*) as n_ads,
    CONCAT("€ ", FORMAT(AVG(kaufpreis),0, "de_DE")) as avg_price
FROM wohnung_kaufen
GROUP BY sale_type
```
| sale_type              | n_ads | avg_price |
|------------------------|-------|-----------|
| apartment agent sale   | 630   | € 387.752 |
| apartment private sale | 92    | € 353.147 |


- Houses for rent
```sql
SELECT  
    CASE WHEN makler = "Privatanbieter" or makler = "ohne-makler.net - Immobilien selbst vermarkten" 
        THEN "house private rent" ELSE "house agent rent" END as sale_type,
    COUNT(*) as n_ads,
    CONCAT("€ ", FORMAT(AVG(kaltmiete),0, "de_DE")) as avg_cold_rent
FROM haus_mieten
GROUP BY sale_type
```
| sale_type          | n_ads | avg_cold_rent |
|--------------------|-------|---------------|
| house private rent | 3     | € 2.530       |
| house agent rent   | 4     | € 2.698       |


- Apartments for rent
```sql
SELECT  
    CASE 
    WHEN makler IN("Privatanbieter","ohne-makler.net - Immobilien selbst vermarkten") THEN "apartment private rent" 
    WHEN makler IN("Tauschwohnung GmbH","Wohnungsswap.de") THEN "apartment swap"
    ELSE "apartment agent rent" END as sale_type,
    COUNT(*) as n_ads,
    CONCAT("€ ", FORMAT(AVG(kaltmiete),0, "de_DE")) as avg_cold_rent
FROM wohnung_mieten
GROUP BY sale_type
```
| sale_type              | n_ads | avg_cold_rent |
|------------------------|-------|---------------|
| apartment private rent | 29    | € 1.064       |
| apartment agent rent   | 115   | € 1.267       |
| apartment swap         | 72    | € 781         |


- TOP 10 makler by ads
```sql
SELECT
  makler,
  COUNT(*) AS num_ads
FROM
  (
    SELECT makler FROM haus_kaufen
    UNION ALL
    SELECT makler FROM haus_mieten
    UNION ALL
    SELECT makler FROM wohnung_kaufen
    UNION ALL
    SELECT makler FROM wohnung_mieten
  ) AS all_table
WHERE makler NOT IN("Privatanbieter", "ohne-makler.net - Immobilien selbst vermarkten", "Tauschwohnung GmbH", "Wohnungsswap.de")
GROUP BY
  makler
ORDER BY
  num_ads DESC
LIMIT 10;
```
| makler                                      | num_ads |
|---------------------------------------------|---------|
| Vonovia SE-Selbstständiger Vertriebspartner | 99      |
| S Immobilienpartner GmbH                    | 91      |
| GLOBAL-ACT GmbH                             | 59      |
| BECKER & BECKER Immobilien GmbH             | 34      |
| FALC Immobilien Köln & Pulheim              | 32      |
| Homeday GmbH                                | 30      |
| PlanetHome Group GmbH                       | 27      |
| Bonava Deutschland GmbH                     | 25      |
| Dein-ImmoCenter                             | 22      |
| Evernest GmbH                               | 21      |
---

# 8. What is the price difference between houses or apartments for sale versus those at auction?

Created a view of tables containing houses and apartments that can be purchased at auction

- Auction houses
```sql  
WITH zv AS (
	SELECT anzeige, info
    FROM haus_kaufen_anz
    WHERE info LIKE "%Zwangsversteigerung%")
SELECT hk.ref_num,
	hk.anzeige AS anz,
    hk.kaufpreis,
    hk.wohnfläche,
    hk.zimmer,
    hk.grundstück,
    hk.stadtteil
FROM haus_kaufen_plz as hk
JOIN zv ON hk.anzeige = zv.anzeige
GROUP BY ref_num,anz,kaufpreis, wohnfläche,zimmer,grundstück,stadtteil
```
| ref_num | anz                                                                               | kaufpreis | wohnfläche | zimmer | grundstück | stadtteil       |
|---------|-----------------------------------------------------------------------------------|-----------|------------|--------|------------|-----------------|
| 2cmju5c | Kapitalanlage + Mehrfamilienhaus, nebst Garage und Stellplatz                     | 830000    | 225        | 12     | 324        | Holweide        |
| 2cep45c | Mehrfamilienhaus in 51067 Köln, Scheidemannstr.                                   | 830000    | 225        | N/A    | 324        | Holweide        |
| 2c9u95c | Reihenmittelhaus in 50739 Köln, Guntherstr.                                       | 450000    | 102        | N/A    | 200        | Bilderstöckchen |
| 2cjhu5c | Kapitalanlage + Wohn-/Geschäftshaus +                                             | 795000    | 186        | N/A    | 282        | Riehl           |
| 2c3aa5c | Zweifamilienhaus in 50737 Köln, Bielefelder Str.                                  | 630000    | 99         | N/A    | 513        | Weidenpesch     |
| 2chgt59 | Reiheneckhaus in 51145 Köln, Georgstr.                                            | 400000    | 110        | N/A    | 280        | Urbach          |
| 2cx9g5c | Reiheneckhaus in 51145 Köln, Helmholtzstr.                                        | 510000    | 133        | N/A    | 235        | Urbach          |
| 2czla5c | Doppelhaushälfte in 51069 Köln, In der Gansau                                     | 560000    | 122        | N/A    | 814        | Dünnwald        |
| 2cdkg5c | Zweifamilienhaus in 51107 Köln, Frankfurter Str.                                  | 1180000   | 290        | N/A    | 1291       | Rath/Heumar     |
| 2c9e85d | Einfamilienhaus in 51147 Köln, Grengeler Mauspfad                                 | 1405000   | 197        | N/A    | 2016       | Wahn            |
| 2cv4z59 | Einfamilienhaus in 50859 Köln, Karl-Kaulen-Str.                                   | 410000    | 62         | N/A    | 401        | Lövenich        |
| 2ckea5c | Einfamilienhaus in 51067 Köln, Schnellweider Str.                                 | 800000    | 110        | N/A    | 1213       | Holweide        |
| 2ca2n5c | Doppelhaushälfte in 50968 Köln, Bayenthalgürtel                                   | 2140000   | 211        | N/A    | 392        | Bayenthal       |
| 2c9a85d | Doppelhaushälfte in 51069 Köln, Grafenmühlenweg                                   | 700000    | 143        | N/A    | 976        | Dünnwald        |
| 2c6hx5c | Klein, aber mein ++ Einfamilienhaus mit Garten ++                                 | 410000    | 62         | 3      | 401        | Lövenich        |
| 2cjhx5c | Einfamilien-Reihenendhaus mit Doppelgarage - provisionsfrei                       | 400000    | 110        | 4      | 280        | Urbach          |
| 2cahx5c | Platz für die ganze Familie + Großzügiges Einfamilienhaus mit Garten und Garage + | 2140000   | 211        | 7      | 392        | Bayenthal       |
| 2cfhx5c | + Doppelhaushälfte mit Garage und Stellplatz +                                    | 700000    | 143        | 6      | 976        | Dünnwald        |
| 2cghx5c | Platz für alle + 2-Familienhaus mit Garage +                                      | 1180000   | 290        | 7      | 1291       | Rath/Heumar     |
| 2c4hx5c | Einfamilien-Reihenmittelhaus mit Garten + provisionsfrei +                        | 450000    | 102        | 4      | 200        | Bilderstöckchen |
| 2chhx5c | + Reihenendhaus mit Garten und Garage +                                           | 510000    | 133        | 5      | 235        | Urbach          |
| 2clhx5c | + Großzügiges Einfamilienhaus mit 4 Garagen +                                     | 1405000   | 197        | 5      | 2016       | Wahn            |
| 2c2hx5c | 2-Familienhaus mit Garage + provisionsfrei +                                      | 630000    | 118        | 7      | 513        | Weidenpesch     |
| 2cdhx5c | Einfamilienhaus mit Garten ++ provisionsfrei ++                                   | 800000    | 110        | 4      | 1213       | Holweide        |

```sql
SELECT
  concat("€ ", format(AVG(kaufpreis), 0, "de_DE")) AS "NO AUCTION houses - Average price",
  concat("€ ", format(AVG(kaufpreis/wohnfläche), 0, "de_DE")) AS "SM average price",
  concat("€ ", format(AVG(kaufpreis/(wohnfläche+grundstück)), 0, "de_DE")) AS "SM average price - with land plot"
FROM
  haus_kaufen
WHERE
  ref_num NOT IN (SELECT ref_num FROM auction_houses);
```
| NO AUCTION houses - Average price | SM average price | SM average price - with land plot |
|-----------------------------------|------------------|-----------------------------------|
| € 1.057.604                       | € 4.740          | € 1.871                           |

```sql
SELECT
  concat("€ ", format(AVG(kaufpreis), 0, "de_DE")) AS "AUCTION houses - Average price",
  concat("€ ", format(AVG(kaufpreis/wohnfläche), 0, "de_DE")) AS "SM average price",
  concat("€ ", format(AVG(kaufpreis/(wohnfläche+grundstück)), 0, "de_DE")) AS "SM average price - with land plot"
FROM
  auction_houses
```
| AUCTION houses - Average price | SM average price | SM average price - with land plot |
|--------------------------------|------------------|-----------------------------------|
| € 844.375                      | € 5.498          | € 1.218                           |

```sql
SELECT 
    stadtteil as neighborhood,
    count(*) as auction_houses,
    concat("€ ", format(AVG(kaufpreis), 0, "de_DE")) as avg_price,
    concat("€ ", format(AVG(kaufpreis/wohnfläche), 0, "de_DE")) as sm_avg_price
FROM auction_houses
GROUP BY stadtteil
ORDER BY auction_houses DESC
```
| neighborhood    | auction_houses | avg_price   | sm_avg_price |
|-----------------|----------------|-------------|--------------|
| Holweide        | 4              | € 815.000   | € 5.481      |
| Urbach          | 4              | € 455.000   | € 3.735      |
| Dünnwald        | 3              | € 653.333   | € 4.793      |
| Bilderstöckchen | 2              | € 450.000   | € 4.412      |
| Weidenpesch     | 2              | € 630.000   | € 5.851      |
| Rath/Heumar     | 2              | € 1.180.000 | € 4.069      |
| Wahn            | 2              | € 1.405.000 | € 7.132      |
| Lövenich        | 2              | € 410.000   | € 6.613      |
| Bayenthal       | 2              | € 2.140.000 | € 10.142     |
| Riehl           | 1              | € 795.000   | € 4.274      |



- Auction apartments

```sql
with zv as(
	select anzeige, info
    from wohnung_kaufen_anz
    where info like "%Zwangsversteigerung%")
select wk.ref_num,
	wk.anzeige as anz,
    wk.kaufpreis,
    wk.wohnfläche,
    wk.zimmer,
    wk.stadtteil
from wohnung_kaufen_plz as wk
join zv on wk.anzeige = zv.anzeige
group by ref_num,anz,kaufpreis, wohnfläche,zimmer,stadtteil
```
| ref_num | anz                                                             | kaufpreis | wohnfläche | zimmer | stadtteil   |
|---------|-----------------------------------------------------------------|-----------|------------|--------|-------------|
| 2cb6c5a | Etagenwohnung in 50823 Köln, Graeffstr.                         | 140000    | 42         | 2      | Innenstadt  |
| 2cwpt5c | 1/2 Anteil - Wohnung                                            | 145000    | 82         | 3      | Riehl       |
| 2c3f85d | Etagenwohnung in 50933 Köln, Voigtelstr.                        | 949000    | 143        | 3      | Müngersdorf |
| 2cyum5c | Etagenwohnung in 51147 Köln, Akazienweg                         | 190000    | 62         | 3      | Wahn        |
| 2cy6z59 | Etagenwohnung in 50999 Köln, Sürther Hauptstr.                  | 404000    | 95         | 3      | Sürth       |
| 2c5hx5c | 2-Zimmer-Wohnung + provisionsfrei +                             | 140000    | 42         | 2      | Innenstadt  |
| 2cmhx5c | + 2-Zimmer-Wohnung mit Terrasse +                               | 180000    | 65         | 2      | Westhoven   |
| 2ckhx5c | 3-Zimmer-Wohnung mit Balkon + provisionsfrei +                  | 190000    | 62         | 3      | Wahn        |
| 2c7hx5c | Große 3-Zimmer-Wohnung mit Balkon und Garage + provisionsfrei + | 949000    | 143        | 3      | Müngersdorf |
| 2cehx5c | Einfamilien-Doppelhaushälfte mit Terrasse                       | 560000    | 122        | 4      | Dünnwald    |
| 2cbhx5c | + 3-Zimmer-Wohnung mit TG-Stellplatz +                          | 404000    | 95         | 3      | Sürth       |
| 2cchx5c | 3-Zimmer-Wohnung - provisionsfrei                               | 205000    | 72         | 3      | Mülheim     |
| 2cnhx5c | 5-Zimmer-Wohnung mit Loggia + provisionsfrei +                  | 225000    | 90         | 5      | Westhoven   |
| 2cdx95c | Etagenwohnung in 50735 Köln, An der Schanz                      | 145000    | 82         | 3      | Riehl       |
| 2cp8a5c | Etagenwohnung in 51149 Köln, Konrad-Adenauer-Str.               | 225000    | 90         | 5      | Westhoven   |
| 2chkg5c | Etagenwohnung in 51149 Köln, Nikolausstr.                       | 180000    | 65         | 3      | Westhoven   |
| 2cacs5d | Dachgeschosswohnung in 51063 Köln, Berliner Str.                | 205000    | 72         | 3      | Mülheim     |
| 2c37q5b | Erdgeschosswohnung in 50935 Köln, Viktor-Schnitzler-Str.        | 1285000   | 156        | 4      | Sülz        |
| 2c8hx5c | 4-Zimmer-Wohnung mit Garten und Garage + provisionsfrei +       | 1285000   | 156        | 4      | Sülz        |


```sql
SELECT 
    stadtteil as neighborhood,
    count(*) as auction_apartments,
    concat("€ ", format(AVG(kaufpreis), 0, "de_DE")) as avg_price,
    concat("€ ", format(AVG(kaufpreis/wohnfläche), 0, "de_DE")) as sm_avg_price
FROM auction_apt
GROUP BY stadtteil
ORDER BY auction_apartments DESC
```
| neighborhood | auction_apartments | avg_price   | sm_avg_price |
|--------------|--------------------|-------------|--------------|
| Westhoven    | 4                  | € 202.500   | € 2.635      |
| Innenstadt   | 2                  | € 140.000   | € 3.333      |
| Riehl        | 2                  | € 145.000   | € 1.768      |
| Müngersdorf  | 2                  | € 949.000   | € 6.636      |
| Wahn         | 2                  | € 190.000   | € 3.065      |
| Sürth        | 2                  | € 404.000   | € 4.253      |
| Mülheim      | 2                  | € 205.000   | € 2.847      |
| Sülz         | 2                  | € 1.285.000 | € 8.237      |
| Dünnwald     | 1                  | € 560.000   | € 4.590      |

```sql
SELECT
  concat("€ ", format(AVG(kaufpreis), 0, "de_DE")) AS "NO AUCTION apartments - Average price",
  concat("€ ", format(AVG(kaufpreis/wohnfläche), 0, "de_DE")) AS "SM average price"
FROM
  wohnung_kaufen
WHERE
  ref_num NOT IN (SELECT ref_num FROM auction_apt);
```
| NO AUCTION apartments - Average price | SM average price |
|---------------------------------------|------------------|
| € 382.314                             | € 4.712          |

```sql
SELECT
  concat("€ ", format(AVG(kaufpreis), 0, "de_DE")) AS "AUCTION houses - Average price",
  concat("€ ", format(AVG(kaufpreis/wohnfläche), 0, "de_DE")) AS "SM average price"
FROM
  auction_apt
```
| AUCTION houses - Average price | SM average price |
|--------------------------------|------------------|
| € 421.368                      | € 3.969          |
