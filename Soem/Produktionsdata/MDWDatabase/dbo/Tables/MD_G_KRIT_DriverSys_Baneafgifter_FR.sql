CREATE TABLE [dbo].[MD_G_KRIT_DriverSys_Baneafgifter_FR] (
    [Drivernavn]       VARCHAR (50) NULL,
    [Enhed]            VARCHAR (50) NULL,
    [Passage]          VARCHAR (50) NULL,
    [Afgift]           VARCHAR (50) NULL,
    [Produkt]          VARCHAR (50) NULL,
    [Togsystemer]      VARCHAR (50) NULL,
    [Destination]      VARCHAR (50) NULL,
    [Destinationsnavn] VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     CONSTRAINT [DF_MD_G_KRIT_DriverSys_Baneafgifter_FR_indlæstTidspunkt] DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    CONSTRAINT [DF_MD_G_KRIT_DriverSys_Baneafgifter_FR_indlæstAf] DEFAULT (suser_sname()) NULL,
    [Periode]          VARCHAR (50) NULL
);

