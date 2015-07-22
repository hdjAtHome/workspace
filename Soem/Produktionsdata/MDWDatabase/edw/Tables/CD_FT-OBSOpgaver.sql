CREATE TABLE [edw].[CD_FT-OBSOpgaver] (
    [DI_Medarbejde_OBS] INT          NOT NULL,
    [MedarbejdeId]      VARCHAR (50) NULL,
    [DI_Opgave]         INT          NOT NULL,
    [Opgave]            VARCHAR (50) NULL,
    [DI_TjenesteDepot]  VARCHAR (50) NOT NULL,
    [Depot]             VARCHAR (50) NULL,
    [DI_Lokation]       VARCHAR (10) NOT NULL,
    [Lokation]          VARCHAR (10) NULL,
    [DI_Togsystem]      INT          NOT NULL,
    [Togsystem]         VARCHAR (50) NULL,
    [DI_Tid]            VARCHAR (50) NOT NULL,
    [Varighed_tim]      FLOAT (53)   NULL,
    [Tognummer]         INT          NOT NULL,
    [DI_Station_fra]    VARCHAR (50) NULL,
    [DI_Station_til]    VARCHAR (50) NULL
);

