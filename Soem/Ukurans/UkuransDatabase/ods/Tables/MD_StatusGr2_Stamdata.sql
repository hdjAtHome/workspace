CREATE TABLE [ods].[MD_StatusGr2_Stamdata] (
    [StatusGr2]         VARCHAR (20)   NOT NULL,
    [StatusGr2Tekst]    VARCHAR (100)  NOT NULL,
    [StatusGrNedskrPct] DECIMAL (5, 3) NULL,
    [DUF_NedskrAar]     INT            NULL,
    [RID_NedskrFaktor]  DECIMAL (7, 5) NULL,
    [RID_NedskrTekst]   VARCHAR (50)   NULL,
    [FixedNedskrFra]    DATETIME       NULL,
    [FixedNedskrTil]    DATETIME       NULL,
    [FixedNedskrErMax]  VARCHAR (5)    NULL,
    [StatusGr1]         VARCHAR (20)   NULL,
    CONSTRAINT [PK_StatusGr_Stamdata] PRIMARY KEY CLUSTERED ([StatusGr2] ASC) WITH (FILLFACTOR = 90)
);

