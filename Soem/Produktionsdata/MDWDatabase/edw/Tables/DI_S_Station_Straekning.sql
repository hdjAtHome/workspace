CREATE TABLE [edw].[DI_S_Station_Straekning] (
    [PK_ID]                           INT             IDENTITY (1, 1) NOT NULL,
    [Straekning]                      VARCHAR (10)    NOT NULL,
    [Frastation]                      VARCHAR (10)    NOT NULL,
    [Frastation_navn]                 VARCHAR (50)    NOT NULL,
    [Tilstation]                      VARCHAR (10)    NOT NULL,
    [TilStation_navn]                 VARCHAR (50)    NOT NULL,
    [Retningsbestemt_straekning]      VARCHAR (50)    NOT NULL,
    [Ikke_retningsbestemt_straekning] VARCHAR (50)    NOT NULL,
    [Distance_km]                     NUMERIC (24, 6) NOT NULL,
    CONSTRAINT [PK_DI_S_Station_Straekning] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [UK_DI_S_Station_Straekning_Strk] UNIQUE NONCLUSTERED ([Straekning] ASC)
);

