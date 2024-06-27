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
ORDER BY postings_count DESC