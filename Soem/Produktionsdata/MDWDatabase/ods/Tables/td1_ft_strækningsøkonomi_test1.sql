CREATE TABLE [ods].[td1_ft_strækningsøkonomi_test1] (
    [level0]         VARCHAR (256)  NULL,
    [R1Refnum]       VARCHAR (256)  NULL,
    [R2Refnum]       VARCHAR (20)   NULL,
    [A1Refnum]       VARCHAR (20)   NULL,
    [A2Refnum]       VARCHAR (20)   NULL,
    [A3Refnum]       VARCHAR (20)   NULL,
    [A4Refnum]       VARCHAR (20)   NULL,
    [artgrp]         VARCHAR (1)    NULL,
    [Co1Refnum]      VARCHAR (256)  NULL,
    [Periodrefnum]   NVARCHAR (256) NULL,
    [Scenariorefnum] VARCHAR (6)    NULL,
    [andel]          FLOAT (53)     NULL,
    [nextandel]      FLOAT (53)     NULL,
    [FixedCost]      FLOAT (53)     NULL,
    [Destcost]       FLOAT (53)     NULL,
    [Model]          VARCHAR (50)   NULL,
    [Model_Id]       INT            NULL
);


GO
CREATE NONCLUSTERED INDEX [r2refnum]
    ON [ods].[td1_ft_strækningsøkonomi_test1]([R2Refnum] ASC);


GO
CREATE NONCLUSTERED INDEX [r1refnum]
    ON [ods].[td1_ft_strækningsøkonomi_test1]([R1Refnum] ASC);


GO
CREATE NONCLUSTERED INDEX [a4refnum]
    ON [ods].[td1_ft_strækningsøkonomi_test1]([A4Refnum] ASC);


GO
CREATE NONCLUSTERED INDEX [a3refnum]
    ON [ods].[td1_ft_strækningsøkonomi_test1]([A3Refnum] ASC);


GO
CREATE NONCLUSTERED INDEX [a2refnum]
    ON [ods].[td1_ft_strækningsøkonomi_test1]([A2Refnum] ASC);


GO
CREATE NONCLUSTERED INDEX [a1refnum]
    ON [ods].[td1_ft_strækningsøkonomi_test1]([A1Refnum] ASC);


GO
CREATE CLUSTERED INDEX [co1refnum]
    ON [ods].[td1_ft_strækningsøkonomi_test1]([Co1Refnum] ASC);

