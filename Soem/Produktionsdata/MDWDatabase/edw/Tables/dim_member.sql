CREATE TABLE [edw].[dim_member] (
    [PK_Key]             INT          NULL,
    [DimensionName]      VARCHAR (64) NULL,
    [MemberName]         VARCHAR (64) NULL,
    [MemberRefnum]       VARCHAR (64) NULL,
    [MemberLevelId]      SMALLINT     NULL,
    [MemberDisplayOrder] FLOAT (53)   NULL,
    [Parent_Key]         INT          NULL,
    [Drivername]         VARCHAR (64) NULL,
    [indlæstTidspunkt]   DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]          [sysname]    DEFAULT (suser_sname()) NULL,
    [opdateretTidspunkt] DATETIME     NULL,
    [opdateretAf]        [sysname]    NULL
);

