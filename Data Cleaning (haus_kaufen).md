# DATA CLEANING

## HAUS_KAUFEN table 

### a. Explore the table structure
---
```sql
SELECT *
FROM haus_kaufen
```

| link                                   | anzeige                                                                        | wohnfläche | zimmer | grundstück | ort                     | kaufpreis | kategorie        | makler                                                          | baujahr | effizienzklasse |
|----------------------------------------|--------------------------------------------------------------------------------|------------|--------|------------|-------------------------|-----------|------------------|-----------------------------------------------------------------|---------|-----------------|
| https://www.immowelt.de/expose/2qxg74e | - NRW- Mehrfamilienhäuser im Paket (Top Investment)-                           |            |        |            | 50667 Köln              | 4.350.000 | Mehrfamilienhaus | Muzi-Berlin Immobilien & Finanzdienst e. K.-seit 1992           | 1900    |                 |
| https://www.immowelt.de/expose/22ft55u | Großes Reihenendhaus mit Zinszuschuss und Bezugsfertigkeit noch in diesem Jahr | 160        | 4      | 295        | 51145 Köln              | 669.990   | Reihenendhaus    | INTERHOMES AG                                                   |         | A+              |
| https://www.immowelt.de/expose/24aqr5x | Früher an später denken!                                                       | 180        | 5      | 242        | 50997 Köln / Meschenich | 499.000   | Reihenendhaus    | FALC Immobilien GmbH & Co. KG                                   | 2002    |                 |
| https://www.immowelt.de/expose/258cc53 | Vermietetes Reihenmittelhaus in ruhiger Lage                                   | 91         | 4      | 197        | 51067 Köln              | 434.000   | Reihenmittelhaus | VON POLL IMMOBILIEN Köln-Dellbrück - Anna Sodki Immobilien GmbH | 1963    | G               |
| https://www.immowelt.de/expose/25eyv5u | CGN Köln Mehrfamilienhaus                                                      | 764        | 25     | 562        | 50670 Köln              | 3.165.000 | Mehrfamilienhaus |                                                                 |         |                 |
---

### b. Manage duplicates

---
```sql
-- Number of ads for houses in sale, seeing if ther are duplicate ads

SELECT 
    total_ads,
    unique_ads,
    total_ads - unique_ads as potential_duplicates
FROM (
    SELECT 
        COUNT(anzeige) as total_ads,
        COUNT(DISTINCT anzeige) as unique_ads
    FROM
        haus_kaufen) 
    dupl;
```

| total_ads | unique_ads | potential_duplicates |
|-----------|------------|----------------------|
| 481       | 435        | 46                   |




```sql
-- it seems to be that 46 ads are duplicates, tried to understand if these are all to remove

SELECT *
FROM haus_kaufen
WHERE anzeige IN (
    SELECT anzeige
    FROM haus_kaufen
    GROUP BY anzeige
    HAVING COUNT(*) > 1
)
ORDER BY anzeige ASC;
```



