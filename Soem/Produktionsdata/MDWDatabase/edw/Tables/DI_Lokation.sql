CREATE TABLE [edw].[DI_Lokation] (
    [Kode]         VARCHAR (10) NOT NULL,
    [Navn]         VARCHAR (30) NULL,
    [StartStation] VARCHAR (5)  NOT NULL,
    [SlutStation]  VARCHAR (5)  NOT NULL,
    [Timestamp]    DATETIME     NULL,
    CONSTRAINT [PK_DI_Lokation] PRIMARY KEY CLUSTERED ([Kode] ASC)
);

