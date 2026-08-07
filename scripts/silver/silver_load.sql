/*
===============================================================================
Процедура хранения: загрузка серебряного слоя (бронза -> серебряная)
===============================================================================
Назначение скрипта: 
	Эта хранимая процедура выполняет процесс ETL (Извлечение, Преобразование, Загрузка) для заполнения таблиц схем «серебряных» из «бронзовой» схемы. 
Выполняемые действия: 
	- Усекает серебряные таблицы. 
	- Вставки, преобразованные и очищенные данные из бронзы в серебряные таблицы. 

Параметры: 
	Отсутствуют. 
	Эта сохранённая процедура не принимает параметры и не возвращает значения. 

Пример использования:
	EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

	SET DATEFORMAT ymd  -- Решаем проблему с DATETIME. Для RU региона TIME часть возвращает ошибку в этих данных
	SET NOCOUNT ON  --  Избавляемся от лишних сообщений. Все, что нужно, уже передано через PRINT

	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME, @rows_geo_cust INT, @rows_geo_sell INT, @rows_cust INT, @rows_prod INT, @rows_sell INT, @rows_fact INT;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=========================================================';
		PRINT 'Загрузка данных для геолокации клиентов';
		PRINT '=========================================================';
-- =====================================================================================================================================
		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_geo_cust';
		TRUNCATE TABLE silver.brazil_db_geo_cust;
		PRINT '>> Вставка информации о данных: silver.brazil_db_geo_cust';

		WITH cte_rn_geo_cust AS (
		SELECT
			customer_zip_code_prefix,
			CONCAT(UPPER(LEFT(customer_city, 1)), LOWER(SUBSTRING(customer_city, 2, LEN(customer_city)))) AS customer_city,
			customer_state,
			ROW_NUMBER() OVER (PARTITION BY customer_zip_code_prefix ORDER BY COUNT(*)) AS rn_geo
		FROM bronze.brazil_dataset
		GROUP BY 	
			customer_zip_code_prefix,
			customer_city,
			customer_state
		)

		INSERT INTO silver.brazil_db_geo_cust (customer_zip_code_prefix,customer_city,customer_state)

		SELECT
			customer_zip_code_prefix,
			customer_city,
			customer_state
		FROM cte_rn_geo_cust 
		WHERE rn_geo = 1;
		SET @rows_geo_cust = @@ROWCOUNT;
		
		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_geo_cust AS VARCHAR(10));
		PRINT '-------------------------------';
-- =====================================================================================================================================
		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_geo_sell';
		TRUNCATE TABLE silver.brazil_db_geo_sell;
		PRINT '>> Вставка информации о данных: silver.brazil_db_geo_sell';

		WITH cte_rn_geo_sell AS (
		SELECT
			seller_zip_code_prefix,
			CONCAT(UPPER(LEFT(seller_city, 1)), LOWER(SUBSTRING(seller_city, 2, LEN(seller_city)))) AS seller_city,
			seller_state,
			ROW_NUMBER() OVER (PARTITION BY seller_zip_code_prefix ORDER BY COUNT(*)) AS rn_geo
		FROM bronze.brazil_dataset
		GROUP BY 	
			seller_zip_code_prefix,
			seller_city,
			seller_state
		)

		INSERT INTO silver.brazil_db_geo_sell (seller_zip_code_prefix,seller_city,seller_state)
		SELECT
			seller_zip_code_prefix,
			seller_city,
			seller_state
		FROM cte_rn_geo_sell
		WHERE rn_geo = 1;
		SET @rows_geo_sell = @@ROWCOUNT;

		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_geo_sell AS VARCHAR(10));
		PRINT '-------------------------------';
-- =====================================================================================================================================
-- Как показала проверка, конкретно в этом датасете аномалий в географии нет. Но в целом сделал выделение географии на этом уровне, чтобы гарантированно иметь корретную информацию. 
-- =====================================================================================================================================

		PRINT '=========================================================';
		PRINT 'Загрузка серебренного слоя';
		PRINT '=========================================================';


		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_dim_cust';
		TRUNCATE TABLE silver.brazil_db_dim_cust;

		PRINT '>> Вставка информации о данных: silver.brazil_db_dim_cust';
		INSERT INTO silver.brazil_db_dim_cust (customer_id,customer_unique_id,customer_zip_code_prefix,customer_city,customer_state)
		SELECT DISTINCT
			c.customer_id,
			c.customer_unique_id,
			g.customer_zip_code_prefix,
			g.customer_city,
			g.customer_state
		FROM bronze.brazil_dataset c
		LEFT JOIN silver.brazil_db_geo_cust g ON g.customer_zip_code_prefix = c.customer_zip_code_prefix
		SET @rows_cust = @@ROWCOUNT;

		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_cust AS VARCHAR(10));
		PRINT '-------------------------------';

-- =====================================================================================================================================

		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_dim_prod';
		TRUNCATE TABLE silver.brazil_db_dim_prod;

		PRINT '>> Вставка информации о данных: silver.brazil_db_dim_prod';
		INSERT INTO silver.brazil_db_dim_prod (product_id,product_category_name,product_name_length,product_description_length,product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm)
		SELECT DISTINCT
			product_id,
			REPLACE(CONCAT(UPPER(LEFT(product_category_name, 1)), LOWER(SUBSTRING(product_category_name, 2, LEN(product_category_name)))), '_', ' ') AS product_category_name,
			CAST(CAST(product_name_lenght AS DECIMAL(10,0)) AS INT) AS product_name_length,  --  Исправляем опечатки сырой базы и преобразуем в INT, чтобы отсечь лишние дроби
			CAST(CAST(product_description_lenght AS DECIMAL(10,0)) AS INT) AS product_description_length,  --  Исправляем опечатки сырой базы и преобразуем в INT, чтобы отсечь лишние дроби
			CAST(CAST(product_photos_qty AS DECIMAL(10,0)) AS INT) product_photos_qty,  --  Преобразуем в INT, чтобы отсечь лишние дроби
			CASE WHEN product_weight_g = '0.0' THEN NULL ELSE product_weight_g 
			END AS product_weight_g,
			product_length_cm,
			product_height_cm,
			product_width_cm
		FROM bronze.brazil_dataset
		SET @rows_prod = @@ROWCOUNT;

		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_prod AS VARCHAR(10));
		PRINT '-------------------------------';

-- =====================================================================================================================================

		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_dim_sell';
		TRUNCATE TABLE silver.brazil_db_dim_sell;

		PRINT '>> Вставка информации о данных: silver.brazil_db_dim_sell';
		INSERT INTO silver.brazil_db_dim_sell (seller_id,seller_city,seller_state,seller_zip_code_prefix)
		SELECT DISTINCT
			s.seller_id,
			g.seller_city,
			g.seller_state,
			g.seller_zip_code_prefix
		FROM bronze.brazil_dataset s
		LEFT JOIN silver.brazil_db_geo_sell g ON g.seller_zip_code_prefix = s.seller_zip_code_prefix
		SET @rows_sell = @@ROWCOUNT;

		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_sell AS VARCHAR(10));
		PRINT '-------------------------------';

-- =====================================================================================================================================

		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_fact';
		TRUNCATE TABLE silver.brazil_db_fact;
		PRINT '>> Вставка информации о данных: silver.brazil_db_fact';
		INSERT INTO silver.brazil_db_fact (customer_key,product_key,seller_key,customer_id,product_id,seller_id,order_id,order_item_id,payment_type,payment_sequential,payment_installments,price,freight_value,payment_value,order_status,shipping_limit_date,order_purchase_timestamp,order_approved_at,order_delivered_carrier_date,order_delivered_customer_date,order_estimated_delivery_date)
		SELECT 
			c.customer_key,
			p.product_key,
			s.seller_key,
		    br.customer_id,
			br.product_id,
			br.seller_id,
			order_id,
			order_item_id,
			REPLACE(CONCAT(UPPER(LEFT(payment_type, 1)), LOWER(SUBSTRING(payment_type, 2, LEN(payment_type)))), '_', ' ') AS payment_type,
			payment_sequential,
			payment_installments,
			price,
			freight_value,
			payment_value,
			CONCAT(UPPER(LEFT(order_status, 1)), LOWER(SUBSTRING(order_status, 2, LEN(order_status)))) AS order_status,
			shipping_limit_date,
			d1.make_an_order1 AS order_purchase_timestamp,
			d2.pay_to_seller2 AS order_approved_at,
			d3.deliver_to_carrier3 AS order_delivered_carrier_date,
			d4.delivery_to_customer4 AS order_delivered_customer_date,
			order_estimated_delivery_date
		FROM bronze.brazil_dataset br
		LEFT JOIN silver.brazil_db_dim_cust c ON c.customer_id = br.customer_id
		LEFT JOIN silver.brazil_db_dim_prod p ON p.product_id = br.product_id
		LEFT JOIN silver.brazil_db_dim_sell s ON s.seller_id = br.seller_id
-- В результате проверки логики дат в них были найдены хронологические аномалии. Для решения в рамках этой ДБ я сделал проверку на сопоставление последовательности. 
-- В частности, дата оформления заказа не может быть позже любой другой даты, дата оплаты не может быть позднее даты доставки, дата передачи в СД не может быть раньше даты доставки до клиента.
-- В рамках реального проекта, конечно, такие вещи сверяются с ответственными за внесение этих данных и логику СУБД, но тут, для наглядности, я сделал простое приведение дат к правильной последовательности.
		CROSS APPLY (SELECT br.order_purchase_timestamp AS make_an_order1) AS d1
		CROSS APPLY (SELECT MAX(v) AS pay_to_seller2 FROM (VALUES (br.order_approved_at), (d1.make_an_order1)) AS val(v)) AS d2
		CROSS APPLY (SELECT MAX(v) AS deliver_to_carrier3 FROM (VALUES(br.order_delivered_carrier_date), (d2.pay_to_seller2)) AS val(v)) AS d3
		CROSS APPLY (SELECT MAX(v) AS delivery_to_customer4 FROM (VALUES(br.order_delivered_customer_date), (d3.deliver_to_carrier3)) AS val(v)) AS d4

		SET @rows_fact = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_fact AS VARCHAR(10));
		PRINT '-------------------------------';

-- =====================================================================================================================================

				SET @batch_end_time = GETDATE();
		PRINT '=====================================================';
		PRINT 'Загрузка серебренного слоя завершена';
		PRINT '     - Общая длительность загрузки: ' +  CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'секунд';
		PRINT '=====================================================';
	END TRY
	BEGIN CATCH
		PRINT '=====================================================';
		PRINT 'Ошибка при загрузке серебренного слоя';
		PRINT 'Сообщение об ошибке: ' + ERROR_MESSAGE();
		PRINT 'Номер ошибки: ' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
		PRINT 'Состояние ошибки: ' + CAST(ERROR_STATE() AS NVARCHAR(50));
		PRINT '=====================================================';
	END CATCH
END

