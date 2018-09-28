USE sakila;

SELECT * from actor;

--1a
SELECT first_name, last_name FROM actor;

--1b
SELECT CONCAT(first_name, " ", last_name) AS "Actor Name" 
FROM actor;

--2a
select actor_id, first_name, last_name from actor
where first_name = 'JOE';

--2b
select first_name, last_name from actor
where last_name like '%GEN%';

--2c
select first_name, last_name from actor
where last_name like '%LI%'
order by last_name, first_name;

--2d
select country_id, country from country
where country  in ('Afghanistan', 'Bangladesh', 'China');

--3a
alter table actor
add description blob;

--3b
alter table actor
drop column description;

--4a
select last_name, count(last_name) from actor
group by last_name;

--4b, c, and d
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO';

update actor
set first_name = 'GROUCHO'
where first_name = 'HARPO';

--5a
show create table address;

--6a
select s.first_name, s.last_name, s.address_id, a.address
from staff s
inner join address a
on (s.address_id = a.address_id);


--6b
select s.first_name, s.last_name, sum(amount) as 'Total'
from payment p
join staff s
on (s.staff_id = p.staff_id)
where payment_date like '%2005-08%'
group by p.staff_id;

--6c
select f.title, count(actor_id) as 'Actor Count'
from film f
join film_actor fa
on (f.film_id = fa.film_id)
group by f.film_id;


--6d
select f.title, count(i.film_id) as 'count'
from inventory i
join film f
on (f.film_id = i.film_id)
where f.title = 'HUNCHBACK IMPOSSIBLE';

select * from customer;

--6e
select c.first_name, c.last_name, sum(p.amount) as 'total paid'
from customer c
join payment p
on (c.customer_id = p.customer_id)
group by c.last_name
order by c.last_name;

--7a
select f.title
from film f
join language l
on (f.language_id = l.language_id)
where f.title like 'K%' or f.title like 'Q%' and l.name = 'English';

--7b
select first_name, last_name
from actor
where actor_id in
(
select actor_id
from film_actor
where film_id in
(
select film_id
from film
where title = 'ALONE TRIP'
)
);

--7c using subquery
select first_name, last_name, email
from customer
where address_id in 
(
select address_id
from address
where city_id in 
(
select city_id
from city
where country_id in 
(
select c.country_id 
from country c
where country = 'Canada'
)
)
);

--7c using joins
select c.first_name, c.last_name, c.email
from customer c
inner join address a
on c.address_id=a.address_id
inner join city 
on city.city_id=a.city_id
inner join country
on country.country_id=city.country_id
where country = 'Canada';

--7d
select title
from film 
where film_id in
(
select film_id
from film_category
where category_id in
(
select category_id
from category
where name = 'Family'
)
);

--7e
select f.title, count(i.film_id) as 'times rented'
from film f
join inventory i
on (f.film_id = i.film_id)
group by i.film_id
order by count(i.film_id) desc;

--7f
select s.staff_id as 'store', sum(p.amount) as 'gross revenue'
from staff s
inner join payment p
on s.staff_id=p.staff_id
GROUP BY s.staff_id;

--7g
select store_id, city, country
from store s
inner join address a
on s.address_id=a.address_id
inner join city c
on a.city_id=c.city_id
inner join country co
on c.country_id=co.country_id;

--7h
select name, sum(p.amount) as 'gross revenue'
from category c
inner join film_category fc
on c.category_id=fc.category_id
inner join inventory i 
on i.film_id=fc.film_id
inner join rental r
on r.inventory_id=i.inventory_id
inner join payment p
on r.rental_id=p.rental_id
group by name
order by sum(p.amount) desc;

-- 8a
-- creating a new view:
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `category_revenue` AS
    SELECT 
        `c`.`name` AS `name`, SUM(`p`.`amount`) AS `gross revenue`
    FROM
        ((((`category` `c`
        JOIN `film_category` `fc` ON ((`c`.`category_id` = `fc`.`category_id`)))
        JOIN `inventory` `i` ON ((`i`.`film_id` = `fc`.`film_id`)))
        JOIN `rental` `r` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
        JOIN `payment` `p` ON ((`r`.`rental_id` = `p`.`rental_id`)))
    GROUP BY `c`.`name`
    ORDER BY SUM(`p`.`amount`) DESC
    LIMIT 5

-- 8b
--displaying the view:
select * from category_revenue;

--8c
-- deleting view
drop view category_revenue;
