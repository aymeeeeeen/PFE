
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 03/17/2021 11:19:38
-- Generated from EDMX file: C:\PFE\RoutesPlanning-Demo\RoutesPlanning-Demo\PlannificationModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [demoDB];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[SpacialDataSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SpacialDataSet];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'SpacialDataSet'
CREATE TABLE [dbo].[SpacialDataSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [vehicule] nvarchar(max)  NOT NULL,
    [dateDepart] datetime  NULL,
    [dateArivee] datetime  NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'SpacialDataSet'
ALTER TABLE [dbo].[SpacialDataSet]
ADD CONSTRAINT [PK_SpacialDataSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------