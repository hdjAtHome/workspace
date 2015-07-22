CREATE TABLE [edw].[FT_Lokopersonale_S_tog] (
    [DI_Tid]                 VARCHAR (50)    NOT NULL,
    [DI_S_Straekning]        INT             NOT NULL,
    [DI_Tidsinterval]        INT             NOT NULL,
    [DI_Medarbejder]         INT             NOT NULL,
    [DI_S_Opgave_Lokofører]  INT             NOT NULL,
    [DI_Depot]               INT             NOT NULL,
    [DI_S_Opgave_Straekning] INT             NOT NULL,
    [Tognr]                  INT             NOT NULL,
    [Opgave_Varighed_Timer]  DECIMAL (24, 6) NOT NULL,
    [DI_S_Doegn_Inddeling]   INT             NOT NULL,
    CONSTRAINT [FK_FT_Lokopersonale_S_tog_DI_Depot] FOREIGN KEY ([DI_Depot]) REFERENCES [edw].[DI_Depot] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokopersonale_S_tog_DI_Medarbejde] FOREIGN KEY ([DI_Medarbejder]) REFERENCES [edw].[DI_Medarbejde] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokopersonale_S_tog_DI_S_Doegn_Inddeling] FOREIGN KEY ([DI_S_Doegn_Inddeling]) REFERENCES [edw].[DI_S_Doegn_Inddeling] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokopersonale_S_tog_DI_S_Opgave_Lokofører] FOREIGN KEY ([DI_S_Opgave_Lokofører]) REFERENCES [edw].[DI_S_Opgave_Lokofører] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokopersonale_S_tog_DI_S_Opgave_Straekning] FOREIGN KEY ([DI_S_Opgave_Straekning]) REFERENCES [edw].[DI_S_Opgave_Straekning] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokopersonale_S_tog_DI_S_Straekning] FOREIGN KEY ([DI_S_Straekning]) REFERENCES [edw].[DI_S_Straekning] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokopersonale_S_tog_DI_Tid] FOREIGN KEY ([DI_Tid]) REFERENCES [edw].[DI_Tid] ([Reference])
);

