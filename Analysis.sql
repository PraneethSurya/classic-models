
-- Questions To Prepare based on the their level from this Database



-- List all product names and their corresponding product lines.
select productName,productLine from products;

-- Find all employees who work in the 'California' office. (Replace 'California' with the actual office name if different)
select firstName,lastName,jobTitle,state  from employees join offices on employees.officeCode = offices.officeCode
where state = "CA";

-- Which products have a buy price greater than their MSRP?
select productName,buyPrice,MSRP from products
where buyPrice > MSRP;
-- None of the product buy_price higher than the MSRP


-- Display the total number of customers in the database.
select distinct(count(customerName)) as Total_Customer from customers;

-- List the top 5 most expensive products based on their MSRP.
select productName,MSRP from products
order by MSRP desc
limit 5;




-- For each product line, calculate the average quantity in stock.
select productLine,avg(quantityInStock) as Avg_products_for_sale  from products
group by productLine;


-- Find all orders placed in the last quarter (past 3 months).
SELECT *
FROM orders
WHERE orderDate >= '2005-01-01' AND orderDate < '2005-04-01'
order by orderDate desc;

-- select customerName,orderNumber from customers join orders on customers.customerNumber = orders.customerNumber

select c.customerName,c.customerNumber from customers c left join orders o on c.customerNumber = o.customerNumber;


-- Identify customers who haven't placed any orders in the past year.
SELECT distinct c.customerName, c.city
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.orderNumber IS NULL OR YEAR(o.orderDate) NOT IN (2004);

-- This query retrieves the names and cities of customers from the 'customers' table who have not placed any orders in the past year, 
-- considering that the orders were taken in the years 2003, 2004, and 2005.
--  The LEFT JOIN ensures all customers are included, and the WHERE clause filters out customers with no orders or orders from the specified years.



-- Which salesperson has the most customers assigned to them (based on the salesRepEmployeeNumber in the customers table)?
select E.firstName,E.employeeNumber,count(salesRepEmployeeNumber) as Assigned_customer 
from customers c 
left join employees E on c.salesRepEmployeeNumber = E.employeeNumber
group by E.employeeNumber
order by Assigned_customer desc;



-- Write a query to display employee last names, their job titles, and the city where their office is located. (Join tables employees and offices)
select E.firstName,E.lastName,E.jobTitle,O.city from employees E join offices O on E.officeCode = O.officeCode;




select p.productCode,p.productName ,sum(od.priceEach * od.quantityOrdered) AS Total_Revenue from products p 
join orderdetails od on p.productCode = od.productCode
join orders o on o.orderNumber = od.orderNumber
-- where o.orderDate >= date_sub("2005-05-30", Interval 1 year)   // I think this calculation was not correct i think 
-- DATE_SUB("2005-05-30", INTERVAL 1 YEAR): 
-- This function calculates a date one year before May 30, 2005. It subtracts one year from the specified date, resulting in May 30, 2004.

				-- OR
where o.orderDate >= "2003-05-30" and o.orderDate <= "2004-05-30"
group by p.productCode,p.productName
order by Total_Revenue desc;



-- Find the top 3 customers by total number of orders placed.
select c.customerNumber, c.customerName,count(orderNumber) as No_of_orders 
from customers c join orders o on c.customerNumber = o.customerNumber
group by c.customerNumber,c.customerName
order by no_of_orders desc
limit 3;



-- Identify employees who don't have any direct reports (those with reportsTo null).
select * from employees
where reportsTo IS NULL;


-- Write a query to display the total sales amount for each month, grouped by year. (Consider using YEAR and MONTH functions)

select year(orderDate) as OrderYear,month(orderDate) As OrderMonth,sum(od.priceEach * od.quantityOrdered) as Total_sales 
from orderdetails od join orders o on od.orderNumber = o.orderNumber
GROUP BY OrderYear, OrderMonth
ORDER BY Total_sales desc,orderYear desc,OrderMonth desc;


-- For each customer, calculate the average order value (total order amount divided by number of orders). (Involves joining multiple tables)

select c.customerName,avg(od.priceEach* od.quantityOrdered) as Avg_orders from customers c
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by c.customerName;


-- Calculate the total revenue generated from each product in the past year. Consider the order quantity and price per item in orderdetails.
select  p.productCode,p.productName,sum(od.priceEach * od.quantityOrdered) as Revenue from products p 
join orderdetails od on p.productCode = od.productCode
join orders o on od.orderNumber = o.orderNumber
where o.orderDate <= "2005-05-30" and o.orderDate >= "2004-05-30"
group by p.productCode,p.productName
order by Revenue desc;



----


-- 1.) Retrieve the list of customer name, customers contact name,
-- phone number, address, order number and order date for the orders
-- which are cancelled
select customerName,contactFirstName,contactLastName,phone,addressLine1,orderNumber,orderDate 
from customers c join orders o on c.customerNumber = o.customerNumber
where status = "cancelled";

