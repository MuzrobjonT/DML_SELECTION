SELECT
  f.title,
  AVG(f_age.age) AS expected_audience_age
FROM
  (
    SELECT
      c.customer_id,
      f.film_id,
      f.release_year,
      EXTRACT(YEAR FROM CURRENT_DATE) - f.release_year AS age
    FROM
      film f
      JOIN rental r ON f.film_id = r.inventory_id
      JOIN customer c ON r.customer_id = c.customer_id
  ) AS f_age
JOIN customer c ON f_age.customer_id = c.customer_id
JOIN film f ON f_age.film_id = f.film_id
GROUP BY
  f.title
ORDER BY
  COUNT(f_age.film_id) DESC
LIMIT
  5;
