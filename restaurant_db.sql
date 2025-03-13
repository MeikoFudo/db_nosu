-- Удаление базы данных (если необходимо)
-- DROP DATABASE restaurant_db;

-- Создание таблиц
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE menu (
    id SERIAL PRIMARY KEY,
    dish_name VARCHAR(50),
    price NUMERIC(6,2)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    menu_id INT REFERENCES menu(id),
    order_date TIMESTAMP
);

-- Очистка таблиц перед вставкой тестовых данных
TRUNCATE TABLE orders RESTART IDENTITY CASCADE;
TRUNCATE TABLE customers RESTART IDENTITY CASCADE;
TRUNCATE TABLE menu RESTART IDENTITY CASCADE;

-- Список имен и фамилий для случайной генерации
WITH name_data AS (
    SELECT 
        unnest(array['Ivan', 'Alexander', 'Sergey', 'Dmitry', 'Maxim', 'Nikolai', 'Andrei', 'Mikhail', 'Vladimir', 'Alexey']) AS first_name,
        unnest(array['Ivanov', 'Petrov', 'Sidorov', 'Kozlov', 'Smirnov', 'Volkov', 'Lebedev', 'Fedorov', 'Makarov', 'Orlov']) AS last_name
)
-- Вставка тестовых данных в клиентов с реальными именами
INSERT INTO customers (name, phone, email)
SELECT
    first_name || ' ' || last_name,  -- Генерация имени и фамилии
    '+7' || trunc(9000000000 + random() * 100000000)::bigint,  -- Случайный номер телефона
    'user' || trunc(random() * 1000)::int || '@example.com'  -- Случайный email
FROM name_data
ORDER BY random()
LIMIT 10;

-- Вставка тестовых данных в меню
INSERT INTO menu (dish_name, price)
SELECT
    'Dish_' || trunc(random() * 100)::int,  -- Случайное название блюда
    round((100 + random() * 500)::numeric, 2)  -- Случайная цена
FROM generate_series(1, 10);

-- Вставка тестовых данных в заказы
INSERT INTO orders (customer_id, menu_id, order_date)
SELECT
    trunc(random() * 10 + 1)::int,  -- Случайный идентификатор клиента
    trunc(random() * 10 + 1)::int,  -- Случайный идентификатор блюда
    NOW() - (trunc(random() * 30) || ' days')::interval  -- Случайная дата заказа (в пределах последних 30 дней)
FROM generate_series(1, 20);

-- Проверка
SELECT * FROM customers;
