CREATE TABLE [dbo].[MD_G_KRIT_Costpool_Anlæg] (
    [ID]               VARCHAR (50) NULL,
    [CostPool]         VARCHAR (50) NULL,
    [CostPoolNavn]     VARCHAR (50) NULL,
    [HUNRFRA]          VARCHAR (50) NULL,
    [HUNRTIL]          VARCHAR (50) NULL,
    [KlasseFra]        VARCHAR (50) NULL,
    [KlasseTil]        VARCHAR (50) NULL,
    [OmkStedFra]       VARCHAR (50) NULL,
    [OmkStedTil]       VARCHAR (50) NULL,
    [Niveau]           VARCHAR (50) NULL,
    [PctrFra]          VARCHAR (50) NULL,
    [PctrTil]          VARCHAR (50) NULL,
    [StationsnrFra]    VARCHAR (50) NULL,
    [StationsnrTil]    VARCHAR (50) NULL,
    [StationstypeFra]  VARCHAR (50) NULL,
    [StationstypeTil]  VARCHAR (50) NULL,
    [Model]            VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     CONSTRAINT [DF_MD_G_KRIT_Costpool_Anlæg_indlæstTidspunkt] DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    CONSTRAINT [DF_MD_G_KRIT_Costpool_Anlæg_indlæstAf] DEFAULT (suser_sname()) NOT NULL,
    [DelområdeFra]     VARCHAR (50) NULL,
    [DelområdeTil]     VARCHAR (50) NULL
);

