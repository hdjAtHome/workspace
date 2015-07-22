CREATE TABLE [edw].[DI_Profitcenter] (
    [PK_ID]                   INT          IDENTITY (-1, 1) NOT NULL,
    [Profitcenter]            VARCHAR (15) NOT NULL,
    [ProfitcenterNavn]        VARCHAR (50) NULL,
    [ProfitcenterParent_FH]   VARCHAR (50) NULL,
    [ProfitcenterAnsvarlig]   VARCHAR (50) NULL,
    [ProfitcenterBeskrivelse] VARCHAR (50) NULL,
    [Enhed]                   VARCHAR (50) NULL,
    [GyldigFradato]           DATETIME     NULL,
    [GyldigTildato]           DATETIME     NULL,
    [Aktiv]                   VARCHAR (50) NULL,
    [Timestamp]               DATETIME     NULL,
    CONSTRAINT [PK_DI_Profitcenter] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

