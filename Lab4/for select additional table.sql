/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[Action]
      ,[ModifiedDate]
      ,[SourceID]
      ,[UserName]
  FROM [AdventureWorks2012].[Sales].[CreditCardHst]

  DELETE   FROM [AdventureWorks2012].[Sales].[CreditCardHst];