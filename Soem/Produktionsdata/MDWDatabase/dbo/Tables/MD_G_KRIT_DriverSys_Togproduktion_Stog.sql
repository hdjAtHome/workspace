CREATE TABLE [dbo].[MD_G_KRIT_DriverSys_Togproduktion_Stog] (
    [Drivernavn]       VARCHAR (50) NULL,
    [Enhed]            VARCHAR (50) NULL,
    [Litra]            VARCHAR (50) NULL,
    [Togsystemer]      VARCHAR (50) NULL,
    [Tidsinterval]     VARCHAR (50) NULL,
    [Destination]      VARCHAR (50) NULL,
    [Destinationsnavn] VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     CONSTRAINT [DF_MD_G_KRIT_DriverSys_Togproduktion_Stog_indlæstTidspunkt] DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    CONSTRAINT [DF_MD_G_KRIT_DriverSys_Togproduktion_Stog_indlæstAf] DEFAULT (suser_sname()) NULL,
    [Periode]          VARCHAR (50) NULL
);

