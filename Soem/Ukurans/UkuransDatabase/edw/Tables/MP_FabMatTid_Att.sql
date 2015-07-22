CREATE TABLE [edw].[MP_FabMatTid_Att] (
    [Fabrik]     VARCHAR (10) NOT NULL,
    [Materiale]  VARCHAR (18) NOT NULL,
    [GyldigFra]  VARCHAR (6)  NOT NULL,
    [GyldigTil]  VARCHAR (6)  NOT NULL,
    [Pris_Enhed] INT          NULL,
    [MRPcontr]   VARCHAR (10) NULL,
    [MRP_type]   VARCHAR (10) NULL,
    [ABC_IN]     VARCHAR (10) NULL,
    [IKGruppe]   VARCHAR (10) NULL,
    [Aktiv]      CHAR (1)     NULL
);

