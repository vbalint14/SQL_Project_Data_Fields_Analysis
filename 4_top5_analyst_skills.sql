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
LIMIT 5