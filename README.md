###### [Venter Bálint](https://github.com/vbalint14), 2024.06.28.
# Data Fields Analysis Project Documentation 
This document provides a step-by-step explanation of seven SQL queries used for analyzing job postings data. The source of the dataset was [**Luke Barousse**](https://github.com/lukebarousse).

## Query 1: Top 10 Companies by Job Postings
#### Query code:
```sql
SELECT name,
    COUNT(company_dim.company_id) AS postings_count
FROM company_dim
INNER JOIN job_postings_fact 
ON company_dim.company_id=job_postings_fact.company_id
GROUP BY company_dim.name
ORDER BY postings_count DESC
LIMIT 10;
```
#### Query result:
| Name                | Postings Count |
|---------------------|----------------|
| Emprego             | 6661           |
| Booz Allen Hamilton | 2890           |
| Dice                | 2825           |
| Harnham             | 2551           |
| Insight Global      | 2254           |
| Citi                | 2186           |
| Confidenziale       | 2039           |
| Capital One         | 1983           |
| Listopro            | 1973           |
| Robert Half         | 1863           |
#### Explanation:
- This query retrieves the top 10 companies with the highest number of job postings.
- It joins company_dim with job_postings_fact on company_id.
- It groups the results by company name and counts the number of postings per company.
- The results are ordered in descending order of the count and limited to 10 records

## Query 2: Top 10 Data Analyst Jobs by Salary
#### Query code:
```sql
SELECT company_dim.name, job_title, salary_year_avg
FROM job_postings_fact
LEFT JOIN company_dim
ON job_postings_fact.company_id=company_dim.company_id
WHERE salary_year_avg IS NOT NULL
AND job_title_short='Data Analyst'
ORDER BY salary_year_avg DESC
LIMIT 10;
```
#### Query result:
| Name                            | Job Title                                                            | Salary Year Avg |
|---------------------------------|----------------------------------------------------------------------|-----------------|
| Mantys                          | Data Analyst                                                         | 650000.0        |
| ЛАНИТ                           | Data base administrator                                              | 400000.0        |
| Citigroup, Inc                  | Head of Infrastructure Management & Data Analytics - Financial...    | 375000.0        |
| Illuminate Mission Solutions    | HC Data Analyst, Senior                                              | 375000.0        |
| Illuminate Mission Solutions    | Sr Data Analyst                                                      | 375000.0        |
| Torc Robotics                   | Director of Safety Data Analysis                                     | 375000.0        |
| Anthropic                       | Data Analyst                                                         | 350000.0        |
| Care.com                        | Head of Data Analytics                                               | 350000.0        |
| Meta                            | Director of Analytics                                                | 336500.0        |
| OpenAI                          | Research Scientist                                                   | 285000.0        |

#### Explanation:
- This query retrieves the top 10 Data Analyst job postings by average annual salary.
- It performs a left join between job_postings_fact and company_dim on company_id.
- It filters the results to include only those with a non-null salary and the job title 'Data Analyst'.
- The results are ordered in descending order of average salary and limited to 50 records.

## Query 3: Average Salary by Data Job Categories
#### Query code:
```sql
WITH job_categories AS (
    SELECT 
        CASE
            WHEN job_title_short LIKE '%Data%Analyst%' THEN 'Data Analyst'
            WHEN job_title_short LIKE '%Data%Scientist%' THEN 'Data Scientist'
            WHEN job_title_short LIKE '%Data%Engineer%' THEN 'Data Engineer'
        END AS data_field,
        salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
    WHERE salary_year_avg IS NOT NULL
)
SELECT 
    data_field,
    ROUND(AVG(salary_year_avg),0) AS field_avg
FROM job_categories
WHERE data_field IS NOT NULL
GROUP BY data_field
ORDER BY field_avg DESC;
```
#### Query result:
| Data Field      | Field Avg |
|-----------------|-----------|
| Data Scientist  | 139943    |
| Data Engineer   | 134341    |
| Data Analyst    | 97348     |
#### Explanation:
- This query calculates the average annual salary for different data job categories.
- It creates a common table expression (CTE) job_categories to categorize job titles into 'Data Analyst', 'Data Scientist', and 'Data Engineer'.
- It filters out records with null salaries.
- The main query calculates the average salary for each category, rounding to the nearest whole number.
- It groups by job category and orders the results by average salary in descending order.

## Query 4: Top 5 Skills for Data Analysts
#### Query code:
```sql
SELECT DISTINCT skills, 
    COUNT(skills_dim.skill_id) AS skill_count
FROM skills_dim
INNER JOIN skills_job_dim 
ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE skills_job_dim.job_id IN
    (SELECT job_id
    FROM job_postings_fact
    LEFT JOIN company_dim
    ON job_postings_fact.company_id=company_dim.company_id
    WHERE salary_year_avg IS NOT NULL
    AND job_title_short='Data Analyst')
GROUP BY skills
ORDER BY skill_count DESC
LIMIT 5;
```
#### Query result:
| Skills  | Skill Count |
|---------|-------------|
| SQL     | 3083        |
| Excel   | 2143        |
| Python  | 1840        |
| Tableau | 1659        |
| R       | 1073        |
#### Explanation:
- This query identifies the top 5 skills required for Data Analyst positions.
- It joins skills_dim with skills_job_dim on skill_id.
- It filters job postings to include only those with non-null salaries and the job title 'Data Analyst'.
- It groups by skill and counts the occurrences of each skill.
- The results are ordered by skill count in descending order and limited to 5 records.

## Query 5: Job Postings and Salaries in Hungary and Austria
#### Query code:
```sql
SELECT job_country, 
    COUNT(job_country) postings_count,
    ROUND(MIN(salary_year_avg),0) AS min_annual_salary,
    ROUND(MAX(salary_year_avg),0) AS max_annual_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
AND job_title LIKE '%Data%'
AND (job_country='Hungary' OR job_country='Austria')
GROUP BY job_country
ORDER BY postings_count DESC;
```
#### Query result:
| Job Country | Postings Count | Min Annual Salary | Max Annual Salary |
|-------------|-----------------|-------------------|-------------------|
| Hungary     | 50              | 49567             | 157500            |
| Austria     | 15              | 53014             | 165000            |
#### Explanation:
- This query retrieves job postings and salary ranges for data-related jobs in Hungary and Austria.
- It filters the job postings to include only those with non-null salaries and job titles containing 'Data'.
- It further filters the results to include only postings from Hungary and Austria.
- It groups the results by country and calculates the count of postings, minimum, and maximum annual salary for each country.
- The results are ordered by the count of postings in descending order.

## Query 6: Job Postings by Quarter
#### Query code:
```sql
SELECT
CASE
    WHEN EXTRACT(MONTH FROM job_posted_date) BETWEEN 1 AND 3 THEN 'first'
    WHEN EXTRACT(MONTH FROM job_posted_date) BETWEEN 4 AND 6 THEN 'second'
    WHEN EXTRACT(MONTH FROM job_posted_date) BETWEEN 7 AND 9 THEN 'third'
    WHEN EXTRACT(MONTH FROM job_posted_date) BETWEEN 10 AND 12 THEN 'fourth'
END AS year_quarters,
    COUNT(job_id) AS postings_count
FROM job_postings_fact
GROUP BY year_quarters
ORDER BY postings_count DESC;
```
#### Query result:
| Year Quarters | Postings Count |
|---------------|-----------------|
| First         | 220984          |
| Third         | 201355          |
| Fourth        | 188697          |
| Second        | 176650          |
#### Explanation:
- This query groups job postings by the quarter of the year they were posted.
- It uses a CASE statement to categorize months into four quarters.
- It counts the number of job postings in each quarter.
- The results are ordered by the count of postings in descending order.

## Query 7: Date with Highest Job Postings
#### Query code:
```sql
SELECT job_posted_date::DATE AS date,
COUNT(job_id) AS postings_count
FROM job_postings_fact
GROUP BY date
ORDER BY postings_count DESC
LIMIT 1;
```
#### Query result:
| Date       | Postings Count |
|------------|-----------------|
| 2023-01-04 | 4003            |
#### Explanation:
- This query identifies the date with the highest number of job postings.
- It converts the job_posted_date to a date format.
- It groups the results by date and counts the number of postings for each date.
- The results are ordered by the count of postings in descending order and limited to 1 record to get the date with the highest postings.
