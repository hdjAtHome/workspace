CREATE TABLE [edw].[Dim_Ordre] (
    [Pk_key]             INT           NULL,
    [Ordre]              VARCHAR (255) NULL,
    [Ordrenavn]          VARCHAR (255) NULL,
    [oprettetTidspunkt]  DATETIME      DEFAULT (getdate()) NULL,
    [oprettetAf]         [sysname]     DEFAULT (suser_sname()) NOT NULL,
    [opdateretTidspunkt] DATETIME      NULL,
    [opdateretAf]        [sysname]     NULL
);


GO

create trigger [edw].[Dim_Ordre_updated] on [edw].[Dim_Ordre]
 AFTER  UPDATE
AS  UPDATE [edw].[Dim_Ordre]  SET opdateretTidspunkt = GETDATE(), opdateretAf = SUSER_SNAME() FROM inserted WHERE inserted.pk_key = [edw].[Dim_Ordre].pk_key