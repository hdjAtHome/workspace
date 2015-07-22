CREATE TABLE [ods].[rd_r_økonomi_drift_konverteret] (
    [Profitcenter]        VARCHAR (50) NULL,
    [Profitcenternavn]    VARCHAR (50) NULL,
    [Omkostningssted]     VARCHAR (50) NULL,
    [Omkostningsstednavn] VARCHAR (50) NULL,
    [Omkostningsart]      VARCHAR (50) NULL,
    [Omkostningsartnavn]  VARCHAR (50) NULL,
    [PSP-element]         VARCHAR (50) NULL,
    [PSP-elementNavn]     VARCHAR (50) NULL,
    [Ordre]               VARCHAR (50) NULL,
    [Ordrenavn]           VARCHAR (50) NULL,
    [Litratype]           VARCHAR (50) NULL,
    [Litratypenavn]       VARCHAR (50) NULL,
    [FaktiskBeløb]        FLOAT (53)   NULL,
    [PlanBeløb]           VARCHAR (50) NULL,
    [AfvigelseBeløb]      VARCHAR (50) NULL,
    [AfvigelseProcent]    VARCHAR (50) NULL,
    [FaktiskMængde]       VARCHAR (50) NULL,
    [PlanMængde]          VARCHAR (50) NULL,
    [indlæstTidspunkt]    DATETIME     NULL,
    [indlæstAf]           [sysname]    NULL,
    [Periode]             VARCHAR (50) NULL
);

