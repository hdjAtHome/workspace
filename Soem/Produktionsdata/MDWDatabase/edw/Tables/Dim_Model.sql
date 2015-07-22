CREATE TABLE [edw].[Dim_Model] (
    [PK_ID]            INT          IDENTITY (1, 1) NOT NULL,
    [Model]            VARCHAR (10) NULL,
    [År]               VARCHAR (6)  NULL,
    [aktiv]            BIT          NULL,
    [Modeltype]        VARCHAR (50) NULL,
    [UnaryOperator]    VARCHAR (10) NULL,
    [PeriodeFra]       DATETIME     NULL,
    [PeriodeTil]       DATETIME     NULL,
    [Periode]          VARCHAR (50) NULL,
    [DataSerie]        VARCHAR (50) NULL,
    [ABC_Cost_Element] VARCHAR (50) NULL,
    [ABC_Driver]       VARCHAR (50) NULL,
    [ABC_Model_Data]   VARCHAR (50) NULL
);

