/*
===============================================================================
DDL Script: Создаем Gold представление
=============================================================================== 
Цель скрипта: 
  Этот скрипт создаёт просмотры для слоя Gold в хранилище данных. 
  Золотой слой представляет готовые таблицы с витринами для бизнеса и таблицу для связи.
Список витрин:
  - Таблица для связи (gold.link_table),
  - Витрина логистики (gold.logistics_mart),
  - Витрина селлеров (gold.sellers_mart),
  - Витрина клиентов (gold.customers_mart),
  - Витрина продуктов (gold.products_mart)
  
  Каждое представление выполняет преобразования и объединяет данные из слоя Silver, 
  создавая чистый, обогащённый и готовый набор данных.
Использование: 
  - Эти просмотры можно запрашиваться напрямую для аналитики и отчетности. 
=============================================================================== 
*/ 

-- ============================================================================= 
-- Создание таблицы для связи: gold.link_table
-- =============================================================================
IF OBJECT_ID('gold.link_table', 'V') IS NOT NULL
    DROP VIEW gold.link_table;
GO
CREATE VIEW gold.link_table AS
SELECT 
customer_key,
seller_key,
product_key,
order_id,
order_item_id AS item_sequence_number,
payment_type AS payment_method ,
payment_sequential AS payment_sequence,
payment_installments,
price AS item_price,
freight_value AS item_shipping_cost,
payment_value AS total_order_payment,
order_status,
order_purchase_timestamp AS order_datetime
FROM silver.brazil_db_fact
GO
-- ============================================================================= 
-- Создание витрины логистики: gold.logistics_mart
-- =============================================================================
IF OBJECT_ID('gold.logistics_mart', 'V') IS NOT NULL
    DROP VIEW gold.logistics_mart;
GO
CREATE VIEW gold.logistics_mart AS
SELECT
	f.seller_key,
	f.customer_key,
	order_id,
	order_purchase_timestamp AS order_datetime,
	order_approved_at AS payment_datetime,
	order_delivered_carrier_date AS shipping_date,
	order_delivered_customer_date AS delivery_date,
	order_estimated_delivery_date AS estimated_delivery_date,
	shipping_limit_date AS shipping_deadline,
	DATEDIFF(d,order_delivered_carrier_date,order_delivered_customer_date) AS actual_delivery_days,
	DATEDIFF(d,order_purchase_timestamp,order_delivered_carrier_date) AS seller_handling_days,
	DATEDIFF(d,order_delivered_customer_date,order_estimated_delivery_date) AS delivery_delay_days,
	CASE WHEN 
		(DATEDIFF(d,order_delivered_customer_date,order_estimated_delivery_date)) < 0 AND (DATEDIFF(d,order_purchase_timestamp,order_delivered_carrier_date)) <= 1 THEN 'Carrier Delay'
		WHEN (DATEDIFF(d,order_delivered_customer_date,order_estimated_delivery_date)) < 0 AND (DATEDIFF(d,order_purchase_timestamp,order_delivered_carrier_date)) > 1 THEN 'Seller Delay'
		ELSE 'Time to Time'
	END AS delay_responsible_party,
	AVG(DATEDIFF(d,order_delivered_carrier_date,order_delivered_customer_date)) OVER (PARTITION BY s.seller_key) AS seller_avg_delivery_days,
	AVG(DATEDIFF(d,order_delivered_carrier_date,order_delivered_customer_date)) OVER (PARTITION BY s.seller_city) AS city_avg_delivery_days,
	CASE WHEN 
		(DATEDIFF(d,shipping_limit_date,order_delivered_customer_date)) < 0 THEN 'Yes'
		ELSE 'No'
		END AS deadline_violation
FROM [silver].[brazil_db_fact] f
LEFT JOIN [silver].[brazil_db_dim_sell] s ON f.seller_key = s.seller_key
LEFT JOIN [silver].[brazil_db_dim_cust] c ON f.customer_key = c.customer_key
GO
-- ============================================================================= 
-- Создание витрины селлеров: gold.sellers_mart
-- =============================================================================
	
IF OBJECT_ID('gold.sellers_mart', 'V') IS NOT NULL
    DROP VIEW gold.sellers_mart;
