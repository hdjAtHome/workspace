CREATE TABLE [ods].[MD_G_STAM_artskontoplan] (
    [OmkArt]             VARCHAR (50) NULL,
    [OmkArtNavn]         VARCHAR (50) NULL,
    [Momsstatus]         FLOAT (53)   NULL,
    [CeArtGrp]           VARCHAR (50) NULL,
    [CeArtGrpNavn]       VARCHAR (50) NULL,
    [ArtGrp]             VARCHAR (50) NULL,
    [ArtGrpNavn]         VARCHAR (50) NULL,
    [Variabilitet]       VARCHAR (50) NULL,
    [VariabilitetNavn]   VARCHAR (50) NULL,
    [Reversibilitet]     VARCHAR (50) NULL,
    [ReversibilitetNavn] VARCHAR (50) NULL,
    [indlæstTidspunkt]   DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]          [sysname]    DEFAULT (suser_sname()) NULL
);

