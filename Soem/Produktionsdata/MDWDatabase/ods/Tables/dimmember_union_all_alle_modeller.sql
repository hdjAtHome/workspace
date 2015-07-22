CREATE TABLE [ods].[dimmember_union_all_alle_modeller] (
    [Model_Id]           INT          NULL,
    [DimensionId]        INT          NULL,
    [DimensionName]      VARCHAR (64) NULL,
    [MemberId]           INT          NULL,
    [MemberKey]          INT          NULL,
    [ParentId]           INT          NULL,
    [ParentKey]          INT          NULL,
    [MemberName]         VARCHAR (64) NULL,
    [MemberRefnum]       VARCHAR (64) NULL,
    [MemberLevelId]      SMALLINT     NULL,
    [MemberDisplayOrder] FLOAT (53)   NULL,
    [Parent_Key]         INT          NULL,
    [Drivername]         VARCHAR (64) NULL,
    [indlæstTidspunkt]   DATETIME     DEFAULT (getdate()) NULL,
    [indlæstAf]          [sysname]    DEFAULT (suser_sname()) NULL
);

