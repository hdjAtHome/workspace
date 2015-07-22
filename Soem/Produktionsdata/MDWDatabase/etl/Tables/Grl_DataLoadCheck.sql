CREATE TABLE [etl].[Grl_DataLoadCheck] (
    [Id]                INT             IDENTITY (1, 1) NOT NULL,
    [Source_System]     VARCHAR (50)    NOT NULL,
    [Source_Gruppe]     VARCHAR (50)    NOT NULL,
    [Beskrivelse]       VARCHAR (256)   NOT NULL,
    [Tilladt_Afvigelse] DECIMAL (24, 6) NOT NULL,
    [Aktiv]             VARCHAR (3)     NOT NULL,
    CONSTRAINT [PK_Grl_DataLoadCheck_Hoved] PRIMARY KEY CLUSTERED ([Id] ASC)
);

