CREATE TABLE [edw].[DI_Togsystem] (
    [PK_DI_Togsystem]    INT           IDENTITY (1, 1) NOT NULL,
    [Togsystemnummer]    INT           NOT NULL,
    [Togsystemnavn]      VARCHAR (50)  NOT NULL,
    [IC_Straekning]      VARCHAR (50)  NOT NULL,
    [Gl_togsystemnummer] INT           NOT NULL,
    [Kontraktoperatoer]  VARCHAR (50)  NULL,
    [Produkt]            VARCHAR (50)  NOT NULL,
    [POEM_CZ-ref]        VARCHAR (50)  NOT NULL,
    [POEM_CX-ref]        VARCHAR (50)  NOT NULL,
    [Kommentar]          VARCHAR (255) NULL,
    [Aktiv]              BIT           NOT NULL,
    [AktivFra]           DATETIME      NOT NULL,
    [AktivTil]           DATETIME      NOT NULL,
    CONSTRAINT [PK_DI_Togsystem_2] PRIMARY KEY CLUSTERED ([PK_DI_Togsystem] ASC)
);

