# Project Description :-
#It is a meal delivery company which operates in multiple cities. 
#They have various fulfillment centers in these cities for dispatching meal orders to their customers. 
#The client wants you to help these centers with demand forecasting 
# for upcoming weeks so that these centers will plan the stock of raw materials accordingly.

# Project Questionaire and Solution Codes :- 

# Q1. Display the number of orders recieved by Centers & Top 10 Centers.
SELECT 
    f.center_id,
    SUM(t.num_orders) AS num_orders
FROM
    fullfilments f
        JOIN
    train t ON f.center_id = t.center_id
GROUP BY f.center_id
ORDER BY num_orders DESC
LIMIT 10;

# Q2. Display the number of orders recieved by Cities & Top 5 Cities.
SELECT 
    f.city_code,
    SUM(t.num_orders) AS num_orders
FROM
    fullfilments f
        JOIN
    train t ON f.center_id = t.center_id
GROUP BY f.city_code
ORDER BY num_orders DESC
LIMIT 5;

# Q3. Display the number of orders recieved by regions & Top 5 regions.
SELECT 
    f.region_code,
    SUM(t.num_orders) AS num_orders
FROM
    fullfilments f
        JOIN
    train t ON f.center_id = t.center_id
GROUP BY f.region_code
ORDER BY num_orders DESC
LIMIT 5;

# Q4. Find the highest orders according to center, city & region. 
SELECT 
    f.city_code,
    f.center_id,
    f.region_code,
    SUM(t.num_orders) AS num_orders
FROM
    fullfilments f
        JOIN
    train t ON f.center_id = t.center_id
GROUP BY f.city_code,f.center_id,f.region_code
ORDER BY num_orders DESC;

# Q5. What is the most popular food category overall ? 
SELECT 
    m.category, SUM(t.num_orders) AS total_orders
FROM
    meal_info m
        JOIN
    train t ON m.meal_id = t.meal_id
GROUP BY m.category
ORDER BY total_orders DESC;

# Q6. What is the most popular food category centre wise ?
SELECT 
    x.center_id, y.category, x.highest_orders
FROM
    (SELECT 
        b.center_id, MAX(b.total_orders) AS highest_orders
    FROM
        (SELECT 
        a.center_id, m.category, SUM(a.num_orders) AS total_orders
    FROM
        meal_info m
    JOIN (SELECT 
        f.center_id, t.meal_id, t.num_orders
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id) a ON m.meal_id = a.meal_id
    GROUP BY a.center_id , m.category) b
    GROUP BY b.center_id) x
        JOIN
    (SELECT 
        a.center_id, m.category, SUM(a.num_orders) AS total_orders
    FROM
        meal_info m
    JOIN (SELECT 
        f.center_id, t.meal_id, t.num_orders
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id) a ON m.meal_id = a.meal_id
    GROUP BY a.center_id , m.category) y ON x.center_id = y.center_id
    WHERE
        x.highest_orders = y.total_orders;
        
# Q7. What is the most popular food city wise ?
SELECT 
    x.city_code , y.category, x.highest_orders
FROM
    (SELECT 
        b.center_id, b.city_code, MAX(b.total_orders) AS highest_orders
    FROM
        (SELECT 
        a.center_id, a.city_code, m.category, SUM(a.num_orders) AS total_orders
    FROM
        meal_info m
    JOIN (SELECT 
        f.center_id, f.city_code, t.meal_id, t.num_orders
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id) a ON m.meal_id = a.meal_id
    GROUP BY a.center_id , m.category) b
    GROUP BY b.center_id) x
        JOIN
    (SELECT 
        a.center_id, a.city_code, m.category, SUM(a.num_orders) AS total_orders
    FROM
        meal_info m
    JOIN (SELECT 
        f.center_id,f.city_code, t.meal_id, t.num_orders
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id) a ON m.meal_id = a.meal_id
    GROUP BY a.center_id , m.category) y ON x.center_id = y.center_id
    WHERE
        x.highest_orders = y.total_orders;
        
# Q8. What is the most popular food cuisine overall ?
SELECT 
    m.cuisine, SUM(t.num_orders) AS total_orders
