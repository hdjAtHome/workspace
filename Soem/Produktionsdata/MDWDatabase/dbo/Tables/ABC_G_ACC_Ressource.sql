﻿CREATE TABLE [dbo].[ABC_G_ACC_Ressource] (
    [Comments]        VARCHAR (255) NULL,
    [DocRef]          VARCHAR (50)  NULL,
    [Reference]       VARCHAR (50)  NOT NULL,
    [ModuleType]      VARCHAR (50)  NOT NULL,
    [Name]            VARCHAR (50)  NULL,
    [ParentReference] VARCHAR (50)  NULL,
    [Periode]         VARCHAR (50)  NOT NULL,
    [DataSerie]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_ABC_G_ACC_Resource] PRIMARY KEY CLUSTERED ([Reference] ASC, [ModuleType] ASC, [Periode] ASC)
);

