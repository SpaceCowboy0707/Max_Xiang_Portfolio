-- Step 0: Load the data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/aggregated_houseads (6).csv'
INTO TABLE houseads
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(adsDate, creative, country, total_impressions, ad_server_clicks);
-- Step 1: Create the monthlyctr view
CREATE OR REPLACE VIEW `italkbb`.`monthlyctr` AS
SELECT 
    EXTRACT(MONTH FROM `italkbb`.`houseads`.`adsDate`) AS `month`,
    `italkbb`.`houseads`.`Creative` AS `Creative`,
    `italkbb`.`houseads`.`Country` AS `Country`,
    SUM(`italkbb`.`houseads`.`Total_impressions`) AS `total_impressions`,
    SUM(`italkbb`.`houseads`.`Ad_server_clicks`) AS `total_clicks`,
    ((SUM(`italkbb`.`houseads`.`Ad_server_clicks`) / SUM(`italkbb`.`houseads`.`Total_impressions`)) * 100) AS `Total_CTR`
FROM `italkbb`.`houseads`
GROUP BY `month`, `italkbb`.`houseads`.`Creative`, `italkbb`.`houseads`.`Country`;

-- Step 2: Create the final_ctr view
CREATE OR REPLACE VIEW `italkbb`.`final_ctr` AS
SELECT 
    `italkbb`.`monthlyctr`.`month` AS `month`,
    SUBSTRING_INDEX(`italkbb`.`monthlyctr`.`Creative`, '_', 1) AS `date`,
    SUBSTR(`italkbb`.`monthlyctr`.`Creative`, (LOCATE('_', `italkbb`.`monthlyctr`.`Creative`) + 1), (((LENGTH(`italkbb`.`monthlyctr`.`Creative`) - LOCATE('_', `italkbb`.`monthlyctr`.`Creative`)) - LENGTH(SUBSTRING_INDEX(`italkbb`.`monthlyctr`.`Creative`, '_', -(2)))) - 1)) AS `position`,
    `italkbb`.`monthlyctr`.`Country` AS `Country`,
    `italkbb`.`monthlyctr`.`total_impressions` AS `total_impressions`,
    `italkbb`.`monthlyctr`.`total_clicks` AS `total_clicks`,
    ROUND(`italkbb`.`monthlyctr`.`Total_CTR`, 2) AS `total_ctr`
FROM `italkbb`.`monthlyctr`;

-- Step 3: Create the real_final_ctr view
CREATE OR REPLACE VIEW `italkbb`.`real_final_ctr` AS
SELECT 
    `italkbb`.`final_ctr`.`month` AS `month`,
    `italkbb`.`final_ctr`.`date` AS `adsdate`,
    `italkbb`.`final_ctr`.`position` AS `position`,
    `italkbb`.`final_ctr`.`Country` AS `Country`,
    `italkbb`.`final_ctr`.`total_impressions` AS `total_impressions`,
    `italkbb`.`final_ctr`.`total_clicks` AS `total_clicks`,
    `italkbb`.`final_ctr`.`total_ctr` AS `total_ctr`,
    (CASE
        WHEN (`italkbb`.`final_ctr`.`position` LIKE 'App&iPad%') THEN 'App&iPad'
        WHEN (`italkbb`.`final_ctr`.`position` LIKE 'App%') THEN 'App'
        WHEN (`italkbb`.`final_ctr`.`position` LIKE 'Web%') THEN 'Web'
        WHEN (`italkbb`.`final_ctr`.`position` LIKE 'iPad%') THEN 'iPad'
    END) AS `terminal`
FROM `italkbb`.`final_ctr`;
