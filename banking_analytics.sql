-- =================================================================
-- Проект: Банковская аналитика (Анализ транзакций клиентов)
-- Цель: Продемонстрировать навыки работы с датами и агрегацией
-- =================================================================

-- 1. РАБОТА С ДАТАМИ: Ежемесячная статистика транзакций
-- Используем DATE_TRUNC для группировки по месяцам
SELECT 
    DATE_TRUNC('month', transaction_date) AS transaction_month,
    COUNT(transaction_id) AS total_transactions,
    SUM(amount) AS total_amount,
    AVG(amount) AS avg_transaction_amount
FROM transactions
WHERE transaction_date >= '2023-01-01'
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY transaction_month;

-- 2. CTE + JOIN: Клиенты с наибольшим количеством транзакций
-- Сначала считаем количество транзакций для каждого клиента, потом джойним с таблицей клиентов
WITH client_transaction_counts AS (
    SELECT 
        customer_id,
        COUNT(transaction_id) AS transaction_count,
        SUM(amount) AS total_spent
    FROM transactions
    GROUP BY customer_id
)
SELECT 
    c.customer_name,
    c.email,
    c.registration_date,
    ct.transaction_count,
    ct.total_spent
FROM clients c
INNER JOIN client_transaction_counts ct ON c.customer_id = ct.customer_id
WHERE ct.transaction_count > 10
ORDER BY ct.total_spent DESC
LIMIT 10;

-- 3. ОКОННАЯ ФУНКЦИЯ: Скользящее среднее (Moving Average) за 3 месяца
-- Используем ROWS BETWEEN для расчета скользящего среднего
SELECT 
    DATE_TRUNC('month', transaction_date) AS transaction_month,
    SUM(amount) AS monthly_revenue,
    AVG(SUM(amount)) OVER(
        ORDER BY DATE_TRUNC('month', transaction_date)
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3_months
FROM transactions
WHERE transaction_date >= '2023-01-01'
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY transaction_month;
