USE [ASDF-Palace]
GO

--1 client subscribe in GYM Service -> test if first subscription is ok---
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id],[subscription_time])
SELECT c.nfc_id,4,(select start_time from HasAccess as h,Spaces as sp where h.nfc_id=c.nfc_id and h.space_id=sp.id and sp.beds<>0)
FROM (select nfc_id from Clients WHERE YEAR(birthday)=1990) as c

--subscribe in GYM Service 12 Clients
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id])
SELECT c.nfc_id,4
FROM (select nfc_id from clients WHERE YEAR(birthday) between 1970 and 1973) as c

INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id],[subscription_time])
SELECT c.nfc_id,4, (select start_time from HasAccess as h,Spaces as sp where c.nfc_id=h.nfc_id and h.space_id=sp.id and sp.beds<>0)
FROM (select nfc_id from clients WHERE (YEAR(birthday) between 1991 and 2000) or (YEAR(birthday) between 1974 and 1976)) as c



--subscribe in SAUNA Service 19 Clients
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id],[subscription_time])
SELECT c.nfc_id,6, (select start_time from HasAccess as h,Spaces as sp where c.nfc_id=h.nfc_id and h.space_id=sp.id and sp.beds<>0)
FROM (select nfc_id from Clients where nfc_id<>6 AND nfc_id<>16 AND nfc_id<>22 AND (YEAR(birthday) between 1960 and 1969)) as c

INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id])
SELECT c.nfc_id,6
FROM (select nfc_id from Clients where YEAR(birthday) between 1970 and 1973) as c

INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id],[subscription_time])
SELECT c.nfc_id,6, (select start_time from HasAccess as h,Spaces as sp where c.nfc_id=h.nfc_id and h.space_id=sp.id and sp.beds<>0)
FROM (select nfc_id from Clients where nfc_id<>16 AND YEAR(birthday) between 1974 and 2003) as c


--subscribe in MEETING ROOM Service 8 Clients
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id],[subscription_time])
SELECT c.nfc_id,7, (select start_time from HasAccess as h,Spaces as sp where c.nfc_id=h.nfc_id and h.space_id=sp.id and sp.beds<>0)
FROM (select nfc_id from Clients where nfc_id<>22 AND  ((YEAR(birthday) between 1941 and 1952) or 
	(YEAR(birthday) between 1962 and 1969))) as c

INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id])
SELECT c.nfc_id,7
FROM (select nfc_id from Clients where YEAR(birthday) between 1970 and 1971) as c
