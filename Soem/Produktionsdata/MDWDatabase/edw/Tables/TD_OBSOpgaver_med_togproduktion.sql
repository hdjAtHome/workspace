CREATE TABLE [edw].[TD_OBSOpgaver_med_togproduktion] (
    [DI_Medarbejde_OBS]    INT          NOT NULL,
    [DI_Opgave]            INT          NOT NULL,
    [DI_TjenesteDepot]     VARCHAR (5)  NOT NULL,
    [DI_Lokation]          VARCHAR (10) NOT NULL,
    [DI_Togsystem]         INT          NOT NULL,
    [DI_Tid]               VARCHAR (50) NOT NULL,
    [Varighed_tim]         FLOAT (53)   NULL,
    [Tognummer]            INT          NOT NULL,
    [Tog_km_pct]           FLOAT (53)   NULL,
    [Varighed_orig]        FLOAT (53)   NULL,
    [DI_Station_fra]       INT          NULL,
    [DI_Station_til]       INT          NULL,
    [PDS_Varighed_fordelt] FLOAT (53)   NULL,
    [Fra_tidspunkt]        DATETIME     NULL,
    [Til_tidspunkt]        DATETIME     NULL,
    [PDS_Start_tidspunkt]  DATETIME     NULL
);

