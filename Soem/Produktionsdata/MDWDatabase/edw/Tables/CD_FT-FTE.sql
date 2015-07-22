CREATE TABLE [edw].[CD_FT-FTE] (
    [DI_Medarbejde] INT             NOT NULL,
    [DI_Tid_Maaned] VARCHAR (6)     NOT NULL,
    [DI_Firmakode]  VARCHAR (15)    NOT NULL,
    [DI_Omksted]    INT             NULL,
    [Profitcenter]  VARCHAR (15)    NOT NULL,
    [Loanart]       VARCHAR (15)    NOT NULL,
    [FTE]           DECIMAL (10, 3) NULL
);

