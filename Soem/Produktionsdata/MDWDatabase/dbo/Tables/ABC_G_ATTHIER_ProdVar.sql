CREATE TABLE [dbo].[ABC_G_ATTHIER_ProdVar] (
    [AttributeReference]       VARCHAR (50)  NOT NULL,
    [AttributeDimension]       VARCHAR (50)  NOT NULL,
    [AttributeName]            VARCHAR (50)  NULL,
    [AttributeParentReference] VARCHAR (50)  NULL,
    [Comments]                 VARCHAR (255) NULL,
    [DocRef]                   VARCHAR (50)  NULL,
    [Periode]                  VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_ABC_AttibHierarchy_ProduktVariabilitet] PRIMARY KEY CLUSTERED ([AttributeReference] ASC, [AttributeDimension] ASC, [Periode] ASC) WITH (FILLFACTOR = 90)
);

