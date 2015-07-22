CREATE TABLE [dbo].[CD_Datavalidering] (
    [IndlæstTidspunkt] DATETIME       CONSTRAINT [DF_CD_Datavalidering_IndlæstTidspunkt] DEFAULT (getdate()) NOT NULL,
    [Model]            CHAR (1)       NOT NULL,
    [Objekt_Type]      VARCHAR (50)   NOT NULL,
    [Objekt_Nøgle]     VARCHAR (50)   NOT NULL,
    [Objekt_Detaljer]  VARCHAR (1000) NOT NULL,
    [Beskrivelses_Id]  VARCHAR (2)    NOT NULL,
    [Valideringstyeo]  VARCHAR (15)   NULL,
    CONSTRAINT [FK_CD_Datavalidering_CD_Data_Validering_Beskrivelse] FOREIGN KEY ([Beskrivelses_Id]) REFERENCES [dbo].[CD_Data_Validering_Beskrivelse] ([Beskrivelses_Id])
);

