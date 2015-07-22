CREATE TABLE [dbo].[LOG_Logging] (
    [Tidstempel]  DATETIME      NULL,
    [Objekt_Type] CHAR (1)      NULL,
    [Objekt_Navn] VARCHAR (50)  NULL,
    [Log_type]    CHAR (1)      NULL,
    [Meddelelse]  VARCHAR (500) NULL,
    [Job_ID]      INT           NULL,
    [Periode]     VARCHAR (50)  NULL,
    [DataSerie]   VARCHAR (50)  NULL
);

