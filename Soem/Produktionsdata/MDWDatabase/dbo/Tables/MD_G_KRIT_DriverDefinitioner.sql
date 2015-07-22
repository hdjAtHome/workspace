CREATE TABLE [dbo].[MD_G_KRIT_DriverDefinitioner] (
    [Drivernavn]       VARCHAR (50) NULL,
    [Sekvens]          INT          NULL,
    [Formel]           VARCHAR (50) NULL,
    [Værdi]            VARCHAR (50) NULL,
    [Vægt]             INT          NULL,
    [indlæstTidspunkt] DATETIME     CONSTRAINT [DF_MD_G_KRIT_DriverDefinitioner_indlæstTidspunkt] DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    CONSTRAINT [DF_MD_G_KRIT_DriverDefinitioner_indlæstAf] DEFAULT (suser_sname()) NULL,
    [Periode]          VARCHAR (50) NULL
);

