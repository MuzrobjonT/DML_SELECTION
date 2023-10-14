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
