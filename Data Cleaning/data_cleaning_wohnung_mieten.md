# DATA CLEANING

## WOHNUNG_MIETEN table 
---

# 1. Explore the table structure
---
```sql
SELECT *
FROM wohnung_mieten
```
| link                                   | anzeige                                                                                           | wohnfläche | zimmer | ort                        | kaltmiete | nebenkosten | heizkosten | kaution | wohnungslage               | sonstiges      | effizienzklasse | makler                                                      |
|----------------------------------------|---------------------------------------------------------------------------------------------------|------------|--------|----------------------------|-----------|-------------|------------|---------|----------------------------|----------------|-----------------|-------------------------------------------------------------|
| https://www.immowelt.de/expose/2gsrr49 | Schicke Dachgeschoss Wohnung                                                                      | 67         | 2      | 50968 Köln  (Raderthal)    | 880       | 150         | -          | 2.500   | 3. Geschoss (Dachgeschoss) |                |                 |                                                             |
| https://www.immowelt.de/expose/2k4374q | 09.11.2023 BESICHTIGUNG um 15:30! 2 Schlafzimmer, 1 Wohnzimer, 1 offener Studioraum               | 99         | 3      | 51103 Köln  (Kalk)         | 1.230     | 360         | 1.590      | 2.460   | 4. Geschoss (Dachgeschoss) |                |                 | Roggendorf GbR                                              |
| https://www.immowelt.de/expose/2w83t4a | 3,5-Zimmerwohnung in Rheinnähe mit größer Südterrasse zum Wohlfühlen                              | 115        | 4      | 51149 Köln  (Westhoven)    | 1.455     | 350         | -          | 3 NKM   | 1. Geschoss                | 01.12.2023     |                 |                                                             |
| https://www.immowelt.de/expose/2z6kd4l | Zwei Zimmerwohnung mit Pantryküche                                                                | 32         | 2      | 51063 Köln  (Mülheim)      | 650       | 90          | 740        | 1.950   |                            | sofort         |                 | ABU Immobilien                                              |
| https://www.immowelt.de/expose/23wbb5f | Einzigartiges Wohnloft (Gewerbe möglich) über 2 Etagen, Toplage im Kwartier Latäng, 2 Stellplätze | 800        | 9      | 50674 Köln  (Neustadt-Süd) | 7.450     | 1.200       | 8.650      | 33.000  |                            | nach Absprache | E               | Sotheby´s International Realty NRW/Pantera Living Köln GmbH |


```sql
-- Number of ads for apartments to rent

SELECT count(anzeige) as n_ads
FROM wohnung_mieten
```
| n_ads |
|-------|
| 217   |
---

# 2. Manage duplicates
---
```sql
SELECT 
    total_ads,
    unique_ads,
    total_ads - unique_ads as potential_duplicates
FROM (
    SELECT 
        COUNT(anzeige) as total_ads,
        COUNT(DISTINCT anzeige) as unique_ads
    FROM
        wohnung_mieten) 
    dupl;
```
| total_ads | unique_ads | potential_duplicates |
|-----------|------------|----------------------|
| 217       | 211        | 6                    |

```sql
SELECT *
FROM wohnung_mieten
WHERE anzeige IN (
    SELECT anzeige
    FROM wohnung_mieten
    GROUP BY anzeige
    HAVING COUNT(*) > 1
)
ORDER BY anzeige ASC;
```

