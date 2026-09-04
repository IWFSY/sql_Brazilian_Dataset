/*
===============================================================================
DDL Script: Создаем Gold представление
=============================================================================== 
Цель скрипта: 
  Этот скрипт создаёт представления для слоя Gold в хранилище данных.
  Золотой слой представляет представления очищенной модели данных. Включает основные измерения для факта заказов и сам факт.
Список витрин:
  - Витрина фактов (gold.fact_mart),
  - Витрина измерения клиентов (gold.dim_customers_mart),
  - Витрина измерения селлеров (gold.dim_sellers_mart),
  - Витрина измерения продуктов (gold.dim_products_mart)
  
  Каждое представление выполняет преобразования и объединяет данные из слоя Silver, 
  создавая чистый, обогащённый и готовый набор данных. При этом представления защищены от удаления колоногк на серебрянном слое.
Использование: 
  - Модель данных подключается к системе BI, имея атомарный уровень для аналитики и отчетности. 
=============================================================================== 
*/ 

-- ============================================================================= 
-- Создание представления таблицы фактов: gold.fact_mart
-- =============================================================================
IF OBJECT_ID('gold.fact_mart', 'V') IS NOT NULL
    DROP VIEW gold.fact_mart;
GO
CREATE VIEW gold.fact_mart 
WITH SCHEMABINDING AS
SELECT 
	customer_key,
	product_key,
	seller_key,
	order_id,
	order_item_id,
	payment_type,
	payment_sequential,
	payment_installments,
	price,
	freight_value,
	payment_value,
	order_status,
    CAST(shipping_limit_date AS DATE) AS shipping_limit_date,
    CAST(order_purchase_timestamp AS DATE) AS order_purchase_date,
    CAST(order_approved_at AS DATE) AS order_approved_at,
    CAST(order_delivered_carrier_date AS DATE) AS order_delivered_carrier_date,
    CAST(order_delivered_customer_date AS DATE) AS order_delivered_customer_date,
	order_estimated_delivery_date
FROM silver.brazil_db_fact
GO

-- ============================================================================= 
-- Создание представления таблицы измерения клиентов: gold.dim_customers_mart
-- =============================================================================
IF OBJECT_ID('gold.dim_customers_mart', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers_mart;
GO
CREATE VIEW gold.dim_customers_mart 
WITH SCHEMABINDING  AS
SELECT 
	customer_key,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
FROM silver.brazil_db_dim_cust
GO

-- ============================================================================= 
-- Создание представления таблицы измерения селлеров: gold.dim_sellers_mart
-- =============================================================================
IF OBJECT_ID('gold.dim_sellers_mart', 'V') IS NOT NULL
    DROP VIEW gold.dim_sellers_mart;
GO
CREATE VIEW gold.dim_sellers_mart 
WITH SCHEMABINDING  AS
SELECT 
	seller_key,
	seller_city,
	seller_state,
	seller_zip_code_prefix
FROM silver.brazil_db_dim_sell
GO

-- ============================================================================= 
-- Создание представления таблицы измерения продуктов: gold.dim_products_mart
-- =============================================================================
IF OBJECT_ID('gold.dim_products_mart', 'V') IS NOT NULL
    DROP VIEW gold.dim_products_mart;
GO
CREATE VIEW gold.dim_products_mart 
WITH SCHEMABINDING  AS
SELECT 
	product_key,
	product_category_name,
	product_name_length,
	product_description_length,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
FROM silver.brazil_db_dim_prod
GO
