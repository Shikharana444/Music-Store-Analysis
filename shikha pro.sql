/*	Question Set 1 */

/* Q1: Who is the senior most employee based on job title? */

-- SELECT title, last_name, first_name 
-- FROM employee
-- ORDER BY levels DESC
-- LIMIT 1



/* Q2: Which countries have the most Invoices? */

--select billing_country, count(invoice_id)
--from invoice
--group by billing_country
--order by 2 desc


/* Q3: What are top 3 values of total invoice? */


--select total
--from invoice
--order by total desc
--limit 3


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */


-- SELECT billing_city,SUM(total) AS InvoiceTotal
-- FROM invoice
-- GROUP BY billing_city
-- ORDER BY InvoiceTotal DESC
-- LIMIT 1


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/


--select C.customer_id, C.first_name, C.last_name, sum(I.total) AS
--total_spend
--from invoice I
--join customer C
--on I.customer_id = C.customer_id
--group by C.customer_id
--ORDER BY total_spend DESC
--LIMIT 1



/* Question Set 2 */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */


---select customer.email as Email,
--customer.first_name, customer.last_name, genre.name as Name from customer  
--left join invoice 
--on customer.customer_id = invoice.customer_id 
--left join invoice_line on invoice.invoice_id = invoice_line.invoice_id
--left join track  on invoice_line.track_id = track.track_id 
--left join genre on track.genre_id = genre.genre_id WHERE genre.name = 'Rock'
----order by email


/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */


-- Select
-- artist.artist_id, artist.name, count(track_id) as number_of_songs
-- from artist
-- left join album
-- on artist.artist_id = album.artist_id
-- left join track
-- on album.album_id = track.album_id
-- left join
-- genre
-- on track.genre_id = genre.genre_id
-- WHERE genre.name = 'Rock'
-- group by 1
-- order by 3 desc
-- limit 10


/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

-- select name, Milliseconds
-- from track
-- where Milliseconds >(
-- select avg(Milliseconds) from track)
-- order by Milliseconds desc



/* Question Set 3  */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

-- select concat(first_name, last_name), AA.name, sum(il.unit_price * il.Quantity)
-- from customer c
-- left join invoice i
-- on c.customer_id = i.customer_id
-- left join invoice_line il
-- on i.invoice_id = il.invoice_id
-- left join track t
-- on il.track_id = t.track_id
-- left join album a
-- on t.album_id = a.album_id
-- left join artist AA
-- on a.artist_id = AA.artist_id
-- group by 1, 2
-- order by 3 desc


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */


-- with a1 as(select c.country, g.Name, COUNT(il.quantity) as total_purchases,
-- dense_rank() over(partition by c.country order by COUNT(il.quantity) desc) ran
-- from genre g
-- left join track t
-- on g.genre_id = t.genre_id
-- left join invoice_line il
-- on t.track_id = il.track_id
-- left join invoice i
-- on il.invoice_id = i.invoice_id
-- left join customer c
-- on i.customer_id = c.customer_id
-- group by 1, 2)

-- select country,Name, total_purchases from a1
-- where ran = 1
-- and total_purchases > 0




/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

-- WITH A1 AS (select C.customer_id, Concat(first_name,last_name) as name, billing_country as country, sum(total) total_spent, dense_rank() over(partition by billing_country order by sum(total) DESC) rab from
-- customer c
-- left join invoice i
-- on c.customer_id = i.customer_id
-- group by 1, 2, 3)
-- select name, country, total_spent
-- from a1
-- WHERE RAB = 1
-- ORDER BY 3 DESC

-- WITH Customter_with_country AS (
-- 		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
-- 	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
-- 		FROM invoice
-- 		JOIN customer ON customer.customer_id = invoice.customer_id
-- 		GROUP BY 1,2,3,4
-- 		ORDER BY 5 DESC)
-- SELECT * FROM Customter_with_country WHERE RowNo <= 1

-- /* Method 2: Using Recursive */

-- WITH RECURSIVE 
-- 	customter_with_country AS (
-- 		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
-- 		FROM invoice
-- 		JOIN customer ON customer.customer_id = invoice.customer_id
-- 		GROUP BY 1,2,3,4
-- 		ORDER BY 2,3 DESC),

-- 	country_max_spending AS(
-- 		SELECT billing_country,MAX(total_spending) AS max_spending
-- 		FROM customter_with_country
-- 		GROUP BY billing_country)

-- SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
-- FROM customter_with_country cc
-- JOIN country_max_spending ms
-- ON cc.billing_country = ms.billing_country
-- WHERE cc.total_spending = ms.max_spending
-- ORDER BY 2 DESC;









