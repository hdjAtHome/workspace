CREATE TABLE [edw].[TD40_MatBehNedskrSfaFLUK] (
    [Materiale]           VARCHAR (18)     NULL,
    [Beholdning]          DECIMAL (38, 3)  NULL,
    [GlidGnsPris]         DECIMAL (38, 6)  NULL,
    [Vaerdi_GP]           DECIMAL (38, 3)  NULL,
    [StatGr2]             VARCHAR (4)      NOT NULL,
    [DUF]                 INT              NULL,
    [StatusDUF_NedskrAar] INT              NULL,
    [StatusNedskrPct]     DECIMAL (38, 15) NULL,
    [Nuv_StatusGr2]       VARCHAR (18)     NULL,
    [Nuv_LNType]          VARCHAR (18)     NULL
);