| link                                   | anzeige                                                                                                                | wohnfläche | zimmer | grundstück | ort                 | kaufpreis       | kategorie               | makler                                                | baujahr | effizienzklasse |
|----------------------------------------|------------------------------------------------------------------------------------------------------------------------|------------|--------|------------|---------------------|-----------------|-------------------------|-------------------------------------------------------|---------|-----------------|
| https://www.immowelt.de/expose/22ul85z | ***NEUE PLANUNG: Demnächst 30-Familienhaus mit TG-Stellplätzen zu Topkonditionen in Porz***                            | 2500       | 90     | 3000       | 51145 Köln          | 9.000.000       | Mehrfamilienhaus        | Emlak AG                                              | 2024    |                 |
| https://www.immowelt.de/expose/228q85z | ***NEUE PLANUNG: Demnächst 30-Familienhaus mit TG-Stellplätzen zu Topkonditionen in Porz***                            | 2500       |        | 3000       | 51145 Köln          | 9.000.000       | Mehrfamilienhaus        | Emlak AG                                              | 2024    |                 |
| https://www.immowelt.de/expose/2c6jv5c | + Doppelhaushälfte mit Garage und Stellplatz +                                                                         | 143        | 6      | 976        | 51069 Köln          | 700.000         | Doppelhaushälfte        |                                                       |         |                 |
| https://www.immowelt.de/expose/2cfhx5c | + Doppelhaushälfte mit Garage und Stellplatz +                                                                         | 143        | 6      | 976        | 51069 Köln          | 700.000         | Doppelhaushälfte        | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2curu5c | + Großzügiges Einfamilienhaus mit 4 Garagen +                                                                          | 197        | 5      | 2016       | 51147 Köln          | 1.405.000       | Einfamilienhaus         |                                                       |         |                 |
| https://www.immowelt.de/expose/2clhx5c | + Großzügiges Einfamilienhaus mit 4 Garagen +                                                                          | 197        | 5      | 2016       | 51147 Köln          | 1.405.000       | Einfamilienhaus         | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2cmru5c | + Reihenendhaus mit Garten und Garage +                                                                                | 133        | 5      | 235        | 51145 Köln          | 510.000         | Reihenendhaus           |                                                       |         |                 |
| https://www.immowelt.de/expose/2chhx5c | + Reihenendhaus mit Garten und Garage +                                                                                | 133        | 5      | 235        | 51145 Köln          | 510.000         | Reihenendhaus           | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2czru5c | 2-Familienhaus mit Garage + provisionsfrei +                                                                           | 118        | 7      | 513        | 50737 Köln          | 630.000         | Mehrfamilienhaus        |                                                       |         |                 |
| https://www.immowelt.de/expose/2c2hx5c | 2-Familienhaus mit Garage + provisionsfrei +                                                                           | 118        | 7      | 513        | 50737 Köln          | 630.000         | Mehrfamilienhaus        | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2bdw75u | 4% Ist-Rendite mit Steigerungspotential! Solides MFH in Köln, 5 Parteien + Gewerbe, 500 m2.                            | 500        | 15     | 526        | 51067 Köln Holweide |   auf Anfrage   | Wohn- und Geschäftshaus | HausHirsch GmbH                                       | 1969    |                 |
| https://www.immowelt.de/expose/2cjbm52 | 4% Ist-Rendite mit Steigerungspotential! Solides MFH in Köln, 5 Parteien + Gewerbe, 500 m2.                            | 500        | 15     | 526        | 51067 Köln Holweide |   auf Anfrage   | Mehrfamilienhaus        | HausHirsch GmbH                                       | 1969    |                 |
| https://www.immowelt.de/expose/29upt5f | AM KÖLNGALOPP, Leben auf Sonnengrundstücken-Haus Optima                                                                | 175        | 6      | 261        | 50735 Köln          | 989.900         | Wohnanlage              | RSE Bau GmbH                                          | 2023    |                 |
| https://www.immowelt.de/expose/294st5f | AM KÖLNGALOPP, Leben auf Sonnengrundstücken-Haus Optima                                                                | 149        | 5      | 261        | 50735 Köln          | 979.900         | Einfamilienhaus         | RSE Bau GmbH                                          | 2023    |                 |
| https://www.immowelt.de/expose/2cmek56 | Attraktives Wohn-und Geschäftshaus in Köln-Rondorf                                                                     | 470        |        | 1340       | 50997 Köln          | 1.150.000       | Wohn- und Geschäftshaus | Estate Connect GmbH                                   | 1978    |                 |
| https://www.immowelt.de/expose/2c9fk56 | Attraktives Wohn-und Geschäftshaus in Köln-Rondorf                                                                     | 200        | 6      | 1340       | 50997 Köln          | 1.150.000       | Mehrfamilienhaus        | Estate Connect GmbH                                   | 1978    |                 |
| https://www.immowelt.de/expose/2cr6u59 | Bestgepflegtes Mehrfamilienhaus mit 8 Wohneinheiten - Rheinpromenadennähe                                              | 281        | 8      | 175        | 51063 Köln          | 967.000         | Mehrfamilienhaus        | CENTURY 21 Meier & Cie. Immobilien                    | 1900    | E               |
| https://www.immowelt.de/expose/2c8xg5b | Bestgepflegtes Mehrfamilienhaus mit 8 Wohneinheiten - Rheinpromenadennähe                                              | 360        | 8      | 175        | 51063 Köln- Mülheim | 967.000         | Mehrfamilienhaus        | CENTURY 21 Meier & Cie. Immobilien                    | 1900    |                 |
| https://www.immowelt.de/expose/2culr5c | Doppelhaushälfte in 50968 Köln, Bayenthalgürtel                                                                        | 211        |        | 392        | 50968 Köln          | 2.140.000       | Doppelhaushälfte        | Argetra GmbH                                          | 1925    |                 |
| https://www.immowelt.de/expose/2ca2n5c | Doppelhaushälfte in 50968 Köln, Bayenthalgürtel                                                                        | 211        |        | 392        | 50968 Köln          | 2.140.000       | Doppelhaushälfte        | Argetra GmbH                                          | 1925    |                 |
| https://www.immowelt.de/expose/2c7ab5d | Doppelhaushälfte in 51069 Köln, Grafenmühlenweg                                                                        | 143        |        | 976        | 51069 Köln          | 700.000         | Doppelhaushälfte        | Argetra GmbH                                          | 1924    |                 |
| https://www.immowelt.de/expose/2c9a85d | Doppelhaushälfte in 51069 Köln, Grafenmühlenweg                                                                        | 143        |        | 976        | 51069 Köln          | 700.000         | Doppelhaushälfte        | Argetra GmbH                                          | 1924    |                 |
| https://www.immowelt.de/expose/2caq75c | Doppelhaushälfte in 51069 Köln, In der Gansau                                                                          | 122        |        | 814        | 51069 Köln          | 560.000         | Doppelhaushälfte        | Argetra GmbH                                          | 2004    |                 |
| https://www.immowelt.de/expose/2czla5c | Doppelhaushälfte in 51069 Köln, In der Gansau                                                                          | 122        |        | 814        | 51069 Köln          | 560.000         | Doppelhaushälfte        | Argetra GmbH                                          | 2004    |                 |
| https://www.immowelt.de/expose/2ac635q | Doppelhaushälfte mit Baugrundstück!!!                                                                                  | 135        |        | 712        | 51147 Köln          | 540.000         | Doppelhaushälfte        |                                                       | 1966    |                 |
| https://www.immowelt.de/expose/2bjel5u | Doppelhaushälfte mit Baugrundstück!!!                                                                                  | 135        |        | 712        | 51147 Köln          | 540.000         | Doppelhaushälfte        |                                                       | 1966    |                 |
| https://www.immowelt.de/expose/2cftu5c | Einfamilien-Reihenendhaus mit Doppelgarage - provisionsfrei                                                            | 110        | 4      | 280        | 51145 Köln          | 400.000         | Reihenendhaus           |                                                       |         |                 |
| https://www.immowelt.de/expose/2cjhx5c | Einfamilien-Reihenendhaus mit Doppelgarage - provisionsfrei                                                            | 110        | 4      | 280        | 51145 Köln          | 400.000         | Reihenendhaus           | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2cafu5c | Einfamilien-Reihenmittelhaus mit Garten + provisionsfrei +                                                             | 102        | 4      | 200        | 50739 Köln          | 450.000         | Reihenmittelhaus        |                                                       |         |                 |
| https://www.immowelt.de/expose/2c4hx5c | Einfamilien-Reihenmittelhaus mit Garten + provisionsfrei +                                                             | 102        | 4      | 200        | 50739 Köln          | 450.000         | Reihenmittelhaus        | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2c2f35a | Einfamilienhaus in 50859 Köln, Karl-Kaulen-Str.                                                                        | 62         |        | 401        | 50859 Köln          | 410.000         | Einfamilienhaus         | Argetra GmbH                                          |         |                 |
| https://www.immowelt.de/expose/2cv4z59 | Einfamilienhaus in 50859 Köln, Karl-Kaulen-Str.                                                                        | 62         |        | 401        | 50859 Köln          | 410.000         | Einfamilienhaus         | Argetra GmbH                                          |         |                 |
| https://www.immowelt.de/expose/2crjg5c | Einfamilienhaus in 51067 Köln, Schnellweider Str.                                                                      | 110        |        | 1213       | 51067 Köln          | 800.000         | Einfamilienhaus         | Argetra GmbH                                          |         |                 |
| https://www.immowelt.de/expose/2ckea5c | Einfamilienhaus in 51067 Köln, Schnellweider Str.                                                                      | 110        |        | 1213       | 51067 Köln          | 800.000         | Einfamilienhaus         | Argetra GmbH                                          |         |                 |
| https://www.immowelt.de/expose/2b8fw5p | Einfamilienhaus in 51069 Köln                                                                                          | 122        |        |            | 51069 Köln          | 560.000         | Einfamilienhaus         | Dein-ImmoCenter                                       |         |                 |
| https://www.immowelt.de/expose/2cny559 | Einfamilienhaus in 51069 Köln                                                                                          | 143        |        |            | 51069 Köln          | 700.000         | Einfamilienhaus         | Dein-ImmoCenter                                       |         |                 |
| https://www.immowelt.de/expose/2bafw5p | Einfamilienhaus in 51145 Köln                                                                                          | 133        |        |            | 51145 Köln          | 510.000         | Einfamilienhaus         | Dein-ImmoCenter                                       |         |                 |
| https://www.immowelt.de/expose/2bjgg5r | Einfamilienhaus in 51145 Köln                                                                                          | 110        |        |            | 51145 Köln          | 400.000         | Einfamilienhaus         | Dein-ImmoCenter                                       |         |                 |
| https://www.immowelt.de/expose/2cefb5d | Einfamilienhaus in 51147 Köln, Grengeler Mauspfad                                                                      | 197        |        | 2016       | 51147 Köln          | 1.405.000       | Einfamilienhaus         | Argetra GmbH                                          | 1997    |                 |
| https://www.immowelt.de/expose/2c9e85d | Einfamilienhaus in 51147 Köln, Grengeler Mauspfad                                                                      | 197        |        | 2016       | 51147 Köln          | 1.405.000       | Einfamilienhaus         | Argetra GmbH                                          | 1997    |                 |
| https://www.immowelt.de/expose/2cz8v5c | Einfamilienhaus mit Garten ++ provisionsfrei ++                                                                        | 110        | 4      | 1213       | 51067 Köln          | 800.000         | Einfamilienhaus         |                                                       |         |                 |
| https://www.immowelt.de/expose/2cdhx5c | Einfamilienhaus mit Garten ++ provisionsfrei ++                                                                        | 110        | 4      | 1213       | 51067 Köln          | 800.000         | Einfamilienhaus         | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2c6ys56 | Einzigartige Investmentmöglichkeit in zentraler Lage Kölns: Kapitalanlage mit Eigennutzpotenzial                       | 478        | 10     | 174        | 50968 Köln          | 1.299.000       | Mehrfamilienhaus        | McMakler GmbH                                         | 2003    | A               |
| https://www.immowelt.de/expose/2ctk757 | Einzigartige Investmentmöglichkeit in zentraler Lage Kölns: Kapitalanlage mit Eigennutzpotenzial                       | 478        | 10     | 174        | 50968 Köln          | 1.299.000       | Mehrfamilienhaus        | McMakler GmbH                                         | 2003    | A               |
| https://www.immowelt.de/expose/2bycy5g | Gepflegtes Vierfamilienhaus im beliebten Kölner Süden                                                                  | 315        | 9      | 338        | 50997 Köln          | 795.000         | Mehrfamilienhaus        | WAV Immobilien Reuschenbach GmbH                      | 1980    |                 |
| https://www.immowelt.de/expose/2bzcy5g | Gepflegtes Vierfamilienhaus im beliebten Kölner Süden                                                                  | 315        | 9      | 338        | 50997 Köln          | 795.000         | Mehrfamilienhaus        | WAV Immobilien Reuschenbach GmbH                      | 1980    |                 |
| https://www.immowelt.de/expose/2c2r257 | Interesse geweckt? Vermietetes Zweifamilienhaus für Immobilienerfahrene - Erbbaurecht!                                 | 106        | 5      | 512        | 51147 Köln          | 249.000         | Mehrfamilienhaus        | McMakler GmbH                                         | 1962    | G               |
| https://www.immowelt.de/expose/2cjr257 | Interesse geweckt? Vermietetes Zweifamilienhaus für Immobilienerfahrene - Erbbaurecht!                                 | 106        | 5      | 512        | 51147 Köln          | 249.000         | Mehrfamilienhaus        | McMakler GmbH                                         | 1962    | G               |
| https://www.immowelt.de/expose/2bnlm58 | Kaufpreisreduktion! Attraktives ZFH mit schönem Garten in Köln-Heimersdorf                                             | 250        |        | 600        | 50767 Köln          | 760.000         | Mehrfamilienhaus        | Estate Connect GmbH                                   | 1950    | D               |
| https://www.immowelt.de/expose/2b3pm58 | Kaufpreisreduktion! Attraktives ZFH mit schönem Garten in Köln-Heimersdorf                                             | 200        | 7      | 600        | 50767 Köln          | 760.000         | Mehrfamilienhaus        | Estate Connect GmbH                                   | 1950    | D               |
| https://www.immowelt.de/expose/2cj7u5c | Klein, aber mein ++ Einfamilienhaus mit Garten ++                                                                      | 62         | 3      | 401        | 50859 Köln          | 410.000         | Einfamilienhaus         |                                                       |         |                 |
| https://www.immowelt.de/expose/2c6hx5c | Klein, aber mein ++ Einfamilienhaus mit Garten ++                                                                      | 62         | 3      | 401        | 50859 Köln          | 410.000         | Einfamilienhaus         | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2cfhx58 | Klimafreundliches Wohngebäude mit QNG - Nachhaltiges Wohnen auf höchstem Niveau                                        | 143        | 6      | 211        | 51145 Köln          | 689.900         | Reihenmittelhaus        | Werner Wohnbau GmbH &Co.KG                            | 2023    |                 |
| https://www.immowelt.de/expose/2clhx58 | Klimafreundliches Wohngebäude mit QNG - Nachhaltiges Wohnen auf höchstem Niveau                                        | 143        | 6      | 286        | 51145 Köln          | 724.900         | Reihenendhaus           | Werner Wohnbau GmbH &Co.KG                            | 2023    |                 |
| https://www.immowelt.de/expose/2cahx58 | Köln-Porz \| Ihr Eigenheim mit langfristiger Wertsteigerung - energieeffizienter Neubau                                | 143        | 6      | 211        | 51145 Köln          | 614.900         | Reihenmittelhaus        | Werner Wohnbau GmbH &Co.KG                            | 2023    |                 |
| https://www.immowelt.de/expose/2cdhx58 | Köln-Porz \| Ihr Eigenheim mit langfristiger Wertsteigerung - energieeffizienter Neubau                                | 143        | 6      | 286        | 51145 Köln          | 649.900         | Reihenendhaus           | Werner Wohnbau GmbH &Co.KG                            | 2023    |                 |
| https://www.immowelt.de/expose/2cx5256 | Lebensqualität am Rhein: Ihr neues Zuhause und Investitionsmöglichkeit!                                                | 148        |        | 270        | 51061 Köln          | 360.000         | Mehrfamilienhaus        | Immobiehler e.K.                                      | 1935    |                 |
| https://www.immowelt.de/expose/2c78f57 | Lebensqualität am Rhein: Ihr neues Zuhause und Investitionsmöglichkeit!                                                | 148        |        | 270        | 51061 Köln          | 360.000         | Reihenmittelhaus        | Immobiehler e.K.                                      | 1935    | H               |
| https://www.immowelt.de/expose/2cep45c | Mehrfamilienhaus in 51067 Köln, Scheidemannstr.                                                                        | 225        |        | 324        | 51067 Köln          | 830.000         | Mehrfamilienhaus        | Argetra GmbH                                          | 1980    |                 |
| https://www.immowelt.de/expose/2cg375c | Mehrfamilienhaus in 51067 Köln, Scheidemannstr.                                                                        | 225        |        | 324        | 51067 Köln          | 830.000         | Mehrfamilienhaus        | Argetra GmbH                                          | 1980    |                 |
| https://www.immowelt.de/expose/2ccha58 | Moderne Neubaudoppelhaushälfte                                                                                         | 125        | 4      | 224        | 51147 Köln          | 499.000         | Doppelhaushälfte        | Immo Projekte P2 GmbH                                 | 2023    |                 |
| https://www.immowelt.de/expose/2cyga58 | Moderne Neubaudoppelhaushälfte                                                                                         | 125        | 4      | 224        | 51147 Köln          | 499.000         | Doppelhaushälfte        | Immo Projekte P2 GmbH                                 | 2023    |                 |
| https://www.immowelt.de/expose/2bxgh55 | Modernisiertes topgepflegtes Mehrfamilienhaus Köln-Lövenich                                                            | 262        | 10     | 555        | 50859 Köln-Lövenich | 1.095.000       | Mehrfamilienhaus        | VON EMHOFEN IMMOBILIEN e.K.                           | 1964    | E               |
| https://www.immowelt.de/expose/2cbdp53 | Modernisiertes topgepflegtes Mehrfamilienhaus Köln-Lövenich                                                            | 262        | 10     | 555        | 50859 Köln-Lövenich | 1.095.000       | Einfamilienhaus         | VON EMHOFEN IMMOBILIEN e.K.                           | 1964    | E               |
| https://www.immowelt.de/expose/2cxuw56 | Perfekte Mischung für Kapitalanleger: einmal vermietet, einmal leerstehend!                                            | 140        | 5      | 482        | 50859 Köln          | 590.000         | Mehrfamilienhaus        | McMakler GmbH                                         | 1958    | H               |
| https://www.immowelt.de/expose/2cmvw56 | Perfekte Mischung für Kapitalanleger: einmal vermietet, einmal leerstehend!                                            | 140        | 5      | 482        | 50859 Köln          | 590.000         | Mehrfamilienhaus        | McMakler GmbH                                         | 1958    | H               |
| https://www.immowelt.de/expose/2cwwu5c | Platz für alle + 2-Familienhaus mit Garage +                                                                           | 290        | 7      | 1291       | 51107 Köln          | 1.180.000       | Mehrfamilienhaus        |                                                       |         |                 |
| https://www.immowelt.de/expose/2cghx5c | Platz für alle + 2-Familienhaus mit Garage +                                                                           | 290        | 7      | 1291       | 51107 Köln          | 1.180.000       | Mehrfamilienhaus        | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2ccyw5c | Platz für die ganze Familie + Großzügiges Einfamilienhaus mit Garten und Garage +                                      | 211        | 7      | 392        | 50968 Köln          | 2.140.000       | Einfamilienhaus         |                                                       |         |                 |
| https://www.immowelt.de/expose/2cahx5c | Platz für die ganze Familie + Großzügiges Einfamilienhaus mit Garten und Garage +                                      | 211        | 7      | 392        | 50968 Köln          | 2.140.000       | Einfamilienhaus         | AZ Agentur für Zwangsversteigerungsinformationen GmbH |         |                 |
| https://www.immowelt.de/expose/2c3zy59 | Reiheneckhaus in 51145 Köln, Georgstr.                                                                                 | 110        |        | 280        | 51145 Köln          | 400.000         | Reiheneckhaus           | Argetra GmbH                                          | 1968    |                 |
| https://www.immowelt.de/expose/2chgt59 | Reiheneckhaus in 51145 Köln, Georgstr.                                                                                 | 110        |        | 280        | 51145 Köln          | 400.000         | Reiheneckhaus           | Argetra GmbH                                          | 1968    |                 |
| https://www.immowelt.de/expose/2czz95c | Reiheneckhaus in 51145 Köln, Helmholtzstr.                                                                             | 133        |        | 235        | 51145 Köln          | 510.000         | Reiheneckhaus           | Argetra GmbH                                          | 1997    |                 |
| https://www.immowelt.de/expose/2cx9g5c | Reiheneckhaus in 51145 Köln, Helmholtzstr.                                                                             | 133        |        | 235        | 51145 Köln          | 510.000         | Reiheneckhaus           | Argetra GmbH                                          | 1997    |                 |
| https://www.immowelt.de/expose/2cd775c | Reihenmittelhaus in 50739 Köln, Guntherstr.                                                                            | 102        |        | 200        | 50739 Köln          | 450.000         | Reihenmittelhaus        | Argetra GmbH                                          | 1930    |                 |
| https://www.immowelt.de/expose/2c9u95c | Reihenmittelhaus in 50739 Köln, Guntherstr.                                                                            | 102        |        | 200        | 50739 Köln          | 450.000         | Reihenmittelhaus        | Argetra GmbH                                          | 1930    |                 |
| https://www.immowelt.de/expose/2bgjx5d | Rundbogenhalle mit PVC Plane in Grün Quadratmeterfläche - 91,50m^2  - Tierstall, Industriehalle, Waren/Holz/Strohlager | 92         | 1      | 92         | 50674 Köln          | 5.293           | Rundbogenhalle          | Covertop GmbH                                         | 2023    |                 |
| https://www.immowelt.de/expose/2bdjy5d | Rundbogenhalle mit PVC Plane in Grün Quadratmeterfläche - 91,50m^2  - Tierstall, Industriehalle, Waren/Holz/Strohlager | 92         | 1      | 92         | 50674 Köln          | 5.293           | Rundbogenhalle          | Covertop GmbH                                         | 2023    |                 |
| https://www.immowelt.de/expose/2cgkt59 | Solides, vollvermietetes, Wohn-Geschäftshaus mit gemütlichem Charm in Köln, Altstadt-Süd                               | 222        | 6      | 102        | 50676 Köln          | 850.000         | Wohn- und Geschäftshaus | Adeneuer Immobilien                                   | 1950    | F               |
| https://www.immowelt.de/expose/2ccrt59 | Solides, vollvermietetes, Wohn-Geschäftshaus mit gemütlichem Charm in Köln, Altstadt-Süd                               | 222        | 6      | 102        | 50676 Köln          | 850.000         | Mehrfamilienhaus        | Adeneuer Immobilien                                   |         | F               |
| https://www.immowelt.de/expose/2bmuc56 | Wohn- und Geschäftshaus in Top Lage in Köln-Sülz                                                                       | 252        | 15     | 387        | 50937 Köln          | 1.890.000       | Mehrfamilienhaus        | Kölner Haus- und Grundbesitzverein Immobilien GmbH    | 1906    | E               |
| https://www.immowelt.de/expose/2ctd953 | Wohn- und Geschäftshaus in Top Lage in Köln-Sülz                                                                       | 488        |        | 387        | 50937 Köln          | 1.890.000       | Wohn- und Geschäftshaus | Kölner Haus- und Grundbesitzverein Immobilien GmbH    | 1906    |                 |
| https://www.immowelt.de/expose/2cvfz5d | Wohnanlage mit 24 WE in guter Lage                                                                                     | 1604       | 72     | 2576       | 51147 Köln          | 5.750.000       | Wohnanlage              | Select Immobiliengesellschaft mbH                     | 1973    |                 |
| https://www.immowelt.de/expose/2c7gz5d | Wohnanlage mit 24 WE in guter Lage                                                                                     | 1604       | 72     | 2576       | 51147 Köln          |   auf Anfrage   | Wohnanlage              | Select Immobiliengesellschaft mbH                     | 1973    |                 |
| https://www.immowelt.de/expose/29mgy5h | Wohnen im Grünen - Ihr neues Zuhause in Köln-Weiler!                                                                   | 150        | 5      | 258        | 50765 Köln          | 755.900         | Doppelhaushälfte        | DORNIEDEN Generalbau GmbH                             |         | A               |
| https://www.immowelt.de/expose/2c5g853 | Wohnen im Grünen - Ihr neues Zuhause in Köln-Weiler!                                                                   | 150        | 5      | 258        | 50765 Köln          | 755.900         | Doppelhaushälfte        | DORNIEDEN Generalbau GmbH                             |         | A               |
| https://www.immowelt.de/expose/2bkmw5z | Wohnhaus mit viel Potenzial. Hier lassen sich Ihre Wohn-Wünsche verwirklichen.                                         | 130        | 4      | 1086       | 51147 Köln          | 698.000         | Einfamilienhaus         | Cornelia Dollberg Immobilien                          | 1908    | G               |
| https://www.immowelt.de/expose/2bqnw5z | Wohnhaus mit viel Potenzial. Hier lassen sich Ihre Wohn-Wünsche verwirklichen.                                         | 130        | 4      | 1086       | 51147 Köln          | 698.000         | Einfamilienhaus         | Cornelia Dollberg Immobilien                          | 1908    | G               |
| https://www.immowelt.de/expose/2c3aa5c | Zweifamilienhaus in 50737 Köln, Bielefelder Str.                                                                       | 99         |        | 513        | 50737 Köln          | 630.000         | Mehrfamilienhaus        | Argetra GmbH                                          | 1952    |                 |
| https://www.immowelt.de/expose/2cfk75c | Zweifamilienhaus in 50737 Köln, Bielefelder Str.                                                                       | 99         |        | 513        | 50737 Köln          | 630.000         | Mehrfamilienhaus        | Argetra GmbH                                          | 1952    |                 |
| https://www.immowelt.de/expose/2cdkg5c | Zweifamilienhaus in 51107 Köln, Frankfurter Str.                                                                       | 290        |        | 1291       | 51107 Köln          | 1.180.000       | Mehrfamilienhaus        | Argetra GmbH                                          | 2013    |                 |
| https://www.immowelt.de/expose/2cgha5c | Zweifamilienhaus in 51107 Köln, Frankfurter Str.                                                                       | 290        |        | 1291       | 51107 Köln          | 1.180.000       | Mehrfamilienhaus        | Argetra GmbH                                          | 2013    |                 |



