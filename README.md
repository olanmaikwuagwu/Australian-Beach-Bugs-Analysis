# Australian-Beach-Bugs-Analysis

## Project Overview
The aim of the project is to understand the distribution of the enterococci bacteria in 11 Australian beaches. From the analysis, we will deduce the councils with the cleanest beaches and draw some correlations between environmental factors and bacteria presence.

<img width="596" alt="BB VIZ" src="https://github.com/user-attachments/assets/b2ff0668-e296-4bd3-9ddf-f752c3fdf1f8">


## Data Source
The dataset was obtained from the NSW Office of Environment and Heritage who compiled the enterococci count between 2013 to 2018. This effort was part of the Beachwatch Water Quality Program. The csv file can be accessed [here](https://bit.ly/4fhQnHS).

  ## Tools 
  - Excel
  - MySQL
  - Microsoft Power BI

## Approach Used
- Data Wrangling: First, I inspected the dataset to detect and remove null values, clean names, and adjust date data to the appropriate format. The sequence of steps are;
  - Data loading and inspection in Excel and MySQL server.
  - Creation of a database and table
  - Filtering of missing values
 
 -  Feature Engineering: Here, I created new columns from the original dataset for a more in-depth analysis. The new columns created were:
     - day_names - to understand the correlation between days of the week and bacteria count, temperature, and rainfall.
     - month_names - to understand the relationship between months of the year, bacteria count, and environmental factors.
     - rain_density - to classify rainfall as low, medium, or heavy.
     - years - to group results by year of occurrence.

- Exploratory data analysis: Project-based questions were answered using database queries.
   - What is the summary statistics for all beaches in the dataset?
   - What is the worst beach affected with bugs overall?
   - Which council does the worst job at keeping their beaches clean?
   - Which beach has the highest recorded single value for the bugs?
   - Does Coogee or Bondi have more extreme bacteria levels?
   - Which months and years recorded the highest and lowest amounts of bacteria?
   - Which days have the maximum and minimum bacteria count?
   - Which beaches have a bacteria count greater than the average?
 
- Results: The analysis revealed the following results:
   - Malabar beach in the Randwick council has an excessive presence of the enterococci bacteria, indicating a high level of sewage pollution.
   - The Randwick council does a poor job at keeping their beaches clean compared to the Waverley council which has neater beaches.
   - Little Bay beach recorded the highest single value of bacteria in a day (sunday).
   - Coogee beach has more bacteria count than Bondi.
   - June 2013 recorded the highest bacteria count while September 2014 recorded the lowest.
   - Overall, fridays had the greatest bacteria count while saturdays had the lowest.

- Limitations: Some limitations of this dataset are;
  - The file had many missing values that would limit the accuracy of results.
  - The dataset was last compiled in 2018 so the results obtained may not reveal current situations.
     
- Recommendations:
  - Randwick council should incorporate best practices for cleaning beaches to keep swimmers safe.
  - Regions with higher latitude should be wary of high temperatures which could lead to increased bacteria count. A case in point is Little Bay.

- References: 
  - The NSW Office of Environment and Heritage.
  - RLadies
 
## Code
Click on the file for the remaining code.
```sql
----------------Create table-----------------------

CREATE TABLE IF NOT EXISTS `rain_temp_beachbugs` (
    `council` VARCHAR(16) CHARACTER SET utf8,
    `long` NUMERIC(9, 6),
    `lat` NUMERIC(8, 6),
    `date` DATETIME,
    `site` VARCHAR(23) CHARACTER SET utf8,
    `beachbugs` VARCHAR(4) CHARACTER SET utf8,
    `id` NUMERIC(3, 1),
    `region` VARCHAR(25) CHARACTER SET utf8,
    `rain_mm` VARCHAR(4) CHARACTER SET utf8,
    `temp_airport` NUMERIC(3, 1)
);
INSERT INTO `rain_temp_beachbugs` VALUES ('Randwick Council',151.267505,-33.914486,'2013-01-02 00:00:00','Clovelly Beach','19',25,'Sydney City Ocean Beaches','0',23.4),
	('Randwick Council',151.267505,-33.914486,'2013-01-06 00:00:00','Clovelly Beach','3',25,'Sydney City Ocean Beaches','0',30.3),
	('Randwick Council',151.267505,-33.914486,'2013-01-12 00:00:00','Clovelly Beach','2',25,'Sydney City Ocean Beaches','0',31.4),
	('Randwick Council',151.267505,-33.914486,'2013-01-18 00:00:00','Clovelly Beach','13',25,'Sydney City Ocean Beaches','0',46.4),
	('Randwick Council',151.267505,-33.914486,'2013-01-30 00:00:00','Clovelly Beach','8',25,'Sydney City Ocean Beaches','0.6',26.6),
	('Randwick Council',151.267505,-33.914486,'2013-02-05 00:00:00','Clovelly Beach','7',25,'Sydney City Ocean Beaches','0.1',25.7),
	('Randwick Council',151.267505,-33.914486,'2013-02-11 00:00:00','Clovelly Beach','11',25,'Sydney City Ocean Beaches','8',22.2),
	('Randwick Council',151.267505,-33.914486,'2013-02-23 00:00:00','Clovelly Beach','97',25,'Sydney City Ocean Beaches','7.2',24.8),
	('Randwick Council',151.267505,-33.914486,'2013-03-07 00:00:00','Clovelly Beach','3',25,'Sydney City Ocean Beaches','0',29.1),
	('Randwick Council',151.267505,-33.914486,'2013-03-25 00:00:00','Clovelly Beach','0',25,'Sydney City Ocean Beaches','0',25.8),
	('Randwick Council',151.267505,-33.914486,'2013-04-02 00:00:00','Clovelly Beach','6',25,'Sydney City Ocean Beaches','0',24.4),
	('Randwick Council',151.267505,-33.914486,'2013-04-12 00:00:00','Clovelly Beach','0',25,'Sydney City Ocean Beaches','0',26.1),
	('Randwick Council',151.267505,-33.914486,'2013-04-18 00:00:00','Clovelly Beach','1',25,'Sydney City Ocean Beaches','7.8',23.2),
	('Randwick Council',151.267505,-33.914486,'2013-04-24 00:00:00','Clovelly Beach','8',25,'Sydney City Ocean Beaches','0',22.9),
	('Randwick Council',151.267505,-33.914486,'2013-05-01 00:00:00','Clovelly Beach','3',25,'Sydney City Ocean Beaches','0',24.4),
	('Randwick Council',151.267505,-33.914486,'2013-05-20 00:00:00','Clovelly Beach','5',25,'Sydney City Ocean Beaches','0',20.2),
	('Randwick Council',151.267505,-33.914486,'2013-05-31 00:00:00','Clovelly Beach','0',25,'Sydney City Ocean Beaches','0',25),
	('Randwick Council',151.267505,-33.914486,'2013-06-06 00:00:00','Clovelly Beach','8',25,'Sydney City Ocean Beaches','0',21.8),
	('Randwick Council',151.267505,-33.914486,'2013-06-12 00:00:00','Clovelly Beach','2',25,'Sydney City Ocean Beaches','0',16.2),
	('Randwick Council',151.267505,-33.914486,'2013-06-24 00:00:00','Clovelly Beach','35',25,'Sydney City Ocean Beaches','55.6',15),
	('Randwick Council',151.267505,-33.914486,'2013-07-06 00:00:00','Clovelly Beach','2',25,'Sydney City Ocean Beaches','0',18.5),
	('Randwick Council',151.267505,-33.914486,'2013-07-18 00:00:00','Clovelly Beach','2',25,'Sydney City Ocean Beaches','0',23.3),
	('Randwick Council',151.267505,-33.914486,'2013-07-24 00:00:00','Clovelly Beach','57',25,'Sydney City Ocean Beaches','0',16.1),
	('Randwick Council',151.267505,-33.914486,'2013-08-08 00:00:00','Clovelly Beach','39',25,'Sydney City Ocean Beaches','10.4',13.3),
	('Randwick Council',151.267505,-33.914486,'2013-08-22 00:00:00','Clovelly Beach','0',25,'Sydney City Ocean Beaches','0',19.4),
	('Randwick Council',151.267505,-33.914486,'2013-08-29 00:00:00','Clovelly Beach','0',25,'Sydney City Ocean Beaches','0',22.8),
	('Randwick Council',151.267505,-33.914486,'2013-01-24 00:00:00','Clovelly Beach','0',25,'Sydney City Ocean Beaches','0',27.5),
	('Randwick Council',151.267505,-33.914486,'2013-02-17 00:00:00','Clovelly Beach','9',25,'Sydney City Ocean Beaches','13.6',26.3),
	('Randwick Council',151.267505,-33.914486,'2013-03-01 00:00:00','Clovelly Beach','20',25,'Sydney City Ocean Beaches','28.6',21.2),
	('Randwick Council',151.267505,-33.914486,'2013-03-13 00:00:00','Clovelly Beach','0',25,'Sydney City Ocean Beaches','0',29.4),
	('Randwick Council',151.267505,-33.914486,'2013-03-19 00:00:00','Clovelly Beach','0',25,'Sydney City Ocean Beaches','0',24.2),

```
