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
| price                         | NVARCHAR(50)         | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                            |
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
