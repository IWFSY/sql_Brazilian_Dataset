/*
=============================================================
Создание базы данных и схем
=============================================================
Назначение скрипта: 
    Этот скрипт создаёт новую базу данных под названием 'AmazonWarehouse' после проверки её существования. 
    Если база данных существует, её отбрасывают и создают заново. 
    Кроме того, скрипт устанавливает три схемы в базе данных: «бронзовая», «серебряная» и «золотая». 

ВНИМАНИЕ: 
    При запуске этого скрипта вся база данных 'AmazonWarehouse' исчезнет, если она существует. 
    Все данные в базе данных будут навсегда удалены. 
    Действуйте осторожно и убедитесь, что у вас есть правильные резервные копии перед запуском этого скрипта.
*/

USE master;
GO

-- Удаляем базу данных 'AmazonWarehouse', при наличии
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'AmazonWarehouse')
BEGIN
    ALTER DATABASE AmazonWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AmazonWarehouse;
END;
GO

-- Создаем базу данных 'AmazonWarehouse'
CREATE DATABASE AmazonWarehouse;
GO

USE AmazonWarehouse;
GO

-- Создаем схемы
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
