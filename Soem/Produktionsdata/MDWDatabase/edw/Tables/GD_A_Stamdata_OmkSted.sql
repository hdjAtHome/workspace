CREATE TABLE [edw].[GD_A_Stamdata_OmkSted] (
    [OmkSted]            VARCHAR (50) NOT NULL,
    [OmkStedNavn]        VARCHAR (50) NULL,
    [OmkStedAnsvarlig]   VARCHAR (50) NULL,
    [OmkStedBeskrivelse] VARCHAR (50) NULL,
    [StandardHierarki]   VARCHAR (50) NULL,
    [Profitcenter]       VARCHAR (50) NULL,
    [GyldigFradato]      DATETIME     NULL,
    [GyldigTildato]      DATETIME     NULL,
    [Aktiv]              VARCHAR (50) NULL,
    [Timestamp]          DATETIME     NULL
);

