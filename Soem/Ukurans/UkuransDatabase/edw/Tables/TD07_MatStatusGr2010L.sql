CREATE TABLE [edw].[TD07_MatStatusGr2010L] (
    [Materiale]      VARCHAR (18)    NULL,
    [MaterialeTekst] VARCHAR (50)    NULL,
    [FRegAar]        VARCHAR (20)    NULL,
    [FTrAar]         VARCHAR (20)    NULL,
    [LitraGr2]       VARCHAR (15)    NULL,
    [StatusGr2]      VARCHAR (5)     NOT NULL,
    [GyldigFra]      DATETIME        NULL,
    [GyldigTil]      DATETIME        NULL,
    [FRegDato]       DATETIME        NULL,
    [FTrDato]        DATETIME        NULL,
    [FBevArt]        VARCHAR (20)    NULL,
    [Status]         VARCHAR (6)     NOT NULL,
    [BehIalt]        DECIMAL (38, 3) NULL,
    [VaerdiIalt]     DECIMAL (38, 3) NULL,
    [MinDUF]         INT             NULL,
    [SAP_MinDUF]     SMALLINT        NULL,
    [FTr_MinDUF]     INT             NULL,
    [Hist_MinDUF]    INT             NULL
);

