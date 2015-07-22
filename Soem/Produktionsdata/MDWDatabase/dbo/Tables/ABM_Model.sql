CREATE TABLE [dbo].[ABM_Model] (
    [Delmodel]     NVARCHAR (64) NOT NULL,
    [BaseCurrency] NVARCHAR (3)  NOT NULL,
    CONSTRAINT [PK_Model] PRIMARY KEY CLUSTERED ([Delmodel] ASC, [BaseCurrency] ASC) WITH (FILLFACTOR = 90)
);

