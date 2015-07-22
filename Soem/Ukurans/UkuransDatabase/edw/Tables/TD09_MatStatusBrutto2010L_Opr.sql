CREATE TABLE [edw].[TD09_MatStatusBrutto2010L_Opr] (
    [Materiale]      VARCHAR (18) NOT NULL,
    [MaterialeTekst] VARCHAR (50) NULL,
    [FRegAar]        VARCHAR (20) NULL,
    [FTrAar]         VARCHAR (20) NULL,
    [LitraGr2]       VARCHAR (15) NOT NULL,
    [StatusGr2]      VARCHAR (20) NOT NULL,
    [GyldigFra]      DATETIME     NOT NULL,
    [GyldigTil]      DATETIME     NULL,
    [FRegDato]       DATETIME     NULL,
    [FTrDato]        DATETIME     NULL,
    [FBevArt]        VARCHAR (10) NULL
);

