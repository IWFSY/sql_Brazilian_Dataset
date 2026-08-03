/*
===============================================================================
DDL-скрипт: Создание серебряных таблиц 
=============================================================================== 
Назначение скрипта: 
	этот скрипт создаёт таблицы в схеме «серебряная», удаляя существующие таблицы, 
	если они уже существуют. 


===============================================================================
*/
IF OBJECT_ID ('silver.brazil_db_fact', 'U') IS NOT NULL
	DROP TABLE silver.brazil_db_fact; 
CREATE TABLE silver.brazil_db_fact (
	order_id VARCHAR(32) NOT NULL,
	order_item_id INT NOT NULL,
	payment_type VARCHAR(15),
	payment_sequential INT,
	payment_installments INT,
	price DECIMAL(10,2),
	freight_value DECIMAL(10,2),
	payment_value DECIMAL(10,2),
	order_status VARCHAR(15),
	shipping_limit_date DATETIME,
	order_purchase_timestamp DATETIME NOT NULL,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATE,
	db_create_date DATETIME2 DEFAULT GETDATE()
);
IF OBJECT_ID ('silver.brazil_db_dim_cust', 'U') IS NOT NULL
	DROP TABLE silver.brazil_db_dim_cust; 
CREATE TABLE silver.brazil_db_dim_cust (
	customer_id VARCHAR(32) NOT NULL,
	customer_unique_id VARCHAR(32) NOT NULL,
	customer_zip_code_prefix INT,
	customer_city VARCHAR(50),
	customer_state CHAR(2),
	db_create_date DATETIME2 DEFAULT GETDATE()
);
IF OBJECT_ID ('silver.brazil_db_dim_sell', 'U') IS NOT NULL
	DROP TABLE silver.brazil_db_dim_sell; 
CREATE TABLE silver.brazil_db_dim_sell (
	seller_id VARCHAR(32) NOT NULL,
	seller_city VARCHAR(50),
	seller_state CHAR(2),
	seller_zip_code_prefix INT,
	db_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.brazil_db_dim_prod', 'U') IS NOT NULL
	DROP TABLE silver.brazil_db_dim_prod; 
CREATE TABLE silver.brazil_db_dim_prod (
	product_id VARCHAR(32) NOT NULL,
	product_category_name VARCHAR(50),
	product_name_length INT,
	product_description_length INT,
	product_photos_qty INT,
	product_weight_g DECIMAL(10,1),
	product_length_cm DECIMAL(10,1),
	product_height_cm DECIMAL(10,1),
	product_width_cm DECIMAL(10,1),
	db_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.brazil_db_geo_cust', 'U') IS NOT NULL
	DROP TABLE silver.brazil_db_geo_cust; 
CREATE TABLE silver.brazil_db_geo_cust (
	customer_zip_code_prefix INT,
	customer_city VARCHAR(50),
	customer_state CHAR(2)
);

IF OBJECT_ID ('silver.brazil_db_geo_sell', 'U') IS NOT NULL
	DROP TABLE silver.brazil_db_geo_sell; 
CREATE TABLE silver.brazil_db_geo_sell (
	seller_zip_code_prefix INT,
	seller_city VARCHAR(50),
	seller_state CHAR(2)
);
