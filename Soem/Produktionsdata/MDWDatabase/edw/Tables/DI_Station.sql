CREATE TABLE [edw].[DI_Station] (
    [PK_ID]               INT           IDENTITY (1, 1) NOT NULL,
    [Stationsforkortelse] VARCHAR (10)  NULL,
    [Station]             VARCHAR (255) NULL,
    CONSTRAINT [PK_DI_Station] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

