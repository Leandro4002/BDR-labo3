SET search_path = pagila;

-- BEGIN Exercice 01
SELECT
    customer_id,
    last_name AS nom,
    email
FROM customer
WHERE first_name = 'PHYLLIS'
    AND store_id = 1
ORDER BY customer_id DESC;
-- END Exercice 01


-- BEGIN Exercice 02
SELECT
    title AS titre,
    release_year AS annee_sortie
FROM film
WHERE rating = 'R'
    AND length < 60
    AND replacement_cost=12.99
ORDER BY title;
-- END Exercice 02


-- BEGIN Exercice 03
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
    OR (co.country_id >= 63
    AND co.country_id <= 67)
ORDER BY co.country,
    ci.city,
    a.postal_code;
-- END Exercice 03


-- BEGIN Exercice 04
SELECT
    customer_id,
    first_name AS prenom,
    last_name AS nom
FROM customer c
INNER JOIN address a
    ON c.address_id = a.address_id
WHERE c.active = true
    AND a.city_id = 171
    AND c.store_id = 1
ORDER BY first_name;
-- END Exercice 04


-- BEGIN Exercice 05
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
-- END Exercice 05


-- BEGIN Exercice 06
SELECT DISTINCT
    a.last_name AS nom,
    a.first_name AS prenom
FROM actor a
WHERE a.first_name LIKE 'K%' OR a.last_name LIKE 'D%' AND a.actor_id IN (
    SELECT
        fa.actor_id
    FROM film_actor fa
    WHERE fa.film_id IN (
        SELECT
            f.film_id
        FROM film f
        WHERE f.film_id IN (
            SELECT
                fc.film_id
            FROM film_category fc
            WHERE fc.category_id IN (
                SELECT
                    category_id
                FROM category c
                WHERE name = 'Horror'
                )
            )
        )
    );
-- END Exercice 06


-- BEGIN Exercice 07a
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
-- END Exercice 07a


-- BEGIN Exercice 07b
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
-- END Exercice 07b


-- BEGIN Exercice 08a
SELECT
    cu.customer_id AS id,
    cu.last_name AS nom,
    cu.first_name AS prenom
FROM customer cu
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
-- END Exercice 08a


-- BEGIN Exercice 08b
SELECT
    customer_id AS id,
    last_name AS nom,
    first_name AS prenom