```sql
/* Investigated the differences between duplicates and selected the rows to remove

https://www.immowelt.de/expose/228q85z no zimmer
https://www.immowelt.de/expose/2c6jv5c no makler
https://www.immowelt.de/expose/2curu5c no makler
https://www.immowelt.de/expose/2cmru5c no makler
https://www.immowelt.de/expose/2czru5c no makler
https://www.immowelt.de/expose/2cjbm52 wohn- und geschäftshaus
https://www.immowelt.de/expose/2cmek56 no zimmer
https://www.immowelt.de/expose/2c8xg5b 281 wf is correct
https://www.immowelt.de/expose/2culr5c duplicate
https://www.immowelt.de/expose/2c7ab5d duplicate
https://www.immowelt.de/expose/2caq75c duplicate
https://www.immowelt.de/expose/2ac635q duplicate
https://www.immowelt.de/expose/2cftu5c no makler
https://www.immowelt.de/expose/2cafu5c no makler
https://www.immowelt.de/expose/2c2f35a duplicate
https://www.immowelt.de/expose/2crjg5c duplicate
https://www.immowelt.de/expose/2cefb5d duplicate
https://www.immowelt.de/expose/2cz8v5c no makler
https://www.immowelt.de/expose/2c6ys56 duplicate
https://www.immowelt.de/expose/2bycy5g duplicate
https://www.immowelt.de/expose/2c2r257 duplicate
https://www.immowelt.de/expose/2bnlm58 no room
https://www.immowelt.de/expose/2cj7u5c no makler
https://www.immowelt.de/expose/2c78f57 mehrfamilienhaus
https://www.immowelt.de/expose/2cg375c duplicate
https://www.immowelt.de/expose/2cyga58 duplicate
https://www.immowelt.de/expose/2cbdp53 mehrfamilienhaus
https://www.immowelt.de/expose/2cxuw56 duplicate
https://www.immowelt.de/expose/2cwwu5c no makler
https://www.immowelt.de/expose/2ccyw5c no makler
https://www.immowelt.de/expose/2c3zy59 duplicate
https://www.immowelt.de/expose/2czz95c duplicate
https://www.immowelt.de/expose/2cd775c duplicate
https://www.immowelt.de/expose/2bgjx5d duplicate
https://www.immowelt.de/expose/2ccrt59 no mehrfamilienhaus
https://www.immowelt.de/expose/2ctd953 no 488 m2
https://www.immowelt.de/expose/2c7gz5d there´s not a price
https://www.immowelt.de/expose/2c5g853 duplicate
https://www.immowelt.de/expose/2bqnw5z duplicate
https://www.immowelt.de/expose/2cfk75c duplicate
https://www.immowelt.de/expose/2cgha5c duplicate

```

