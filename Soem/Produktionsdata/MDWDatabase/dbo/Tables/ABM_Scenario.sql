CREATE TABLE [dbo].[ABM_Scenario] (
    [Delmodel]        NVARCHAR (64) NOT NULL,
    [ScenarioID]      SMALLINT      NULL,
    [Reference]       NVARCHAR (64) NOT NULL,
    [ParentReference] NVARCHAR (64) NULL,
    [Name]            NVARCHAR (64) NULL,
    [Description]     NTEXT         NULL,
    CONSTRAINT [PK_Scenario] PRIMARY KEY CLUSTERED ([Delmodel] ASC, [Reference] ASC) WITH (FILLFACTOR = 90)
);

