# Final project dw
# Oct 21, 2022

# I joined four subqueries A to D based on customer level, you can run each table separately.
# You may not create the view successfully due to mysql version. So you can run them one by one to debug.
# If you have any questions, please tell me in the group chat.
# I can't find some interesting queries and visualization topics right now, 
# so hope you guys can come up with some interesting questions on Q2 and I can help with the query.
# Tableau visualization, hope someone can do it.

# Let me explain the meaning of some variables for easy understanding. 
# Subquery A: Numb_Invo in table A is the number of orders the user has purchased, 
#          SupportRepId is which employee supported him, and Avg_Days is the average number of days between each order. 
#          For example, customer1 has a total of seven orders, then there ar e six interval dates. Then I calculated the average.
# Subquery B: Numb_Alb is the average of albums purchased per order,
#             we can also calculate the standard deviation between different orders. 
#             Numb_Gen is how many genres the customer has purchased.
#             Numb_Tracks is how many tracks the customer has purchased.
#             Avg_Minutes is the average duration of each song purchased by the customer.
#Subquery C: The number of songs purchased by customers in each gener(25 in total).
#Subquery D: The number of songs purchased by customers in each playlist(18 in total), some of which are duplicated.


USE final_project;

#Create DW
CREATE OR REPLACE VIEW Final_Project_dw AS
SELECT A.CustomerId, A.Last_Purchase, A.Numb_Invo, A.Total_Amount, A.Country, A.SupportRepId, A.Avg_Days,
	   B.Numb_Alb, B.Numb_Gen, B.Numb_Tracks, B.Avg_Minutes,
	   Rock, Jazz, Metal, Alternative_Punk, Rock_And_Roll, Blues, Lati, Reggae, Pop, Soundtrack, Bossa_Nova, Easy_Listening, Heavy_Metal, RnB_Soul, Electronica_Dance, World, Hip_Hop_Rap, Science_Fictio, TV_Shows, Sci_Fi_Fantasy, Drama, Comedy, Alternative, Classical, Opera,
	   1_Music, 2_Movies, 3_TV_Shows, 4_Audiobooks, 5_90’s_Music, 6_Audiobooks, 7_Movies, 8_Music, 9_Music_Videos, 10_TV_Shows, 11_Brazilian_Music, 12_Classical, 13_Classical_101_Deep_Cuts, 14_Classical_101_Next_Steps, 15_Classical_101_The_Basics, 16_Grunge, 17_Heavy_Metal_Classic, 18_On_The_Go_1
