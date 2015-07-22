CREATE TABLE [dbo].[ABC_Template_Dimension] (
    [Dimension]      NVARCHAR (50) NOT NULL,
    [SequenceNumber] SMALLINT      NULL,
    CONSTRAINT [PK_ABC_Dimension] PRIMARY KEY CLUSTERED ([Dimension] ASC) WITH (FILLFACTOR = 90)
);

