USE [ASDF-Palace]
GO

--HAS ACCESS to ROOM
INSERT INTO [dbo].[HasAccess]
           ([nfc_id],[space_id],[start_time],[end_time])
     VALUES
           (1,1,'2021-06-05 12:28:57.143','2021-06-10 12:00:00.000'),
		   (3,3,'2021-06-10 12:28:57.143','2021-06-15 12:00:00.000'),
		   (4,4,'2021-06-15 12:28:57.143','2021-06-20 12:00:00.000'),
		   (5,5,'2021-06-20 12:28:57.143','2021-06-23 12:00:00.000'),
		   (6,6,'2021-06-25 12:28:57.143','2021-06-30 12:00:00.000')
GO

INSERT INTO [dbo].[HasAccess]
([nfc_id],[space_id],[start_time],[end_time])
     VALUES
	--stayed in the hotel in the near past
		   (7,7,'2021-08-25 12:28:57.143','2021-08-30 12:00:00.000'),
		   (8,8,'2021-08-26 12:28:57.143','2021-09-01 12:00:00.000'),
		   (9,9,'2021-08-27 12:28:57.143','2021-09-02 12:00:00.000'),
		   (11,11,'2021-08-28 12:28:57.143','2021-09-03 12:00:00.000'),
		   (12,12,'2021-08-29 12:28:57.143','2021-09-04 12:00:00.000'),
		   (13,13,'2021-09-01 12:28:57.143','2021-09-07 12:00.000'),
		   (14,14,'2021-09-03 12:28:57.143','2021-09-09 12:00:00.000'),
	--stay in the hotel now
		   (15,15,'2021-09-7 12:28:57.143','2021-09-14 12:00:00.000'),
		   (17,17,'2021-09-8 12:28:57.143','2021-09-14 12:00:00.000'),
		   (18,18,'2021-09-8 12:28:57.143','2021-09-14 12:00:00.000'),
		   (19,19,'2021-09-9 12:28:57.143','2021-09-15 12:00:00.000'),
		   (20,20,'2021-09-9 12:28:57.143','2021-09-15 12:00:00.000'),
		   (21,21,'2021-09-10 12:28:57.143','2021-09-16 12:00:00.000'),
		   (23,23,'2021-09-10 12:28:57.143','2021-09-17 12:00:00.000'),
		   (24,24,null,'2021-09-15 12:00:00.000'),
		   (25,25,null,'2021-09-16 12:00:00.000'),
		   (26,26,null,'2021-09-17 12:00:00.000'),
		   (27,27,null,'2021-09-18 12:00:00.000'),
	--will stay in the hotel in the future
		   (28,28,'2021-09-20 20:28:57.143','2021-09-24 12:00:00.000'),
		   (29,29,'2021-09-21 20:28:57.143','2021-09-25 21:00:00.000'),
		   (30,30,'2021-09-22 20:28:57.143','2021-09-26 21:00:00.000'),
		   (31,31,'2021-09-23 20:28:57.143','2021-09-27 21:00:00.000'),
		   (32,32,'2021-09-24 20:28:57.143','2021-09-28 21:00:00.000'),
		   (33,33,'2021-09-25 20:28:57.143','2021-09-29 21:00:00.000'),
		   (34,34,'2021-09-26 20:28:57.143','2021-09-30 21:00:00.000')
GO

--null for start_time or end_time
INSERT INTO [dbo].[HasAccess]
           ([nfc_id],[space_id],[start_time],[end_time])
     VALUES
--2 clients have not been added - meeting room
           (31,436,'2021-09-23 20:28:57.143',null),
		   (32,437,'2021-09-24 20:28:57.143',null),
		   (33,438,'2021-09-25 20:28:57.143',null),
		   (34,439,'2021-09-26 20:28:57.143',null),
		   (21,441,'2021-09-11 20:28:57.143','2021-09-11 21:00:00.000'),
		   (23,443,'2021-09-11 20:28:57.143','2021-09-11 21:00:00.000'),
		   (24,444,'2021-09-13 20:28:57.143','2021-09-14 21:00:00.000'),
		   (25,445,'2021-09-13 20:28:57.143','2021-09-14 21:00:00.000'),
--3 clients have not been added - gym
		   (11,446,'2021-09-1','2021-09-3 23:59:00.000'),
		   (12,446,'2021-09-1','2021-09-3 23:59:00.000'),
		   (13,446,'2021-09-3','2021-09-6 23:59:00.000'),
		   (14,447,'2021-09-3','2021-09-8 21:59:00.000'),
		   (15,447,null,'2021-09-13 21:00:00.000'),
		   (24,448,null,'2021-09-14 21:00:00.000'),
		   (25,448,null,'2021-09-15 21:00:00.000'),
		   (26,449,null,null),
		   (27,449,null,null),
		   (28,449,'2021-09-20 20:28:57.143',null),
--16 clients have not been added - sauna
		   (21,450,'2021-09-11 20:28:57.143',null),
		   (23,452,'2021-09-11 20:28:57.143',null),
		   (24,453,'2021-09-13',null),
		   (25,454,'2021-09-13',null),
		   (26,455,'2021-09-13',null),
		   (27,456,'2021-09-13',null),
		   (28,457,'2021-09-20 20:28:57.143',null),
		   (29,458,'2021-09-21 20:28:57.143',null),
		   (30,459,'2021-09-22 20:28:57.143','2021-09-26 21:00:00.000')
GO
