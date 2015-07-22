CREATE TABLE [etl].[Grl_DataLoadCheck_Vaerdi] (
    [Id]              INT             IDENTITY (1, 1) NOT NULL,
    [CheckElement_Id] INT             NOT NULL,
    [Period]          INT             NULL,
    [Vaerdi]          DECIMAL (24, 6) NULL,
    [Tidsstempel]     DATETIME        NULL,
    CONSTRAINT [PK_Grl_DataLoadCheck_Vaerdi] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Grl_DataLoadCheck_Vaerdi_Grl_DataLoadCheck_Element] FOREIGN KEY ([CheckElement_Id]) REFERENCES [etl].[Grl_DataLoadCheck_Element] ([Id])
);

