CREATE TABLE [etl].[Ods_LoaderLog] (
    [LoaderLogID]  INT             IDENTITY (1, 1) NOT NULL,
    [PackageLogID] INT             NOT NULL,
    [SourceSystem] VARCHAR (12)    NOT NULL,
    [TableName]    VARCHAR (100)   NOT NULL,
    [StartTime]    DATETIME        NOT NULL,
    [EndTime]      DATETIME        NULL,
    [Success]      BIT             CONSTRAINT [DF_LoaderLog_Success] DEFAULT ((0)) NOT NULL,
    [MaxPeriod]    VARCHAR (50)    NULL,
    [NumRows]      INT             NULL,
    [CtlColName_1] VARCHAR (50)    NULL,
    [CtlColTot_1]  DECIMAL (24, 6) NULL,
    [CtlColName_2] VARCHAR (50)    NULL,
    [CtlColTot_2]  DECIMAL (24, 6) NULL,
    [CtlColName_3] VARCHAR (50)    NULL,
    [CtlColTot_3]  DECIMAL (24, 6) NULL,
    [CtlColName_4] VARCHAR (50)    NULL,
    [CtlColTot_4]  DECIMAL (24, 6) NULL,
    CONSTRAINT [PK_LoaderLogID] PRIMARY KEY CLUSTERED ([LoaderLogID] ASC)
);

