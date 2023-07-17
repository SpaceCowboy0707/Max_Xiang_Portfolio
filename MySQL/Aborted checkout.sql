USE italkbb;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Signup_Aborted_Report July.csv'
INTO TABLE abort_july
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`Create date`, `Customer id`, `Combo name`, `First Name`, `Last Name`, `cell phone`, `email`);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Signup_Aborted_Report June.csv'
INTO TABLE abort_jun
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`Create date`, `Customer id`, `Combo name`, `First Name`, `Last Name`, `cell phone`, `email`);

UPDATE abort_jun
SET `Customer id` = NULLIF(TRIM(`Customer id`), ''), 
	`Combo name` = NULLIF(TRIM(`Combo name`), ''), 
	`First Name` = NULLIF(TRIM(`First Name`), ''), 
    `Last Name` = NULLIF(TRIM(`Last Name`), ''), 
    `cell phone` = NULLIF(TRIM(`cell phone`), ''), 
    `email` = NULLIF(NULLIF(TRIM(`email`), ''), '\r');
UPDATE abort_july
SET `Customer id` = NULLIF(TRIM(`Customer id`), ''), 
	`Combo name` = NULLIF(TRIM(`Combo name`), ''), 
	`First Name` = NULLIF(TRIM(`First Name`), ''), 
    `Last Name` = NULLIF(TRIM(`Last Name`), ''), 
    `cell phone` = NULLIF(TRIM(`cell phone`), ''), 
    `email` = NULLIF(NULLIF(TRIM(`email`), ''), '\r');
    
SELECT * 
FROM abort_july
WHERE `cell phone` IS NOT NULL OR `email` IS NOT NULL;


SELECT * 
FROM abort_jun
WHERE `cell phone` != ''
GROUP BY `Combo name`, `cell phone`;

SELECT * 
FROM abort_july
WHERE `cell phone` != ''
GROUP BY `Combo name`, `cell phone`;

#Aljia情况
SELECT * 
FROM abort_jun
WHERE `Combo name` LIKE '%AIjia%';
SELECT * 
FROM abort_july
WHERE `Combo name` LIKE '%AIjia%';
SELECT *
FROM abort_jun
WHERE `Combo name` LIKE '%AIjia%' AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);
SELECT *
FROM abort_july
WHERE `Combo name` LIKE '%AIjia%' AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);

#summary
SELECT *
FROM abort_jun
GROUP BY `Combo name`, `Create date`;
SELECT *
FROM abort_jun
WHERE `Combo name` IS NULL;
SELECT *
FROM abort_july
WHERE `cell phone` IS NOT NULL OR `email` IS NOT NULL;
SELECT *
FROM abort_july
WHERE `Combo name` IS NULL;
SELECT *
FROM abort_jun
WHERE `Combo name` IS NOT NULL AND `First Name` IS NULL AND `Last Name` IS NULL AND `cell phone` IS NULL AND `email` IS NULL;
SELECT *
FROM abort_july
WHERE `Combo name` IS NOT NULL AND `First Name` IS NULL AND `Last Name` IS NULL AND `cell phone` IS NULL AND `email` IS NULL;

SELECT *
FROM abort_jun
WHERE `Combo name` LIKE '%中港澳%';
SELECT *
FROM abort_july
WHERE `Combo name` LIKE '%中港澳%';

SELECT * 
FROM abort_jun
WHERE `Combo name` LIKE '%中港澳%' AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);
SELECT * 
FROM abort_july
WHERE `Combo name` LIKE '%中港澳%' AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);

SELECT * 
FROM abort_jun
WHERE `Combo name` LIKE '%中国通%';

#potential prime users
SELECT * 
FROM abort_jun
WHERE `Combo name` LIKE '%Prime%';
SELECT * 
FROM abort_july
WHERE `Combo name` LIKE '%Prime%';

#potential prime users that leave at least one contact info
SELECT *
FROM abort_jun
WHERE `Combo name` LIKE '%Prime%' AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);
SELECT *
FROM abort_july
WHERE `Combo name` LIKE '%Prime%' AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);

