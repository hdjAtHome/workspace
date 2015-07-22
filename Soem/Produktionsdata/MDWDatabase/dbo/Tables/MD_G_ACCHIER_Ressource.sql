CREATE TABLE [dbo].[MD_G_ACCHIER_Ressource] (
    [Niveau]           VARCHAR (50) NULL,
    [Sort]             INT          NULL,
    [Reference_ID]     VARCHAR (50) NULL,
    [Reference_Name]   VARCHAR (50) NULL,
    [Reference_Parent] VARCHAR (50) NULL,
    [Type]             VARCHAR (50) NULL,
    [EvenlyAssigned]   VARCHAR (50) NULL,
    [DriverName]       VARCHAR (50) NULL,
    [Model]            VARCHAR (50) NULL,
    [Aktiv]            VARCHAR (50) NULL,
    [Beskrivelse]      VARCHAR (50) NULL,
    [ATT_ResType]      VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    DEFAULT (suser_sname()) NULL,
    [Periode]          VARCHAR (50) NULL
);

