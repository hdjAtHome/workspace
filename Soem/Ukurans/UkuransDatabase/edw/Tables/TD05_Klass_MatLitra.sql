CREATE TABLE [edw].[TD05_Klass_MatLitra] (
    [Materiale]          VARCHAR (18) NOT NULL,
    [MaterialeTekst]     VARCHAR (50) NULL,
    [LitraGr2]           VARCHAR (15) NOT NULL,
    [StatusGr2]          VARCHAR (20) NOT NULL,
    [Aktiv]              CHAR (1)     NOT NULL,
    [Gyldigfra]          DATETIME     NOT NULL,
    [Gyldigtil]          DATETIME     NOT NULL,
    [FRegAar]            VARCHAR (20) NOT NULL,
    [FTrAar]             VARCHAR (20) NULL,
    [FRegDato]           DATETIME     NULL,
    [FTrDato]            DATETIME     NULL,
    [Oprettet]           DATETIME     NULL,
    [MatArt]             VARCHAR (20) NULL,
    [VareGrp]            VARCHAR (20) NULL,
    [FBevArt]            VARCHAR (20) NULL,
    [OmlVare]            CHAR (1)     NULL,
    [LitraGr2_PKID]      INT          NOT NULL,
    [Timestamp]          DATETIME     NULL,
    [Materiale_og_Tekst] VARCHAR (70) NULL,
    [Status]             VARCHAR (15) NULL
);

