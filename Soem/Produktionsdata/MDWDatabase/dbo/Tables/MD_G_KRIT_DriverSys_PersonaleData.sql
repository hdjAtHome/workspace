CREATE TABLE [dbo].[MD_G_KRIT_DriverSys_PersonaleData] (
    [DriverNavn]            VARCHAR (50) NULL,
    [Enhed]                 VARCHAR (50) NULL,
    [Navn]                  VARCHAR (50) NULL,
    [Profitcenter]          VARCHAR (50) NULL,
    [Omkostningssted]       VARCHAR (50) NULL,
    [RessourceKildeR1]      VARCHAR (50) NULL,
    [RessouceDestinationR2] VARCHAR (50) NULL,
    [ATT_ResType]           VARCHAR (50) NULL,
    [EvenlyAssigned]        VARCHAR (50) NULL,
    [Destination]           VARCHAR (50) NULL,
    [Destinationsnavn]      VARCHAR (50) NULL,
    [indlæstTidspunkt]      DATETIME     CONSTRAINT [DF_MD_G_KRIT_DriverSys_PersonaleData_indlæstTidspunkt] DEFAULT (getdate()) NULL,
    [indlæstAf]             [sysname]    CONSTRAINT [DF_MD_G_KRIT_DriverSys_PersonaleData_indlæstAf] DEFAULT (suser_sname()) NULL,
    [Periode]               VARCHAR (50) NULL
);