FROM ( SELECT  i.CustomerId, max(i.InvoiceDate) as Last_Purchase,COUNT(i.InvoiceId) as Numb_Invo, 
               SUM(i.Total) as Total_Amount, c.Country, c.SupportRepId,
               (sum(TIMESTAMPDIFF(DAY,i.InvoiceDate,(SELECT InvoiceDate 
													 FROM invoice 
													 WHERE InvoiceId > i.InvoiceId and CustomerId = i.CustomerId 
													 ORDER BY CustomerId, InvoiceId 
													 limit 1)))/(COUNT(InvoiceId)-1) )as Avg_Days
		FROM invoice i
             JOIN customer c 
				  ON i.CustomerId = c.CustomerId
        GROUP BY CustomerId) A
        
	JOIN ( SELECT i.CustomerId, round(count(distinct AlbumId)/count(distinct il.InvoiceId), 2) as Numb_Alb,
                  count(distinct GenreID) AS Numb_Gen, count(dif_albums.Numb_Tracks) as Numb_Tracks,
                  round(AVG((Milliseconds / (1000 * 60)) % 60), 2) as Avg_Minutes                  
           FROM invoiceline il
                JOIN invoice i
					 ON il.InvoiceId = i.InvoiceId
                JOIN track t
		             ON il.TrackId = t.TrackId
	            JOIN  (  SELECT i.CustomerId, il.InvoiceId, count(distinct AlbumId) as Numb_Alb, count(distinct il.TrackId) as Numb_Tracks
			             FROM invoiceline il
                             JOIN invoice i
                                 ON il.InvoiceId = i.InvoiceId
				             JOIN track t
                                 on il.TrackId = t.TrackId
			              GROUP BY il.InvoiceId   )   dif_albums
					 on il.InvoiceId = dif_albums.InvoiceId
			GROUP BY i.CustomerId
            ORDER BY CustomerId) B
	ON A.CustomerId = B.CustomerId

	JOIN (SELECT customerid,
                 sum(CASE GenreId WHEN '1'   THEN Num_Tracks ELSE 0 END) AS 'Rock',
                 sum(CASE GenreId WHEN '2'   THEN Num_Tracks ELSE 0 END) AS 'Jazz',
                 sum(CASE GenreId WHEN '3'   THEN Num_Tracks ELSE 0 END) AS 'Metal',
                 sum(CASE GenreId WHEN '4'   THEN Num_Tracks ELSE 0 END) AS 'Alternative_Punk',
                 sum(CASE GenreId WHEN '5'   THEN Num_Tracks ELSE 0 END) AS 'Rock_And_Roll',
                 sum(CASE GenreId WHEN '6'   THEN Num_Tracks ELSE 0 END) AS 'Blues',
                 sum(CASE GenreId WHEN '7'   THEN Num_Tracks ELSE 0 END) AS 'Lati',
                 sum(CASE GenreId WHEN '8'   THEN Num_Tracks ELSE 0 END) AS 'Reggae',
                 sum(CASE GenreId WHEN '9'   THEN Num_Tracks ELSE 0 END) AS 'Pop',
                 sum(CASE GenreId WHEN '10'   THEN Num_Tracks ELSE 0 END) AS 'Soundtrack',
                 sum(CASE GenreId WHEN '11'   THEN Num_Tracks ELSE 0 END) AS 'Bossa_Nova',
                 sum(CASE GenreId WHEN '12'   THEN Num_Tracks ELSE 0 END) AS 'Easy_Listening',
                 sum(CASE GenreId WHEN '13'   THEN Num_Tracks ELSE 0 END) AS 'Heavy_Metal',
                 sum(CASE GenreId WHEN '14'   THEN Num_Tracks ELSE 0 END) AS 'RnB_Soul',
                 sum(CASE GenreId WHEN '15'   THEN Num_Tracks ELSE 0 END) AS 'Electronica_Dance',
                 sum(CASE GenreId WHEN '16'   THEN Num_Tracks ELSE 0 END) AS 'World',
                 sum(CASE GenreId WHEN '17'   THEN Num_Tracks ELSE 0 END) AS 'Hip_Hop_Rap',
                 sum(CASE GenreId WHEN '18'   THEN Num_Tracks ELSE 0 END) AS 'Science_Fictio',
                 sum(CASE GenreId WHEN '19'   THEN Num_Tracks ELSE 0 END) AS 'TV_Shows',
                 sum(CASE GenreId WHEN '20'   THEN Num_Tracks ELSE 0 END) AS 'Sci_Fi_Fantasy',
                 sum(CASE GenreId WHEN '21'   THEN Num_Tracks ELSE 0 END) AS 'Drama',
                 sum(CASE GenreId WHEN '22'   THEN Num_Tracks ELSE 0 END) AS 'Comedy',
                 sum(CASE GenreId WHEN '23'   THEN Num_Tracks ELSE 0 END) AS 'Alternative',
                 sum(CASE GenreId WHEN '24'   THEN Num_Tracks ELSE 0 END) AS 'Classical',
                 sum(CASE GenreId WHEN '25'   THEN Num_Tracks ELSE 0 END) AS 'Opera'
           FROM
                 (SELECT i.CustomerId, t.GenreId, count(Distinct il.Trackid) as Num_Tracks
				  FROM invoiceline il
                       JOIN track t
                            ON  il.trackid = t.TrackId
					   JOIN invoice i
                            ON il.InvoiceId = i.InvoiceId
                  GROUP BY i.CustomerId, t.GenreId )  Tracks_Genre
          GROUP BY Tracks_Genre.CustomerId ) c
	ON B.CustomerId= C.CustomerId

   JOIN ( SELECT customerid,
                 sum(CASE playlistid WHEN '1'   THEN num ELSE 0 END) AS '1_Music',
	             sum(CASE playlistid WHEN '2'   THEN num ELSE 0 END) AS '2_Movies',
                 sum(CASE playlistid WHEN '3'   THEN num ELSE 0 END) AS '3_TV_Shows',
	             sum(CASE playlistid WHEN '4'   THEN num ELSE 0 END) AS '4_Audiobooks',
                 sum(CASE playlistid WHEN '5'   THEN num ELSE 0 END) AS '5_90’s_Music',
	             sum(CASE playlistid WHEN '6'   THEN num ELSE 0 END) AS '6_Audiobooks',
                 sum(CASE playlistid WHEN '7'   THEN num ELSE 0 END) AS '7_Movies',
	             sum(CASE playlistid WHEN '8'   THEN num ELSE 0 END) AS '8_Music',
                 sum(CASE playlistid WHEN '9'   THEN num ELSE 0 END) AS '9_Music_Videos',
	             sum(CASE playlistid WHEN '10'   THEN num ELSE 0 END) AS '10_TV_Shows',
                 sum(CASE playlistid WHEN '11'   THEN num ELSE 0 END) AS '11_Brazilian_Music',
	             sum(CASE playlistid WHEN '12'   THEN num ELSE 0 END) AS '12_Classical',
                 sum(CASE playlistid WHEN '13'   THEN num ELSE 0 END) AS '13_Classical_101_Deep_Cuts',
	             sum(CASE playlistid WHEN '14'   THEN num ELSE 0 END) AS '14_Classical_101_Next_Steps',
                 sum(CASE playlistid WHEN '15'   THEN num ELSE 0 END) AS '15_Classical_101_The_Basics',
	             sum(CASE playlistid WHEN '16'   THEN num ELSE 0 END) AS '16_Grunge',
                 sum(CASE playlistid WHEN '17'   THEN num ELSE 0 END) AS '17_Heavy_Metal_Classic',
	             sum(CASE playlistid WHEN '18'   THEN num ELSE 0 END) AS '18_On_The_Go_1'
           FROM
                (SELECT i.customerid,   pt.playlistid, count(distinct pt.trackid) as num
                 FROM invoiceline il
                      JOIN playlisttrack pt
                           ON  il.trackid = pt.TrackId
                      JOIN invoice i
                           ON il.InvoiceId = i.InvoiceId
				 GROUP BY CustomerId, pt.PlaylistId )  Tracks_Playlist
         GROUP BY  Tracks_Playlist.CustomerId) D
	ON C.CustomerId= D.CustomerId;

SELECT * FROM Final_Project_dw;




