CREATE TABLE [edw].[DI_Tid_Maaned] (
    [PK_ID]    VARCHAR (6)  NOT NULL,
    [Navn]     VARCHAR (30) NOT NULL,
    [Kvarter]  VARCHAR (10) NOT NULL,
    [Aar]      VARCHAR (6)  NOT NULL,
    [KortNavn] VARCHAR (6)  NULL,
    CONSTRAINT [PK_DI_Tid_Maaned] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

