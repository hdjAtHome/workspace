CREATE TABLE [dbo].[MD_STYRING_Mail_Lister] (
    [Gruppe_id] VARCHAR (50) NOT NULL,
    [Bruger_id] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_MD_STYRING_Mail_Lister] PRIMARY KEY CLUSTERED ([Gruppe_id] ASC, [Bruger_id] ASC),
    CONSTRAINT [FK_MD_STYRING_Mail_Lister_MD_STYRING_Mail_Brugere] FOREIGN KEY ([Bruger_id]) REFERENCES [dbo].[MD_STYRING_Mail_Brugere] ([Bruger_id]),
    CONSTRAINT [FK_MD_STYRING_Mail_Lister_MD_STYRING_Mail_Grupper] FOREIGN KEY ([Gruppe_id]) REFERENCES [dbo].[MD_STYRING_Mail_Grupper] ([Gruppe_id])
);