GO
CREATE VIEW gold.sellers_mart AS
WITH cte_seller_calc AS (
SELECT
	f.seller_key,
	order_id,
	s.seller_city,
	s.seller_state,
	price,
	freight_value,
	payment_value,
	order_status,
	order_item_id,
	order_purchase_timestamp,
	order_delivered_carrier_date,
	MIN(order_purchase_timestamp) OVER (PARTITION BY f.seller_key) AS first_order, 
	MAX(order_purchase_timestamp) OVER (PARTITION BY f.seller_key) AS last_order,
	COUNT(order_id) OVER (PARTITION BY f.seller_key) AS overall_orders_by_seller,
	ROW_NUMBER() OVER (PARTITION BY f.order_id, f.seller_key ORDER BY f.order_item_id) AS rn_seller_order,

	SUM(price) OVER (PARTITION BY f.seller_key) AS sum_price_by_seller,
	SUM(freight_value) OVER (PARTITION BY f.seller_key) AS sum_freight_by_seller,
	SUM(CASE WHEN lower(order_status) = 'canceled' THEN 1.0 / order_item_id ELSE 0 END) OVER (PARTITION BY f.seller_key) AS canceled_orders

FROM [silver].[brazil_db_fact] f
LEFT JOIN [silver].[brazil_db_dim_sell] s ON f.seller_key = s.seller_key
)
,
cte_sellecr_calc_2 AS (
SELECT
	seller_key,
	order_id,
	seller_city,
	seller_state,
	price,
	freight_value,
	payment_value,
	order_status,
	order_item_id,
	order_purchase_timestamp,
	order_delivered_carrier_date,
	first_order, 
	last_order,
	overall_orders_by_seller,
	rn_seller_order,
	sum_price_by_seller,
	sum_freight_by_seller,
	canceled_orders,
	SUM(CASE WHEN rn_seller_order = 1 THEN 1 ELSE 0 END) OVER (PARTITION BY seller_key) AS total_orders,
	DATEDIFF(month,first_order, last_order) AS seller_lifespan_months
FROM cte_seller_calc
)

SELECT DISTINCT
	seller_key,
	seller_city,
	seller_state,
	sum_price_by_seller AS total_revenue,
	sum_freight_by_seller AS total_shipping_revenue,
	sum_freight_by_seller + sum_price_by_seller AS gross_merchandise_value,
	total_orders,
	overall_orders_by_seller AS total_items_sold,
	ROUND((CAST(overall_orders_by_seller AS FLOAT) / NULLIF(total_orders, 0)), 2) AS items_per_order,
	first_order AS first_sale_date, 
	last_order AS last_sale_date,
	seller_lifespan_months,
	ROUND((canceled_orders / CAST(total_orders AS FLOAT)) * 100, 2) AS cancellation_rate

FROM cte_sellecr_calc_2
GO
-- ============================================================================= 
-- Создание витрины клиентов: gold.customers_mart
-- =============================================================================

IF OBJECT_ID('gold.customers_mart', 'V') IS NOT NULL
    DROP VIEW gold.customers_mart;
GO

