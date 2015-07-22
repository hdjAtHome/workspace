CREATE TABLE [edw].[TD08_MatStatusEj2010L] (
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
    [Status]         VARCHAR (1)  NOT NULL
);

