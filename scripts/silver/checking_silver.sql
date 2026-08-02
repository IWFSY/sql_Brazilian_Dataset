-- =======================================================================
-- Первичная сверка типов данных. Проверки до создания скелета silver_load
-- =======================================================================

-- Проверка и вычисление сместившихся строк
SELECT DISTINCT
order_status
FROM bronze.brazil_dataset

SELECT DISTINCT
payment_installments
FROM bronze.brazil_dataset;

-- Проверка на наличие невалидных символов (цифр и спецсимволов)
SELECT 
customer_city
FROM bronze.brazil_dataset
WHERE customer_city LIKE '%[^a-zA-Z '' -]%';

-- Проверка и вычисление аномальных данных в seller_state
SELECT
seller_state
FROM bronze.brazil_dataset
GROUP BY seller_state
HAVING MAX(LEN(seller_state)) > 2

-- Проверка и вычисление аномальных данных в почтовом коде
SELECT
seller_zip_code_prefix
FROM bronze.brazil_dataset
WHERE LEN(seller_zip_code_prefix) > 5

-- =====================================================================================================================
-- В результате этой сверки были найдены три смещения строк и внесены корерктировки в процедуру загрузки бронзового слоя
-- =====================================================================================================================

-- Дополнительная проверка на ошибки с DATETIME. Пробуем преобразовать в дэйттайм и выдаем значения, которые преобразовать не удалось. Наглядная демонстрация работы "SET DATEFORMAT ymd"

--SET DATEFORMAT ymd
SELECT 
    order_id,
    shipping_limit_date,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM bronze.brazil_dataset
WHERE 
    TRY_CAST(shipping_limit_date AS datetime) IS NULL AND shipping_limit_date IS NOT NULL
    OR TRY_CAST(order_purchase_timestamp AS datetime) IS NULL AND order_purchase_timestamp IS NOT NULL
    OR TRY_CAST(order_approved_at AS datetime) IS NULL AND order_approved_at IS NOT NULL
    OR TRY_CAST(order_delivered_carrier_date AS datetime) IS NULL AND order_delivered_carrier_date IS NOT NULL
    OR TRY_CAST(order_delivered_customer_date AS datetime) IS NULL AND order_delivered_customer_date IS NOT NULL
    OR TRY_CAST(order_estimated_delivery_date AS datetime) IS NULL AND order_estimated_delivery_date IS NOT NULL;

-- ==============================================================================
-- Проверка на несовпадения названий городов после выделения таблицы с географией
-- ==============================================================================

    SELECT
	br.customer_zip_code_prefix BRC,
	br.customer_city BRC,
	br.customer_state BRC,
	c.customer_zip_code_prefix C,
	c.customer_city C,
	c.customer_state C
FROM bronze.brazil_dataset br
JOIN silver.brazil_db_dim_cust c ON br.customer_id = c.customer_id
WHERE br.customer_city != c.customer_city 

	SELECT
	br.seller_zip_code_prefix BRS,
	br.seller_city BRS,
	br.seller_state BRS,
	s.seller_zip_code_prefix S,
	s.seller_city S,
	s.seller_state S
FROM bronze.brazil_dataset br
JOIN silver.brazil_db_dim_sell s ON br.seller_id = s.seller_id
WHERE br.seller_city != s.seller_city

-- =========================================================
-- Непосредственная работа с очисткой данных для silver_load
-- =========================================================

-- Проверка на лишние пробелы и уникальные значения
SELECT DISTINCT
	customer_city,
	customer_state,
	customer_zip_code_prefix,
	seller_city,
	seller_state,
	seller_zip_code_prefix
FROM bronze.brazil_dataset
WHERE	LEN(TRIM(customer_city)) != LEN(customer_city) OR
	LEN(TRIM(customer_state)) != LEN(customer_state) OR
	LEN(TRIM(customer_zip_code_prefix)) != LEN(customer_zip_code_prefix) OR
	LEN(TRIM(product_category_name)) != LEN(product_category_name) OR
	LEN(TRIM(seller_city)) != LEN(seller_city) OR
	LEN(TRIM(seller_state)) != LEN(seller_state) OR
	LEN(TRIM(seller_zip_code_prefix)) != LEN(seller_zip_code_prefix)

SELECT DISTINCT payment_type FROM bronze.brazil_dataset WHERE LEN(TRIM(payment_type)) != LEN(payment_type)

SELECT DISTINCT product_category_name FROM bronze.brazil_dataset WHERE LEN(TRIM(product_category_name)) != LEN(product_category_name)

SELECT DISTINCT order_status FROM bronze.brazil_dataset WHERE LEN(TRIM(order_status)) != LEN(order_status)

-- Проверка аномалий в габаритах 
SELECT 
	MIN(product_name_length) namep,
	MAX(product_name_length),
	MIN(product_description_length) descr,
	MAX(product_description_length),
	MIN(product_photos_qty) photo,
	MAX(product_photos_qty),
	MIN(product_weight_g),
	MAX(product_weight_g),
	MIN(product_length_cm),
	MAX(product_length_cm),
	MIN(product_height_cm),
	MAX(product_height_cm),
	MIN(product_width_cm),
	MAX(product_width_cm)
FROM silver.brazil_db_dim_prod
-- Найден продукт с весом 0.0. Судя по проверке категории и остальных габаритов это постельное белье, которое никак не можетв есить 0.0, на этапе инверт сделаю его нулификацию. В Gold представлении заменю на n\a.
SELECT 
	product_id,
	product_category_name,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
FROM bronze.brazil_dataset
GROUP BY 
	product_id,
	product_category_name,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
HAVING MIN(CAST(product_weight_g AS DECIMAL(10,2))) = 0.0

-- Найдены аномалии в хронолической последвоательности дат
SELECT
	order_id,
	order_purchase_timestamp AS make_an_order1,
	order_approved_at AS pay_to_seller2,
	order_delivered_carrier_date AS deliver_to_carrier3,
	shipping_limit_date AS shipping_limit_date3,
	order_delivered_customer_date AS delivery_to_customer4,
	order_estimated_delivery_date AS planned_date_delivered_to_customer4
FROM bronze.brazil_dataset
WHERE 
	order_purchase_timestamp > order_approved_at OR
	order_purchase_timestamp > order_delivered_carrier_date OR
	order_purchase_timestamp > shipping_limit_date OR
	order_purchase_timestamp > order_delivered_customer_date OR
	order_purchase_timestamp > order_estimated_delivery_date



