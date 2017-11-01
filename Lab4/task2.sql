USE [AdventureWorks2012]
GO

/*---------------------------------------------------------------------------*/
/*a) �������� ������������� VIEW, ������������ ������ �� ������ Sales.CreditCard 
� Sales.PersonCreditCard. �������� ����������� �������� ��������� ���� �������������. 
�������� ���������� ���������� ������ � ������������� �� ���� CreditCardID.*/

IF (OBJECT_ID(N'[Sales].[PersonCreditCardDataView]') IS NOT NULL)
BEGIN
      DROP VIEW [Sales].[PersonCreditCardDataView];
END


CREATE VIEW [Sales].[PersonCreditCardDataView] WITH SCHEMABINDING
AS
SELECT [CC].[CreditCardID], [BusinessEntityID], [CardType], [CardNumber], [ExpMonth], [ExpYear], [CC].[ModifiedDate]
FROM [Sales].[PersonCreditCard] AS [PCC] 
JOIN [Sales].[CreditCard] AS [CC]
ON [PCC].[CreditCardID] = [CC].[CreditCardID];

SELECT * FROM [Sales].[PersonCreditCardDataView] ; 

CREATE UNIQUE CLUSTERED INDEX [CreditCardIdIndex] ON [Sales].[PersonCreditCardDataView]([CreditCardID]);

UPDATE [Sales].[PersonCreditCardDataView]
SET [ModifiedDate] = '2007-09-30 00:00:00.000'
WHERE [CreditCardID] = 1;

SELECT * FROM [Sales].[CreditCard] ORDER BY [CreditCardID];

/*---------------------------------------------------------------------------*/
/*b) �������� ��� INSTEAD OF �������� ��� ������������� �� �������� INSERT, UPDATE, DELETE. 
������ ������� ������ ��������� ��������������� �������� � �������� 
Sales.CreditCard � Sales.PersonCreditCard ��� ���������� BusinessEntityID. 
���������� ������ ����������� ������ � ������� Sales.CreditCard. 
�������� ����� �� ������� Sales.CreditCard ����������� ������ � ��� ������, 
���� ��������� ������ ������ �� ��������� �� Sales.PersonCreditCard.*/


IF (OBJECT_ID(N'[Sales].[InsteadInsertTrigger]') IS NOT NULL)
BEGIN
      DROP TRIGGER [Sales].[InsteadInsertTrigger];
END

CREATE TRIGGER [InsteadInsertTrigger] on [Sales].[PersonCreditCardDataView]
INSTEAD OF INSERT
AS
BEGIN
	SET IDENTITY_INSERT [Sales].[CreditCard] ON;
	INSERT INTO [Sales].[CreditCard]( [CreditCardID], [CardType], [CardNumber], [ExpMonth], [ExpYear], [ModifiedDate]) 
	SELECT [CreditCardID], [CardType], [CardNumber], [ExpMonth], [ExpYear], [ModifiedDate]
	FROM [INSERTED];
	SET IDENTITY_INSERT [Sales].[CreditCard] OFF;


	INSERT INTO [Sales].[PersonCreditCard]([BusinessEntityID], [CreditCardID], [ModifiedDate])
	SELECT [BusinessEntityID], [CreditCardID], [ModifiedDate]
	FROM [INSERTED];	

END;
GO


IF (OBJECT_ID(N'[Sales].[InsteadUpdateTrigger]') IS NOT NULL)
BEGIN
      DROP TRIGGER [Sales].[InsteadUpdateTrigger];
END;


CREATE TRIGGER [InsteadUpdateTrigger] on [Sales].[PersonCreditCardDataView]
INSTEAD OF UPDATE
AS
BEGIN
	UPDATE [Sales].[CreditCard]
	SET [CardType] = [Ins].[CardType] ,
		[CardNumber] = [Ins].[CardNumber] ,
		[ExpMonth] = [Ins].[ExpMonth],
		[ExpYear] = [Ins].[ExpYear] ,
		[ModifiedDate] = [Ins].[ModifiedDate] 
	FROM [INSERTED] AS [Ins]
	WHERE [Sales].[CreditCard].[CreditCardID] = (SELECT [CreditCardID] FROM [INSERTED] )
END;


IF (OBJECT_ID(N'[Sales].[InsteadDeleteTrigger]') IS NOT NULL)
BEGIN
      DROP TRIGGER [Sales].[InsteadDeleteTrigger];
END;

CREATE TRIGGER [InsteadDeleteTrigger] on [Sales].[PersonCreditCardDataView]
INSTEAD OF DELETE
AS
BEGIN

	DELETE FROM [Sales].[PersonCreditCard] 
	WHERE [Sales].[PersonCreditCard].[CreditCardID] = (SELECT [CreditCardID] FROM [DELETED] )

	DELETE FROM [Sales].[CreditCard] 
	WHERE [Sales].[CreditCard].[CreditCardID] = (SELECT [CreditCardID] FROM [DELETED] )
		   AND (SELECT COUNT(*) FROM [Sales].[PersonCreditCard]
		   WHERE [Sales].[PersonCreditCard].[CreditCardID] = (SELECT [CreditCardID] FROM [DELETED])) = 0;	
END;


/*---------------------------------------------------------------------------*/
/*c) �������� ����� ������ � �������������, ������ ����� ������ ��� CreditCard ��� 
������������� BusinessEntityID (�������� 1). ������� ������ �������� ����� ������ � ������� 
Sales.CreditCard � Sales.PersonCreditCard. �������� ����������� ������ ����� �������������. 
������� ������.*/
--SET IDENTITY_INSERT [Sales].[PersonCreditCardDataView] OFF;

INSERT INTO [Sales].[PersonCreditCardDataView]([CreditCardID], [BusinessEntityID], [CardType], [CardNumber], [ExpMonth], [ExpYear], [ModifiedDate]) 
VALUES (22000, 1, 'Vista', 99999999971255, 12, 2007, '1997-03-25 00:00:00.000');

SELECT * FROM [Sales].[PersonCreditCardDataView] ORDER BY [CreditCardID] DESC;

UPDATE [Sales].[PersonCreditCardDataView]
SET [Sales].[PersonCreditCardDataView].[ModifiedDate] = '1997-03-25 16:00:00.000',
	[ExpMonth] = 11,
	[ExpYear] = 2006
WHERE [CreditCardID] = 22000;

DELETE [Sales].[PersonCreditCardDataView]
WHERE [CreditCardID] = 22000;


SELECT * FROM [Sales].[PersonCreditCardDataView] ORDER BY [CreditCardID] DESC;

SELECT * FROM [Sales].[PersonCreditCard] ORDER BY [CreditCardID] DESC;

SELECT * FROM [Sales].[CreditCard] ORDER BY [CreditCardID] DESC;