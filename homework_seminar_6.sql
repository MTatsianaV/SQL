use semimar_4;

/*Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой 
можно переместить любого (одного) пользователя из таблицы users в таблицу users_old 
(использование транзакции с выбором commit или rollback обязательно).*/

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(100) UNIQUE
);
DROP PROCEDURE IF EXISTS moving_user_to_users_old;
DELIMITER //
CREATE PROCEDURE moving_user_to_users_old(moved_user_id INT)
BEGIN
START TRANSACTION;
INSERT INTO users_old SELECT * FROM users WHERE users.id = moved_user_id;
DELETE FROM users WHERE users.id = moved_user_id LIMIT 1;
COMMIT;
END //
DELIMITER ;
CALL moving_user_to_users_old(5); 
SELECT * FROM users_old;
SELECT * FROM users;
INSERT INTO users (id, firstname, lastname, email) VALUES 
(5, 'Frederick', 'Effertz', 'von.bridget@example.net');

/*Создайте хранимую функцию hello(), которая будет возвращать приветсвие в зависимости от текущего времени 
суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 - функция должна 
возвращать фразу "Добрый день", с 18:00 до 00:00 - "Добрый вечер", с 00:00 до 6:00 - "Доброй ночи".*/

DROP FUNCTION IF EXISTS hello; 
DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(20) READS SQL DATA
BEGIN
	SET @now =  curtime();
    SET @stop_evening = '24:00:00';
	SEt @stop_night = '06:00:00';
    SET @stop_morning = '12:00:00';
    SET @stop_afternoon = '18:00:00';    
RETURN
	CASE
		WHEN @now >= @stop_evening AND @now <  @stop_night THEN 'Доброй ночи!'
        WHEN @now >= @stop_night AND @now <  @stop_morning THEN 'Доброе утро!'
        WHEN @now >= @stop_morning AND @now <  @stop_afternoon THEN 'Добрый день!'
        WHEN @now >= @stop_afternoon AND @now <  @stop_evening THEN 'Добрый вечер!'
	END;
END//
DELIMITER ;
SELECT curtime() AS now, hello() AS hello;