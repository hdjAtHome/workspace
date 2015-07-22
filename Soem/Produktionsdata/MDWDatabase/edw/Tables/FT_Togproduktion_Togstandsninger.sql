CREATE TABLE [edw].[FT_Togproduktion_Togstandsninger] (
    [FK_DI_Togsystem]        INT          NULL,
    [FK_DI_Tid]              VARCHAR (50) NULL,
    [AT_Togkategori]         VARCHAR (50) NULL,
    [AT_Stationsforkortelse] VARCHAR (50) NULL,
    [AT_Stationsnavn]        VARCHAR (50) NULL,
    [AT_Status]              VARCHAR (50) NULL,
    [AntalTog]               BIGINT       NULL,
    [Timestamp]              DATETIME     NULL,
    CONSTRAINT [FK_FT_Togproduktion_Togstandsninger_DI_Tid] FOREIGN KEY ([FK_DI_Tid]) REFERENCES [edw].[DI_Tid] ([Reference]),
    CONSTRAINT [FK_FT_Togproduktion_Togstandsninger_DI_Togsystem] FOREIGN KEY ([FK_DI_Togsystem]) REFERENCES [edw].[DI_Togsystem] ([PK_DI_Togsystem])
);

