CREATE TABLE [edw].[FT_OBSFravaer] (
    [DI_Medarbejder_Togfører_FR] INT          NOT NULL,
    [DI_Fravaerkode]             VARCHAR (10) NOT NULL,
    [DI_Tid]                     VARCHAR (50) NOT NULL,
    [Varighed_tim]               FLOAT (53)   NOT NULL,
    CONSTRAINT [FK_FT_OBSFravaer_DI_Fravaerkode] FOREIGN KEY ([DI_Fravaerkode]) REFERENCES [edw].[DI_Fravaerkode] ([Kode]),
    CONSTRAINT [FK_FT_OBSFravaer_DI_Medarbejder_Togfører_FR] FOREIGN KEY ([DI_Medarbejder_Togfører_FR]) REFERENCES [edw].[DI_Medarbejder_Togfører_FR] ([PK_ID]),
    CONSTRAINT [FK_FT_OBSFravaer_DI_Tid] FOREIGN KEY ([DI_Tid]) REFERENCES [edw].[DI_Tid] ([Reference])
);

