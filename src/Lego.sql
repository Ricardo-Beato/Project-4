use lego;

-- I'll have to actually create the table. Getting the information I checked in Python to help me out with the datatypes for each column:

-- 0   Set_ID            5442 non-null   object 
-- 1   Name              5442 non-null   object 
-- 2   Year              5442 non-null   int64  
-- 3   Theme             5442 non-null   object 
-- 4   Theme_Group       5441 non-null   object 
-- 5   Subtheme          4763 non-null   object 
-- 6   Category          5442 non-null   object 
-- 7   Packaging         5442 non-null   object 
-- 8   Num_Instructions  5442 non-null   int64  
-- 9   Availability      5442 non-null   object 
-- 10  Pieces            5420 non-null   float64
-- 11  Minifigures       3598 non-null   float64
-- 12  Owned             5442 non-null   float64
-- 13  Rating            5442 non-null   float64
-- 14  USD_MSRP          3612 non-null   float64
-- 15  Total_Quantity    5442 non-null   float64
-- 16  Current_Price     5442 non-null   float64

-- what are the columns that admit empty cells?
-- Set_ID                 0
-- Name                   0
-- Year                   0
-- Theme                  0
-- Theme_Group            1
-- Subtheme             679
-- Category               0
-- Packaging              0
-- Num_Instructions       0
-- Availability           0
-- Pieces                22
-- Minifigures         1844
-- Owned                  0
-- Rating                 0
-- Total_Quantity         0
-- Current_Price          0
-- dtype: int64

drop table if exists lego_sets;

CREATE TABLE lego_sets (
    Set_ID VARCHAR(255),
    Name VARCHAR(255),
    Year INT,
    Theme VARCHAR(255),
    Theme_Group VARCHAR(255),
    Subtheme VARCHAR(255) NULL,
    Category VARCHAR(255),
    Packaging VARCHAR(255),
    Num_Instructions INT,
    Availability VARCHAR(255),
    Pieces INT NULL,
    Minifigures INT NULL,
    Owned INT,
    Rating DECIMAL(3, 1), 
    Total_Quantity INT,
    Current_Price DECIMAL(10, 2));

-- so I was having loooots of trouble with the manual creation of the table so I've just used the import wizard which created a table with a space in the name:
show tables;
SELECT * FROM `lego`.`lego sets_cleaned`;

-- I'm renaming it:
RENAME TABLE `lego`.`lego sets_cleaned` TO `lego`.`lego_sets`;

use lego;
SELECT * FROM lego_sets;

-- checking how the price behaves according to some labels:
-- by year:
select Year, round(avg(Current_Price),2) as avg_price from lego_sets
group by Year
order by avg_price DESC;

-- by theme:
select Theme, round(avg(Current_Price),2) as avg_price from lego_sets
group by Theme
order by avg_price DESC;

-- interesting, what's the price interval for the Batman, The Simpsons and Stranger Things and The Lord of the Rings?
select Theme, min(Current_Price) as min_price, round(avg(Current_Price),2) as avg_price, max(Current_Price) max_price from lego_sets
where Theme in ('The Lord of the Rings', 'Batman', 'The Simpsons', 'Stranger Things')
group by Theme
order by max_price DESC;

-- now, The Stranger Things has got the same value for everything, could it be there's only one entry in our Dataset?
select Theme, count(distinct(Name)) from lego_sets 
where Theme in ('The Lord of the Rings', 'Batman', 'The Simpsons', 'Stranger Things')
group by Theme;

-- yes, unfort we were right, also the Simpsons have only got 2 entries, what a shame. 

-- what's the arrangement of the groups and subgroups?
Select Theme_group, count(distinct(Theme_group)) as number_of_theme_groups, count(distinct(Theme)) as number_of_themes, count(distinct(Subtheme)) as number_of_subthemes 
from lego_sets
group by Theme_group
order by number_of_subthemes DESC;

-- is there a correlation between rating and price?
SELECT Ratings, avg(Current_Price) as avg_price from (select
    CASE
        WHEN Rating BETWEEN 0 AND 1 THEN '0-1'
        WHEN Rating BETWEEN 1 AND 2 THEN '1-2'
        WHEN Rating BETWEEN 2 AND 3 THEN '2-3'
        WHEN Rating BETWEEN 3 AND 4 THEN '3-4'
        WHEN Rating BETWEEN 4 AND 5 THEN '4-5'
        ELSE '?'
    END AS Ratings,
    Current_Price
FROM lego_sets) as subquery1
WHERE Ratings != '0-1' -- I don't want the first cluster cause some values are non existing and where being clustered here
GROUP BY Ratings
ORDER BY Ratings ASC;

-- well, yeah, there seems to be a link between the two 



