CREATE TABLE [edw].[DI_Depot] (
    [PK_ID]           INT          IDENTITY (1, 1) NOT NULL,
    [Depot]           VARCHAR (50) NOT NULL,
    [Station]         VARCHAR (50) NOT NULL,
    [Stations_Nummer] VARCHAR (50) NOT NULL,
    [Stations_Navn]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_DI_Depot] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [UK_DI_Depot] UNIQUE NONCLUSTERED ([Depot] ASC)
);

