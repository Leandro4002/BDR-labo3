-- BEGIN Exercice 1

SELECT
    customer_id,
    last_name AS nom,
    email
FROM customer
WHERE first_name = 'PHYLLIS'
    AND store_id = 1
ORDER BY customer_id ASC;

-- END Exercice 1

-- BEGIN Exercice 2

SELECT
    title AS titre, release_year AS annee_sortie
FROM pagila.film
WHERE length < 60 AND replacement_cost=12.99
ORDER BY title;

-- END Exercice 2

-- BEGIN Exercice 3

SELECT
    co.country,
    ci.city,
    a.postal_code
FROM city ci
    INNER JOIN country co
        ON ci.country_id = co.country_id
    INNER JOIN address a
        ON ci.city_id = a.city_id
WHERE co.country = 'France'
    OR (co.country_id >= 63 AND co.country_id <= 67)
ORDER BY co.country, ci.city, a.postal_code;

-- END Exercice 3

-- BEGIN Exercice 4

SELECT
    customer_id, first_name AS prenom, last_name AS nom
FROM pagila.customer c
INNER JOIN pagila.address a ON c.address_id = a.address_id
WHERE a.city_id = 117
ORDER BY first_name;

-- END Exercice 4

-- BEGIN Exercice 5


-- END Exercice 5

-- BEGIN Exercice 6

SELECT
    a.last_name AS nom, a.first_name AS prenom
FROM pagila.actor a
WHERE a.first_name LIKE 'K%' OR a.last_name LIKE 'D%' AND a.actor_id IN (
    SELECT
        fa.actor_id
    FROM pagila.film_actor fa
    WHERE fa.film_id IN (
        SELECT
            f.film_id
        FROM pagila.film f
        WHERE f.film_id IN (
            SELECT
                fc.film_id
            FROM pagila.film_category fc
            WHERE fc.category_id IN (
                SELECT
                    category_id
                FROM pagila.category c
                WHERE name = 'Horror'
                )
            )
        )
    );

-- END Exercice 6

-- BEGIN Exercice 8

-- (b)
SELECT
    customer_id AS id,
    last_name AS nom,
    first_name AS prenom
FROM pagila.customer cu
WHERE cu.address_id IN (
    SELECT
        a.address_id
    FROM pagila.address a
    WHERE a.city_id IN (
        SELECT
            ci.city_id
        FROM pagila.city ci
        WHERE ci.country_id = (
            SELECT
                co.country_id
            FROM pagila.country co
            WHERE country='Spain'
            )
        )
    )
ORDER BY last_name;

-- (c)

-- INNER JOOOOOOIN

-- END Exercice 8