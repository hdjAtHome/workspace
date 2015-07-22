CREATE TABLE [dbo].[ABM_ScenarioLevel] (
    [Delmodel]  NVARCHAR (64) NOT NULL,
    [ModelID]   SMALLINT      NULL,
    [ModelName] NVARCHAR (64) NULL,
    [LevelNo]   SMALLINT      NOT NULL,
    [Name]      NVARCHAR (64) NOT NULL,
    CONSTRAINT [PK_ScenarioLevel] PRIMARY KEY CLUSTERED ([Delmodel] ASC, [LevelNo] ASC, [Name] ASC) WITH (FILLFACTOR = 90)
);

