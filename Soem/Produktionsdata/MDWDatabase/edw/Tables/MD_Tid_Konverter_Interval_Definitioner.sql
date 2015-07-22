CREATE TABLE [edw].[MD_Tid_Konverter_Interval_Definitioner] (
    [Interval_header_id] INT          NOT NULL,
    [Dagugen]            VARCHAR (3)  NULL,
    [Dagugen_num]        INT          NULL,
    [Dagstype]           CHAR (1)     NULL,
    [Dagugen_tekst]      VARCHAR (20) NULL,
    [Time]               INT          NULL,
    [Tidsinterval]       CHAR (1)     NULL,
    [Tidsinterval_tekst] VARCHAR (10) NULL,
    [Prioritet]          INT          NULL
);

