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

