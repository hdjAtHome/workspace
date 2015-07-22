CREATE TABLE [ods].[MD_Stog_finger_straekninger] (
    [Finger_ID]     INT          NOT NULL,
    [Straekning_ID] VARCHAR (5)  NOT NULL,
    [Navn]          VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_MD_Stog_finger_straekninger] PRIMARY KEY CLUSTERED ([Finger_ID] ASC)
);

