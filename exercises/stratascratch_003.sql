-- Find the best-selling item for each month (no need to separate months by year).
-- The best-selling item is determined by the highest total sales amount, calculated as: total_paid = unitprice * quantity. A negative quantity indicates a return or cancellation.
-- To calculate sales, ignore returns and cancellations. Output the month, description of the item, and the total amount paid.

-- https://platform.stratascratch.com/coding/10172-best-selling-item?code_type=3

WITH cte AS (
    SELECT
        DATE_FORMAT(invoicedate, '%m') AS month,
        description,
        SUM(quantity * unitprice) AS total_paid,
        DENSE_RANK() OVER (
            PARTITION BY DATE_FORMAT(invoicedate, '%m')
            ORDER BY SUM(quantity * unitprice) DESC
        ) AS rnk
    FROM online_retail
    GROUP BY 1, 2
)
SELECT month, description, total_paid
FROM cte
WHERE rnk = 1;
