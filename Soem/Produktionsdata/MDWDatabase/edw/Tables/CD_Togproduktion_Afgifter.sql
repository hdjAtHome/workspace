CREATE TABLE [edw].[CD_Togproduktion_Afgifter] (
    [Beskrivelse]      VARCHAR (50)    NULL,
    [FK_DI_Togsystem]  INT             NULL,
    [FK_DI_Tid]        VARCHAR (50)    NULL,
    [AT_Togkategori]   VARCHAR (50)    NULL,
    [AT_Afgiftstype]   VARCHAR (50)    NULL,
    [AT_Afgiftsdriver] VARCHAR (50)    NULL,
    [AT_Afgiftssats]   DECIMAL (24, 6) NULL,
    [Antal]            BIGINT          NULL,
    [Afgift_kr]        DECIMAL (24, 6) NULL,
    [Status]           VARCHAR (50)    NULL,
    [Timestamp]        DATETIME        NULL
);

