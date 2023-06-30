SELECT month, Country, avg(total_ctr)
FROM real_final_ctr
GROUP BY month, Country;

#the drop in apr in us may have something to do with the adsdate?
SELECT month, Country, SUM(total_impressions)
FROM real_final_ctr
WHERE adsdate LIKE '2022%'
GROUP BY month, Country;
SELECT month, Country, SUM(total_impressions)
FROM real_final_ctr
WHERE adsdate LIKE '2023%'
GROUP BY month, Country;

SELECT month, Country, SUM(total_impressions)
FROM real_final_ctr
WHERE adsdate LIKE '2022%' AND Country = 'United States'
GROUP BY month;

SELECT month, Country, SUM(total_impressions)
FROM real_final_ctr
WHERE adsdate LIKE '2023%' AND Country = 'United States'
GROUP BY month;

#the drop in apr in us may have something to do with the total counts of promotion?
SELECT month, COUNT(position)
FROM real_final_ctr
GROUP BY month;

SELECT month, SUM(total_impressions)
FROM real_final_ctr
GROUP BY month;

SELECT month, terminal, SUM(total_impressions)
FROM real_final_ctr
GROUP BY month, terminal;

#Which terminal has the highest ctr
SELECT terminal, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr)
FROM real_final_ctr
GROUP BY terminal;

#WHICH position has highest ctr?
SELECT position, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr)
FROM real_final_ctr
GROUP BY position
ORDER BY AVG(total_ctr) DESC
LIMIT 10;

#WHICH position has lowest ctr?
SELECT position, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr)
FROM real_final_ctr
GROUP BY position
ORDER BY AVG(total_ctr) ASC
LIMIT 10;

#what kinds of ads has highest CTR?
SELECT adsdate, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr) avg_ctr
FROM real_final_ctr
GROUP BY adsdate
ORDER BY avg_ctr DESC
LIMIT 15;

#what kind of ads has lowest CTR
SELECT adsdate, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr) avg_ctr
FROM real_final_ctr
GROUP BY adsdate
ORDER BY avg_ctr ASC
LIMIT 15;

#流量王牌有变化吗
SELECT month, adsdate, position, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr) avg_ctr
FROM real_final_ctr
WHERE position = 'iPad_Image_Home_Banner_'
GROUP BY month, adsdate, position;

SELECT month, adsdate, position, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr) avg_ctr
FROM real_final_ctr
WHERE position = 'App_Image_Home_Banner_'
GROUP BY month, adsdate, position;

SELECT month, adsdate, position, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr) avg_ctr
FROM real_final_ctr
WHERE position = 'iPad_Image_Points&Detail_'
GROUP BY month, adsdate, position;

SELECT month, adsdate, position, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr) avg_ctr
FROM real_final_ctr
WHERE position = 'iPad_Image_Original_'
GROUP BY month, adsdate, position;

SELECT month, adsdate, position, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr) avg_ctr
FROM real_final_ctr
WHERE position = 'App&iPad_Image_Pause_'
GROUP BY month, adsdate, position;

#Why iPad increase?
SELECT month, SUM(total_impressions), SUM(total_clicks), ROUND(AVG(total_ctr), 2) AS avg_ctr,
    ROUND(COUNT(CASE WHEN adsdate LIKE '2022%' THEN 1 END) / COUNT(adsdate) * 100, 2) AS '2022_percentage',
    ROUND(COUNT(CASE WHEN adsdate LIKE '2023%' THEN 1 END) / COUNT(adsdate) * 100, 2) AS '2023_percentage'
FROM real_final_ctr
WHERE terminal = 'iPad'
GROUP BY month;

#WHAT ABOUT OTHER TERMINALS
SELECT month, SUM(total_impressions), SUM(total_clicks), ROUND(AVG(total_ctr), 2) AS avg_ctr,
    ROUND(COUNT(CASE WHEN adsdate LIKE '2022%' THEN 1 END) / COUNT(adsdate) * 100, 2) AS '2022_percentage',
    ROUND(COUNT(CASE WHEN adsdate LIKE '2023%' THEN 1 END) / COUNT(adsdate) * 100, 2) AS '2023_percentage'
FROM real_final_ctr
WHERE terminal = 'App&iPad'
GROUP BY month;

