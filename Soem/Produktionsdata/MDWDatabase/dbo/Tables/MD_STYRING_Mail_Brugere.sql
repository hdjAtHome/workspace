CREATE TABLE [dbo].[MD_STYRING_Mail_Brugere] (
    [Bruger_id] VARCHAR (50) NOT NULL,
    [Navn]      VARCHAR (50) NOT NULL,
    [Mail]      VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_MD_STYRING_Mail_Brugere] PRIMARY KEY CLUSTERED ([Bruger_id] ASC) WITH (FILLFACTOR = 90)
);

