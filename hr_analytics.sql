-- =================================================================
-- Проект: HR-аналитика (Анализ данных сотрудников)
-- Цель: Продемонстрировать навыки работы с оконными функциями и подзапросами
-- =================================================================

-- 1. ОКОННАЯ ФУНКЦИЯ: Ранжирование сотрудников по зарплате внутри каждого отдела
-- Используем RANK() и PARTITION BY для группировки по отделам
SELECT 
    employee_name,
    department,
    salary,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank_in_dept
FROM employees
WHERE is_active = TRUE
ORDER BY department, salary_rank_in_dept;

-- 2. ПОДЗАПРОС: Сотрудники с зарплатой выше средней по своей должности
-- Вложенный запрос вычисляет среднюю зарплату для каждой должности
SELECT 
    employee_name,
    position,
    salary,
    (SELECT AVG(salary) FROM employees e2 WHERE e2.position = e1.position) AS avg_position_salary
FROM employees e1
WHERE salary > (SELECT AVG(salary) FROM employees e2 WHERE e2.position = e1.position)
ORDER BY position, salary DESC;

-- 3. АГРЕГАЦИЯ С УСЛОВИЕМ: Статистика по отделам с фильтрацией
-- Используем HAVING для фильтрации после группировки
SELECT 
    department,
    COUNT(employee_id) AS total_employees,
    AVG(salary) AS avg_salary,
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary
FROM employees
GROUP BY department
HAVING COUNT(employee_id) > 5  -- Только отделы с более чем 5 сотрудниками
ORDER BY avg_salary DESC;
