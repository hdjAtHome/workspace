CREATE TABLE [edw].[DI_Arbejdskode] (
    [Kode]        VARCHAR (15)  NOT NULL,
    [Navn]        VARCHAR (50)  NULL,
    [Beskrivelse] VARCHAR (100) NULL,
    [Timestamp]   DATETIME      NULL,
    CONSTRAINT [PK_DI_Arbejdskode] PRIMARY KEY CLUSTERED ([Kode] ASC)
);

