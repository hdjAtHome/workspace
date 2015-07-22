CREATE TABLE [edw].[DI_Elementkode_ltf] (
    [Elementkode] VARCHAR (10) NOT NULL,
    [Navn]        VARCHAR (50) NULL,
    [Gruppe]      VARCHAR (10) NULL,
    [GruppeNavn]  VARCHAR (50) NULL,
    [Type]        VARCHAR (10) NULL,
    [TypeNavn]    VARCHAR (50) NULL,
    [Timestamp]   DATETIME     NULL,
    CONSTRAINT [PK_DI_Elementkode_ltf] PRIMARY KEY CLUSTERED ([Elementkode] ASC)
);