| link                                   | anzeige                                                                        | wohnfläche | zimmer | ort                       | kaltmiete | nebenkosten | heizkosten | kaution | wohnungslage | sonstiges     | effizienzklasse | makler                          |
|----------------------------------------|--------------------------------------------------------------------------------|------------|--------|---------------------------|-----------|-------------|------------|---------|--------------|---------------|-----------------|---------------------------------|
| https://www.immowelt.de/expose/2c9wm5d | 3-Zimmer-Wohnung mit großem Balkon und viel Licht!                             | 97         | 2      | 51149 Köln / Ensen        | 1.495     | 291         | -          | 4.485   |              | Frühjahr 2024 |                 | BECKER & BECKER Immobilien GmbH |
| https://www.immowelt.de/expose/2ckwm5d | 3-Zimmer-Wohnung mit großem Balkon und viel Licht!                             | 97         | 2      | 51149 Köln / Ensen        | 1.534     | 291         | -          | 4.602   |              | Frühjahr 2024 |                 | BECKER & BECKER Immobilien GmbH |
| https://www.immowelt.de/expose/2c4jw54 | Luxuriöse Wohnung im schönen Junkersdorf erfüllt höchste Ansprüche (Erstbezug) | 106        | 3      | 50858 Köln  (Junkersdorf) | 2.120     | 400         | 100        | 6.360   |              | Erstbezug     |                 |                                 |
| https://www.immowelt.de/expose/2cnf657 | Luxuriöse Wohnung im schönen Junkersdorf erfüllt höchste Ansprüche (Erstbezug) | 160        | 3      | 50858 Köln  (Junkersdorf) | 3.200     | 3.800       | 20         | 9.600   | 1. Geschoss  | Erstbezug     |                 |                                 |
| https://www.immowelt.de/expose/2ctgj57 | Perfekt für die ganze Familie. 4-Zimmer-Wohnung mit zwei Bädern!               | 98         | 4      | 51149 Köln / Ensen        | 1.504     | 295         | -          | 4.512   |              | Frühjahr 2024 |                 | BECKER & BECKER Immobilien GmbH |
| https://www.immowelt.de/expose/2cpwm5d | Perfekt für die ganze Familie. 4-Zimmer-Wohnung mit zwei Bädern!               | 98         | 4      | 51149 Köln / Ensen        | 1.561     | 295         | -          | 4.512   |              | Frühjahr 2024 |                 | BECKER & BECKER Immobilien GmbH |
| https://www.immowelt.de/expose/2acr75a | Wohnungsswap - Ehrenstraße                                                     | 40         | 2      | 50672                     | 400       | -           | -          |         | 1. Geschoss  |               |                 | Wohnungsswap.de                 |
| https://www.immowelt.de/expose/2a9u85a | Wohnungsswap - Ehrenstraße                                                     | 81         | 4      | 50672                     | 950       | -           | -          |         | 1. Geschoss  |               |                 | Wohnungsswap.de                 |
| https://www.immowelt.de/expose/2aj2m5q | Wohnungsswap - Steinkauzweg                                                    | 55         | 2      | 50829                     | 670       | -           | -          |         | 2. Geschoss  |               |                 | Wohnungsswap.de                 |
| https://www.immowelt.de/expose/2al2m5q | Wohnungsswap - Steinkauzweg                                                    | 55         | 2      | 50829                     | 670       | -           | -          |         | 2. Geschoss  |               |                 | Wohnungsswap.de                 |
| https://www.immowelt.de/expose/2a6r85a | Wohnungsswap - Venloer Straße                                                  | 67         | 2      | 50827                     | 792       | -           | -          |         | 6. Geschoss  |               |                 | Wohnungsswap.de                 |
| https://www.immowelt.de/expose/2c6yg5c | Wohnungsswap - Venloer Straße                                                  | 105        | 3      | 50823                     | 1.500     | -           | -          |         | 4. Geschoss  |               |                 | Wohnungsswap.de                 |


#### They are all ads referred to different apartment. No duplicate are removed
---

# 3. Manage missing values
---

```sql
-- Insered the column with ref_num

ALTER TABLE wohnung_mieten
ADD COLUMN ref_num VARCHAR(255);
```
```sql
UPDATE wohnung_mieten
SET ref_num = SUBSTRING(link, LENGTH('https://www.immowelt.de/expose/') + 1);
```
```sql
ALTER TABLE "immo_köln"."wohnung_mieten" 
CHANGE COLUMN "ref_num" "ref_num" VARCHAR(255) NULL DEFAULT NULL AFTER "link";
```