FROM customer cu
WHERE cu.address_id IN (
    SELECT
        a.address_id
    FROM address a
    WHERE a.city_id IN (
        SELECT
            ci.city_id
        FROM city ci
        WHERE ci.country_id = (
            SELECT
                co.country_id
            FROM country co
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
-- END Exercice 08b


-- BEGIN Exercice 08c
SELECT
    cu.customer_id AS id,
    cu.last_name AS nom,
    cu.first_name AS prenom
FROM customer cu
INNER JOIN address a on cu.address_id = a.address_id
INNER JOIN city c on a.city_id = c.city_id
INNER JOIN country co on co.country_id = c.country_id
INNER JOIN rental r on r.customer_id = cu.customer_id
WHERE
    co.country = 'Spain'
    AND r.return_date IS NULL
ORDER BY last_name;
-- END Exercice 08c


-- BEGIN Exercice 09 (Bonus)
SELECT
    c.customer_id,
    c.first_name AS prenom,
    c.last_name AS nom
FROM customer c
WHERE
    ( -- Compte le nombre de film diff??rent avec Emily Dee que le customer a lou??
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
-- END Exercice 09 (Bonus)


-- BEGIN Exercice 10
SELECT
    f.title AS titre,
    COUNT(fa.actor_id) AS nb_acteurs
FROM film f
INNER JOIN film_actor fa on f.film_id = fa.film_id
INNER JOIN film_category fc on f.film_id = fc.film_id
INNER JOIN category c on fc.category_id = c.category_id
WHERE
    c.name = 'Drama'
GROUP BY f.title
HAVING COUNT(fa.actor_id) < 5
ORDER BY nb_acteurs DESC;
-- END Exercice 10


-- BEGIN Exercice 11
SELECT
    c.category_id AS id,
    c.name AS nom,
    COUNT(fc.film_id) AS nb_films
FROM category c
INNER JOIN film_category fc
    ON c.category_id = fc.category_id
GROUP BY c.category_id
HAVING COUNT(fc.film_id) > 65
ORDER BY COUNT(fc.film_id);
-- END Exercice 11


-- BEGIN Exercice 12
SELECT
    f.film_id AS id,
    f.title AS titre,
    f.length AS duree
FROM film f
WHERE f.length <= ALL (SELECT length FROM film);
-- END Exercice 12


-- BEGIN Exercice 13a
SELECT
    f.film_id as id,
    f.title as titre
FROM film f
INNER JOIN film_actor fa
    ON f.film_id = fa.film_id
WHERE fa.actor_id IN
    (
        SELECT
            fa2.actor_id
        FROM film_actor fa2
        GROUP BY fa2.actor_id
        HAVING COUNT(fa2.actor_id) > 40
    );
-- END Exercice 13a


-- BEGIN Exercice 13b
SELECT
    f.film_id as id,
    f.title as titre
FROM film f
INNER JOIN film_actor fa
    ON fa.film_id = f.film_id
INNER JOIN (
        SELECT
            fa2.actor_id
        FROM film_actor fa2
        GROUP BY fa2.actor_id
        HAVING COUNT(fa2.actor_id) > 40
    ) as fa3
    ON fa3.actor_id = fa.actor_id;
-- END Exercice 13b


-- BEGIN Exercice 14
SELECT
    SUM(f.length) / 60 / 8 AS nb_jours
FROM film f;
-- END Exercice 14


-- BEGIN Exercice 15
SELECT
    c.customer_id as id,
    c.last_name as nom,
    c.email,
    co.country as pays,
    COUNT(r.rental_id) as nb_locations,
    SUM(p.amount) as depense_total,
    AVG(p.amount) as depense_moyenne
FROM customer c
INNER JOIN address a
    ON c.address_id = a.address_id
INNER JOIN city ci
    ON a.city_id = ci.city_id
INNER JOIN country co
    ON ci.country_id = co.country_id
INNER JOIN rental r
    ON c.customer_id = r.customer_id
INNER JOIN payment p
    ON r.rental_id = p.rental_id
WHERE
    co.country IN ('Switzerland', 'France', 'Germany')
GROUP BY c.customer_id, c.last_name, c.email, co.country
HAVING AVG(p.amount) > 3.0
ORDER BY co.country, c.last_name;
-- END Exercice 15


-- BEGIN Exercice 16a
SELECT
    COUNT(*)
FROM payment p
WHERE p.amount <= 9;
-- R??sultat: 15678
-- END Exercice 16a


-- BEGIN Exercice 16b
DELETE FROM payment p WHERE p.amount <= 9;
-- END Exercice 16b

-- BEGIN Exercice 16c
SELECT
    COUNT(*)
FROM payment p
WHERE p.amount <= 9;
-- R??sultat: 0
-- END Exercice 16c


-- BEGIN Exercice 17
UPDATE payment
SET
    amount = amount * 1.5,
    payment_date = NOW()
WHERE
    amount > 4;
-- END Exercice 17


-- BEGIN Exercice 18
-- Ajout de la ville du client
INSERT INTO city (city, country_id, last_update)
VALUES ('Nyon', (SELECT country_id FROM country WHERE country = 'Switzerland'), CURRENT_DATE);

-- Ajout de l'adresse du client
INSERT INTO address (address, address2, district, city_id, postal_code, phone)
VALUES ('Rue du Centre', NULL, 'Vaud', (SELECT city_id FROM city WHERE city = 'Nyon'), '1260', '021/360.00.00');

-- Ajout du client
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date, last_update)
VALUES (1, 'Guillaume', 'Ransome', 'gr@bluewin.ch', (SELECT MAX(address_id) FROM address), true, CURRENT_DATE, CURRENT_DATE);
-- END Exercice 18


-- BEGIN Exercice 18d
SELECT * FROM customer WHERE first_name = 'Guillaume' AND last_name = 'Ransome';
-- END Exercice 18d
