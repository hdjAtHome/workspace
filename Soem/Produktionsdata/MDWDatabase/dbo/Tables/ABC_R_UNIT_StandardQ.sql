CREATE TABLE [dbo].[ABC_R_UNIT_StandardQ] (
    [AccountReference]  VARCHAR (50) NOT NULL,
    [AccountModuleType] VARCHAR (50) NOT NULL,
    [UnitLabel]         VARCHAR (50) NOT NULL,
    [UnitQuantity]      FLOAT (53)   NOT NULL,
    [Periode]           VARCHAR (50) NULL,
    CONSTRAINT [PK_ABC_P_UNIT_StandardQ] PRIMARY KEY CLUSTERED ([AccountReference] ASC, [AccountModuleType] ASC, [UnitLabel] ASC) WITH (FILLFACTOR = 90)
);

