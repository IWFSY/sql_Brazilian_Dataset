-- ====================
-- Сверка типов данных
-- ====================

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