```sql
-- added a new column with a ref_num, took from the link column

ALTER TABLE haus_kaufen
ADD COLUMN ref_num VARCHAR(255);
```

```sql
UPDATE haus_kaufen
SET ref_num = SUBSTRING(link, LENGTH('https://www.immowelt.de/expose/') + 1);
```
```sql
ALTER TABLE `immo_köln`.`haus_kaufen` 
CHANGE COLUMN `ref_num` `ref_num` VARCHAR(255) NULL DEFAULT NULL AFTER `link`;
```
```sql
-- checked the presence of the new column in the table

SELECT *
FROM haus_kaufen
WHERE anzeige IN (
    SELECT anzeige
    FROM haus_kaufen
    GROUP BY anzeige
    HAVING COUNT(*) > 1
)
ORDER BY anzeige ASC;
```


| link                                   | anzeige                                                                               | wohnfläche | zimmer | grundstück | ort        | kaufpreis | kategorie        | makler   | baujahr | effizienzklasse | ref_num |
|----------------------------------------|---------------------------------------------------------------------------------------|------------|--------|------------|------------|-----------|------------------|----------|---------|-----------------|---------|
| https://www.immowelt.de/expose/22ul85z | NEUE PLANUNG: Demnächst 30-Familienhaus mit TG-Stellplätzen zu Topkonditionen in Porz | 2500       | 90     | 3000       | 51145 Köln | 9.000.000 | Mehrfamilienhaus | Emlak AG | 2024    |                 | 22ul85z |


