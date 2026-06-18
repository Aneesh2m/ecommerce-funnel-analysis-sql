
-- E-COMMERCE FUNNEL ANALYSIS


-- 1. FUNNEL STAGE ANALYSIS
--    How many unique users reach each stage? 

WITH funnel_stages AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view'      THEN user_id END) AS stage_1_views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart'    THEN user_id END) AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type = 'payment_info'   THEN user_id END) AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase'       THEN user_id END) AS stage_5_purchase
    FROM ecom.project1
)
SELECT * FROM funnel_stages;



-- 2. CONVERSION RATE ANALYSIS
--    Step-by-step drop-off rates through the funnel

WITH funnel_stages AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view'      THEN user_id END) AS stage_1_views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart'    THEN user_id END) AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type = 'payment_info'   THEN user_id END) AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase'       THEN user_id END) AS stage_5_purchase
    FROM ecom.project1
)
SELECT
    stage_1_views,

    stage_2_cart,
    ROUND(stage_2_cart * 100.0 / stage_1_views, 2)       AS view_to_cart_rate,

    stage_3_checkout,
    ROUND(stage_3_checkout * 100.0 / stage_2_cart, 2)    AS cart_to_checkout_rate,

    stage_4_payment,
    ROUND(stage_4_payment * 100.0 / stage_3_checkout, 2) AS checkout_to_payment_rate,

    stage_5_purchase,
    ROUND(stage_5_purchase * 100.0 / stage_4_payment, 2) AS payment_to_purchase_rate,

    ROUND(stage_5_purchase * 100.0 / stage_1_views, 2)   AS overall_conversion_rate
FROM funnel_stages;



-- 3. CHANNEL PERFORMANCE ANALYSIS
--    Which traffic source drives the most efficient conversions?

WITH source_funnel AS (
    SELECT
        traffic_source,
        COUNT(DISTINCT CASE WHEN event_type = 'page_view'   THEN user_id END) AS views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS carts,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase'    THEN user_id END) AS purchases
    FROM ecom.project1
    GROUP BY traffic_source
)
SELECT
    traffic_source,
    views,
    carts,
    purchases,
    ROUND(carts     * 100.0 / views, 2) AS view_to_cart_rate,
    ROUND(purchases * 100.0 / carts, 2) AS cart_to_purchase_rate,
    ROUND(purchases * 100.0 / views, 2) AS overall_channel_conversion_rate
FROM source_funnel
ORDER BY overall_channel_conversion_rate DESC;  


-- 4. TIME-TO-CONVERSION ANALYSIS
--    How long does it take users to move through the funnel?

WITH user_journey AS (
    SELECT
        user_id,
        MIN(CASE WHEN event_type = 'page_view'   THEN event_date END) AS view_time,
        MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
        MIN(CASE WHEN event_type = 'purchase'    THEN event_date END) AS purchase_time
    FROM ecom.project1
    GROUP BY user_id
    HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL
)
SELECT
    COUNT(*) AS converted_users,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, view_time, cart_time)), 2) AS avg_view_to_cart_minutes,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, cart_time, purchase_time)), 2) AS avg_cart_to_purchase_minutes,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, view_time, purchase_time)), 2) AS avg_total_journey_minutes,
    SUM(CASE WHEN TIMESTAMPDIFF(MINUTE, view_time, purchase_time) <= 30  THEN 1 ELSE 0 END) AS converted_within_30_min,
    SUM(CASE WHEN TIMESTAMPDIFF(MINUTE, view_time, purchase_time) <= 60  THEN 1 ELSE 0 END) AS converted_within_1_hr,
    SUM(CASE WHEN TIMESTAMPDIFF(MINUTE, view_time, purchase_time) >  60  THEN 1 ELSE 0 END) AS converted_after_1_hr
FROM user_journey;



-- 5. REVENUE FUNNEL ANALYSIS

WITH revenue_funnel AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase'  THEN user_id END) AS total_buyers,
        ROUND(SUM(CASE WHEN event_type = 'purchase' THEN  amount END), 2) AS total_revenue,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN event_id END) AS total_orders
    FROM ecom.project1
)
SELECT
    total_visitors,
    total_buyers,
    total_revenue,
    total_orders,
    ROUND(total_revenue / total_orders,   2) AS avg_order_value,
    ROUND(total_revenue / total_buyers,   2) AS revenue_per_buyer,
    ROUND(total_revenue / total_visitors, 2) AS revenue_per_visitor
FROM revenue_funnel;



-- 6. REVENUE BY CHANNEL
--    Which channel generates the most revenue per visitor?

SELECT
    traffic_source,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase'  THEN user_id END) AS buyers,
    ROUND(SUM(CASE WHEN event_type = 'purchase' THEN amount  END), 2)  AS total_revenue,
    ROUND(SUM(CASE WHEN event_type = 'purchase' THEN amount END) /
          NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END), 0), 2)  AS avg_order_value,
    ROUND(SUM(CASE WHEN event_type = 'purchase' THEN amount END) /
          NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END), 0), 2) AS revenue_per_visitor
FROM ecom.project1
GROUP BY traffic_source
ORDER BY revenue_per_visitor DESC;
