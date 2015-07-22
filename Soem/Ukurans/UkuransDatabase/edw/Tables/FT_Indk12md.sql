CREATE TABLE [edw].[FT_Indk12md] (
    [Dim_Fabrik]        VARCHAR (4)     NULL,
    [Materiale]         VARCHAR (18)    NULL,
    [Dim_Materiale]     INT             NULL,
    [Dim_Tid]           VARCHAR (6)     NOT NULL,
    [BrutIndk12mdMgd]   DECIMAL (18, 3) NULL,
    [UltBehIndk12mdMgd] DECIMAL (18, 3) NULL,
    [UltBehIndk12mdVd]  DECIMAL (18, 3) NULL
);

