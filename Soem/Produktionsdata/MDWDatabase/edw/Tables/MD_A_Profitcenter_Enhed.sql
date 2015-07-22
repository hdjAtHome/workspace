CREATE TABLE [edw].[MD_A_Profitcenter_Enhed] (
    [Profitcenter] VARCHAR (50) NOT NULL,
    [Enhed]        VARCHAR (50) NULL,
    [Timestamp]    DATETIME     NULL,
    CONSTRAINT [PK_MD_A_Profitcenter_Enhed] PRIMARY KEY CLUSTERED ([Profitcenter] ASC)
);

