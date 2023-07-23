                                                  -- DATA INSIGHTS --




SELECT 
    *
FROM
    major_info;
    
    
    
-- MOST OPTED MAJOR --
SELECT 
    major_code, major, major_category, opted_by
FROM
    major_info
ORDER BY opted_by DESC;
    -- limit 10 ;
    
    
    
-- LEAST OPTED MAJOR -- 
SELECT 
    major_code, major, major_category, opted_by
FROM
    major_info
ORDER BY opted_by ;
-- limit 10;



-- EMPLOYMENT RATE OF MAJORS --
SELECT 
    major,
    major_category,
    opted_by,
    employed,
    unemployed,
    ROUND((employed / (employed + unemployed)) * 100,
            3) AS employment_rates
FROM
    major_info
ORDER BY employment_rates DESC;



-- EMPLOYMENT RATE BY MAJOR CATEGORY --
SELECT 
    major_category,
    ROUND(AVG(employed / (employed + unemployed)) * 100,
            3) AS employment_rates
FROM
    major_info
GROUP BY major_category
ORDER BY 2 DESC;



-- GENDER DISTRIBUTION BY MAJOR CATEGORY --
SELECT 
    mi.major_category,
    si.gender,
    COUNT(si.gender) AS total_students
FROM
    major_info mi
        JOIN
    student_information si ON si.major = mi.Major
GROUP BY si.gender , mi.Major_category ;



-- MAJORS WITH HIGHEST UNEMPLOYMENT RATES --
SELECT 
    major,
    major_category,
    opted_by,
    employed,
    unemployed,
    ROUND(unemployed / (employed + unemployed) * 100,
            3) as unemployment_rates
FROM
    major_info
ORDER BY 6 DESC
;



-- MAJOR SELECTTION BY GENDER --
SELECT 
    mi.major, si.gender, COUNT(si.gender) AS total_students
FROM
    major_info mi
        JOIN
    student_information si ON si.major = mi.Major
GROUP BY si.gender , mi.Major
ORDER BY mi.major;



-- EMPLOYMENT RATES BY MAJOR CATEGORY AND GENDER --
SELECT 
    m.major_category,
    s.gender,
    ROUND(AVG(employed / (employed + unemployed)) * 100,
            3) AS average_employment_rate
FROM
    major_info AS m
        JOIN
    student_information AS s ON m.major = s.major
GROUP BY m.major_category , s.gender
ORDER BY 3 DESC;
 


-- EMPLOYMENT INFORMATION--
SELECT 
    FORMAT(SUM(opted_by), 0) AS total_students,
    FORMAT(SUM(employed), 0) AS employed,
    FORMAT(SUM(unemployed), 0) AS unemployed,
    ROUND(SUM(employed) / (SUM(employed) + SUM(unemployed)) * 100,
            3) AS employment_rate
FROM
    major_info;



-- MAJOR'S SELECTION CHANGE OVER A DECADE --
SELECT 
    *
FROM
    ten_year_trend_change_college_major;



-- NO OF MAJOR IN EVERY CATEGORY --
SELECT 
    MAJOR_CATEGORY, COUNT(MAJOR) AS TOTAL_NO_OF_MAJORS
FROM
    MAJOR_INFO
GROUP BY MAJOR_CATEGORY;

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

-- VIEWS --

-- MOST OPTED MAJOR --
create view most_opted_major as (
SELECT 
    major_code, major, major_category, opted_by
FROM
    major_info
ORDER BY opted_by DESC);

SELECT * FROM university_dataset.most_opted_major;



-- LEAST OPTED MAJOR -- 
CREATE VIEW LEAST_OPTED_MAJOR AS(
SELECT 
    major_code, major, major_category, opted_by
FROM
    major_info
ORDER BY opted_by );

SELECT * FROM university_dataset.least_opted_major;



-- EMPLOYMENT RATE OF MAJORS --
CREATE VIEW EMPLOYMENT_RATE_OF_MAJORS AS (
SELECT 
    major,
    major_category,
    opted_by,
    employed,
    unemployed,
    ROUND((employed / (employed + unemployed)) * 100,
            3) AS employment_rates
FROM
    major_info
ORDER BY employment_rates DESC);

SELECT * FROM university_dataset.employment_rate_of_majors;



-- GENDER DISTRIBUTION BY MAJOR CATEGORY --
CREATE VIEW GENDER_DISTRIBUTION_BY_MAJOR_CATEGORY AS (
SELECT 
    mi.major_category,
    si.gender,
    COUNT(si.gender) AS total_students
FROM
    major_info mi
        JOIN
    student_information si ON si.major = mi.Major
GROUP BY si.gender , mi.Major_category );

SELECT * FROM university_dataset.gender_distribution_by_major_category;




-- MAJORS WITH HIGHEST UNEMPLOYMENT RATES --
CREATE VIEW MAJOR_WITH_HIGHEST_UNEMPLOYMENT_RATES AS (
SELECT 
    major,
    major_category,
    opted_by,
    employed,
    unemployed,
    ROUND(unemployed / (employed + unemployed) * 100,
            3) as unemployment_rates
FROM
    major_info
ORDER BY 6 DESC)
;

SELECT * FROM university_dataset.major_with_highest_unemployment_rates;




-- EMPLOYMENT INFORMATION--
CREATE VIEW EMPLOYMENT_INFORMATION AS (
SELECT 
    FORMAT(SUM(opted_by), 0) AS total_students,
    FORMAT(SUM(employed), 0) AS employed,
    FORMAT(SUM(unemployed), 0) AS unemployed,
    ROUND(SUM(employed) / (SUM(employed) + SUM(unemployed)) * 100,
            3) AS employment_rate
FROM
    major_info);

SELECT * FROM university_dataset.employment_information;



-- MAJOR'S SELECTION CHANGE OVER A DECADE --
CREATE VIEW MAJORS_SELECTION_CHANGE_OVER_DECADE AS (
SELECT 
    *
FROM
    ten_year_trend_change_college_major);
    
SELECT * FROM university_dataset.majors_selection_change_over_decade;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- STORED PROCEDURE --

delimiter $$
CREATE procedure employment_statistics_for_major (in p_major text)
begin
    (SELECT 
        major_code,
        major,
        major_category,
        opted_by,
        employed,
        unemployed,
        ROUND(AVG(employed / (employed + unemployed)) * 100,
                3) AS employment_rates
    FROM
        major_info
	where p_major = major
    GROUP BY major_code , major , major_category , opted_by , employed , unemployed);
    end $$
    delimiter ;
    
call university_dataset.employment_statistics_for_major('economics');



