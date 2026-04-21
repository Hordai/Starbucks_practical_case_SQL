# Starbucks retail analysis : le comportement client et l'efficacité opérationnelle

## Le contexte
Dans un secteur du retail en pleine mutation, la digitalisation des parcours d'achat et la fidélisation sont des enjeux majeurs. Ce projet d'analyse de données, réalisé avec Google BigQuery, explore un dataset de 100 000 transactions simulées de chez Starbucks (2024-2025).

L'objectif principal est d'identifier les leviers de croissance à travers l'analyse de l'adoption de l'application mobile, l'efficacité des différents canaux de vente (Drive-Thru, In-Store, Mobile App) et l'impact du programme de fidélité "Rewards".

* Dataset : https://www.kaggle.com/datasets/likithagedipudi/starbucks-customer-ordering-patterns
* Tableau de bord interactif : https://datastudio.google.com/reporting/dbf76d11-9468-4e86-ad1a-3db8cfbd63cb


## Les outils et les compétences
* Outil : Google BigQuery (Cloud SQL)
* Techniques SQL utilisées : Agrégations (GROUP BY), Fonctions de calcul (COUNT, SUM, AVG), Filtrage (HAVING, WHERE) et des expressions de tables communes (WITH).
* Data Visualisation : Locker Studio

## L'analyse et les insights stratégiques
### 1. L'impact du programme de fidélité ("Rewards")
La première étape consistait à vérifier si l'acquisition de membres au programme de fidélité se traduisait par une augmentation réelle du chiffre d'affaires.

```SQL
SELECT 
    is_rewards_member,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_spend), 2) AS average_spend
FROM 
    `portfotlio-1.startbuck.orders`
GROUP BY 
    is_rewards_member;
```
<img width="899" height="487" alt="image" src="https://github.com/user-attachments/assets/64e667d0-bd29-4a1a-9cd6-570e98e4fa4f" />

Le programme de fidélité a un impact direct sur le chiffre d'affaires. Bien que les membres Rewards génèrent un peu moins de transactions au global (47,7% du volume), leur panier moyen est significativement plus élevé (+1,63$ par commande par rapport aux non-membres).

### 2. L'effet du digital et sa capacité à créer de la valeur
La deuxième étape consiste à analyser la répartition du chiffre d'affaires par canal d'acquisition pour comprendre le comportement des utilisateurs mobiles.

```SQL
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
```
<img width="907" height="584" alt="image" src="https://github.com/user-attachments/assets/9734da2a-35c4-486c-8912-eb7bed5ac9a4" />

L'analyse révèle une différence marquante entre les canaux digitaux et physiques. L'application mobile domine avec plus d'un tiers des commandes totales (42,52%). Le panier moyen sur mobile atteint 18,08$, soit environ 6$ de plus que les canaux classiques (In-Store, Drive-Thru). Cette hausse est corrélée à l'augmentation des options payantes : un client mobile ajoute en moyenne plus de 2 personnalisations, soit le double d'un client physique.

### 3. Les goulots d'étranglement côté opérationnel
Ensuite, il est également pertinent d'évaluer l'efficacité de la préparation des commandes et de son impact sur la satisfaction client.

```SQL
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
```
<img width="905" height="549" alt="image" src="https://github.com/user-attachments/assets/6de4bce6-7bc1-4a64-8f4c-e23ec6174e3e" />

Le Drive-Thru rencontre un problème opérationnel. C'est le canal le plus lent (avec une attente moyenne de 6 minutes et des pics à +11 minutes), ce qui impacte sévèrement l'expérience client. En effet, il obtient la pire note de satisfaction (3,44/5). À l'inverse, le Mobile App conserve la meilleure note globale (3,86/5) grâce à un équilibre entre attente et fluidité de commande.

### 4. La segmentation : Le profil type du Super-Customisateur
Enfin, il est crucial d'identifier les segments démographiques les plus rentablesn notamment ceux qui ajoutent 2 options payantes ou plus, via l'utilisation de requêtes avancées (CTE).

```SQL
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
```
<img width="823" height="744" alt="image" src="https://github.com/user-attachments/assets/234ae548-b337-41fe-8138-2e4715ed3c49" />

La forte rentabilité des boissons personnalisées est portée par un segment très précis : le duo "25-34 ans / Mobile App" est de loin le premier pourvoyeur de commandes ultra-personnalisées (11 705 commandes à 18,74 $), suivi par les 18-24 ans sur le même canal.

## Les recommandations
Sur la base de cette analyse de données, voici trois recommandations stratégiques actionnables pour les opérations Starbucks :
* Focus marketing sur les Gen-Z/Millenials et Mobile App : les campagnes marketing poussant les suppléments payants (sirops, laits végétaux) doivent cibler en priorité les moins de 35 ans via des notifications push sur l'application mobile. Ce segment a démontré la plus forte propension à l'upselling.

* Optimisation du Drive-Thru : il est urgent d'optimiser le flux du Drive-Thru. Une solution serait de limiter les options de personnalisation complexes sur ce canal spécifique ou de créer une file de préparation supplémentaire aux heures de pointe pour remonter la note de satisfaction.

* UX en point de vente : étant donné le succès de l'interface mobile pour générer des options payantes supplémentaires (+6$ par panier), les bornes interactives (Kiosks) en magasin devraient s'inspirer de l'UX de l'application mobile pour inciter les clients physiques à la personnalisation.


----------------------------------------------------------------------------------------
Projet réalisé par Dai Horiuchi - Ouvert aux opportunités Data Analyst
Contact : https://www.linkedin.com/in/horiuchidai/


