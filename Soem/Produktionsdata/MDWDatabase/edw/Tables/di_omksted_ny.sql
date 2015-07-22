CREATE TABLE [edw].[di_omksted_ny] (
    [PK_ID]                INT          NOT NULL,
    [OmkSted]              VARCHAR (15) NOT NULL,
    [OmkStedNavn]          VARCHAR (50) NULL,
    [OmkStedAnsvarlig]     VARCHAR (50) NULL,
    [OmkStedBeskrivelse]   VARCHAR (50) NULL,
    [Profitcenter]         VARCHAR (15) NULL,
    [FK_Profitcenter_PKID] INT          NOT NULL,
    [GyldigFradato]        DATETIME     NULL,
    [GyldigTildato]        DATETIME     NULL,
    [Aktiv]                VARCHAR (10) NULL,
    [Timestamp]            DATETIME     NULL
);

