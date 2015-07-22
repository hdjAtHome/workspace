CREATE TABLE [ods].[MD_G_STAM_artGrp] (
    [ArtGrp]           VARCHAR (50) NULL,
    [ArtGrpNavn]       VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    DEFAULT (suser_sname()) NULL
);

