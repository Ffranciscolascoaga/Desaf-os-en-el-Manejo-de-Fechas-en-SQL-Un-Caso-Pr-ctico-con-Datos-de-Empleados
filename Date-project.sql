CREATE DATABASE EMPLOYEES_DB;

USE EMPLOYEES_DB;

SELECT * FROM limpieza;

SET SQL_SAFE_UPDATES = 0;
-- en primera instancia tengo datos inconsistentes en las columnas de fechas, por lo cual debo 
-- arreglarlas


SELECT 
	CASE 
		WHEN SUBSTRING_INDEX(birth_date, '/', 1) > 12 THEN STR_TO_DATE(birth_date, '%d/%m/%Y')
        ELSE STR_TO_DATE(birth_date, '%m/%d/%Y')
	END AS Birth_date_formatted
FROM limpieza;

ALTER TABLE limpieza ADD COLUMN Birth_date_formatted DATE;

UPDATE limpieza
SET Birth_date_formatted = CASE 
		WHEN SUBSTRING_INDEX(birth_date, '/', 1) > 12 THEN STR_TO_DATE(birth_date, '%d/%m/%Y')
        ELSE STR_TO_DATE(birth_date, '%m/%d/%Y')
	END;


    
SELECT birth_date, birth_date_formatted FROM limpieza
LIMIT 5;

SELECT * FROM limpieza;

SELECT 
	CASE
		WHEN SUBSTRING_INDEX(star_date, '/',1) > 12 THEN STR_TO_DATE(star_date, '%d/%m/%Y')
        ELSE STR_TO_DATE(star_date, '%d/%m/%Y')
        END AS star_date_formatted
FROM limpieza;

ALTER TABLE limpieza ADD COLUMN star_date_formatted DATE;

UPDATE limpieza 
SET star_date_formatted = CASE 
		WHEN SUBSTRING_INDEX(star_date, '/', 1) > 12 THEN STR_TO_DATE(star_date, '%d/%m/%Y')
        ELSE STR_TO_DATE(star_date, '%m/%d/%Y')
	END;

  
  
SELECT start_date, start_date_formatted FROM limpieza
LIMIT 5;



UPDATE limpieza
SET finish_date = STR_TO_DATE(finish_date, '%Y-%m-%d %H:%i:%s UTC')
WHERE finish_date IS NOT NULL AND finish_date != '';

-- la columna finish date ahora se encuentra en formato fecha pero sigue teniendo la fecha y hora juntos
-- por lo tanto procedo a separarlas para una mejor claridad de los datos

ALTER TABLE limpieza
ADD COLUMN finish_date_only DATE,
ADD COLUMN finish_time_only TIME;

UPDATE limpieza
SET finish_date_only = IF(finish_date = '', NULL, DATE(finish_date)),
    finish_time_only = IF(finish_date = '', NULL, TIME(finish_date));

SELECT finish_date, finish_date_only, finish_time_only FROM limpieza 
LIMIT 5;


SELECT * FROM limpieza;
-- UNA VEZ ARREGLADAS LAS COLUMNAS DE FECHAS, PASO A CORREGIR EL NOMBRE DE LAS COLUMNAS 

ALTER TABLE limpieza CHANGE COLUMN `﻿Id?empleado` id_emp varchar(20);
ALTER TABLE limpieza CHANGE COLUMN `﻿Name` name varchar(20);
ALTER TABLE limpieza CHANGE COLUMN `Apellido` last_name VARCHAR(20);
ALTER TABLE limpieza CHANGE COLUMN `género` gender VARCHAR(20);
ALTER TABLE limpieza CHANGE COLUMN `género` gender VARCHAR(20);
ALTER TABLE limpieza CHANGE COLUMN `star_date` start_date varchar(20);
ALTER TABLE limpieza CHANGE COLUMN `star_date_formatted` start_date_formatted date;

ALTER TABLE limpieza DROP COLUMN start_date;


SELECT * FROM limpieza;


select salary from limpieza;

UPDATE limpieza
SET salary = CAST(REPLACE(REPLACE(salary, '$', ''), ',', '') AS DECIMAL(10, 2))
WHERE salary IS NOT NULL;

SELECT finish_date FROM limpieza;

DESCRIBE limpieza;



SELECT name, last_name, TIMESTAMPDIFF(YEAR, start_date_formatted, CURRENT_DATE()) AS antigüedad
FROM limpieza
WHERE start_date_formatted <= CURRENT_DATE() - INTERVAL 1 YEAR
LIMIT 3;
SELECT * FROM limpieza;

SELECT 
    name, 
    last_name, 
    start_date_formatted + INTERVAL 2 DAY AS add_2days, 
    start_date_formatted - INTERVAL 3 DAY AS minus_3days, 
    finish_time_only + INTERVAL 4 HOUR AS add_4hours, 
    finish_date_only - INTERVAL 30 MINUTE AS minus_30mins 
FROM limpieza
LIMIT 5;

SELECT 
    EXTRACT(YEAR FROM start_date_formatted) AS año_inicio, 
    COUNT(*) AS cantidad_empleados
FROM limpieza
GROUP BY año_inicio
HAVING COUNT(*) > 10
LIMIT 5;



		