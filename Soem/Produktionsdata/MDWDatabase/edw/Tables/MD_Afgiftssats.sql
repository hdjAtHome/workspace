CREATE TABLE [edw].[MD_Afgiftssats] (
    [Straekning]  VARCHAR (50)    NOT NULL,
    [Navn]        VARCHAR (50)    NULL,
    [AfgiftsSats] DECIMAL (18, 2) NOT NULL,
    [Bemaerkning] VARCHAR (50)    NULL,
    CONSTRAINT [PK__MD_Afgiftssats__2F3AE904] PRIMARY KEY CLUSTERED ([Straekning] ASC)
);

