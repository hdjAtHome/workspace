CREATE TABLE [dbo].[ABM_EnteredCostElement] (
    [Delmodel]             NVARCHAR (64) NOT NULL,
    [Period]               NVARCHAR (64) NOT NULL,
    [Scenario]             NVARCHAR (64) NOT NULL,
    [ModuleType]           NVARCHAR (64) NOT NULL,
    [AccountReference]     NVARCHAR (64) NULL,
    [Reference]            NVARCHAR (64) NOT NULL,
    [Name]                 NVARCHAR (64) NOT NULL,
    [EnteredCost]          FLOAT (53)    NULL,
    [AccountDimRef1]       NVARCHAR (64) NULL,
    [AccountDimMemberRef1] NVARCHAR (64) NULL,
    [AccountDimRef2]       NVARCHAR (64) NULL,
    [AccountDimMemberRef2] NVARCHAR (64) NULL,
    [AccountDimRef3]       NVARCHAR (64) NULL,
    [AccountDimMemberRef3] NVARCHAR (64) NULL,
    [AccountDimRef4]       NVARCHAR (64) NULL,
    [AccountDimMemberRef4] NVARCHAR (64) NULL,
    [AccountDimRef5]       NVARCHAR (64) NULL,
    [AccountDimMemberRef5] NVARCHAR (64) NULL
);

