CREATE DATABASE [NewDatabase];

USE [NewDatabase]; 
GO

CREATE SCHEMA [sales];
GO

CREATE SCHEMA [persons];
GO

CREATE TABLE [sales].[Orders] ([OrderNum] INT NULL);

BACKUP DATABASE [NewDatabase] TO DISK='D:\Studying\7_semestr\DB\Lab1\backup.bak';

USE [master]
GO

DROP DATABASE [NewDatabase];

RESTORE DATABASE [NewDatabase] FROM DISK='D:\Studying\7_semestr\DB\Lab1\backup.bak';
