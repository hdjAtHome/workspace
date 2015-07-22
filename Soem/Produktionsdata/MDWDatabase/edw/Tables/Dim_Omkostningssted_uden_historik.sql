CREATE TABLE [edw].[Dim_Omkostningssted_uden_historik] (
    [pk_key]              INT          NULL,
    [Omkostningssted]     VARCHAR (50) NULL,
    [OmkostningsstedNavn] VARCHAR (50) NULL,
    [Created]             DATETIME     DEFAULT (getdate()) NULL,
    [Profitcenter]        VARCHAR (50) NULL
);

