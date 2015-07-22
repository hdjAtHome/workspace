CREATE TABLE [edw].[DI_Operatoer] (
    [PK_ID]     INT          IDENTITY (1, 1) NOT NULL,
    [Operatoer] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_DI_Operatoer] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [UK_DI_Operatoer] UNIQUE NONCLUSTERED ([Operatoer] ASC)
);