```sql
-- deleted the selected duplicates

DELETE FROM haus_kaufen
WHERE ref_num IN("228q85z", "2c6jv5c", "2curu5c", "2cmru5c", "2czru5c", "2cjbm52", 
		"228q85z", "2c6jv5c", "2curu5c", "2cmru5c", "2czru5c", "2cjbm52", 
		"2cmek56", "2c8xg5b", "2culr5c", "2c7ab5d", "2caq75c", "2ac635q", 
		"2cftu5c", "2cafu5c", "2c2f35a","2crjg5c", "2cefb5d", "2cz8v5c", 
		"2c6ys56", "2bycy5g", "2c2r257", "2bnlm58", "2cj7u5c", "2c78f57", 
		"2cg375c", "2cyga58", "2cbdp53", "2cxuw56", "2cwwu5c", "2ccyw5c", 
		"2c3zy59", "2czz95c", "2cd775c", "2bgjx5d", "2ccrt59", "2ctd953", 
		"2c7gz5d", "2c5g853", "2bqnw5z", "2cfk75c", "2cgha5c")
```

```sql
-- verified if the selected rows are deleted

SELECT *
FROM haus_kaufen
WHERE anzeige IN (
    SELECT anzeige
    FROM haus_kaufen
    GROUP BY anzeige
    HAVING COUNT(*) > 1
)
ORDER BY anzeige ASC;

-- the remaining rows refer to the ads that have the same title but different information in price, living surface, rooms or plot
```

