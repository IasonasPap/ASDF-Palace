USE [ASDF-Palace]
GO

INSERT INTO [dbo].[Services]
           ([title])
     VALUES
           ('Bar'),
		   
		   ('Restaurant'),
		   
		   ('Hair Salon');

INSERT INTO [dbo].[Services]
           ([title]
           ,[requires_registration])
     VALUES

		   ('Gym',1),
		   
		   ('Room',1),
		   
		   ('Sauna',1),
		   
		   ('Meeting Room',1);
GO


