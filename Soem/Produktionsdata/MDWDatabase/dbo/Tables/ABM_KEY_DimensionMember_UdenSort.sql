CREATE TABLE [dbo].[ABM_KEY_DimensionMember_UdenSort] (
    [Delmodel]        VARCHAR (64) NOT NULL,
    [DimRef]          VARCHAR (64) NOT NULL,
    [Reference]       VARCHAR (64) NOT NULL,
    [Name]            VARCHAR (64) NULL,
    [ParentReference] VARCHAR (64) NULL,
    [DimLevel]        INT          NULL,
    [DimLevelName]    VARCHAR (64) NULL,
    CONSTRAINT [PK_ABM_KEY_DimensionMember_UdenSort] PRIMARY KEY CLUSTERED ([Delmodel] ASC, [DimRef] ASC, [Reference] ASC) WITH (FILLFACTOR = 90)
);