SELECT month, SUM(total_impressions), SUM(total_clicks), ROUND(AVG(total_ctr), 2) AS avg_ctr,
    ROUND(COUNT(CASE WHEN adsdate LIKE '2022%' THEN 1 END) / COUNT(adsdate) * 100, 2) AS '2022_percentage',
    ROUND(COUNT(CASE WHEN adsdate LIKE '2023%' THEN 1 END) / COUNT(adsdate) * 100, 2) AS '2023_percentage'
FROM real_final_ctr
WHERE terminal = 'App'
GROUP BY month;

SELECT adsdate, SUM(total_impressions), SUM(total_clicks), AVG(total_ctr) AS avg_ctr
FROM real_final_ctr
GROUP BY adsdate
ORDER BY avg_ctr DESC;

#same ads on diff terminal's ctr
SELECT adsdate, terminal, SUM(total_impressions), SUM(total_clicks), ROUND(AVG(total_ctr), 2) AS avg_ctr
FROM real_final_ctr
WHERE adsdate = 20230417
GROUP BY terminal;

#same position in diff country
SELECT adsdate, Country, position, terminal, SUM(total_impressions), SUM(total_clicks), ROUND(AVG(total_ctr), 2) AS avg_ctr
FROM real_final_ctr
WHERE position = 'iPad_Image_Points&Detail_'
GROUP BY adsdate, country;

#Analysis on 20230209
SELECT adsdate, position, 
SUM(CASE WHEN month = 3 THEN total_impressions ELSE 0 END) AS mar_imp,
       SUM(CASE WHEN month = 3 THEN total_clicks ELSE 0 END) AS mar_clicks,
       ROUND(AVG(CASE WHEN month = 3 THEN total_ctr ELSE NULL END), 2) AS mar_avg_ctr,
       SUM(CASE WHEN month = 4 THEN total_impressions ELSE 0 END) AS apr_imp,
       SUM(CASE WHEN month = 4 THEN total_clicks ELSE 0 END) AS apr_clicks,
       ROUND(AVG(CASE WHEN month = 4 THEN total_ctr ELSE NULL END), 2) AS apr_avg_ctr,
       SUM(CASE WHEN month = 5 THEN total_impressions ELSE 0 END) AS may_imp,
       SUM(CASE WHEN month = 5 THEN total_clicks ELSE 0 END) AS may_clicks,
       ROUND(AVG(CASE WHEN month = 5 THEN total_ctr ELSE NULL END), 2) AS may_avg_ctr
FROM real_final_ctr
GROUP BY position
HAVING adsdate = 20230209;

SELECT adsdate, position, 
       SUM(CASE WHEN month = 4 THEN total_impressions ELSE 0 END) AS apr_imp,
       SUM(CASE WHEN month = 4 THEN total_clicks ELSE 0 END) AS apr_clicks,
       ROUND(AVG(CASE WHEN month = 4 THEN total_ctr ELSE NULL END), 2) AS apr_avg_ctr,
       SUM(CASE WHEN month = 5 THEN total_impressions ELSE 0 END) AS may_imp,
       SUM(CASE WHEN month = 5 THEN total_clicks ELSE 0 END) AS may_clicks,
       ROUND(AVG(CASE WHEN month = 5 THEN total_ctr ELSE NULL END), 2) AS may_avg_ctr
FROM real_final_ctr
WHERE adsdate = 20230407
GROUP BY position;

SELECT adsdate, position, 
SUM(CASE WHEN month = 3 THEN total_impressions ELSE 0 END) AS mar_imp,
       SUM(CASE WHEN month = 3 THEN total_clicks ELSE 0 END) AS mar_clicks,
       ROUND(AVG(CASE WHEN month = 3 THEN total_ctr ELSE NULL END), 2) AS mar_avg_ctr,
       SUM(CASE WHEN month = 4 THEN total_impressions ELSE 0 END) AS apr_imp,
       SUM(CASE WHEN month = 4 THEN total_clicks ELSE 0 END) AS apr_clicks,
       ROUND(AVG(CASE WHEN month = 4 THEN total_ctr ELSE NULL END), 2) AS apr_avg_ctr,
       SUM(CASE WHEN month = 5 THEN total_impressions ELSE 0 END) AS may_imp,
       SUM(CASE WHEN month = 5 THEN total_clicks ELSE 0 END) AS may_clicks,
       ROUND(AVG(CASE WHEN month = 5 THEN total_ctr ELSE NULL END), 2) AS may_avg_ctr
FROM real_final_ctr
WHERE adsdate = 20230227
GROUP BY position;
