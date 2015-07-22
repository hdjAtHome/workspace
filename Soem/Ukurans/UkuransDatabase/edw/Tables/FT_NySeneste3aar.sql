CREATE TABLE [edw].[FT_NySeneste3aar] (
    [Dim_Fabrik]    VARCHAR (10)    NULL,
    [Materiale]     VARCHAR (18)    NULL,
    [Dim_Materiale] INT             NULL,
    [Dim_Tid]       VARCHAR (8)     NOT NULL,
    [Vaerdi_GP]     DECIMAL (18, 3) NULL,
    [Beholdning]    DECIMAL (18, 3) NULL
);

