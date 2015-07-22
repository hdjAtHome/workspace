CREATE TABLE [edw].[DI_Opgave] (
    [PK_ID]             INT           IDENTITY (-1, 1) NOT NULL,
    [OpgaveKode]        VARCHAR (30)  NOT NULL,
    [OpgaveNavn]        VARCHAR (50)  NULL,
    [OpgaveBeskrivelse] VARCHAR (500) NULL,
    [OpgaveGruppe]      VARCHAR (50)  NULL,
    [OpgaveGruppeNavn]  VARCHAR (50)  NULL,
    [OpgaveType]        VARCHAR (10)  NULL,
    [OpgaveTypeNavn]    VARCHAR (50)  NULL,
    [GyldigFradato]     DATETIME      NULL,
    [GyldigTildato]     DATETIME      NULL,
    [Aktiv]             CHAR (1)      NULL,
    [Timestamp]         DATETIME      NULL,
    CONSTRAINT [PK_DI_Opgave] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [UK_DI_Opgave_Kode] UNIQUE NONCLUSTERED ([OpgaveKode] ASC)
);

