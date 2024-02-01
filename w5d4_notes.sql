select *
from customer;

select *
from order_;

alter table customer
drop column phone_number cascade; -- if other tables are dependent on this column, it will remove those dependencies as well

-- altering table adding one column
--alter table customer
--add phone_number VARCHAR(20)

-- alter table and add more than one column, each new add column needs to be separated by a comma
-- DDL
alter table order_
add order_quantity INTEGER,
add staff_first VARCHAR(50),
add staff_last VARCHAR(50),
add price integer

-- DDL
alter table order_ 
alter column price type numeric(6,2);

-- update order table and set values for specific columns where order_id is 1 
--DML
update order_ 
set order_quantity = 3, 
staff_first = 'Rod', 
staff_last = 'Kimble',
price = '250.00'
where order_id = 1;

-- setting a staff member for all orders. Rod Kimble managed all orders
-- DML
update order_ 
set staff_first = 'Rod', staff_last = 'Kimble';





