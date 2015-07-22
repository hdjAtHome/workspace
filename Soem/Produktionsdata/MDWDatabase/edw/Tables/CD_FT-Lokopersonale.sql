CREATE TABLE [edw].[CD_FT-Lokopersonale] (
    [DI_Omksted]      INT          NOT NULL,
    [MedarbejdeId]    VARCHAR (50) NULL,
    [Medarbejde_PKID] INT          NULL,
    [DI_Turdepot]     VARCHAR (5)  NOT NULL,
    [DI_Elementkode]  VARCHAR (10) NOT NULL,
    [DI_Togsystem]    INT          NOT NULL,
    [Togsystem]       VARCHAR (50) NULL,
    [DI_Lokation]     VARCHAR (10) NOT NULL,
    [DI_Litra]        VARCHAR (12) NOT NULL,
    [Tognummer]       VARCHAR (6)  NULL,
    [Turtimer]        FLOAT (53)   NULL,
    [Turdag]          VARCHAR (15) NULL,
    [Praktik]         VARCHAR (3)  NULL,
    [Antaltur]        INT          NULL,
    [Turnummer]       VARCHAR (15) NULL,
    [DI_Tid_Maaned]   VARCHAR (6)  NOT NULL
);