| link                                   | ref_num | anzeige                                                                                 | wohnfläche | zimmer | grundstück | ort        | kaufpreis | kategorie        | makler                     | baujahr | effizienzklasse |
|----------------------------------------|---------|-----------------------------------------------------------------------------------------|------------|--------|------------|------------|-----------|------------------|----------------------------|---------|-----------------|
| https://www.immowelt.de/expose/29upt5f | 29upt5f | AM KÖLNGALOPP, Leben auf Sonnengrundstücken-Haus Optima                                 | 175        | 6      | 261        | 50735 Köln | 989.900   | Wohnanlage       | RSE Bau GmbH               | 2023    |                 |
| https://www.immowelt.de/expose/294st5f | 294st5f | AM KÖLNGALOPP, Leben auf Sonnengrundstücken-Haus Optima                                 | 149        | 5      | 261        | 50735 Köln | 979.900   | Einfamilienhaus  | RSE Bau GmbH               | 2023    |                 |
| https://www.immowelt.de/expose/2b8fw5p | 2b8fw5p | Einfamilienhaus in 51069 Köln                                                           | 122        |        |            | 51069 Köln | 560.000   | Einfamilienhaus  | Dein-ImmoCenter            |         |                 |
| https://www.immowelt.de/expose/2cny559 | 2cny559 | Einfamilienhaus in 51069 Köln                                                           | 143        |        |            | 51069 Köln | 700.000   | Einfamilienhaus  | Dein-ImmoCenter            |         |                 |
| https://www.immowelt.de/expose/2bafw5p | 2bafw5p | Einfamilienhaus in 51145 Köln                                                           | 133        |        |            | 51145 Köln | 510.000   | Einfamilienhaus  | Dein-ImmoCenter            |         |                 |
| https://www.immowelt.de/expose/2bjgg5r | 2bjgg5r | Einfamilienhaus in 51145 Köln                                                           | 110        |        |            | 51145 Köln | 400.000   | Einfamilienhaus  | Dein-ImmoCenter            |         |                 |
| https://www.immowelt.de/expose/2cfhx58 | 2cfhx58 | Klimafreundliches Wohngebäude mit QNG - Nachhaltiges Wohnen auf höchstem Niveau         | 143        | 6      | 211        | 51145 Köln | 689.900   | Reihenmittelhaus | Werner Wohnbau GmbH &Co.KG | 2023    |                 |
| https://www.immowelt.de/expose/2clhx58 | 2clhx58 | Klimafreundliches Wohngebäude mit QNG - Nachhaltiges Wohnen auf höchstem Niveau         | 143        | 6      | 286        | 51145 Köln | 724.900   | Reihenendhaus    | Werner Wohnbau GmbH &Co.KG | 2023    |                 |
| https://www.immowelt.de/expose/2cahx58 | 2cahx58 | Köln-Porz \  Ihr Eigenheim mit langfristiger Wertsteigerung - energieeffizienter Neubau | 143        | 6      | 211        | 51145 Köln | 614.900   | Reihenmittelhaus | Werner Wohnbau GmbH &Co.KG | 2023    |                 |
| https://www.immowelt.de/expose/2cdhx58 | 2cdhx58 | Köln-Porz \  Ihr Eigenheim mit langfristiger Wertsteigerung - energieeffizienter Neubau | 143        | 6      | 286        | 51145 Köln | 649.900   | Reihenendhaus    | Werner Wohnbau GmbH &Co.KG | 2023    |                 |   


```sql
-- Replaced for the ref_num 2bmuc56 the category "Mehrfamilienhaus"
-- with the correct house category "Wohn- und Geschäftshaus"

UPDATE haus_kaufen
SET kategorie = "Wohn- und Geschäftshaus"
WHERE ref_num = '2bmuc56'
--
SELECT *
FROM haus_kaufen
WHERE ref_num = '2bmuc56'   
```
| link                                   | ref_num | anzeige                                          | wohnfläche | zimmer | grundstück | ort        | kaufpreis | kategorie               | makler                                             | baujahr | effizienzklasse |
|----------------------------------------|---------|--------------------------------------------------|------------|--------|------------|------------|-----------|-------------------------|----------------------------------------------------|---------|-----------------|
| https://www.immowelt.de/expose/2bmuc56 | 2bmuc56 | Wohn- und Geschäftshaus in Top Lage in Köln-Sülz | 252        | 15     | 387        | 50937 Köln | 1.890.000 | Wohn- und Geschäftshaus | Kölner Haus- und Grundbesitzverein Immobilien GmbH | 1906    | E               |
---


### c. Manage missing value

---
```sql
-- Identified the number of null values in the column "wohnfläche"

SELECT 
    count(anzeige) as null_wohnfläche
FROM 
    haus_kaufen
WHERE
    wohnfläche = ""
```

| null_wohnfläche |
|-----------------|
| 1               |

```sql
-- Investigate the null value in the column "wohnfläche"

SELECT *
FROM haus_kaufen
WHERE wohnfläche = ""
```

| link                                   | anzeige                                              | wohnfläche | zimmer | grundstück | ort        | kaufpreis | kategorie        | makler                                                | baujahr | effizienzklasse | ref_num |
|----------------------------------------|------------------------------------------------------|------------|--------|------------|------------|-----------|------------------|-------------------------------------------------------|---------|-----------------|---------|
| https://www.immowelt.de/expose/2qxg74e | - NRW- Mehrfamilienhäuser im Paket (Top Investment)- |            |        |            | 50667 Köln | 4.350.000 | Mehrfamilienhaus | Muzi-Berlin Immobilien & Finanzdienst e. K.-seit 1992 | 1900    |                 | 2qxg74e |

```sql
-- It seems to be a sort of spam AD and it refers to the region NRW. From the link there´s only a picture with a skyscraper
-- Anyway it isn´t helpful for the analysis due to the lack of the house characteristics data.
-- Provided to delete it

DELETE 
FROM haus_kaufen
WHERE ref_num = "2qxg74e"
```

```sql
-- Identified the number of null values in the column "zimmer"

SELECT 
    COUNT(*) as null_zimmer,
    (COUNT(*) / (SELECT COUNT(*) FROM haus_kaufen)) * 100 AS percent
FROM 
    haus_kaufen
WHERE 
    zimmer = "";
```
    
| null_zimmer | percent |
|-------------|---------|
| 74          | 16.8565 |

```sql
-- searched for values about the number of rooms in the ad
SELECT ref_num, anzeige
FROM haus_kaufen
WHERE zimmer = "" AND anzeige LIKE "%zimmer%"
```

| ref_num | anzeige                                                |
|---------|--------------------------------------------------------|
| 2a3n45m | Attraktive 2-Zimmer-Wohnung mit Balkon in Köln-Mülheim |

```sql
-- replaced the null value of the room with "2" for the ad "2a3n45m"

UPDATE haus_kaufen
SET zimmer = 2
WHERE ref_num = '2a3n45m';
```
```sql
SELECT ref_num, anzeige, zimmer
FROM haus_kaufen
WHERE ref_num = '2a3n45m';
```

| ref_num | anzeige                                                | zimmer |
|---------|--------------------------------------------------------|--------|
| 2a3n45m | Attraktive 2-Zimmer-Wohnung mit Balkon in Köln-Mülheim | 2      |

```sql
-- Added "N/A" for the null values in the column "zimmer"

UPDATE haus_kaufen
SET zimmer = "N/A"
WHERE zimmer = ""
```

```sql
-- Identified the number of null values in the column "grundstück"

SELECT 
    count(anzeige) as null_grundstück
FROM 
    haus_kaufen
WHERE
    grundstück = ""
```

| null_grundstück |
|-----------------|
| 33              |

#### It can be assumed that ads that do not contain information on the number of square meters of land do not have a plot of land.
#### For this reason the null values can be replaced with "0"

```sql
UPDATE haus_kaufen
SET grundstück = 0
WHERE grundstück = ""
```

```sql
-- Identified the number of null values in the column "ort"

SELECT 
    count(anzeige) as null_ort
FROM 
    haus_kaufen
WHERE
    ort = ""
```

| null_ort	 |
|----------------|
| 0              |

```sql
-- Identified the number of null values in the column "kategorie"

SELECT 
    count(anzeige) as null_kategorie
FROM 
    haus_kaufen
WHERE
    kategorie = ""
```

| null_kategorie |
|----------------|
| 1              |

