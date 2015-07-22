CREATE TABLE [edw].[FT_Beholdning] (
    [Dim_Fabrik]    VARCHAR (10)    NULL,
    [Materiale]     VARCHAR (18)    NULL,
    [Dim_Materiale] INT             NULL,
    [Dim_Tid]       VARCHAR (8)     NOT NULL,
    [Beholdning]    DECIMAL (18, 3) NULL,
    [Vaerdi_GP]     DECIMAL (18, 3) NULL,
    [GlidGnsPris]   DECIMAL (18, 3) NULL,
    [Vaerdi_SP]     DECIMAL (18, 3) NULL
);

