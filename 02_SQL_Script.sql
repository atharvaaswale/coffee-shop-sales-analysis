--SELECT COUNT(*) FROM sales --check all records inserted
--SELECT * FROM sales
--SELECT DISTINCT product_category, product_type FROM sales

-- QUESTION 1
-- What is the Month-over-Month (MoM) Growth Rate of total revenue and transaction volume across each Store Location,
-- and which Product Category is the primary driver of this growth?

-- CTE 1 - Monthly summary
WITH monthly_sales AS (
    SELECT
        EOMONTH(transaction_date) month_end,
        store_location,
        product_category,
        SUM(sales) AS total_revenue,
        COUNT(transaction_id) AS total_transaction
    FROM sales
    GROUP BY EOMONTH(transaction_date), store_location, product_category
)

, sales_with_lag AS (
    SELECT
        *,
        LAG(total_revenue) OVER (
            PARTITION BY store_location, product_category
            ORDER BY month_end
        ) AS prev_month_revenue,
        LAG(total_transaction) OVER (
            PARTITION BY store_location, product_category
            ORDER BY month_end
        ) AS prev_month_transactions
    FROM monthly_sales
)

SELECT
    month_end,
    store_location,
    product_category,
    total_revenue,
    prev_month_revenue,
    total_transaction,
    --calculation for MoM Revenue Growth
    CASE
        WHEN prev_month_revenue IS NULL THEN NULL
        ELSE (total_revenue - prev_month_revenue) / prev_month_revenue * 100
    END AS revenue_growth_percentage
FROM sales_with_lag
ORDER BY store_location, month_end, revenue_growth_percentage DESC;

-- QUESTION 2
-- What is the Average Transaction Value (ATV) per Store Location,
-- and how does the distribution of Transaction Quantity vary by Hour of Day?
WITH product_performance AS (
    SELECT
        product_detail,
        product_category,
        ROUND(SUM(sales), 2) AS total_revenue, -- Rounds to 2 decimal places
        COUNT(transaction_id) AS total_units_sold
    FROM sales
    GROUP BY product_detail, product_category
),
ranked_products AS (
    SELECT
        *,
        PERCENT_RANK() OVER (ORDER BY total_revenue ASC) AS rev_percentile
    FROM product_performance
)
SELECT
    product_detail,
    product_category,
    total_revenue,
    total_units_sold,
    ROUND(rev_percentile * 100, 2) AS revenue_percentile_rank
FROM ranked_products
WHERE rev_percentile <= 0.10
ORDER BY total_revenue ASC;

-- QUESTION 3
-- Which specific Product Details rank in the bottom 10% of total revenue per Store,
-- and what is their average daily sales frequency compared to the top-tier products?
SELECT
    store_location,
    DATEPART(HOUR, datetime) AS hour_of_day,
    ROUND(SUM(sales), 2) AS total_revenue,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(sales) / COUNT(DISTINCT transaction_date), 2) AS avg_revenue_per_day
FROM sales
GROUP BY store_location, DATEPART(HOUR, datetime)
ORDER BY avg_revenue_per_day DESC;

-- QUESTION 4
-- How does the Revenue Contribution % of each Product Category shift between Morning
-- (6 AM-11 AM) and Afternoon (12 PM-5 PM) across the different Store Locations?
WITH daypart_sales AS (
    SELECT
        store_location,
        product_category,
        CASE
            WHEN DATEPART(HOUR, datetime) BETWEEN 6 AND 11 THEN 'Morning (6AM-11AM)'
            WHEN DATEPART(HOUR, datetime) BETWEEN 12 AND 17 THEN 'Afternoon (12PM-5PM)'
            ELSE 'Evening (6PM+)'
        END AS daypart,
        SUM(sales) AS total_sales
    FROM sales
    GROUP BY store_location, product_category,
        CASE
            WHEN DATEPART(HOUR, datetime) BETWEEN 6 AND 11 THEN 'Morning (6AM-11AM)'
            WHEN DATEPART(HOUR, datetime) BETWEEN 12 AND 17 THEN 'Afternoon (12PM-5PM)'
            ELSE 'Evening (6PM+)'
        END
)
SELECT
    *,
    ROUND(total_sales * 100.0 / SUM(total_sales) OVER (PARTITION BY store_location, daypart), 2) AS category_contribution_pct
FROM daypart_sales
ORDER BY store_location, daypart, category_contribution_pct DESC;

-- QUESTION 5
-- Which Store Location achieves the highest Revenue per Transactional Hour,
-- and how does this correlate with the Unit Price variance of the products sold there?
SELECT
    store_location,
    transaction_qty, -- Number of items in a single transaction
    COUNT(transaction_id) AS transaction_count,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(sales) / COUNT(transaction_id), 2) AS avg_ticket_size
FROM sales
GROUP BY store_location, transaction_qty
ORDER BY store_location, transaction_qty;