-- Identified the number of null values in the column "wohnfläche"

```sql
SELECT count(anzeige) as null_wohnfläche
FROM wohnung_mieten
WHERE wohnfläche = ""
```
| null_wohnfläche |
|-----------------|
| 0               |

```sql
-- Identified the number of null values in the column "zimmer"

SELECT count(anzeige) as null_zimmer
FROM wohnung_mieten
WHERE zimmer = ""
```
| null_zimmer |
|-------------|
| 4           |

```sql
SELECT *
FROM wohnung_mieten
WHERE zimmer = "" 
```

| link                                   | anzeige                                                                  | wohnfläche | zimmer | ort                         | kaltmiete | nebenkosten                    | heizkosten | kaution | wohnungslage               | sonstiges       | effizienzklasse | makler                   |
|----------------------------------------|--------------------------------------------------------------------------|------------|--------|-----------------------------|-----------|--------------------------------|------------|---------|----------------------------|-----------------|-----------------|--------------------------|
| https://www.immowelt.de/expose/24m2757 | Vollmöbliertes Apartment für Studenten & Azubis ab 19m² ab 625€          | 19         |        | 50825 Köln  (Ehrenfeld)     | 485       | 140                            | -          | 1.455   | 1. Geschoss                |                 | B               | Cube Life GmbH           |
| https://www.immowelt.de/expose/2bljn5q | Pendler aufgepasst! Schick möbliertes 65 qm Appartement mit DACHTERRASSE | 65         |        | 50672 Köln  (Altstadt-Nord) | 1.399     | 160                            | -          | 4.197   | 4. Geschoss (Dachgeschoss) |                 | E               | Sylvia-Keidel-Immobilien |
| https://www.immowelt.de/expose/2ceq856 | Wohnung im gehobenen Stil auf der 1.Etage in einem 2 Familienhaus        | 70         |        | 50739 Köln  (Longerich)     | 860       | 100                            | 180        | 1.720   | 1. Geschoss (Dachgeschoss) | 1.Dezember 2023 |                 |                          |
| https://www.immowelt.de/expose/2cktv5a | Köln luxuriös genießen (Möbeliert)                                       | 70         |        | 50933 Köln  (Braunsfeld)    | 1.650     | nicht in Nebenkosten enthalten | -          |         | Dachgeschoss               |                 |                 |                          |


Searched for rooms information 
24m2757 1
2bljn5q 2
2ceq856 2 
2cktv5a 2

```sql
UPDATE wohnung_mieten
SET zimmer = 2
WHERE ref_num IN("2bljn5q", "2ceq856", "2cktv5a")
```
```sql
UPDATE wohnung_mieten
SET zimmer = 1
WHERE ref_num = "24m2757"
```

```sql
-- Identified the number of null values in the column "ort"

SELECT count(anzeige) as null_ort
FROM wohnung_mieten
WHERE ort = ""
```
| null_ort	  |
|-------------|
| 0           |

```sql
-- Identified the number of null values in the column "kaltmiete"

SELECT count(anzeige) as null_kaltmiete
FROM wohnung_mieten
WHERE kaltmiete = ""
```

| null_kaltmiete |
|----------------|
| 0              |

```sql
-- Identified the number of null values in the column "nebenkosten"

SELECT count(anzeige) as null_nebenkosten
FROM wohnung_mieten
WHERE nebenkosten = ""
```
| null_nebenkosten |
|------------------|
| 0                |

```sql
-- Identified the number of null values in the column "heizkosten"

SELECT count(anzeige) as null_heizkosten
FROM wohnung_mieten
WHERE heizkosten = ""
```
| null_heizkosten  |
|------------------|
| 0                |

