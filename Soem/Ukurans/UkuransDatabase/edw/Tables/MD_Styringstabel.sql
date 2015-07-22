CREATE TABLE [edw].[MD_Styringstabel] (
    [Parameter]      VARCHAR (20)  NOT NULL,
    [Parametertekst] VARCHAR (100) NOT NULL,
    [Vaerdi]         VARCHAR (50)  NULL,
    CONSTRAINT [PK_Styringstabel] PRIMARY KEY CLUSTERED ([Parameter] ASC) WITH (FILLFACTOR = 90)
);

