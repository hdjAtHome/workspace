CREATE TABLE [edw].[MD_Styringstabel_Multipli] (
    [FraTil_Tid]     VARCHAR (13) NOT NULL,
    [PrimoPrimoDato] VARCHAR (50) NOT NULL,
    [PrimoDato]      VARCHAR (50) NOT NULL,
    [UltimoDato]     VARCHAR (50) NOT NULL,
    [RegnOpdtDato]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Styringstabel_Multipli] PRIMARY KEY CLUSTERED ([FraTil_Tid] ASC) WITH (FILLFACTOR = 90)
);

