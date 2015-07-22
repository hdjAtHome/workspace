CREATE TABLE [edw].[DI_Profitcenter_ny] (
    [PK_ID]                   INT          NOT NULL,
    [Profitcenter]            VARCHAR (15) NOT NULL,
    [ProfitcenterNavn]        VARCHAR (50) NULL,
    [ProfitcenterParent_FH]   VARCHAR (50) NULL,
    [ProfitcenterAnsvarlig]   VARCHAR (50) NULL,
    [ProfitcenterBeskrivelse] VARCHAR (50) NULL,
    [Enhed]                   VARCHAR (50) NULL,
    [GyldigFradato]           DATETIME     NULL,
    [GyldigTildato]           DATETIME     NULL,
    [Aktiv]                   VARCHAR (50) NULL,
    [Timestamp]               DATETIME     NULL
);

