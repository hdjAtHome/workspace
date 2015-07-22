CREATE TABLE [ods].[RD_SAP_MatDUF_Historisk] (
    [Dim_Tid]        VARCHAR (6)     NOT NULL,
    [Fabrik]         VARCHAR (10)    NULL,
    [Materiale]      VARCHAR (18)    NULL,
    [MaterialeTekst] VARCHAR (50)    NOT NULL,
    [OmlVare]        CHAR (1)        NULL,
    [Dage_U_Forbrug] SMALLINT        NOT NULL,
    [Anvendt]        CHAR (1)        NULL,
    [Beholdning]     DECIMAL (18, 3) NOT NULL,
    [Dato]           VARCHAR (10)    NOT NULL,
    [MRPcontr]       VARCHAR (10)    NULL,
    [MRP_type]       VARCHAR (10)    NOT NULL,
    [ABC_IN]         VARCHAR (10)    NOT NULL,
    [VareGrp]        VARCHAR (20)    NOT NULL,
    [MatArt]         VARCHAR (10)    NOT NULL,
    [IKGruppe]       VARCHAR (10)    NOT NULL
);

