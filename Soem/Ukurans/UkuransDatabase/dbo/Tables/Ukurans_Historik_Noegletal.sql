CREATE TABLE [dbo].[Ukurans_Historik_Noegletal] (
    [Gruppe]           VARCHAR (8)     NOT NULL,
    [Tekst]            VARCHAR (14)    NOT NULL,
    [LNType]           VARCHAR (4)     NOT NULL,
    [Antal]            INT             NULL,
    [Beholdning]       NUMERIC (38, 2) NULL,
    [LogNedBrutto]     NUMERIC (38, 2) NULL,
    [LgIndkNedskrKorr] NUMERIC (38, 2) NULL,
    [NytNedskrKorr]    NUMERIC (38, 2) NULL,
    [NedskrivNetto]    NUMERIC (38, 2) NULL,
    [AnskVaerdi]       NUMERIC (38, 2) NULL,
    [GnsRID]           NUMERIC (38, 6) NULL,
    [GnsDUF]           NUMERIC (38, 6) NULL,
    [Beregning]        NVARCHAR (10)   NULL
);

