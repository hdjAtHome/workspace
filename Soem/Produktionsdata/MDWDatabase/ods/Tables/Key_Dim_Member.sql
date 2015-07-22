CREATE TABLE [ods].[Key_Dim_Member] (
    [Pk_Key]             INT           IDENTITY (1, 1) NOT NULL,
    [DimensionName]      VARCHAR (256) NULL,
    [MemberRefnum]       VARCHAR (256) NULL,
    [Created]            DATETIME      DEFAULT (getdate()) NULL,
    [opdateretTidspunkt] DATETIME      NULL,
    [opdateretAf]        [sysname]     NULL
);

