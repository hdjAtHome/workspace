CREATE TABLE [ods].[Key_Dim_Omkostningssted] (
    [Pk_Key]               INT           IDENTITY (1, 1) NOT NULL,
    [Omkostningssted]      VARCHAR (256) NULL,
    [Gyldigfra]            DATETIME      NULL,
    [Gyldigtil]            DATETIME      NULL,
    [Created]              DATETIME      DEFAULT (getdate()) NULL,
    [Updated]              DATETIME      NULL,
    [Gyldigtil_tilrettet]  BIT           NULL,
    [omkostningssted_kort] VARCHAR (50)  NULL
);

