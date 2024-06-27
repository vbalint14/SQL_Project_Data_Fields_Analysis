SELECT company_dim.name, job_title, salary_year_avg
FROM job_postings_fact
LEFT JOIN company_dim
ON job_postings_fact.company_id=company_dim.company_id
WHERE salary_year_avg IS NOT NULL
AND job_title_short='Data Analyst'
ORDER BY salary_year_avg DESC
LIMIT 50