# Data cleaning
### "Haus_mieten" Table
---
Insert the ref_num column
```sql
ALTER TABLE haus_mieten
ADD COLUMN ref_num VARCHAR(255);
```
```sql
UPDATE haus_mieten
SET ref_num = SUBSTRING(link, LENGTH('https://www.immowelt.de/expose/') + 1);
```
```sql
SELECT *
FROM haus_mieten
```
| link                                   | ref_num | anzeige                                                                                      | wohnfläche | zimmer | grundstück | ort                              | kaltmiete | nebenkosten | heizkosten | kaution | wohnungslage     | effizienzklasse | makler                                                  |
|----------------------------------------|---------|----------------------------------------------------------------------------------------------|------------|--------|------------|----------------------------------|-----------|-------------|------------|---------|------------------|-----------------|---------------------------------------------------------|
| https://www.immowelt.de/expose/2cssw5d | 2cssw5d | Doppelhaushälfte in 51469 GL . Angrenzung Köln Dellbrück                                     | 140        | 4      | 325        | 51469 Bergisch-Gladbach/Delbrück | 2240      | 290         |            | 5850    | Doppelhaushälfte | A+              | ohne-makler.net - Immobilien selbst vermarkten          |
| https://www.immowelt.de/expose/2bh425q | 2bh425q | Saniertes Haus mit Flair in zentraler Lage in Köln - Zündorf                                 | 87         | 4      | 130        | 51143 Köln                       | 1300      | 200         |            | 3000    | Einfamilienhaus  | F               | Immobilien Bernd Minkley                                |
| https://www.immowelt.de/expose/2bmck5d | 2bmck5d | Herrenhaus kernsaniert mit schönem Garten in Köln Dünnwald!!!                                | 240        | 6      | 870        | 51069 Köln                       | 3240      | 200         | 3440       | 9720    | Einfamilienhaus  |                 | Krupp Immobilien                                        |
| https://www.immowelt.de/expose/2b9tz5v | 2b9tz5v | renoviertes EFH mit Wohnkomfort und Garten im Kölner Norden                                  | 130        | 7      | 860        | 50737 Köln                       | 2650      | 250         | 2900       | 5200    | Einfamilienhaus  | B               |                                                         |
| https://www.immowelt.de/expose/2acxp5s | 2acxp5s | Erstbezug: NINE HOMES - Familienleben auf 144 m² plus E-Mobilität-Stadthäuser in Klettenberg | 144        | 6      | 169        | 50939 Köln                       | 4250      | 500         |            | 12750   | Stadthaus        | B               | INTERHOUSE Immobilienvermittlungs- und Verwaltungs GmbH |
| https://www.immowelt.de/expose/2adan5e | 2adan5e | Neubau Erstbezug: energieeffizientes Einfamilienhaus mit Garten                              | 125        | 4      | 140        | 51061 Köln                       | 2000      | 295         |            | 6000    | Reihenmittelhaus | B               | Bay Immobilien                                          |
| https://www.immowelt.de/expose/2cvhv5a | 2cvhv5a | Modernes Stadthaus, BJ 2007 im Herzen von Ehrenfeld, Wallbox                                 | 161        | 4      | 148        | 50823 Köln                       | 2700      | 200         | 135        | 8100    | Einfamilienhaus  | B               |                                                         |

```sql
SELECT count(anzeige) AS n_ads
FROM haus_mieten
```
| n_ads |
|-------|
| 7     |

The values in "heizkosten" for two of the ads are the sum of listing rent and accessories costs. 
For this reason provided to cancel the values for the ads "2bmck5d" and "2b9tz5v"
```sql
UPDATE haus_mieten
SET heizkosten = 0
WHERE ref_num IN("2bmck5d", "2b9tz5v")
```
```sql
UPDATE haus_mieten
SET heizkosten = 0
WHERE heizkosten = ""
```
```sql
-- Set as private offer where the column "makler" is null

UPDATE haus_mieten
SET makler = "Privatanbieter"
WHERE makler = ""
```
```sql
-- Added the column of postal code

ALTER TABLE haus_mieten
ADD COLUMN plz VARCHAR(255)

UPDATE haus_mieten
SET plz = TRIM(SUBSTRING_INDEX(ort, ' ', 1))
```

```sql
-- Joined the table to obtain the neighborhood information

SELECT hm.ref_num,
        hm.anzeige,
        hm.wohnfläche,
        hm.zimmer,
        hm.grundstück,
        hm.plz,
        pl.stadtteil,
        hm.kaltmiete,
        hm.nebenkosten,
        hm.heizkosten,
        hm.kaution,
        hm.wohnungslage,
        hm.effizienzklasse,
        hm.makler
FROM haus_mieten as hm
LEFT JOIN plz_koeln as pl 
ON hm.plz = pl.plz
GROUP BY hm.ref_num,
        hm.anzeige,
        hm.wohnfläche,
        hm.zimmer,
        hm.grundstück,
        hm.plz,
        pl.stadtteil,
        hm.kaltmiete,
        hm.nebenkosten,
        hm.heizkosten,
        hm.kaution,
        hm.wohnungslage,
        hm.effizienzklasse,
        hm.makler
```

| ref_num | anzeige                                                                                      | wohnfläche | zimmer | grundstück | plz   | stadtteil   | kaltmiete | nebenkosten | heizkosten | kaution | wohnungslage     | effizienzklasse | makler                                                  |
|---------|----------------------------------------------------------------------------------------------|------------|--------|------------|-------|-------------|-----------|-------------|------------|---------|------------------|-----------------|---------------------------------------------------------|
| 2cssw5d | Doppelhaushälfte in 51469 GL . Angrenzung Köln Dellbrück                                     | 140        | 4      | 325        | 51469 | null        | 2240      | 290         |            | 5850    | Doppelhaushälfte | A+              | ohne-makler.net - Immobilien selbst vermarkten          |
| 2bh425q | Saniertes Haus mit Flair in zentraler Lage in Köln - Zündorf                                 | 87         | 4      | 130        | 51143 | Porz        | 1300      | 200         |            | 3000    | Einfamilienhaus  | F               | Immobilien Bernd Minkley                                |
| 2bmck5d | Herrenhaus kernsaniert mit schönem Garten in Köln Dünnwald!!!                                | 240        | 6      | 870        | 51069 | Dünnwald    | 3240      | 200         | 0          | 9720    | Einfamilienhaus  |                 | Krupp Immobilien                                        |
| 2b9tz5v | renoviertes EFH mit Wohnkomfort und Garten im Kölner Norden                                  | 130        | 7      | 860        | 50737 | Weidenpesch | 2650      | 250         | 0          | 5200    | Einfamilienhaus  | B               | Privatanbieter                                          |
| 2acxp5s | Erstbezug: NINE HOMES - Familienleben auf 144 m² plus E-Mobilität-Stadthäuser in Klettenberg | 144        | 6      | 169        | 50939 | Klettenberg | 4250      | 500         |            | 12750   | Stadthaus        | B               | INTERHOUSE Immobilienvermittlungs- und Verwaltungs GmbH |
| 2adan5e | Neubau Erstbezug: energieeffizientes Einfamilienhaus mit Garten                              | 125        | 4      | 140        | 51061 | Stammheim   | 2000      | 295         |            | 6000    | Reihenmittelhaus | B               | Bay Immobilien                                          |
| 2cvhv5a | Modernes Stadthaus, BJ 2007 im Herzen von Ehrenfeld, Wallbox                                 | 161        | 4      | 148        | 50823 | Innenstadt  | 2700      | 200         | 135        | 8100    | Einfamilienhaus  | B               | Privatanbieter                                          |




