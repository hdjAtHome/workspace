CREATE TABLE [edw].[TD10_MatStatusGrFLUK] (
    [Materiale]      VARCHAR (18) NULL,
    [MaterialeTekst] VARCHAR (50) NULL,
    [LitraGr2]       VARCHAR (15) NULL,
    [StatusGr2]      VARCHAR (4)  NOT NULL,
    [Nuv_StatusGr2]  VARCHAR (18) NULL,
    [Nuv_LNType]     VARCHAR (18) NULL,
    [Aktiv]          VARCHAR (1)  NOT NULL,
    [GyldigFra]      DATETIME     NULL,
    [GyldigTil]      DATETIME     NULL,
    [FRegAar]        VARCHAR (20) NULL,
    [FTrAar]         VARCHAR (20) NULL,
    [FRegDato]       DATETIME     NULL,
    [FTrDato]        DATETIME     NULL,
    [Oprettet]       DATETIME     NULL,
    [MatArt]         VARCHAR (20) NULL,
    [VareGrp]        VARCHAR (20) NULL,
    [FBevArt]        VARCHAR (20) NULL,
    [OmlVare]        CHAR (1)     NULL,
    [Litra_PKID]     INT          NULL,
    [Timestamp]      DATETIME     NOT NULL,
    [Status]         VARCHAR (6)  NOT NULL
);

