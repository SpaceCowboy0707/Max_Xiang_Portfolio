USE italkbb;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Call details1.csv'
INTO TABLE call_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`Start time`, `Duration`, `Caller country code`, `Caller area code`, `Caller phone number`, `Recording`, `Status`, `Call source`, `Call type`, `Campaign`, `Ad group`
);

SELECT *
FROM call_details;

#avg min for each campaign
SELECT Campaign, ROUND(AVG(Duration) / 60, 2) `Duration(min)`, COUNT(*) 
FROM call_details
WHERE Campaign != ''
GROUP BY Campaign
ORDER BY `Duration(min)` DESC;

#most popular caller area code for each campaign
SELECT Campaign, `Caller area code`, callcount
	FROM (SELECT `Caller area code`, Campaign, COUNT(`Caller area code`) callcount,
          ROW_NUMBER() OVER(PARTITION BY Campaign ORDER BY COUNT(`Caller area code`) DESC ) callindex
		  FROM call_details
          WHERE `Caller area code` != ' NA'
          GROUP BY Campaign, `Caller area code`) t
WHERE callindex = 1 AND Campaign != ''
ORDER BY callcount DESC;

#Received Missed ration
SELECT Campaign, `Status`, COUNT(`Status`)
FROM call_details
WHERE Campaign != '' AND Campaign = 'Wishare - Search - Brand'
GROUP BY Campaign, `Status`
UNION ALL
SELECT Campaign, `Status`, COUNT(`Status`)
FROM call_details
WHERE Campaign != '' AND Campaign = 'Wishare - Search - BB'
GROUP BY Campaign, `Status`
UNION ALL
SELECT Campaign, `Status`, COUNT(`Status`)
FROM call_details
WHERE Campaign != '' AND Campaign = 'Wishare - Search - TV'
GROUP BY Campaign, `Status`
UNION ALL
SELECT Campaign, `Status`, COUNT(`Status`)
FROM call_details
WHERE Campaign != '' AND Campaign = 'Wishare - Search - Prime (CN)'
GROUP BY Campaign, `Status`
UNION ALL
SELECT Campaign, `Status`, COUNT(`Status`)
FROM call_details
WHERE Campaign != '' AND Campaign = 'Wishare - Search - AIjia'
GROUP BY Campaign, `Status`
UNION ALL
SELECT Campaign, `Status`, COUNT(`Status`)
FROM call_details
WHERE Campaign != '' AND Campaign = 'Wishare - Search - Prime (EN)'
GROUP BY Campaign, `Status`;

#caller area
SELECT `Caller area code`, COUNT(`Caller area code`) count
FROM call_details
WHERE `Caller area code` != ' NA' AND `Caller area code` != ''
GROUP BY `Caller area code`
ORDER BY count DESC;




