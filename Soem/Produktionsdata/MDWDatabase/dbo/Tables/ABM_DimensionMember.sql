CREATE TABLE [dbo].[ABM_DimensionMember] (
    [Delmodel]        NVARCHAR (64) NOT NULL,
    [DimRef]          NVARCHAR (64) NOT NULL,
    [Reference]       NVARCHAR (64) NOT NULL,
    [Name]            NVARCHAR (64) NOT NULL,
    [ParentReference] NVARCHAR (64) NULL,
    [DimLevel]        SMALLINT      NULL,
    [DimLevelName]    NVARCHAR (64) NULL
);