FROM
    meal_info m
        JOIN
    train t ON m.meal_id = t.meal_id
GROUP BY m.cuisine
ORDER BY total_orders DESC;

# Q9. What is the average base and checkout price for each category overall?
SELECT 
    m.category,
    ROUND(AVG(t.base_price), 2) AS avrg_baseprice,
    ROUND(AVG(t.checkout_price), 2) AS avrg_checkoutprice
FROM
    meal_info m
        JOIN
    train t ON m.meal_id = t.meal_id
GROUP BY m.category;

# Q10. What is the average base and checkout price for each cuisine overall?
SELECT 
    m.cuisine,
    ROUND(AVG(t.base_price), 2) AS avrg_baseprice,
    ROUND(AVG(t.checkout_price), 2) AS avrg_checkoutprice
FROM
    meal_info m
        JOIN
    train t ON m.meal_id = t.meal_id
GROUP BY m.cuisine;

# Q11. Find the average number of orders recieved from per square Kms. of area by every center ?
SELECT 
    a.center_id,
    ROUND(a.total_orders / a.area_sqkms, 2) AS avrg_orders_persqkms
FROM
    (SELECT 
        f.center_id,
            SUM(f.op_area) AS area_sqkms,
            SUM(t.num_orders) AS total_orders
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id
    GROUP BY f.center_id) a
GROUP BY a.center_id
ORDER BY a.center_id ASC;

# Q12. Find the average number of orders recieved from per square Kms. of area by every city ?
SELECT 
    a.city_code,
    ROUND(a.total_orders / a.area_sqkms, 2) AS avrg_orders_persqkms
FROM
    (SELECT 
        f.city_code,
            SUM(f.op_area) AS area_sqkms,
            SUM(t.num_orders) AS total_orders
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id
    GROUP BY f.city_code) a
GROUP BY a.city_code
ORDER BY a.city_code ASC;

# Q13. Find the average number of orders recieved from per square Kms. of area by every region ?
SELECT 
    a.region_code,
    ROUND(a.total_orders / a.area_sqkms, 2) AS avrg_orders_persqkms
FROM
    (SELECT 
        f.region_code,
            SUM(f.op_area) AS area_sqkms,
            SUM(t.num_orders) AS total_orders
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id
    GROUP BY f.region_code) a
GROUP BY a.region_code
ORDER BY a.region_code ASC;

# Q14. Which centre type gets more orders ?
SELECT 
    f.center_type, SUM(t.num_orders) AS orders
FROM
    fullfilments f
        JOIN
    train t ON f.center_id = t.center_id
GROUP BY f.center_type;

# Q15. What is the discount value and discount %age noticed in all centers ?
SELECT 
    a.center_id,
    a.week,
    m.category,
    m.cuisine,
    a.base_price,
    a.checkout_price,
    a.disc,
    a.disc_prcnt
FROM
    meal_info m
        JOIN
    (SELECT 
        center_id,
            week,
            meal_id,
            base_price,
            checkout_price,
            base_price - checkout_price AS disc,
            CONCAT(CONVERT( ROUND(100 * (base_price - checkout_price) / base_price, 2) , CHAR), '%') AS disc_prcnt
    FROM
        train
    ORDER BY week , center_id) a ON m.meal_id = a.meal_id
ORDER BY a.week , a.center_id;


# Q16. Fetch the details when maximum of the discount value and percentage was noticed.
SELECT 
    *
FROM
    (SELECT 
        a.center_id,
            a.week,
            m.category,
            m.cuisine,
            a.base_price,
            a.checkout_price,
            a.disc,
            a.disc_prcnt
    FROM
        meal_info m
    JOIN (SELECT 
        center_id,
            week,
            meal_id,
            base_price,
            checkout_price,
            base_price - checkout_price AS disc,
            CONCAT(CONVERT( ROUND(100 * (base_price - checkout_price) / base_price, 2) , CHAR), '%') AS disc_prcnt
    FROM
        train
    ORDER BY week , center_id) a ON m.meal_id = a.meal_id
    ORDER BY a.week , a.center_id) x
ORDER BY x.disc DESC
LIMIT 1;

