CREATE TABLE [edw].[FT_Nedskriv_Prg] (
    [Dim_Fabrik]       VARCHAR (10)    NULL,
    [Dim_Materiale]    INT             NULL,
    [Materiale]        VARCHAR (18)    NULL,
    [Dim_Tid]          VARCHAR (8)     NOT NULL,
    [FraTil_Tid]       VARCHAR (13)    NOT NULL,
    [Beholdning]       DECIMAL (18, 3) NULL,
    [Vaerdi_GP]        DECIMAL (18, 3) NULL,
    [GlidGnsPris]      DECIMAL (18, 3) NULL,
    [Vaerdi_SP]        DECIMAL (18, 3) NULL,
    [DUF_DagtilProg]   INT             NULL,
    [ProgNedskrPct]    DECIMAL (7, 5)  NULL,
    [ProgNedskrVaerdi] DECIMAL (18, 3) NULL,
    [LogNedBrutto]     DECIMAL (18, 3) NULL,
    [StatProgNedReelt] DECIMAL (18, 3) NULL
);

