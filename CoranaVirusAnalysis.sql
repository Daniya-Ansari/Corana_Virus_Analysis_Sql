select * from cvd
--Checking NULL values
select * from cvd where recovered is null

-- Since in this dataset we dont have any NULL values then we will skip the task of replacing NULL as 0
--Check total number of rows
SELECT COUNT(*) AS total_rows FROM cvd;

--Check start_date and end_date
SELECT 
    MIN(Date) AS start_date, 
    MAX(Date) AS end_date
FROM cvd;


--Number of months present in the dataset
SELECT 
    COUNT(DISTINCT DATEPART(YEAR, Date) * 12 + DATEPART(MONTH, Date)) AS number_of_months
FROM cvd;


--Find monthly average for confirmed, deaths, recovered
SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(CAST(Confirmed AS INT)) / COUNT(*) AS avg_confirmed,
    SUM(CAST(Deaths AS INT)) / COUNT(*) AS avg_deaths,
    SUM(CAST(Recovered AS INT)) / COUNT(*) AS avg_recovered
FROM cvd
GROUP YEAR(Date), MONTH(Date)
ORDER BY year, month;

--Find most frequent value for confirmed, deaths, recovered each month 
WITH monthly_data AS (
    SELECT
        MONTH(Date) AS month,
        Confirmed,
        Deaths,
        Recovered,
        ROW_NUMBER() OVER (PARTITION BY MONTH(Date), Confirmed ORDER BY COUNT(*) DESC) AS confirmed_rank,
        ROW_NUMBER() OVER (PARTITION BY MONTH(Date), Deaths ORDER BY COUNT(*) DESC) AS deaths_rank,
        ROW_NUMBER() OVER (PARTITION BY MONTH(Date), Recovered ORDER BY COUNT(*) DESC) AS recovered_rank
    FROM cvd
    GROUP BY MONTH(Date), Confirmed, Deaths, Recovered
)
SELECT
    month,
    MAX(CASE WHEN confirmed_rank = 1 THEN Confirmed END) AS most_frequent_confirmed,
    MAX(CASE WHEN deaths_rank = 1 THEN Deaths END) AS most_frequent_deaths,
    MAX(CASE WHEN recovered_rank = 1 THEN Recovered END) AS most_frequent_recovered
FROM monthly_data
GROUP BY month


--Find minimum values for confirmed, deaths, recovered per year
SELECT
    YEAR(Date) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM cvd
GROUP BY YEAR(Date)
ORDER BY year;



--Find maximum values of confirmed, deaths, recovered per year
SELECT
    YEAR(Date) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM cvd
GROUP BY YEAR(Date)
ORDER BY year;


--The total number of case of confirmed, deaths, recovered each month
SELECT
    MONTH(Date) AS month,
    SUM(CAST(Confirmed AS INT)) AS total_confirmed,
    SUM(CAST(Deaths AS INT)) AS total_deaths,
    SUM(CAST(Recovered AS INT)) AS total_recovered
FROM cvd
GROUP BY MONTH(Date)
ORDER BY month;


--Check how corona virus spread out with respect to confirmed case
--With Respect to Total Confirmed Cases
SELECT
    SUM(CAST(Confirmed AS INT)) AS total_confirmed_cases
FROM cvd;

--With Respect to Standard Deviation of Confirmed Cases
SELECT
    STDEV(CAST(Confirmed AS INT)) AS std_dev_confirmed_cases
FROM cvd;

--With Respect to Average Confirmed Cases
SELECT
    AVG(CAST(Confirmed AS INT)) AS average_confirmed_cases
FROM cvd;

--Check how corona virus spread out with respect to death case per month
--With Respect to Total Confirmed Cases, Standard Deviation of Confirmed Cases and Average Confirmed Cases

SELECT
    MONTH(Date) AS month,
    SUM(CAST(Deaths AS INT)) AS total_deaths,
    AVG(CAST(Deaths AS INT)) AS average_deaths,
    STDEV(CAST(Deaths AS INT)) AS std_dev_deaths
FROM cvd
GROUP BY MONTH(Date)
ORDER BY month;


--Check how corona virus spread out with respect to recovered case
--With Respect to Total Confirmed Cases, Standard Deviation of Confirmed Cases and Average Confirmed Cases
SELECT
    SUM(CAST(Recovered AS INT)) AS total_recovered_cases,
    AVG(CAST(Recovered AS INT)) AS average_recovered_cases,
    STDEV(CAST(Recovered AS INT)) AS std_dev_recovered_cases
FROM cvd;

--Find Country having highest number of the Confirmed case
SELECT TOP 5
    Country_Region,
    MAX(CAST(Confirmed AS INT)) AS max_confirmed_cases
FROM cvd
GROUP BY Country_Region
ORDER BY max_confirmed_cases DESC;


-- Find Country having lowest number of the death case
SELECT top 5
    Country_Region,
    MIN(CAST(Deaths AS INT)) AS min_death_cases
FROM cvd
GROUP BY Country_Region
ORDER BY min_death_cases ASC;

--Find top 5 countries having highest recovered case
SELECT Top 5
    Country_Region,
    SUM(CAST(Recovered AS INT)) AS total_recovered_cases
FROM cvd
GROUP BY Country_Region
ORDER BY total_recovered_cases DESC

