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

	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME, @rows_fact INT, @rows_cust INT, @rows_prod INT, @rows_sell INT;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=========================================================';
		PRINT 'Загрузка данных для геолокации клиентов';
		PRINT '=========================================================';

		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_geo';
		TRUNCATE TABLE silver.brazil_db_geo;
		PRINT '>> Вставка информации о данных: silver.brazil_db_geo';
				WITH cte_rn_geo AS (
		SELECT
			customer_zip_code_prefix,
			customer_city,
			customer_state,
			ROW_NUMBER() OVER (PARTITION BY customer_zip_code_prefix ORDER BY COUNT(*)) AS rn_geo
		FROM bronze.brazil_dataset
		GROUP BY 	
			customer_zip_code_prefix,
			customer_city,
			customer_state
		)
		INSERT INTO silver.brazil_db_geo (customer_zip_code_prefix,customer_city,customer_state)

		SELECT
			customer_zip_code_prefix,
			customer_city,
			customer_state
		FROM cte_rn_geo 
		WHERE rn_geo = 1

		SET @rows_fact = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_fact AS VARCHAR(10));
		PRINT '-------------------------------';
-- Как показала проверка, конкретно в этом датасете аномалий в географии нет. Но в целом сделал выделение географии на этом уровне, чтобы гарантированно иметь корретную информацию. 
-- =====================================================================================================================================

		PRINT '=========================================================';
		PRINT 'Загрузка серебренного слоя';
		PRINT '=========================================================';

		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_fact';
		TRUNCATE TABLE silver.brazil_db_fact;
		PRINT '>> Вставка информации о данных: silver.brazil_db_fact';
		INSERT INTO silver.brazil_db_fact (order_id,order_item_id,payment_type,payment_sequential,payment_installments,price,freight_value,payment_value,order_status,shipping_limit_date,order_purchase_timestamp,order_approved_at,order_delivered_carrier_date,order_delivered_customer_date,order_estimated_delivery_date)
		SELECT 
			order_id,
			order_item_id,
			payment_type,
			payment_sequential,
			payment_installments,
			price,
			freight_value,
			payment_value,
			order_status,
			shipping_limit_date,
			order_purchase_timestamp,
			order_approved_at,
			order_delivered_carrier_date,
			order_delivered_customer_date,
			order_estimated_delivery_date
		FROM bronze.brazil_dataset

		SET @rows_fact = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_fact AS VARCHAR(10));
		PRINT '-------------------------------';

-- =====================================================================================================================================

		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_dim_cust';
		TRUNCATE TABLE silver.brazil_db_dim_cust;

		PRINT '>> Вставка информации о данных: silver.brazil_db_dim_cust';
		INSERT INTO silver.brazil_db_dim_cust (customer_id,customer_unique_id,customer_zip_code_prefix,customer_city,customer_state)
		SELECT 
			c.customer_id,
			c.customer_unique_id,
			g.customer_zip_code_prefix,
			g.customer_city,
			g.customer_state
		FROM bronze.brazil_dataset c
		JOIN silver.brazil_db_geo g ON g.customer_zip_code_prefix = c.customer_zip_code_prefix
		SET @rows_cust = @@ROWCOUNT;

		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_fact AS VARCHAR(10));
		PRINT '-------------------------------';

-- =====================================================================================================================================

		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_dim_prod';
		TRUNCATE TABLE silver.brazil_db_dim_prod;

		PRINT '>> Вставка информации о данных: silver.brazil_db_dim_prod';
		INSERT INTO silver.brazil_db_dim_prod (product_id,product_category_name,product_name_length,product_description_length,product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm)
		SELECT 
			product_id,
			product_category_name,
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
		PRINT '>> Загружено строк: ' + CAST(@rows_fact AS VARCHAR(10));
		PRINT '-------------------------------';

-- =====================================================================================================================================

		SET @start_time = GETDATE();
		PRINT '>> Очистка данных из таблицы: silver.brazil_db_dim_sell';
		TRUNCATE TABLE silver.brazil_db_dim_sell;

		PRINT '>> Вставка информации о данных: silver.brazil_db_dim_sell';
		INSERT INTO silver.brazil_db_dim_sell (seller_id,seller_city,seller_state,seller_zip_code_prefix)
		SELECT 
			s.seller_id,
			g.customer_city AS seller_city,
			g.customer_state AS seller_state,
			g.customer_zip_code_prefix AS seller_zip_code_prefix
		FROM bronze.brazil_dataset s
		JOIN silver.brazil_db_geo g ON g.customer_zip_code_prefix = s.customer_zip_code_prefix
		SET @rows_sell = @@ROWCOUNT;

		SET @end_time = GETDATE();
		PRINT '>> Длительность загрузки: ' +  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'секунд';
		PRINT '>> Загружено строк: ' + CAST(@rows_fact AS VARCHAR(10));
		PRINT '-------------------------------';


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
