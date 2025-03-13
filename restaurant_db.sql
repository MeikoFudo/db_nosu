-- Удаление базы данных 
-- DROP DATABASE restaurant_db;

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE tables (
    id BIGSERIAL PRIMARY KEY,
    number INT UNIQUE,
    capacity INT,
    status VARCHAR(20)
);

CREATE TABLE dishes (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(6,2),
    category VARCHAR(50)
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    open TIMESTAMP,
    close TIMESTAMP,
    table_number INT,
    total DECIMAL,
    status VARCHAR(20),
    table_id BIGINT REFERENCES tables(id),
    order_type VARCHAR(20),
    dishes TEXT
);

CREATE TABLE reservations (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    table_number INT,
    reserved_at TIMESTAMP,
    reservation_time TIMESTAMP,
    status VARCHAR(20)
);

-- Очистка таблиц перед вставкой тестовых данных
TRUNCATE TABLE orders, reservations, dishes, tables, roles, users RESTART IDENTITY CASCADE;

-- Вставка данных в roles
INSERT INTO roles (name) VALUES
('Администратор'),
('Официант'),
('Клиент');

-- Вставка тестовых данных в users
WITH names AS (
    SELECT unnest(array['Ivan', 'Alexander', 'Sergey', 'Dmitry', 'Maxim']) AS name,
           unnest(array['ivan@example.com', 'alex@example.com', 'sergey@example.com', 'dmitry@example.com', 'maxim@example.com']) AS email,
           unnest(array['+79000000001', '+79000000002', '+79000000003', '+79000000004', '+79000000005']) AS phone
)
INSERT INTO users (name, email, phone)
SELECT name, email, phone FROM names;

-- Вставка тестовых данных в tables
INSERT INTO tables (number, capacity, status) VALUES
(1, 4, 'Свободен'),
(2, 2, 'Занят'),
(3, 6, 'Свободен');

-- Вставка тестовых данных в dishes
WITH dishes_data AS (
    SELECT unnest(array['Салат Цезарь', 'Борщ', 'Стейк', 'Паста Карбонара', 'Мороженое']) AS name,
           unnest(array[350.00, 250.00, 800.00, 450.00, 200.00]) AS price,
           unnest(array['Закуски', 'Супы', 'Основные блюда', 'Основные блюда', 'Десерты']) AS category
)
INSERT INTO dishes (name, price, category)
SELECT name, price, category FROM dishes_data;

-- Вставка тестовых данных в orders
INSERT INTO orders (user_id, open, close, table_number, total, status, table_id, order_type, dishes)
SELECT 
    (random() * 5 + 1)::int,
    NOW() - (trunc(random() * 10) || ' days')::interval,
    NOW(),
    (random() * 3 + 1)::int,
    round(random() * 1000 + 500, 2),
    'Ожидание',
    (random() * 3 + 1)::int,
    'В зале',
    'Салат Цезарь, Стейк';

-- Вставка тестовых данных в reservations
INSERT INTO reservations (user_id, table_number, reserved_at, reservation_time, status)
SELECT
    (random() * 5 + 1)::int,
    (random() * 3 + 1)::int,
    NOW() - (trunc(random() * 5) || ' days')::interval,
    NOW() + (trunc(random() * 5 + 1) || ' days')::interval,
    'Подтверждено';

-- Проверка
SELECT * FROM users;
SELECT * FROM dishes;
SELECT * FROM orders;
SELECT * FROM reservations;
