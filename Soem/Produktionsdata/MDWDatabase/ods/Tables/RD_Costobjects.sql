CREATE TABLE [ods].[RD_Costobjects] (
    [Omraade]         VARCHAR (50)   NULL,
    [Reference]       VARCHAR (50)   NOT NULL,
    [Produkt]         VARCHAR (50)   NULL,
    [HFO]             VARCHAR (50)   NULL,
    [FO]              VARCHAR (50)   NULL,
    [Name]            VARCHAR (50)   NULL,
    [Momsbelastning]  FLOAT (53)     NULL,
    [Type]            VARCHAR (50)   NULL,
    [ParentReference] VARCHAR (50)   NULL,
    [Togsystem]       INT            NULL,
    [Kode]            VARCHAR (50)   NULL,
    [Beskrivelse]     VARCHAR (1000) NULL,
    [Udbudt]          VARCHAR (50)   NULL,
    [Kommentar]       VARCHAR (200)  NULL,
    [Aktiv]           VARCHAR (50)   NULL,
    [Markedsprisdok]  VARCHAR (50)   NULL,
    [Timestamp]       DATETIME       NULL,
    [Period]          VARCHAR (50)   NULL,
    CONSTRAINT [IX_RD_Costobjects_1] UNIQUE NONCLUSTERED ([Reference] ASC, [Aktiv] ASC)
);

