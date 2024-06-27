SELECT job_country, 
    COUNT(job_country) postings_count,
    ROUND(MIN(salary_year_avg),0) AS min_annual_salary,
    ROUND(MAX(salary_year_avg),0) AS max_annual_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
AND job_title LIKE '%Data%'
AND (job_country='Hungary' OR job_country='Austria')
GROUP BY job_country
ORDER BY postings_count DESC