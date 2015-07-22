CREATE TABLE [dbo].[MD_G_KRIT_DriverSys_Lokoførertid_FR] (
    [Drivernavn]       VARCHAR (50) NULL,
    [Enhed]            VARCHAR (50) NULL,
    [Navn]             VARCHAR (50) NULL,
    [Turdepot]         VARCHAR (50) NULL,
    [OpgaveGruppe]     VARCHAR (50) NULL,
    [Opgavetype]       VARCHAR (50) NULL,
    [Produkt]          VARCHAR (50) NULL,
    [Togsystem]        VARCHAR (50) NULL,
    [Tidsinterval]     VARCHAR (50) NULL,
    [Destination]      VARCHAR (50) NULL,
    [Destinationsnavn] VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     CONSTRAINT [DF_MD_G_KRIT_DriverSys_Lokoførertid_FR_indlæstTidspunkt] DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    CONSTRAINT [DF_MD_G_KRIT_DriverSys_Lokoførertid_FR_indlæstAf] DEFAULT (suser_sname()) NULL,
    [Periode]          VARCHAR (50) NULL
);

