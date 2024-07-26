-- Используя бд OE решить задачи.
use oe;

-- Таблица - customers
select * from customers;

-- Вывести максимальный и минимальный credit_limit.
select max(CREDIT_LIMIT) max_credit_limit, min(CREDIT_LIMIT) min_credit_limit
from customers;

-- Вывести покупателей у которых creditlimit выше среднего creditlimit.

select customers.CUST_FIRST_NAME, customers.CUST_LAST_NAME, customers.CREDIT_LIMIT
FROM customers;

select avg(c.CREDIT_LIMIT) avg_credit_limit
from customers c;

select customers.CUST_FIRST_NAME, customers.CUST_LAST_NAME, customers.CREDIT_lIMIT
from customers
having customers.CREDIT_LIMIT > (select avg(customers.CREDIT_LIMIT) from customers);
                                
-- Найти кол/во покупателей имя которых начинается на букву 'D' и credit_limit больше 500.

select count(CUST_FIRST_NAME) as count_name_with_D_and_credit_more_500
from customers
where CUST_FIRST_NAME like 'D%'and CREDIT_LIMIT > 500;

select count(CREDIT_LIMIT) credit_limit_more_500
from customers
where CREDIT_LIMIT > 500;

-- Таблица order_items
select * from order_items;

-- Найти среднее значение unit_price
select avg(UNIT_PRICE) as avg_unit_price
from order_items;

-- Таблицы - orderitems, productinformation
select product_information.PRODUCT_NAME, order_items.QUANTITY from product_information
join order_items
on product_information.PRODUCT_ID = order_items.PRODUCT_ID;

-- Вывести имена продуктов(PRODUCT_NAME), кол/во(QUANTITY) которых меньше среднего.
select product_information.PRODUCT_NAME from product_information;

select count(product_information.PRODUCT_NAME) as prod_sum from product_information;

select avg(order_items.QUANTITY) as prod_avg from order_items;

select order_items.QUANTITY as prodQuantity_less_avg
from order_items
group by order_items.QUANTITY
having order_items.QUANTITY < (select avg(order_items.QUANTITY) as prod_avg from order_items);

select product_information.PRODUCT_NAME, less_avg.prodQuantity_avg from product_information
right join (select order_items.PRODUCT_ID, avg(order_items.QUANTITY) as prodQuantity_avg from order_items
group by order_items.PRODUCT_ID
having prodQuantity_avg < (select avg(order_items.QUANTITY) from order_items)) as less_avg
on less_avg.PRODUCT_ID = product_information.PRODUCT_ID;

-- Таблицы - orders, customers
select customers.CUST_FIRST_NAME, customers.CUST_LAST_NAME, orders.ORDER_TOTAL from orders
join customers
on orders.CUSTOMER_ID = customers.CUSTOMER_ID;

-- Вывести имя и фамилию покупателя с максимальной общей суммой покупки(ORDER_TOTAL).
select max(ORDER_TOTAL) from orders;

select customers.CUST_FIRST_NAME, customers.CUST_LAST_NAME, max_order.max_order_total from customers
join (select max(ORDER_TOTAL) as max_order_total, CUSTOMER_ID from orders
group by CUSTOMER_ID
having max_order_total = (select max(ORDER_TOTAL) from orders)) as max_order
on max_order.CUSTOMER_ID = customers.CUSTOMER_ID;

-- Найти сумму общей суммы покупок(ORDER_TOTAL) всех мужчин покупателей.
select customers.GENDER, sum(orders.ORDER_TOTAL) as total_order_amouint from orders
join customers
on orders.CUSTOMER_ID = customers.CUSTOMER_ID
where GENDER = 'M'
group by customers.GENDER;

select customers.GENDER, orders.ORDER_TOTAL from orders
join customers
on orders.CUSTOMER_ID = customers.CUSTOMER_ID
where GENDER = 'M';

select count(GENDER), sum(orders.ORDER_TOTAL) as total_order_amouint from orders
join customers
on orders.CUSTOMER_ID = customers.CUSTOMER_ID
where GENDER = 'M'
group by customers.GENDER;