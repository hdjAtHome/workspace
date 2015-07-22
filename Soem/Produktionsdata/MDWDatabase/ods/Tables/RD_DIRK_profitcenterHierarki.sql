CREATE TABLE [ods].[RD_DIRK_profitcenterHierarki] (
    [dimprofitcenterid] VARCHAR (10)  NULL,
    [parent]            VARCHAR (10)  NULL,
    [membername]        VARCHAR (100) NULL,
    [created_datetime]  DATETIME      DEFAULT (getdate()) NULL,
    [created_username]  [sysname]     DEFAULT (suser_sname()) NOT NULL
);

