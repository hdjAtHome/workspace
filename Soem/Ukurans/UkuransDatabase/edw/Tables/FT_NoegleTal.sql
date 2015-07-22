CREATE TABLE [edw].[FT_NoegleTal] (
    [Rap_Dim]       VARCHAR (10)    NOT NULL,
    [Dim_Tid]       VARCHAR (8)     NOT NULL,
    [Dim_Vaerdi]    VARCHAR (10)    NULL,
    [AnskVaerdi]    DECIMAL (18, 3) NULL,
    [LogNedBrutto]  DECIMAL (18, 3) NULL,
    [NedskrNetto]   DECIMAL (18, 3) NULL,
    [LogNedPct]     DECIMAL (7, 5)  NULL,
    [NetNedPct]     DECIMAL (7, 5)  NULL,
    [Gns_DUF]       DECIMAL (7, 5)  NULL,
    [Gns_RID]       DECIMAL (7, 5)  NULL,
    [PctAfBrNedskr] DECIMAL (7, 5)  NULL,
    [PctAfNtNedskr] DECIMAL (7, 5)  NULL,
    [Vaerdi_HOmsH]  DECIMAL (18, 3) NULL,
    [Pct_HOmsH]     DECIMAL (7, 5)  NULL,
    [FraTil_tid]    VARCHAR (13)    NOT NULL
);

