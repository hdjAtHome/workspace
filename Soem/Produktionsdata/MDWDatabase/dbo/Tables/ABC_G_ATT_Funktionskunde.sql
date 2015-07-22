CREATE TABLE [dbo].[ABC_G_ATT_Funktionskunde] (
    [AttributeReference] VARCHAR (50)  NULL,
    [AttributeDimension] VARCHAR (50)  NOT NULL,
    [AccountModuleType]  VARCHAR (50)  NOT NULL,
    [AccountReference]   VARCHAR (50)  NOT NULL,
    [Comments]           VARCHAR (255) NULL,
    [DocRef]             VARCHAR (50)  NULL,
    [Periode]            VARCHAR (50)  NOT NULL,
    [DataSerie]          VARCHAR (50)  NULL,
    CONSTRAINT [PK_ABC_Attribute_Funktionskunde] PRIMARY KEY CLUSTERED ([AttributeDimension] ASC, [AccountModuleType] ASC, [AccountReference] ASC, [Periode] ASC) WITH (FILLFACTOR = 90)
);

