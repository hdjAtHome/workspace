CREATE TABLE [edw].[Dim_StatusHierarki] (
    [StatusGr1]         VARCHAR (20)     NOT NULL,
    [StatusGr2]         VARCHAR (50)     NOT NULL,
    [StatusGr2Tekst]    VARCHAR (100)    NOT NULL,
    [StatusGrNedskrPct] DECIMAL (5, 2)   NULL,
    [DUF_NedskrAar]     INT              NULL,
    [RID_NedskrFaktor]  DECIMAL (16, 15) NULL,
    [RID_NedskrTekst]   VARCHAR (50)     NULL,
    [FixedNedskrFra]    DATETIME         NULL,
    [FixedNedskrTil]    DATETIME         NULL,
    [FixedNedskrErMax]  VARCHAR (5)      NULL,
    [GyldigFra]         DATETIME         NOT NULL,
    [GyldigTil]         DATETIME         NOT NULL,
    CONSTRAINT [PK_StatusGrHierarki] PRIMARY KEY CLUSTERED ([StatusGr1] ASC, [StatusGr2] ASC, [GyldigFra] ASC) WITH (FILLFACTOR = 90)
);

