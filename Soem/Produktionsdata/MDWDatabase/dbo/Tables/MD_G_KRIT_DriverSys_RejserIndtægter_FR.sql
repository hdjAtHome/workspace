CREATE TABLE [dbo].[MD_G_KRIT_DriverSys_RejserIndtægter_FR] (
    [Drivernavn]       VARCHAR (50) NULL,
    [Enhed]            VARCHAR (50) NULL,
    [Stationnr]        VARCHAR (50) NULL,
    [Stationstype]     VARCHAR (50) NULL,
    [Landsdel]         VARCHAR (50) NULL,
    [Produkt]          VARCHAR (50) NULL,
    [Togsystemer]      VARCHAR (50) NULL,
    [Tidsinterval]     VARCHAR (50) NULL,
    [Destination]      VARCHAR (50) NULL,
    [Destinationsnavn] VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     CONSTRAINT [DF_MD_G_KRIT_DriverSys_RejserIndtægter_FR_indlæstTidspunkt] DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    CONSTRAINT [DF_MD_G_KRIT_DriverSys_RejserIndtægter_FR_indlæstAf] DEFAULT (suser_sname()) NULL,
    [Periode]          VARCHAR (50) NULL
);

