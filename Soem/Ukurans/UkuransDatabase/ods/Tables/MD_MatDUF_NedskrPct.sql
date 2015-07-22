CREATE TABLE [ods].[MD_MatDUF_NedskrPct] (
    [DUF]           INT            NOT NULL,
    [Tidshorisont3] DECIMAL (8, 7) NULL,
    [Tidshorisont5] DECIMAL (8, 7) NULL,
    [Tidshorisont7] DECIMAL (8, 7) NULL,
    [DUF-antal_aar] DECIMAL (8, 7) NULL,
    CONSTRAINT [PK_DUF] PRIMARY KEY CLUSTERED ([DUF] ASC) WITH (FILLFACTOR = 90)
);

