CREATE TABLE [edw].[DI_Litra] (
    [Kode]          VARCHAR (12) NOT NULL,
    [Navn]          VARCHAR (50) NULL,
    [MaterielTypel] VARCHAR (10) NULL,
    [Data_kilde]    VARCHAR (10) NULL,
    [Timestamp]     DATETIME     NULL,
    CONSTRAINT [PK_DI_Litra] PRIMARY KEY CLUSTERED ([Kode] ASC)
);