-- 2.) Retrieve the list of customer name, customers contact name,
-- phone number, address, order number and order date for the orders
-- which are under dispute

select customerName,contactLastName,phone,addressLine1,orderNumber,orderDate 
from orders o join customers c on o.customerNumber = c.customerNumber
where status = "Disputed";


-- 3.) Obtain the list of unique shipping status for the company

select distinct(status) from orders;	

-- 4.) Obtain the list of orders which has some comments noted on them.

select * from orders
where comments is NOT NULL;

-- 5.)  Obtain the output with customer number, Customer name,
-- customer contact name, phone number, city, order number, product
-- code, product name for only motorcycles sales

SELECT
    c.customerNumber,
    c.customerName,
    c.contactFirstName,
    c.contactLastName,
    p.productLine,
    c.phone,
    c.city,
    o.orderNumber,
    p.productCode,
    p.productName
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
WHERE p.productLine LIKE '%Mo%'
order by customerNumber asc;

select * from products;

-- • Retrieve the list of employees who are working in France
select * from offices
where country = "France";

-- • Retrieve the list of all the persons who are in presidential 

select distinct(jobTitle) from employees;

select * from employees;

select * from employees 
where jobTitle in  ("President","VP Sales","VP Marketing");



-- Retrieve the list of the customer who has got the maximum  credit limit
select customerName,contactFirstName,city,creditLimit from customers
order by creditLimit desc
limit 20;


-- • Obtain the product with a lowest price and the highest price
select * from products
order by buyPrice asc
limit 1;

select * from products
order by buyPrice desc
limit 1;

-- Customer name, Customer contact name, Phone number,
-- Address, Check number, amount, and payment date
-- • Sort the list by ascending order

select customerName,c.customerNumber,concat(c.contactFirstName,' ',c.contactLastName) as contact_name,phone,addressLine1,checkNumber,paymentDate,amount 
from customers c join payments p on p.customerNumber = c.customerNumber
order by p.amount asc;


-- • Filter the list further for those customers who has made the
-- payment of 1lakh
select customerName,
	c.customerNumber,
	concat(c.contactFirstName,' ',
	c.contactLastName) as contact_name,
	phone,addressLine1,
	checkNumber,
	paymentDate,
	amount 
from customers c join payments p on p.customerNumber = c.customerNumber
where p.amount >= 100000
order by p.amount desc;

-- Retrieve the list of customer name, customers contact name,
-- phone number, address, order number and order date for the orders
-- which are cancelled

select c.customerName,concat(c.contactFirstName,' ',c.contactLastName) as Contact_Name ,phone,addressLine1,orderNumber,orderDate 
from customers c join orders o on c.customerNumber = o.customerNumber
where status like "%Cancel%";


-- • For the above output, obtain the product name and the quantity
-- ordered
select 
	productName,
	quantityOrdered 
from customers c 
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
join products p on p.productCode = od.productCode
where status like "%Cancel%"
order by quantityOrdered desc;

-- • For the above output, obtain the reasons for cancellation

select comments from orders
where status like "%Can%";

-- Obtain how many products are there in each product line
select productLine,count(*) as No_of_Products from products
group by productLine
order by No_of_Products desc;

-- - Order the output in ascending order
select productLine,count(*) as No_of_Products from products
group by productLine
order by No_of_Products asc;

-- - Include the description of product line in the output
SELECT
    o.orderNumber,
    o.comments,
    p.productName,
    pl.textDescription AS productLineDescription
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
JOIN productlines pl ON p.productLine = pl.productLine;

-- or --

SELECT
    pl.textDescription AS productLineDescription,
    COUNT(DISTINCT o.orderNumber) AS total_orders,
    SUM(p.buyPrice) AS total_revenue
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
JOIN productlines pl ON p.productLine = pl.productLine
GROUP BY pl.textDescription
ORDER BY total_revenue DESC;



-- • Obtain the employee number, first name, last name, email, office
-- address (complete address) for all the Vice Presidents
select * from employees e join offices o on e.officeCode = o.officeCode
where jobTitle like "V%";

-- • Obtain the minimum amount paid by the customer, maximum
-- amount paid by the customer
select min(amount),max(amount) from customers c join payments p on c.customerNumber = p.customerNumber;

-- • Obtain the unique job titles of the employees
select distinct(jobTitle) from employees;


-- Obtain the output with customer number, Customer name,
-- customer contact name, phone number, city, order number, product
-- code, product name
-- • Arrange the output in ascending order
select  c.customerName,c.customerNumber,concat(c.contactFirstName,' ',c.contactLastName) as Contact_Name,phone,city,o.orderNumber,p.productCode,p.productName
 from customers c 
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on od.orderNumber = o.orderNumber
join products p on p.productCode = od.productCode
order by o.orderDate asc;

-- • Obtain the output to see under which product line the product
-- “2001 Ferrari Enzo” falls in

select productName,productLine from products
where productName like "%Ferrari Enzo%";
