CREATE TABLE [dbo].[MD_G_KORR_ØKONOMI_Anlæg_efterposter] (
    [HovednrUnr]            VARCHAR (50) NULL,
    [Firmakode]             VARCHAR (50) NULL,
    [Profitcenter]          VARCHAR (50) NULL,
    [BetegnelseAnlaegAktiv] VARCHAR (50) NULL,
    [ProfitcenterNavn]      VARCHAR (50) NULL,
    [BalKonto]              VARCHAR (50) NULL,
    [AnlKlasse]             VARCHAR (50) NULL,
    [OmkStedPrimo]          VARCHAR (50) NULL,
    [OmkStedNavnPrimo]      VARCHAR (50) NULL,
    [OmkStedUltimo]         VARCHAR (50) NULL,
    [OmkStedNavnUltimo]     VARCHAR (50) NULL,
    [Delområde]             VARCHAR (50) NULL,
    [Beskrivelse]           VARCHAR (50) NULL,
    [Afskrivning]           FLOAT (53)   NULL,
    [Forrentning]           FLOAT (53)   NULL,
    [indlæstTidspunkt]      DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]             [sysname]    DEFAULT (suser_sname()) NULL,
    [Periode]               VARCHAR (50) NULL,
    [KildeArk]              VARCHAR (50) NULL
);

