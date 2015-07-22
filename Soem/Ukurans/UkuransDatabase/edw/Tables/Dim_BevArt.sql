CREATE TABLE [edw].[Dim_BevArt] (
    [BevArt]      VARCHAR (5)  NOT NULL,
    [BevArtTekst] VARCHAR (50) NULL,
    [BevArtType]  VARCHAR (50) NULL,
    CONSTRAINT [PK_Dim_BevArt_BevArt] PRIMARY KEY CLUSTERED ([BevArt] ASC)
);

