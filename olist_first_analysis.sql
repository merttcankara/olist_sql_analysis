--- Finding Monthly Orders

SELECT
  FORMAT(TRY_CONVERT(datetime2, order_purchase_timestamp), 'yyyy-MM') AS year_month,
  COUNT(*) AS order_count
FROM orders
WHERE TRY_CONVERT(datetime2, order_purchase_timestamp) IS NOT NULL
GROUP BY
  FORMAT(TRY_CONVERT(datetime2, order_purchase_timestamp), 'yyyy-MM')
ORDER BY year_month;

-- Monthly Revenue Calculating

SELECT
  FORMAT(TRY_CONVERT(datetime2, o.order_purchase_timestamp), 'yyyy-MM') AS year_month,
  SUM(TRY_CONVERT(decimal(10,2), i.price)) AS revenue
FROM orders o
JOIN order_items i
  ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND TRY_CONVERT(datetime2, o.order_purchase_timestamp) IS NOT NULL
GROUP BY FORMAT(TRY_CONVERT(datetime2, o.order_purchase_timestamp), 'yyyy-MM')
ORDER BY year_month;


-- Average Delivered Days

SELECT
  AVG(
    DATEDIFF(
      day,
      TRY_CONVERT(date, order_purchase_timestamp),
      TRY_CONVERT(date, order_delivered_customer_date))) 
      AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND TRY_CONVERT(date, order_purchase_timestamp) IS NOT NULL
  AND TRY_CONVERT(date, order_delivered_customer_date) IS NOT NULL;


-- Late Delivery Rate(%)

SELECT
  CAST(
    100.0 * SUM(
      CASE
        WHEN TRY_CONVERT(date, order_delivered_customer_date) >
             TRY_CONVERT(date, order_estimated_delivery_date)
        THEN 1 ELSE 0
      END) / COUNT(*) AS decimal(5,2)) 
      AS late_delivery_pct
FROM orders
WHERE order_status = 'delivered'
  AND TRY_CONVERT(date, order_delivered_customer_date) IS NOT NULL
  AND TRY_CONVERT(date, order_estimated_delivery_date) IS NOT NULL;


/*  Relationship between delivery time and customer satisfaction (review score)

- Analyzing whether longer delivery times lead to lower customer review scores
- Calculating the average delivery for each review score (1–5) */


/* 
Relationship between delivery time and customer satisfaction (review score)

Objective:
- Analyze whether longer delivery times lead to lower customer review scores
- Calculate the average delivery duration for each review score (1–5)

Tables used:
- dbo.orders         → order and delivery timestamps
- dbo.order_reviews  → customer review scores

Notes:
- Only delivered orders are included
- TRY_CONVERT is used to safely handle invalid or NULL date values
*/

SELECT
    r.review_score,  
    AVG(
        DATEDIFF(
            DAY,
            TRY_CONVERT(DATE, o.order_purchase_timestamp),        
            TRY_CONVERT(DATE, o.order_delivered_customer_date)    
        )
    ) AS avg_delivery_days   
FROM orders o
JOIN order_reviews r
    ON r.order_id = o.order_id   
WHERE o.order_status = 'delivered'   -- Only delivered orders
  AND TRY_CONVERT(DATE, o.order_delivered_customer_date) IS NOT NULL
GROUP BY r.review_score            
ORDER BY r.review_score;             
 
/*
Delivery speed is a critical driver of customer satisfaction in the Olist marketplace.
Delays in delivery are strongly associated with lower review scores
suggesting that improving logistics performance could directly improve customer ratings and 
overall platform reputation.
*/





