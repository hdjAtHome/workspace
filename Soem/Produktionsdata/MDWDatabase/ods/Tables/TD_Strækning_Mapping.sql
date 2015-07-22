CREATE TABLE [ods].[TD_Strækning_Mapping] (
    [DI_Tid]               VARCHAR (50) NOT NULL,
    [DI_S_Straekning]      INT          NOT NULL,
    [DI_Tidsintervaller]   INT          NOT NULL,
    [Afgang]               DATETIME     NOT NULL,
    [Ankomst]              DATETIME     NOT NULL,
    [Tognr]                INT          NOT NULL,
    [Frastation]           VARCHAR (10) NULL,
    [Tilstation]           VARCHAR (10) NULL,
    [Kilde]                VARCHAR (50) NULL,
    [Aflyst]               VARCHAR (20) NULL,
    [DI_S_Doegn_Inddeling] INT          NULL
);

