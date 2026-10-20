-- 1. Criar o banco aula04_ambiente com charset utf8mb4 (pode rodar várias vezes sem erro)
DROP DATABASE IF EXISTS aula04_ambiente;
CREATE DATABASE aula04_ambiente CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Mostrar só esse banco na lista de bancos
SHOW DATABASES LIKE 'aula04_ambiente';

-- 3. Selecionar o banco e confirmar qual está em uso
USE aula04_ambiente;
SELECT DATABASE() AS 'Banco em Uso';

-- 4. Mostrar a versão e a porta do servidor
SELECT VERSION() AS 'Versão do Servidor', @@port AS 'Porta do Servidor';

-- 5. Contar as linhas de film, customer e rental da Sakila
SELECT COUNT(*) FROM sakila.film;
SELECT COUNT(*) FROM sakila.customer;
SELECT COUNT(*) FROM sakila.rental;

-- Contagens observadas na base padrão Sakila (valores de referência):
-- film: 1000
-- customer: 599
-- rental: 16044