CREATE TABLE [dbo].[MD_R_STAM_Rentesats] (
    [Periode]          VARCHAR (50) NULL,
    [Firmakode]        VARCHAR (5)  NULL,
    [Dataserie]        VARCHAR (1)  NULL,
    [Rentesats]        FLOAT (53)   NULL,
    [indlæstTidspunkt] DATETIME     CONSTRAINT [DF_MD_R_STAM_Rentesats_ny_indlæstTidspunkt] DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    CONSTRAINT [DF_MD_R_STAM_Rentesats_ny_indlæstAf] DEFAULT (suser_sname()) NULL
);

