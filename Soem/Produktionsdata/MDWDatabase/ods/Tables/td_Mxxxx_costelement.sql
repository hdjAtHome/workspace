CREATE TABLE [ods].[td_Mxxxx_costelement] (
    [Id]                   INT           NULL,
    [PeriodId]             SMALLINT      NULL,
    [ScenarioId]           SMALLINT      NULL,
    [SourceId]             INT           NULL,
    [DestinationId]        INT           NULL,
    [Refnum]               VARCHAR (256) NULL,
    [Name]                 VARCHAR (256) NULL,
    [Type]                 SMALLINT      NULL,
    [FixedCost]            FLOAT (53)    NULL,
    [VariableCost]         FLOAT (53)    NULL,
    [AllocatedCost]        FLOAT (53)    NULL,
    [IdleCost]             FLOAT (53)    NULL,
    [FixedQuantity]        FLOAT (53)    NULL,
    [VariableQuantity]     FLOAT (53)    NULL,
    [FixedWeight]          FLOAT (53)    NULL,
    [VariableWeight]       FLOAT (53)    NULL,
    [QuantityBasic]        FLOAT (53)    NULL,
    [QuantityCalculated]   FLOAT (53)    NULL,
    [UserIdleQuantity]     FLOAT (53)    NULL,
    [AssignedIdleQuantity] FLOAT (53)    NULL
);

