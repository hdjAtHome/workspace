CREATE TABLE [edw].[DI_Tidsintervaller] (
    [PK_ID]     INT          NOT NULL,
    [Navn]      VARCHAR (50) NOT NULL,
    [Prioritet] INT          NOT NULL,
    CONSTRAINT [PK_DI_Tidsintervaller] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

