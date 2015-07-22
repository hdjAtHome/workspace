CREATE TABLE [ods].[MD_MatStatusGr2] (
    [Materiale] VARCHAR (18) NOT NULL,
    [StatusGr2] VARCHAR (20) NOT NULL,
    [GyldigFra] DATETIME     NOT NULL,
    [GyldigTil] DATETIME     NULL,
    CONSTRAINT [PK_MatStatusGr2] PRIMARY KEY CLUSTERED ([Materiale] ASC, [GyldigFra] ASC) WITH (FILLFACTOR = 90)
);

