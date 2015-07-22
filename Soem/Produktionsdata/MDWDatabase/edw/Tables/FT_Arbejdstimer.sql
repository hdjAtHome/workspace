CREATE TABLE [edw].[FT_Arbejdstimer] (
    [DI_Medarbejde]   INT          NOT NULL,
    [DI_Tid_Maaned]   VARCHAR (6)  NOT NULL,
    [Loankodegrp]     INT          NOT NULL,
    [DI_Omksted]      INT          NOT NULL,
    [Loanart]         VARCHAR (10) NOT NULL,
    [Samko]           VARCHAR (10) NULL,
    [Arbejdstimer]    FLOAT (53)   NULL,
    [DI_Tjenestested] INT          NOT NULL,
    CONSTRAINT [FK_FT_Arbejdstimer_DI_Medarbejde] FOREIGN KEY ([DI_Medarbejde]) REFERENCES [edw].[DI_Medarbejde] ([MedarbejdeId]),
    CONSTRAINT [FK_FT_Arbejdstimer_DI_Omksted] FOREIGN KEY ([DI_Omksted]) REFERENCES [edw].[DI_Omksted] ([PK_ID]),
    CONSTRAINT [FK_FT_Arbejdstimer_DI_Tid_Maaned] FOREIGN KEY ([DI_Tid_Maaned]) REFERENCES [edw].[DI_Tid_Maaned] ([PK_ID]),
    CONSTRAINT [FK_FT_Arbejdstimer_DI_Tjenestested] FOREIGN KEY ([DI_Tjenestested]) REFERENCES [edw].[DI_Tjenestested] ([PK_ID])
);

