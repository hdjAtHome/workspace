CREATE TABLE [edw].[MDH_Litragr2_Stamdata] (
    [Litragr2]       VARCHAR (50)   NOT NULL,
    [Litragr2Tekst]  VARCHAR (100)  NOT NULL,
    [LitraNedskrPct] DECIMAL (5, 3) NULL,
    [Tidshorisont]   INT            NOT NULL,
    [FixedNedskrFra] DATETIME       NULL,
    [FixedNedskrTil] DATETIME       NULL,
    [GyldigFra]      DATETIME       NOT NULL,
    [GyldigTil]      DATETIME       NULL,
    [Litragr1]       VARCHAR (20)   NULL,
    CONSTRAINT [PK_Litragr2_Historiske_Stamdata] PRIMARY KEY CLUSTERED ([Litragr2] ASC, [GyldigFra] ASC) WITH (FILLFACTOR = 90)
);

