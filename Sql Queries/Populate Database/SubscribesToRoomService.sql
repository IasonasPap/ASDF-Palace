USE [ASDF-Palace]
GO

--1 client subscribe in ROOM Service -> test if first subscription is ok---
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id]) VALUES (1,5)

--34 clients subscribe in ROOM Service
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id])
SELECT c.nfc_id,5
FROM Clients as c
WHERE c.nfc_id<>1 AND c.nfc_id<>2 AND c.nfc_id<>10 AND c.nfc_id<>16 AND c.nfc_id<>22 AND c.nfc_id<>36
