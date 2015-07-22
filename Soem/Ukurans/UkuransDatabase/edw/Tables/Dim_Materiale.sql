CREATE TABLE [edw].[Dim_Materiale] (
    [PK_ID]          INT          IDENTITY (-1, 1) NOT NULL,
    [Materiale]      VARCHAR (18) NOT NULL,
    [MaterialeTekst] VARCHAR (50) NULL,
    [LitraGr2]       VARCHAR (15) NOT NULL,
    [StatusGr2]      VARCHAR (20) NOT NULL,
    [Aktiv]          CHAR (1)     NOT NULL,
    [GyldigFra]      DATETIME     NOT NULL,
    [GyldigTil]      DATETIME     NOT NULL,
    [FRegAar]        VARCHAR (20) NOT NULL,
    [FTrAar]         VARCHAR (20) NULL,
    [FRegDato]       DATETIME     NULL,
    [FTrDato]        DATETIME     NULL,
    [Oprettet]       DATETIME     NULL,
    [MatArt]         VARCHAR (20) NULL,
    [VareGrp]        VARCHAR (20) NULL,
    [FBevArt]        VARCHAR (20) NULL,
    [OmlVare]        CHAR (1)     NULL,
    [Litra_PKID]     INT          NOT NULL,
    [Timestamp]      DATETIME     NULL,
    CONSTRAINT [PK_Dim_Materiale] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

