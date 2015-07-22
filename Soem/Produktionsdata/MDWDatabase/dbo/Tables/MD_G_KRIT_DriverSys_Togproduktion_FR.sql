CREATE TABLE [dbo].[MD_G_KRIT_DriverSys_Togproduktion_FR] (
    [Drivernavn]       VARCHAR (50) NULL,
    [Enhed]            VARCHAR (50) NULL,
    [Litra]            VARCHAR (50) NULL,
    [Produkt]          VARCHAR (50) NULL,
    [Materielkørsel]   VARCHAR (50) NULL,
    [Togsystemer]      VARCHAR (50) NULL,
    [Tidsinterval]     VARCHAR (50) NULL,
    [Destination]      VARCHAR (50) NULL,
    [Destinationsnavn] VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    DEFAULT (suser_sname()) NULL,
    [Periode]          VARCHAR (50) NULL
);

