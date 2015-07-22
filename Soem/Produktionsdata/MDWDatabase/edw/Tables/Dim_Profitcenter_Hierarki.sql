CREATE TABLE [edw].[Dim_Profitcenter_Hierarki] (
    [Pk_key]             INT           NULL,
    [Profitcenter]       VARCHAR (255) NULL,
    [Profitcenternavn]   VARCHAR (255) NULL,
    [Parent_Key]         INT           NULL,
    [ParentProfitcenter] VARCHAR (255) NULL,
    [Niveau]             SMALLINT      NULL
);

