SELECT job_posted_date::DATE AS date,
COUNT(job_id) AS postings_count
FROM job_postings_fact
GROUP BY date
ORDER BY postings_count DESC
LIMIT 1