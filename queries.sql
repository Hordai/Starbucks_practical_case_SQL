-- 1. Analyse du programme de fidélité
SELECT 
    is_rewards_member,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_spend), 2) AS average_spend
FROM 
    `portfotlio-1.startbuck.orders`
GROUP BY 
    is_rewards_member;

-- 2. Analyse de l'effet Digital (Mobile App) et sa valeur
SELECT 
    order_channel,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(AVG(num_customizations), 2) AS avg_customizations
FROM 
    `portfotlio-1.startbuck.orders`
GROUP BY 
    order_channel
ORDER BY 
    avg_spend DESC;

-- 3. Analyse du temps moyen de préparation et la satisfaction client
SELECT 
    order_channel,
    ROUND(AVG(fulfillment_time_min), 2) AS avg_wait_time_minutes,
    MAX(fulfillment_time_min) AS max_wait_time_minutes,
    ROUND(AVG(customer_satisfaction), 2) AS avg_satisfaction
FROM 
    `portfotlio-1.startbuck.orders`
GROUP BY 
    order_channel
ORDER BY 
    avg_wait_time_minutes DESC;

-- 4. Analyse des super-customisateur
WITH HeavyCustomizers AS (
    SELECT 
        customer_age_group,
        order_channel,
        total_spend
    FROM 
        `portfotlio-1.startbuck.orders`
    WHERE 
        num_customizations >= 2)
SELECT 
    customer_age_group,
    order_channel,
    COUNT(*) AS total_heavy_orders,
    ROUND(AVG(total_spend), 2) AS avg_spend
FROM 
    HeavyCustomizers
GROUP BY 
    customer_age_group, order_channel
ORDER BY 
    total_heavy_orders DESC;



