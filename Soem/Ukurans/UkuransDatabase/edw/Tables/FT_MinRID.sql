CREATE TABLE [edw].[FT_MinRID] (
    [Materiale]      VARCHAR (18)    NULL,
    [Dim_Materiale]  INT             NULL,
    [Dim_Tid]        VARCHAR (8)     NOT NULL,
    [Beholdning]     DECIMAL (18, 3) NULL,
    [Forbrug_pr_dag] DECIMAL (18, 3) NULL,
    [Vaerdi_GP]      DECIMAL (18, 3) NULL,
    [MinRID]         DECIMAL (18, 6) NULL
);

