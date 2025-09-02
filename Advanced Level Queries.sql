 Q1: Customer spend per artist
WITH artist_sales AS (
    SELECT il.invoice_id::int,
           t.album_id,
           SUM(il.unit_price::numeric * il.quantity::int) AS sales
    FROM invoice_line il
    JOIN track t ON il.track_id::int = t.track_id
    GROUP BY il.invoice_id, t.album_id
)
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       a.name AS artist,
       SUM(asl.sales) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN artist_sales asl ON i.invoice_id::int = asl.invoice_id
JOIN album al ON asl.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.name
ORDER BY total_spent DESC;


Q2: Most popular genre by country
WITH genre_country AS (
    SELECT c.country,
           g.name AS genre,
           COUNT(il.invoice_line_id) AS purchase_count,
           ROW_NUMBER() OVER (
               PARTITION BY c.country
               ORDER BY COUNT(il.invoice_line_id) DESC
           ) AS rnk
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id::int = il.invoice_id::int  
    JOIN track t ON il.track_id::int = t.track_id
    JOIN genre g ON t.genre_id::int = g.genre_id
    GROUP BY c.country, g.name
)
SELECT country, genre, purchase_count
FROM genre_country
WHERE rnk = 1;


Q3: Top spending customer per country
WITH customer_country AS (
    SELECT c.country,
           c.customer_id,
           c.first_name,
           c.last_name,
           SUM(i.total::numeric) AS total_spent,   -- fixed cast
           ROW_NUMBER() OVER (
               PARTITION BY c.country
               ORDER BY SUM(i.total::numeric) DESC
           ) AS rnk
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.country, c.customer_id, c.first_name, c.last_name
)
SELECT country, customer_id, first_name, last_name, total_spent
FROM customer_country
WHERE rnk = 1;

