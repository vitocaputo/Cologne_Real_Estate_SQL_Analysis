# DATA CLEANING

## WOHNUNG_KAUFEN table 
---
### a. Explore the table structure

---
```sql
SELECT *
FROM wohnung_kaufen
```
| link                                   | anzeige                                                                                     | wohnfläche | zimmer | ort                        | kaufpreis | hausgeld | wohnungslage | baujahr | effizienzklasse | makler          |
|----------------------------------------|---------------------------------------------------------------------------------------------|------------|--------|----------------------------|-----------|----------|--------------|---------|-----------------|-----------------|
| https://www.immowelt.de/expose/2uwpa4n | Die perfekte Größe! 2-Zimmer-Wohnung als Kapitalanlage in der Liebigstr. 161-163 - WE 11    | 48         | 2      | 50825 Köln  (Neuehrenfeld) | 279000    | 138      | 3. Geschoss  | 1957    | F               | GLOBAL-ACT GmbH |
| https://www.immowelt.de/expose/2u4yc4n | Mein Veedel !!! 2-Zimmer-Wohnung als Kapitalanlage zu verkaufen - Karolingerring 19, WE 14  | 43         | 2      | 50678 Köln  (Neustadt-Süd) | 265000    |          | 5. Geschoss  | 1959    | E               | GLOBAL-ACT GmbH |
| https://www.immowelt.de/expose/2v4gx4x | Wie für mich gemacht! vermietete 1-Zimmer Wohnung zu verkaufen ( WE 1 )                     | 26         | 1      | 50676 Köln  (Altstadt-Süd) | 169000    | 142      | Erdgeschoss  | 2018    | C               | GLOBAL-ACT GmbH |
| https://www.immowelt.de/expose/2w8ck4q | Die perfekte Größe! vermiete 2-Zimmer-Wohnung in der Liebigstr. 161-163 zu verkaufen! WE 15 | 41         | 2      | 50823 Köln  (Neuehrenfeld) | 249000    | 124      | 3. Geschoss  | 2020    | E               | GLOBAL-ACT GmbH |
| https://www.immowelt.de/expose/2yr7j4f | FRESH, HIP UND BUNT - Kapitalanlage- Hansemannstr. 16, Köln-Ehrenfeld WE 1                  | 26         | 2      | 50823 Köln  (Ehrenfeld)    | 169000    | 157      | 1. Geschoss  | 1950    | C               | GLOBAL-ACT GmbH |

```sql
-- Number of ads for apartments in sale 

SELECT count(anzeige) as num_ads
FROM wohnung_kaufen
```
| num_ads |
|---------|
| 752     |

---

### b. Manage duplicates

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
        wohnung_kaufen) 
    dupl;
```
| total_ads | unique_ads | potential_duplicates |
|-----------|------------|----------------------|
| 752       | 705        | 47                   |

```sql
-- Insered the column with ref_num

ALTER TABLE wohnung_kaufen
ADD COLUMN ref_num VARCHAR(255);
```
```sql
UPDATE wohnung_kaufen
SET ref_num = SUBSTRING(link, LENGTH('https://www.immowelt.de/expose/') + 1);
```
```sql
ALTER TABLE "immo_köln"."wohnung_kaufen" 
CHANGE COLUMN "ref_num" "ref_num" VARCHAR(255) NULL DEFAULT NULL AFTER "link";
```
```sql
-- it seems to be that 47 ads are duplicates, tried to understand if these are all to remove

SELECT *
FROM wohnung_kaufen
WHERE anzeige IN (
    SELECT anzeige
    FROM wohnung_kaufen
    GROUP BY anzeige
    HAVING COUNT(*) > 1
)
ORDER BY anzeige ASC;
```
| link                                   | ref_num | anzeige                                                                                                                                               | wohnfläche | zimmer   | ort                         | kaufpreis | hausgeld | wohnungslage | baujahr | effizienzklasse | makler                                                |
|----------------------------------------|---------|-------------------------------------------------------------------------------------------------------------------------------------------------------|------------|----------|-----------------------------|-----------|----------|--------------|---------|-----------------|-------------------------------------------------------|
| https://www.immowelt.de/expose/2c6j75d | 2c6j75d | **Wohnkomfort wie nie zuvor**                                                                                                                         | 70         | 3        | 50735 Köln  (Niehl)         | 329000    |          |              |         |                 |                                                       |
| https://www.immowelt.de/expose/2ccw659 | 2ccw659 | **Wohnkomfort wie nie zuvor**                                                                                                                         | 96         | 3        | 50858 Köln  (Junkersdorf)   | 735000    |          |              |         | B               |                                                       |
| https://www.immowelt.de/expose/2bv7l5p | 2bv7l5p | *Offene Beratung am So., den 12.11. von 12:00-12:30 Uhr, Georg-Zapf-Straße 2a in 51061 Köln*                                                          | 59         | 2        | 51061 Köln  (Flittard)      | 339900    | 5742     | Erdgeschoss  | 2024    | A+              | CLOUDBERRY Real Estate GmbH                           |
| https://www.immowelt.de/expose/2by7l5p | 2by7l5p | *Offene Beratung am So., den 12.11. von 12:00-12:30 Uhr, Georg-Zapf-Straße 2a in 51061 Köln*                                                          | 58         | 2        | 51061 Köln  (Flittard)      | 336900    | 5849     | Erdgeschoss  | 2024    | A+              | CLOUDBERRY Real Estate GmbH                           |
| https://www.immowelt.de/expose/2bu8l5p | 2bu8l5p | *Offene Beratung am So., den 12.11. von 12:00-12:30 Uhr, Georg-Zapf-Straße 2a in 51061 Köln*                                                          | 56         | 2        | 51061 Köln  (Flittard)      | 336900    | 6027     | 1. Geschoss  | 2024    | A+              | CLOUDBERRY Real Estate GmbH                           |
| https://www.immowelt.de/expose/2bx9l5p | 2bx9l5p | *Offene Beratung am So., den 12.11. von 12:00-12:30 Uhr, Georg-Zapf-Straße 2a in 51061 Köln*                                                          | 78         | 4        | 51061 Köln  (Flittard)      | 469900    | 6017     | 1. Geschoss  | 2024    | A+              | CLOUDBERRY Real Estate GmbH                           |
| https://www.immowelt.de/expose/2cmqt5c | 2cmqt5c | + 2-Zimmer-Wohnung mit Terrasse +                                                                                                                     | 65         | 2        | 51149 Köln  (Westhoven)     | 180000    |          |              |         |                 |                                                       |
| https://www.immowelt.de/expose/2cmhx5c | 2cmhx5c | + 2-Zimmer-Wohnung mit Terrasse +                                                                                                                     | 65         | 2        | 51149 Köln  (Westhoven)     | 180000    |          |              |         |                 | AZ Agentur für Zwangsversteigerungsinformationen GmbH |
| https://www.immowelt.de/expose/2c6wt5c | 2c6wt5c | + 3-Zimmer-Wohnung mit TG-Stellplatz +                                                                                                                | 95         | 3        | 50999 Köln  (Sürth)         | 404000    |          |              |         |                 |                                                       |
| https://www.immowelt.de/expose/2cbhx5c | 2cbhx5c | + 3-Zimmer-Wohnung mit TG-Stellplatz +                                                                                                                | 95         | 3        | 50999 Köln  (Sürth)         | 404000    |          |              |         |                 | AZ Agentur für Zwangsversteigerungsinformationen GmbH |
| https://www.immowelt.de/expose/2cbmt5c | 2cbmt5c | 2-Zimmer-Wohnung + provisionsfrei +                                                                                                                   | 42         | 2        | 50823 Köln  (Neuehrenfeld)  | 140000    |          |              |         |                 |                                                       |
| https://www.immowelt.de/expose/2c5hx5c | 2c5hx5c | 2-Zimmer-Wohnung + provisionsfrei +                                                                                                                   | 42         | 2        | 50823 Köln  (Neuehrenfeld)  | 140000    |          |              |         |                 | AZ Agentur für Zwangsversteigerungsinformationen GmbH |
| https://www.immowelt.de/expose/2bwsn56 | 2bwsn56 | 3 Zimmer Wohnung mit Loggia in Köln-Weidenpesch OHNE KÄUFERPROVISION                                                                                  | 79         | 3        | 50737 Köln  (Weidenpesch)   | 232000    | 2937     | 5. Geschoss  | 1974    | E               | Vonovia SE-Selbstständiger Vertriebspartner           |
| https://www.immowelt.de/expose/2bxsn56 | 2bxsn56 | 3 Zimmer Wohnung mit Loggia in Köln-Weidenpesch OHNE KÄUFERPROVISION                                                                                  | 79         | 3        | 50737 Köln  (Weidenpesch)   | 232000    | 2937     | 8. Geschoss  | 1974    | E               | Vonovia SE-Selbstständiger Vertriebspartner           |
| https://www.immowelt.de/expose/2cxut5c | 2cxut5c | 3-Zimmer-Wohnung - provisionsfrei                                                                                                                     | 72         | 3        | 51063 Köln  (Mülheim)       | 205000    |          | Dachgeschoss |         |                 |                                                       |
| https://www.immowelt.de/expose/2cchx5c | 2cchx5c | 3-Zimmer-Wohnung - provisionsfrei                                                                                                                     | 72         | 3        | 51063 Köln  (Mülheim)       | 205000    |          | Dachgeschoss |         |                 | AZ Agentur für Zwangsversteigerungsinformationen GmbH |
| https://www.immowelt.de/expose/2crqt5c | 2crqt5c | 3-Zimmer-Wohnung mit Balkon + provisionsfrei +                                                                                                        | 62         | 3        | 51147 Köln  (Grengel)       | 190000    |          |              |         |                 |                                                       |
| https://www.immowelt.de/expose/2ckhx5c | 2ckhx5c | 3-Zimmer-Wohnung mit Balkon + provisionsfrei +                                                                                                        | 62         | 3        | 51147 Köln  (Grengel)       | 190000    |          |              |         |                 | AZ Agentur für Zwangsversteigerungsinformationen GmbH |
| https://www.immowelt.de/expose/2cdyt5c | 2cdyt5c | 4-Zimmer-Wohnung mit Garten und Garage + provisionsfrei +                                                                                             | 156        | 4        | 50935 Köln  (Lindenthal)    | 1285000   |          | Erdgeschoss  |         |                 |                                                       |
| https://www.immowelt.de/expose/2c8hx5c | 2c8hx5c | 4-Zimmer-Wohnung mit Garten und Garage + provisionsfrei +                                                                                             | 156        | 4        | 50935 Köln  (Lindenthal)    | 1285000   |          | Erdgeschoss  |         |                 | AZ Agentur für Zwangsversteigerungsinformationen GmbH |
| https://www.immowelt.de/expose/2c8tt5c | 2c8tt5c | 5-Zimmer-Wohnung mit Loggia + provisionsfrei +                                                                                                        | 90         | 5        | 51149 Köln  (Porz)          | 225000    |          |              |         |                 |                                                       |
| https://www.immowelt.de/expose/2cnhx5c | 2cnhx5c | 5-Zimmer-Wohnung mit Loggia + provisionsfrei +                                                                                                        | 90         | 5        | 51149 Köln  (Porz)          | 225000    |          |              |         |                 | AZ Agentur für Zwangsversteigerungsinformationen GmbH |
| https://www.immowelt.de/expose/2bt6c56 | 2bt6c56 | Barrierefreie Eigentumswohnung für die ganze Familie mit großem Bad und Loggia                                                                        | 102        | 4        | 50737 Köln  (Weidenpesch)   | 569000    |          | 3. Geschoss  | 2023    |                 | Bonava Deutschland GmbH                               |
| https://www.immowelt.de/expose/2b9fb5r | 2b9fb5r | Barrierefreie Eigentumswohnung für die ganze Familie mit großem Bad und Loggia                                                                        | 90         | 4        | 50737 Köln  (Weidenpesch)   | 529000    |          | 2. Geschoss  | 2023    |                 | Bonava Deutschland GmbH                               |
| https://www.immowelt.de/expose/2bbq956 | 2bbq956 | Barrierefreie Eigentumswohnung mit offenem Wohn- und Küchenbereich sowie Loggia                                                                       | 75         | 3        | 50737 Köln  (Weidenpesch)   | 429000    |          | 1. Geschoss  | 2023    |                 | Bonava Deutschland GmbH                               |
| https://www.immowelt.de/expose/2bss956 | 2bss956 | Barrierefreie Eigentumswohnung mit offenem Wohn- und Küchenbereich sowie Loggia                                                                       | 79         | 3        | 50737 Köln  (Weidenpesch)   | 459000    |          | 2. Geschoss  | 2023    |                 | Bonava Deutschland GmbH                               |
| https://www.immowelt.de/expose/2b25a56 | 2b25a56 | Barrierefreie Eigentumswohnung mit offenem Wohn- und Küchenbereich sowie Loggia                                                                       | 79         | 3        | 50737 Köln  (Weidenpesch)   | 489000    |          | 3. Geschoss  | 2023    |                 | Bonava Deutschland GmbH                               |
| https://www.immowelt.de/expose/2c3gy5d | 2c3gy5d | Dachgeschosswohnung in 51063 Köln, Berliner Str.                                                                                                      | 72         | 3        | 51063 Köln  (Mülheim)       | 205000    |          | Erdgeschoss  | 1920    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cacs5d | 2cacs5d | Dachgeschosswohnung in 51063 Köln, Berliner Str.                                                                                                      | 72         | 3        | 51063 Köln  (Mülheim)       | 205000    |          | Erdgeschoss  | 1920    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2bvqz5t | 2bvqz5t | Doppeltes Glück: 2 Bäder & 4 Zimmer, Gartenhaus und Riesenkeller, STP                                                                                 | 82         | 4        | 51143 Köln  (Zündorf)       | 254000    | 390      | 1. Geschoss  | 1968    | F               | Immobiehler e.K.                                      |
| https://www.immowelt.de/expose/2bsl35u | 2bsl35u | Doppeltes Glück: 2 Bäder & 4 Zimmer, Gartenhaus und Riesenkeller, STP                                                                                 | 82         | 4        | 51143 Köln  (Zündorf)       | 254000    | 390      | 1. Geschoss  | 1968    | F               | Immobiehler e.K.                                      |
| https://www.immowelt.de/expose/2bvgu5t | 2bvgu5t | Eigentumswohnung in 51149 Köln                                                                                                                        | 90         |   k.A.   | 51149 Köln  (Porz)          | 225000    |          |              |         |                 | Dein-ImmoCenter                                       |
| https://www.immowelt.de/expose/2b6sa5p | 2b6sa5p | Eigentumswohnung in 51149 Köln                                                                                                                        | 65         |   k.A.   | 51149 Köln  (Westhoven)     | 180000    |          |              |         |                 | Dein-ImmoCenter                                       |
| https://www.immowelt.de/expose/2ctqt5c | 2ctqt5c | Einfamilien-Doppelhaushälfte mit Terrasse                                                                                                             | 122        | 4        | 51069 Köln  (Dellbrück)     | 560000    |          |              |         |                 |                                                       |
| https://www.immowelt.de/expose/2cehx5c | 2cehx5c | Einfamilien-Doppelhaushälfte mit Terrasse                                                                                                             | 122        | 4        | 51069 Köln  (Dellbrück)     | 560000    |          |              |         |                 | AZ Agentur für Zwangsversteigerungsinformationen GmbH |
| https://www.immowelt.de/expose/2c37q5b | 2c37q5b | Erdgeschosswohnung in 50935 Köln, Viktor-Schnitzler-Str.                                                                                              | 156        | 4        | 50935 Köln  (Lindenthal)    | 1285000   |          | Erdgeschoss  | 1953    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cnsr5b | 2cnsr5b | Erdgeschosswohnung in 50935 Köln, Viktor-Schnitzler-Str.                                                                                              | 156        | 4        | 50935 Köln  (Lindenthal)    | 1285000   |          | Erdgeschoss  | 1953    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cv775c | 2cv775c | Etagenwohnung in 50735 Köln, An der Schanz                                                                                                            | 82         | 3        | 50735 Köln  (Riehl)         | 145000    |          | 10. Geschoss |         |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cdx95c | 2cdx95c | Etagenwohnung in 50735 Köln, An der Schanz                                                                                                            | 82         | 3        | 50735 Köln  (Riehl)         | 145000    |          | 10. Geschoss |         |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2c8xj5a | 2c8xj5a | Etagenwohnung in 50823 Köln, Graeffstr.                                                                                                               | 42         | 2        | 50823 Köln  (Neuehrenfeld)  | 140000    |          | 30. Geschoss | 1973    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cb6c5a | 2cb6c5a | Etagenwohnung in 50823 Köln, Graeffstr.                                                                                                               | 42         | 2        | 50823 Köln  (Neuehrenfeld)  | 140000    |          | 30. Geschoss | 1973    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2c8k25d | 2c8k25d | Etagenwohnung in 50933 Köln, Voigtelstr.                                                                                                              | 143        | 3        | 50933 Köln  (Braunsfeld)    | 949000    |          | 3. Geschoss  |         |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2c3f85d | 2c3f85d | Etagenwohnung in 50933 Köln, Voigtelstr.                                                                                                              | 143        | 3        | 50933 Köln  (Braunsfeld)    | 949000    |          | 3. Geschoss  |         |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cbnt59 | 2cbnt59 | Etagenwohnung in 50999 Köln, Sürther Hauptstr.                                                                                                        | 95         | 3        | 50999 Köln  (Sürth)         | 404000    |          | 1. Geschoss  | 1997    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cy6z59 | 2cy6z59 | Etagenwohnung in 50999 Köln, Sürther Hauptstr.                                                                                                        | 95         | 3        | 50999 Köln  (Sürth)         | 404000    |          | 1. Geschoss  | 1997    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cr6g5c | 2cr6g5c | Etagenwohnung in 51147 Köln, Akazienweg                                                                                                               | 62         | 3        | 51147 Köln  (Grengel)       | 190000    |          | 2. Geschoss  | 1972    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cyum5c | 2cyum5c | Etagenwohnung in 51147 Köln, Akazienweg                                                                                                               | 62         | 3        | 51147 Köln  (Grengel)       | 190000    |          | 2. Geschoss  | 1972    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2crf75c | 2crf75c | Etagenwohnung in 51149 Köln, Konrad-Adenauer-Str.                                                                                                     | 90         | 5        | 51149 Köln  (Porz)          | 225000    |          | 3. Geschoss  | 1969    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cp8a5c | 2cp8a5c | Etagenwohnung in 51149 Köln, Konrad-Adenauer-Str.                                                                                                     | 90         | 5        | 51149 Köln  (Porz)          | 225000    |          | 3. Geschoss  | 1969    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2cjma5c | 2cjma5c | Etagenwohnung in 51149 Köln, Nikolausstr.                                                                                                             | 65         | 3        | 51149 Köln  (Westhoven)     | 180000    |          | 1. Geschoss  | 1974    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2chkg5c | 2chkg5c | Etagenwohnung in 51149 Köln, Nikolausstr.                                                                                                             | 65         | 3        | 51149 Köln  (Westhoven)     | 180000    |          | 1. Geschoss  | 1974    |                 | Argetra GmbH                                          |
| https://www.immowelt.de/expose/2csqt5c | 2csqt5c | Große 3-Zimmer-Wohnung mit Balkon und Garage + provisionsfrei +                                                                                       | 143        | 3        | 50933 Köln  (Braunsfeld)    | 949000    |          |              |         |                 |                                                       |
| https://www.immowelt.de/expose/2c7hx5c | 2c7hx5c | Große 3-Zimmer-Wohnung mit Balkon und Garage + provisionsfrei +                                                                                       | 143        | 3        | 50933 Köln  (Braunsfeld)    | 949000    |          |              |         |                 | AZ Agentur für Zwangsversteigerungsinformationen GmbH |
| https://www.immowelt.de/expose/2z7k64d | 2z7k64d | KÖLN-LIVE- Kapitalanlage im Mauritiuswall 33! ( WE 8 )                                                                                                | 62         | 3        | 50676 Köln  (Altstadt-Süd)  | 403260    | 225      | 3. Geschoss  | 2020    | D               | GLOBAL-ACT GmbH                                       |
| https://www.immowelt.de/expose/272pz5f | 272pz5f | KÖLN-LIVE- Kapitalanlage im Mauritiuswall 33! ( WE 8 )                                                                                                | 62         | 3        | 50676 Köln  (Altstadt-Süd)  | 403260    |          | 3. Geschoss  | 1966    |                 | GLOBAL-ACT GmbH                                       |
| https://www.immowelt.de/expose/29ck65m | 29ck65m | meine.liebe - von Herzen Wohnen in Porz/Zündorf                                                                                                       | 107        | 3        | 51143 Köln  (Zündorf)       | 369000    | 3440     |              |         | D               | Volksbank Rhein - Erft - Köln eG                      |
| https://www.immowelt.de/expose/2afl353 | 2afl353 | meine.liebe - von Herzen Wohnen in Porz/Zündorf                                                                                                       | 32         | 1        | 51143 Köln  (Zündorf)       | 119000    | 3665     |              |         | E               | Volksbank Rhein - Erft - Köln eG                      |
| https://www.immowelt.de/expose/2abl353 | 2abl353 | meine.liebe - von Herzen Wohnen in Porz/Zündorf                                                                                                       | 87         | 3        | 51143 Köln  (Zündorf)       | 339000    | 3892     |              |         | E               | Volksbank Rhein - Erft - Köln eG                      |
| https://www.immowelt.de/expose/2ael353 | 2ael353 | meine.liebe - von Herzen Wohnen in Porz/Zündorf                                                                                                       | 85         | 3        | 51143 Köln  (Zündorf)       | 299000    | 3533     |              |         | E               | Volksbank Rhein - Erft - Köln eG                      |
| https://www.immowelt.de/expose/2acl353 | 2acl353 | meine.liebe - von Herzen Wohnen in Porz/Zündorf                                                                                                       | 49         | 2        | 51143 Köln  (Zündorf)       | 179000    | 3678     |              |         | E               | Volksbank Rhein - Erft - Köln eG                      |
| https://www.immowelt.de/expose/29mk65m | 29mk65m | meine.liebe - von Herzen Wohnen in Porz/Zündorf                                                                                                       | 93         | 2        | 51143 Köln  (Zündorf)       | 359000    | 3874     |              |         | D               | Volksbank Rhein - Erft - Köln eG                      |
| https://www.immowelt.de/expose/29kk65m | 29kk65m | meine.liebe - von Herzen Wohnen in Porz/Zündorf                                                                                                       | 127        | 3        | 51143 Köln  (Zündorf)       | 469000    | 3702     |              |         | D               | Volksbank Rhein - Erft - Köln eG                      |
| https://www.immowelt.de/expose/2ahl353 | 2ahl353 | meine.liebe - von Herzen Wohnen in Porz/Zündorf                                                                                                       | 94         | 4        | 51143 Köln  (Zündorf)       | 359000    | 3815     |              |         | E               | Volksbank Rhein - Erft - Köln eG                      |
| https://www.immowelt.de/expose/293k65m | 293k65m | meine.liebe - von Herzen Wohnen in Porz/Zündorf                                                                                                       | 171        | 4        | 51143 Köln  (Zündorf)       | 599000    | 3493     |              |         | D               | Volksbank Rhein - Erft - Köln eG                      |
| https://www.immowelt.de/expose/2bzwb56 | 2bzwb56 | Moderne, barrierefreie Eigentumswohnung mit großer Dachterrasse im Simonsveedel                                                                       | 45         | 2        | 50737 Köln  (Weidenpesch)   | 299000    |          | 2. Geschoss  | 2023    |                 | Bonava Deutschland GmbH                               |
| https://www.immowelt.de/expose/2badc56 | 2badc56 | Moderne, barrierefreie Eigentumswohnung mit großer Dachterrasse im Simonsveedel                                                                       | 77         | 3        | 50737 Köln  (Weidenpesch)   | 479000    |          | 3. Geschoss  | 2023    |                 | Bonava Deutschland GmbH                               |
| https://www.immowelt.de/expose/27rwz5f | 27rwz5f | Natürlich Köln- 3-Zimmer-Wohnung als KAPITALANLAGE zu verkaufen! WE 1                                                                                 | 67         | 3        | 50827 Köln  (Bickendorf)    | 366410    | 281      | 1. Geschoss  | 1966    |                 | GLOBAL-ACT GmbH                                       |
| https://www.immowelt.de/expose/29q6856 | 29q6856 | Natürlich Köln- 3-Zimmer-Wohnung als KAPITALANLAGE zu verkaufen! WE 1                                                                                 | 67         | 3        | 50827 Köln  (Bickendorf)    | 366410    | 281      |              | 1966    | E               | GLOBAL-ACT GmbH                                       |
| https://www.immowelt.de/expose/2c8t45c | 2c8t45c | Privatverkauf: Renditeobjekt aus Eigenbestand, Provision frei; vermietete 4-Zimmer-Eigentumswohnung mit gr. Loggia, Garage, Pkw-Stplz in Köln-Ostheim | 83         | 4        | 51107 Köln  (Ostheim)       | 284000    | 478      | 5. Geschoss  | 1974    | F               | Pars Immobilien Cologne                               |
| https://www.immowelt.de/expose/2cylx5d | 2cylx5d | Privatverkauf: Renditeobjekt aus Eigenbestand, Provision frei; vermietete 4-Zimmer-Eigentumswohnung mit gr. Loggia, Garage, Pkw-Stplz in Köln-Ostheim | 83         | 4        | 51107 Köln  (Ostheim)       | 284000    | 478      | 5. Geschoss  | 1974    | F               | Pars Immobilien Cologne                               |
| https://www.immowelt.de/expose/2bxct5z | 2bxct5z | RATHENAUPLATZ / KWARTIER LATÄNG -- MITTEN IM VEEDEL: 3 - Zimmerwohnung mit Balkon                                                                     | 92         | 3        | 50672 Köln  (Neustadt-Nord) | 430000    | 249      | 2. Geschoss  | 1900    | B               | MERZENICH Immobilien GmbH                             |
| https://www.immowelt.de/expose/2bvbt5z | 2bvbt5z | RATHENAUPLATZ / KWARTIER LATÄNG -- MITTEN IM VEEDEL: 3 - Zimmerwohnung mit Balkon                                                                     | 92         | 3        | 50672 Köln  (Neustadt-Nord) | 430000    | 249      | 2. Geschoss  | 1900    | B               | MERZENICH Immobilien GmbH                             |
| https://www.immowelt.de/expose/27j255h | 27j255h | Riehler Ruheterrasse am Zoo!                                                                                                                          | 88         | 3        | 50735 Köln / Riehl          | 409000    | 140      |              |         | C               | Immobiehler e.K.                                      |
| https://www.immowelt.de/expose/27kgl5k | 27kgl5k | Riehler Ruheterrasse am Zoo!                                                                                                                          | 88         | 3        | 50735 Köln / Riehl          | 409000    | 140      |              |         | C               | Immobiehler e.K.                                      |
| https://www.immowelt.de/expose/2cvnf57 | 2cvnf57 | Strahlende Oase: Begehrt in der Altstadt-Süd mit Stellplatz                                                                                           | 26         | 1        | 50678 Köln  (Altstadt-Süd)  | 169000    | 152      |              |         |                 | Immobiehler e.K.                                      |
| https://www.immowelt.de/expose/2crmf57 | 2crmf57 | Strahlende Oase: Begehrt in der Altstadt-Süd mit Stellplatz                                                                                           | 26         | 1        | 50678 Köln  (Altstadt-Süd)  | 169000    | 152      |              |         |                 | Immobiehler e.K.                                      |
| https://www.immowelt.de/expose/295eq5h | 295eq5h | vermietete Wohnung mit Balkon - provisionsfrei                                                                                                        | 57         | 2        | 51149 Köln  (Gremberghoven) | 167100    | 394      | 2. Geschoss  | 1957    | E               | Vonovia SE-Selbstständiger Vertriebspartner           |
| https://www.immowelt.de/expose/2bem756 | 2bem756 | vermietete Wohnung mit Balkon - provisionsfrei                                                                                                        | 60         | 2        | 51103 Köln  (Höhenberg)     | 150000    | 380      | 3. Geschoss  | 1966    | F               | Vonovia SE-Selbstständiger Vertriebspartner           |
| https://www.immowelt.de/expose/2blmz5j | 2blmz5j | vermietete Wohnung mit Balkon - provisionsfrei                                                                                                        | 66         | 2        | 51065 Köln  (Mülheim)       | 179000    | 330      | Erdgeschoss  | 1963    | C               | Vonovia SE-Selbstständiger Vertriebspartner           |
| https://www.immowelt.de/expose/2c6qs5c | 2c6qs5c | vermietete Wohnung mit Balkon - provisionsfrei                                                                                                        | 40         | 2        | 50823 Köln  (Neuehrenfeld)  | 150000    | 2019     | Erdgeschoss  | 1953    | A+              | Vonovia SE-Selbstständiger Vertriebspartner           |
| https://www.immowelt.de/expose/2b6xl5d | 2b6xl5d | Vermietetes Apartement mit Stellplatz!                                                                                                                | 33         | 1        | 50737 Köln  (Longerich)     | 114800    | 80       | 1. Geschoss  | 1967    | D               | S Immobilienpartner GmbH                              |
| https://www.immowelt.de/expose/2b5xl5d | 2b5xl5d | Vermietetes Apartement mit Stellplatz!                                                                                                                | 33         | 1        | 50737 Köln  (Longerich)     | 118800    | 75       | Erdgeschoss  | 1967    | D               | S Immobilienpartner GmbH                              |

```sql
-- Not all the duplicates are to remove. Some have the same title but are a part of a build with different apartments.
-- They have different living area, price or floor

DELETE FROM wohnung_kaufen
WHERE ref_num IN("2cmqt5c", "2c6wt5c", "2cbmt5c", "2cxut5c",
                "2crqt5c", "2cdyt5c", "2c8tt5c", "2c3gy5d",
                "2bsl35u", "2ctqt5c", "2cnsr5b", "2cv775c",
                "2c8xj5a", "2c8k25d", "2cbnt59", "2cr6g5c",
                "2crf75c", "2cjma5c", "2csqt5c", "272pz5f",
                "29q6856", "2c8t45c", "2bxct5z", "27j255h", "2cvnf57")
```






































































