```sql
-- Investigate the null value

SELECT *
FROM 
    haus_kaufen
WHERE
    kategorie = ""
```

| link                                   | anzeige              | wohnfläche | zimmer | grundstück | ort          | kaufpreis | kategorie | makler | baujahr | effizienzklasse | ref_num |
|----------------------------------------|----------------------|------------|--------|------------|--------------|-----------|-----------|--------|---------|-----------------|---------|
| https://www.immowelt.de/expose/2a7z75y | Watamu Privatanwesen | 1          | 5      | 1          | 80202 Watamu | 398.000   |           |        |         |                 | 2a7z75y |


#### The ad that hasn´t a category, refers to a city in Kenya, for this reason can be delete as out of scope of the analysis.
#### The anomaly would come out with the outliers analysis 


```sql
-- Deleted the Watamu ad

DELETE
FROM haus_kaufen
WHERE ref_num = "2a7z75y"
```

```sql
--  Identified the number of null values in the column "kategorie"

SELECT 
    count(anzeige) as null_kategorie
FROM 
    haus_kaufen
WHERE
    kategorie = ""
```

| null_kategorie |
|----------------|
| 0              |

```sql
--  Identified the number of null values in the column "makler"

SELECT 
    count(anzeige) as null_makler
FROM 
    haus_kaufen
WHERE
    makler = ""
```
| null_makler |
|-------------|
| 43          |

#### We can assume that for ads where no agency information is present, the sale is conducted privately

```sql
UPDATE haus_kaufen
SET makler = "Privatanbieter"
WHERE makler = ""
```
```sql
--  Identified the number of null values in the column "baujahr"
SELECT 
    count(anzeige) as null_baujahr
FROM 
    haus_kaufen
WHERE
    baujahr = ""
```
| null_baujahr |
|--------------|
| 85           |
---


### d. Convert Data Type
#### All the values are imported in mySQL as a string. The data have to be modified before convert the data type

---
```sql
-- Converted wohnfläche and grundstück in float values

ALTER TABLE `immo_köln`.`haus_kaufen` 
CHANGE COLUMN `wohnfläche` `wohnfläche` FLOAT NULL DEFAULT NULL 
CHANGE COLUMN `grundstück` `grundstück` FLOAT NULL DEFAULT NULL 
```

```sql
-- Replaced the "." in the column related to the price

UPDATE haus_kaufen
SET kaufpreis = REPLACE(kaufpreis, ".", "")
```
```sql
-- Investigated the presence of non numerical data in the column "kaufpreis"

SELECT * FROM haus_kaufen
WHERE kaufpreis REGEXP '^[^0-9]+$';
```
| link                                   | ref_num | anzeige                                                                                        | wohnfläche | zimmer | grundstück | ort                   | kaufpreis   | kategorie               | makler                                                      | baujahr | effizienzklasse |
|----------------------------------------|---------|------------------------------------------------------------------------------------------------|------------|--------|------------|-----------------------|-------------|-------------------------|-------------------------------------------------------------|---------|-----------------|
| https://www.immowelt.de/expose/2av8x59 | 2av8x59 | Das besondere Haus für Naturliebhaber und Individualisten, so wie man es noch nicht kennt!     | 115        | 6      | 1684       | 51105 Köln            | auf Anfrage | Einfamilienhaus         | Katzmann Immobilien GmbH                                    | 1934    | G               |
| https://www.immowelt.de/expose/2bjcs57 | 2bjcs57 | Exklusive Villa im Südstaaten-Stil, aufwendig modernisiert, Neubauzustand, 1170m² Gesamtfläche | 750        | 16     | 2000       | 50996 Köln / Hahnwald | auf Anfrage | Villa                   | Sotheby´s International Realty NRW/Pantera Living Köln GmbH | 1996    | E               |
| https://www.immowelt.de/expose/2bdw75u | 2bdw75u | 4% Ist-Rendite mit Steigerungspotential! Solides MFH in Köln, 5 Parteien + Gewerbe, 500 m2.    | 500        | 15     | 526        | 51067 Köln Holweide   | auf Anfrage | Wohn- und Geschäftshaus | HausHirsch GmbH                                             | 1969    |                 |
| https://www.immowelt.de/expose/2b63m5w | 2b63m5w | Außergewöhnliche Villa auf einem 2.600m² Grundstück in Bestlage von Alt-Hahnwald               | 788        | 9      | 2620       | 50996 Köln / Hahnwald | auf Anfrage | Villa                   | Sotheby´s International Realty NRW/Pantera Living Köln GmbH | 2016    | B               |
| https://www.immowelt.de/expose/2css358 | 2css358 | Repräsentative Architektur in ausgezeichneter Lage                                             | 498        | 13     | 1262       | 50935 Köln            | auf Anfrage | Villa                   | Postbank Immobilien GmbH                                    | 1936    |                 |
| https://www.immowelt.de/expose/29mak5v | 29mak5v | Architektenhaus kurz vor Fertigstellung - KFW 55+ einziehen und genießen                       | 162        | 4      | 702        | 51143 Köln            | auf Anfrage | Einfamilienhaus         | Immobilien Graumann                                         | 2023    | A+              |
| https://www.immowelt.de/expose/2bhr252 | 2bhr252 | Eleganz zum Wohnen                                                                             | 480        | 7      | 1200       | 51149 Köln            | auf Anfrage | Villa                   | Immobilien Graumann                                         | 2024    |                 |
| https://www.immowelt.de/expose/2ccng5a | 2ccng5a | amarc21 - privates Bieterverfahren - keine zusätzliche Käuferprovision -                       | 257        | 11     | 287        | 51105 Köln            | auf Anfrage | Mehrfamilienhaus        | amarc21 Aussem Immobilien                                   | 1905    |                 |

#### Looking in the sale price column, there are 8 listings that do not contain the price, communicated upon request.
#### These are mainly large houses and villas. 
#### Since they do not have price as data, these listings are not useful for analysis and they were excluded

```sql
-- Removed the ads that contain "auf Anfrage" in the price column

DELETE FROM haus_kaufen
WHERE kaufpreis REGEXP '^[^0-9]+$';
```
```sql
-- Converted the values in the column "kaufpreis" as float

ALTER TABLE `immo_köln`.`haus_kaufen` 
CHANGE COLUMN `kaufpreis` `kaufpreis` FLOAT NULL DEFAULT NULL ;
```

### e. Dealing with outliers
```sql
-- Checked the value range of the living area

SELECT 
    MIN(wohnfläche) as min_wf,
    MAX(wohnfläche) as max_wf
FROM haus_kaufen
```
| min_wf | max_wf |
|--------|--------|
| 1      | 3392   |

```sql
-- investigated the ad with wohnfläche = 1

SELECT *
FROM haus_kaufen
WHERE wohnfläche = 1
```

| link                                   | ref_num | anzeige                                                    | wohnfläche | zimmer | grundstück | ort        | kaufpreis | kategorie        | makler               | baujahr | effizienzklasse |
|----------------------------------------|---------|------------------------------------------------------------|------------|--------|------------|------------|-----------|------------------|----------------------|---------|-----------------|
| https://www.immowelt.de/expose/28fx65r | 28fx65r | Verkaufsstart!! Neubau: Doppelhaushälfte in Köln Longerich | 1          | 5      | 211        | 50737 Köln | 569000    | Doppelhaushälfte | Rhein-Main-Ruhr-Haus |         |                 |

