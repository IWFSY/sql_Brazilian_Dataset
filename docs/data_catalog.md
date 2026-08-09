# Каталог данных золотого слоя

## Overview
Золотой уровень — это представление данных бизнес-уровня, структурированное для поддержки вариантов использования в аналитике и отчетности.

---

### 1. **gold.link_table**
- **Цель:** Связующий узел Золотого слоя. Объединяет изолированные бизнес-витрины по суррогатным ключам и содержит общие метрики транзакций (цены, логистику, параметры оплат) для сквозной BI-отчетности.
- **Список колонок:**

| Название колонки              | Тип даннных     | Описание                                                                                    |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key                  | INT           | Цифровой суррогатный ключ для связи с витриной клиентов (gold.customers_mart)                 |
| product_key                   | INT           | Цифровой суррогатный ключ для связи с витриной продуктов (gold.products_mart)                 |
| seller_key                    | INT           | Цифровой суррогатный ключ для связи с витриной продавцов (gold.seller_mart)                   |
| order_id                      | VARCHAR(32)   | Уникальный идентификатор заказа                                                               |
| item_sequence_number          | INT           | Порядковый номер позиции товара в чеке                                                        |
| payment_method                | VARCHAR(15)   | Тип оплаты (Credit card, Boleto, Voucher, Debit card)                                         |
| payment_sequence              | INT           | Порядковый номер транзакции в рамках одного чека                                              |
| payment_installments          | INT           | Количество месяцев предоставленной рассрочки                                                  |
| item_price                    | DECIMAL(10,2) | Чистая стоимость одной единицы товара                                                         |
| item_shipping_cost            | DECIMAL(10,2) | Стоимость доставки одной единицы товара                                                       |
| total_order_payment           | DECIMAL(10,2) | Полная стоимость товаров по чеку                                                              |
| order_status                  | VARCHAR(15)   | Текущий статус заказа (Delivered, Canceled)                                                   |
| order_datetime                | DATETIME      | Дата и время совершения покупки                                                               |
---

### 2. **gold.customers_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key (PK)             | INT           |                |
| customer_unique_id            | VARCHAR(32)   |                                     |
| order_id                      | VARCHAR(32)   |         |
| customer_city                 | VARCHAR(50)   |                                         |
| customer_state                | CHAR(2)       |                                                     |
| payment_sequential            | INT           |                                |
| payment_installments          | INT           |                            |
| price                         | DECIMAL(10,2) |                                |
| payment_value                 | DECIMAL(10,2) |                |
| order_purchase_timestamp      | DATETIME      |                          |
| order_delivered_customer_date | DATETIME      |                          |
| first_order                   | DATETIME      |                           |
| last_order                    | DATETIME      |                          |
| months_lifespan               | INT           |                         |
| total_orders                  | INT           |                           |
| total_spent                   | FLOAT         |                          |
| payment_type                  | VARCHAR(15)   |                          |
| preferred_payment_type        | VARCHAR(11)   |                          |
| canceled_percent              | FLOAT         |                          |
---

### 3. **gold.products_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key (PK)              | INT           |               |
| order_id                      | VARCHAR(32)   |                                       |
| order_item_id                 | INT           |          |
| product_category_name         | VARCHAR(50)   |                                         |
| price                         | DECIMAL(10,2) |                                                   |
| freigh_value                  | DECIMAL(10,2) |                              |
| order_date                    | DATE          |                              |
| order_months                  | INT           |                                   |
| order_quarter                 | INT           |                |
| order_day_of_week             | INT           |                          |
| product_photos_count          | INT           |                         |
| product_weight_grams          | DECIMAL(10,1) |                        |
| product_lenght_cm             | DECIMAL(10,1) |                         |
| product_height_cm             | DECIMAL(10,1) |                           |
| product_width_cm              | DECIMAL(10,1) |                           |
| total_item_cost               | DECIMAL(38,2) |                          |
| total_order_shipping_cost     | DECIMAL(38,2) |                          |
| shipping_to_price_ratio       | FLOAT         |                          |
| is_free_shipping              | INT           |                         |
---

### 4. **gold.logistics_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| seller_key (PK)               | INT           |               |
| customer_key (PK)             | INT           |                                         |
| order_id                      | VARCHAR(32)   |          |
| order_datetime                | DATETIME      |                                         |
| payment_datetime              | DATETIME      |                                                    |
| shipping_date                 | DATETIME      |                                |
| delivery_date                 | DATETIME      |                              |
| estimated_delivery            | DATE          |                                   |
| shipping_deadline             | DATETIME      |                 |
| actual_delivery_days          | INT           |                          |
| seller_handling_days          | INT           |                         |
| delivery_delay_days           | INT           |                           |
| delay_responsible_party       | VARCHAR(13)   |                        |
| seller_avg_delivery_days      | INT           |                          |
| city_avg_delivery_days        | INT           |                        |
| deadline_violation            | VARCHAR(3)    |                        |
---

### 4. **gold.seller_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| seller_key (PK)               | INT           |                |
| seller_city                   | VARCHAR(50)   |                                    |
| seller_state                  | CHAR(2)       |        |
| total_revenue                 | DECIMAL(38,2) |                                        |
| total_shipping_revenue        | DECIMAL(38,2) |                                                     |
| gross_merchendise_value       | DECIMAL(38,2) |                              |
| total_orders                  | INT           |                               |
| total_item_sold               | INT           |                               |
| items_per_order               | FLOAT         |                 |
| first_sale_date               | DATETIME      |                          |
| last_sale_date                | DATETIME      |                        |
| seller_lifespan_months        | INT           |                         |
| cancellation_rate             | FLOAT         |                       |
---
