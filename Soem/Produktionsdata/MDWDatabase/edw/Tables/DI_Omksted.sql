CREATE TABLE [edw].[DI_Omksted] (
    [PK_ID]                INT          IDENTITY (-1, 1) NOT NULL,
    [OmkSted]              VARCHAR (15) NOT NULL,
    [OmkStedNavn]          VARCHAR (50) NULL,
    [OmkStedAnsvarlig]     VARCHAR (50) NULL,
    [OmkStedBeskrivelse]   VARCHAR (50) NULL,
    [Profitcenter]         VARCHAR (15) NULL,
    [FK_Profitcenter_PKID] INT          NOT NULL,
    [GyldigFradato]        DATETIME     NULL,
    [GyldigTildato]        DATETIME     NULL,
    [Aktiv]                VARCHAR (10) NULL,
    [Timestamp]            DATETIME     NULL,
    CONSTRAINT [PK_DI_Omksted] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [FK_DI_Omksted_DI_Profitcenter] FOREIGN KEY ([FK_Profitcenter_PKID]) REFERENCES [edw].[DI_Profitcenter] ([PK_ID])
);

