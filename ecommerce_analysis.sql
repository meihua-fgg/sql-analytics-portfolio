-- =================================================================
-- Проект: Анализ данных интернет-магазина (E-commerce)
-- Инструменты: SQL (PostgreSQL/MySQL синтаксис)
-- Цель: Продемонстрировать навыки работы с агрегацией, JOIN, CTE и оконными функциями
-- =================================================================

-- 1. БАЗОВАЯ АГРЕГАЦИЯ: Топ-5 категорий товаров по общей выручке
-- Используем GROUP BY и агрегатную функцию SUM
SELECT 
    category_name,
    SUM(sales_amount) AS total_revenue,
    COUNT(order_id) AS total_orders
FROM sales
GROUP BY category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 2. ОБЪЕДИНЕНИЕ ТАБЛИЦ (JOIN): Детализация заказов с данными о клиентах
-- Используем INNER JOIN для связывания таблицы продаж и таблицы клиентов
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    c.city,
    o.sales_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date >= '2023-01-01'
ORDER BY o.order_date DESC;

-- 3. ПРОДВИНУТЫЙ УРОВЕНЬ: CTE (WITH) и Оконная функция (ROW_NUMBER)
-- Задача: Найти топ-1 менеджера по продажам в каждом месяце
WITH monthly_manager_sales AS (
    SELECT 
        manager_name,
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(sales_amount) AS total_sales
    FROM sales
    GROUP BY manager_name, DATE_TRUNC('month', order_date)
)
SELECT 
    sales_month,
    manager_name,
    total_sales,
    ROW_NUMBER() OVER(PARTITION BY sales_month ORDER BY total_sales DESC) AS sales_rank
FROM monthly_manager_sales
WHERE sales_rank = 1
ORDER BY sales_month DESC;
