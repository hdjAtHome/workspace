CREATE TABLE [dbo].[MD_STYRING_Mail_Grupper] (
    [Gruppe_id]          VARCHAR (50)  NOT NULL,
    [Gruppe_Navn]        VARCHAR (50)  NOT NULL,
    [Gruppe_Beskirvelse] VARCHAR (100) NULL,
    CONSTRAINT [PK_MD_STYRING_Mail_Grupper] PRIMARY KEY CLUSTERED ([Gruppe_id] ASC) WITH (FILLFACTOR = 90)
);

