CREATE TABLE [edw].[TD_Dim_CostObject] (
    [Reference]       VARCHAR (50) NOT NULL,
    [Name]            VARCHAR (50) NOT NULL,
    [ParentReference] VARCHAR (50) NULL,
    [Period]          VARCHAR (50) NULL,
    [Togsystem]       INT          NULL
);

