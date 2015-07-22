CREATE TABLE [edw].[DI_CostObject] (
    [Reference]       VARCHAR (50) NOT NULL,
    [Name]            VARCHAR (50) NOT NULL,
    [ParentReference] VARCHAR (50) NULL,
    [FK_DI_Togsystem] INT          NULL,
    CONSTRAINT [PK_DI_CostObject] PRIMARY KEY CLUSTERED ([Reference] ASC)
);

