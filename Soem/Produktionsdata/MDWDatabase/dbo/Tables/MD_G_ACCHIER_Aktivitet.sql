CREATE TABLE [dbo].[MD_G_ACCHIER_Aktivitet] (
    [Sort]             FLOAT (53)   NULL,
    [Reference_ID]     VARCHAR (50) NULL,
    [Reference_Name]   VARCHAR (50) NULL,
    [Reference_Parent] VARCHAR (50) NULL,
    [Type]             VARCHAR (50) NULL,
    [EvenlyAssigned]   VARCHAR (50) NULL,
    [DriverName]       VARCHAR (50) NULL,
    [Aktiv]            VARCHAR (50) NULL,
    [Beskrivelse]      VARCHAR (50) NULL,
    [ATT_FunkKunde]    VARCHAR (50) NULL,
    [ATT_ProdVAR]      VARCHAR (50) NULL,
    [ATT_Segment]      VARCHAR (50) NULL,
    [ATT_ProdAktGrp]   VARCHAR (50) NULL,
    [ATT_ProdLitra]    VARCHAR (50) NULL,
    [ATT_TidDr]        VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    DEFAULT (suser_sname()) NULL,
    [Periode]          VARCHAR (50) NULL
);

