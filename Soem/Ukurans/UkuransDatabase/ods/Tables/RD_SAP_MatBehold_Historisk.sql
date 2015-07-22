CREATE TABLE [ods].[RD_SAP_MatBehold_Historisk] (
    [Dim_Tid]        VARCHAR (6)     NOT NULL,
    [Slettemark]     CHAR (1)        NULL,
    [Fabrik]         VARCHAR (10)    NULL,
    [Materiale]      VARCHAR (18)    NULL,
    [MaterialeTekst] VARCHAR (50)    NULL,
    [OmlVare]        CHAR (1)        NULL,
    [BME]            VARCHAR (10)    NULL,
    [MatArt]         VARCHAR (10)    NULL,
    [Beholdning]     DECIMAL (18, 3) NULL,
    [PrisEnh]        INT             NULL,
    [GlGPris]        DECIMAL (18, 3) NULL,
    [Vaerdi_GP]      DECIMAL (18, 3) NULL,
    [StandPris]      DECIMAL (18, 3) NULL,
    [Vaerdi_SP]      DECIMAL (18, 3) NULL,
    [FremtPris]      DECIMAL (18, 3) NULL,
    [GyldigFra]      DATETIME        NULL,
    [SenAendring]    DATETIME        NULL,
    [ForegPris]      DECIMAL (18, 3) NULL
);

