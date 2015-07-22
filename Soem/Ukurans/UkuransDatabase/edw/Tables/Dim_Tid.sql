CREATE TABLE [edw].[Dim_Tid] (
    [uds_level]       VARCHAR (10) NOT NULL,
    [Reference]       VARCHAR (8)  NOT NULL,
    [ParentReference] VARCHAR (8)  NOT NULL,
    [Name]            VARCHAR (50) NOT NULL,
    [Aar]             INT          NULL,
    [Halvaar]         INT          NULL,
    [Kvartal]         INT          NULL,
    [Maanedtekst]     VARCHAR (50) NULL,
    [MaanedNum]       INT          NULL,
    [UgedagTekst]     VARCHAR (50) NULL,
    [UgedagNum]       INT          NULL,
    [Maanedsdag]      INT          NULL,
    [Helligdag]       VARCHAR (5)  NULL,
    [Alternativ1]     VARCHAR (10) NULL,
    [Dagenefter]      VARCHAR (8)  NULL,
    [Dato]            DATETIME     NULL,
    CONSTRAINT [PK_DI_Tid] PRIMARY KEY CLUSTERED ([Reference] ASC)
);

