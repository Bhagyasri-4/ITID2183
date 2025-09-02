Q1: Most senior employee
SELECT *FROM employee ORDER BY levels DESC
LIMIT 1;

Q2: Countries with most invoices
SELECT billing_country, COUNT(*) AS invoice_count FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;

Q3: Top 3 invoice totals
SELECT invoice_id, total FROM invoice
ORDER BY total DESC


Q4: City with highest total invoice amount
SELECT billing_city, SUM(CAST(total AS NUMERIC)) AS total_amount
FROM invoice
GROUP BY billing_city
ORDER BY total_amount DESC;


Q5: Customer who spent the most
SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total::numeric) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC


