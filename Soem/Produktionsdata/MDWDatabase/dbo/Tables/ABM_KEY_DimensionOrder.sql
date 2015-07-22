CREATE TABLE [dbo].[ABM_KEY_DimensionOrder] (
    [Delmodel]       NVARCHAR (64) NOT NULL,
    [ModelID]        SMALLINT      NULL,
    [ModelName]      NVARCHAR (64) NULL,
    [ModuleType]     NVARCHAR (64) NOT NULL,
    [SequenceNumber] SMALLINT      NOT NULL,
    [DimID]          SMALLINT      NULL,
    [DimRef]         NVARCHAR (64) NOT NULL,
    [DimName]        NVARCHAR (64) NULL,
    CONSTRAINT [PK_ABM_KEY_DimensionOrder] PRIMARY KEY CLUSTERED ([Delmodel] ASC, [ModuleType] ASC, [SequenceNumber] ASC, [DimRef] ASC) WITH (FILLFACTOR = 90)
);

