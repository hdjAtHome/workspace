CREATE TABLE [dbo].[ABC_R_DR_Togproduktion_FR] (
    [DriverName]          VARCHAR (50) NOT NULL,
    [DestModuleType]      VARCHAR (50) NOT NULL,
    [DestReference]       VARCHAR (50) NOT NULL,
    [DriverQuantityFixed] FLOAT (53)   NULL,
    [DriverWeightFixed]   FLOAT (53)   NULL,
    [Periode]             VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ABC_G_DR_Togproduktion_FR] PRIMARY KEY CLUSTERED ([DriverName] ASC, [DestReference] ASC, [Periode] ASC)
);

