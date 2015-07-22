CREATE TABLE [edw].[DI_S_Straekning] (
    [PK_ID]      INT          IDENTITY (1, 1) NOT NULL,
    [Finger_ID]  INT          NOT NULL,
    [Straekning] VARCHAR (5)  NOT NULL,
    [Navn]       VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_DI_S_Straekning] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [UK_DI_S_Straekning_Finger_id] UNIQUE NONCLUSTERED ([Finger_ID] ASC)
);

