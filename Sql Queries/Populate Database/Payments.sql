USE [ASDF-Palace]
GO

--ROOM PAYMENTS 30 Clients paid
INSERT INTO [dbo].[Payments]
           ([nfc_id],[description],[cost])
     VALUES
           (1,'Room1',200),
		   (3,'Room3',60),
		   (4,'Room4',400),
		   (5,'Room5',250),
		   (6,'Room6',180),
		   (7,'Room7',200),
		   (8,'Room8',90),
		   (9,'Room9',240),
		   (11,'Room11',390),
		   (12,'Room12',440),

		   (13,'Room13',1000),
		   (14,'Room14',130),
		   (15,'Room15',120),
		   (17,'Room17',180),
		   (18,'Room18',230),
		   (19,'Room19',320),
		   (20,'Room20',310),
		   (21,'Room21',370),
		   (23,'Room23',430),
		   (24,'Room24',420),

		   (25,'Room25',480),
		   (26,'Room26',500),
		   (27,'Room27',600),
		   (28,'Room28',510),
		   (29,'Room29',220),
		   (30,'Room30',250),
		   (31,'Room31',200),
		   (32,'Room32',100),
		   (33,'Room33',280),
		   (34,'Room34',245)
GO

--50 SERVICES PAYMENTS
/*
11    3 GYM    0 SAUNA     0 MEETING ROOM
12    2 GYM    1 SAUNA     0 MEETING ROOM
13    1 GYM    1 SAUNA     0 MEETING ROOM
14    1 GYM    0 SAUNA     0 MEETING ROOM
15    1 GYM    0 SAUNA     0 MEETING ROOM
21    0 GYM    2 SAUNA     2 MEETING ROOM
23    0 GYM    1 SAUNA     1 MEETING ROOM
24    2 GYM    3 SAUNA     3 MEETING ROOM
25    2 GYM    3 SAUNA     3 MEETING ROOM
26    2 GYM    1 SAUNA     0 MEETING ROOM
27    2 GYM    1 SAUNA     0 MEETING ROOM
28    2 GYM    1 SAUNA     0 MEETING ROOM
29    0 GYM    1 SAUNA     0 MEETING ROOM
30    1 GYM    2 SAUNA     0 MEETING ROOM
31    0 GYM    0 SAUNA     1 MEETING ROOM
32    0 GYM    0 SAUNA     2 MEETING ROOM
33    0 GYM    0 SAUNA     1 MEETING ROOM
34    0 GYM    0 SAUNA     1 MEETING ROOM
*/
INSERT INTO [dbo].[Payments]
           ([nfc_id],[description],[cost])
     VALUES
           (11,'Gym',200),
		   (12,'Gym',60),
		   (13,'Gym',400),
		   (14,'Gym',250),
		   (21,'Sauna',180),
		   (23,'Sauna',200),
		   (24,'Sauna',90),
		   (31,'Meeting Room',240),
		   (32,'Meeting Room',390),
		   (33,'Meeting Room',440),

		   (15,'Gym',1000),
		   (24,'Gym',130),
		   (25,'Gym',120),
		   (25,'Sauna',180),
		   (26,'Sauna',230),
		   (27,'Sauna',320),
		   (28,'Sauna',310),
		   (34,'Meeting Room',370),
		   (21,'Meeting Room',430),
		   (23,'Meeting Room',420),

		   (26,'Gym',480),
		   (27,'Gym',500),
		   (28,'Gym',600),
		   (29,'Sauna',510),
		   (30,'Sauna',220),
		   (24,'Meeting Room',200),
		   (25,'Meeting Room',100),
		   (26,'Gym',120),
		   (27,'Gym',80),
		   (28,'Gym',40),

		   (11,'Gym',80),
		   (12,'Gym',40),
		   (11,'Gym',600),
		   (12,'Sauna',510),
		   (13,'Sauna',220),
		   (24,'Sauna',10),
		   (25,'Sauna',20),
		   (24,'Meeting Room',370),
		   (25,'Meeting Room',430),
		   (32,'Meeting Room',420),

		   (24,'Gym',80),
		   (24,'Sauna',40),
		   (24,'Meeting Room',600),
		   (25,'Gym',80),
		   (25,'Sauna',40),
		   (25,'Meeting Room',600),
		   (21,'Sauna',20),
		   (21,'Meeting Room',370),
		   (30,'Gym',30),
		   (30,'Sauna',40)
GO
