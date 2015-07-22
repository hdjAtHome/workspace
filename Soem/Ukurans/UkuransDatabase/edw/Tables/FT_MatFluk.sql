CREATE TABLE [edw].[FT_MatFluk] (
    [Dim_Materiale]       INT             NULL,
    [Materiale]           VARCHAR (18)    NULL,
    [Beholdning]          DECIMAL (38, 3) NULL,
    [GlidGnsPris]         DECIMAL (38, 6) NULL,
    [Vaerdi_GP]           DECIMAL (38, 3) NULL,
    [StatGr2]             VARCHAR (4)     NOT NULL,
    [DUF]                 INT             NULL,
    [StatusDUF_NedskrAar] INT             NULL,
    [StatusNedskrPct]     DECIMAL (38, 6) NULL,
    [Nuv_StatusGr2]       VARCHAR (15)    NULL,
    [Nuv_LNType]          VARCHAR (4)     NOT NULL,
    [FraTil_Tid]          VARCHAR (8000)  NULL
);

