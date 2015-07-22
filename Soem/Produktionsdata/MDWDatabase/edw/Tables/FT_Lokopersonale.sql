CREATE TABLE [edw].[FT_Lokopersonale] (
    [DI_Omksted]     INT          NOT NULL,
    [DI_Turdepot]    VARCHAR (5)  NOT NULL,
    [DI_Elementkode] VARCHAR (10) NOT NULL,
    [DI_Togsystem]   INT          NOT NULL,
    [DI_Lokation]    VARCHAR (10) NOT NULL,
    [DI_Litra]       VARCHAR (12) NULL,
    [Tognummer]      VARCHAR (6)  NULL,
    [Turtimer]       FLOAT (53)   NULL,
    [Turdag]         VARCHAR (15) NULL,
    [Praktik]        VARCHAR (3)  NULL,
    [Antaltur]       INT          NULL,
    [Turnummer]      VARCHAR (15) NULL,
    [DI_Tid_Maaned]  VARCHAR (6)  NOT NULL,
    CONSTRAINT [FK_FT_Lokopersonale_DI_Elementkode_ltf] FOREIGN KEY ([DI_Elementkode]) REFERENCES [edw].[DI_Elementkode_ltf] ([Elementkode]),
    CONSTRAINT [FK_FT_Lokopersonale_DI_Litra] FOREIGN KEY ([DI_Litra]) REFERENCES [edw].[DI_Litra] ([Kode]),
    CONSTRAINT [FK_FT_Lokopersonale_DI_Lokation] FOREIGN KEY ([DI_Lokation]) REFERENCES [edw].[DI_Lokation] ([Kode]),
    CONSTRAINT [FK_FT_Lokopersonale_DI_Omksted] FOREIGN KEY ([DI_Omksted]) REFERENCES [edw].[DI_Omksted] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokopersonale_DI_Tid_Maaned] FOREIGN KEY ([DI_Tid_Maaned]) REFERENCES [edw].[DI_Tid_Maaned] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokopersonale_DI_Togsystem] FOREIGN KEY ([DI_Togsystem]) REFERENCES [edw].[DI_Togsystem] ([PK_DI_Togsystem]),
    CONSTRAINT [FK_FT_Lokopersonale_DI_Turdepot] FOREIGN KEY ([DI_Turdepot]) REFERENCES [edw].[DI_Turdepot] ([Turdepot])
);

