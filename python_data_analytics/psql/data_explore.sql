- Q1: Show first 10 rows

SELECT * FROM retail limit 10;

- Q2: Check # of records

SELECT COUNT(*) FROM retail;

- Q3: number of clients (e.g. unique client ID)

SELECT COUNT(DISTINCT customer_id) FROM retail;

- Q4: invoice date range (e.g. max/min dates)

SELECT MAX(invoice_date) AS MAX, MIN(invoice_date) AS MIN
FROM retail;

- Q5: number of SKU/merchants (e.g. unique stock code)

SELECT COUNT(DISTINCT stock_code) FROM retail;

- Q6: Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)

SELECT AVG(invoice_total) AS average_invoice_amount
FROM (
    SELECT invoice_no, SUM(quantity * unit_price) AS invoice_total
    FROM retail
    WHERE quantity > 0 AND unit_price > 0                                        
    GROUP BY invoice_no
) AS invoice_totals;

- Q7: Calculate total revenue (e.g. sum of unit_price * quantity)

SELECT SUM(unit_price * quantity) FROM retail;

- Q8: Calculate total revenue by YYYYMM

SELECT
    EXTRACT(YEAR FROM invoice_date) * 100 + EXTRACT(MONTH FROM invoice_date) AS YYYYMM,
    SUM(quantity * unit_price) AS total_revenue
FROM
    retail
GROUP BY
    YYYYMM
ORDER BY
    YYYYMM;

