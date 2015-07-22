CREATE TABLE [ods].[td_ressourcePortal_anlaeg_slim] (
    [Omkostningssted_key] INT          NOT NULL,
    [art_hierarki_key]    INT          NOT NULL,
    [ordre_key]           INT          NOT NULL,
    [pspelement_key]      INT          NOT NULL,
    [profitcenter_key]    INT          NOT NULL,
    [ressource_key]       INT          NOT NULL,
    [afskrivning]         FLOAT (53)   NULL,
    [forrentning]         FLOAT (53)   NULL,
    [RessourceReference]  VARCHAR (50) NULL,
    [kilde_key]           INT          NULL
);

