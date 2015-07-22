CREATE TABLE [dbo].[ABM_ValueAttributePeriodicDef] (
    [Delmodel]     NVARCHAR (64)   NOT NULL,
    [Period]       NVARCHAR (64)   NOT NULL,
    [Scenario]     NVARCHAR (64)   NOT NULL,
    [Reference]    NVARCHAR (64)   NOT NULL,
    [DefaultValue] NVARCHAR (2048) NULL,
    [Formula]      NVARCHAR (2048) NULL
);

