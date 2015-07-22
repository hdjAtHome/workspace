CREATE TABLE [dbo].[ABM_Period] (
    [Delmodel]        VARCHAR (64)  NULL,
    [PeriodID]        INT           NULL,
    [Reference]       VARCHAR (64)  NULL,
    [ParentReference] VARCHAR (64)  NULL,
    [Name]            VARCHAR (64)  NULL,
    [StartDate]       DATETIME      NULL,
    [EndDate]         DATETIME      NULL,
    [Description]     VARCHAR (255) NULL
);