#leave both contact
SELECT *
FROM abort_jun
WHERE `Combo name` LIKE '%Prime%' AND (`cell phone` IS NOT NULL AND `email` IS NOT NULL);
SELECT *
FROM abort_july
WHERE `Combo name` LIKE '%Prime%' AND (`cell phone` IS NOT NULL AND `email` IS NOT NULL);

#only leave email
SELECT COUNT(`email`)
FROM abort_jun
WHERE `Combo name` LIKE '%Prime%' AND (`cell phone` IS NULL AND `email` IS NOT NULL);
SELECT COUNT(`email`)
FROM abort_july
WHERE `Combo name` LIKE '%Prime%' AND (`cell phone` IS NULL AND `email` IS NOT NULL);

#only leave phone
SELECT COUNT(`cell phone`)
FROM abort_jun
WHERE `Combo name` LIKE '%Prime%' AND (`cell phone` IS NOT NULL AND `email` IS NULL);
SELECT COUNT(`cell phone`)
FROM abort_july
WHERE `Combo name` LIKE '%Prime%' AND (`cell phone` IS NOT NULL AND `email` IS NULL);

#潜在TV用户
SELECT * 
FROM abort_jun
WHERE `Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%';
SELECT * 
FROM abort_july
WHERE `Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%';

#potential TV users that leave at least one contact info
SELECT *
FROM abort_jun
WHERE (`Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%') AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);
SELECT *
FROM abort_july
WHERE (`Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%') AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);

#Leave both contacts
SELECT *
FROM abort_jun
WHERE (`Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%') AND (`cell phone` IS NOT NULL AND `email` IS NOT NULL);
SELECT *
FROM abort_july
WHERE (`Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%') AND (`cell phone` IS NOT NULL AND `email` IS NOT NULL);

#Leave only email
SELECT *
FROM abort_jun
WHERE (`Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%') AND (`cell phone` IS NULL AND `email` IS NOT NULL);
SELECT *
FROM abort_july
WHERE (`Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%') AND (`cell phone` IS NULL AND `email` IS NOT NULL);

#Leave only phone
SELECT *
FROM abort_jun
WHERE (`Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%') AND (`cell phone` IS NOT NULL AND `email` IS NULL);
SELECT *
FROM abort_july
WHERE (`Combo name` LIKE '%TV%' OR `Combo name` LIKE '%电视%') AND (`cell phone` IS NOT NULL AND `email` IS NULL);

#潜在电话用户
SELECT * 
FROM abort_jun
WHERE `Combo name` LIKE '%家庭电话%' OR `Combo name` LIKE '%Home Phone%';
SELECT * 
FROM abort_july
WHERE `Combo name` LIKE '%家庭电话%' OR `Combo name` LIKE '%Home Phone%';

#potential phone users leave at least one contact
SELECT *
FROM abort_jun
WHERE (`Combo name` LIKE '%家庭电话%' OR `Combo name` LIKE '%Home Phone%') AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);
SELECT *
FROM abort_july
WHERE (`Combo name` LIKE '%家庭电话%' OR `Combo name` LIKE '%Home Phone%') AND (`cell phone` IS NOT NULL OR `email` IS NOT NULL);

#leave both contact
SELECT *
FROM abort_jun
WHERE (`Combo name` LIKE '%家庭电话%' OR `Combo name` LIKE '%Home Phone%') AND (`cell phone` IS NOT NULL AND `email` IS NOT NULL);
SELECT *
FROM abort_july
WHERE (`Combo name` LIKE '%家庭电话%' OR `Combo name` LIKE '%Home Phone%') AND (`cell phone` IS NOT NULL AND `email` IS NOT NULL);

#only leave email
SELECT *
FROM abort_jun
WHERE (`Combo name` LIKE '%家庭电话%' OR `Combo name` LIKE '%Home Phone%') AND (`cell phone` IS NULL AND `email` IS NOT NULL);

#only leave phone
SELECT *
FROM abort_jun
WHERE (`Combo name` LIKE '%家庭电话%' OR `Combo name` LIKE '%Home Phone%') AND (`cell phone` IS NOT NULL AND `email` IS NULL);

SELECT *
FROM abort_july
GROUP BY `Combo name`, `Create date`;