# Q17. Enlist the average base and average checkout prices of all food categories. 
SELECT 
    m.category,
    ROUND(AVG(t.base_price), 2) AS avrg_base_price,
    ROUND(AVG(t.checkout_price), 2) AS avrg_checkout_price
FROM
    meal_info m
        JOIN
    train t ON m.meal_id = t.meal_id
GROUP BY m.category;

# Q18. Enlist the average base and average checkout prices of all food cuisine.
SELECT 
    m.cuisine,
    ROUND(AVG(t.base_price), 2) AS avrg_base_price,
    ROUND(AVG(t.checkout_price), 2) AS avrg_checkout_price
FROM
    meal_info m
        JOIN
    train t ON m.meal_id = t.meal_id
GROUP BY m.cuisine;

# Q19. Enlist the average base and average checkout prices of all food category and cuisine.
SELECT 
    m.cuisine,
    m.category,
    ROUND(AVG(t.base_price), 2) AS avrg_base_price,
    ROUND(AVG(t.checkout_price), 2) AS avrg_checkout_price
FROM
    meal_info m
        JOIN
    train t ON m.meal_id = t.meal_id
GROUP BY m.cuisine , m.category
ORDER BY m.cuisine , m.category;

# Q20. Which is the most expensive Indian Category according to average base price ?
SELECT 
    *
FROM
    (SELECT 
        m.cuisine,
            m.category,
            ROUND(AVG(t.base_price), 2) AS avrg_base_price,
            ROUND(AVG(t.checkout_price), 2) AS avrg_checkout_price
    FROM
        meal_info m
    JOIN train t ON m.meal_id = t.meal_id
    GROUP BY m.cuisine , m.category
    ORDER BY m.cuisine , m.category) x
WHERE
    x.cuisine = 'Indian'
ORDER BY x.avrg_base_price DESC
LIMIT 1;

# Q21.Enlist the number of orders recieved for Indian Category "Desert" in all the centers, cities and regions. 
SELECT 
    a.center_id,
    a.city_code,
    a.region_code,
    m.category,
    a.num_orders
FROM
    meal_info m
        JOIN
    (SELECT 
        f.center_id,
            f.city_code,
            f.region_code,
            t.meal_id,
            t.num_orders
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id) a ON m.meal_id = a.meal_id
WHERE
    m.category = 'Desert';
    
# Q22.Which top 5 centers recieved highest orders for "Desert" ?
SELECT 
    x.center_id, SUM(x.num_orders) AS total_desert_orders
FROM
    (SELECT 
        a.center_id,
            a.city_code,
            a.region_code,
            m.category,
            a.num_orders
    FROM
        meal_info m
    JOIN (SELECT 
        f.center_id,
            f.city_code,
            f.region_code,
            t.meal_id,
            t.num_orders
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id) a ON m.meal_id = a.meal_id
    WHERE
        m.category = 'Desert') x
GROUP BY x.center_id
ORDER BY total_desert_orders DESC
LIMIT 5;

# Q23. Tabulate weekly trend of price (checkout_price) for "Desert". 
SELECT 
    a.week, m.category, a.checkout_price
FROM
    meal_info m
        JOIN
    (SELECT 
        f.center_id, t.week, t.meal_id, t.checkout_price
    FROM
        fullfilments f
    JOIN train t ON f.center_id = t.center_id) a ON m.meal_id = a.meal_id
WHERE
    m.category = 'Desert'
ORDER BY a.week;

# Q24. Tabulate the trends of "Desert" for discount_values and percentages weekly bases. 
SELECT 
    a.week, m.category, a.disc, a.disc_prcnt
FROM
    meal_info m
        JOIN
    (SELECT 
        center_id,
            week,
            meal_id,
            base_price,
            checkout_price,
            base_price - checkout_price AS disc,
            CONCAT(CONVERT( ROUND(100 * (base_price - checkout_price) / base_price, 2) , CHAR), '%') AS disc_prcnt
    FROM
        train
    ORDER BY week , center_id) a ON m.meal_id = a.meal_id
WHERE
    m.category = 'Desert'
ORDER BY a.week;












