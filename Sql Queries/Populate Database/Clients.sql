USE [ASDF-Palace]
GO

--40 clients
INSERT INTO [dbo].[Clients]
           ([first_name]
           ,[last_name]
           ,[birthday]
           ,[identification_number]
           ,[identification_type]
           ,[identification_issue_authority])
     VALUES
			('Alexis','Trakakis','2003-12-3','ал811519','Id Card','ат баягс'),
			('Iasonas','Papadim','2004-11-5','ал343459','Id Card','ат баягс'),
			('Mike','Linos','2013-10-27',null,null,null),
			('George','Tsimos','2012-8-13',null,null,null),
			('Maria','Kanellopoulou','2011-2-1',null,null,null),
			('Jonas','Maciulis','2010-3-30',null,null,null),
			('Katerina','Linou','2009-1-4',null,null,null),
			('Nikos','Linos','2008-4-8',null,null,null),
		   ('Niki','Kantali','2007-5-11','AU8967453','Passport','аеа'),
		   ('Melina','Moniaki','2006-6-17','йл303599','Id Card','ат буяыма'),

		   ('Kostas','Karakaxidis','1996-1-1','ал343059','Id Card','ат йояыпиоу'),
		   ('Barbara','Papadopoulou','1997-2-2','KL123456','Passport','аеа'),
		   ('Alexandra','Matraki','1998-3-3','ай121212','Id Card','ат алаяоусиоу'),
		   ('Marios','Mposhs','1999-4-4','LO9021769','Passport','аеа'),
		   ('Mark','Gasol','2000-5-5','пл129078','Id Card','N.Y'),
		   ('Sonia','Katevaki','1983-6-6','DM3620979','Passport','аеа'),
		   ('Katia','Danihl','1985-7-7','йл908356','Id Card','ат боукас'),
		   ('Stathis','Koutouzos','1988-8-10','RT2143657','Passport','аеа'),
		   ('Eric','Cantona','1990-9-8','кт890216','Id Card','PO SAO PAOLO'),
		   ('Laura','Nerman','1989-10-9','WM6045698','Passport','NPC'),

		   ('Thalia','Giannaka','1962-11-30','PL1357903','Passport','аеа'),
		   ('Fotis','Stergiou','1965-12-29','ея213143','Id Card','ат йеяйуяас'),
		   ('Andreas','Papadim','1966-1-28','TE1238769','Passport','аеа'),
		   ('Nikos','Pelekanos','1970-2-27','тл432120','Id Card','ат баягс'),
		   ('Alex','Xalkidis','1971-3-26','UM1480998','Passport','аеа'),
		   ('Lina','Kara','1972-4-25','йп907897','Id Card','ат йухмоу'),
		   ('Stauros','Sinas','1973-5-24','LP5487123','Passport','аеа'),
		   ('Stella','Ferle','1974-6-23','пм123456','Id Card','ат баягс'),
		   ('Monika','Belle','1975-7-22','U6543640','Passport','NPC'),
		   ('Giannis','Tritsis','1976-8-21','йт125690','Id Card','ат йакалатас'),

		   ('Stratos','Perperoglou','1941-9-20','TH3216548','Passport','аеа'),
		   ('Iasonas','Kalomiris','1943-10-19','лк909078','Id Card','ат сепокиым'),
		   ('Molly','Malone','1950-11-18','A4589108','Passport','NPC'),
		   ('Stephan','Kraven','1952-12-17','йс951468','Id Card','PO BERLIN'),
		   ('Thomas','Tasoulis','1953-1-16','SD5589001','Passport','аеа'),
		   ('Daria','Lorian','1956-2-15','ал456745','Id Card','PO MARYLAND'),
		   ('Fanis','Dararas','1957-3-14','SK6458762','Passport','аеа'),
		   ('Lena','Teller','1959-8-18','K2771199','Id Card','PO IONA'),
		   ('Daryl','Macon','1958-4-13','9182735','Passport','NPC'),
		   ('Ben','Teller','1959-6-11','ак771199','Id Card','PO IONA')
