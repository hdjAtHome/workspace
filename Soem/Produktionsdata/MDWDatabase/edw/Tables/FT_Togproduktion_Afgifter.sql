CREATE TABLE [edw].[FT_Togproduktion_Afgifter] (
    [FK_DI_Togsystem]  INT             NULL,
    [FK_DI_Tid]        VARCHAR (50)    NULL,
    [AT_Togkategori]   VARCHAR (50)    NULL,
    [AT_Afgiftstype]   VARCHAR (50)    NULL,
    [AT_Afgiftsdriver] VARCHAR (50)    NULL,
    [AT_Afgiftssats]   DECIMAL (24, 6) NULL,
    [Antal]            BIGINT          NULL,
    [Afgift_kr]        DECIMAL (24, 6) NULL,
    [Status]           VARCHAR (50)    NULL,
    [Timestamp]        DATETIME        NULL,
    CONSTRAINT [FK_FT_Togproduktion_Afgifter_DI_Tid] FOREIGN KEY ([FK_DI_Tid]) REFERENCES [edw].[DI_Tid] ([Reference]),
    CONSTRAINT [FK_FT_Togproduktion_Afgifter_DI_Togsystem] FOREIGN KEY ([FK_DI_Togsystem]) REFERENCES [edw].[DI_Togsystem] ([PK_DI_Togsystem])
);

