CREATE TABLE [edw].[DI_Fravaerkode] (
    [Kode]            VARCHAR (10) NOT NULL,
    [PDSKode]         VARCHAR (10) NULL,
    [Navn]            VARCHAR (50) NULL,
    [PDSNavn]         VARCHAR (50) NULL,
    [Tid]             CHAR (1)     NULL,
    [Gruppe]          VARCHAR (10) NULL,
    [GruppeNavn]      VARCHAR (50) NULL,
    [Type]            VARCHAR (10) NULL,
    [TypeNavn]        VARCHAR (50) NULL,
    [PDSRegistrering] VARCHAR (3)  NULL,
    [Timestamp]       DATETIME     NULL,
    CONSTRAINT [PK_DI_Fravaerkode] PRIMARY KEY CLUSTERED ([Kode] ASC)
);

