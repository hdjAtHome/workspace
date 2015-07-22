CREATE TABLE [ods].[Key_Dim_Profitcenter_uden_historik] (
    [Pk_Key]       INT           IDENTITY (1, 1) NOT NULL,
    [Profitcenter] VARCHAR (256) NULL,
    [Created]      DATETIME      DEFAULT (getdate()) NULL
);

