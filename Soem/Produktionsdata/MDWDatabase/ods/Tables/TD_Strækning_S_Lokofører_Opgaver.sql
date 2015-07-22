CREATE TABLE [ods].[TD_Strækning_S_Lokofører_Opgaver] (
    [DI_Tid]                 VARCHAR (20) NULL,
    [DI_S_Straekning]        INT          NULL,
    [DI_Tidsintervaller]     INT          NULL,
    [DSB_Brugerid]           VARCHAR (50) NULL,
    [DI_S_turdepot]          VARCHAR (30) NULL,
    [ElementCode]            VARCHAR (30) NULL,
    [Opgave_tidspunkt_start] DATETIME     NULL,
    [Opgave_tidspunkt_slut]  DATETIME     NULL,
    [Opgave_Station_start]   VARCHAR (30) NULL,
    [Opgave_Station_Slut]    VARCHAR (30) NULL,
    [Opgave_varighed]        NUMERIC (10) NULL,
    [Stræknings_varighed]    INT          NULL,
    [Strækning_Frastation]   VARCHAR (10) NULL,
    [Strækning_Tilstation]   VARCHAR (10) NULL,
    [Strækning_Afgang]       DATETIME     NULL,
    [Strækning_Ankomst]      DATETIME     NULL,
    [Tognr]                  INT          NULL,
    [PDS_Strækningsvarighed] FLOAT (53)   NULL,
    [Aflyst]                 VARCHAR (20) NULL,
    [DI_S_Doegn_Inddeling]   INT          NULL
);

