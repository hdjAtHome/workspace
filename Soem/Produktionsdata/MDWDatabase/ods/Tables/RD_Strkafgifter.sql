CREATE TABLE [ods].[RD_Strkafgifter] (
    [Maaned]              VARCHAR (50) NULL,
    [Afgiftsstraekning]   VARCHAR (50) NULL,
    [Togsystemnummer]     VARCHAR (50) NULL,
    [ICStraekning]        VARCHAR (50) NULL,
    [Togkategori]         VARCHAR (50) NULL,
    [Toggruppe]           VARCHAR (50) NULL,
    [AntalTog_MedAfgift]  INT          NULL,
    [AntalTog_UdenAfgift] INT          NULL,
    [Timestamp]           DATETIME     NULL,
    [Status]              VARCHAR (50) NULL
);

