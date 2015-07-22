CREATE TABLE [ods].[CTL_Dataload] (
    [Kilde_System]     VARCHAR (12)  NOT NULL,
    [Variable]         VARCHAR (50)  NOT NULL,
    [Value]            VARCHAR (100) NULL,
    [Updated]          DATETIME      NULL,
    [Updated_username] [sysname]     NULL,
    CONSTRAINT [PK_kilde_system_variabel] PRIMARY KEY CLUSTERED ([Kilde_System] ASC, [Variable] ASC)
);

