CREATE TABLE [dbo].[CD_Data_Validering_Beskrivelse] (
    [Beskrivelses_Id] VARCHAR (2)    NOT NULL,
    [Beskrivelse]     VARCHAR (1000) NOT NULL,
    CONSTRAINT [PK_CD_Data_Validering_Beskrivelse] PRIMARY KEY CLUSTERED ([Beskrivelses_Id] ASC)
);

