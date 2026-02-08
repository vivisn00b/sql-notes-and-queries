USE MyDatabase;
GO

/* Show customer name, country, order date, and sales. */
SELECT
	customers.first_name,
	customers.country,
	orders.order_date,
	orders.sales
FROM dbo.customers
LEFT JOIN dbo.orders
	ON customers.id = orders.customer_id

/* Find orders where the customer does NOT exist. */
SELECT *
FROM orders AS o
LEFT JOIN customers AS c
	ON o.customer_id = c.id
WHERE c.id IS NULL

/* List customers with NO orders */
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
	ON c.id = o.customer_id
WHERE o.customer_id IS NULL

--

USE SalesDB;
GO

/* Show product name and total sales amount. */
SELECT
	p.Product,
	SUM(o.Sales) Total_Sales
FROM Sales.Orders o
LEFT JOIN Sales.Products p
	ON o.ProductID = p.ProductID
GROUP BY p.Product

/* Find customers who never placed any order using NOT EXISTS. */
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName
FROM Sales.Customers c
WHERE NOT EXISTS (
	SELECT 1
	FROM Sales.Orders o
	WHERE o.CustomerID = c.CustomerID
);

/* Show employee name and the orders they handled. */
SELECT 
    e.FirstName,
    e.LastName,
    o.OrderID,
    o.OrderDate,
    o.Sales
FROM Sales.Employees e
INNER JOIN Sales.Orders o
    ON e.EmployeeID = o.SalesPersonID;

/* Find orders where SalesPersonID has NO matching employee. */
SELECT 
    o.*
FROM Sales.Orders o
LEFT JOIN Sales.Employees e
    ON o.SalesPersonID = e.EmployeeID
WHERE e.EmployeeID IS NULL;