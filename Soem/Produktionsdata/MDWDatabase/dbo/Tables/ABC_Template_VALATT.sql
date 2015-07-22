CREATE TABLE [dbo].[ABC_Template_VALATT] (
    [Reference]       NVARCHAR (50)  NOT NULL,
    [Name]            NVARCHAR (50)  NULL,
    [ParentReference] NVARCHAR (50)  NULL,
    [DefaultValue]    NVARCHAR (255) NULL,
    [Type]            NVARCHAR (50)  NULL,
    [Comments]        NVARCHAR (255) NULL,
    [DocRef]          NVARCHAR (50)  NULL,
    CONSTRAINT [PK_ABC_ValueAttribute] PRIMARY KEY CLUSTERED ([Reference] ASC) WITH (FILLFACTOR = 90)
);

