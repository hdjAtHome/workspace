CREATE TABLE [ods].[rd_stog_korelobtider] (
    [DATO]              DATETIME     NULL,
    [AFG_STAT_NR]       INT          NULL,
    [ANK_STAT_NR]       INT          NULL,
    [ANK_TID]           INT          NULL,
    [AFG_TID]           INT          NULL,
    [Ankomst]           DATETIME     NULL,
    [Afgang]            DATETIME     NULL,
    [TOG_NR]            INT          NULL,
    [Passagerkapacitet] INT          NULL,
    [Antal_vogne]       INT          NULL,
    [Fingernr]          INT          NULL,
    [Kilometer]         FLOAT (53)   NULL,
    [DoegnInddeling]    VARCHAR (10) NULL,
    [TOG_TYPE]          VARCHAR (1)  DEFAULT ('') NOT NULL
);