```sql
-- Identified the number of null values in the column "kaution"

SELECT count(anzeige) as null_kaution
FROM wohnung_mieten
WHERE kaution = ""
```
| null_kaution |
|--------------|
| 0            |

```sql
SELECT count(ref_num) as null_makler
FROM wohnung_mieten
WHERE makler = ""
```
| null_makler	 |
|--------------|
| 28           |

```sql
-- Set as private offer where the column "makler" is null

UPDATE wohnung_mieten
SET makler = "Privatanbieter"
WHERE makler = ""
```

---

# 4. Dealing with outliers
---
```sql
-- Checked the value range of the living area

SELECT 
    MIN(wohnfläche) as min_wf,
    MAX(wohnfläche) as max_wf
FROM wohnung_mieten
```
| min_wf | max_wf |
|--------|--------|
| 16     | 800    |

```sql
-- Checked the value range of the rooms

SELECT zimmer, 
    count(zimmer) as n_ads
FROM wohnung_mieten
GROUP BY zimmer
ORDER BY zimmer ASC
```
| zimmer | n_ads |
|--------|-------|
| 1      | 26    |
| 1,5    | 5     |
| 2      | 85    |
| 2,5    | 4     |
| 3      | 75    |
| 3,5    | 9     |
| 4      | 10    |
| 5      | 2     |
| 9      | 1     |

```sql
-- Checking if in the column ort there are only postal codes of Cologne (doesn´t start with 5)

SELECT *
FROM wohnung_mieten
WHERE ort NOT LIKE '5%';
```
| link                                   | ref_num | anzeige                                                | wohnfläche | zimmer | ort            | kaltmiete | nebenkosten | heizkosten | kaution | wohnungslage | sonstiges | effizienzklasse | makler                |
|----------------------------------------|---------|--------------------------------------------------------|------------|--------|----------------|-----------|-------------|------------|---------|--------------|-----------|-----------------|-----------------------|
| https://www.immowelt.de/expose/2ayxw5y | 2ayxw5y | Südtiroler Chalet in Alleinlage in Jenesien - Südtirol | 73         | 2      | 39050 Jenesien | 980.000   | -           | -          |         |              |           |                 | 9045 Real Estate GmbH |

### The ad refers to an aparment in Italien (Südtirol). For this reason provided to delete it

```sql
DELETE
FROM wohnung_mieten
WHERE ref_num = "2ayxw5y"
```
```sql
-- Checked the range of the column "kaltmiete"

SELECT 
    MIN(kaltmiete) as min_km,
    MAX(kaltmiete) as max_km
FROM wohnung_mieten
```
| min_km | max_km |
|--------|--------|
| 280    | 8500   |

```sql
-- Checked the range of the column "heizkosten"

SELECT 
    MIN(heizkosten) as min_hk,
    MAX(heizkosten) as max_hk
FROM wohnung_mieten
```
```sql
-- Investigated why heating costs are so high in some ads.

SELECT *
FROM wohnung_mieten
WHERE heizkosten > 1000
```

| link                                   | ref_num | anzeige                                                                                           | wohnfläche | zimmer | ort                        | kaltmiete | nebenkosten | heizkosten | kaution | wohnungslage               | wohnungslage_[0] | effizienzklasse | makler                                                      |
|----------------------------------------|---------|---------------------------------------------------------------------------------------------------|------------|--------|----------------------------|-----------|-------------|------------|---------|----------------------------|------------------|-----------------|-------------------------------------------------------------|
| https://www.immowelt.de/expose/2k4374q | 2k4374q | 09.11.2023 BESICHTIGUNG um 15:30! 2 Schlafzimmer, 1 Wohnzimer, 1 offener Studioraum               | 99         | 3      | 51103 Köln  (Kalk)         | 1230      | 360         | 1590       | 2460    | 4. Geschoss (Dachgeschoss) |                  |                 | Roggendorf GbR                                              |
| https://www.immowelt.de/expose/23wbb5f | 23wbb5f | Einzigartiges Wohnloft (Gewerbe möglich) über 2 Etagen, Toplage im Kwartier Latäng, 2 Stellplätze | 800        | 9      | 50674 Köln  (Neustadt-Süd) | 7450      | 1200        | 8650       | 33000   |                            | nach Absprache   | E               | Sotheby´s International Realty NRW/Pantera Living Köln GmbH |
| https://www.immowelt.de/expose/2cudv5d | 2cudv5d | In KÖLNS SZENEVIERTEL: Großzügiges und vollmöbliertes 3-Zimmer-Apartment!                         | 65         | 3      | 50823 Köln  (Neuehrenfeld) | 1433      | 255         | 1688       | 4300    | 5. Geschoss                |                  | B               | moovin Immobilien GmbH                                      |


