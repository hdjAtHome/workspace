CREATE TABLE [edw].[FT_Togproduktion_S_Tog_Litra] (
    [DI_Tid]                  VARCHAR (50)    NOT NULL,
    [DI_S_Station_Straekning] INT             NOT NULL,
    [DI_S_Materiel]           INT             NOT NULL,
    [DI_S_Materiel_Litra]     INT             NOT NULL,
    [DI_S_Straekning]         INT             NOT NULL,
    [DI_S_Doegn_Inddeling]    INT             NOT NULL,
    [Afgang]                  DATETIME        NOT NULL,
    [Ankomst]                 DATETIME        NOT NULL,
    [Tognr]                   INT             NOT NULL,
    [litra_løbenr]            INT             NOT NULL,
    [Litrakm]                 DECIMAL (24, 6) NOT NULL,
    [Pladskm]                 DECIMAL (24, 6) NOT NULL,
    [DI_Tidsintervaller]      INT             NOT NULL,
    CONSTRAINT [FK_FT_Togproduktion_S_Tog_Litra_DI_S_Doegn_Inddeling] FOREIGN KEY ([DI_S_Doegn_Inddeling]) REFERENCES [edw].[DI_S_Doegn_Inddeling] ([PK_ID]),
    CONSTRAINT [FK_FT_Togproduktion_S_Tog_Litra_DI_S_Materiel] FOREIGN KEY ([DI_S_Materiel]) REFERENCES [edw].[DI_S_Materiel] ([PK_ID]),
    CONSTRAINT [FK_FT_Togproduktion_S_Tog_Litra_DI_S_Materiel_litra] FOREIGN KEY ([DI_S_Materiel_Litra]) REFERENCES [edw].[DI_S_Materiel] ([PK_ID]),
    CONSTRAINT [FK_FT_Togproduktion_S_Tog_Litra_DI_S_Station_Straekning] FOREIGN KEY ([DI_S_Station_Straekning]) REFERENCES [edw].[DI_S_Station_Straekning] ([PK_ID]),
    CONSTRAINT [FK_FT_Togproduktion_S_Tog_Litra_DI_S_Straekning] FOREIGN KEY ([DI_S_Straekning]) REFERENCES [edw].[DI_S_Straekning] ([PK_ID]),
    CONSTRAINT [FK_FT_Togproduktion_S_Tog_Litra_DI_Tid] FOREIGN KEY ([DI_Tid]) REFERENCES [edw].[DI_Tid] ([Reference]),
    CONSTRAINT [FK_FT_Togproduktion_S_Tog_Litra_DI_Tidsinterval] FOREIGN KEY ([DI_Tidsintervaller]) REFERENCES [edw].[DI_Tidsintervaller] ([PK_ID])
);

