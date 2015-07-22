CREATE TABLE [edw].[TD11_MatStatus_Ej_FLUK] (
    [Materiale]      VARCHAR (18) NOT NULL,
    [MaterialeTekst] VARCHAR (50) NULL,
    [FRegAar]        VARCHAR (20) NOT NULL,
    [FTrAar]         VARCHAR (20) NULL,
    [LitraGr2]       VARCHAR (15) NOT NULL,
    [StatusGr2]      VARCHAR (3)  NOT NULL,
    [GyldigFra]      DATETIME     NULL,
    [GyldigTil]      DATETIME     NOT NULL,
    [FRegDato]       DATETIME     NULL,
    [FTrDato]        DATETIME     NULL,
    [FBevArt]        VARCHAR (20) NULL,
    [OmlVare]        CHAR (1)     NULL,
    [Litra_PKID]     INT          NOT NULL,
    [Timestamp]      DATETIME     NOT NULL,
    [Status]         VARCHAR (1)  NOT NULL
);

