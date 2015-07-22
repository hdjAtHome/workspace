CREATE TABLE [dbo].[ABC_R_DRDEF_DriverDefinitioner] (
    [DriverName]                  VARCHAR (50)  NOT NULL,
    [DriverType]                  VARCHAR (50)  NULL,
    [Formula]                     VARCHAR (255) NULL,
    [SequenceNumber]              NUMERIC (12)  NULL,
    [FixedDriverQuantityOverride] VARCHAR (50)  NULL,
    [UseWeightedQuantities]       INT           NULL,
    [Periode]                     VARCHAR (50)  NULL
);

