CREATE TABLE [edw].[DI_S_Opgave_Lokofører] (
    [PK_ID]            INT          IDENTITY (1, 1) NOT NULL,
    [Elementkode]      VARCHAR (50) NOT NULL,
    [Elementkode_Navn] VARCHAR (50) NOT NULL,
    [Gruppe]           VARCHAR (50) NOT NULL,
    [Gruppe_Navn]      VARCHAR (50) NOT NULL,
    [Type]             VARCHAR (50) NOT NULL,
    [Type_Navn]        VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_DI_S_Opgave_Lokofører] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