#### In the ad online wasn´t any information about the living area. 
#### Anyway it is written: The house listed above includes land and house.
#### It can be supposed that in the 211 sm a substantial part is for the house that has 5 rooms. 
#### Counting about 30 square meters per room we get 150 m2 for the house and the remaining 60 for the land. 
#### In this way we manage to get a more truthful value that does not negatively affect the analysis

```sql
UPDATE haus_kaufen
SET 
    wohnfläche = 150,
    grundstück = 61
WHERE 
    ref_num = "28fx65r"
```
```sql
SELECT *
FROM haus_kaufen
WHERE ref_num = "28fx65r"
```

| link                                   | ref_num | anzeige                                                    | wohnfläche | zimmer | grundstück | ort        | kaufpreis | kategorie        | makler               | baujahr | effizienzklasse |
|----------------------------------------|---------|------------------------------------------------------------|------------|--------|------------|------------|-----------|------------------|----------------------|---------|-----------------|
| https://www.immowelt.de/expose/28fx65r | 28fx65r | Verkaufsstart!! Neubau: Doppelhaushälfte in Köln Longerich | 150        | 5      | 61         | 50737 Köln | 569000    | Doppelhaushälfte | Rhein-Main-Ruhr-Haus |         |                 |

```sql
-- Checked the value range of the rooms

SELECT zimmer, 
    count(zimmer) as n_ads
FROM haus_kaufen
GROUP BY zimmer
ORDER BY zimmer DESC
```

| zimmer | n_ads |
|--------|-------|
| N/A    | 72    |
| 90     | 1     |
| 9      | 9     |
| 8      | 32    |
| 72     | 1     |
| 7      | 26    |
| 6      | 59    |
| 5      | 78    |
| 4      | 76    |
| 34     | 1     |
| 3      | 16    |
| 25     | 1     |
| 24     | 1     |
| 23     | 1     |
| 20     | 1     |
| 2      | 3     |
| 18     | 5     |
| 17     | 4     |
| 16     | 4     |
| 15     | 6     |
| 14     | 3     |
| 13     | 1     |
| 12     | 5     |
| 11     | 6     |
| 10     | 15    |
| ...    | ...   |

```sql
-- Selected the ads with the highest number of rooms
SELECT *
FROM haus_kaufen
WHERE zimmer = 90 OR zimmer = 72
```

| link                                   | ref_num | anzeige                                                                               | wohnfläche | zimmer | grundstück | ort        | kaufpreis | kategorie        | makler                            | baujahr | effizienzklasse |
|----------------------------------------|---------|---------------------------------------------------------------------------------------|------------|--------|------------|------------|-----------|------------------|-----------------------------------|---------|-----------------|
| https://www.immowelt.de/expose/2cvfz5d | 2cvfz5d | Wohnanlage mit 24 WE in guter Lage                                                    | 1604       | 72     | 2576       | 51147 Köln | 5750000   | Wohnanlage       | Select Immobiliengesellschaft mbH | 1973    |                 |
| https://www.immowelt.de/expose/22ul85z | 22ul85z | NEUE PLANUNG: Demnächst 30-Familienhaus mit TG-Stellplätzen zu Topkonditionen in Porz | 2500       | 90     | 3000       | 51145 Köln | 9000000   | Mehrfamilienhaus | Emlak AG                          | 2024    |                 |

#### From the description in the ad it seems reasonable to think that the room data entered is correct.
#### In the first case it is the sale of a housing complex of 24 apartments, in the second case the complex has 30 apartments (average of 3 apartments each)

```sql
-- Checking if in the column ort there are only postal codes of Cologne (doesn´t start with 5)

SELECT *
FROM haus_kaufen
WHERE ort NOT LIKE '5%';
```

| link                                   | ref_num | anzeige                                              | wohnfläche | zimmer | grundstück | ort            | kaufpreis | kategorie       | makler               | baujahr | effizienzklasse |
|----------------------------------------|---------|------------------------------------------------------|------------|--------|------------|----------------|-----------|-----------------|----------------------|---------|-----------------|
| https://www.immowelt.de/expose/2ahtz5e | 2ahtz5e | Wunderschönes Einfamilienhaus für die ganze Familie! | 210        | 5      | 85         | 38020 Pralongo | 340000    | Einfamilienhaus | zamm Immobilien GmbH | 1974    |                 |

```sql
-- The ads refers to a property in Italy. It can be deleted 
DELETE 
FROM haus_kaufen
WHERE ref_num = "2ahtz5e"
```
```sql
-- Checked the range of the house prices
SELECT 
    min(kaufpreis) as min_price,
    max(kaufpreis) as max_price
FROM haus_kaufen
```

| min_price | max_price |
|-----------|-----------|
| 2259      | 13450000  |

```sql
-- The minimum value of the column price seems to be too low for an house
-- Selected the to wich it refers

SELECT *
FROM haus_kaufen
WHERE kaufpreis = 2259
```

| link                                   | ref_num | anzeige                                                                                   | wohnfläche | zimmer | grundstück | ort        | kaufpreis | kategorie            | makler        | baujahr | effizienzklasse |
|----------------------------------------|---------|-------------------------------------------------------------------------------------------|------------|--------|------------|------------|-----------|----------------------|---------------|---------|-----------------|
| https://www.immowelt.de/expose/2btmy5d | 2btmy5d | PVC Containerüberdachung in Weiß Quadratmeter 36m^2 Autogarage, Holzlager, Viehunterstand | 36         | 1      | 36         | 50670 Köln | 2259      | Containerüberdachung | Covertop GmbH | 2023    |                 |

```sql
-- The ads refers to a PVC container of 36 sm that can be used as garage or wood storage
-- The announcement is not inherent to the analysis being conducted, so it has been deleted

DELETE
FROM haus_kaufen
WHERE ref_num = "2btmy5d"
```
```sql
-- Get deep in the search of outliers, selecting all ads whose price is below 100.000 €

SELECT *
FROM haus_kaufen
WHERE kaufpreis < 100000
```

| link                                   | ref_num | anzeige                                                                                                               | wohnfläche | zimmer | grundstück | ort        | kaufpreis | kategorie      | makler        | baujahr | effizienzklasse |
|----------------------------------------|---------|-----------------------------------------------------------------------------------------------------------------------|------------|--------|------------|------------|-----------|----------------|---------------|---------|-----------------|
| https://www.immowelt.de/expose/2bdjy5d | 2bdjy5d | Rundbogenhalle mit PVC Plane in Grün Quadratmeterfläche - 91,50m^2 - Tierstall, Industriehalle, Waren/Holz/Strohlager | 92         | 1      | 92         | 50674 Köln | 5293      | Rundbogenhalle | Covertop GmbH | 2023    |                 |

```sql
-- Deleted the ad found

DELETE
FROM haus_kaufen
WHERE ref_num = "2bdjy5d"
```
```sql
-- Checked the categorie column

SELECT kategorie
FROM haus_kaufen
GROUP BY kategorie
```
| kategorie               |
|-------------------------|
| Reihenendhaus           |
| Reihenmittelhaus        |
| Mehrfamilienhaus        |
| Doppelhaushälfte        |
| Einfamilienhaus         |
| Stadthaus               |
| Wohnanlage              |
| Bungalow                |
| Wohn- und Geschäftshaus |
| Villa                   |
| Herrenhaus              |
| Grundstück              |
| Reiheneckhaus           |

