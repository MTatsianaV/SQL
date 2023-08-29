use semimar_4;

/* Подсчитать общее количество лайков, которые получили пользователи младше 12 лет. */

SELECT COUNT(likes.user_id) AS total_likes
FROM likes
JOIN profiles ON profiles.user_id = likes.user_id
WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) < 12;

/* Определить кто больше поставил лайков (всего): мужчины или женщины.  */

SELECT gender, COUNT(likes.user_id) AS total_likes
FROM likes
JOIN profiles ON profiles.user_id = likes.user_id
GROUP BY gender
ORDER BY total_likes DESC
LIMIT 1
;

/* Вывести всех пользователей, которые не отправляли сообщения. */

SELECT *
FROM users
LEFT JOIN messages ON users.id = messages.from_user_id
WHERE messages.from_user_id IS NULL;