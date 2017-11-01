USE [AdventureWorks2012]
GO

/*---------------------------------------------------------------------------*/
/*a) —оздайте таблицу Sales.CreditCardHst, котора€ будет хранить информацию 
	 об изменени€х в таблице Sales.CreditCard.

	 ќб€зательные пол€, которые должны присутствовать в таблице: 
	 ID Ч первичный ключ IDENTITY(1,1); 
	 Action Ч совершенное действие (insert, update или delete); 
	 ModifiedDate Ч дата и врем€, когда была совершена операци€; 
	 SourceID Ч первичный ключ исходной таблицы; 
	 UserName Ч им€ пользовател€, совершившего операцию. 
	 —оздайте другие пол€, если считаете их нужными.*/
DROP TABLE 	[Sales].[CreditCardHst];

CREATE TABLE [Sales].[CreditCardHst] (
			 [ID] INT PRIMARY KEY IDENTITY(1,1),
			 [Action] CHAR(1),
			 [ModifiedDate] DATETIME,
			 [SourceID] INT,
			 [UserName] VARCHAR(50));

/*---------------------------------------------------------------------------*/
/*b) —оздайте один AFTER триггер дл€ трех операций INSERT, UPDATE, DELETE 
     дл€ таблицы Sales.CreditCard. “риггер должен заполн€ть таблицу Sales.CreditCardHst 
	 с указанием типа операции в поле Action в зависимости от оператора, вызвавшего триггер.*/

IF (OBJECT_ID(N'[Sales].[CreditCardTrigger]') IS NOT NULL)
BEGIN
      DROP TRIGGER [Sales].[CreditCardTrigger];
END;

CREATE TRIGGER [CreditCardTrigger] 
ON [Sales].[CreditCard]  
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	INSERT INTO [Sales].[CreditCardHst] 
		SELECT CASE WHEN EXISTS(SELECT * FROM [DELETED]) AND EXISTS(SELECT * FROM [INSERTED])
						THEN 'U'
					WHEN EXISTS(SELECT * FROM [DELETED])
						THEN 'D'
					ELSE 'I'
				END,
				GETDATE(),
				COALESCE( [INSERTED].[CreditCardID], [DELETED].[CreditCardID] ),
				USER_NAME()
		FROM [INSERTED] 
		FULL OUTER JOIN [DELETED] 
		ON [INSERTED].[CreditCardID] = [DELETED].[CreditCardID]
END;


INSERT INTO [Sales].[CreditCard]( [CardType], [CardNumber], [ExpMonth], [ExpYear], [ModifiedDate])
VALUES ( 'Vista', 11111000471255, 12, 2007, '2008-02-06 00:00:00.000');

UPDATE [Sales].[CreditCard] SET [ExpMonth] = 11 WHERE [CardNumber] = 11111000471255;

DELETE FROM [Sales].[CreditCard] WHERE [CardNumber] = 11111000471255;

/*---------------------------------------------------------------------------*/
/*c) —оздайте представление VIEW, отображающее все пол€ таблицы Sales.CreditCard.*/
IF (OBJECT_ID(N'[Sales].[CreditCardView]') IS NOT NULL)
BEGIN
      DROP VIEW [Sales].[CreditCardView];
END;

CREATE VIEW [Sales].[CreditCardView]
AS
SELECT * FROM [Sales].[CreditCard];



SELECT * FROM [Sales].[CreditCard] ORDER BY [CardNumber] ASC ;

SELECT * FROM [Sales].[CreditCardView] ORDER BY [CardNumber] ASC;

/*---------------------------------------------------------------------------*/
/*d) ¬ставьте новую строку в Sales.CreditCard через представление.
 ќбновите вставленную строку. ”далите вставленную строку. 
 ”бедитесь, что все три операции отображены в Sales.CreditCardHst.*/
 INSERT INTO [Sales].[CreditCardView]( [CardType], [CardNumber], [ExpMonth], [ExpYear], [ModifiedDate])
 VALUES ( 'Vista', 11111000471255, 12, 2007, '2008-02-06 00:00:00.000');

 UPDATE [Sales].[CreditCardView] SET [ExpMonth] = 11 WHERE [CardNumber] = 11111000471255;

 DELETE FROM [Sales].[CreditCardView] WHERE [CardNumber] = 11111000471255;



