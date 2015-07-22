CREATE TABLE [edw].[DI_Tjenestested] (
    [PK_ID]            INT          IDENTITY (-1, 1) NOT NULL,
    [Tjenestested]     VARCHAR (15) NOT NULL,
    [TjenestestedNavn] VARCHAR (50) NULL,
    [Niveau4]          VARCHAR (15) NULL,
    [Niveau4Navn]      VARCHAR (50) NULL,
    [Niveau3]          VARCHAR (15) NULL,
    [Niveau3Navn]      VARCHAR (50) NULL,
    [Niveau2]          VARCHAR (15) NULL,
    [Niveau2Navn]      VARCHAR (50) NULL,
    [GyldigFradato]    DATETIME     NULL,
    [GyldigTildato]    DATETIME     NULL,
    [Aktiv]            VARCHAR (50) NULL,
    [Timestamp]        DATETIME     NULL,
    CONSTRAINT [PK_DI_Tjenestested] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

