CREATE TABLE [edw].[FT_OBSArbejder] (
    [DI_Medarbejder_Togfører_FR] INT          NOT NULL,
    [DI_Arbejdskode]             VARCHAR (15) NOT NULL,
    [DI_Tid]                     VARCHAR (50) NOT NULL,
    [TjenesteVarighed_tim]       FLOAT (53)   NOT NULL,
    CONSTRAINT [FK_DI_Medarbejder_Togfører_FR] FOREIGN KEY ([DI_Medarbejder_Togfører_FR]) REFERENCES [edw].[DI_Medarbejder_Togfører_FR] ([PK_ID]),
    CONSTRAINT [FK_FT_OMSArbejder_DI_Arbejdskode] FOREIGN KEY ([DI_Arbejdskode]) REFERENCES [edw].[DI_Arbejdskode] ([Kode]),
    CONSTRAINT [FK_FT_OMSArbejder_DI_Tid] FOREIGN KEY ([DI_Tid]) REFERENCES [edw].[DI_Tid] ([Reference])
);

