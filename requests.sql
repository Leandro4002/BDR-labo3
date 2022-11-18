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

SELECT
    c1.first_name AS prenom_1,
    c1.last_name AS nom_1,
    c2.first_name AS prenom_2,
    c2.last_name AS nom_2
FROM film f
INNER JOIN inventory i
    ON i.film_id = f.film_id
INNER JOIN rental r1
    ON r1.inventory_id = i.inventory_id
INNER JOIN rental r2
    ON r2.inventory_id = i.inventory_id
INNER JOIN customer c1
    ON r1.customer_id = c1.customer_id
INNER JOIN customer c2
    ON r2.customer_id = c2.customer_id
WHERE
    c1.customer_id != c2.customer_id;

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

-- BEGIN Exercice 7

-- Version 1

SELECT
    film_id AS id,
    title AS titre,
    rental_rate / rental_duration AS prix_location_par_jour
FROM film f
WHERE
    rental_rate / rental_duration <= 1
    AND film_id NOT IN (
        SELECT
            film_id
        FROM rental
        INNER JOIN inventory i
            ON i.inventory_id = rental.inventory_id
    );

-- Version 2

SELECT
    film_id AS id,
    title AS titre,
    rental_rate / rental_duration AS prix_location_par_jour
FROM film f
WHERE
    rental_rate / rental_duration <= 1
    AND NOT EXISTS (
        SELECT
            film_id
        FROM rental
        INNER JOIN inventory i
            ON i.inventory_id = rental.inventory_id
        WHERE
            i.film_id = f.film_id
    );

-- END Exercice 7

-- BEGIN Exercice 8

-- (a)

SELECT
    cu.customer_id AS id,
    cu.last_name AS nom,
    cu.first_name AS prenom
FROM pagila.customer cu
WHERE EXISTS
    (
    SELECT a.address_id
    FROM address a
    WHERE a.address_id = cu.address_id AND EXISTS (
        SELECT c.city_id
        FROM city c
        WHERE c.city_id = a.city_id AND EXISTS (
            SELECT co.country_id
            FROM country co
            WHERE co.country_id = c.country_id AND co.country = 'Spain'
            )
        )
)
AND EXISTS
(SELECT r.customer_id FROM rental r WHERE cu.customer_id = r.customer_id AND r.return_date IS NULL)
ORDER BY last_name;

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
AND cu.customer_id IN (
    SELECT
        customer_id
    FROM rental r
    WHERE r.return_date IS NULL
    )
ORDER BY last_name;

-- (c)

SELECT
    cu.customer_id AS id,
    cu.last_name AS nom,
    cu.first_name AS prenom
FROM pagila.customer cu
INNER JOIN address a on cu.address_id = a.address_id
INNER JOIN city c on a.city_id = c.city_id
INNER JOIN country co on co.country_id = c.country_id
INNER JOIN rental r on r.customer_id = cu.customer_id
WHERE
    co.country = 'Spain'
    AND r.return_date IS NULL
ORDER BY last_name;

-- END Exercice 8

-- BEGIN Exercice 9

SELECT
    c.customer_id,
    c.first_name AS prenom,
    c.last_name AS nom
FROM customer c
WHERE
    ( -- Compte le nombre de film différent avec Emily Dee que le customer a loué
        SELECT
            COUNT(DISTINCT f.film_id)
        FROM rental r
        INNER JOIN inventory i
            ON i.inventory_id = r.inventory_id
         INNER JOIN film f
            ON f.film_id = i.film_id
         INNER JOIN film_actor fa
            ON fa.film_id = f.film_id
         INNER JOIN actor a
            ON fa.actor_id = a.actor_id
         WHERE
            r.customer_id = c.customer_id
            AND a.first_name = 'EMILY' AND a.last_name = 'DEE'
    )
    =
    ( -- Compte le nombre total de film avec Emily Dee
        SELECT
            COUNT(*)
        FROM film f
        INNER JOIN film_actor fa
            ON fa.film_id = f.film_id
        INNER JOIN actor a
            ON fa.actor_id = a.actor_id
        WHERE
            a.first_name = 'EMILY' AND a.last_name = 'DEE'
    );


-- END Exercice 9

-- BEGIN Exercice 11



-- END Exercice 11

-- BEGIN