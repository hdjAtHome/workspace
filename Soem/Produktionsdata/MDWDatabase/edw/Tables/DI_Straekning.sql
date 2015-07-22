CREATE TABLE [edw].[DI_Straekning] (
    [PK_ID]                           INT           IDENTITY (1, 1) NOT NULL,
    [Straekningskode]                 VARCHAR (10)  NOT NULL,
    [Frastation]                      VARCHAR (50)  NOT NULL,
    [Frastation_Tekst]                VARCHAR (100) NOT NULL,
    [Tilstation]                      VARCHAR (50)  NOT NULL,
    [Tilstation_Tekst]                VARCHAR (100) NOT NULL,
    [Retningsbestemt_Straekning]      VARCHAR (100) NOT NULL,
    [Ikke_retningsbestemt_Straekning] VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_DI_Straekning] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [UK_DI_Straekning_Kode] UNIQUE NONCLUSTERED ([Straekningskode] ASC)
);

