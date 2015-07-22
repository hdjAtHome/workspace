CREATE TABLE [etl].[Grl_DataLoadCheck_Element] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [DataLoadCheck_Id] INT           NOT NULL,
    [Load_Instans]     VARCHAR (50)  NOT NULL,
    [Load_Tabel]       VARCHAR (60)  NOT NULL,
    [Attribute]        VARCHAR (50)  NOT NULL,
    [Vaerdi_type]      VARCHAR (25)  NOT NULL,
    [Beskrivelse]      VARCHAR (256) NOT NULL,
    [Check_Element]    VARCHAR (35)  NULL,
    CONSTRAINT [PK_etl.DataLoadCheck] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Grl_DataLoadCheck_Element_Grl_DataLoadCheck_Hoved1] FOREIGN KEY ([DataLoadCheck_Id]) REFERENCES [etl].[Grl_DataLoadCheck] ([Id])
);

