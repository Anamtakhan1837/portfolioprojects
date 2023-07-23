
                                          --  QUERIES ON TABLE 1 COVID_DEATHS --


SELECT 
    *
FROM
    covid_deaths;

------------------------------------------------------------------------------------------------------------------

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    covid_deaths
    order by 1;
    
-------------------------------------------------------------------------------------------------------------------
    
-- TOTAL CASES VS TOTAL DEATHS
-- DEATH PERCENTAGE(%)
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS death_percentage
FROM

    covid_deaths
ORDER BY 1;

-- FOR INDIA
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS death_percentage
FROM
    covid_deaths
WHERE
    LOCATION = 'India'
ORDER BY 1;

------------------------------------------------------------------------------------------------------------------------------

-- TOTAL CASES VS POPULATION
-- INFECTED PERCENTAGE (%)
SELECT 
    location,
    date,
    population,
    total_cases,
    ROUND((total_cases / population) * 100, 3) AS infected_in_percentage
FROM
    covid_deaths
ORDER BY 5 desc;

-- FOR INDIA
SELECT 
    location,
    date,
    population,
    total_cases,
    ROUND((total_cases / population) * 100, 3) AS infected_in_percentage
FROM
    covid_deaths
WHERE
    LOCATION = 'India'
ORDER BY 1;

-- COUNTRY WITH HIGHEST INFECTED RATE
SELECT 
    location,
    population,
    MAX(total_cases) AS highest_infection_count,
    ROUND(MAX((total_cases / population) * 100), 3) AS infected_in_percentage
FROM
    covid_deaths
GROUP BY location , population
ORDER BY 4 DESC;

----------------------------------------------------------------------------------------------------------------------

-- TOTAL DEATH COUNT PER COUNTRY
SELECT 
    location,
    sum(CONVERT( total_deaths , SIGNED)) AS highest_death_count
FROM
    covid_deaths
WHERE
    location NOT IN ('europe' , 'north america',
        'South America',
        ' africa',
        'European Union',
        'africa',
        'asia',
        'oceania')
GROUP BY location
ORDER BY highest_death_count DESC
LIMIT 15;

-------------------------------------------------------------------------------------------------------------------------

-- DEATH COUNT BY CONTINENT
SELECT 
    continent,
    MAX(CONVERT( total_deaths , SIGNED)) AS highest_death_count
FROM
    covid_deaths
WHERE
    CONTINENT IS NOT NULL AND total_deaths
GROUP BY continent
ORDER BY highest_death_count ASC
LIMIT 6;

---------------------------------------------------------------------------------------------------------------------------

-- TOTAL CASES VS TOTAL DEATHS EVERYDAY
SELECT 
    date,
    SUM(new_cases) AS total_cases,
    SUM(CONVERT( new_deaths , SIGNED)) AS total_deaths
FROM
    covid_deaths
GROUP BY date
;

-----------------------------------------------------------------------------------------------------------------------------
-- TOTAL CASES VS TOTAL DEATHS
SELECT 
    SUM(new_cases) AS total_cases,
    SUM(CONVERT( new_deaths , SIGNED)) AS total_deaths
FROM
    covid_deaths
ORDER BY 2;


 ----------------------------------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------------------------------
 
                                            -- QUERIES ON TABLE 2 COVID_VACCINATION --
                                            
                                            
					
SELECT 
    *
FROM
    covid_vaccinations;
    
------------------------------------------------------------------------------------------------------------------------------

-- JOINING THE TWO TABLES
SELECT 
    *
FROM
    covid_deaths dth
        JOIN
    covid_vaccinations vcc ON dth.location = vcc.location
        AND dth.date = vcc.date
;
-------------------------------------------------------------------------------------------------------------------------------

-- TOTAL POPULATION VS TOTAL VACCINATION
SELECT 
    dth.continent,
    dth.location,
    dth.date,
    dth.population,
    vcc.total_vaccinations,
    sum(vcc.new_vaccinations) over(partition by dth.location )
