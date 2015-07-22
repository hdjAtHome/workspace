CREATE TABLE [ods].[MD_G_STAM_Timer_Grp_Lokoførertid] (
    [Kilde]            VARCHAR (50)  NULL,
    [Elementkode]      VARCHAR (50)  NULL,
    [ElementkodeNavn]  VARCHAR (50)  NULL,
    [Beskrivelse]      VARCHAR (300) NULL,
    [Gruppe]           VARCHAR (50)  NULL,
    [GruppeNavn]       VARCHAR (50)  NULL,
    [Type]             VARCHAR (50)  NULL,
    [TypeNavn]         VARCHAR (50)  NULL,
    [indlæstTidspunkt] DATETIME      DEFAULT (getdate()) NULL,
    [indlæstAf]        [sysname]     DEFAULT (suser_sname()) NULL
);

