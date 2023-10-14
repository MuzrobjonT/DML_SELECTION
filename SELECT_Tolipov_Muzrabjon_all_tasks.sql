#Task 1
WITH RevenuePerStaff AS (
    SELECT
        p.staff_id,
        s.store_id,
        SUM(p.amount) AS total_revenue
    FROM
        payment p
        JOIN staff s ON p.staff_id = s.staff_id
        JOIN rental r ON p.rental_id = r.rental_id
    WHERE
        EXTRACT(YEAR FROM p.payment_date) = 2017
    GROUP BY
        p.staff_id, s.store_id
),
MaxRevenuePerStore AS (
    SELECT
        store_id,
        MAX(total_revenue) AS max_revenue
    FROM
        RevenuePerStaff
    GROUP BY
        store_id
)
SELECT
    r.store_id,
    r.staff_id,
    r.total_revenue AS revenue_for_2017
FROM
    RevenuePerStaff r
    JOIN MaxRevenuePerStore m ON r.store_id = m.store_id AND r.total_revenue = m.max_revenue
ORDER BY
    r.store_id;

#task2 
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

#task3
WITH ActorInactivity AS (
    SELECT
        a.actor_id,
        a.first_name,
        a.last_name,
        MAX(r.rental_date) AS last_movie_date
    FROM
        actor a
        LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
        LEFT JOIN film f ON fa.film_id = f.film_id
        LEFT JOIN inventory i ON f.film_id = i.film_id
        LEFT JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY
        a.actor_id, a.first_name, a.last_name
)
SELECT
    ai.actor_id,
    ai.first_name,
    ai.last_name,
    ai.last_movie_date,
    EXTRACT(DAY FROM NOW() - ai.last_movie_date) AS days_since_last_movie
FROM
    ActorInactivity ai
ORDER BY
    days_since_last_movie DESC;




