-- Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost. Order records by customer's first name alphabetically.

-- https://platform.stratascratch.com/coding/10183-total-cost-of-orders?code_type=3

WITH cust AS (
    SELECT id, first_name
    FROM customers
    GROUP BY id, first_name
)
SELECT c.id,
       c.first_name,
       SUM(total_order_cost)
FROM orders o
INNER JOIN cust c
    ON o.cust_id = c.id
GROUP BY c.id, c.first_name;
