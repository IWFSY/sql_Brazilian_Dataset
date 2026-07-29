/*
===============================================================================
DDL-скрипт: Создание бронзовой таблицы
=============================================================================== 
Цель сценария: 
	Этот скрипт создаёт таблицу в «бронзовой» схеме, удаляя существующую таблицу, 
	если она уже существует. 
	Запустите этот скрипт, чтобы переопределить структуру DDL «бронзовой» таблицы
===============================================================================
*/
IF OBJECT_ID ('bronze.overall_info', 'U') IS NOT NULL
	DROP TABLE bronze.overall_info; 
CREATE TABLE bronze.overall_info (
	product_id NVARCHAR(MAX),
	product_name NVARCHAR(MAX),
	category NVARCHAR(MAX),
	discounted_price NVARCHAR(MAX),
	actual_price NVARCHAR(MAX),
	discount_percentage NVARCHAR(MAX),
	rating NVARCHAR(MAX),
	rating_count NVARCHAR(MAX),
	about_product NVARCHAR(MAX),
	user_id NVARCHAR(MAX),
	user_name NVARCHAR(MAX),
	review_id NVARCHAR(MAX),
	review_title NVARCHAR(MAX),
	review_content NVARCHAR(MAX),
	img_link NVARCHAR(MAX),
	product_link NVARCHAR(MAX)

);