CREATE VIEW gold.customers_mart AS
WITH cte_calc_gold_customers AS (
SELECT
	f.customer_key,
	c.customer_unique_id,
	order_id,
	customer_city,
	customer_state,
	payment_type,
	payment_sequential,
	payment_installments,
	price,
	MAX(order_item_id) OVER (PARTITION BY c.customer_unique_id) max_item,
	order_item_id,
	freight_value,
	payment_value,
	order_status,
	order_purchase_timestamp,
	order_delivered_customer_date,
	MIN(order_purchase_timestamp) OVER (PARTITION BY c.customer_unique_id) AS first_order, 
	MAX(order_purchase_timestamp) OVER (PARTITION BY c.customer_unique_id) AS last_order,
	COUNT(order_id) OVER (PARTITION BY c.customer_unique_id) AS ct_orders_by_client,
	SUM(payment_value) OVER (PARTITION BY c.customer_unique_id) AS total_spent,
	SUM(price) OVER (PARTITION BY c.customer_unique_id) AS sum_price_by_client,

	CAST(SUM(CASE WHEN lower(payment_type) = 'voucher' THEN 1.0 / order_item_id ELSE 0 END) 
		OVER (PARTITION BY c.customer_unique_id) AS INT) AS cheking_voucher,

	CAST(SUM(CASE WHEN lower(payment_type) = 'credit card' THEN 1.0 / order_item_id ELSE 0 END) 
		OVER (PARTITION BY c.customer_unique_id) AS INT)AS cheking_credit_card,

	CAST(SUM(CASE WHEN lower(payment_type) = 'boleto' THEN 1.0 / order_item_id ELSE 0 END) 
		OVER (PARTITION BY c.customer_unique_id) AS INT) AS cheking_boleto,

	CAST(SUM(CASE WHEN lower(payment_type) = 'debit card' THEN 1.0 / order_item_id ELSE 0 END) 
		OVER (PARTITION BY c.customer_unique_id) AS INT) AS cheking_debit_card,

	SUM(CASE WHEN lower(order_status) = 'canceled' THEN 1.0 / order_item_id ELSE 0 END) OVER (PARTITION BY c.customer_unique_id) AS canceled_orders
FROM [silver].[brazil_db_fact] f
LEFT JOIN [silver].[brazil_db_dim_cust] c ON f.customer_key = c.customer_key
)
SELECT
	customer_key,
	customer_unique_id,
	order_id,
	customer_city,
	customer_state,
	payment_sequential,
	payment_installments,
	price,
	payment_value,
	order_purchase_timestamp,
	order_delivered_customer_date,
	first_order, 
	last_order,
	DATEDIFF(month,first_order, last_order) AS months_lifespan,
	ct_orders_by_client / max_item AS total_orders,
	ROUND((total_spent / CAST(max_item AS FLOAT)), 2) AS total_spent,
		payment_type,
	CASE 
		WHEN cheking_credit_card >= cheking_voucher
		 AND cheking_credit_card >= cheking_boleto
		 AND cheking_credit_card >= cheking_debit_card THEN 'Credit card'
		WHEN cheking_boleto >= cheking_voucher
		 AND cheking_boleto >= cheking_debit_card THEN 'Boleto' 
		WHEN cheking_voucher >= cheking_debit_card THEN 'Voucher'
		ELSE 'Debit card'
	END AS preferred_payment_type,
	ROUND((canceled_orders / CAST(ct_orders_by_client AS FLOAT)) * 100, 2) AS canceled_percent
FROM cte_calc_gold_customers
GO
-- ============================================================================= 
-- Создание витрины клиентов: gold.products_mart
-- =============================================================================

IF OBJECT_ID('gold.products_mart', 'V') IS NOT NULL
    DROP VIEW gold.products_mart;
GO
CREATE VIEW gold.products_mart AS
WITH cte_calc_product AS (
SELECT
f.product_key,
order_id,
order_item_id,
price,
freight_value,
payment_value,
CAST(order_purchase_timestamp AS DATE) AS order_date,
MONTH(order_purchase_timestamp) AS order_month, 
DATEPART(quarter, order_purchase_timestamp) AS order_quarter,
DATEPART(weekday, order_purchase_timestamp) AS order_day_of_week,
p.product_category_name,
p.product_photos_qty,
p.product_weight_g,
p.product_length_cm,
p.product_height_cm,
p.product_width_cm,
SUM(price) OVER (PARTITION BY order_id) AS total_price,
SUM(freight_value) OVER (PARTITION BY order_id) AS total_freight_value

FROM [silver].[brazil_db_fact] f 
LEFT JOIN [silver].[brazil_db_dim_prod] p ON f.product_key = p.product_key
)

SELECT
product_key,
order_id,
order_item_id,
product_category_name,
price,
freight_value,
order_date,
order_month,
order_quarter,
order_day_of_week,
product_photos_qty AS product_photos_count,
product_weight_g AS product_weight_grams,
product_length_cm,
product_height_cm,
product_width_cm,
total_price AS total_items_cost,
total_freight_value AS total_order_shipping_cost,
ROUND((CAST(total_freight_value AS FLOAT) / total_price) * 100, 2) AS shipping_to_price_ratio,
CASE WHEN freight_value = 0 THEN 1 ELSE 0 END AS is_free_shipping
FROM cte_calc_product
GO
