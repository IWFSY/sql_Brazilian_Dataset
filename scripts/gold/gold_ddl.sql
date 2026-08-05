/*
===============================================================================
DDL Script: Создаем Gold представление
=============================================================================== 
Цель скрипта: 
  Этот скрипт создаёт просмотры для слоя Gold в хранилище данных. 
  Золотой слой представляет готовые таблицы с витринами для бизнеса.
Список витрин:
  - Витрина логистики (gold.logistics_mart),
  - Витрина коммерции (),
  - Витрина Сэллеров (),
  - Витрина Клиентов ()
  
  Каждое представление выполняет преобразования и объединяет данные из слоя Silver, 
  создавая чистый, обогащённый и готовый набор данных.
Использование: 
  - Эти просмотры можно запрашиваться напрямую для аналитики и отчетности. 
=============================================================================== 
*/ 

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
	s.seller_city,
	c.customer_city,
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
