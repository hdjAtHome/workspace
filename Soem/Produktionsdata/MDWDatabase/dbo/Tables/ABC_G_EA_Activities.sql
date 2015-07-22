CREATE TABLE [dbo].[ABC_G_EA_Activities] (
    [SourceReference]  VARCHAR (50)  NOT NULL,
    [SourceModuleType] VARCHAR (50)  NOT NULL,
    [DestReference]    VARCHAR (50)  NULL,
    [DestModuleType]   VARCHAR (50)  NULL,
    [Comments]         VARCHAR (255) NULL,
    [DocRef]           VARCHAR (50)  NULL,
    [Periode]          VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_ABC_G_EA_Activities] PRIMARY KEY CLUSTERED ([SourceReference] ASC, [SourceModuleType] ASC, [Periode] ASC) WITH (FILLFACTOR = 90)
);

