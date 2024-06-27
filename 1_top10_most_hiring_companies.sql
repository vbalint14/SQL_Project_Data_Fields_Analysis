SELECT name ,
    COUNT(company_dim.company_id) AS postings_count
FROM company_dim
INNER JOIN job_postings_fact 
ON company_dim.company_id=job_postings_fact.company_id
GROUP BY company_dim.name
ORDER BY postings_count DESC
LIMIT 10