Q1
SELECT * from employee
ORDER by levels DESC limit 1
Q2
SELECT billing_country,count(*) as tot_invoices  from invoice 
GROUP by billing_country order by tot_invoices desc;
Q3
select * from invoice
SELECT invoice.total
from invoice
ORDER by total desc limit 3
Q4
select * from invoice
SELECT billing_city, sum(total) from invoice
GROUP by billing_city ORDER by sum(total) desc
Q5
SELECT customer.customer_id,customer.first_name,customer.last_name, sum(invoice.total) from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
ORDER by sum(invoice.total) desc limit 1
Q6
SELECT distinct email, first_name,customer.last_name, genre.name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id=genre.genre_id
where genre.name like 'Rock'
order by email
Q7
select artist.artist_id, artist.name, count(artist.artist_id) as tot_songs
from artist
join album on album.artist_id = artist.artist_id
join track on track.album_id = album.album_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by tot_songs DESC
limit 10
Q8
SELECT track.name, milliseconds as  song_length
from track where milliseconds >(SELECT avg(milliseconds) as avg_song_length from track)
order by milliseconds desc
Q9
with best_selling_artist AS(
SELECT artist.artist_id,artist.name,sum(invoice_line.unit_price* invoice_line.quantity) as tot_price
from invoice_line
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by 1
order by 3 desc 
limit 1
)
SELECT c.customer_id,c.first_name, c.last_name,bsa.name,sum(invoice_line.unit_price* invoice_line.quantity) as amount_spent
from invoice
join customer c on c.customer_id = invoice.customer_id
JOIN invoice_line on invoice_line.invoice_id = invoice.invoice_id	
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join best_selling_artist bsa on bsa.artist_id=album.artist_id
group by 1,2,4
order by 5 desc;
Q10
with popular_genre as(
SELECT customer.country,genre.genre_id,genre.name, count(invoice_line.quantity) as purchases,
row_number() over(PARTITION by customer.country order by count(invoice_line.quantity) desc) as row_num
from customer
JOIN invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by customer.country,genre.genre_id,genre.name
order by customer.country asc,count(invoice_line.quantity) desc 
)
SELECT * from popular_genre
where row_num <=1
Q11
with customer_spent_countrywise as(
select customer.customer_id, customer.first_name, customer.last_name, customer.country,sum(total),
row_number() over(PARTITION by customer.country order by sum(total) DESC) as row_num
from invoice
join customer on customer.customer_id=invoice.customer_id
group by customer.customer_id,customer.first_name, customer.last_name, customer.country
order by customer.first_name, customer.last_name,country,sum(total)  DESC
)
select * from customer_spent_countrywise
where row_num<=1
order by customer_spent_countrywise.country










