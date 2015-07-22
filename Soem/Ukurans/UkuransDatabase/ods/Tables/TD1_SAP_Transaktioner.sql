CREATE TABLE [ods].[TD1_SAP_Transaktioner] (
    [Fabrik]        VARCHAR (10)    NULL,
    [Materiale]     VARCHAR (18)    NULL,
    [OmkArt]        VARCHAR (10)    NULL,
    [BevArt]        VARCHAR (3)     NULL,
    [Maengde]       DECIMAL (18, 3) NULL,
    [Vaerdi_SP]     DECIMAL (18, 3) NULL,
    [RefBilagNr]    VARCHAR (12)    NULL,
    [IndkBilag]     VARCHAR (12)    NULL,
    [BogDato]       DATETIME        NULL,
    [Periode]       VARCHAR (2)     NULL,
    [Aar]           VARCHAR (4)     NULL,
    [RegistrDato]   DATETIME        NULL,
    [RegistrDatoKl] VARCHAR (10)    NULL,
    [Brugernavn]    VARCHAR (12)    NULL,
    [BilagNr]       VARCHAR (9)     NULL,
    [Profitcenter]  VARCHAR (10)    NULL,
    [Partner]       VARCHAR (8)     NULL,
    [xx]            VARCHAR (2)     NULL
);

