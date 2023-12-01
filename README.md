# Houses and Apartments in Cologne - SQL Analysis

The following project is carried out used different datasets, obtained by webscraping the real estate ads of houses and apartments, for sale and for rent, in the city of Cologne, Germany (date 10.11.2023).
The CSV files obtained are:
1. haus_kaufen: that is, the list of houses for sale
2. haus_kaufen_anz: i.e., the list of houses for sale with information about the type of sale (e.g., whether at auction)
3. wohnung_kaufen: i.e., the list of apartments for sale
4. wohnung_kaufen_anz: i.e., the list of apartments for sale with information about the type of sale (e.g., if at auction)
5. haus_mieten: that is, the list of houses for rent
5. wohnung_mieten: i.e., the list of apartments for rent

# Data cleaning

The process was done with mySQL, on the csv files.
To take a view of the steps performed, see:
[Data Cleaning](https://github.com/vitocaputo/Cologne_RealEstate_SQL-Analysis/tree/9196b898cee6da9db5d9f9169d0d70be56ea7a6e/Data%20Cleaning)

Below is the information about the columns contained in the datasets, useful for analysis.

For the house in sale ads:
- Anzeige: ad title
- Wohnfläche: living area in square meters
- Grundstück: plot area in square meters
- Zimmer: number of rooms
- ort: location, neighborhood with postal code
- kaufpreis: sale price
- kategorie: house category
- makler: real estate agency
- baujahr: year of construction
- effizienzklasse: efficiency class

For the apartments in sale ads:
- hausgeld: condo fees
- wohnungslage: floor

For the rent ads:
- kaltmiete: rent price without ancillary costs
- nebenkosten: additional costs for taxes, water, heating (when not separatly indicated)
- heizkosten: heating costs
- kaution: caution

# Analysis

The Analysis is generally oriented toward finding the areas where it is most convenient to buy or rent houses or apartments in Cologne. 
[Analysis](https://github.com/vitocaputo/Cologne_RealEstate_SQL-Analysis/blob/9196b898cee6da9db5d9f9169d0d70be56ea7a6e/Analysis.md)

# Visualization

Finally was made a visualization map in Tableau to easily search the ads trough the Cologne neighborhoods.
Link to the Tableau work: [Houses&Apartments_Cologne](https://public.tableau.com/app/profile/vito.caputo/viz/Housesandapartments_Cologne/Dashboard)

![image](https://github.com/vitocaputo/Cologne_Real_Estate_SQL_Analysis/assets/149478650/4b112a7a-987d-492c-8a06-1a09bec24b51)





  
