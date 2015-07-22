CREATE TABLE [edw].[DI_Medarbejde] (
    [PK_ID]            INT          IDENTITY (-1, 1) NOT NULL,
    [MedarbejdeId]     INT          NOT NULL,
    [Cpr]              VARCHAR (12) NULL,
    [Navn]             VARCHAR (50) NULL,
    [Medarbejde_Tekst] VARCHAR (60) NULL,
    [Email]            VARCHAR (50) NULL,
    [NetId]            VARCHAR (50) NULL,
    [GyldigFradato]    DATETIME     NULL,
    [GyldigTildato]    DATETIME     NULL,
    [Aktiv]            VARCHAR (10) NULL,
    [Timestamp]        DATETIME     NULL,
    CONSTRAINT [PK_DI_Medarbejde] PRIMARY KEY CLUSTERED ([MedarbejdeId] ASC),
    CONSTRAINT [UK_DI_Medarbejde] UNIQUE NONCLUSTERED ([PK_ID] ASC)
);

