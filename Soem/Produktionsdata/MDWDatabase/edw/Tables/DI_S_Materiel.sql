CREATE TABLE [edw].[DI_S_Materiel] (
    [PK_ID]            INT          IDENTITY (1, 1) NOT NULL,
    [Litra_typer]      VARCHAR (50) NOT NULL,
    [Siddepladser]     INT          NOT NULL,
    [Antal_vogne]      INT          NOT NULL,
    [Materielkategori] VARCHAR (50) DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_DI_S_Materiel] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [UK_DI_S_Materiel_Siddepladser] UNIQUE NONCLUSTERED ([Siddepladser] ASC, [Materielkategori] ASC)
);

