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
| seller_key                    | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| order_id                      | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |
| item_sequence_number          | NVARCHAR(50)  | The customer's last name or family name.                                                      |
| payment_method                | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                                |
| payment_sequence              | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                               |
| payment_installments          | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| item_price                    | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| item_shipping_cost            | DATE          | The date and time when the customer record was created in the system                          |
| total_order_payment           | DATE          | The date and time when the customer record was created in the system                          |
| order_status                  | DATE          | The date and time when the customer record was created in the system                          |
| order_datetime                | DATE          | The date and time when the customer record was created in the system                          |
---

### 2. **gold.customer_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key (PK)             | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| customer_unique_id            | INT           | Unique numerical identifier assigned to each customer.                                        |
| order_id                      | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| customer_city                 | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |
| customer_state                | NVARCHAR(50)  | The customer's last name or family name.                                                      |
| payment_sequential            | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                                |
| payment_installments          | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                               |
| price                         | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| payment_value                 | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| order_purchase_timestamp      | DATE          | The date and time when the customer record was created in the system                          |
| order_delivered_customer_date | DATE          | The date and time when the customer record was created in the system                          |
| first_order                   | DATE          | The date and time when the customer record was created in the system                          |
| last_order                    | DATE          | The date and time when the customer record was created in the system                          |
| months_lifespan               | DATE          | The date and time when the customer record was created in the system                          |
| total_orders                  | DATE          | The date and time when the customer record was created in the system                          |
| total_spent                   | DATE          | The date and time when the customer record was created in the system                          |
| payment_type                  | DATE          | The date and time when the customer record was created in the system                          |
| preferred_payment_type        | DATE          | The date and time when the customer record was created in the system                          |
| canceled_percent              | DATE          | The date and time when the customer record was created in the system                          |
---

### 3. **gold.products_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key (PK)              | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| order_id                      | INT           | Unique numerical identifier assigned to each customer.                                        |
| order_item_id                 | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| product_category_name         | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |
| price                         | NVARCHAR(50)  | The customer's last name or family name.                                                      |
| freigh_value                  | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                                |
| order_date                    | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                               |
| order_months                  | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| order_quarter                 | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| order_day_of_week             | DATE          | The date and time when the customer record was created in the system                          |
| product_photos_count          | DATE          | The date and time when the customer record was created in the system                          |
| product_weight_grams          | DATE          | The date and time when the customer record was created in the system                          |
| product_lenght_cm             | DATE          | The date and time when the customer record was created in the system                          |
| product_height_cm             | DATE          | The date and time when the customer record was created in the system                          |
| product_width_cm              | DATE          | The date and time when the customer record was created in the system                          |
| total_item_cost               | DATE          | The date and time when the customer record was created in the system                          |
| total_order_shipping_cost     | DATE          | The date and time when the customer record was created in the system                          |
| shipping_to_price_ratio       | DATE          | The date and time when the customer record was created in the system                          |
| is_free_shipping              | DATE          | The date and time when the customer record was created in the system                          |
---

### 4. **gold.logistics_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| seller_key (PK)               | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| customer_key (PK)             | INT           | Unique numerical identifier assigned to each customer.                                        |
| order_id                      | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| order_datetime                | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |
| payment_datetime              | NVARCHAR(50)  | The customer's last name or family name.                                                      |
| shipping_date                 | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                                |
| delivery_date                 | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                               |
| estimated_delivery            | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| shipping_deadline             | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| actual_delivery_days          | DATE          | The date and time when the customer record was created in the system                          |
| seller_handling_days          | DATE          | The date and time when the customer record was created in the system                          |
| delivery_delay_days           | DATE          | The date and time when the customer record was created in the system                          |
| delay_responsible_party       | DATE          | The date and time when the customer record was created in the system                          |
| seller_avg_delivery_days      | DATE          | The date and time when the customer record was created in the system                          |
| city_avg_delivery_days        | DATE          | The date and time when the customer record was created in the system                          |
| deadline_violation            | DATE          | The date and time when the customer record was created in the system                          |
---

### 4. **gold.seller_mart**
- **Цель:** 
- **Список колонок:**

| Название колонки              | Тип даннных   | Описание                                                                                      |
|-------------------------------|---------------|-----------------------------------------------------------------------------------------------|
| seller_key (PK)               | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| seller_city                   | INT           | Unique numerical identifier assigned to each customer.                                        |
| seller_state                  | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| total_revenue                 | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |
| total_shipping_revenue        | NVARCHAR(50)  | The customer's last name or family name.                                                      |
| gross_merchendise_value       | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                                |
| total_orders                  | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                               |
| total_item_sold               | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                   |
| items_per_order               | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).                |
| first_sale_date               | DATE          | The date and time when the customer record was created in the system                          |
| last_sale_date                | DATE          | The date and time when the customer record was created in the system                          |
| seller_lifespan_months        | DATE          | The date and time when the customer record was created in the system                          |
| cancellation_rate             | DATE          | The date and time when the customer record was created in the system                          |
---
