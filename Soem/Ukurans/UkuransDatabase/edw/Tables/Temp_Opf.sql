CREATE TABLE [edw].[Temp_Opf] (
    [FraTil_Tid]     VARCHAR (13)    NULL,
    [Dim_Fabrik]     VARCHAR (10)    NULL,
    [Materiale]      VARCHAR (18)    NULL,
    [MaterialeTekst] VARCHAR (50)    NULL,
    [LNType]         VARCHAR (4)     NOT NULL,
    [FLNType]        VARCHAR (4)     NULL,
    [Beh_N]          DECIMAL (18, 3) NULL,
    [Beh_F]          DECIMAL (18, 3) NULL,
    [Ansk_Vd_N]      DECIMAL (18, 3) NULL,
    [Ansk_Vd_F]      DECIMAL (18, 3) NULL,
    [Delta_Vd]       DECIMAL (19, 3) NULL,
    [LogNedskr_N]    DECIMAL (18, 3) NULL,
    [LogNedskr_F]    DECIMAL (18, 3) NULL,
    [NedskrNetto_N]  DECIMAL (18, 3) NULL,
    [NedskrNetto_F]  DECIMAL (18, 3) NULL,
    [Delta_Nedskr]   DECIMAL (19, 3) NULL,
    [LitraGr2]       VARCHAR (15)    NULL,
    [StatusGr2]      VARCHAR (20)    NULL,
    [DUF]            INT             NULL,
    [RID]            DECIMAL (18, 3) NULL
);

