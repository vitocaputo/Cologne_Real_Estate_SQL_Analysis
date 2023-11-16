select *
from haus_kaufen as hk;

-- number of null values in the column "Wohnfläche"
select 
	count(distinct anzeige) as null_wohnfläche
from 
	haus_kaufen
where wohnfläche = "";

-- selected the row with the null value in the column "Wohnfläche"
select *
from haus_kaufen
where wohnfläche = "";

-- number of null values in the column "zimmer"
select 
	count(distinct anzeige) as null_zimmer
from 
	haus_kaufen
where zimmer = "";

-- Search for room information "zimmer" in the ad
select anzeige
from 
	(select 
		anzeige
	from 
		haus_kaufen
	where 
		zimmer = "") as null_zimmer
where anzeige LIKE "%zimmer%";



-- number of null values in the column "Grundstück"
select 
	count(distinct anzeige) as null_grund
from 
	haus_kaufen
where grundstück = "";

-- number of null values in the column "kaufpreis"
select
	count(distinct anzeige) as null_kaufpreis
from 
	haus_kaufen
where
	kaufpreis = "";
    

    




-- count of the ads by house category
select
	kategorie,
    count(distinct anzeige) as count_ads
from 
	haus_kaufen
group by
	kategorie
order by
	count_ads desc;