FROM
    covid_deaths dth
        JOIN
    covid_vaccinations vcc ON dth.location = vcc.location
        AND dth.date = vcc.date
        ;
--------------------------------------------------------------------------------------------------------------------------------

-- POPULATION VS VACCINATION

with popvsvac (continent, location, date, new_vaccinations, population, rolling_people_vaccinated)
as
(select 
    dth.continent,
    dth.location,
    dth.date,
    dth.population,
    vcc.total_vaccinations,
    sum(vcc.new_vaccinations) over(partition by dth.location ) as rolling_people_vaccinated
    from
        covid_deaths dth
        JOIN
    covid_vaccinations vcc ON dth.location = vcc.location
        AND dth.date = vcc.date)
        select *, (rolling_people_vaccinated/population)*100
        from popvsvac;

----------------------------------------------------------------------------------------------------------------------------
-- STRINGENCY INDEX

with stringency_index as (
select dth.location,
dth.population,
dth.total_cases,
dth.total_deaths,
vcc.stringency_index
from covid_deaths dth
join covid_vaccinations vcc on dth.location = vcc.location
order by 5 desc
)
SELECT 
location,
population,
total_cases,
total_deaths,
stringency_index
FROM stringency_index;

------------------------------------------------------------------------------------------------------------------------------------------

-- VIEWS


-- HIGHEST DEATH COUNT
drop view if exists highest_death_count;
CREATE VIEW highest_death_count AS
    (SELECT 
        location,
        MAX(CONVERT( total_deaths , SIGNED)) AS highest_death_count
    FROM
        covid_deaths
    WHERE
        location NOT IN ('europe' , 'north america',
            'South America',
            ' africa',
            'asia',
            'oceania')
    GROUP BY location
    ORDER BY highest_death_count DESC);

SELECT 
    *
FROM
    highest_death_count;






-- MOST INFECTED COUNTRIES

DROP VIEW IF EXISTS most_infected_country;
CREATE VIEW most_infected_country AS
    (SELECT 
        location, SUM(total_cases) AS infected_cases
    FROM
        covid_deaths
    GROUP BY location
    ORDER BY 2 DESC);

SELECT 
    *
FROM
    most_infected_country;





-- DEATH COUNT BY CONTINENT

drop view if exists death_count_by_continent;
CREATE VIEW death_count_by_continent AS
    (SELECT 
        continent,
        MAX(CONVERT( total_deaths , SIGNED)) AS highest_death_count
    FROM
        covid_deaths
    WHERE
        CONTINENT IS NOT NULL AND total_deaths
    GROUP BY continent
    ORDER BY highest_death_count ASC
    LIMIT 6);

SELECT 
    *
FROM
    death_count_by_continent;





-- TOTAL CASES VS TOTAL DEATHS

DROP VIEW IF EXISTS total_cases_vs_total_deaths;
create view total_cases_vs_total_deaths as
(SELECT 
    SUM(new_cases) AS total_cases,
    SUM(CONVERT( new_deaths , SIGNED)) AS total_deaths
FROM
    covid_deaths
ORDER BY 2
);

SELECT 
    *
FROM
    total_cases_vs_total_deaths;
    
------------------------------------------------------------------------------------------------------------------------------------

-- STORED PROCEDURES



-- DATA FOR A COUNTRY

DROP PROCEDURE  IF EXISTS data_for_a_country;
DELIMITER $$
create procedure data_for_a_country ( in LOCATION text)
begin
SELECT 
    *
FROM
    covid_deaths dth
WHERE
    dth.location = location;
end $$
delimiter ;

call portfolioproject.data_for_a_country('India');





-- DATA FOR A CONTINENT

drop procedure if exists data_for_a_continent;
delimiter $$
create procedure data_for_a_continent ( IN CONTINENT text)
begin 
SELECT 
    *
FROM
    covid_deaths dth
WHERE
    dth.continent = continent;
end $$
delimiter ;

call portfolioproject.data_for_a_continent('asia');
