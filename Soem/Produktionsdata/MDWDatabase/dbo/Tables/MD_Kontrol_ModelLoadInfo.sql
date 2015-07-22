CREATE TABLE [dbo].[MD_Kontrol_ModelLoadInfo] (
    [DataSerie]        VARCHAR (50) NULL,
    [Periode]          VARCHAR (50) NULL,
    [Scenarie]         VARCHAR (50) NULL,
    [ABC_Cost_Element] VARCHAR (50) NULL,
    [ABC_Drivere]      VARCHAR (50) NULL,
    [ABC_Model_data]   VARCHAR (50) NULL,
    [ABM_Model]        VARCHAR (50) NULL,
    [Job_ID]           INT          IDENTITY (1, 1) NOT NULL,
    [Tilstand]         VARCHAR (50) NULL,
    [indlæstTidspunkt] DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]    DEFAULT (suser_sname()) NULL,
    CONSTRAINT [PK_MD_Kontrol_ModelLoadInfo] PRIMARY KEY CLUSTERED ([Job_ID] ASC)
);

