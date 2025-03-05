-- Удаление базы данных 
-- DROP DATABASE restaurant_db;
-- В случае ошибки о существовании отношении 
-- DROP TABLE IF EXISTS orders;
-- DROP TABLE IF EXISTS menu;
-- DROP TABLE IF EXISTS customers;

-- Создание таблиц
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS menu (
    id SERIAL PRIMARY KEY,
    dish_name VARCHAR(50),
    price NUMERIC(6,2)
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    menu_id INT REFERENCES menu(id),
    order_date TIMESTAMP
);

-- Очистка таблиц перед вставкой тестовых данных
TRUNCATE TABLE orders RESTART IDENTITY CASCADE;
TRUNCATE TABLE customers RESTART IDENTITY CASCADE;
TRUNCATE TABLE menu RESTART IDENTITY CASCADE;

-- Вставка тестовых данных в клиентов
INSERT INTO customers (name, phone, email)
SELECT
    'Customer_' || trunc(random() * 1000)::int,
    '+7' || trunc(9000000000 + random() * 100000000)::bigint,
    'user' || trunc(random() * 1000)::int || '@example.com'
FROM generate_series(1, 10);

-- Вставка тестовых данных в меню
INSERT INTO menu (dish_name, price)
SELECT
    'Dish_' || trunc(random() * 100)::int,
    round((100 + random() * 500)::numeric, 2)
FROM generate_series(1, 10);

-- Вставка тестовых данных в заказы
INSERT INTO orders (customer_id, menu_id, order_date)
SELECT
    trunc(random() * 10 + 1)::int,
    trunc(random() * 10 + 1)::int,
    NOW() - (trunc(random() * 30) || ' days')::interval
FROM generate_series(1, 20);

-- Проверка
SELECT * FROM customers;
