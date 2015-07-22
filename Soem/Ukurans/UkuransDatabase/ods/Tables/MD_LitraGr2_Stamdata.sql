CREATE TABLE [ods].[MD_LitraGr2_Stamdata] (
    [LitraGr1]         VARCHAR (15)     NOT NULL,
    [LitraGr2]         VARCHAR (15)     NOT NULL,
    [LitraGr2Tekst]    VARCHAR (100)    NOT NULL,
    [LitraNedskrPct]   DECIMAL (5, 3)   NULL,
    [DUF_NedskrAar]    INT              NOT NULL,
    [RID_NedskrFaktor] DECIMAL (15, 15) NULL,
    [RID_NedskrTekst]  VARCHAR (50)     NOT NULL,
    [FixedNedskrFra]   DATETIME         NULL,
    [FixedNedskrTil]   DATETIME         NULL,
    [FixedNedskrErMax] VARCHAR (5)      NULL,
    CONSTRAINT [PK_Litragr2_Stamdata] PRIMARY KEY CLUSTERED ([LitraGr2] ASC) WITH (FILLFACTOR = 90)
);

