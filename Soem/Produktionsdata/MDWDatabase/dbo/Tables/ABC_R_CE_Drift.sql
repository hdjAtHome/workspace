CREATE TABLE [dbo].[ABC_R_CE_Drift] (
    [Comments]         VARCHAR (255) NULL,
    [DocRef]           VARCHAR (50)  NULL,
    [Reference]        VARCHAR (50)  NOT NULL,
    [ModuleType]       VARCHAR (50)  NOT NULL,
    [Name]             VARCHAR (50)  NULL,
    [AccountReference] VARCHAR (50)  NULL,
    [EnteredCost]      FLOAT (53)    NULL,
    [Periode]          VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_ABC_R_CE_Drift] PRIMARY KEY CLUSTERED ([Reference] ASC, [ModuleType] ASC, [Periode] ASC)
);

