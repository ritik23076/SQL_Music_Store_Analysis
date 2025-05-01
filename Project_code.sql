/*	Question Set 1 - Easy */

/* Q1: Who is the senior most employee based on job title? */

SELECT title, last_name, first_name 
FROM employee
ORDER BY levels DESC
LIMIT 1


/* Q2: Which countries have the most Invoices? */

SELECT COUNT(*) AS c, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY c DESC


/* Q3: What are top 3 values of total invoice? */

SELECT total 
FROM invoice
ORDER BY total DESC

---Q4.ANS
select SUM(total) as sum,billing_city 
from invoice 
group by billing_city
order by sum desc
Limit 1 

----Q5.AMS
select customer.first_name,customer.last_name,
       sum(invoice.total) as total
from customer
join invoice 
on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc limit 1

-----Q6.ANS
select DISTINCT email,first_name,last_name
from customer 
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
Select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name LIKE 'Rock'
)
order by  email

---Q7.ans

select  artist.name,count(artist.artist_id)as songs,artist.artist_id
from track
join  album on track.album_id=album.album_id
join  artist on artist.artist_id =album.artist_id
join genre on genre.genre_id = track.genre_id 
where genre.name LIKE 'Rock'

group by artist.artist_id
order by songs desc
limit 10


---Q8.ANS
select name,milliseconds
from track
where milliseconds >(
select avg(milliseconds)  
from track)
order by milliseconds desc


---Q9,ANS
with best_selling_artist As (
     Select artist.artist_id,artist.name As artist_name,
	    sum(invoice_line.unit_price*invoice_line.quantity)  as total_spent
	 from invoice_line
	 join track on invoice_line.track_id = track.track_id
	 join album on album.album_id = track.album_id
	 join artist on artist.artist_id = album.artist_id
	 group by 1
	 order by 3 desc 
	 limit 3 
)

Select c.customer_id,c.first_name,c.last_name,bsa.artist_name,SUM(il.unit_price*il.quantity) AS amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album a on a.album_id =t.album_id
join best_selling_artist bsa on bsa.artist_id = a.artist_id
group by 1,2,3,4
order by 5 desc
limit 5 



---Q10.ANS
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre 

---OR HE solution giiven below 

SELECT DISTINCT ON (customer.country) 
       customer.country, 
       genre.name, 
       COUNT(invoice_line.quantity) AS purchases
FROM invoice_line 
JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
GROUP BY customer.country, genre.name
ORDER BY customer.country, COUNT(invoice_line.quantity) DESC;




