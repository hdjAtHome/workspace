CREATE TABLE [dbo].[ABM_KEY_Dimension] (
    [Delmodel]  NVARCHAR (64) NOT NULL,
    [ModelID]   SMALLINT      NULL,
    [ModelName] NVARCHAR (64) NULL,
    [DimID]     SMALLINT      NULL,
    [Reference] NVARCHAR (64) NOT NULL,
    [Name]      NVARCHAR (64) NOT NULL,
    CONSTRAINT [PK_ABM_KEY_Dimension] PRIMARY KEY CLUSTERED ([Delmodel] ASC, [Reference] ASC) WITH (FILLFACTOR = 90)
);

