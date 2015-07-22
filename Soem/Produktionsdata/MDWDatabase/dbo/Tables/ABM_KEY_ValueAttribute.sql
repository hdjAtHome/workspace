CREATE TABLE [dbo].[ABM_KEY_ValueAttribute] (
    [Delmodel]        NVARCHAR (64)  NOT NULL,
    [ModelID]         SMALLINT       NULL,
    [ModelName]       NVARCHAR (64)  NULL,
    [Reference]       NVARCHAR (64)  NOT NULL,
    [Name]            NVARCHAR (64)  NULL,
    [ParentReference] NVARCHAR (64)  NULL,
    [DefaultValue]    NVARCHAR (255) NULL,
    [Type]            NVARCHAR (64)  NULL,
    CONSTRAINT [PK_ABM_KEY_ValueAttribute] PRIMARY KEY CLUSTERED ([Delmodel] ASC, [Reference] ASC) WITH (FILLFACTOR = 90)
);

