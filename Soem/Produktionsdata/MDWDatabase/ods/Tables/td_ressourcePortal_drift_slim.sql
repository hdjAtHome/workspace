CREATE TABLE [ods].[td_ressourcePortal_drift_slim] (
    [Omkostningssted_key] INT          NOT NULL,
    [art_hierarki_key]    INT          NOT NULL,
    [ordre_key]           INT          NOT NULL,
    [pspelement_key]      INT          NOT NULL,
    [profitcenter_key]    INT          NOT NULL,
    [ressource_key]       INT          NOT NULL,
    [Beloeb]              FLOAT (53)   NULL,
    [RessourceReference]  VARCHAR (50) NULL,
    [Artsgruppe_key]      INT          NOT NULL,
    [variabilitet_key]    INT          NOT NULL,
    [reversibilitet_key]  INT          NOT NULL,
    [Momsstatus]          INT          NOT NULL,
    [kilde_key]           INT          NULL
);

