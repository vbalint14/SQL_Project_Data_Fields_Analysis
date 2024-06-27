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