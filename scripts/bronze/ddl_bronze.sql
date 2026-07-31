/*
=========================================================================================================
DDL-скрипт: Создание бронзовой таблицы
=========================================================================================================
Цель сценария: 
	Этот скрипт создаёт таблицу в «бронзовой» схеме, удаляя существующую таблицу, если она уже существует. 
	Поскольку исходный файл имеет только одну таблицу, идет только ее загрузка.
	Запуск этого скрипта переопределит структуру DDL «бронзовой» таблицы
===========================================================================================================
*/
IF OBJECT_ID ('bronze.brazil_dataset', 'U') IS NOT NULL
	DROP TABLE bronze.brazil_dataset; 
CREATE TABLE bronze.brazil_dataset (
	number INT,
	order_id NVARCHAR(250),
	order_item_id NVARCHAR(250),
	customer_id NVARCHAR(250),
	customer_unique_id NVARCHAR(250),
	customer_zip_code_prefix NVARCHAR(250),
	customer_city NVARCHAR(250),
	customer_state NVARCHAR(250),
	product_id NVARCHAR(250),
	product_category_name NVARCHAR(250),
	product_name_lenght NVARCHAR(250),
	product_description_lenght NVARCHAR(250),
	product_photos_qty NVARCHAR(250),
	product_weight_g NVARCHAR(250),
	product_length_cm NVARCHAR(250),
	product_height_cm NVARCHAR(250),
	product_width_cm NVARCHAR(250),
	seller_id NVARCHAR(250),
	seller_city NVARCHAR(250),
	seller_state NVARCHAR(250),
	seller_zip_code_prefix NVARCHAR(250),
	payment_type NVARCHAR(250),
	payment_sequential NVARCHAR(250),
	payment_installments NVARCHAR(250),
	price NVARCHAR(250),
	freight_value NVARCHAR(250),
	payment_value NVARCHAR(250),
	shipping_limit_date NVARCHAR(250),
	order_purchase_timestamp NVARCHAR(250),
	order_approved_at NVARCHAR(250),
	order_delivered_carrier_date NVARCHAR(250),
	order_delivered_customer_date NVARCHAR(250),
	order_estimated_delivery_date NVARCHAR(250),
	day_of_purchase NVARCHAR(250),
	month_of_purchase NVARCHAR(250),
	year_of_purchase NVARCHAR(250),
	month_year_of_purchase NVARCHAR(2250),
	order_status NVARCHAR(2250),
	order_unique_id	NVARCHAR(2250)
);
