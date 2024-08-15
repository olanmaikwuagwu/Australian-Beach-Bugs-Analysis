 
    -----------------------------------Data Cleaning----------------------------------------------------------------------
    
    --------------- Select all data from the table and check for null values-----------
    SELECT * FROM rain_temp_beachbugs;
    
    ------------Remove NA values and modify beachbugs as Integer, rain_mm as Decimal-----------------

DELETE FROM rain_temp_beachbugs WHERE beachbugs = 'NA';
ALTER TABLE rain_temp_beachbugs MODIFY COLUMN beachbugs INT(5);

UPDATE rain_temp_beachbugs SET rain_mm = '0' WHERE rain_mm NOT REGEXP '^-?[0-9]+(\.[0-9]+)?$';
ALTER TABLE rain_temp_beachbugs MODIFY COLUMN rain_mm DECIMAL(5, 2);
    
    -------------------------------------------Feature Engineering ------------------------------------------------------------------------------------------------
   --------------------------------------Extract dayname from date ----------------------------------------------------------------------------------------------
   SELECT date,
    DAYNAME(date) as day_names
    FROM rain_temp_beachbugs;
    
    ALTER TABLE rain_temp_beachbugs ADD COLUMN day_names VARCHAR(10);
    
    UPDATE rain_temp_beachbugs
    SET day_names = DAYNAME(date);
    
    ---------------------------------------------------Extract Monthname from date -------------------------------------------------------------------------------------------
       SELECT date,
    MONTHNAME(date) as month_names
    FROM rain_temp_beachbugs;
    
    ALTER TABLE rain_temp_beachbugs ADD COLUMN month_names VARCHAR(10);
    
    UPDATE rain_temp_beachbugs
    SET month_names = MONTHNAME(date);
    
	SELECT date,
    YEAR(date) as years
    FROM rain_temp_beachbugs;
    
     ALTER TABLE rain_temp_beachbugs ADD COLUMN years INT(10);
     
	UPDATE rain_temp_beachbugs
    SET years = YEAR(date);
    
    ---------------------Group rainfall as low, moderate, and heavy by site, region and council and creating a new column------------------
    SELECT
    rain_mm,
    CASE
    WHEN rain_mm BETWEEN  0 AND 2.5 THEN "Low"
    WHEN rain_mm BETWEEN 2.6 AND 7.6 THEN "Moderate"
    WHEN rain_mm BETWEEN 7.7 AND 50 THEN "Heavy"
    ELSE "Violent"
    END AS rain
    FROM rain_temp_beachbugs;
    
    ALTER TABLE rain_temp_beachbugs ADD COLUMN rain_density VARCHAR(14);
  
  ------------- Since there are some NA values in the rain_mm column, we include the 'invalid' option in the case statement-----------
  
   UPDATE rain_temp_beachbugs
   SET rain_density = (CASE
    WHEN rain_mm NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$' THEN 'Invalid'
    WHEN rain_mm BETWEEN  0 AND 2.5 THEN "Low"
    WHEN rain_mm BETWEEN 2.6 AND 7.6 THEN "Moderate"
    WHEN rain_mm BETWEEN 7.7 AND 50 THEN "Heavy"
    ELSE "Violent"
    END);
    
ALTER TABLE rain_temp_beachbugs DROP COLUMN rain_densities;
ALTER TABLE rain_temp_beachbugs DROP COLUMN rain_density;

-----------------------------------Data Exploration-------------------------------------------------------------

------------------Summary statistics for all the beaches in the dataset----------------------
SELECT 
site,
AVG(temp_airport),
AVG(lat),
AVG(beachbugs) AS mean_bugs,
MAX(beachbugs) AS max_values,
SUM(beachbugs) AS total_bugs
FROM rain_temp_beachbugs
GROUP BY site
ORDER BY total_bugs DESC;

--------------------------------------What is the worst beach affected with beachbugs overall?------------------------------------------------------------------

SELECT site,
SUM(beachbugs) AS bug_count
FROM rain_temp_beachbugs
GROUP BY site
ORDER BY bug_count DESC;

---------------------------------Which council does the worst job at keeping their beaches clean?------------------------------------------
SELECT council,
SUM(beachbugs) AS total
FROM rain_temp_beachbugs
GROUP BY council
ORDER BY total DESC;


-------------------------------Which beach has the highest recorded value for the beachbugs bacteria?-----------------------------------------------
SELECT 
site,
day_names,
beachbugs
FROM rain_temp_beachbugs
WHERE beachbugs != "NA"
ORDER BY beachbugs DESC;

------------------------------------Does Coogee or Bondi have more extreme bacteria levels? ----------------------------------------------
SELECT 
site,
beachbugs
FROM rain_temp_beachbugs
WHERE site = "Coogee Beach" OR site = "Bondi Beach"
ORDER BY beachbugs DESC;

-------------------------------------OR get the summary of bacteria on both beaches-------------------------------------------------------
SELECT 
site,
AVG(beachbugs) AS mean_bugs,
MAX(beachbugs) AS max_values,
SUM(beachbugs) AS total_bugs
FROM rain_temp_beachbugs
WHERE site = "Coogee Beach" OR site = "Bondi Beach"
GROUP BY site
ORDER BY total_bugs DESC;


--------------------------------Which month and year recorded the highest and lowest amounts of bacteria?------------------------------------
SELECT 
month_names,
years,
SUM(beachbugs) AS total_bacteria,
AVG(rain_mm),
AVG(temp_airport) AS Avg_temp
FROM rain_temp_beachbugs
GROUP BY month_names, years
ORDER BY  total_bacteria DESC;

SELECT
day_names,
COUNT(*) AS number_of_days
FROM rain_temp_beachbugs
GROUP BY day_names
ORDER BY number_of_days DESC;

SELECT
month_names,
COUNT(*) AS number_of_months,
SUM(beachbugs) AS total_bacteria
FROM rain_temp_beachbugs
GROUP BY month_names
ORDER BY total_bacteria DESC;


--------------------------------------------Which days have the maximum and minimum bacteria count?----------------------------------------------------------------
SELECT day_names,
MAX(beachbugs) AS maxi,
MIN(beachbugs),
AVG(beachbugs)
FROM rain_temp_beachbugs
GROUP BY day_names
ORDER BY maxi DESC;

SELECT day_names,
AVG(temp_airport),
SUM(beachbugs) AS overall
FROM rain_temp_beachbugs
GROUP BY day_names
ORDER BY overall DESC;

----------------------------------Which beaches have a bacteria count greater than the average?---------------------------------------------
SELECT
site,
SUM(beachbugs) AS total_bugs
FROM rain_temp_beachbugs
GROUP BY site
HAVING SUM(beachbugs) > (SELECT
AVG(beachbugs)
FROM rain_temp_beachbugs);
