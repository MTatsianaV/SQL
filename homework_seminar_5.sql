use semimar_4;

/* Создайте представление, в которое попадет информация о пользователях (имя, фамилия,
город и пол), которые не старше 20 лет. */

CREATE OR REPLACE VIEW user_information
AS 
(SELECT firstname, lastname, gender, hometown
FROM users
JOIN profiles ON uSers.id = profiles.user_id 
WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) <= 20);

SELECT *
FROM user_information;

/* Найдите кол-во, отправленных сообщений каждым пользователем и выведите
ранжированный список пользователей, указав имя и фамилию пользователя, количество
отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным
количеством сообщений) . (используйте DENSE_RANK)  */

SELECT users.id, firstname, lastname, COUNT(messages.body) AS sent_messages,
DENSE_RANK() OVER(ORDER BY COUNT(messages.body) DESC) place_in_the_ranking
FROM users
JOIN messages ON users.id = messages.from_user_id
GROUP BY users.id
;

/* Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления
(created_at) и найдите разницу дат отправления между соседними сообщениями, получившегося
списка. (используйте LEAD или LAG) */

SELECT body AS message, created_at AS date_of_creation,
timestampdiff(minute, lag(created_at) OVER(ORDER BY created_at), created_at) AS date_difference_in_minutes 
FROM messages
ORDER BY created_at
;