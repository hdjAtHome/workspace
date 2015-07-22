CREATE TABLE [edw].[DI_Flag] (
    [Aktiv]       BIT         NOT NULL,
    [Aktiv_Tekst] VARCHAR (3) NOT NULL,
    CONSTRAINT [PK_DI_Flag] PRIMARY KEY CLUSTERED ([Aktiv] ASC)
);

