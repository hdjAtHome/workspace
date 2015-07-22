CREATE TABLE [edw].[FT_Transaktioner] (
    [Dim_Fabrik]    VARCHAR (10)    NULL,
    [Materiale]     VARCHAR (18)    NULL,
    [Dim_Materiale] INT             NULL,
    [OmkArt]        VARCHAR (10)    NULL,
    [Dim_BevArt]    VARCHAR (5)     NULL,
    [Maengde]       DECIMAL (18, 3) NULL,
    [Vaerdi_SP]     DECIMAL (18, 3) NULL,
    [RefBilagNr]    VARCHAR (12)    NULL,
    [IndkBilag]     VARCHAR (12)    NULL,
    [BogfDato]      DATETIME        NULL,
    [Dim_Tid]       VARCHAR (8)     NULL,
    [RegistrDato]   DATETIME        NULL,
    [RegistrDatoKl] VARCHAR (10)    NULL,
    [Brugernavn]    VARCHAR (12)    NULL,
    [BilagNr]       VARCHAR (9)     NULL,
    [Profitcenter]  VARCHAR (10)    NULL,
    [Partner]       VARCHAR (10)    NULL,
    CONSTRAINT [FK_FT_Transaktioner_Dim_BevArt] FOREIGN KEY ([Dim_BevArt]) REFERENCES [edw].[Dim_BevArt] ([BevArt]),
    CONSTRAINT [FK_FT_Transaktioner_Dim_Fabrik] FOREIGN KEY ([Dim_Fabrik]) REFERENCES [edw].[Dim_Fabrik] ([Fabrik])
);

