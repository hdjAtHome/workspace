CREATE TABLE [edw].[DI_Tognummer] (
    [Tognr]         INT          NOT NULL,
    [TognrInterval] VARCHAR (50) NULL,
    [Timestamp]     DATETIME     NULL,
    CONSTRAINT [PK_DI_Tognummer] PRIMARY KEY CLUSTERED ([Tognr] ASC)
);

