CREATE TABLE [edw].[DI_Turdepot] (
    [Turdepot]  VARCHAR (5)  NOT NULL,
    [Navn]      VARCHAR (50) NULL,
    [Timestamp] DATETIME     NULL,
    CONSTRAINT [PK_DI_Turdepot] PRIMARY KEY CLUSTERED ([Turdepot] ASC)
);

