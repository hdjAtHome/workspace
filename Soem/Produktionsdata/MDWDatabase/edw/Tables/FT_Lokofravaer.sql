CREATE TABLE [edw].[FT_Lokofravaer] (
    [DI_Omksted]     INT          NOT NULL,
    [DI_Turdepot]    VARCHAR (5)  NOT NULL,
    [DI_Fravaerkode] VARCHAR (10) NOT NULL,
    [Fravaertimer]   FLOAT (53)   NOT NULL,
    [DI_Tid_Maaned]  VARCHAR (6)  NOT NULL,
    [Turdag]         VARCHAR (15) NULL,
    [Turnummer]      VARCHAR (15) NULL,
    CONSTRAINT [FK_FT_Lokofravaer_DI_Fravaerkode] FOREIGN KEY ([DI_Fravaerkode]) REFERENCES [edw].[DI_Fravaerkode] ([Kode]),
    CONSTRAINT [FK_FT_Lokofravaer_DI_Omksted] FOREIGN KEY ([DI_Omksted]) REFERENCES [edw].[DI_Omksted] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokofravaer_DI_Tid_Maaned] FOREIGN KEY ([DI_Tid_Maaned]) REFERENCES [edw].[DI_Tid_Maaned] ([PK_ID]),
    CONSTRAINT [FK_FT_Lokofravaer_DI_Turdepot] FOREIGN KEY ([DI_Turdepot]) REFERENCES [edw].[DI_Turdepot] ([Turdepot])
);

