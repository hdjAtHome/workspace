CREATE TABLE [dbo].[ABM_KEY_Driver] (
    [Delmodel]                       NVARCHAR (64)  NOT NULL,
    [Name]                           NVARCHAR (64)  NOT NULL,
    [DriverType]                     NVARCHAR (64)  NULL,
    [UniqueDriverQuantities]         BIT            NOT NULL,
    [Formula]                        NVARCHAR (255) NULL,
    [UseFixedQuantities]             BIT            NULL,
    [UseVariableQuantities]          BIT            NULL,
    [UseWeightedQuantities]          BIT            NULL,
    [SequenceNumber]                 INT            NULL,
    [FixedDriverQuantityOverride]    NVARCHAR (64)  NULL,
    [VariableDriverQuantityOverride] NVARCHAR (64)  NULL,
    [IdleFlowMethod]                 NVARCHAR (64)  NULL,
    [UserEnteredCostAllocation]      BIT            NULL,
    CONSTRAINT [PK_ABM_KEY_Driver] PRIMARY KEY CLUSTERED ([Delmodel] ASC, [Name] ASC) WITH (FILLFACTOR = 90)
);

