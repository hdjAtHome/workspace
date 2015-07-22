CREATE TABLE [edw].[FT_Forklaring_Arkiv_Gemte] (
    [Dim_Aendring]         VARCHAR (20)    NOT NULL,
    [Dim_Fabrik]           VARCHAR (10)    NULL,
    [Materiale]            VARCHAR (18)    NULL,
    [Dim_Materiale]        INT             NULL,
    [LNType]               VARCHAR (4)     NULL,
    [FLNType]              VARCHAR (4)     NULL,
    [FraTil_tid]           VARCHAR (13)    NOT NULL,
    [AnskVaerdi]           DECIMAL (18, 3) NULL,
    [NedForPrinc]          DECIMAL (18, 3) NULL,
    [DSystAnedr]           DECIMAL (18, 3) NULL,
    [NedskrNetto]          DECIMAL (18, 3) NULL,
    [Beholdning]           DECIMAL (18, 3) NULL,
    [Vaerdi_SP]            DECIMAL (18, 3) NULL,
    [Forskel]              DECIMAL (18, 3) NULL,
    [Flg_Uroerte]          TINYINT         NULL,
    [Flg_NytMat36md]       TINYINT         NULL,
    [Flg_Indk12md]         TINYINT         NULL,
    [Dim_Fabrik_Materiale] INT             NOT NULL
);

