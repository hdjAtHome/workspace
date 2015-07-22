CREATE TABLE [edw].[MD_Klass_Litragr3_Litrahierarki] (
    [AntalMat] NUMERIC (10) NOT NULL,
    [Litragr3] VARCHAR (60) NOT NULL,
    [Litragr2] VARCHAR (15) NOT NULL,
    [Litragr1] VARCHAR (15) NOT NULL,
    CONSTRAINT [PK_Litragr3_Litrahierarki] PRIMARY KEY CLUSTERED ([Litragr3] ASC, [Litragr2] ASC) WITH (FILLFACTOR = 90)
);

