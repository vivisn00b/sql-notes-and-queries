USE MyDatabase;
GO

/* Find customers whose score is above the average score. */
SELECT *
FROM dbo.customers
WHERE score > (
	SELECT AVG(score)
	FROM customers
);

/* Find customers who placed the highest sales order. */
SELECT
	c.id,
	c.first_name,
	o.sales
FROM customers c
INNER JOIN orders o
	ON c.id = o.customer_id
WHERE sales = (
	SELECT MAX(sales)
	FROM orders
);

/* Find customers who placed at least one order. */
SELECT
	c.id,
	c.first_name,
	o.sales
FROM customers c
INNER JOIN orders o
	ON c.id = o.customer_id
WHERE EXISTS (
	SELECT 1
	FROM orders
	WHERE sales >= 1
	--WHERE o.customer_id = c.id
);

--

USE SalesDB;
GO

/* Find employees earning more than the average salary. */
SELECT *
FROM Sales.Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Sales.Employees
);

/* Find products that were never sold. */
SELECT *
FROM Sales.Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Orders o
    WHERE o.ProductID = p.ProductID
);

/* Find customers who placed orders in both 2024 (archive) and 2025. */
SELECT *
FROM Sales.Customers c
WHERE EXISTS (
    SELECT 1
    FROM Sales.OrdersArchive oa
    WHERE oa.CustomerID = c.CustomerID
		AND YEAR(oa.OrderDate) = 2024
)
AND EXISTS (
    SELECT 1
    FROM Sales.Orders o
    WHERE o.CustomerID = c.CustomerID
		AND YEAR(o.OrderDate) = 2025
);

/* Find orders whose sales are above the customer’s average order value. */
SELECT *
FROM Sales.Orders o
WHERE o.Sales > (
    SELECT AVG(o2.Sales)
    FROM Sales.Orders o2
    WHERE o2.CustomerID = o.CustomerID
);