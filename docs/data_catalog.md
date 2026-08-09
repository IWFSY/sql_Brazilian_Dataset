# Каталог данных золотого слоя

## Overview
Золотой уровень — это представление данных бизнес-уровня, структурированное для поддержки вариантов использования в аналитике и отчетности.

---

### 1. **gold.link_table**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных     | Описание                                                                                    |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key                  | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| product_key                   | INT           | Unique numerical identifier assigned to each customer.                                        |
| seller_key                    | INT           | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| order_id                      | VARCHAR(32)   | The customer's first name, as recorded in the system.                                         |
| item_sequence_number          | INT           | The customer's last name or family name.                                                      |
| payment_method                | VARCHAR(15)   | The country of residence for the customer (e.g., 'Australia').                                |
| payment_sequence              | INT           | The marital status of the customer (e.g., 'Married', 'Single').                               |
| payment_installments          | INT           | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| item_price                    | DECIMAL(10,2) | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| item_shipping_cost            | DECIMAL(10,2) | The date and time when the customer record was created in the system                          |
| total_order_payment           | DECIMAL(10,2) | The date and time when the customer record was created in the system                          |
| order_status                  | VARCHAR(15)   | The date and time when the customer record was created in the system                          |
| order_datetime                | DATETIME      | The date and time when the customer record was created in the system                          |
---

### 2. **gold.customer_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key (PK)             | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| customer_unique_id            | VARCHAR(32)   | Unique numerical identifier assigned to each customer.                                        |
| order_id                      | VARCHAR(32)   | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| customer_city                 | VARCHAR(50)   | The customer's first name, as recorded in the system.                                         |
| customer_state                | CHAR(2)       | The customer's last name or family name.                                                      |
| payment_sequential            | INT           | The country of residence for the customer (e.g., 'Australia').                                |
| payment_installments          | INT           | The marital status of the customer (e.g., 'Married', 'Single').                               |
| price                         | DECIMAL(10,2) | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| payment_value                 | DECIMAL(10,2) | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| order_purchase_timestamp      | DATETIME      | The date and time when the customer record was created in the system                          |
| order_delivered_customer_date | DATETIME      | The date and time when the customer record was created in the system                          |
| first_order                   | DATETIME      | The date and time when the customer record was created in the system                          |
| last_order                    | DATETIME      | The date and time when the customer record was created in the system                          |
| months_lifespan               | INT           | The date and time when the customer record was created in the system                          |
| total_orders                  | INT           | The date and time when the customer record was created in the system                          |
| total_spent                   | FLOAT         | The date and time when the customer record was created in the system                          |
| payment_type                  | VARCHAR(15)   | The date and time when the customer record was created in the system                          |
| preferred_payment_type        | VARCHAR(11)   | The date and time when the customer record was created in the system                          |
| canceled_percent              | FLOAT         | The date and time when the customer record was created in the system                          |
---

### 3. **gold.products_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key (PK)              | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| order_id                      | VARCHAR(32)   | Unique numerical identifier assigned to each customer.                                        |
| order_item_id                 | INT           | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| product_category_name         | VARCHAR(50)   | The customer's first name, as recorded in the system.                                         |
| price                         | DECIMAL(10,2) | The customer's last name or family name.                                                      |
| freigh_value                  | DECIMAL(10,2) | The country of residence for the customer (e.g., 'Australia').                                |
| order_date                    | DATE          | The marital status of the customer (e.g., 'Married', 'Single').                               |
| order_months                  | INT           | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| order_quarter                 | INT           | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| order_day_of_week             | INT           | The date and time when the customer record was created in the system                          |
| product_photos_count          | INT           | The date and time when the customer record was created in the system                          |
| product_weight_grams          | DECIMAL(10,1) | The date and time when the customer record was created in the system                          |
| product_lenght_cm             | DECIMAL(10,1) | The date and time when the customer record was created in the system                          |
| product_height_cm             | DECIMAL(10,1) | The date and time when the customer record was created in the system                          |
| product_width_cm              | DECIMAL(10,1) | The date and time when the customer record was created in the system                          |
| total_item_cost               | DECIMAL(38,2) | The date and time when the customer record was created in the system                          |
| total_order_shipping_cost     | DECIMAL(38,2) | The date and time when the customer record was created in the system                          |
| shipping_to_price_ratio       | FLOAT         | The date and time when the customer record was created in the system                          |
| is_free_shipping              | INT           | The date and time when the customer record was created in the system                          |
---

### 4. **gold.logistics_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| seller_key (PK)               | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| customer_key (PK)             | INT           | Unique numerical identifier assigned to each customer.                                        |
| order_id                      | VARCHAR(32)   | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| order_datetime                | DATETIME      | The customer's first name, as recorded in the system.                                         |
| payment_datetime              | DATETIME      | The customer's last name or family name.                                                      |
| shipping_date                 | DATETIME      | The country of residence for the customer (e.g., 'Australia').                                |
| delivery_date                 | DATETIME      | The marital status of the customer (e.g., 'Married', 'Single').                               |
| estimated_delivery            | DATE          | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| shipping_deadline             | DATETIME      | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| actual_delivery_days          | INT           | The date and time when the customer record was created in the system                          |
| seller_handling_days          | INT           | The date and time when the customer record was created in the system                          |
| delivery_delay_days           | INT           | The date and time when the customer record was created in the system                          |
| delay_responsible_party       | VARCHAR(13)   | The date and time when the customer record was created in the system                          |
| seller_avg_delivery_days      | INT           | The date and time when the customer record was created in the system                          |
| city_avg_delivery_days        | INT           | The date and time when the customer record was created in the system                          |
| deadline_violation            | VARCHAR(3)    | The date and time when the customer record was created in the system                          |
---

### 4. **gold.seller_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| seller_key (PK)               | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| seller_city                   | VARCHAR(50)   | Unique numerical identifier assigned to each customer.                                        |
| seller_state                  | CHAR(2)       | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| total_revenue                 | DECIMAL(38,2) | The customer's first name, as recorded in the system.                                         |
| total_shipping_revenue        | DECIMAL(38,2) | The customer's last name or family name.                                                      |
| gross_merchendise_value       | DECIMAL(38,2) | The country of residence for the customer (e.g., 'Australia').                                |
| total_orders                  | INT           | The marital status of the customer (e.g., 'Married', 'Single').                               |
| total_item_sold               | INT           | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| items_per_order               | FLOAT         | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| first_sale_date               | DATETIME      | The date and time when the customer record was created in the system                          |
| last_sale_date                | DATETIME      | The date and time when the customer record was created in the system                          |
| seller_lifespan_months        | INT           | The date and time when the customer record was created in the system                          |
| cancellation_rate             | FLOAT         | The date and time when the customer record was created in the system                          |
---
