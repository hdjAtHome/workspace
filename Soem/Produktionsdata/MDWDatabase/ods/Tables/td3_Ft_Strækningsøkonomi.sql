CREATE TABLE [ods].[td3_Ft_Strækningsøkonomi] (
    [Model_id]                       INT         NULL,
    [Destcost]                       FLOAT (53)  NULL,
    [resource1_key]                  INT         NOT NULL,
    [resource2_key]                  INT         NOT NULL,
    [activity1_key]                  INT         NOT NULL,
    [activity2_key]                  INT         NOT NULL,
    [activity3_key]                  INT         NOT NULL,
    [activity4_key]                  INT         NOT NULL,
    [costobject1_key]                INT         NOT NULL,
    [attRessourcetype_key]           INT         NOT NULL,
    [attFunktionskunde_key]          INT         NOT NULL,
    [AttSegment_key]                 INT         NOT NULL,
    [AttProduktaktivitetsgruppe_key] INT         NOT NULL,
    [AttProduktVariabilitet_key]     INT         NOT NULL,
    [AttProduktLitra_key]            INT         NOT NULL,
    [AttTogsystem_key]               INT         NOT NULL,
    [CEArt]                          VARCHAR (1) NULL
);