It seems to be that the heating costs are actually the sum of the rent + accessories costs.
The reason is that in extrapolating the data, the same row where for some ads there were heating costs, in others there was directly the total amount including additional costs ("warmmiete").
Therefore, a table was created in which the total cost (sum of kaltmiete + nebenkosten) was compared with that of heating costs.
The difference amounted to zero if the "heizkosten" field actually contained the total cost of rent.

```sql
WITH wm AS(
		SELECT 
			ref_num,
			anzeige,
			kaltmiete,
			nebenkosten,
			heizkosten,
			kaltmiete + nebenkosten as warmmiete
		FROM wohnung_mieten)
SELECT ref_num
FROM wm
WHERE warmmiete - heizkosten = 0
```

| ref_num |
|---------|
| 2k4374q |
| 2z6kd4l |
| 23wbb5f |
| 2cudv5d |
| 2c4dc5a |


The list of ads containing the incorrect value also includes the values investigated above.
Provided to replace 0 as the value of the heating costs for the ads found

```sql
UPDATE wohnung_mieten
SET heizkosten = 0
WHERE ref_num IN("2k4374q", "2z6kd4l", "23wbb5f", "2cudv5d", "2c4dc5a")
```

-- Added the column plz and searched for the realtive Cologne area
```sql
ALTER TABLE wohnung_mieten
ADD COLUMN plz VARCHAR(255);

UPDATE wohnung_mieten
SET plz = TRIM(SUBSTRING_INDEX(ort, ' ', 1))
```
```sql
-- Joined the table with the postal code table, to retrieve the associeated area name
SELECT *
FROM wohnung_mieten AS wm
left JOIN plz_koeln as pk
ON wm.plz = pk.plz
```
| link                                   | ref_num | anzeige                                                                                           | wohnfläche | zimmer | ort                         | plz   | kaltmiete | nebenkosten | heizkosten | kaution | wohnungslage               | wohnungslage_[0] | effizienzklasse | makler                                                      | PLZ   | Stadtteil     |
|----------------------------------------|---------|---------------------------------------------------------------------------------------------------|------------|--------|-----------------------------|-------|-----------|-------------|------------|---------|----------------------------|------------------|-----------------|-------------------------------------------------------------|-------|---------------|
| https://www.immowelt.de/expose/2gsrr49 | 2gsrr49 | Schicke Dachgeschoss Wohnung                                                                      | 67         | 2      | 50968 Köln  (Raderthal)     | 50968 | 880       | 150         | 0          | 2500    | 3. Geschoss (Dachgeschoss) |                  |                 | Privatanbieter                                              | 50968 | Bayenthal     |
| https://www.immowelt.de/expose/2k4374q | 2k4374q | 09.11.2023 BESICHTIGUNG um 15:30! 2 Schlafzimmer, 1 Wohnzimer, 1 offener Studioraum               | 99         | 3      | 51103 Köln  (Kalk)          | 51103 | 1230      | 360         | 0          | 2460    | 4. Geschoss (Dachgeschoss) |                  |                 | Roggendorf GbR                                              | 51103 | Kalk          |
| https://www.immowelt.de/expose/2w83t4a | 2w83t4a | 3,5-Zimmerwohnung in Rheinnähe mit größer Südterrasse zum Wohlfühlen                              | 115        | 3,5    | 51149 Köln  (Westhoven)     | 51149 | 1455      | 350         | 0          | 3 NKM   | 1. Geschoss                | 01.12.2023       |                 | Privatanbieter                                              | 51149 | Westhoven     |
| https://www.immowelt.de/expose/2z6kd4l | 2z6kd4l | Zwei Zimmerwohnung mit Pantryküche                                                                | 32         | 2      | 51063 Köln  (Mülheim)       | 51063 | 650       | 90          | 0          | 1950    |                            | sofort           |                 | ABU Immobilien                                              | 51063 | Mülheim       |
| https://www.immowelt.de/expose/23wbb5f | 23wbb5f | Einzigartiges Wohnloft (Gewerbe möglich) über 2 Etagen, Toplage im Kwartier Latäng, 2 Stellplätze | 800        | 9      | 50674 Köln  (Neustadt-Süd)  | 50674 | 7450      | 1200        | 0          | 33000   |                            | nach Absprache   | E               | Sotheby´s International Realty NRW/Pantera Living Köln GmbH | 50674 | Innenstadt    |
| https://www.immowelt.de/expose/24m2757 | 24m2757 | Vollmöbliertes Apartment für Studenten & Azubis ab 19m² ab 625€                                   | 19         | 1      | 50825 Köln  (Ehrenfeld)     | 50825 | 485       | 140         | 0          | 1455    | 1. Geschoss                |                  | B               | Cube Life GmbH                                              | 50825 | Ehrenfeld     |
| https://www.immowelt.de/expose/2635u5x | 2635u5x | Möblierte Dachgeschoss-Wohnung mit EBK in der Kölner Altstadt!                                    | 105        | 3      | 50667 Köln  (Altstadt-Nord) | 50667 | 3000      | 825         | 0          | 9000    | Dachgeschoss               |                  |                 | Sotheby´s International Realty NRW/Pantera Living Köln GmbH | 50667 | Altstadt/Nord |
| https://www.immowelt.de/expose/274qv5k | 274qv5k | 1-Zi.-Wohnung in Köln - mit Balkon                                                                | 39         | 1      | 51109 Köln  (Neubrück)      | 51109 | 385       | 65          | 75         | 1155    | 1. Geschoss                | 01.01.2024       | B               | Privatanbieter                                              | 51109 | Brück         |
| https://www.immowelt.de/expose/27zr55z | 27zr55z | Moderne, gut geschnittene 3-Zimmer-Wohnung im 2.OG/DG                                             | 60         | 3      | 51107 Köln  (Rath/Heumar)   | 51107 | 660       | 100         | 80         | 1980    | 2. Geschoss (Dachgeschoss) | sofort           |                 | Splinter Hausverwaltung GbR                                 | 51107 | Rath/Heumar   |
| https://www.immowelt.de/expose/2atg35a | 2atg35a | Wohnungsswap - Rolshover Straße                                                                   | 53         | 2      | 51105                       | 51105 | 454       | 0           | 0          | 0       | 1. Geschoss                |                  |                 | Wohnungsswap.de                                             | 51105 | Poll          |
| https://www.immowelt.de/expose/2aah35a | 2aah35a | Wohnungsswap - Humboldtstraße                                                                     | 50         | 2      | 50676                       | 50676 | 590       | 0           | 0          | 0       | 3. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50676 | Altstadt/Süd  |
| https://www.immowelt.de/expose/2acr75a | 2acr75a | Wohnungsswap - Ehrenstraße                                                                        | 40         | 2      | 50672                       | 50672 | 400       | 0           | 0          | 0       | 1. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50672 | Innenstadt    |
| https://www.immowelt.de/expose/2akp85a | 2akp85a | Wohnungsswap - Wildunger Straße                                                                   | 50         | 2      | 51065                       | 51065 | 460       | 0           | 0          | 0       | 2. Geschoss                |                  |                 | Wohnungsswap.de                                             | 51065 | Buchforst     |
| https://www.immowelt.de/expose/2avp85a | 2avp85a | Wohnungsswap - Subbelrather Straße                                                                | 37         | 1      | 50825                       | 50825 | 434       | 0           | 0          | 0       | 3. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50825 | Ehrenfeld     |
| https://www.immowelt.de/expose/2adq85a | 2adq85a | Wohnungsswap - Zollstockgürtel                                                                    | 68         | 3      | 50969                       | 50969 | 1300      | 0           | 0          | 0       | 4. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50969 | Zollstock     |
| https://www.immowelt.de/expose/2a2r85a | 2a2r85a | Wohnungsswap - Große Telegraphenstraße                                                            | 48         | 2      | 50676                       | 50676 | 690       | 0           | 0          | 0       | 3. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50676 | Altstadt/Süd  |
| https://www.immowelt.de/expose/2a6r85a | 2a6r85a | Wohnungsswap - Venloer Straße                                                                     | 67         | 2      | 50827                       | 50827 | 792       | 0           | 0          | 0       | 6. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50827 | Bickendorf    |
| https://www.immowelt.de/expose/2avr85a | 2avr85a | Wohnungsswap - Gottesweg                                                                          | 25         | 1      | 50969                       | 50969 | 391       | 0           | 0          | 0       | 3. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50969 | Zollstock     |
| https://www.immowelt.de/expose/2a9u85a | 2a9u85a | Wohnungsswap - Ehrenstraße                                                                        | 81         | 3,5    | 50672                       | 50672 | 950       | 0           | 0          | 0       | 1. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50672 | Innenstadt    |
| https://www.immowelt.de/expose/2atu85a | 2atu85a | Wohnungsswap - Friesenstraße                                                                      | 68         | 2      | 50670                       | 50670 | 890       | 0           | 0          | 0       | 4. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50670 | Neustadt/Nord |
| https://www.immowelt.de/expose/2a6mh5b | 2a6mh5b | Wohnungsswap - Regentenstraße                                                                     | 50         | 2      | 51063                       | 51063 | 700       | 0           | 0          | 0       | 4. Geschoss                |                  |                 | Wohnungsswap.de                                             | 51063 | Mülheim       |
| https://www.immowelt.de/expose/2aqzh5b | 2aqzh5b | Wohnungsswap - Horbeller Straße                                                                   | 80         | 3      | 50858                       | 50858 | 600       | 0           | 0          | 0       | 1. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50858 | Weiden        |
| https://www.immowelt.de/expose/2aybq5f | 2aybq5f | Wohnungsswap - Rathenauplatz                                                                      | 95         | 3      | 50674                       | 50674 | 1550      | 0           | 0          | 0       | 3. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50674 | Innenstadt    |
| https://www.immowelt.de/expose/2akcq5f | 2akcq5f | Wohnungsswap - Thebäerstraße                                                                      | 58         | 2      | 50823                       | 50823 | 830       | 0           | 0          | 0       | 2. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50823 | Innenstadt    |
| https://www.immowelt.de/expose/2alcq5f | 2alcq5f | Wohnungsswap - Vorgebirgstraße                                                                    | 84         | 3      | 50969                       | 50969 | 1000      | 0           | 0          | 0       | 4. Geschoss                |                  |                 | Wohnungsswap.de                                             | 50969 | Zollstock     |
| ...                                    | ...     | ...                                                                                               | ...        | ...    | ...                         | ...   | ...       | ...         | ...        | ...     | ...                        | ...              | ...             | ...                                                         | ...   | ...           |








































