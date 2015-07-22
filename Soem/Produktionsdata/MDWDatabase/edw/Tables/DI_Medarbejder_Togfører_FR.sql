CREATE TABLE [edw].[DI_Medarbejder_Togfører_FR] (
    [PK_ID]       INT          IDENTITY (1, 1) NOT NULL,
    [NetId]       VARCHAR (50) NOT NULL,
    [Navn]        VARCHAR (30) NOT NULL,
    [TurDepot]    VARCHAR (30) NOT NULL,
    [Aktiv]       CHAR (1)     CONSTRAINT [DV_DI_Medarbejder_Togfører_FR_Aktiv] DEFAULT ('J') NOT NULL,
    [Tidsstempel] DATETIME     CONSTRAINT [DV_DI_Medarbejder_Togfører_FR] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_DI_Medarbejder_Togfører_FR] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [UK_DI_Medarbejder_Togfører_FR] UNIQUE NONCLUSTERED ([NetId] ASC, [TurDepot] ASC)
);

