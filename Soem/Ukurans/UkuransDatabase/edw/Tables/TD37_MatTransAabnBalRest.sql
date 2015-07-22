CREATE TABLE [edw].[TD37_MatTransAabnBalRest] (
    [Materiale]           VARCHAR (18)    NULL,
    [MaterialeTekst]      VARCHAR (50)    NULL,
    [Fabrik]              VARCHAR (10)    NULL,
    [BehIalt]             DECIMAL (38, 3) NULL,
    [NuvStkPris]          DECIMAL (38, 6) NULL,
    [AnskMgdIalt]         DECIMAL (38, 3) NULL,
    [RestAabnBalBeh]      DECIMAL (38, 3) NULL,
    [RestAabnBalVaerdi]   DECIMAL (38, 6) NULL,
    [AabnBalNedskrPct]    NUMERIC (2, 2)  NOT NULL,
    [AabnBalNedskrVaerdi] NUMERIC (38, 6) NULL
);

