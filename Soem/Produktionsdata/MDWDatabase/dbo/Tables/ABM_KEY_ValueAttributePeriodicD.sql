CREATE TABLE [dbo].[ABM_KEY_ValueAttributePeriodicD] (
    [Delmodel]     NVARCHAR (64)   NOT NULL,
    [Period]       NVARCHAR (64)   NOT NULL,
    [Scenario]     NVARCHAR (64)   NOT NULL,
    [Reference]    NVARCHAR (64)   NOT NULL,
    [DefaultValue] NVARCHAR (2048) NULL,
    [Formula]      NVARCHAR (2048) NULL,
    CONSTRAINT [PK_ABM_KEY_ValueAttributePeriodicD] PRIMARY KEY CLUSTERED ([Delmodel] ASC, [Period] ASC, [Scenario] ASC, [Reference] ASC) WITH (FILLFACTOR = 90)
);

