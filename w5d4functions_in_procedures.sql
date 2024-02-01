-- query to check out data in the payment table
select *
from payment;


create or replace procedure late_fee(
	customer INTEGER, -- customer_id
	late_payment INTEGER, -- payment_id
	late_fee_amount numeric(5,2) -- increase the amount column by this value
)
language plpgsql -- procedural language postgresql -- stores the language for the procedure for you and other developers
as $$ -- stores the actual query to the procedure, stores as a string literal to exceucte query when the procedure is called, not stored
begin 
	-- use the customer_id and payment_id to alter amount column
	update payment
	set amount = amount + late_fee_amount
	where customer_id = customer and payment_id = late_payment; -- matching the customer id to our customer argument and payment_id to the late_payment argument
end;
$$

-- calling a procedure
-- customer_id 341
-- payment_id 17503
-- late_fee_amount 2.00

call late_fee(341, 17503, 2.00);

-- query for specific payment_id for late_fee addition
select *
from payment
where payment_id = 17503;

--update payment 
--set amount = amount + 2.00
--where customer_id = 341 and payment_id = 17503

call late_fee(347, 17529, 5.00);

select *
from payment
where payment_id = 17529;

drop procedure late_fee;

-- check out actor table to see the goods
select *
from actor
order by actor_id desc;


-- Stored Functions
-- create a function to add an actor to the actor table
create or replace function add_actor(
	_actor_id INTEGER,
	_first_name VARCHAR(30),
	_last_name VARCHAR(30),
	_last_update TIMESTAMP
)
returns void -- datatype the function is going to return, its void because we're simply adding to a table
as $main$
begin
	insert into actor
	values(_actor_id, _first_name, _last_name, _last_update);
end;
$main$
language plpgsql;

-- DO NOT CALL FUNCTION SELECT THE FUNCTION -- 
select add_actor(201, 'Orlando', 'Bloom', NOW()::timestamp);

-- checking that our actor was added
select *
from actor
order by actor_id desc;

-- selecting our function again to add more actors
select add_actor(202, 'Vigo', 'Mortensen', NOW()::timestamp);
select add_actor(203, 'Elijah', 'Wood', NOW()::timestamp);
select add_actor(204, 'Sean', 'Bean', NOW()::timestamp);
select add_actor(205, 'Sir Ian', 'McKellen', NOW()::timestamp);

-- dropping a function
drop function add_actor;


select *
from payment
order by amount desc;

-- function with a returned value
-- setting return type to an integer
create or replace function get_total_rentals()
returns integer
as $$
begin 
	return (select sum(amount) from payment);
end;
$$
language plpgsql;

select get_total_rentals();

-- creating a function to return the average amount form the rental column
create or replace function avg_rental_amount()
returns decimal
as $$
begin 
	return (select avg(amount) from payment);
end;
$$
language plpgsql;

-- calling (selecting) our function to get the average back
select avg_rental_amount();

-- query to select all rows where the amount is greater than the average amount
select *
from payment
where amount > avg_rental_amount();

-- creating a function to calculate a discount
create function get_discount(price numeric, percentage integer)
returns decimal
as $$
begin
	return (price * percentage/100);
end;
$$
language plpgsql;

select get_discount(4.99, 50);

create or replace procedure apply_discount(percentage integer, _payment_id integer)
as $$
begin
	update payment
	set amount = get_discount(payment.amount, percentage)
	where payment_id = _payment_id;
end;
$$
language plpgsql;

select *
from payment
order by amount desc;

call apply_discount(50, 24866);

select *
from payment
where payment_id = 24866;







