CREATE TABLE [edw].[dim_member_slettede] (
    [PK_Key]             INT          NULL,
    [DimensionName]      VARCHAR (64) NULL,
    [MemberName]         VARCHAR (64) NULL,
    [MemberRefnum]       VARCHAR (64) NULL,
    [MemberLevelId]      SMALLINT     NULL,
    [MemberDisplayOrder] FLOAT (53)   NULL,
    [Parent_Key]         INT          NULL,
    [Drivername]         VARCHAR (64) NULL,
    [indlæstTidspunkt]   DATETIME     NULL,
    [indlæstAf]          [sysname]    NULL,
    [opdateretTidspunkt] DATETIME     NULL,
    [opdateretAf]        [sysname]    NULL,
    [slettetTidspunkt]   DATETIME     DEFAULT (getdate()) NULL,
    [slettetAf]          [sysname]    DEFAULT (suser_sname()) NULL
);

