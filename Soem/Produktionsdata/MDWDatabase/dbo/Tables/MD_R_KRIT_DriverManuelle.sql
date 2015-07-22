CREATE TABLE [dbo].[MD_R_KRIT_DriverManuelle] (
    [Drivernavn]       VARCHAR (50) NULL,
    [Destination]      VARCHAR (50) NULL,
    [Destinationsnavn] VARCHAR (50) NULL,
    [Værdi]            FLOAT (53)   NULL,
    [Vægt]             FLOAT (53)   NULL,
    [Dato]             VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     NULL,
    [indlæstAf]        [sysname]    NULL,
    [Periode]          VARCHAR (50) NULL
);

