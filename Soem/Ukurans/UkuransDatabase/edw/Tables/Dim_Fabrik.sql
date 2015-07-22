CREATE TABLE [edw].[Dim_Fabrik] (
    [Fabrik]      VARCHAR (10) NOT NULL,
    [FabrikTekst] VARCHAR (50) NULL,
    [Parent]      VARCHAR (10) NULL,
    CONSTRAINT [PK_Dim_Fabrik_Fabrik] PRIMARY KEY CLUSTERED ([Fabrik] ASC)
);

