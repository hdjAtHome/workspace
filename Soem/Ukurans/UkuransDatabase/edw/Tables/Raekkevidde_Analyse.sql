CREATE TABLE [edw].[Raekkevidde_Analyse] (
    [Dim_Tid]      VARCHAR (6)     NOT NULL,
    [RID_Niveau]   INT             NOT NULL,
    [Ansk_Vaerdi]  DECIMAL (38, 3) NULL,
    [LogNedBrutto] DECIMAL (38, 3) NULL,
    [NedskrNetto]  DECIMAL (38, 3) NULL,
    [AvgDUF]       NUMERIC (38, 6) NULL,
    [AvgRID]       NUMERIC (38, 6) NULL
);

