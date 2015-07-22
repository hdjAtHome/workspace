CREATE TABLE [dbo].[MD_G_KORR_ØKONOMI_Delområde] (
    [Beskrivelse]         VARCHAR (50) NULL,
    [Profitcenter]        VARCHAR (50) NULL,
    [ProfitcenterNavn]    VARCHAR (50) NULL,
    [Omkostningssted]     VARCHAR (50) NULL,
    [OmkostningsstedNavn] VARCHAR (50) NULL,
    [Omkostningsart]      VARCHAR (50) NULL,
    [OmkostningsartNavn]  VARCHAR (50) NULL,
    [PSP-element]         VARCHAR (50) NULL,
    [PSP-elementNavn]     VARCHAR (50) NULL,
    [Ordre]               VARCHAR (50) NULL,
    [OrdreNavn]           VARCHAR (50) NULL,
    [Litratype]           VARCHAR (50) NULL,
    [LitratypeNavn]       VARCHAR (50) NULL,
    [Stationsnr]          VARCHAR (50) NULL,
    [Stationstype]        VARCHAR (50) NULL,
    [Beløb]               FLOAT (53)   NULL,
    [Delområde]           VARCHAR (50) NULL,
    [indlæstTidspunkt]    DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]           [sysname]    DEFAULT (suser_sname()) NULL,
    [Periode]             VARCHAR (50) NULL,
    [KildeArk]            VARCHAR (50) NULL
);

