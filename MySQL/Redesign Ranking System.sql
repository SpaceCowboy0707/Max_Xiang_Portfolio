USE italkbb;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/box ranking.csv'
INTO TABLE box_ranking
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`title`, `category`, `create_date`, `group`, `episode`, `view_7day`, `view_30day`,`view_90day`, `90day_rank`, `新平台评级`);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/new.csv'
INTO TABLE tv_ranking
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`title`, `create_at`, `group`, `episode`, `90day_view`, `90day_grade`);

SELECT * 
FROM box_ranking;
SELECT * 
FROM tv_ranking;

#compare ranking for tv and box
SELECT b.title, b.create_date, b.`90day_rank` AS box_90dayrank, t.`90day_grade` AS tv_90dayrank
FROM box_ranking b
LEFT JOIN tv_ranking t
ON b.title = t.title
WHERE t.`90day_grade` IS NOT NULL;

#Design new ranking by dividing total views evenly
WITH ranking AS(
	SELECT title, view_90day, `90day_rank`,
    NTILE (5) OVER(ORDER BY view_90day DESC) AS divider
    FROM box_ranking)
SELECT title, view_90day, `90day_rank`,
	CASE WHEN divider = 1 THEN '跟播S'
		 WHEN divider = 2 THEN '跟播A'
         WHEN divider = 3 THEN '跟播B'
         WHEN divider = 4 THEN '跟播C'
         WHEN divider = 5 THEN '跟播D'
         ELSE '跟播E'
	END AS 'new_ranking'
FROM ranking;

#genbo ranking percentage for Box
SELECT `90day_rank`, COUNT(*) AS count, ROUND((COUNT(*) / (SELECT COUNT(*) FROM box_ranking)), 2) * 100 AS percentage
FROM  box_ranking
GROUP BY `90day_rank`
ORDER BY percentage DESC;

#Genbo ranking percentage for TV
WITH genbo AS (SELECT *
FROM tv_ranking
WHERE category = '跟播剧')
SELECT `90day_grade`, COUNT(*) AS count, ROUND((COUNT(*) / (SELECT COUNT(*) FROM genbo)), 2) * 100 AS percentage
FROM  genbo
GROUP BY `90day_grade`
ORDER BY percentage DESC;

#Smallest 90 day view percentage represent of the total views for different ranking
SELECT `90day_rank`, MIN(view_90day) OVER(PARTITION BY `90day_rank`)/(SELECT SUM(view_90day) FROM box_ranking) * 100 AS rank_standard
FROM box_ranking;
SELECT `90day_grade`, MIN(`90day_view`) OVER(PARTITION BY `90day_grade`)/(SELECT SUM(`90day_view`) FROM tv_ranking) * 100 AS Srank_standard
FROM tv_ranking
WHERE category = '跟播剧';



#Find current ranking system percentage by 90 day views
SELECT 1300000/SUM(view_90day) 
FROM box_ranking
UNION ALL
SELECT 900000/SUM(view_90day) 
FROM box_ranking
UNION ALL
SELECT 500000/SUM(view_90day)
FROM box_ranking
UNION ALL
SELECT 300000/SUM(view_90day) 
FROM box_ranking
UNION ALL
SELECT 100000/SUM(view_90day) 
FROM box_ranking;

#Find current ranking system percentage by 30 day views
SELECT 1100000/SUM(view_30day) 
FROM box_ranking
UNION ALL
SELECT 600000/SUM(view_30day) 
FROM box_ranking
UNION ALL
SELECT 400000/SUM(view_30day)
FROM box_ranking
UNION ALL
SELECT 200000/SUM(view_30day) 
FROM box_ranking
UNION ALL
SELECT 50000/SUM(view_30day) 
FROM box_ranking;

#Find current ranking system percentage by 7 day views
SELECT 150000/SUM(view_7day) 
FROM box_ranking
UNION ALL
SELECT 100000/SUM(view_7day) 
FROM box_ranking
UNION ALL
SELECT 90000/SUM(view_7day)
FROM box_ranking
UNION ALL
SELECT 40000/SUM(view_7day) 
FROM box_ranking
UNION ALL
SELECT 10000/SUM(view_7day) 
FROM box_ranking;

#Apply the 90day percentage to the TV system
SELECT SUM(`90day_view`) * 0.03606
FROM tv_ranking
UNION ALL
SELECT SUM(`90day_view`) * 0.0233
FROM tv_ranking
UNION ALL
SELECT SUM(`90day_view`) * 0.0129
FROM tv_ranking
UNION ALL
SELECT SUM(`90day_view`) * 0.0078
FROM tv_ranking
UNION ALL
SELECT SUM(`90day_view`) * 0.0026
FROM tv_ranking;

#Find new ranking system percentage by new view rankings TV
SELECT 140000/SUM(`90day_view`) 
FROM tv_ranking
UNION ALL
SELECT 98000/SUM(`90day_view`) 
FROM tv_ranking
UNION ALL
SELECT 54500/SUM(`90day_view`)
FROM tv_ranking
UNION ALL
SELECT 32900/SUM(`90day_view`) 
FROM tv_ranking
UNION ALL
SELECT 10900/SUM(`90day_view`) 
FROM tv_ranking;

#new TV ranking based on the 140000 standard, find the new percentage then apply it back to box
SELECT *,
CASE WHEN `90day_view` > 140000 THEN '跟播S'
	 WHEN `90day_view` > 98000 THEN '跟播A'
     WHEN `90day_view` > 54500 THEN '跟播B'
     WHEN `90day_view` > 32900 THEN '跟播C'
     WHEN `90day_view` > 10900 THEN '跟播D'
     ELSE '跟播E'
     END AS 'NEW_RANKING_TV'
FROM tv_ranking
WHERE category = '跟播剧';