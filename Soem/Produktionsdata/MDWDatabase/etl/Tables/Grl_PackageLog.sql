CREATE TABLE [etl].[Grl_PackageLog] (
    [PackageLogID] INT            IDENTITY (1, 1) NOT NULL,
    [PackageName]  NVARCHAR (100) NOT NULL,
    [StartTime]    DATETIME       NOT NULL,
    [EndTime]      DATETIME       NULL,
    [Success]      BIT            CONSTRAINT [DF_PackageLog_Success] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_PackageLog] PRIMARY KEY CLUSTERED ([PackageLogID] ASC)
);

