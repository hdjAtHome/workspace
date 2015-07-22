CREATE TABLE [edw].[FT_PDS] (
    [DI_Medarbejder_Togfører_FR]          INT             NOT NULL,
    [DI_Tid]                              VARCHAR (50)    NOT NULL,
    [DI_Togsystem]                        INT             NOT NULL,
    [DI_Tidsintervaller]                  INT             NOT NULL,
    [DI_Turdepot]                         VARCHAR (5)     NOT NULL,
    [DI_Straekning]                       INT             NOT NULL,
    [DI_Opgave]                           INT             NOT NULL,
    [DI_Fravaerkode]                      VARCHAR (50)    NOT NULL,
    [DI_Arbejdskode]                      VARCHAR (15)    NOT NULL,
    [Opgave_varighed_timer]               DECIMAL (24, 6) NOT NULL,
    [Medarbejder_tjeneste_varighed_timer] DECIMAL (24, 6) NOT NULL,
    [fravaer_varighed_timer]              DECIMAL (24, 6) NOT NULL,
    CONSTRAINT [FK_FT_PDS_DI_Medarbejder_Togfører_FR] FOREIGN KEY ([DI_Medarbejder_Togfører_FR]) REFERENCES [edw].[DI_Medarbejder_Togfører_FR] ([PK_ID]),
    CONSTRAINT [FK_FT_PDS_DI_Opgave] FOREIGN KEY ([DI_Opgave]) REFERENCES [edw].[DI_Opgave] ([PK_ID]),
    CONSTRAINT [FK_FT_PDS_DI_Straekning] FOREIGN KEY ([DI_Straekning]) REFERENCES [edw].[DI_Straekning] ([PK_ID]),
    CONSTRAINT [FK_FT_PDS_DI_Tid] FOREIGN KEY ([DI_Tid]) REFERENCES [edw].[DI_Tid] ([Reference]),
    CONSTRAINT [FK_FT_PDS_DI_Tidsintervaller] FOREIGN KEY ([DI_Tidsintervaller]) REFERENCES [edw].[DI_Tidsintervaller] ([PK_ID]),
    CONSTRAINT [FK_FT_PDS_DI_Togsystem] FOREIGN KEY ([DI_Togsystem]) REFERENCES [edw].[DI_Togsystem] ([PK_DI_Togsystem])
);