GO

--49 emails(some of them have two)
INSERT INTO [dbo].[Emails]
           ([nfc_id]
           ,[email])
     VALUES
           (1,'email1@gmail.com'),
		   (2,'email2@gmail.com'),
		   (3,'email3@gmail.com'),
		   (4,'email4@gmail.com'),
		   (5,'email5@gmail.com'),
		   (6,'email6@gmail.com'),
		   (7,'email7@gmail.com'),
		   (8,'email8@gmail.com'),
		   (9,'email9@gmail.com'),
		   (10,'email10@gmail.com'),
		   (11,'email11@gmail.com'),
		   (12,'email12@gmail.com'),
		   (13,'email13@gmail.com'),
		   (14,'email14@gmail.com'),
		   (15,'email15@gmail.com'),
		   (16,'email16@gmail.com'),
		   (17,'email17@gmail.com'),
		   (18,'email18@gmail.com'),
		   (19,'email19@gmail.com'),
		   (20,'email20@gmail.com'),
		   (21,'email21@gmail.com'),
		   (22,'email22@gmail.com'),
		   (23,'email23@gmail.com'),
		   (24,'email24@gmail.com'),
		   (25,'email25@gmail.com'),
		   (26,'email26@gmail.com'),
		   (27,'email27@gmail.com'),
		   (28,'email28@gmail.com'),
		   (29,'email29@gmail.com'),
		   (30,'email30@gmail.com'),
		   (31,'email31@gmail.com'),
		   (32,'email32@gmail.com'),
		   (33,'email33@gmail.com'),
		   (34,'email34@gmail.com'),
		   (35,'email35@gmail.com'),
		   (36,'email36@gmail.com'),
		   (37,'email37@gmail.com'),
		   (38,'email38@gmail.com'),
		   (39,'email39@gmail.com'),
		   (40,'email40@gmail.com'),

		   (1,'email1@hotmail.com'),
		   (5,'email5@hotmail.com'),
		   (10,'email10@hotmail.com'),
		   (15,'email15@hotmail.com'),
		   (20,'email20@hotmail.com'),
		   (25,'email25@hotmail.com'),
		   (30,'email30@hotmail.com'),
		   (35,'email35@hotmail.com'),
		   (40,'email40@hotmail.com')
GO

--49 phones(some of them have two)
INSERT INTO [dbo].[Phones]
           ([nfc_id]
           ,[phone])
     VALUES
           (1,'6932547665'),
		   (2,'6934523564'),
		   (3,'6942980680'),
		   (4,'6975697643'),
		   (5,'6965458529'),
		   (6,'6900775534'),
		   (7,'6911223344'),
		   (8,'6966778899'),
		   (9,'6909347819'),
		   (10,'6928379328'),
		   (11,'6916907569'),
		   (12,'6994638579'),
		   (13,'6964579623'),
		   (14,'6945589781'),
		   (15,'5027069584'),
		   (16,'6964795880'),
		   (17,'6900426795'),
		   (18,'6904586798'),
		   (19,'6072058964'),
		   (20,'6598064268'),
		   (21,'6978945638'),
		   (22,'6927206786'),
		   (23,'6906798345'),
		   (24,'6913200544'),
		   (25,'6907295812'),
		   (26,'6904752675'),
		   (27,'6905947527'),
		   (28,'6989765404'),
		   (29,'6509781664'),
		   (30,'6948941530'),
		   (31,'6947894563'),
		   (32,'6978945789'),
		   (33,'9887560863'),
		   (34,'1230590456'),
		   (35,'6978996374'),
		   (36,'2587539515'),
		   (37,'6945697138'),
		   (38,'3806070809'),
		   (39,'9685020053'),
		   (40,'6497385120'),

		   (1,'2108979798'),
		   (5,'2114548469'),
		   (10,'+0035 7894654189'),
		   (15,'2125468989'),
		   (20,'21069353874'),
		   (8,'+0045 7894654189'),
		   (18,'2124568767'),
		   (28,'2857946120'),
		   (38,'+0034 7894654189')
GO