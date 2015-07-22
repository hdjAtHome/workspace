CREATE TABLE [dbo].[ABC_Template_Model] (
    [BaseCurrency] NVARCHAR (3) NOT NULL,
    CONSTRAINT [PK_Model_1] PRIMARY KEY CLUSTERED ([BaseCurrency] ASC) WITH (FILLFACTOR = 90)
);

