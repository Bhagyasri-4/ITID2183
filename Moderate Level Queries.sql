-Q1: Customers who listen to Rock music
SELECT DISTINCT c.email, c.first_name, c.last_name
FROM customer c
JOIN invoice i  ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id::int = il.invoice_id::int
JOIN track t ON il.track_id::int = t.track_id::int
JOIN genre g ON t.genre_id::int = g.genre_id::int
WHERE g.name = 'Rock';

Q2: Top 10 rock artists by track count
SELECT a.artist_id, a.name, COUNT(t.track_id) AS track_count FROM artist a
JOIN album al ON a.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id, a.name
ORDER BY track_count DESC


Q3: Tracks longer than average
SELECT name, milliseconds FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) FROM track
);
