CREATE TABLE [edw].[DI_S_Doegn_Inddeling] (
    [PK_ID]           INT          IDENTITY (1, 1) NOT NULL,
    [Doegn_Inddeling] VARCHAR (5)  NOT NULL,
    [Navn]            VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_DI_S_Doegn_Inddeling] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [UK_DI_S_Doegn_Inddeling] UNIQUE NONCLUSTERED ([Doegn_Inddeling] ASC)
);

