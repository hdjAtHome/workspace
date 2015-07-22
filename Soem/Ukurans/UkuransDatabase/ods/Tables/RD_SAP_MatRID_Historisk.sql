CREATE TABLE [ods].[RD_SAP_MatRID_Historisk] (
    [Dim_Tid]           VARCHAR (6)     NOT NULL,
    [Fabrik]            VARCHAR (10)    NOT NULL,
    [Materiale]         VARCHAR (18)    NULL,
    [MatTekst]          VARCHAR (50)    NULL,
    [OmlVare]           CHAR (1)        NULL,
    [Raekkeevne_i_dage] INT             NULL,
    [Forbrug_pr_dag]    DECIMAL (7, 3)  NULL,
    [Beholdning]        DECIMAL (18, 3) NULL,
    [BME]               VARCHAR (10)    NULL,
    [MRPcontr]          VARCHAR (10)    NULL,
    [MRPtype]           VARCHAR (10)    NULL,
    [ABC_IN]            VARCHAR (10)    NULL,
    [VareGrp]           VARCHAR (20)    NULL,
    [MatArt]            VARCHAR (10)    NULL,
    [IKGruppe]          VARCHAR (10)    NULL
);

