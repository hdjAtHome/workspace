CREATE TABLE [edw].[Dim_Aendring] (
    [Order_Num]   INT           NULL,
    [Kode]        VARCHAR (20)  NOT NULL,
    [KortNavn]    VARCHAR (20)  NULL,
    [Beskrivelse] VARCHAR (100) NULL,
    CONSTRAINT [PK_Dim_Aendring_Kode] PRIMARY KEY CLUSTERED ([Kode] ASC)
);

