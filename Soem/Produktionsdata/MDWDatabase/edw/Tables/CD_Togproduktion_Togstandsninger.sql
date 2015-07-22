CREATE TABLE [edw].[CD_Togproduktion_Togstandsninger] (
    [Beskrivelse]            VARCHAR (50) NULL,
    [FK_DI_Togsystem]        INT          NULL,
    [FK_DI_Tid]              VARCHAR (50) NULL,
    [AT_Togkategori]         VARCHAR (50) NULL,
    [AT_Stationsforkortelse] VARCHAR (50) NULL,
    [AT_Stationsnavn]        VARCHAR (50) NULL,
    [AT_Status]              VARCHAR (50) NULL,
    [AntalTog]               BIGINT       NULL,
    [Timestamp]              DATETIME     NULL
);

